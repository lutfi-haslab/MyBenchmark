#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESULTS_DIR="$SCRIPT_DIR/results"
mkdir -p "$RESULTS_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="$RESULTS_DIR/$TIMESTAMP.txt"

run_benchmark() {
    local name="$1"
    local cmd="$2"
    echo "----------------------------------------"
    echo "Running: $name"
    echo "----------------------------------------"
    if eval "$cmd" 2>&1 | tee -a "$RESULTS_FILE"; then
        echo ""
    else
        echo "FAILED: $name" | tee -a "$RESULTS_FILE"
        echo ""
    fi
}

echo "=== Benchmark Suite ===" | tee "$RESULTS_FILE"
echo "Date: $(date)" | tee -a "$RESULTS_FILE"
echo "OS: $(uname -s) $(uname -m) (Apple MacBook Air M3)" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

if command -v go &>/dev/null; then
    run_benchmark "Go" "cd $SCRIPT_DIR/go && go run main.go"
else
    echo "Go not found, skipping..." | tee -a "$RESULTS_FILE"
    echo ""
fi

if command -v cargo &>/dev/null; then
    run_benchmark "Rust (release)" "cd $SCRIPT_DIR/rust && cargo run --release"
else
    echo "Rust/Cargo not found, skipping..." | tee -a "$RESULTS_FILE"
    echo ""
fi

if command -v zig &>/dev/null; then
    run_benchmark "Zig" "cd $SCRIPT_DIR/zig && zig run src/main.zig -O ReleaseSafe"
else
    echo "Zig not found, skipping..." | tee -a "$RESULTS_FILE"
    echo ""
fi

if command -v bun &>/dev/null; then
    run_benchmark "BunJS" "cd $SCRIPT_DIR/bun && bun run index.ts"
else
    echo "Bun not found, skipping..." | tee -a "$RESULTS_FILE"
    echo ""
fi

if command -v php &>/dev/null; then
    run_benchmark "PHP" "cd $SCRIPT_DIR/php && php bench.php"
else
    echo "PHP not found, skipping..." | tee -a "$RESULTS_FILE"
    echo ""
fi

echo "----------------------------------------" | tee -a "$RESULTS_FILE"
echo "Results saved to: $RESULTS_FILE" | tee -a "$RESULTS_FILE"
