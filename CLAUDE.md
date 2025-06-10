# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

TOL (Time-Oriented Language) is a declarative, autoevaluative programming language with dynamic memory management and lazy evaluation, specifically designed for time-series analysis, mathematical computation, and statistical modeling. The codebase is primarily implemented in C++ with multiple build system support.

## Build Commands

### Building TOL Core on Linux/macOS

```bash
# Navigate to build scripts
cd tol-master/building/Linux

# Build main TOL interpreter
./build.sh tol Release

# Build with debug symbols
./build.sh tol Debug

# Build other components
./build.sh toltcl Release  # TOL-Tcl integration
./build.sh tolbase Release # TOL GUI (Tcl/Tk based)
./build.sh rtol Release    # R-TOL integration
```

### Building TOL Core on Windows (MinGW)

```batch
cd tol-master\building\MinGW
build.bat
```

### CMake Build (Alternative)

```bash
# Create build directory
mkdir build && cd build

# Configure with CMake
cmake ../tol-master/tol -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/tol

# Build and install
make
sudo make install
```

### Running Tests

```bash
# Run all tests
cd tol-master/tol_tests
./run_all_tests.sh

# Run specific test category
/usr/local/tol/bin/tolcon -v tol/_tolTester.tol
```

### Running TOL Programs

```bash
# Interactive console
/usr/local/tol/bin/tolcon

# Execute a TOL file
/usr/local/tol/bin/tol myprogram.tol

# Execute with verbose output
/usr/local/tol/bin/tolcon -v myprogram.tol
```

## Architecture

### Directory Structure

- **tol-master/**: Main TOL codebase
  - **tol/**: Core interpreter and language implementation
    - **bbasic/**: Basic data types and utilities (BText, BDate, BList, etc.)
    - **bmath/**: Mathematical libraries
      - **barith/**: Arithmetic operations
      - **blinalg/**: Linear algebra (BLAS/LAPACK integration)
      - **bstat/**: Statistical functions
      - **dcdflib/**: Probability distributions
      - **fftw/**: FFT operations
    - **bparser/**: TOL language parser and scanner
    - **btol/**: TOL-specific types (Serie, TimeSet, Matrix, Polynomial)
    - **lang/**: Language interpreter core
    - **stdlib/**: Standard library written in TOL
    - **dbdrivers/**: Database connectivity (ODBC, MySQL, PostgreSQL, SQLite)
  - **tolbase/**: GUI application (Tcl/Tk based)
  - **toltcl/**: Tcl integration layer
  - **vbtol/**: Visual Basic integration
  - **building/**: Build scripts for different platforms

### Core Components Architecture

1. **Type System**: TOL has a rich type system implemented in C++:
   - Numerical: `Real`, `Complex`, `Ratio`
   - Time-related: `Date`, `TimeSet`, `Serie` (time series), `CTime`
   - Mathematical: `Matrix`, `VMatrix` (sparse), `Polynomial`, `PolMat`
   - Structural: `Set`, `Text`, `Code`, `NameBlock`

2. **Parser/Interpreter**: 
   - Scanner (`bparser/scn.cpp`) tokenizes TOL source
   - Parser (`bparser/par.cpp`) builds AST
   - Interpreter (`lang/language.cpp`) executes code with lazy evaluation

3. **External Dependencies**:
   - GSL (GNU Scientific Library) for mathematical functions
   - FFTW for Fast Fourier Transforms
   - CHOLMOD/SuiteSparse for sparse matrix operations
   - LAPACK/BLAS for linear algebra
   - Boost for utilities and threading

### Key Implementation Details

- **Memory Management**: Custom memory handler with reference counting (`bbasic/bfsmem.cpp`)
- **Lazy Evaluation**: Expressions are stored as code objects and evaluated on demand
- **Time Series**: Specialized data structures for efficient time-indexed data
- **OIS (Object Information System)**: TOL's package/module system (`OIS/` directory)

### TOL Language Syntax Examples

```tol
// Function definition
Real Square(Real x) { x * x };

// Time series operations
Serie IDelta(Serie Ser) { DifEq(1/(1-B), Ser, 0) };

// Set operations
Set Range = For(1, 10, Real(Real n) { n });

// NameBlock (namespace/object)
NameBlock Stats = [[
  Real mean = 0;
  Real Calculate(Set data) { 
    Real sum = Sum(data);
    mean := sum / Card(data)
  }
]];
```

## Development Tips

1. **Include Paths**: When modifying C++ code, key headers are in:
   - `tol/tol_bcommon.h` - Common definitions
   - `tol/tol_blanguage.h` - Language interface
   - Type-specific headers in respective directories

2. **Adding New Functions**: 
   - C++ implementation goes in appropriate `btol/` subdirectory
   - Register in grammar files under `btol/bgrammar/`
   - Add TOL wrapper in `stdlib/` if needed

3. **Debugging**:
   - Use `tolcon -v` for verbose output
   - Check `tol_tests/` for test examples
   - Memory issues: Enable debug build for better diagnostics

4. **Standard Library**: Pure TOL implementations are in `tol/stdlib/`:
   - `_tolcore.tol` - Core library loader
   - `system/` - System utilities
   - `arima/` - ARIMA modeling functions
   - `various/` - Miscellaneous utilities