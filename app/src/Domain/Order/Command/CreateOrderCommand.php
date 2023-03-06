<?php

declare(strict_types=1);

namespace App\Domain\Order\Command;

class CreateOrderCommand
{
	public function __toString()
	{
		echo CreateOrderCommand::class;
	}
}
