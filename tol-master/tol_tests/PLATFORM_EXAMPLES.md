# TOL Testing Framework - Platform Examples

**Issue**: NUM-11 - P0: Comprehensive Cross-Platform Testing Framework  
**Author**: Massimiliano Marinucci  
**Date**: 2025-07-06  

## Overview

This document provides detailed examples for running the TOL Comprehensive Testing Framework on different platforms: Linux, Windows, and macOS.

## Linux Examples

### Prerequisites

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install cmake build-essential python3 bc

# Verify TOL installation
which tolcon
tolcon --version
```

### Basic Execution

```bash
# Clone and navigate to test directory
cd tol-master/tol_tests

# Method 1: Using CMake (Recommended)
mkdir build && cd build
cmake ..
make

# Run all tests
make test

# Run with verbose output
ctest --verbose

# Run specific test categories
make test_unit
make test_performance
make test_integration
make test_platform
make test_memory

# Run tests in parallel
make test_parallel

# Generate reports
make test_reports
```

### Advanced Linux Examples

```bash
# Custom CMake configuration
cmake -DTOL_TESTS_ENABLE_PERFORMANCE=ON \
      -DTOL_TESTS_ENABLE_MEMORY=ON \
      -DTOL_TESTS_PARALLEL=ON \
      -DTOL_TESTS_UNIT_TIMEOUT=600 \
      ..

# Run tests with custom filters
ctest -L "unit" --output-on-failure
ctest -L "performance" --parallel 4
ctest -R "matrix" --verbose

# Method 2: Using shell script
./run_comprehensive_tests.sh

# Method 3: Manual execution
export TOL_TEST_OUTPUT_DIR="./test_results"
tolcon -v enhanced_test_runner.tol
```

### Linux CI/CD Integration

```yaml
# .github/workflows/linux-tests.yml
name: Linux Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install cmake build-essential python3 bc
    - name: Setup TOL
      run: |
        # Install TOL (adjust path as needed)
        sudo cp tol/bin/tolcon /usr/local/bin/
    - name: Run tests
      run: |
        cd tol_tests
        mkdir build && cd build
        cmake ..
        make test
    - name: Generate reports
      run: |
        cd tol_tests/build
        make test_reports
    - name: Upload test results
      uses: actions/upload-artifact@v2
      with:
        name: linux-test-results
        path: tol_tests/build/test_results/
```

## Windows Examples

### Prerequisites

```cmd
REM Install Visual Studio Build Tools or Visual Studio
REM Install CMake from https://cmake.org/
REM Install Python 3 from https://python.org/

REM Verify TOL installation
where tolsh.exe
tolsh.exe --version
```

### Basic Execution

```cmd
REM Navigate to test directory
cd tol-master\tol_tests

REM Method 1: Using CMake (Recommended)
mkdir build && cd build
cmake ..
cmake --build .

REM Run all tests
ctest

REM Run with verbose output
ctest --verbose

REM Run specific test categories
ctest -L unit
ctest -L performance
ctest -L integration
ctest -L platform
ctest -L memory

REM Generate reports
cmake --build . --target test_reports
```

### Advanced Windows Examples

```cmd
REM Custom CMake configuration
cmake -DTOL_TESTS_ENABLE_PERFORMANCE=ON ^
      -DTOL_TESTS_ENABLE_MEMORY=ON ^
      -DTOL_TESTS_PARALLEL=ON ^
      -DTOL_TESTS_UNIT_TIMEOUT=600 ^
      ..

REM Run tests with custom filters
ctest -L "unit" --output-on-failure
ctest -L "performance" --parallel 4
ctest -R "matrix" --verbose

REM Method 2: Using batch script
run_comprehensive_tests.bat

REM Method 3: Manual execution
set TOL_TEST_OUTPUT_DIR=.\test_results
tolsh.exe -v enhanced_test_runner.tol
```

### Windows PowerShell Examples

```powershell
# Navigate to test directory
Set-Location tol-master\tol_tests

# Using CMake with PowerShell
New-Item -ItemType Directory -Name build
Set-Location build
cmake ..
cmake --build .

# Run tests
ctest

# Run specific categories
ctest -L "unit"
ctest -L "performance"

# Generate reports
cmake --build . --target test_reports

# Check results
Get-ChildItem test_results\reports\
```

### Windows CI/CD Integration

```yaml
# .github/workflows/windows-tests.yml
name: Windows Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v2
    - name: Setup Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.x'
    - name: Setup TOL
      run: |
        # Install TOL (adjust path as needed)
        copy windows\ActiveTol\bin\tolsh.exe C:\Windows\System32\
    - name: Run tests
      run: |
        cd tol_tests
        mkdir build
        cd build
        cmake ..
        cmake --build .
        ctest
    - name: Generate reports
      run: |
        cd tol_tests\build
        cmake --build . --target test_reports
    - name: Upload test results
      uses: actions/upload-artifact@v2
      with:
        name: windows-test-results
        path: tol_tests\build\test_results\
```

## macOS Examples

### Prerequisites

```bash
# Install Xcode command line tools
xcode-select --install

# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install cmake python3 coreutils

# Verify TOL installation
which tolcon
tolcon --version
```

### Basic Execution

```bash
# Navigate to test directory
cd tol-master/tol_tests

# Method 1: Using CMake (Recommended)
mkdir build && cd build
cmake ..
make

# Run all tests
make test

# Run with verbose output
ctest --verbose

# Run specific test categories
make test_unit
make test_performance
make test_integration
make test_platform
make test_memory

# Run tests in parallel
make test_parallel

# Generate reports
make test_reports
```

### Advanced macOS Examples

```bash
# Custom CMake configuration
cmake -DTOL_TESTS_ENABLE_PERFORMANCE=ON \
      -DTOL_TESTS_ENABLE_MEMORY=ON \
      -DTOL_TESTS_PARALLEL=ON \
      -DTOL_TESTS_UNIT_TIMEOUT=600 \
      ..

# Run tests with custom filters
ctest -L "unit" --output-on-failure
ctest -L "performance" --parallel $(sysctl -n hw.ncpu)
ctest -R "matrix" --verbose

# Method 2: Using macOS-specific shell script
./run_comprehensive_tests_macos.sh

# Method 3: Manual execution
export TOL_TEST_OUTPUT_DIR="./test_results"
tolcon -v enhanced_test_runner.tol
```

### macOS-Specific Features

```bash
# Use macOS system information in tests
system_profiler SPHardwareDataType
sysctl -n machdep.cpu.brand_string
sysctl -n hw.memsize

# Monitor memory usage during tests
top -l 1 -s 0 | grep PhysMem

# Use macOS-specific timeout command
gtimeout 300 tolcon -v test.tol
```

### macOS CI/CD Integration

```yaml
# .github/workflows/macos-tests.yml
name: macOS Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v2
    - name: Install dependencies
      run: |
        brew install cmake python3 coreutils
    - name: Setup TOL
      run: |
        # Install TOL (adjust path as needed)
        sudo cp tol/bin/tolcon /usr/local/bin/
    - name: Run tests
      run: |
        cd tol_tests
        mkdir build && cd build
        cmake ..
        make test
    - name: Generate reports
      run: |
        cd tol_tests/build
        make test_reports
    - name: Upload test results
      uses: actions/upload-artifact@v2
      with:
        name: macos-test-results
        path: tol_tests/build/test_results/
```

## Cross-Platform Examples

### Docker Examples

```dockerfile
# Dockerfile.linux
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y cmake build-essential python3 bc
COPY . /tol
WORKDIR /tol/tol_tests
RUN mkdir build && cd build && cmake .. && make
CMD ["make", "test"]
```

```dockerfile
# Dockerfile.windows
FROM mcr.microsoft.com/windows/servercore:ltsc2019
# Install Visual Studio Build Tools, CMake, Python
COPY . C:\tol
WORKDIR C:\tol\tol_tests
RUN mkdir build && cd build && cmake .. && cmake --build .
CMD ["ctest"]
```

### Vagrant Examples

```ruby
# Vagrantfile
Vagrant.configure("2") do |config|
  # Linux box
  config.vm.define "linux" do |linux|
    linux.vm.box = "ubuntu/20.04"
    linux.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y cmake build-essential python3 bc
      cd /vagrant/tol_tests
      mkdir -p build && cd build
      cmake .. && make test
    SHELL
  end

  # Windows box
  config.vm.define "windows" do |windows|
    windows.vm.box = "gusztavvargadr/windows-10"
    windows.vm.provision "shell", inline: <<-SHELL
      # Install dependencies and run tests
      cd C:\vagrant\tol_tests
      mkdir build
      cd build
      cmake ..
      cmake --build .
      ctest
    SHELL
  end
end
```

### Performance Comparison

```bash
# Run performance tests on all platforms and compare
# Linux
cd tol_tests/build
make test_performance > linux_perf.log

# Windows
cd tol_tests\build
ctest -L performance > windows_perf.log

# macOS
cd tol_tests/build
make test_performance > macos_perf.log

# Compare results
python3 scripts/compare_performance.py linux_perf.log windows_perf.log macos_perf.log
```

## Troubleshooting

### Common Issues

1. **TOL Binary Not Found**
   ```bash
   # Linux/macOS
   export PATH=$PATH:/path/to/tol/bin
   
   # Windows
   set PATH=%PATH%;C:\path\to\tol\bin
   ```

2. **CMake Configuration Issues**
   ```bash
   # Clear CMake cache
   rm -rf build/
   mkdir build && cd build
   cmake .. -DCMAKE_VERBOSE_MAKEFILE=ON
   ```

3. **Test Timeouts**
   ```bash
   # Increase timeout values
   cmake -DTOL_TESTS_UNIT_TIMEOUT=600 ..
   ```

4. **Memory Issues**
   ```bash
   # Monitor memory usage
   # Linux
   free -h
   
   # macOS
   vm_stat
   
   # Windows
   wmic OS get TotalVisibleMemorySize,FreePhysicalMemory
   ```

### Platform-Specific Issues

- **Linux**: Ensure sufficient permissions for test execution
- **Windows**: Use appropriate path separators and escape characters
- **macOS**: Install Xcode command line tools and use Homebrew for dependencies

---

**Contact**: mmarinucci@numinate.com  
**Linear Issue**: https://linear.app/numinate/issue/NUM-11  
**Last Updated**: 2025-07-06
