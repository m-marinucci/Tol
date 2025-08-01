# macOS Installation Guide

This guide provides detailed instructions for installing TOL on macOS, covering both Intel and Apple Silicon architectures.

## Table of Contents

- [System Requirements](#system-requirements)
- [Apple Silicon](#apple-silicon)
- [Intel Macs](#intel-macs)
- [Universal Binary](#universal-binary)
- [Prerequisites Installation](#prerequisites-installation)
- [Building from Source](#building-from-source)
- [Troubleshooting](#troubleshooting)
- [Performance Optimization](#performance-optimization)

## System Requirements

### Supported Versions

| macOS Version | Architecture | Xcode Version | Status |
|---------------|--------------|---------------|---------|
| 14.0+ (Sonoma) | Apple Silicon | 15.0+ | ✅ Fully Supported |
| 13.0+ (Ventura) | Apple Silicon/Intel | 14.0+ | ✅ Fully Supported |
| 12.0+ (Monterey) | Apple Silicon/Intel | 13.0+ | ✅ Fully Supported |
| 11.0+ (Big Sur) | Apple Silicon/Intel | 12.5+ | ✅ Fully Supported |
| 10.15 (Catalina) | Intel | 11.7+ | ⚠️ Limited Support |
| 10.14 and earlier | Intel | - | ❌ Not Supported |

### Hardware Requirements

- **Apple Silicon**: M1, M1 Pro, M1 Max, M1 Ultra, M2, M2 Pro, M2 Max, M3 series
- **Intel**: 64-bit processor (Core i5 or better recommended)
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 2GB free space

## Apple Silicon

### Native ARM64 Build

Apple Silicon Macs (M1/M2/M3) can run TOL natively for best performance.

#### Prerequisites

```bash
# 1. Install Xcode Command Line Tools
xcode-select --install

# 2. Install Homebrew for Apple Silicon
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Add Homebrew to PATH (if not already done)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# 4. Install dependencies
brew install cmake gsl fftw lapack openblas bzip2 boost suite-sparse
```

#### Building for Apple Silicon

```bash
# Clone repository
git clone https://github.com/m-marinucci/Tol.git
cd Tol/tol-master/tol

# Create build directory
mkdir build-arm64 && cd build-arm64

# Configure for ARM64
cmake .. -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_OSX_ARCHITECTURES=arm64 \
         -DCMAKE_PREFIX_PATH=/opt/homebrew

# Build
make -j$(sysctl -n hw.ncpu)

# Test
./tolcon -c 'WriteLn("Native ARM64 TOL!");'
```

### Rosetta 2 Compatibility

To run Intel-based TOL binaries on Apple Silicon:

```bash
# Install Rosetta 2 (if not already installed)
softwareupdate --install-rosetta

# Run Intel binary under Rosetta
arch -x86_64 ./tolcon
```

## Intel Macs

### Building for Intel

```bash
# Prerequisites (using Homebrew)
brew install cmake gsl fftw lapack openblas bzip2 boost suite-sparse

# Clone and build
git clone https://github.com/m-marinucci/Tol.git
cd Tol/tol-master/tol
mkdir build-intel && cd build-intel

# Configure for Intel
cmake .. -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_OSX_ARCHITECTURES=x86_64

# Build
make -j$(sysctl -n hw.ncpu)
```

## Universal Binary

Build a single binary that runs on both Intel and Apple Silicon:

```bash
# Configure for Universal Binary
cmake .. -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
         -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0

# Build
make -j$(sysctl -n hw.ncpu)

# Verify universal binary
lipo -info tolcon
# Output: Architectures in the fat file: tolcon are: x86_64 arm64
```

## Prerequisites Installation

### Option 1: Homebrew (Recommended)

```bash
# Update Homebrew
brew update
brew upgrade

# Install all dependencies
brew install \
    cmake \
    gsl \
    fftw \
    lapack \
    openblas \
    bzip2 \
    boost \
    suite-sparse \
    tcl-tk

# Optional: Development tools
brew install \
    ninja \
    ccache \
    doxygen \
    graphviz
```

### Option 2: MacPorts

```bash
# Install MacPorts from https://www.macports.org/

# Update ports
sudo port selfupdate

# Install dependencies
sudo port install \
    cmake \
    gsl \
    fftw-3 \
    lapack \
    openblas \
    bzip2 \
    boost \
    suitesparse
```

### Option 3: From Source

For complete control, build dependencies from source:

```bash
# Example: Building GSL from source
wget https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz
tar -xzf gsl-2.7.tar.gz
cd gsl-2.7
./configure --prefix=/usr/local
make -j$(sysctl -n hw.ncpu)
sudo make install
```

## Building from Source

### Standard Build Process

```bash
# 1. Clone repository
git clone https://github.com/m-marinucci/Tol.git
cd Tol

# 2. Prepare build
cd tol-master/tol
mkdir build && cd build

# 3. Configure
cmake .. -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_PREFIX_PATH="$(brew --prefix)"

# 4. Build
make -j$(sysctl -n hw.ncpu)

# 5. Test
make test

# 6. Install (optional)
sudo make install
```

### CMake Configuration Options

```bash
# Debug build with symbols
cmake .. -DCMAKE_BUILD_TYPE=Debug \
         -DCMAKE_CXX_FLAGS="-g -O0"

# Release with debug info
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo

# Custom installation prefix
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/tol

# Disable GUI components
cmake .. -DENABLE_GUI=OFF

# Use specific compiler
cmake .. -DCMAKE_C_COMPILER=clang \
         -DCMAKE_CXX_COMPILER=clang++
```

### Using Ninja Build System

For faster builds:

```bash
# Install ninja
brew install ninja

# Configure with Ninja
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release

# Build
ninja

# Parallel build is automatic with Ninja
```

## Troubleshooting

### Common Issues

#### 1. Xcode License Agreement

**Error**: `Agreeing to the Xcode/iOS license requires admin privileges`

**Solution**:
```bash
sudo xcodebuild -license accept
```

#### 2. Missing Command Line Tools

**Error**: `xcrun: error: invalid active developer path`

**Solution**:
```bash
xcode-select --install
# If that doesn't work:
sudo xcode-select --reset
```

#### 3. Homebrew Path Issues

**Error**: `CMake cannot find GSL`

**Solution**:
```bash
# For Apple Silicon
export CMAKE_PREFIX_PATH=/opt/homebrew

# For Intel
export CMAKE_PREFIX_PATH=/usr/local

# Or specify in CMake
cmake .. -DCMAKE_PREFIX_PATH=$(brew --prefix)
```

#### 4. Accelerate vs OpenBLAS Conflicts

**Error**: `Undefined symbols for architecture x86_64: "_cblas_dgemm"`

**Solution**:
```bash
# Use macOS Accelerate framework
cmake .. -DBLA_VENDOR=Apple

# Or force OpenBLAS
cmake .. -DBLA_VENDOR=OpenBLAS \
         -DBLAS_LIBRARIES=$(brew --prefix openblas)/lib/libopenblas.dylib
```

#### 5. Code Signing Issues

**Error**: `killed: 9` when running tolcon

**Solution**:
```bash
# Sign the binary
codesign -s - tolcon

# Or disable code signing check (development only)
sudo spctl --master-disable
```

### Architecture-Specific Issues

#### Running Wrong Architecture

```bash
# Check binary architecture
file tolcon

# Force specific architecture
arch -x86_64 ./tolcon  # Run as Intel
arch -arm64 ./tolcon   # Run as ARM64
```

#### Building for Older macOS

```bash
# Set deployment target
cmake .. -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15

# Check minimum version
otool -l tolcon | grep -A 3 LC_VERSION_MIN_MACOSX
```

## Performance Optimization

### Compiler Optimizations

```bash
# Aggressive optimization
cmake .. -DCMAKE_CXX_FLAGS="-O3 -march=native -flto"

# Apple Silicon specific
cmake .. -DCMAKE_CXX_FLAGS="-O3 -mcpu=apple-m1"

# Intel specific with AVX
cmake .. -DCMAKE_CXX_FLAGS="-O3 -mavx2 -mfma"
```

### Using Accelerate Framework

Apple's Accelerate framework provides optimized BLAS/LAPACK:

```bash
cmake .. -DBLA_VENDOR=Apple \
         -DCMAKE_CXX_FLAGS="-framework Accelerate"
```

### Link-Time Optimization (LTO)

```bash
# Enable LTO
cmake .. -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
         -DCMAKE_CXX_FLAGS="-flto=thin"
```

### Build Caching

```bash
# Install ccache
brew install ccache

# Configure CMake to use ccache
cmake .. -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
```

## Environment Setup

Add to `~/.zshrc` (or `~/.bash_profile` for older macOS):

```bash
# TOL environment
export TOL_HOME=/usr/local/tol
export PATH=$TOL_HOME/bin:$PATH

# Development environment
export CC=clang
export CXX=clang++

# Homebrew paths (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Homebrew paths (Intel)
# eval "$(/usr/local/bin/brew shellenv)"
```

## Verification

After installation, verify TOL works correctly:

```bash
# Check version
tolcon --version

# Architecture check
file $(which tolcon)

# Basic test
tolcon -c 'WriteLn("TOL on macOS " + OSVersion());'

# Performance test
tolcon -c 'Matrix A = RandomMatrix(1000, 1000); Time start = Now(); MatrixInv(A); WriteLn("Time: " + (Now() - start));'
```

## Creating a macOS App Bundle

For GUI applications:

```bash
# Create app structure
mkdir -p TOL.app/Contents/MacOS
mkdir -p TOL.app/Contents/Resources

# Copy executable
cp tolbase TOL.app/Contents/MacOS/

# Create Info.plist
cat > TOL.app/Contents/Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>TOL</string>
    <key>CFBundleIdentifier</key>
    <string>org.tol-project.tol</string>
    <key>CFBundleVersion</key>
    <string>3.0.0</string>
    <key>CFBundleExecutable</key>
    <string>tolbase</string>
</dict>
</plist>
EOF

# Sign the app
codesign -s - TOL.app
```

## See Also

- [Main Installation Guide](README.md)
- [Building from Source](../../developer/building.md)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Homebrew Documentation](https://docs.brew.sh)