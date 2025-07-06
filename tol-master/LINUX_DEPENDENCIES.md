# TOL Linux Dependencies Guide

**Version**: 1.0.0  
**Date**: 2025-07-06  
**Issue**: NUM-12 - Linux Build Documentation & User Guides  

## 🎯 **Quick Installation**

```bash
# Ubuntu/Debian - One-liner
curl -fsSL https://raw.githubusercontent.com/m-marinucci/Tol/master/scripts/install-deps-ubuntu.sh | bash

# CentOS/RHEL/Fedora - One-liner  
curl -fsSL https://raw.githubusercontent.com/m-marinucci/Tol/master/scripts/install-deps-centos.sh | bash
```

## 📋 **Dependency Categories**

### **1. Core Build Dependencies**

| Package | Purpose | Ubuntu/Debian | CentOS/RHEL | Fedora |
|---------|---------|---------------|-------------|---------|
| CMake | Build system | `cmake` | `cmake3` | `cmake` |
| GCC | C++ compiler | `build-essential` | `gcc-c++` | `gcc-c++` |
| Python | Scripting | `python3` | `python3` | `python3` |
| Git | Version control | `git` | `git` | `git` |

### **2. Mathematical Libraries**

| Package | Purpose | Ubuntu/Debian | CentOS/RHEL | Fedora |
|---------|---------|---------------|-------------|---------|
| GSL | Scientific computing | `libgsl-dev` | `gsl-devel` | `gsl-devel` |
| BLAS | Linear algebra | `libblas-dev` | `blas-devel` | `blas-devel` |
| LAPACK | Linear algebra | `liblapack-dev` | `lapack-devel` | `lapack-devel` |
| FFTW | Fast Fourier Transform | `libfftw3-dev` | `fftw-devel` | `fftw-devel` |
| Boost | C++ libraries | `libboost-all-dev` | `boost-devel` | `boost-devel` |

### **3. Database Connectivity (Optional)**

| Package | Purpose | Ubuntu/Debian | CentOS/RHEL | Fedora |
|---------|---------|---------------|-------------|---------|
| MySQL | MySQL support | `libmysqlclient-dev` | `mysql-devel` | `mysql-devel` |
| PostgreSQL | PostgreSQL support | `libpq-dev` | `postgresql-devel` | `postgresql-devel` |
| ODBC | ODBC support | `unixodbc-dev` | `unixODBC-devel` | `unixODBC-devel` |
| SQLite | SQLite support | `libsqlite3-dev` | `sqlite-devel` | `sqlite-devel` |

### **4. GUI Dependencies (TOLBase)**

| Package | Purpose | Ubuntu/Debian | CentOS/RHEL | Fedora |
|---------|---------|---------------|-------------|---------|
| Tcl | Tcl interpreter | `tcl-dev` | `tcl-devel` | `tcl-devel` |
| Tk | GUI toolkit | `tk-dev` | `tk-devel` | `tk-devel` |
| X11 | X Window System | `libx11-dev` | `libX11-devel` | `libX11-devel` |
| Xt | X Toolkit | `libxt-dev` | `libXt-devel` | `libXt-devel` |

## 🐧 **Distribution-Specific Instructions**

### **Ubuntu 20.04/22.04 LTS**

```bash
# Update package database
sudo apt-get update

# Install core dependencies
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
    libtool \
    make

# Install mathematical libraries
sudo apt-get install -y \
    libgsl-dev \
    liblapack-dev \
    libblas-dev \
    libopenblas-dev \
    libfftw3-dev \
    libboost-all-dev \
    libeigen3-dev

# Install database support (optional)
sudo apt-get install -y \
    libmysqlclient-dev \
    libpq-dev \
    unixodbc-dev \
    libsqlite3-dev

# Install GUI support (optional)
sudo apt-get install -y \
    tcl-dev \
    tk-dev \
    libx11-dev \
    libxt-dev \
    libxft-dev

# Install development tools
sudo apt-get install -y \
    bc \
    unzip \
    wget \
    curl \
    valgrind \
    gdb \
    strace

# Install Python packages
pip3 install --user numpy scipy matplotlib
```

### **CentOS 7**

```bash
# Enable EPEL repository
sudo yum install -y epel-release

# Enable Software Collections (for newer GCC)
sudo yum install -y centos-release-scl
sudo yum install -y devtoolset-9-gcc devtoolset-9-gcc-c++

# Install core dependencies
sudo yum install -y \
    cmake3 \
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
    openblas-devel \
    fftw-devel \
    boost-devel \
    eigen3-devel

# Install database support (optional)
sudo yum install -y \
    mysql-devel \
    postgresql-devel \
    unixODBC-devel \
    sqlite-devel

# Install GUI support (optional)
sudo yum install -y \
    tcl-devel \
    tk-devel \
    libX11-devel \
    libXt-devel \
    libXft-devel

# Install development tools
sudo yum install -y \
    bc \
    unzip \
    wget \
    curl \
    valgrind \
    gdb \
    strace

# Create cmake symlink
sudo ln -sf /usr/bin/cmake3 /usr/bin/cmake

# Enable newer GCC for build
scl enable devtoolset-9 bash
```

### **CentOS 8/Rocky Linux/AlmaLinux**

```bash
# Enable PowerTools repository
sudo dnf config-manager --set-enabled powertools

# Install core dependencies
sudo dnf install -y \
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
sudo dnf install -y \
    gsl-devel \
    lapack-devel \
    blas-devel \
    openblas-devel \
    fftw-devel \
    boost-devel

# Install database support (optional)
sudo dnf install -y \
    mysql-devel \
    postgresql-devel \
    unixODBC-devel \
    sqlite-devel

# Install GUI support (optional)
sudo dnf install -y \
    tcl-devel \
    tk-devel \
    libX11-devel \
    libXt-devel

# Install development tools
sudo dnf install -y \
    bc \
    unzip \
    wget \
    curl \
    valgrind \
    gdb \
    strace
```

### **Fedora 33+**

```bash
# Install core dependencies
sudo dnf install -y \
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
sudo dnf install -y \
    gsl-devel \
    lapack-devel \
    blas-devel \
    openblas-devel \
    fftw-devel \
    boost-devel \
    eigen3-devel

# Install database support (optional)
sudo dnf install -y \
    mysql-devel \
    postgresql-devel \
    unixODBC-devel \
    sqlite-devel

# Install GUI support (optional)
sudo dnf install -y \
    tcl-devel \
    tk-devel \
    libX11-devel \
    libXt-devel

# Install development tools
sudo dnf install -y \
    bc \
    unzip \
    wget \
    curl \
    valgrind \
    gdb \
    strace
```

### **Debian 10/11**

```bash
# Update package database
sudo apt-get update

# Install core dependencies
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
    libopenblas-dev \
    libfftw3-dev \
    libboost-all-dev

# Install database support (optional)
sudo apt-get install -y \
    default-libmysqlclient-dev \
    libpq-dev \
    unixodbc-dev \
    libsqlite3-dev

# Install GUI support (optional)
sudo apt-get install -y \
    tcl-dev \
    tk-dev \
    libx11-dev \
    libxt-dev

# Install development tools
sudo apt-get install -y \
    bc \
    unzip \
    wget \
    curl \
    valgrind \
    gdb \
    strace
```

### **Arch Linux**

```bash
# Update system
sudo pacman -Syu

# Install core dependencies
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
    openblas \
    fftw \
    boost \
    eigen

# Install database support (optional)
sudo pacman -S \
    mariadb-libs \
    postgresql-libs \
    unixodbc \
    sqlite

# Install GUI support (optional)
sudo pacman -S \
    tcl \
    tk \
    libx11 \
    libxt

# Install development tools
sudo pacman -S \
    bc \
    unzip \
    wget \
    curl \
    valgrind \
    gdb \
    strace
```

## 🔧 **Verification Scripts**

### **Dependency Checker**

```bash
#!/bin/bash
# TOL Dependency Checker

echo "=== TOL Dependency Verification ==="

# Check core tools
echo "Checking core tools..."
for tool in cmake gcc g++ python3 git; do
    if command -v $tool >/dev/null 2>&1; then
        echo "✓ $tool: $(command -v $tool)"
    else
        echo "✗ $tool: NOT FOUND"
    fi
done

# Check libraries
echo -e "\nChecking libraries..."
for lib in gsl blas lapack fftw3; do
    if pkg-config --exists $lib 2>/dev/null; then
        echo "✓ $lib: $(pkg-config --modversion $lib)"
    else
        echo "✗ $lib: NOT FOUND"
    fi
done

# Check optional libraries
echo -e "\nChecking optional libraries..."
for lib in mysqlclient libpq odbc sqlite3; do
    if pkg-config --exists $lib 2>/dev/null; then
        echo "✓ $lib: $(pkg-config --modversion $lib)"
    else
        echo "? $lib: NOT FOUND (optional)"
    fi
done

echo -e "\n=== Verification Complete ==="
```

### **Performance Optimization**

```bash
# Install optimized libraries for better performance
sudo apt-get install -y \
    libopenblas-dev \
    libatlas-base-dev \
    libeigen3-dev

# Set environment variables for optimal performance
echo 'export OPENBLAS_NUM_THREADS=$(nproc)' >> ~/.bashrc
echo 'export OMP_NUM_THREADS=$(nproc)' >> ~/.bashrc
echo 'export BLAS_NUM_THREADS=$(nproc)' >> ~/.bashrc
```

## 📚 **Additional Resources**

- **[Linux Build Guide](LINUX_BUILD_GUIDE.md)** - Complete build instructions
- **[Troubleshooting Guide](LINUX_TROUBLESHOOTING.md)** - Common issues and solutions
- **[Testing Framework](tol_tests/COMPREHENSIVE_TESTING_FRAMEWORK.md)** - Testing documentation

---

**Contact**: mmarinucci@numinate.com  
**Issue**: NUM-12 - Linux Build Documentation & User Guides  
**Last Updated**: 2025-07-06
