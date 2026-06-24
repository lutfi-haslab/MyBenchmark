package main

import (
	"fmt"
	"time"
)

func fibonacci(n int) int {
	if n <= 1 {
		return n
	}
	return fibonacci(n-1) + fibonacci(n-2)
}

func matrixMultiply(n int) {
	a := make([][]float64, n)
	b := make([][]float64, n)
	c := make([][]float64, n)
	for i := 0; i < n; i++ {
		a[i] = make([]float64, n)
		b[i] = make([]float64, n)
		c[i] = make([]float64, n)
		for j := 0; j < n; j++ {
			a[i][j] = float64(i+j) * 0.1
			b[i][j] = float64(i-j) * 0.1
		}
	}
	for i := 0; i < n; i++ {
		for j := 0; j < n; j++ {
			var sum float64
			for k := 0; k < n; k++ {
				sum += a[i][k] * b[k][j]
			}
			c[i][j] = sum
		}
	}
	_ = c[0][0]
}

func primeCount(limit int) int {
	sieve := make([]bool, limit+1)
	count := 0
	for i := 2; i <= limit; i++ {
		if !sieve[i] {
			count++
			for j := i * 2; j <= limit; j += i {
				sieve[j] = true
			}
		}
	}
	return count
}

func main() {
	fmt.Println("=== Go Benchmark ===")

	start := time.Now()
	result := fibonacci(42)
	elapsed := time.Since(start)
	fmt.Printf("fibonacci(42) = %d, time: %v\n", result, elapsed)

	start = time.Now()
	matrixMultiply(500)
	elapsed = time.Since(start)
	fmt.Printf("matrix_multiply(500x500), time: %v\n", elapsed)

	start = time.Now()
	count := primeCount(10_000_000)
	elapsed = time.Since(start)
	fmt.Printf("prime_count(10M) = %d, time: %v\n", count, elapsed)
}
