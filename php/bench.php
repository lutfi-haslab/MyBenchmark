<?php

ini_set('memory_limit', '512M');

function fibonacci(int $n): int {
    if ($n <= 1) return $n;
    return fibonacci($n - 1) + fibonacci($n - 2);
}

function matrixMultiply(int $n): void {
    $a = [];
    $b = [];
    $c = [];
    for ($i = 0; $i < $n; $i++) {
        for ($j = 0; $j < $n; $j++) {
            $a[$i][$j] = ($i + $j) * 0.1;
            $b[$i][$j] = ($i - $j) * 0.1;
            $c[$i][$j] = 0.0;
        }
    }
    for ($i = 0; $i < $n; $i++) {
        for ($j = 0; $j < $n; $j++) {
            $sum = 0.0;
            for ($k = 0; $k < $n; $k++) {
                $sum += $a[$i][$k] * $b[$k][$j];
            }
            $c[$i][$j] = $sum;
        }
    }
}

function primeCount(int $limit): int {
    $sieve = array_fill(0, $limit + 1, false);
    $count = 0;
    for ($i = 2; $i <= $limit; $i++) {
        if (!$sieve[$i]) {
            $count++;
            for ($j = $i * 2; $j <= $limit; $j += $i) {
                $sieve[$j] = true;
            }
        }
    }
    return $count;
}

echo "=== PHP Benchmark ===\n";

$start = hrtime(true);
$result = fibonacci(42);
$elapsed = hrtime(true) - $start;
printf("fibonacci(42) = %d, time: %.2fms\n", $result, $elapsed / 1_000_000);

$start = hrtime(true);
matrixMultiply(500);
$elapsed = hrtime(true) - $start;
printf("matrix_multiply(500x500), time: %.2fms\n", $elapsed / 1_000_000);

$start = hrtime(true);
$count = primeCount(10_000_000);
$elapsed = hrtime(true) - $start;
printf("prime_count(10M) = %d, time: %.2fms\n", $count, $elapsed / 1_000_000);
