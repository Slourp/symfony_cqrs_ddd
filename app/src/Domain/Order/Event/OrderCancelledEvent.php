<?php

declare(strict_types=1);

namespace App\Domain\Order\Event;


class OrderCancelledEvent
{
	public function __toString()
	{
		echo OrderCancelledEvent::class;
	}
}
