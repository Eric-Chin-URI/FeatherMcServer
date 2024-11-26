# Use the official Rust image to build the Feather server
FROM rust:latest as builder

# Set the working directory inside the container
WORKDIR /app

# Install required dependencies (if needed for the build)
RUN apt-get update && apt-get install -y \
    cmake \
    libssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Clone the Feather repository
RUN git clone https://github.com/feather-rs/feather.git .

# Build the Feather server
RUN cargo build --release

# Use a lightweight base image for the final container
FROM debian:bullseye-slim

# Set the working directory for the server
WORKDIR /feather-server

# Copy the compiled Feather binary from the builder stage
COPY --from=builder /app/target/release/feather .

# Expose the default Minecraft server port
EXPOSE 25565

# Set the entry point to run the server
CMD ["./feather"]
