# TOL Installation Guide

This comprehensive guide covers all supported platforms and installation methods for TOL (Time-Oriented Language).

## Table of Contents

- [Compatibility Matrix](#compatibility-matrix)
- [Prerequisites](#prerequisites)
- [Platform-Specific Instructions](#platform-specific-instructions)
  - [Linux Installation](#linux-installation)
  - [macOS Installation](#macos-installation)
  - [Windows Installation](#windows-installation)
  - [Docker Installation](#docker-installation)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Compatibility Matrix

| Platform | OS Version | Architecture | Compiler | TOL Version | Status | Notes |
|----------|------------|--------------|----------|-------------|---------|-------|
| **Linux** |
| Ubuntu | 20.04+ | x86_64, ARM64 | GCC 9+ | 3.0+ | ✅ Fully Supported | Recommended for production |
| Ubuntu | 18.04 | x86_64 | GCC 7+ | 3.0+ | ✅ Fully Supported | Requires updated GCC |
| Debian | 10+ | x86_64, ARM64 | GCC 8+ | 3.0+ | ✅ Fully Supported | |
| CentOS | 7+ | x86_64 | GCC 7+ | 3.0+ | ✅ Fully Supported | May need devtoolset |
| Fedora | 32+ | x86_64 | GCC 10+ | 3.0+ | ✅ Fully Supported | |
| Alpine | 3.12+ | x86_64 | GCC 9+ | 3.0+ | ⚠️ Community | Requires musl patches |
| **macOS** |
| macOS | 14.0+ (Sonoma) | Apple Silicon | Clang 15+ | 3.0+ | ✅ Fully Supported | Native ARM64 |
| macOS | 13.0+ (Ventura) | Apple Silicon | Clang 14+ | 3.0+ | ✅ Fully Supported | Native ARM64 |
| macOS | 12.0+ (Monterey) | Intel/AS | Clang 13+ | 3.0+ | ✅ Fully Supported | Universal binary |
| macOS | 11.0+ (Big Sur) | Intel/AS | Clang 12+ | 3.0+ | ✅ Fully Supported | Rosetta 2 for AS |
| macOS | 10.15 (Catalina) | Intel | Clang 11+ | 3.0+ | ⚠️ Limited | No longer tested |
| **Windows** |
| Windows | 11 | x86_64 | MSVC 2019+ | 3.0+ | ✅ Fully Supported | Recommended |
| Windows | 10 (1909+) | x86_64 | MSVC 2019+ | 3.0+ | ✅ Fully Supported | |
| Windows | 10 | x86_64 | MinGW-w64 8+ | 3.0+ | ⚠️ Community | Alternative toolchain |
| Windows | Server 2019+ | x86_64 | MSVC 2019+ | 3.0+ | ✅ Fully Supported | |
| **Other** |
| Docker | Any | x86_64, ARM64 | - | 3.0+ | ✅ Fully Supported | Platform agnostic |
| WSL2 | Windows 10+ | x86_64 | GCC 9+ | 3.0+ | ✅ Fully Supported | Ubuntu-based |

### Legend
- ✅ **Fully Supported**: Officially tested and supported by the TOL team
- ⚠️ **Community**: Community-maintained, may require additional steps
- ❌ **Not Supported**: Known to not work or no longer maintained

## Prerequisites

### All Platforms

1. **Minimum System Requirements**:
   - RAM: 4GB minimum, 8GB recommended
   - Disk Space: 2GB for full installation
   - Internet connection for downloading dependencies

2. **Required Skills**:
   - Basic command line knowledge
   - Familiarity with your platform's package manager
   - C++ compilation experience (helpful but not required)

### Development Tools

The following tools are required for building TOL from source:

| Tool | Minimum Version | Purpose |
|------|-----------------|---------|
| CMake | 3.10+ | Build system generator |
| Git | 2.0+ | Source code management |
| Python | 3.6+ | Build scripts and tools |

### External Libraries

TOL depends on several mathematical and scientific libraries:

| Library | Version | Required | Purpose |
|---------|---------|----------|---------|
| GSL | 2.5+ | ✅ Yes | Scientific computations |
| FFTW3 | 3.3+ | ✅ Yes | Fast Fourier transforms |
| BLAS | Any | ✅ Yes | Basic linear algebra |
| LAPACK | 3.8+ | ✅ Yes | Linear algebra routines |
| CLAPACK | - | ✅ Yes* | C interface to LAPACK |
| BZip2 | 1.0+ | ✅ Yes | Compression support |
| CHOLMOD | 3.0+ | ❌ No | Sparse matrix operations |
| Boost | 1.65+ | ❌ No | C++ utilities |
| Tcl/Tk | 8.5+ | ❌ No | GUI components |

\* CLAPACK is required unless your LAPACK build includes the C interface

## Platform-Specific Instructions

### Linux Installation

Choose your distribution below for specific instructions:

- [Ubuntu/Debian](linux.md#ubuntu-debian)
- [CentOS/RHEL](linux.md#centos-rhel)
- [Fedora](linux.md#fedora)
- [Alpine Linux](linux.md#alpine-linux)
- [Generic Linux](linux.md#generic-linux)

#### Quick Start (Ubuntu/Debian)

```bash
# 1. Update system packages
sudo apt update && sudo apt upgrade -y

# 2. Install dependencies
sudo apt install -y \
    build-essential cmake git python3 \
    libgsl-dev libfftw3-dev libblas-dev liblapack-dev \
    libbz2-dev libboost-all-dev \
    libsuitesparse-dev libsparsehash-dev

# 3. Clone TOL repository
git clone https://github.com/m-marinucci/Tol.git
cd Tol

# 4. Build TOL
cd tol-master/tol
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

# 5. Test installation
./tolcon -c 'WriteLn("TOL installed successfully!");'

# 6. Optional: Install system-wide
sudo make install
```

### macOS Installation

Choose your macOS version and architecture:

- [Apple Silicon (M1/M2/M3)](macos.md#apple-silicon)
- [Intel-based Macs](macos.md#intel-macs)
- [Universal Binary](macos.md#universal-binary)

#### Quick Start (Homebrew)

```bash
# 1. Install Xcode Command Line Tools
xcode-select --install

# 2. Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Install dependencies
brew install cmake gsl fftw lapack openblas bzip2 suite-sparse boost

# 4. Clone TOL repository
git clone https://github.com/m-marinucci/Tol.git
cd Tol

# 5. Build TOL
cd tol-master/tol
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(sysctl -n hw.ncpu)

# 6. Test installation
./tolcon -c 'WriteLn("TOL on macOS!");'
```

### Windows Installation

Choose your preferred toolchain:

- [Visual Studio 2019/2022](windows.md#visual-studio)
- [MinGW-w64](windows.md#mingw-w64)
- [WSL2 (Recommended)](windows.md#wsl2)

#### Quick Start (Visual Studio)

```powershell
# 1. Install Visual Studio 2019/2022 with C++ workload
# Download from: https://visualstudio.microsoft.com/

# 2. Install vcpkg for dependency management
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install

# 3. Install dependencies
.\vcpkg install gsl:x64-windows fftw3:x64-windows lapack:x64-windows bzip2:x64-windows

# 4. Clone TOL repository
git clone https://github.com/m-marinucci/Tol.git
cd Tol

# 5. Build with CMake
cd tol-master\tol
mkdir build
cd build
cmake .. -G "Visual Studio 16 2019" -A x64 -DCMAKE_TOOLCHAIN_FILE=[vcpkg root]\scripts\buildsystems\vcpkg.cmake
cmake --build . --config Release

# 6. Test installation
.\Release\tolcon.exe -c "WriteLn(\"TOL on Windows!\");"
```

### Docker Installation

For a platform-agnostic installation:

```bash
# 1. Pull the official TOL Docker image
docker pull tolproject/tol:latest

# 2. Run TOL interactively
docker run -it --rm tolproject/tol:latest

# 3. Or run a TOL script
docker run -it --rm -v $(pwd):/workspace tolproject/tol:latest /workspace/myscript.tol
```

See [Docker documentation](docker.md) for building custom images and advanced usage.

## Verification

After installation, verify TOL is working correctly:

### Basic Test

```bash
# Check version
tolcon --version

# Run simple calculation
tolcon -c 'WriteLn(2 + 2);'

# Expected output: 4
```

### Comprehensive Test

Create a file `test_install.tol`:

```tol
// test_install.tol - Comprehensive installation test
WriteLn("Testing TOL installation...");

// Test basic arithmetic
Real x = 3.14;
Real y = x * 2;
WriteLn("Arithmetic test: " + Text(y));  // Should print 6.28

// Test matrix operations
Matrix A = [[1, 2], [3, 4]];
Real det = MatDet(A);
WriteLn("Matrix determinant: " + Text(det));  // Should print -2

// Test time series
Serie data = [1, 2, 3, 4, 5];
Real mean = Mean(data);
WriteLn("Mean of series: " + Text(mean));  // Should print 3

// Test standard library
Include("stdlib/_tolcore.tol");
WriteLn("Standard library loaded successfully!");

WriteLn("\nAll tests passed! TOL is working correctly.");
```

Run the test:

```bash
tolcon test_install.tol
```

## Troubleshooting

### Common Issues

#### 1. CMake Cannot Find Dependencies

**Error**: `Could NOT find GSL (missing: GSL_LIBRARY GSL_INCLUDE_DIR)`

**Solution**:
```bash
# Linux: Specify library paths
cmake .. -DGSL_ROOT_DIR=/usr/local

# macOS: Use Homebrew paths
cmake .. -DCMAKE_PREFIX_PATH=/opt/homebrew

# Windows: Use vcpkg toolchain file
cmake .. -DCMAKE_TOOLCHAIN_FILE=[vcpkg]\scripts\buildsystems\vcpkg.cmake
```

#### 2. CLAPACK vs LAPACK Issues

**Error**: `undefined reference to 'clapack_dgetrf'`

**Solution**:
```bash
# Option 1: Install separate CLAPACK
sudo apt install libclapack-dev  # Debian/Ubuntu

# Option 2: Use LAPACK with C interface
cmake .. -DCLAPACK_LIBRARY=/usr/lib/liblapack.so
```

#### 3. Build Failures on macOS

**Error**: `ld: library not found for -lSystem`

**Solution**:
```bash
# Ensure Xcode command line tools are installed
xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept
```

#### 4. Windows Path Issues

**Error**: `'tolcon' is not recognized as an internal or external command`

**Solution**:
```powershell
# Add TOL to PATH
$env:Path += ";C:\path\to\tol\build\Release"

# Or use full path
C:\path\to\tol\build\Release\tolcon.exe
```

### Getting Help

If you encounter issues not covered here:

1. Check the [GitHub Issues](https://github.com/m-marinucci/Tol/issues)
2. Search [closed issues](https://github.com/m-marinucci/Tol/issues?q=is%3Aissue+is%3Aclosed)
3. Join the [TOL Community Discord](https://discord.gg/tol)
4. Post a new issue with:
   - Your platform and version
   - Complete error messages
   - Steps to reproduce
   - Output of `cmake --version` and compiler version

## Next Steps

After successful installation:

1. **Quick Start Tutorial**: Learn TOL basics in 15 minutes
   - [Read the Quick Start Guide](../quickstart.md)

2. **Example Programs**: Explore TOL capabilities
   - Browse `/tol-master/tol_tests/` for examples
   - Check the [Examples Documentation](../../examples/)

3. **IDE Setup**: Configure your development environment
   - [VS Code Extension](../../developer/ide-setup.md#vscode)
   - [Vim Configuration](../../developer/ide-setup.md#vim)
   - [Emacs Mode](../../developer/ide-setup.md#emacs)

4. **Learn More**:
   - [Language Reference](../../user-guide/language-basics.md)
   - [API Documentation](../../api/)
   - [Contributing Guide](../../../CONTRIBUTING.md)

---

**Note**: This guide is maintained by the TOL community. If you find errors or have improvements, please [contribute](../../../CONTRIBUTING.md)!