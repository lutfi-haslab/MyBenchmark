.PHONY: all go rust zig bun php run clean

all: go rust zig bun php

go:
	@echo "=== Running Go ==="
	cd go && go run main.go

rust:
	@echo "=== Running Rust ==="
	cd rust && cargo run --release

zig:
	@echo "=== Running Zig ==="
	cd zig && zig run src/main.zig -O ReleaseSafe

bun:
	@echo "=== Running BunJS ==="
	cd bun && bun run index.ts

php:
	@echo "=== Running PHP ==="
	cd php && php bench.php

run:
	./run.sh

clean:
	rm -rf zig/zig-cache zig/zig-out rust/target bun/node_modules results/
