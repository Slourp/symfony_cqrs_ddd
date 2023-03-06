<?php

declare(strict_types=1);

namespace App\Domain\Order\Event;


class OrderPaidEvent
{
	public function __toString()
	{
		echo OrderPaidEvent::class;
	}
}
