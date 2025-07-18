#!/bin/bash
# Build script for TOL on Linux ARM64

set -e

echo "========================================"
echo "TOL Linux ARM64 Build"
echo "========================================"

# Check if we're on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: This script is for Linux systems only."
    echo "Detected OS: $OSTYPE"
    exit 1
fi

# Check architecture
ARCH=$(uname -m)
if [[ "$ARCH" != "aarch64" && "$ARCH" != "arm64" ]]; then
    echo "Warning: This script is optimized for ARM64 architecture."
    echo "Detected architecture: $ARCH"
    echo "Continue anyway? (y/n)"
    read -r response
    if [[ "$response" != "y" ]]; then
        exit 1
    fi
fi

# Clean previous build if requested
if [[ "$1" == "clean" ]]; then
    echo "Cleaning previous build..."
    rm -rf CMakeCache.txt CMakeFiles/ Makefile cmake_install.cmake bin/ build/ *.a *.so tolcon tolbase PackArchive
fi

# Configure with CMake
echo ""
echo "Configuring with CMake..."
cmake ../tol-master/tol \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DCMAKE_C_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DBLA_VENDOR=OpenBLAS \
    -DENABLE_TESTING=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

# Build
echo ""
echo "Building TOL..."
make -j$(nproc)

# Test if build succeeded
if [ -f ./tolcon ]; then
    echo ""
    echo "========================================"
    echo "Build successful!"
    echo "========================================"
    echo ""
    echo "Testing tolcon..."
    ./tolcon -c 'WriteLn("TOL ARM64 Linux build successful!")'
else
    echo ""
    echo "Build failed. Check the error messages above."
    exit 1
fi