# Docker Installation Guide

This guide covers running TOL in Docker containers for platform-agnostic deployment and development.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Using Official Images](#using-official-images)
- [Building Custom Images](#building-custom-images)
- [Development Workflow](#development-workflow)
- [Production Deployment](#production-deployment)
- [Docker Compose](#docker-compose)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Docker Installation

Install Docker for your platform:

- **Linux**: [Docker Engine](https://docs.docker.com/engine/install/)
- **macOS**: [Docker Desktop](https://docs.docker.com/desktop/mac/install/)
- **Windows**: [Docker Desktop](https://docs.docker.com/desktop/windows/install/)

Verify installation:
```bash
docker --version
docker run hello-world
```

### System Requirements

- **RAM**: 2GB minimum for Docker, 4GB recommended
- **Storage**: 5GB for images and containers
- **CPU**: Any x86_64 or ARM64 processor

## Quick Start

### Running TOL Interactively

```bash
# Pull the official TOL image
docker pull tolproject/tol:latest

# Run TOL interactively
docker run -it --rm tolproject/tol:latest

# Run a simple command
docker run --rm tolproject/tol:latest tolcon -c 'WriteLn("Hello from Docker!");'
```

### Running TOL Scripts

```bash
# Run a local script
docker run --rm -v $(pwd):/workspace tolproject/tol:latest tolcon /workspace/script.tol

# Windows PowerShell
docker run --rm -v ${PWD}:/workspace tolproject/tol:latest tolcon /workspace/script.tol

# With input/output files
docker run --rm \
  -v $(pwd)/input:/input:ro \
  -v $(pwd)/output:/output \
  tolproject/tol:latest tolcon /input/analysis.tol
```

## Using Official Images

### Available Tags

| Tag | Description | Base Image | Size |
|-----|-------------|------------|------|
| `latest` | Latest stable release | Ubuntu 22.04 | ~300MB |
| `3.0` | Version 3.0.x | Ubuntu 22.04 | ~300MB |
| `alpine` | Minimal Alpine-based | Alpine 3.18 | ~150MB |
| `dev` | Development build | Ubuntu 22.04 | ~500MB |
| `slim` | Minimal dependencies | Debian slim | ~200MB |

### Architecture Support

```bash
# Check available architectures
docker manifest inspect tolproject/tol:latest

# Explicitly pull for specific architecture
docker pull --platform linux/amd64 tolproject/tol:latest    # Intel/AMD
docker pull --platform linux/arm64 tolproject/tol:latest    # ARM64/Apple Silicon
```

## Building Custom Images

### Basic Dockerfile

Create a `Dockerfile` for your TOL application:

```dockerfile
# Dockerfile
FROM tolproject/tol:latest

# Set working directory
WORKDIR /app

# Copy your TOL scripts
COPY *.tol /app/

# Copy data files
COPY data/ /app/data/

# Set default command
CMD ["tolcon", "main.tol"]
```

Build and run:
```bash
docker build -t my-tol-app .
docker run --rm my-tol-app
```

### Building TOL from Source

```dockerfile
# Dockerfile.build
FROM ubuntu:22.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libgsl-dev \
    libfftw3-dev \
    libblas-dev \
    liblapack-dev \
    libbz2-dev \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build TOL
WORKDIR /build
RUN git clone https://github.com/m-marinucci/Tol.git && \
    cd Tol/tol-master/tol && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc)

# Runtime stage
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libgsl27 \
    libfftw3-3 \
    libblas3 \
    liblapack3 \
    libbz2-1.0 \
    libboost-system1.74.0 \
    && rm -rf /var/lib/apt/lists/*

# Copy built binaries
COPY --from=builder /build/Tol/tol-master/tol/build/tolcon /usr/local/bin/
COPY --from=builder /build/Tol/tol-master/tol/stdlib /usr/local/share/tol/stdlib

# Set environment
ENV TOL_HOME=/usr/local/share/tol
ENV PATH=/usr/local/bin:$PATH

# Verify installation
RUN tolcon --version

WORKDIR /workspace
CMD ["tolcon"]
```

### Multi-Architecture Build

Build for multiple platforms:

```bash
# Enable buildx
docker buildx create --use

# Build for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myregistry/tol:latest \
  --push .
```

## Development Workflow

### Interactive Development Container

```dockerfile
# Dockerfile.dev
FROM tolproject/tol:dev

# Install development tools
RUN apt-get update && apt-get install -y \
    vim \
    gdb \
    valgrind \
    strace \
    && rm -rf /var/lib/apt/lists/*

# Create development user
RUN useradd -m -s /bin/bash developer
USER developer
WORKDIR /home/developer

# Keep container running
CMD ["tail", "-f", "/dev/null"]
```

Run development container:
```bash
# Start container
docker run -d \
  --name tol-dev \
  -v $(pwd):/workspace \
  -v $HOME/.ssh:/home/developer/.ssh:ro \
  my-tol-dev

# Execute commands
docker exec -it tol-dev tolcon /workspace/test.tol

# Interactive shell
docker exec -it tol-dev bash
```

### VS Code Integration

`.devcontainer/devcontainer.json`:
```json
{
    "name": "TOL Development",
    "image": "tolproject/tol:dev",
    "workspaceFolder": "/workspace",
    "mounts": [
        "source=.,target=/workspace,type=bind"
    ],
    "settings": {
        "terminal.integrated.defaultProfile.linux": "bash"
    },
    "extensions": [
        "ms-vscode.cpptools"
    ],
    "forwardPorts": [],
    "postCreateCommand": "tolcon --version"
}
```

## Production Deployment

### Optimized Production Image

```dockerfile
# Dockerfile.prod
FROM tolproject/tol:alpine AS runtime

# Add only necessary files
COPY --chown=nobody:nobody app.tol /app/
COPY --chown=nobody:nobody config/ /app/config/

# Run as non-root user
USER nobody
WORKDIR /app

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD tolcon -c 'WriteLn("OK");' || exit 1

# Set resource limits
ENV TOL_MAX_MEMORY=1G
ENV TOL_MAX_THREADS=4

ENTRYPOINT ["tolcon"]
CMD ["app.tol"]
```

### Security Considerations

```dockerfile
# Security-hardened image
FROM tolproject/tol:latest

# Remove unnecessary packages
RUN apt-get remove -y wget curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Create app user
RUN groupadd -r app && useradd -r -g app app

# Set up app directory
RUN mkdir -p /app && chown -R app:app /app
WORKDIR /app

# Copy files as app user
COPY --chown=app:app . /app/

# Switch to app user
USER app

# Read-only root filesystem
RUN chmod -R a-w /app

# No new privileges
SECURITY_OPT="no-new-privileges:true"
```

## Docker Compose

### Development Setup

`docker-compose.yml`:
```yaml
version: '3.8'

services:
  tol:
    image: tolproject/tol:latest
    volumes:
      - ./scripts:/scripts:ro
      - ./data:/data:ro
      - ./output:/output
    environment:
      - TOL_LOG_LEVEL=DEBUG
    command: tolcon /scripts/main.tol

  database:
    image: postgres:14
    environment:
      POSTGRES_DB: toldata
      POSTGRES_USER: tol
      POSTGRES_PASSWORD: secure_password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### Production Stack

`docker-compose.prod.yml`:
```yaml
version: '3.8'

services:
  tol-api:
    image: myregistry/tol-api:latest
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 1G
    environment:
      - NODE_ENV=production
    secrets:
      - db_password
    networks:
      - backend

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certs:/etc/nginx/certs:ro
    depends_on:
      - tol-api
    networks:
      - backend

networks:
  backend:
    driver: overlay

secrets:
  db_password:
    external: true
```

## Troubleshooting

### Common Issues

#### 1. Container Exits Immediately

**Problem**: Container stops right after starting

**Solution**:
```bash
# Check logs
docker logs container_name

# Run with interactive terminal
docker run -it tolproject/tol:latest /bin/bash

# Keep container running for debugging
docker run -d tolproject/tol:latest tail -f /dev/null
```

#### 2. Permission Issues

**Problem**: Cannot write to mounted volumes

**Solution**:
```bash
# Check user ID
docker run --rm tolproject/tol:latest id

# Run with current user
docker run --user $(id -u):$(id -g) \
  -v $(pwd):/workspace \
  tolproject/tol:latest

# Fix permissions
docker run --rm \
  -v $(pwd):/workspace \
  tolproject/tol:latest \
  chown -R $(id -u):$(id -g) /workspace
```

#### 3. Memory Issues

**Problem**: Out of memory errors

**Solution**:
```bash
# Increase memory limit
docker run --memory=4g --memory-swap=4g \
  tolproject/tol:latest

# Check current limits
docker stats container_name
```

#### 4. Network Issues

**Problem**: Cannot connect to external services

**Solution**:
```bash
# Use host network
docker run --network=host tolproject/tol:latest

# Custom DNS
docker run --dns 8.8.8.8 tolproject/tol:latest
```

### Performance Optimization

#### CPU Optimization
```bash
# Use all available CPUs
docker run --cpus="0" tolproject/tol:latest

# Limit to specific CPUs
docker run --cpuset-cpus="0-3" tolproject/tol:latest
```

#### Storage Optimization
```bash
# Use tmpfs for temporary files
docker run --tmpfs /tmp:rw,size=1g tolproject/tol:latest

# Use volumes for better I/O
docker volume create tol-data
docker run -v tol-data:/data tolproject/tol:latest
```

### Debugging

#### Interactive Debugging
```bash
# Run with debugging tools
docker run -it --cap-add=SYS_PTRACE \
  tolproject/tol:dev \
  gdb tolcon

# Trace system calls
docker run --cap-add=SYS_PTRACE \
  tolproject/tol:dev \
  strace tolcon script.tol
```

#### Container Inspection
```bash
# Inspect running processes
docker exec container_name ps aux

# Check file system
docker exec container_name ls -la /

# Environment variables
docker exec container_name env
```

## Best Practices

### Image Size Optimization

1. Use multi-stage builds
2. Minimize layers
3. Remove build dependencies
4. Use Alpine when possible

### Security

1. Run as non-root user
2. Use read-only root filesystem
3. Limit capabilities
4. Scan images for vulnerabilities

### Caching

```dockerfile
# Leverage build cache
COPY requirements.txt .
RUN install_dependencies

# Then copy source code
COPY . .
```

### Logging

```bash
# JSON logging
docker run tolproject/tol:latest \
  tolcon -c 'JSONLog(["level": "info", "message": "Started"]);'

# Centralized logging
docker run --log-driver=syslog \
  --log-opt syslog-address=tcp://logserver:514 \
  tolproject/tol:latest
```

## See Also

- [Main Installation Guide](README.md)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Kubernetes Deployment Guide](../../deployment/kubernetes.md)