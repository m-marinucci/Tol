# Linux ARM64 Build Fixes

This document summarizes the fixes applied to make TOL compile successfully on Linux ARM64 (Ubuntu 24.04 on Parallels Desktop).

## Files Modified

### 1. btol/bgrammar/opr.cpp
- **Line 1046**: Changed `if(grammarName.IsEmpty())` to `if(!grammarName.Length())`
- **Reason**: The `IsEmpty()` method doesn't exist in the BText class. Using `Length()` check instead.

### 2. CMake Configuration
- **Added**: `-fPIC` flag to both C and CXX flags
- **Added**: `-DCMAKE_POSITION_INDEPENDENT_CODE=ON`
- **Reason**: Required for building shared libraries on ARM64 Linux

## Dependencies Installed

The following packages are required for Ubuntu 24.04 ARM64:

```bash
# Build tools
build-essential cmake git pkg-config gfortran python3 python3-pip

# Core libraries
libgsl-dev               # GNU Scientific Library
libfftw3-dev            # Fast Fourier Transform
libblas-dev             # Basic Linear Algebra Subprograms
liblapack-dev           # Linear Algebra Package
libopenblas-openmp-dev  # Optimized BLAS for ARM64
liblapacke-dev          # LAPACK C interface

# Additional dependencies
libboost-all-dev        # Boost C++ Libraries
libzip-dev              # ZIP compression
libpcre3-dev            # Perl Compatible Regular Expressions
libncurses5-dev         # Terminal handling
libreadline-dev         # Command line editing
libgmp-dev              # GNU Multiple Precision Arithmetic
libeigen3-dev           # C++ template library for linear algebra
libbz2-dev              # BZip2 compression
libsparsehash-dev       # Google's dense_hash_map
libsuitesparse-dev      # Sparse matrix algorithms
```

## Build Commands

```bash
# Configure with ARM64 optimizations
cmake ../tol-master/tol \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DCMAKE_C_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DBLA_VENDOR=OpenBLAS \
    -DENABLE_TESTING=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

# Build
make -j$(nproc)
```

## Notes

1. The sys.cpp file on Linux had duplicate method definitions that were removed during the build process.
2. The build was tested on Ubuntu 24.04 LTS ARM64 running in Parallels Desktop on an M4 MacBook Air.
3. All tests passed and tolcon runs successfully.