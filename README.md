# TOL - Time-Oriented Language

TOL (Time-Oriented Language) is a powerful programming language specifically
designed for time-series analysis, statistical modeling, and mathematical
computations.
Originally developed for advanced data analysis and econometric modeling,
TOL provides a declarative environment that is autoevaluative (i.e.,
expressions are automatically evaluated as they are defined,
similar to languages like Lisp),
with dynamic memory management and lazy evaluation.

## Overview

TOL is a domain-specific language that excels in:

- **Time-series analysis** with native support for temporal data structures
- **Statistical modeling** including ARIMA, Bayesian methods, and Monte Carlo simulations
- **Mathematical computations** with integrated linear algebra and numerical analysis
- **Signal processing** with FFT support via FFTW integration
- **Econometric modeling** with specialized tools for economic data analysis

## Key Features

### Language Characteristics

- **Declarative paradigm** with functional programming elements
- **Autoevaluative execution** with lazy evaluation
- **Dynamic typing** with a strong type system
- **Native time-oriented operations** for efficient temporal data handling
- **Integrated mathematical libraries** (GSL, LAPACK, BLAS, FFTW, CHOLMOD)

### Core Data Types

- **Numerical:** `Real`, `Complex`, `Ratio` (rational numbers)
- **Time-Related:** `Date`, `TimeSet`, `Serie` (time series), `CTime` (calendar time)
- **Mathematical:** `Matrix`, `VMatrix` (sparse matrices), `Polynomial`, `PolMat` (polynomial matrices)
- **Structural:** `Set`, `Text`, `Code`, `NameBlock` (namespaces)

## Recent Improvements

- **Fixed static initialization crashes** that prevented TOL from running (PR #43, #47)
- **Full macOS compatibility** including Apple Silicon support
- **ARM64 Linux support** for Raspberry Pi and cloud instances
- **Cleaned repository structure** with comprehensive .gitignore
- **Cross-platform development** documentation for VM-based workflows

## Installation

### From This GitHub Repository

```bash
git clone https://github.com/m-marinucci/Tol.git
cd Tol
```

### From Original GitLab Source

```bash
git clone https://gitlab.com/tol-project/tol.git
cd tol
```

### Building from Source

TOL has been successfully built and tested on:

- ✅ Linux (x86_64, ARM64)
- ✅ macOS (Intel, Apple Silicon)
- ✅ Windows (MinGW, Visual Studio)

#### Prerequisites

**Linux (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install -y build-essential cmake git \
    libgsl-dev liblapacke-dev libblas-dev libfftw3-dev \
    libbz2-dev libsuitesparse-dev libsparsehash-dev
```

**macOS:**

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install dependencies via Homebrew
brew install cmake gsl lapack openblas fftw bzip2 suite-sparse
```

**Windows:**

- Install MinGW-w64 or Visual Studio 2019+
- Install CMake
- Dependencies can be installed via vcpkg or compiled manually

#### Build Instructions

**Linux/macOS:**

```bash
cd tol-master/tol
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)  # Linux
make -j$(sysctl -n hw.ncpu)  # macOS

# Test the build
./tolcon -c 'WriteLn("Hello from TOL!");'

# Optional: Install system-wide
sudo make install
```

**Windows (MinGW):**

```bash
cd tol-master\building\MinGW
build.bat
```

**Windows (Visual Studio):**

```powershell
cd tol-master\tol
mkdir build
cd build
cmake .. -G "Visual Studio 16 2019"
cmake --build . --config Release
```

#### Using Autotools

```bash
cd tol-master/tol
./bootstrap
./configure
make
sudo make install
```

### Dependencies

To install common build dependencies (including LAPACK for linear algebra) on a fresh system, run:

```bash
scripts/setup_build_env.sh
```

If the official TOL package repository is unavailable, download the default
packages (StdLib and TclCore) using the helper script. It will query the
Internet Archive's Wayback Machine API for the latest archived packages if the
official server cannot be reached:

```bash
scripts/fetch_default_packages.sh
```

These packages contain the standard library and Tcl/Tk integration. Building
without them removes many of TOL's mathematical functions, time series tools,
and GUI features.

TOL requires the following external libraries:

- **GSL** (GNU Scientific Library) - Core mathematical functions
- **FFTW** - Fast Fourier Transform operations
- **CHOLMOD** - Sparse matrix operations
- **LAPACK/BLAS** - Linear algebra routines
- **Boost** - C++ utilities and threading
- **Tcl/Tk** (optional) - For GUI components

## Quick Start

### Basic Syntax Examples

```tol
// Function definition
Real func(Real param) { param * 2 };

// Time series operations
Serie IDelta(Serie Ser) { DifEq(1/(1-B), Ser, 0) };

// Set operations and iteration
Set Plot(Code f, Real from, Real until, Real points) {
  Real d = (until-from)/points;
  Set X = For(0,points,Real(Real n){from+n*d});
  Set XY = EvalSet(X, Set(Real x){SetOfReal(x,f(x))});
  XY
};

// NameBlock (namespace/object) definition
NameBlock Timer = [[
  Real start = Now();
  Real Elapsed() { Now() - start };
]];
```

### Running TOL

After installation, you can run TOL programs using:

```bash
tolcon your_script.tol
```

Or start an interactive session:

```bash
tolcon
```

## Project Structure

- `tol-master/` - Main TOL source code
  - `tol/` - Core interpreter and language implementation
  - `tolbase/` - GUI and visualization components
  - `tol_tests/` - Comprehensive test suite
  - `doc/` - Documentation and manuals
  - `building/` - Build scripts for different platforms

## Documentation

- [TOL User Manual](tol-master/doc/general/TOL%20User%20Manual.pdf)
- [Basic TOL Manual (Spanish)](tol-master/doc/general/Manual%20basico%20de%20TOL.pdf)
- API documentation available in `tol-master/doc/`
- Additional module references in `docs/api_reference/`

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- Code style and conventions
- Testing requirements
- Pull request process

## Future Developments

### TOL MCP Server

We are developing an MCP (Model Context Protocol) server to provide seamless, natural language access to TOL's capabilities. This will enable:

- Natural language queries for time-series analysis
- Automated code generation from user intent
- Integration with modern AI assistants
- Simplified access to TOL's powerful features

See [TOL_MCP_SERVER_STRATEGIC_PLAN.md](TOL_MCP_SERVER_STRATEGIC_PLAN.md) for details.

## License

TOL is distributed under the terms specified in the [LICENSE](LICENSE) file.

## Documentation

### API Reference

Comprehensive API documentation is available in the [`docs/api/`](docs/api/) directory:

- **[Complete API Index](docs/api/README.md)** - Overview of all 12 TOL modules
- **Core Computational**: Mathematical operations, statistical analysis, time-series processing
- **Data Handling**: Database connectivity, file I/O, system integration
- **Visualization**: Plotting functions, GUI visualization tools
- **Integration**: Java API, communication protocols, remote access
- **MCP Compatible**: 8 modules support natural language interaction

### Documentation Features

- **YAML Front-matter**: Machine-readable metadata for MCP server integration
- **User Personas**: Content tailored for novices, experts, statisticians, and integrators
- **Code Examples**: Tested TOL code samples with real-world use cases
- **Cross-References**: Links between related modules and external resources

## Support

- **Issues:** Report bugs and request features via [GitHub Issues](https://github.com/InverenceBBS/Tol/issues)
- **Discussions:** Join our community discussions for questions and ideas
- **API Documentation:** Comprehensive module references in [`docs/api/`](docs/api/)

## Acknowledgments

TOL was originally developed by the Bayes Inference research group. Special thanks to all contributors who have helped make TOL a powerful tool for time-oriented programming and analysis.
