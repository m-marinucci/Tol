# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

TOL (Time-Oriented Language) is a declarative, autoevaluative programming language with dynamic memory management and lazy evaluation, specifically designed for time-series analysis, mathematical computation, and statistical modeling. The codebase is primarily implemented in C++ with multiple build system support.

## Current Project Status

- **Linux Build**: ✅ 100% success (PR #26 fixed major compatibility issues)
- **Windows Build**: ✅ Fully maintained
- **macOS Build**: ✅ Native support
- **Testing Framework**: ✅ Comprehensive cross-platform framework (NUM-11)
- **CI/CD Pipeline**: ✅ GitHub Actions ready (NUM-17)
- **Documentation**: ✅ Complete Linux build guides (NUM-12)

## Build Commands

### Quick Start (Linux)

```bash
# Install dependencies (Ubuntu/Debian)
curl -fsSL https://raw.githubusercontent.com/m-marinucci/Tol/master/scripts/install-deps-ubuntu.sh | bash

# Clone and build
git clone https://github.com/m-marinucci/Tol.git
cd Tol
mkdir build && cd build
cmake ..
make -j$(nproc)

# Test installation
make test
```

### CMake Build Options

```bash
# Debug build
cmake .. -DCMAKE_BUILD_TYPE=Debug

# Release build with custom install prefix
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/tol

# Enable testing framework
cmake .. -DENABLE_TESTING=ON -DTOL_TESTS_ENABLE_PERFORMANCE=ON

# Build specific targets
make tol          # Core interpreter only
make tolbase      # GUI application
make test_unit    # Run unit tests only
```

### Alternative Build Methods

```bash
# Using build scripts (if available)
cd tol-master/building/Linux
./build.sh tol Release

# Windows MinGW build
cd tol-master\building\MinGW
build.bat
```

## Testing Commands

### Using CMake/CTest

```bash
# Run all tests
make test

# Run specific test categories
make test_unit          # Unit tests
make test_performance   # Performance benchmarks
make test_integration   # Integration tests
make test_platform      # Platform-specific tests
make test_memory        # Memory leak detection

# Generate comprehensive reports
make test_reports       # Creates JSON, XML, HTML, JUnit XML reports
```

### Direct Test Execution

```bash
# Run comprehensive test suite
cd tol_tests
./run_comprehensive_tests.sh

# Run specific test with TOL interpreter
tolcon -v unit_tests/bmath/test.tol

# Run with custom output directory
export TOL_TEST_OUTPUT_DIR="./my_test_results"
tolcon -v enhanced_test_runner.tol
```

### Single Test Execution

```bash
# Run a single test file
tolcon -v tol_tests/unit_tests/text_type/test.tol

# Run with verbose output
tolcon -v -c "WriteLn(\"Running test\"); Include(\"test.tol\")"
```

## Architecture

### Core Components

1. **Type System** (C++ Implementation):
   - Numerical: `Real`, `Complex`, `Ratio`
   - Time-related: `Date`, `TimeSet`, `Serie`, `CTime`
   - Mathematical: `Matrix`, `VMatrix`, `Polynomial`, `PolMat`
   - Structural: `Set`, `Text`, `Code`, `NameBlock`

2. **Parser/Interpreter Chain**:
   - Scanner: `bparser/scn.cpp` → Tokenization
   - Parser: `bparser/par.cpp` → AST generation
   - Interpreter: `lang/language.cpp` → Lazy evaluation engine

3. **Memory Management**:
   - Custom allocator with reference counting: `bbasic/bfsmem.cpp`
   - Fixed-size memory pools for performance
   - Automatic garbage collection

4. **Module System (OIS)**:
   - Package management: `OIS/oisloader.cpp`
   - ZIP archive support: `OIS/oisstream_zip.cpp`
   - Interactive package browser: `OIS/oisinteractive.cpp`

### Key Dependencies

- **GSL**: GNU Scientific Library for mathematical functions
- **FFTW3**: Fast Fourier Transform operations
- **BLAS/LAPACK**: Linear algebra operations
- **Boost**: Utilities, threading, filesystem
- **CHOLMOD/SuiteSparse**: Sparse matrix operations (optional)

### Known Issues and Workarounds

1. **Build Order Dependencies** (PR #35):
   - `bbasic` must be built before `PackArchive` and `OIS`
   - Fixed in CMakeLists.txt build order

2. **C++ Compatibility** (PR #26, PR #40):
   - Deprecated `register` keyword usage
   - Thread safety issues with static initialization
   - Character encoding problems with non-ASCII

3. **Platform-Specific Code**:
   - Windows: Check `win_tolinc.h` includes
   - Linux: Ensure all dependencies installed via scripts

## TOL Language Syntax

### Basic Examples

```tol
// Variable declaration and function definition
Real x = 3.14;
Real Square(Real x) { x * x };

// Time series operations
Serie prices = ReadSerie("data.csv");
Serie returns = Log(prices/prices.B);

// Matrix operations
Matrix A = [[1,2],[3,4]];
Matrix B = Inv(A);
Real det = MatDet(A);

// NameBlock (namespace/object)
NameBlock Model = [[
  Serie data;
  Real Forecast(Real periods) {
    // ARIMA modeling
    SetOfSerie arima = ARIMA::Estimate(data, 1, 1, 1);
    Serie forecast = ARIMA::Forecast(arima, periods)
  }
]];
```

## Development Workflow

### Adding New C++ Functions

1. Implement in appropriate module directory:
   - Math functions → `bmath/barith/` or `bmath/bfunct/`
   - Type operations → `btol/[type]_type/`
   - System functions → `bbasic/`

2. Register in grammar:
   - Add to `btol/bgrammar/[module].y`
   - Update `btol/bgrammar/[module]_internal.tol`

3. Add TOL wrapper if needed:
   - Create in `stdlib/system/` or appropriate module
   - Include in `stdlib/_tolcore.tol` initialization

### Debugging

```bash
# Enable verbose output
tolcon -v script.tol

# Debug build for better diagnostics
cmake .. -DCMAKE_BUILD_TYPE=Debug
gdb tolcon

# Memory debugging
valgrind --leak-check=full tolcon script.tol

# Check test examples
ls tol_tests/unit_tests/*/test.tol
```

### Code Style

- C++ files: 2-space indentation, opening braces on same line
- TOL files: 2-space indentation, semicolons optional
- Headers: Use include guards, not #pragma once
- Comments: Use `//` for single line, `/* */` for multi-line

## CI/CD Integration

The project includes GitHub Actions workflows (PR #37, #39):

```yaml
# Triggers on push to master/develop and PRs
# Builds on Linux (GCC 9-12) and Windows (MSVC)
# Runs full test suite with coverage
# Generates documentation with Doxygen
# Creates release packages with checksums
```

## Important File Locations

- Main CMakeLists.txt: `tol/CMakeLists.txt`
- Test framework: `tol_tests/enhanced_test_framework.tol`
- Linux build scripts: `scripts/install-deps-*.sh`
- Grammar definitions: `tol/btol/bgrammar/*.y`
- Standard library: `tol/stdlib/_tolcore.tol`
- Memory handler: `tol/bbasic/tol_bfsmem.h`