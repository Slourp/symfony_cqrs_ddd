<?php

declare(strict_types=1);

namespace App\Domain\Order\Model;

/**
 * This class represents the repository for the Order domain.
 * It is responsible for storing and retrieving domain events
 * related to orders, using the principles of Event Sourcing.
 *
 * In this example, the OrderRepository class is simply an
 * empty class that prints its own name when converted to a string.
 */
class OrderRepository
{
	/**
	 * Returns a string representation of this class.
	 *
	 * @return string
	 */
	public function __toString(): string
	{
		return OrderRepository::class;
	}
}
