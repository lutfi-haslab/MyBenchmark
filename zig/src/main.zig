const std = @import("std");

extern fn clock_gettime(clk_id: std.c.clockid_t, tp: *std.posix.timespec) c_int;

fn nowNs() i64 {
    var ts: std.posix.timespec = undefined;
    _ = clock_gettime(@enumFromInt(0), &ts);
    return @as(i64, ts.sec) * 1_000_000_000 + ts.nsec;
}

fn fibonacci(n: u64) u64 {
    if (n < 2) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

fn matrixMultiply(allocator: std.mem.Allocator, n: usize) void {
    const total = n * n;

    const a = allocator.alloc(f64, total) catch unreachable;
    defer allocator.free(a);

    const b = allocator.alloc(f64, total) catch unreachable;
    defer allocator.free(b);

    const c = allocator.alloc(f64, total) catch unreachable;
    defer allocator.free(c);

    @memset(c, 0);

    for (0..n) |i| {
        for (0..n) |j| {
            a[i * n + j] =
                @as(f64, @floatFromInt(i + j)) * 0.1;

            b[i * n + j] =
                @as(f64, @floatFromInt(i)) * 0.1 -
                @as(f64, @floatFromInt(j)) * 0.1;
        }
    }

    // cache-friendly i-k-j ordering
    for (0..n) |i| {
        const row_c = i * n;

        for (0..n) |k| {
            const aik = a[row_c + k];
            const row_b = k * n;

            for (0..n) |j| {
                c[row_c + j] += aik * b[row_b + j];
            }
        }
    }

    std.mem.doNotOptimizeAway(c[0]);
}

fn primeCount(allocator: std.mem.Allocator, limit: usize) usize {
    var sieve = allocator.alloc(bool, limit + 1) catch unreachable;
    defer allocator.free(sieve);

    @memset(sieve, false);

    var p: usize = 2;

    while (p * p <= limit) : (p += 1) {
        if (!sieve[p]) {
            var multiple = p * p;

            while (multiple <= limit) : (multiple += p) {
                sieve[multiple] = true;
            }
        }
    }

    var count: usize = 0;

    var i: usize = 2;
    while (i <= limit) : (i += 1) {
        if (!sieve[i]) {
            count += 1;
        }
    }

    return count;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    std.debug.print("=== Zig Optimized Benchmark ===\n", .{});

    const fib_start = nowNs();
    const fib_result = fibonacci(42);
    const fib_elapsed =
        @divTrunc(nowNs() - fib_start, 1_000_000);

    std.debug.print(
        "fibonacci(42) = {}, time: {}ms\n",
        .{ fib_result, fib_elapsed },
    );

    const mat_start = nowNs();

    matrixMultiply(allocator, 500);

    const mat_elapsed =
        @divTrunc(nowNs() - mat_start, 1_000_000);

    std.debug.print(
        "matrix_multiply(500x500), time: {}ms\n",
        .{mat_elapsed},
    );

    const prime_start = nowNs();

    const count = primeCount(
        allocator,
        10_000_000,
    );

    const prime_elapsed =
        @divTrunc(nowNs() - prime_start, 1_000_000);

    std.debug.print(
        "prime_count(10M) = {}, time: {}ms\n",
        .{ count, prime_elapsed },
    );
}
