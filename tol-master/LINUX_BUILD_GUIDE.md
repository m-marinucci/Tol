# TOL Linux Build Guide

**Version**: 1.0.0  
**Date**: 2025-07-06  
**Issue**: NUM-12 - Linux Build Documentation & User Guides  
**Compatibility**: Ubuntu 20.04+, CentOS 7+, Fedora 30+, Debian 10+  

## 🎯 **Quick Start**

```bash
# Install dependencies
sudo apt-get update && sudo apt-get install -y cmake build-essential python3 git

# Clone and build
git clone https://github.com/m-marinucci/Tol.git
cd Tol
mkdir build && cd build
cmake ..
make -j$(nproc)

# Test installation
make test
```

## 📋 **Table of Contents**

1. [System Requirements](#system-requirements)
2. [Dependency Installation](#dependency-installation)
3. [Building TOL](#building-tol)
4. [Testing Framework](#testing-framework)
5. [Installation](#installation)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Configuration](#advanced-configuration)

## 🖥️ **System Requirements**

### **Minimum Requirements**
- **OS**: Linux kernel 3.10+ (64-bit recommended)
- **RAM**: 2 GB minimum, 4 GB recommended
- **Disk**: 2 GB free space for build
- **CPU**: x86_64 architecture

### **Supported Distributions**
- **Ubuntu**: 18.04 LTS, 20.04 LTS, 22.04 LTS
- **CentOS/RHEL**: 7, 8, 9
- **Fedora**: 30, 31, 32, 33+
- **Debian**: 9, 10, 11
- **openSUSE**: Leap 15.2+
- **Arch Linux**: Current

### **Required Tools**
- **CMake**: 3.16 or higher
- **GCC**: 7.0 or higher (C++14 support)
- **Python**: 3.6 or higher
- **Git**: 2.0 or higher

## 📦 **Dependency Installation**

### **Ubuntu/Debian**

```bash
# Update package list
sudo apt-get update

# Install build essentials
sudo apt-get install -y \
    cmake \
    build-essential \
    gcc \
    g++ \
    gfortran \
    python3 \
    python3-pip \
    git \
    pkg-config \
    autoconf \
    automake \
    libtool

# Install mathematical libraries
sudo apt-get install -y \
    libgsl-dev \
    liblapack-dev \
    libblas-dev \
    libfftw3-dev \
    libboost-all-dev

# Install database connectivity (optional)
sudo apt-get install -y \
    libmysqlclient-dev \
    libpq-dev \
    unixodbc-dev \
    libsqlite3-dev

# Install GUI dependencies (for TOLBase)
sudo apt-get install -y \
    tcl-dev \
    tk-dev \
    libx11-dev \
    libxt-dev

# Install additional tools
sudo apt-get install -y \
    bc \
    unzip \
    wget \
    curl \
    valgrind
```

### **CentOS/RHEL/Fedora**

```bash
# Enable EPEL repository (CentOS/RHEL)
sudo yum install -y epel-release  # CentOS 7
# OR
sudo dnf install -y epel-release  # CentOS 8+/Fedora

# Install build essentials
sudo yum install -y \
    cmake \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    python3 \
    python3-pip \
    git \
    pkg-config \
    autoconf \
    automake \
    libtool \
    make

# Install mathematical libraries
sudo yum install -y \
    gsl-devel \
    lapack-devel \
    blas-devel \
    fftw-devel \
    boost-devel

# Install database connectivity (optional)
sudo yum install -y \
    mysql-devel \
    postgresql-devel \
    unixODBC-devel \
    sqlite-devel

# Install GUI dependencies (for TOLBase)
sudo yum install -y \
    tcl-devel \
    tk-devel \
    libX11-devel \
    libXt-devel

# Install additional tools
sudo yum install -y \
    bc \
    unzip \
    wget \
    curl \
    valgrind
```

### **Arch Linux**

```bash
# Update system
sudo pacman -Syu

# Install build essentials
sudo pacman -S \
    cmake \
    base-devel \
    gcc \
    gcc-fortran \
    python \
    python-pip \
    git \
    pkg-config \
    autoconf \
    automake \
    libtool

# Install mathematical libraries
sudo pacman -S \
    gsl \
    lapack \
    blas \
    fftw \
    boost

# Install database connectivity (optional)
sudo pacman -S \
    mariadb-libs \
    postgresql-libs \
    unixodbc \
    sqlite

# Install GUI dependencies (for TOLBase)
sudo pacman -S \
    tcl \
    tk \
    libx11 \
    libxt

# Install additional tools
sudo pacman -S \
    bc \
    unzip \
    wget \
    curl \
    valgrind
```

## 🏗️ **Building TOL**

### **Method 1: CMake Build (Recommended)**

```bash
# Clone the repository
git clone https://github.com/m-marinucci/Tol.git
cd Tol

# Create build directory
mkdir build && cd build

# Configure build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local/tol \
    -DTOL_TESTS_ENABLE_PERFORMANCE=ON \
    -DTOL_TESTS_ENABLE_MEMORY=ON

# Build (use all available cores)
make -j$(nproc)

# Optional: Build specific components
make tol          # Core TOL interpreter
make tolbase      # GUI application
make toltcl       # Tcl bindings
```

### **Method 2: Using Build Scripts**

```bash
# Navigate to Linux build directory
cd building/Linux

# Make scripts executable
chmod +x *.sh

# Run main build script
./build.sh

# Build contributed packages
./build_contrib.sh

# Create installer package
./build_installer.sh
```

### **Build Configuration Options**

```bash
# Debug build
cmake .. -DCMAKE_BUILD_TYPE=Debug

# Custom installation prefix
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/tol

# Enable specific features
cmake .. \
    -DTOL_ENABLE_DATABASE=ON \
    -DTOL_ENABLE_GUI=ON \
    -DTOL_ENABLE_PYTHON_BINDINGS=ON

# Cross-compilation for 32-bit
cmake .. -DCMAKE_TOOLCHAIN_FILE=../tol/cmake/linux-i686.toolchain.cmake
```

## 🧪 **Testing Framework**

TOL includes a comprehensive cross-platform testing framework (NUM-11).

### **Quick Test Execution**

```bash
# Run all tests
cd build
make test

# Run specific test categories
make test_unit          # Unit tests
make test_performance   # Performance benchmarks
make test_integration   # Integration tests
make test_platform      # Platform-specific tests

# Generate test reports
make test_reports
```

### **Manual Test Execution**

```bash
# Navigate to test directory
cd tol_tests

# Run comprehensive test suite
./run_comprehensive_tests.sh

# Run specific test manually
tolcon -v unit_tests/bmath/test.tol
```

### **Test Results**

Test results are generated in multiple formats:
- **Console Output**: Human-readable results
- **JSON**: `build/test_results/comprehensive_test_report.json`
- **HTML**: `build/test_results/comprehensive_test_report.html`
- **JUnit XML**: `build/test_results/junit_test_results.xml`

## 📥 **Installation**

### **System-wide Installation**

```bash
# Install to system directories (requires sudo)
cd build
sudo make install

# Verify installation
tolcon --version
```

### **User Installation**

```bash
# Install to user directory
cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/tol
make install

# Add to PATH
echo 'export PATH=$HOME/tol/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### **Package Creation**

```bash
# Create DEB package (Ubuntu/Debian)
cd build
cpack -G DEB

# Create RPM package (CentOS/RHEL/Fedora)
cpack -G RPM

# Create TAR.GZ archive
cpack -G TGZ
```

## 🔧 **Environment Configuration**

### **Required Environment Variables**

```bash
# Add to ~/.bashrc or ~/.profile
export TOL_HOME=/usr/local/tol
export PATH=$TOL_HOME/bin:$PATH
export LD_LIBRARY_PATH=$TOL_HOME/lib:$LD_LIBRARY_PATH

# For development
export TOL_STDLIB_PATH=$TOL_HOME/share/tol/stdlib
export TOL_TEST_OUTPUT_DIR=$HOME/tol_test_results
```

### **Optional Configuration**

```bash
# Performance optimization
export OMP_NUM_THREADS=$(nproc)
export BLAS_NUM_THREADS=$(nproc)

# Memory configuration
export TOL_MAX_MEMORY=4G
export TOL_CACHE_SIZE=256M

# Database configuration (if using database features)
export TOL_DB_DRIVER_PATH=$TOL_HOME/lib/tol/drivers
```

## 🚀 **Quick Verification**

### **Basic Functionality Test**

```bash
# Test TOL interpreter
tolcon -c "WriteLn(\"Hello from TOL on Linux!\")"

# Test mathematical operations
tolcon -c "WriteLn(\"2 + 2 = \" + Text(2 + 2))"

# Test matrix operations
tolcon -c "Matrix m = [[1,2],[3,4]]; WriteLn(\"Matrix determinant: \" + Text(MatDet(m)))"
```

### **Performance Verification**

```bash
# Run performance benchmarks
cd tol_tests
tolcon -v performance_tests/matrix/test.tol

# Check system performance
tolcon -c "Real start = Time(); Matrix m = MatRand(1000,1000); Matrix p = m*m; WriteLn(\"1000x1000 matrix multiplication: \" + Text(Time()-start) + \"s\")"
```

## 📚 **Next Steps**

After successful installation:

1. **Read User Manual**: `doc/general/TOL User Manual.pdf`
2. **Explore Examples**: `tol_tests/` directory
3. **Try TOLBase GUI**: Run `tolbase` command
4. **Join Community**: Visit TOL project website
5. **Contribute**: See `DEVELOPER_GUIDE.md` in `tol_tests/`

## 🔗 **Related Documentation**

- **[Testing Framework Guide](tol_tests/COMPREHENSIVE_TESTING_FRAMEWORK.md)**
- **[Developer Guide](tol_tests/DEVELOPER_GUIDE.md)**
- **[Platform Examples](tol_tests/PLATFORM_EXAMPLES.md)**
- **[Troubleshooting Guide](LINUX_TROUBLESHOOTING.md)**

---

**Contact**: mmarinucci@numinate.com  
**Issue**: NUM-12 - Linux Build Documentation & User Guides  
**Last Updated**: 2025-07-06
