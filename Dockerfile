# Modify standard Rust image
FROM rust:latest as cargo-build
RUN apt-get update
RUN apt-get install musl-tools -y
RUN rustup target add x86_64-unknown-linux-musl
RUN useradd -u 10001 tideuser

# Cache dependencies
WORKDIR /usr/src/tidetest
COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock
RUN mkdir src/
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
RUN rm -f target/x86_64-unknown-linux-musl/release/deps/tidetest*

# Final Rust build stage. Docker caches up to this stage if dependencies are unchanged.
COPY . .
RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
RUN strip /usr/src/tidetest/target/x86_64-unknown-linux-musl/release/tidetest

# Final Docker build Stage
FROM scratch
COPY --from=cargo-build /usr/src/tidetest/target/x86_64-unknown-linux-musl/release/tidetest .
COPY --from=cargo-build /etc/passwd /etc/passwd
USER tideuser

# Configure and document the service HTTP port
ENV PORT 8000
EXPOSE $PORT

# ENV RUST_LOG=info
ENTRYPOINT ["./tidetest"]