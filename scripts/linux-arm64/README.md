# Linux ARM64 Build Directory

This directory is for building TOL on Linux ARM64 systems.

## Build Instructions

### Option 1: Build on Native Linux ARM64

```bash
# Install dependencies
sudo apt update
sudo apt install -y \
    build-essential cmake git pkg-config gfortran python3 python3-pip \
    libgsl-dev libfftw3-dev libblas-dev liblapack-dev libopenblas-openmp-dev \
    liblapacke-dev libboost-all-dev libzip-dev libpcre3-dev libncurses5-dev \
    libreadline-dev libgmp-dev libeigen3-dev libbz2-dev libsparsehash-dev \
    libsuitesparse-dev

# Configure
cmake ../tol-master/tol \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DCMAKE_C_FLAGS="-O3 -march=armv8-a -fPIC" \
    -DBLA_VENDOR=OpenBLAS \
    -DENABLE_TESTING=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON

# Build
make -j$(nproc)

# Test
./tolcon -c 'WriteLn("TOL ARM64 Linux build successful!")'
```

### Option 2: Build via SSH on VM (from macOS)

If you have a Linux VM set up (see ../PARALLELS_UBUNTU_SETUP.md):

```bash
# From the Tol directory on macOS
./build-tol-linux-remote.sh
```

## Build Artifacts

After a successful build, you will have:
- `tolcon` - The TOL console interpreter
- `libtol.so` - The TOL shared library
- Various module libraries in subdirectories

## Notes

- Requires GCC 9+ or Clang 10+
- The `-fPIC` flag is essential for ARM64 shared libraries
- OpenBLAS is recommended for optimal ARM64 performance
- Tested on Ubuntu 22.04 and 24.04 ARM64
