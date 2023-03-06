<?php

declare(strict_types=1);

namespace App\Domain\Order\Exception;

class OrderNotFoundException
{
	public function __toString()
	{
		echo OrderNotFoundException::class;
	}
}
