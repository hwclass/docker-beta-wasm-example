FROM --platform=$BUILDPLATFORM rust:1.70-slim as builder

WORKDIR /app

# Copy only Cargo.toml first
COPY Cargo.toml ./

# Create src directory and dummy main.rs
RUN mkdir src && \
    echo 'fn main() { println!("Hello from WASM!"); }' > src/main.rs && \
    rustup target add wasm32-wasi && \
    cargo build --target wasm32-wasi --release

# Now copy the real source code
COPY src ./src

# Build the actual application
RUN cargo build --target wasm32-wasi --release

FROM scratch
COPY --from=builder /app/target/wasm32-wasi/release/*.wasm /app.wasm
ENTRYPOINT [ "/app.wasm" ]