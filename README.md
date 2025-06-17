# TOL - Time-Oriented Language

TOL (Time-Oriented Language) is a powerful programming language specifically designed for time-series analysis, statistical modeling, and mathematical computations. Originally developed for advanced data analysis and econometric modeling, TOL provides a declarative environment that is autoevaluative (i.e., expressions are automatically evaluated as they are defined, similar to languages like Lisp), with dynamic memory management and lazy evaluation.

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

## Installation

### From Original GitLab Source
```bash
git clone https://gitlab.com/tol-project/tol.git
cd tol
```

### From This GitHub Repository
```bash
git clone https://github.com/m-marinucci/Tol.git
cd Tol
```

### Building from Source

TOL supports multiple build systems:

#### Using CMake (Recommended)
```bash
cd tol-master
mkdir build && cd build
cmake ..
make
sudo make install
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

## Support

- **Issues:** Report bugs and request features via [GitHub Issues](https://github.com/InverenceBBS/Tol/issues)
- **Discussions:** Join our community discussions for questions and ideas
- **Documentation:** Comprehensive guides available in the `doc/` directory

## Acknowledgments

TOL was originally developed by the Bayes Inference research group. Special thanks to all contributors who have helped make TOL a powerful tool for time-oriented programming and analysis.


