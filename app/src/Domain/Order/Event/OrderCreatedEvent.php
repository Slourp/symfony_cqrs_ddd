<?php

declare(strict_types=1);

namespace App\Domain\Order\Event;


class OrderCreatedEvent
{
	public function __toString()
	{
		echo OrderCreatedEvent::class;
	}
}
