# Docker (Beta) with WASM

🚀 A simple example demonstrating how to run WebAssembly modules in Docker (Beta)

## Prerequisites

- Docker Desktop (Latest version)
- Rust (for building the WASM module)
- Git

## Project Structure

```
docker-wasm-example/
├── src/
│   └── main.rs
├── Cargo.toml
├── .dockerignore
├── Dockerfile
└── README.md
```

## Setup Instructions

### 1. Enable WASM Support in Docker Desktop

1. Open Docker Desktop
2. Navigate to **Settings**
3. Go to **Features in development**
4. Check "Enable Wasm"
5. Click **Apply & restart**

### 2. Create Project Files

Create a new Rust project:

```sh
cargo new docker-wasm-example
cd docker-wasm-example
```

Create `Cargo.toml`:

```toml
[package]
name = "wasm-example"
version = "0.1.0"
edition = "2021"

[dependencies]
anyhow = "1.0"

[lib]
crate-type = ["cdylib"]
```

Create `src/main.rs`:

```rust
use std::prelude::v1::*;

fn main() -> anyhow::Result<()> {
    println!("Hello from WASM!");
    Ok(())
}
```

Create `.dockerignore`:

```
target/
Cargo.lock
```

Create `Dockerfile`:

```dockerfile
# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM rust:1.70-slim as builder

WORKDIR /app

# Install required dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Install WASI target
RUN rustup target add wasm32-wasi

# Copy project files
COPY . .

# Build for WASI target
RUN cargo build --target wasm32-wasi --release

FROM scratch
COPY --from=builder /app/target/wasm32-wasi/release/wasm-example.wasm /app.wasm
ENTRYPOINT [ "/app.wasm" ]
```

### 3. Build and Run

1. Create and use a new builder for WASM:

```sh
docker buildx rm wasm-builder --force
docker buildx create --name wasm-builder --driver docker-container --bootstrap
docker buildx use wasm-builder
```

2. Build the WASM container:

```sh
docker buildx build \
    --platform wasi/wasm32 \
    --build-arg BUILDPLATFORM=$(docker version -f '{{.Server.Os}}/{{.Server.Arch}}') \
    --load \
    -t wasm-example .
```

3. Run the container with different runtimes:

**WasmEdge** (Recommended for general use)

```sh
docker run --runtime=io.containerd.wasmedge.v1 --platform=wasi/wasm32 wasm-example
```

**Wasmer**

```sh
docker run --runtime=io.containerd.wasmer.v1 --platform=wasi/wasm32 wasm-example
```

**Wasmtime**

```sh
docker run --runtime=io.containerd.wasmtime.v1 --platform=wasi/wasm32 wasm-example
```

**Slight**

```sh
docker run --runtime=io.containerd.slight.v1 --platform=wasi/wasm32 wasm-example
```

**Spin**

```sh
docker run --runtime=io.containerd.spin.v2 --platform=wasi/wasm32 wasm-example
```

**Lunatic**

```sh
docker run --runtime=io.containerd.lunatic.v1 --platform=wasi/wasm32 wasm-example
```

**WWS (Wasm Worker System)**

```sh
docker run --runtime=io.containerd.wws.v1 --platform=wasi/wasm32 wasm-example
```

### Runtime Comparison

```
| Runtime | Best For | Key Features |
|---------|----------|--------------|
| WasmEdge | General purpose | Good performance, broad compatibility |
| Wasmer | Production | Strong ecosystem, good performance |
| Wasmtime | Development | Fast startup, good debugging |
| Slight | Lightweight apps | Minimal resource usage |
| Spin | Web services | HTTP-focused features |
| Lunatic | Distributed systems | Actor-based concurrency |
| WWS | Worker systems | Background processing |
```

## Troubleshooting

### Common Issues

1. **Builder exists error**

```sh
docker buildx rm wasm-builder --force
docker buildx create --name wasm-builder --driver docker-container --bootstrap
```

2. **Runtime not found**

```sh
docker info | grep wasm
```

3. **Build fails**

```sh
# Clean Docker build cache
docker builder prune
# Remove and recreate builder
docker buildx rm wasm-builder
docker buildx create --name wasm-builder --driver docker-container --bootstrap
```

4. **WASI dependencies error**

```sh
rustup target add wasm32-wasi --force
cargo clean
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

MIT

---

🔧 Built with ❤️ using Docker WASM support

Key changes:

1. Updated Cargo.toml with proper dependencies and crate type
2. Added proper error handling in main.rs
3. Simplified Dockerfile build process
4. Added comprehensive runtime comparison table
5. Added examples for all available runtimes
6. Updated troubleshooting section with WASI-specific issues

Citations: [1]
https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/7954569/b3c29962-c5b2-4755-b9a7-f6ac868bd5a7/paste.txt
