<?php

declare(strict_types=1);

namespace App\Domain\Order\Event;

class OrderUpdatedEvent
{
	public function __toString()
	{
		echo OrderUpdatedEvent::class;
	}
}
