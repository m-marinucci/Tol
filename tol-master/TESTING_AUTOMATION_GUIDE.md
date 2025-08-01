# TOL Comprehensive Test Automation Guide

This guide describes the comprehensive test automation infrastructure implemented for the TOL project to ensure C++ compatibility, thread safety, and build optimization across different compilers and configurations.

## Overview

The test automation system consists of four main components:

1. **C++17/20 Compilation Test Suite** - Validates compilation across multiple compilers and C++ standards
2. **Multi-threaded Initialization Tests** - Ensures thread-safe operator registration
3. **Sanitizer Tests** - Detects memory leaks, race conditions, and undefined behavior
4. **Build Cache Optimization** - Optimizes build performance with ccache

## Quick Start

### Run All Tests Locally

```bash
# Run comprehensive tests with default settings
./scripts/run_comprehensive_cpp_tests.sh

# Run with specific compilers and C++ standards
./scripts/run_comprehensive_cpp_tests.sh --compilers "gcc-11 clang-14" --cpp-standards "17 20"

# Run without sanitizer tests (faster)
./scripts/run_comprehensive_cpp_tests.sh --no-sanitizer-tests

# Clean build and run all tests
./scripts/run_comprehensive_cpp_tests.sh --clean
```

### Build and Test Specific Configuration

```bash
# Build with C++17 and GCC 11
cd tol-master/tol
mkdir build-test && cd build-test
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=17 -DENABLE_TESTING=ON
make -j$(nproc)

# Run basic tests
./tolcon --version
./tolcon -c 'WriteLn("Test passed");'
```

## GitHub Actions Workflows

### 1. C++ Standards Compliance Test (`cpp-standards-test.yml`)

**Triggers:** Push to master/develop, Pull requests  
**Matrix:**
- Compilers: gcc-11, gcc-12, clang-14, clang-15
- C++ Standards: 17, 20

**Features:**
- Cross-compiler compatibility validation
- C++ standard compliance verification
- Build caching with ccache
- Thread safety testing integration
- Comprehensive error reporting

### 2. Sanitizer Tests (`sanitizer-tests.yml`)

**Triggers:** Push to master/develop, Pull requests, Daily schedule  
**Sanitizers:**
- AddressSanitizer (ASan) - Memory error detection
- ThreadSanitizer (TSan) - Data race detection
- UndefinedBehaviorSanitizer (UBSan) - Undefined behavior detection
- MemorySanitizer (MSan) - Uninitialized memory detection (Clang only)

**Features:**
- Comprehensive memory safety validation
- Thread safety verification
- Undefined behavior detection
- Cross-sanitizer compatibility testing

### 3. Build Cache Optimization (`build-cache-optimization.yml`)

**Triggers:** Push to master/develop, Pull requests, Weekly schedule  
**Tests:**
- Cache performance benchmarking
- Cache size optimization (500M, 1G, 2G, 4G)
- Distributed build simulation
- Parallelism analysis

**Features:**
- Build time measurement and optimization
- Cache hit ratio analysis
- Performance improvement metrics
- Parallelism effectiveness testing

## Test Components

### Thread Safety Tests

Located in `tol_tests/unit_tests/thread_safety/`

#### Files:
- `multi_threaded_init_test.cpp` - Mock-based concurrent initialization test
- `real_tol_thread_test.cpp` - Real TOL integration thread safety test
- `CMakeLists.txt` - Build configuration with sanitizer support

#### Usage:
```bash
cd tol_tests/unit_tests/thread_safety
mkdir build && cd build
cmake .. -DENABLE_THREAD_SANITIZER=ON
make
./multi_threaded_init_test --threads 16 --duration 5000
```

#### Test Options:
- `--threads N` - Number of concurrent threads
- `--duration N` - Test duration in milliseconds
- `--stress` - Enable stress testing mode
- `--repeated-init` - Test repeated initialization cycles

### Sanitizer Integration

#### AddressSanitizer (ASan)
- **Purpose:** Detect memory leaks, buffer overflows, use-after-free
- **Build flags:** `-fsanitize=address -fno-omit-frame-pointer`
- **Environment:** `ASAN_OPTIONS=detect_leaks=1:abort_on_error=1`

#### ThreadSanitizer (TSan)
- **Purpose:** Detect data races and thread safety issues
- **Build flags:** `-fsanitize=thread -fno-omit-frame-pointer`
- **Environment:** `TSAN_OPTIONS=abort_on_error=1:halt_on_error=1`

#### UndefinedBehaviorSanitizer (UBSan)
- **Purpose:** Detect undefined behavior patterns
- **Build flags:** `-fsanitize=undefined -fno-omit-frame-pointer`
- **Environment:** `UBSAN_OPTIONS=abort_on_error=1:print_stacktrace=1`

### Build Cache Configuration

#### ccache Setup
- **Cache size:** 2G (configurable)
- **Compression:** Level 6
- **Hit ratio target:** >80%
- **Integration:** CMake compiler launcher

#### Performance Metrics
- Cold build time measurement
- Warm build time measurement
- Cache effectiveness analysis
- Build parallelism optimization

## Local Development Workflow

### Prerequisites

Install required compilers and tools:

```bash
# Ubuntu/Debian
sudo apt-get install -y \
    gcc-11 g++-11 \
    clang-14 clang++-14 \
    cmake ccache \
    libgsl-dev liblapacke-dev libblas-dev \
    libfftw3-dev libbz2-dev libsuitesparse-dev \
    libsparsehash-dev libboost-all-dev \
    libltdl-dev zlib1g-dev valgrind

# macOS
brew install gcc@11 llvm cmake ccache \
    gsl lapack openblas fftw boost \
    suite-sparse zlib
```

### Development Testing Cycle

1. **Standard Development Testing:**
```bash
# Quick C++17 compatibility test with GCC
./scripts/run_comprehensive_cpp_tests.sh \
    --compilers "gcc-11" \
    --cpp-standards "17" \
    --no-sanitizer-tests \
    --no-performance-tests
```

2. **Pre-commit Testing:**
```bash
# Full compatibility test
./scripts/run_comprehensive_cpp_tests.sh \
    --compilers "gcc-11 clang-14" \
    --cpp-standards "17 20"
```

3. **Pre-release Testing:**
```bash
# Comprehensive test with all sanitizers
./scripts/run_comprehensive_cpp_tests.sh --clean
```

### Interpreting Results

#### Success Indicators
- ✅ All compilation tests pass across compilers and standards
- ✅ Thread safety tests show no race conditions
- ✅ Sanitizer tests detect no memory/thread issues
- ✅ Build cache achieves >80% hit ratio

#### Failure Investigation
- Check `test-results/comprehensive_cpp_tests.log` for detailed logs
- Review individual result files in `test-results/`
- Use sanitizer output for debugging memory/thread issues
- Verify C++ standard compliance requirements

## CI/CD Integration

### Workflow Triggers
- **Push events:** master, develop branches
- **Pull requests:** All branches to master/develop
- **Scheduled runs:** 
  - Sanitizer tests: Daily at 2 AM UTC
  - Cache optimization: Weekly on Sunday at 4 AM UTC

### Artifact Retention
- **Test results:** 7-30 days
- **Build logs:** 7 days
- **Performance reports:** 30-90 days
- **Summary reports:** 30 days

### Status Reporting
- Workflow status badges in README
- Detailed test result artifacts
- Performance trend analysis
- Automated issue detection

## Advanced Configuration

### Custom Sanitizer Configuration

Create custom sanitizer builds:

```bash
# Custom ASan build with specific options
cd tol-master/tol
mkdir build-custom-asan && cd build-custom-asan
cmake .. \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS="-g -O1 -fsanitize=address -fsanitize-address-use-after-scope" \
    -DCMAKE_EXE_LINKER_FLAGS="-fsanitize=address"

export ASAN_OPTIONS="detect_leaks=1:check_initialization_order=1:strict_init_order=1"
make -j$(nproc)
./tolcon -c 'WriteLn("Custom ASan test");'
```

### Performance Tuning

Optimize build performance:

```bash
# Enable ccache with custom configuration
export CCACHE_MAXSIZE=4G
export CCACHE_COMPRESS=1
export CCACHE_COMPRESSLEVEL=9
ccache --set-config=hash_dir=false

# Use Ninja for faster builds (if available)
cmake .. -GNinja -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
ninja -j$(nproc)
```

### Thread Safety Debugging

For detailed thread safety analysis:

```bash
# Build with ThreadSanitizer and debug symbols
cmake .. \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_CXX_FLAGS="-g -O0 -fsanitize=thread -fno-omit-frame-pointer"

export TSAN_OPTIONS="report_bugs=1:history_size=7:report_signal_unsafe=1:force_seq_cst_atomics=1"

# Run specific thread tests
cd tol_tests/unit_tests/thread_safety/build
./multi_threaded_init_test --threads 4 --duration 10000 --stress
```

## Troubleshooting

### Common Issues

1. **Compilation Failures with C++17/20:**
   - Check for deprecated features (`register` keyword)
   - Verify template specialization syntax
   - Update legacy C++ constructs

2. **Thread Safety Test Failures:**
   - Review operator registration order
   - Check for static initialization race conditions
   - Verify thread-local storage usage

3. **Sanitizer False Positives:**
   - Use suppression files (`.github/workflows/valgrind.supp`)
   - Configure sanitizer options appropriately
   - Check for library compatibility issues

4. **Build Cache Performance Issues:**
   - Verify ccache installation and configuration
   - Check disk space for cache directory
   - Review cache hit ratio and adjust size

### Debug Commands

```bash
# Verbose CMake configuration
cmake .. -DCMAKE_VERBOSE_MAKEFILE=ON

# Detailed sanitizer output
export ASAN_OPTIONS="verbosity=1:halt_on_error=0"
export TSAN_OPTIONS="verbosity=1:report_bugs=1"

# ccache statistics and debugging
ccache --show-config
ccache --show-stats
ccache --show-log-stats

# Thread safety debugging
gdb --args ./multi_threaded_init_test --threads 2 --duration 1000
```

## Contributing

When adding new tests or modifying the test infrastructure:

1. **Follow the established patterns** in existing workflows
2. **Add appropriate documentation** for new test cases
3. **Ensure backward compatibility** with existing configurations
4. **Test locally** before submitting pull requests
5. **Update this guide** when adding new features

### Adding New Test Cases

1. Create test files in appropriate directories
2. Update CMakeLists.txt to include new tests
3. Add workflow integration if needed
4. Document usage and expected behavior

### Modifying Workflows

1. Test workflow changes in a feature branch
2. Verify artifact generation and retention
3. Ensure proper error handling and reporting
4. Update status badges and documentation

---

This comprehensive test automation system ensures that TOL maintains high code quality, compatibility, and performance across different platforms and configurations. Regular use of these tests helps prevent regressions and maintains the project's stability as it evolves.