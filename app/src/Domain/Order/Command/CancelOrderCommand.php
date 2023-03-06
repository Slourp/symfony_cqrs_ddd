<?php

declare(strict_types=1);

namespace App\Domain\Order\Command;

class CancelOrderCommand
{
	public function __toString()
	{
		echo CancelOrderCommand::class;
	}
}
