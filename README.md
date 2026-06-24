# MyBenchmark

Multi-language performance benchmark comparing **Go**, **Rust**, **Zig**, **BunJS**, and **PHP**.

## Benchmarks

| Benchmark | Description |
|---|---|
| **Fibonacci(42)** | Recursive CPU-bound computation |
| **Matrix Multiply (500x500)** | O(n³) computation with memory access patterns |
| **Prime Count (10M)** | Sieve of Eratosthenes up to 10,000,000 |

## Results

**Environment:** macOS Darwin arm64 (Apple MacBook Air M3)

| Language | Version | Fibonacci(42) | Matrix Multiply (500x500) | Prime Count (10M) |
|---|---|---|---|---|
| **Zig** | 0.16.0 | 1,223ms | 63ms | 24ms |
| **Rust** | 1.84.1 | 1,266ms | 193ms | 45ms |
| **Go** | 1.24.0 | 1,338ms | 239ms | 39ms |
| **BunJS** | 1.3.11 | 1,857ms | 431ms | 55ms |
| **PHP** | 8.4.7 | 32,929ms | 4,729ms | 1,304ms |

> Lower is better. Results may vary between runs.

## Run

```bash
./run.sh
```

The script auto-detects installed languages and runs available benchmarks. Results are saved to `results/`.

## Run Individual Benchmarks

```bash
# Go
cd go && go run main.go

# Rust (release mode)
cd rust && cargo run --release

# Zig (release safe)
cd zig && zig run src/main.zig -O ReleaseSafe

# BunJS
cd bun && bun run index.ts

# PHP
cd php && php bench.php
```

## Project Structure

```
.
├── run.sh              # Run all benchmarks
├── go/
│   ├── go.mod
│   └── main.go
├── rust/
│   ├── Cargo.toml
│   └── src/main.rs
├── zig/
│   └── src/main.zig
├── bun/
│   └── index.ts
├── php/
│   └── bench.php
└── results/
    └── *.txt           # Saved benchmark results
```
