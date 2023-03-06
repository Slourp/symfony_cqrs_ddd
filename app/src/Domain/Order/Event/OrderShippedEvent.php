<?php

declare(strict_types=1);

namespace App\Domain\Order\Event;


class OrderShippedEvent
{
	public function __toString()
	{
		echo OrderShippedEvent::class;
	}
}
