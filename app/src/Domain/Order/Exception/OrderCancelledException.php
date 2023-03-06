<?php

declare(strict_types=1);

namespace App\Domain\Order\Exception;

class OrderCancelledException
{
	public function __toString()
	{
		echo OrderCancelledException::class;
	}
}
