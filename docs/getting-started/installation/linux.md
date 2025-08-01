# Linux Installation Guide

This guide provides detailed instructions for installing TOL on various Linux distributions.

## Table of Contents

- [Ubuntu/Debian](#ubuntu-debian)
- [CentOS/RHEL](#centos-rhel)
- [Fedora](#fedora)
- [Alpine Linux](#alpine-linux)
- [Generic Linux](#generic-linux)
- [ARM64 Linux](#arm64-linux)
- [Building from Source](#building-from-source)
- [Package Management](#package-management)
- [Troubleshooting](#troubleshooting)

## Ubuntu/Debian

### Supported Versions
- Ubuntu 20.04 LTS (Focal Fossa) and later
- Debian 10 (Buster) and later

### Prerequisites Installation

```bash
# Update package list
sudo apt update

# Install build tools
sudo apt install -y \
    build-essential \
    cmake \
    git \
    python3 \
    python3-pip

# Install required libraries
sudo apt install -y \
    libgsl-dev \
    libfftw3-dev \
    libblas-dev \
    liblapack-dev \
    liblapacke-dev \
    libbz2-dev

# Install optional libraries
sudo apt install -y \
    libboost-all-dev \
    libsuitesparse-dev \
    libsparsehash-dev \
    tcl8.6-dev \
    tk8.6-dev
```

### Ubuntu-Specific Notes

For Ubuntu 18.04, you may need a newer compiler:
```bash
# Add toolchain PPA
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install gcc-9 g++-9

# Set as default
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 90
```

## CentOS/RHEL

### Supported Versions
- CentOS 7 and later
- RHEL 7 and later
- Rocky Linux 8 and later
- AlmaLinux 8 and later

### Prerequisites Installation

#### CentOS/RHEL 7
```bash
# Enable EPEL repository
sudo yum install -y epel-release

# Install development tools
sudo yum groupinstall -y "Development Tools"

# Install newer GCC (required for C++14)
sudo yum install -y centos-release-scl
sudo yum install -y devtoolset-9

# Enable new GCC (add to .bashrc for persistence)
scl enable devtoolset-9 bash

# Install dependencies
sudo yum install -y \
    cmake3 \
    git \
    python3 \
    gsl-devel \
    fftw3-devel \
    blas-devel \
    lapack-devel \
    bzip2-devel \
    boost-devel
```

#### CentOS/RHEL 8+
```bash
# Enable PowerTools/CRB repository
sudo dnf config-manager --set-enabled powertools  # CentOS 8
# or
sudo dnf config-manager --set-enabled crb  # RHEL 8

# Install development tools
sudo dnf groupinstall -y "Development Tools"

# Install dependencies
sudo dnf install -y \
    cmake \
    git \
    python3 \
    gsl-devel \
    fftw3-devel \
    blas-devel \
    lapack-devel \
    bzip2-devel \
    boost-devel \
    suitesparse-devel
```

## Fedora

### Supported Versions
- Fedora 32 and later

### Prerequisites Installation

```bash
# Install development tools
sudo dnf groupinstall -y "Development Tools"

# Install dependencies
sudo dnf install -y \
    cmake \
    git \
    python3 \
    gsl-devel \
    fftw3-devel \
    blas-devel \
    lapack-devel \
    bzip2-devel \
    boost-devel \
    suitesparse-devel \
    sparsehash-devel \
    tcl-devel \
    tk-devel
```

## Alpine Linux

### Prerequisites Installation

```bash
# Update package index
apk update

# Install build tools
apk add --no-cache \
    build-base \
    cmake \
    git \
    python3 \
    py3-pip

# Install libraries
apk add --no-cache \
    gsl-dev \
    fftw-dev \
    lapack-dev \
    bzip2-dev \
    boost-dev

# Note: Some packages may need to be built from source on Alpine
```

### Alpine-Specific Considerations

Alpine uses musl libc instead of glibc, which may require additional patches:

1. Some C++ standard library features may behave differently
2. Static linking is preferred for better compatibility
3. Consider using the Docker image for production deployments

## Generic Linux

For distributions not listed above, install equivalent packages:

### Required Packages
| Package | Purpose | Typical Names |
|---------|---------|---------------|
| C++ Compiler | Building TOL | gcc, g++, clang |
| CMake | Build system | cmake |
| Git | Source control | git |
| GSL | Scientific library | libgsl, gsl |
| FFTW3 | FFT operations | libfftw3, fftw |
| BLAS | Linear algebra | libblas, blas |
| LAPACK | Linear algebra | liblapack, lapack |
| BZip2 | Compression | libbz2, bzip2 |

### Finding Package Names

```bash
# Search for packages (examples)
# Debian/Ubuntu:
apt-cache search gsl | grep dev

# Fedora/CentOS:
dnf search gsl | grep devel

# Arch Linux:
pacman -Ss gsl

# OpenSUSE:
zypper search gsl
```

## ARM64 Linux

### Supported Platforms
- Raspberry Pi 4 (64-bit OS)
- AWS Graviton instances
- Apple M1/M2 Linux VMs
- Other ARM64/AArch64 systems

### ARM64-Specific Build Flags

```bash
# Configure for ARM64 optimization
cd tol-master/tol
mkdir build && cd build

cmake .. -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DCMAKE_C_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

make -j$(nproc)
```

### Raspberry Pi Specific

```bash
# Raspberry Pi OS (64-bit)
sudo apt update
sudo apt install -y \
    build-essential cmake git \
    libgsl-dev libfftw3-dev \
    libblas-dev liblapack-dev \
    libbz2-dev

# Build with Pi-specific optimizations
cmake .. -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72"
```

## Building from Source

### Standard Build Process

```bash
# 1. Clone the repository
git clone https://github.com/m-marinucci/Tol.git
cd Tol

# 2. Create build directory
cd tol-master/tol
mkdir build && cd build

# 3. Configure with CMake
cmake .. -DCMAKE_BUILD_TYPE=Release

# 4. Build
make -j$(nproc)

# 5. Run tests
make test

# 6. Install (optional)
sudo make install
```

### CMake Options

```bash
# Debug build
cmake .. -DCMAKE_BUILD_TYPE=Debug

# Custom installation prefix
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/tol

# Disable optional features
cmake .. -DENABLE_GUI=OFF -DENABLE_SPARSE=OFF

# Specify custom library paths
cmake .. -DGSL_ROOT_DIR=/usr/local \
         -DFFTW3_ROOT_DIR=/usr/local \
         -DLAPACK_ROOT_DIR=/usr/local
```

### Build Types

| Build Type | Optimization | Debug Info | Use Case |
|------------|--------------|------------|----------|
| Release | -O3 | No | Production |
| Debug | -O0 | Yes | Development |
| RelWithDebInfo | -O2 | Yes | Profiling |
| MinSizeRel | -Os | No | Embedded |

## Package Management

### Creating a DEB Package (Debian/Ubuntu)

```bash
# Install packaging tools
sudo apt install -y checkinstall

# Build and create package
cd build
sudo checkinstall --pkgname=tol \
                  --pkgversion="3.0.0" \
                  --backup=no \
                  --deldoc=yes \
                  --fstrans=no \
                  --default \
                  make install
```

### Creating an RPM Package (CentOS/Fedora)

```bash
# Install RPM tools
sudo yum install -y rpm-build

# Create RPM spec file (see documentation)
# Build RPM
rpmbuild -ba tol.spec
```

### AppImage (Universal Linux Package)

```bash
# Download appimagetool
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# Create AppDir structure
make install DESTDIR=AppDir

# Generate AppImage
./appimagetool-x86_64.AppImage AppDir
```

## Troubleshooting

### Common Issues

#### 1. Compiler Too Old

**Error**: `error: 'std::make_unique' is not a member of 'std'`

**Solution**:
```bash
# Check compiler version
gcc --version

# Install newer compiler (Ubuntu)
sudo apt install gcc-9 g++-9

# Or use clang
sudo apt install clang-10
export CC=clang-10 CXX=clang++-10
```

#### 2. Missing CLAPACK Symbols

**Error**: `undefined reference to 'clapack_dgetrf'`

**Solution**:
```bash
# Option 1: Install CLAPACK separately
sudo apt install libclapack-dev

# Option 2: Build with LAPACKE
cmake .. -DUSE_LAPACKE=ON
```

#### 3. Library Not Found

**Error**: `ld: cannot find -lgsl`

**Solution**:
```bash
# Find library location
find /usr -name "libgsl.so*" 2>/dev/null

# Add to library path
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Or specify in CMake
cmake .. -DCMAKE_PREFIX_PATH=/usr/local
```

#### 4. Permission Denied During Install

**Error**: `CMake Error at cmake_install.cmake: file INSTALL cannot copy file`

**Solution**:
```bash
# Use sudo for system-wide install
sudo make install

# Or install to user directory
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
make install
```

### Performance Optimization

#### CPU-Specific Optimization

```bash
# Detect CPU capabilities
lscpu | grep Flags

# Build with native optimizations
cmake .. -DCMAKE_CXX_FLAGS="-O3 -march=native"
```

#### Link-Time Optimization (LTO)

```bash
# Enable LTO for smaller, faster binaries
cmake .. -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON
```

#### Parallel Build

```bash
# Use all available cores
make -j$(nproc)

# Or limit to specific number
make -j4
```

### Debugging Build Issues

```bash
# Verbose build output
make VERBOSE=1

# CMake debugging
cmake .. -DCMAKE_VERBOSE_MAKEFILE=ON

# Check dependencies
ldd tolcon

# Trace library loading
LD_DEBUG=libs ./tolcon
```

## Post-Installation

### Environment Setup

Add to `~/.bashrc` or `~/.bash_profile`:

```bash
# TOL installation directory
export TOL_HOME=/usr/local/tol
export PATH=$TOL_HOME/bin:$PATH
export LD_LIBRARY_PATH=$TOL_HOME/lib:$LD_LIBRARY_PATH

# TOL packages directory
export TOL_PACKAGES=$HOME/.tol/packages
```

### Verification

```bash
# Check installation
which tolcon
tolcon --version

# Run test
tolcon -c 'WriteLn("TOL is working on Linux!");'
```

## See Also

- [Main Installation Guide](README.md)
- [Building from Source](../../developer/building.md)
- [Docker Installation](docker.md)
- [Troubleshooting Guide](../../troubleshooting.md)