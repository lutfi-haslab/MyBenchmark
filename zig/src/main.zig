const std = @import("std");

extern fn clock_gettime(clk_id: std.c.clockid_t, tp: *std.posix.timespec) c_int;

fn nowNs() i64 {
    var ts: std.posix.timespec = undefined;
    _ = clock_gettime(@enumFromInt(0), &ts);
    return @as(i64, ts.sec) * 1_000_000_000 + ts.nsec;
}

fn fibonacci(n: u64) u64 {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

fn matrixMultiply(allocator: std.mem.Allocator, n: usize) void {
    var a = allocator.alloc([]f64, n) catch unreachable;
    defer allocator.free(a);
    var b = allocator.alloc([]f64, n) catch unreachable;
    defer allocator.free(b);
    var c = allocator.alloc([]f64, n) catch unreachable;
    defer allocator.free(c);

    for (0..n) |i| {
        a[i] = allocator.alloc(f64, n) catch unreachable;
        b[i] = allocator.alloc(f64, n) catch unreachable;
        c[i] = allocator.alloc(f64, n) catch unreachable;
        for (0..n) |j| {
            a[i][j] = @as(f64, @floatFromInt(i + j)) * 0.1;
            b[i][j] = @as(f64, @floatFromInt(i)) * 0.1 - @as(f64, @floatFromInt(j)) * 0.1;
        }
    }

    for (0..n) |i| {
        for (0..n) |j| {
            var sum: f64 = 0;
            for (0..n) |k| {
                sum += a[i][k] * b[k][j];
            }
            c[i][j] = sum;
        }
    }
    std.mem.doNotOptimizeAway(&c[0][0]);
}

fn primeCount(allocator: std.mem.Allocator, limit: usize) usize {
    var sieve = allocator.alloc(bool, limit + 1) catch unreachable;
    defer allocator.free(sieve);
    for (sieve) |*v| {
        v.* = false;
    }

    var count: usize = 0;
    var i: usize = 2;
    while (i <= limit) : (i += 1) {
        if (!sieve[i]) {
            count += 1;
            var j = i * 2;
            while (j <= limit) : (j += i) {
                sieve[j] = true;
            }
        }
    }
    return count;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    std.debug.print("=== Zig Benchmark ===\n", .{});

    const start = nowNs();
    const result = fibonacci(42);
    const elapsed = @divTrunc(nowNs() - start, 1_000_000);
    std.debug.print("fibonacci(42) = {}, time: {}ms\n", .{ result, elapsed });

    const start2 = nowNs();
    matrixMultiply(allocator, 500);
    const elapsed2 = @divTrunc(nowNs() - start2, 1_000_000);
    std.debug.print("matrix_multiply(500x500), time: {}ms\n", .{elapsed2});

    const start3 = nowNs();
    const count = primeCount(allocator, 10_000_000);
    const elapsed3 = @divTrunc(nowNs() - start3, 1_000_000);
    std.debug.print("prime_count(10M) = {}, time: {}ms\n", .{ count, elapsed3 });
}
