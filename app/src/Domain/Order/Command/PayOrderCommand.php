<?php

declare(strict_types=1);

namespace App\Domain\Order\Command;

class PayOrderCommand
{
	public function __toString()
	{
		echo PayOrderCommand::class;
	}
}