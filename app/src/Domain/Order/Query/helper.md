# Exemple 1 d'utilisation de Queries pour la génération de rapports

Supposons que vous développiez une application de commerce électronique, où les utilisateurs peuvent acheter des produits en ligne. Vous pouvez utiliser des Queries pour récupérer les données sur les ventes de produits, telles que les ventes totales pour une période donnée, les ventes par produit, les ventes par catégorie, etc. 

Ces données peuvent être utilisées pour générer des rapports pour les gestionnaires, les analystes ou les investisseurs.

Par exemple, vous pouvez définir une Query pour récupérer les données de vente par catégorie de produit pour une période donnée. 
Cette Query peut être utilisée pour générer un rapport de ventes pour chaque catégorie de produit, avec des graphiques et des tableaux pour représenter les données de manière visuelle.


```php
<?php

declare(strict_types=1);

namespace App\Application\Order\Query;

use App\Domain\Order\Event\OrderCreatedEvent;
use App\Domain\Order\Model\Order;
use App\Domain\Order\Model\OrderLine;
use App\Infrastructure\EventStore\EventStoreInterface;

class OrderSalesByCategoryQuery
{
    private EventStoreInterface $eventStore;

    public function __construct(EventStoreInterface $eventStore)
    {
        $this->eventStore = $eventStore;
    }

    public function execute(\DateTimeImmutable $fromDate, \DateTimeImmutable $toDate): array
    {
        $orderEvents = $this->eventStore->getEventsByType(OrderCreatedEvent::class, $fromDate, $toDate);

        $orders = array_reduce($orderEvents, function (array $acc, OrderCreatedEvent $orderEvent) {
            $order = Order::reconstituteFromEvents([$orderEvent]);

            $orderLines = $order->getOrderLines();

            $categories = array_reduce($orderLines, function (array $acc, OrderLine $orderLine) {
                $category = $orderLine->getProduct()->getCategory();
                $categoryId = $category->getId();

                $acc[$categoryId]['category'] = $category;
                $acc[$categoryId]['quantity'] = ($acc[$categoryId]['quantity'] ?? 0) + $orderLine->getQuantity();
                $acc[$categoryId]['totalAmount'] = ($acc[$categoryId]['totalAmount'] ?? 0) + $orderLine->getTotalAmount();

                return $acc;
            }, []);

            return array_replace_recursive($acc, $categories);
        }, []);
        usort($orders, fn ($a, $b)=>  $a['totalAmount'] < $b['totalAmount']);
        return $orders;
    }
}

```
Dans cet exemple, la Query OrderSalesByCategoryQuery récupère les données de vente par catégorie de produit à partir du magasin d'événements, en filtrant les événements de commande créée pour une période donnée. La Query utilise la méthode getEventsByType de l'interface EventStoreInterface pour récupérer les événements de domaine pertinents à partir du magasin d'événements. La Query reconstitue ensuite chaque commande à partir des événements de domaine, afin d'obtenir les informations nécessaires sur les produits et les quantités vendues. Les résultats sont ensuite triés par ordre décroissant du chiffre d'affaires total, afin de faciliter la lecture et l'analyse des données.

# Exemple 2  d'utilisation de Queries pour effectuer des requêtes complexes ou des agrégations sur les données de domaine


Supposons que vous développiez une application de gestion de stock pour une entreprise de vente en gros, où les utilisateurs peuvent suivre les niveaux de stock de leurs produits. Vous pouvez utiliser des Queries pour récupérer les données sur les niveaux de stock actuels, ainsi que des données historiques sur les niveaux de stock pour une période donnée. Vous pouvez également utiliser des Queries pour effectuer des agrégations sur les données de stock, telles que la quantité totale de stock pour une catégorie donnée de produits.

Par exemple, vous pouvez définir une Query pour récupérer les données de stock pour un produit donné, en prenant en compte les mouvements d'entrée et de sortie de stock. Cette Query peut être utilisée pour afficher les niveaux de stock actuels, ainsi que l'historique des niveaux de stock pour une période donnée.

```php
<?php

declare(strict_types=1);

namespace App\Application\Product\Query;

use App\Domain\Product\Event\ProductInventoryChangedEvent;
use App\Domain\Product\Model\Product;
use App\Infrastructure\EventStore\EventStoreInterface;

class ProductStockQuery
{
    private EventStoreInterface $eventStore;

    public function __construct(EventStoreInterface $eventStore)
    {
        $this->eventStore = $eventStore;
    }

    public function execute(string $productId): array
    {
        $productEvents = $this->eventStore->getEventsByAggregateId(Product::class, $productId);

        $inventory = 0;
        $history = [];

        foreach ($productEvents as $event) {
            if ($event instanceof ProductInventoryChangedEvent) {
                $inventory += $event->getQuantity();
                $history[] = [
                    'timestamp' => $event->getTimestamp(),
                    'quantity' => $event->getQuantity(),
                    'type' => $event->getType(),
                ];
            }
        }

        return [
            'inventory' => $inventory,
            'history' => $history,
        ];
    }
}

```
Dans cet exemple, la Query ProductStockQuery récupère les données de stock pour un produit donné à partir du magasin d'événements, en filtrant les événements de changement d'inventaire pour le produit. La Query utilise la méthode getEventsByAggregateId de l'interface EventStoreInterface pour récupérer les événements de domaine pertinents à partir du magasin d'événements. La Query calcule ensuite les niveaux de stock actuels en prenant en compte les mouvements d'entrée et de sortie de stock. Les résultats sont ensuite retournés sous forme d'un tableau, contenant à la fois les niveaux de stock actuels et l'historique des niveaux de stock pour le produit donné.

# Exemple 3 d'utilisation de Queries pour l'intégration avec d'autres applications ou services externes

Supposons que vous développiez une application de suivi de la santé pour les utilisateurs, où les utilisateurs peuvent suivre leur poids, leur fréquence cardiaque, leur sommeil, etc. Vous pouvez utiliser des Queries pour récupérer les données sur la santé des utilisateurs, qui peuvent ensuite être intégrées avec d'autres applications ou services externes, tels que les applications de fitness ou les services de télémédecine. Ces données peuvent également être utilisées pour personnaliser l'expérience utilisateur en fonction des préférences de l'utilisateur.

Par exemple, vous pouvez définir une Query pour récupérer les données de poids d'un utilisateur donné à partir d'un service externe tel que Google Fit. Cette Query peut être utilisée pour récupérer les données de poids de l'utilisateur, qui peuvent ensuite être intégrées avec l'application de suivi de la santé. Les données peuvent également être utilisées pour personnaliser l'expérience utilisateur en fonction des préférences de l'utilisateur, telles que la définition d'objectifs de perte de poids ou la recommandation d'exercices spécifiques.

```php
<?php

declare(strict_types=1);

namespace App\Application\User\Query;

use App\Infrastructure\FitnessApi\FitnessApiInterface;

class UserWeightQuery
{
    private FitnessApiInterface $fitnessApi;

    public function __construct(FitnessApiInterface $fitnessApi)
    {
        $this->fitnessApi = $fitnessApi;
    }

    public function execute(string $userId): float
    {
        $weight = $this->fitnessApi->getUserWeight($userId);

        return $weight;
    }
}

```

# Cas pratique

```
Supposons que nous avons une entité de domaine Order qui peut être créée, mise à jour et annulée. Lorsqu'un utilisateur crée une nouvelle commande, une Command CreateOrderCommand est créée et envoyée à un Command Handler. Le Command Handler utilise un Repository pour enregistrer la nouvelle commande sous forme d'un événement OrderCreatedEvent.

Lorsqu'un utilisateur souhaite consulter l'historique des commandes, une Query GetOrdersQuery est créée et envoyée à un Query Handler. Le Query Handler utilise un Repository pour récupérer les événements OrderCreatedEvent, OrderUpdatedEvent et OrderCancelledEvent correspondant à l'historique des commandes, en les filtrant en fonction de la date de création, de la date de mise à jour ou de la date d'annulation de la commande.

Voici un exemple de Command, Command Handler et Repository pour la création d'une commande :
```

```php
<?php

declare(strict_types=1);

namespace App\Domain\Order\Command;

class CreateOrderCommand
{
    private string $orderId;

    private string $customerId;

    private array $items;

    public function __construct(string $orderId, string $customerId, array $items)
    {
        $this->orderId = $orderId;
        $this->customerId = $customerId;
        $this->items = $items;
    }

    public function getOrderId(): string
    {
        return $this->orderId;
    }

    public function getCustomerId(): string
    {
        return $this->customerId;
    }

    public function getItems(): array
    {
        return $this->items;
    }
}

```
```php
<?php

declare(strict_types=1);

namespace App\Application\Order\Command;

use App\Domain\Order\Command\CreateOrderCommand;
use App\Domain\Order\Event\OrderCreatedEvent;
use App\Domain\Order\Model\OrderRepository;

class CreateOrderCommandHandler
{
    private OrderRepository $orderRepository;

    public function __construct(OrderRepository $orderRepository)
    {
        $this->orderRepository = $orderRepository;
    }

    public function __invoke(CreateOrderCommand $command): void
    {
        $order = new Order($command->getOrderId(), $command->getCustomerId(), $command->getItems());

        $orderCreatedEvent = new OrderCreatedEvent(
            $command->getOrderId(),
            $command->getCustomerId(),
            $command->getItems()
        );

        $this->orderRepository->store($orderCreatedEvent);
    }
}

```

```php
<?php

declare(strict_types=1);

namespace App\Domain\Order\Model;

use App\Domain\Order\Event\OrderCreatedEvent;
use App\Infrastructure\EventStore\EventStoreInterface;

class OrderRepository
{
    private EventStoreInterface $eventStore;

    public function __construct(EventStoreInterface $eventStore)
    {
        $this->eventStore = $eventStore;
    }

    public function store(OrderCreatedEvent $event): void
    {
        $this->eventStore->storeEvent($event);
    }
}

```

Dans cet exemple, le Command CreateOrderCommand contient l'identifiant de commande, l'identifiant du client et la liste des articles de la commande. Le Command Handler CreateOrderCommandHandler crée une nouvelle entité Order à partir des informations du Command, crée un nouvel événement OrderCreatedEvent correspondant, puis enregistre l'événement en utilisant le Repository OrderRepository.

Notez que le Repository utilise l'interface EventStoreInterface pour stocker et récupérer des événements

## Code client 

### Pour enrengistrer une commande
```php
<?php

declare(strict_types=1);

namespace App\Application\Order\Controller;

use App\Application\Order\Command\CreateOrderCommand;
use App\Application\Order\Command\CreateOrderCommandHandler;
use App\Domain\Order\Model\OrderRepository;
use App\Infrastructure\EventStore\EventStore;

class OrderController
{
    private CreateOrderCommandHandler $createOrderCommandHandler;

    public function __construct(OrderRepository $orderRepository)
    {
        $eventStore = new EventStore();
        $this->createOrderCommandHandler = new CreateOrderCommandHandler($orderRepository);
    }

    public function createOrder(string $orderId, string $customerId, array $items): void
    {
        $command = new CreateOrderCommand($orderId, $customerId, $items);

        $this->createOrderCommandHandler->__invoke($command);
    }
}
```


### Pour récupérer une commande 

```php
<?php

declare(strict_types=1);

namespace App\Application\Order\Controller;

use App\Application\Order\Query\GetOrdersQuery;
use App\Application\Order\Query\GetOrdersQueryHandler;
use App\Domain\Order\Model\Order;
use App\Domain\Order\Model\OrderRepository;
use App\Infrastructure\EventStore\EventStore;

class OrderController
{
    private GetOrdersQueryHandler $getOrdersQueryHandler;

    public function __construct(OrderRepository $orderRepository)
    {
        $eventStore = new EventStore();
        $this->getOrdersQueryHandler = new GetOrdersQueryHandler($orderRepository);
    }

    public function getOrders(string $customerId): array
    {
        $query = new GetOrdersQuery($customerId);

        $orders = $this->getOrdersQueryHandler->__invoke($query);

        return array_map(fn (Order $order) => $order->toArray(), $orders);
    }
}

```