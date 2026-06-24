function fibonacci(n: number): number {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

function matrixMultiply(n: number): void {
  const a: number[][] = [];
  const b: number[][] = [];
  const c: number[][] = [];
  for (let i = 0; i < n; i++) {
    a[i] = new Array(n);
    b[i] = new Array(n);
    c[i] = new Array(n);
    for (let j = 0; j < n; j++) {
      a[i][j] = (i + j) * 0.1;
      b[i][j] = (i - j) * 0.1;
    }
  }
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      let sum = 0;
      for (let k = 0; k < n; k++) {
        sum += a[i][k] * b[k][j];
      }
      c[i][j] = sum;
    }
  }
}

function primeCount(limit: number): number {
  const sieve = new Uint8Array(limit + 1);
  let count = 0;
  for (let i = 2; i <= limit; i++) {
    if (!sieve[i]) {
      count++;
      for (let j = i * 2; j <= limit; j += i) {
        sieve[j] = 1;
      }
    }
  }
  return count;
}

console.log("=== BunJS Benchmark ===");

let start = performance.now();
const fibResult = fibonacci(42);
console.log(`fibonacci(42) = ${fibResult}, time: ${(performance.now() - start).toFixed(2)}ms`);

start = performance.now();
matrixMultiply(500);
console.log(`matrix_multiply(500x500), time: ${(performance.now() - start).toFixed(2)}ms`);

start = performance.now();
const primeCountResult = primeCount(10_000_000);
console.log(`prime_count(10M) = ${primeCountResult}, time: ${(performance.now() - start).toFixed(2)}ms`);
