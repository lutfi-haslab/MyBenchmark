fn fibonacci(n: u64) -> u64 {
    if n <= 1 {
        return n;
    }
    fibonacci(n - 1) + fibonacci(n - 2)
}

fn matrix_multiply(n: usize) {
    let mut a = vec![vec![0.0f64; n]; n];
    let mut b = vec![vec![0.0f64; n]; n];
    let mut c = vec![vec![0.0f64; n]; n];
    for i in 0..n {
        for j in 0..n {
            a[i][j] = ((i + j) as f64) * 0.1;
            b[i][j] = ((i as isize - j as isize) as f64) * 0.1;
        }
    }
    for i in 0..n {
        for j in 0..n {
            let mut sum = 0.0f64;
            for k in 0..n {
                sum += a[i][k] * b[k][j];
            }
            c[i][j] = sum;
        }
    }
    std::hint::black_box(c[0][0]);
}

fn prime_count(limit: usize) -> usize {
    let mut sieve = vec![false; limit + 1];
    let mut count = 0usize;
    for i in 2..=limit {
        if !sieve[i] {
            count += 1;
            let mut j = i * 2;
            while j <= limit {
                sieve[j] = true;
                j += i;
            }
        }
    }
    count
}

fn main() {
    use std::time::Instant;

    println!("=== Rust Benchmark ===");

    let start = Instant::now();
    let result = fibonacci(42);
    println!("fibonacci(42) = {}, time: {:?}", result, start.elapsed());

    let start = Instant::now();
    matrix_multiply(500);
    println!("matrix_multiply(500x500), time: {:?}", start.elapsed());

    let start = Instant::now();
    let count = prime_count(10_000_000);
    println!("prime_count(10M) = {}, time: {:?}", count, start.elapsed());
}
