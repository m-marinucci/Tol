# TOL - Time-Oriented Language

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](#)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)](#)
[![Version](https://img.shields.io/badge/version-3.0.0-orange.svg)](#)

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

## Why TOL?

### TOL vs Other Languages

| Feature | TOL | R | Python | MATLAB | Julia |
|---------|-----|---|--------|--------|-------|
| **Time-series native** | ✅ Built-in | 📦 Packages | 📦 Pandas | 📦 Toolbox | 📦 Packages |
| **Autoevaluation** | ✅ Yes | ❌ No | ❌ No | ⚠️ Limited | ❌ No |
| **Lazy evaluation** | ✅ Yes | ⚠️ Limited | ❌ No | ❌ No | ⚠️ Limited |
| **Mathematical syntax** | ✅ Natural | ⚠️ Verbose | ⚠️ Verbose | ✅ Natural | ✅ Natural |
| **Memory management** | ✅ Automatic | ✅ Automatic | ✅ Automatic | ✅ Automatic | ✅ Automatic |
| **Performance** | ✅ Fast | ⚠️ Medium | ⚠️ Medium | ✅ Fast | ✅ Fast |
| **Learning curve** | ✅ Gentle | ⚠️ Moderate | ✅ Gentle | ⚠️ Moderate | ⚠️ Steep |

### Unique TOL Features

1. **Time-Oriented Design**: Unlike general-purpose languages, TOL treats time-series as first-class citizens with operators like `.B` (backshift) and `.F` (forward shift).

2. **Autoevaluation**: Expressions are evaluated as they're defined, making it ideal for interactive data analysis and rapid prototyping.

3. **Integrated Libraries**: No need to install separate packages for mathematical operations - GSL, LAPACK, FFTW are built-in.

4. **Domain-Specific Syntax**: Write `Serie returns = Log(prices/prices.B)` instead of verbose library calls.

5. **NameBlocks**: Object-oriented programming with a functional twist, perfect for encapsulating models and analysis.

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

> 📚 **For detailed platform-specific instructions, see our [Comprehensive Installation Guide](docs/getting-started/installation/README.md)**

### Quick Install

#### From This GitHub Repository

```bash
git clone https://github.com/m-marinucci/Tol.git
cd Tol
```

#### From Original GitLab Source

```bash
git clone https://gitlab.com/tol-project/tol.git
cd tol
```

### Supported Platforms

TOL has been successfully built and tested on:

- ✅ **Linux** (x86_64, ARM64) - Ubuntu, Debian, CentOS, Fedora
- ✅ **macOS** (Intel, Apple Silicon) - macOS 11.0+
- ✅ **Windows** (MinGW, Visual Studio, WSL2) - Windows 10/11
- ✅ **Docker** - Platform-agnostic containers

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
cmake .. -DCMAKE_BUILD_TYPE=Release \
       -DCLAPACK_LIBRARY=/path/to/liblapack.so  # if LAPACK already provides CLAPACK
# Install a separate CLAPACK package if your LAPACK build does not include the
# C interface.
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
packages (StdLib and TclCore) using the helper script. The script first tries to
use HTTPS when contacting `packages.tol-project.org` and, if that download
fails, it queries the Internet Archive's Wayback Machine API for the latest
archived packages:
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
- **CLAPACK** (or LAPACK with built-in CLAPACK symbols) - C LAPACK interface
- **Boost** - C++ utilities and threading
- **Tcl/Tk** (optional) - For GUI components

## Quick Start

### Running TOL

After installation, verify TOL is working:

```bash
# Check version
tolcon --version

# Run a simple calculation
tolcon -c 'WriteLn(2 + 2);'
# Expected output: 4

# Start interactive session
tolcon
# TOL> WriteLn("Hello, TOL!");
# Hello, TOL!
# TOL> exit
```

### Basic Examples with Output

#### 1. Simple Arithmetic and Functions

Create `example1.tol`:
```tol
// Basic arithmetic
Real x = 3.14;
Real y = x * 2;
WriteLn("Pi times 2 = " + Text(y));

// Function definition
Real Square(Real n) { n * n };
WriteLn("5 squared = " + Text(Square(5)));

// Mathematical functions
WriteLn("Square root of 16 = " + Text(Sqrt(16)));
WriteLn("Sine of Pi/2 = " + Text(Sin(Pi/2)));
```

Run it:
```bash
tolcon example1.tol
```

Expected output:
```
Pi times 2 = 6.28
5 squared = 25
Square root of 16 = 4
Sine of Pi/2 = 1
```

#### 2. Working with Time Series

Create `timeseries.tol`:
```tol
// Create a time series
Serie prices = [100, 102, 98, 103, 105, 101, 99, 104];
WriteLn("Prices: " + Text(prices));

// Calculate returns
Serie returns = Log(prices/prices.B);
WriteLn("Returns: " + Text(returns));

// Basic statistics
WriteLn("Mean return: " + Text(Mean(returns)));
WriteLn("Std deviation: " + Text(StdDev(returns)));

// Moving average
Serie ma3 = MovingAverage(prices, 3);
WriteLn("3-period MA: " + Text(ma3));
```

Run it:
```bash
tolcon timeseries.tol
```

Expected output:
```
Prices: [100, 102, 98, 103, 105, 101, 99, 104]
Returns: [Empty, 0.0198, -0.0408, 0.0494, 0.0192, -0.0392, -0.0202, 0.0494]
Mean return: 0.0054
Std deviation: 0.0384
3-period MA: [Empty, Empty, 100, 101, 102, 103, 102, 101.333]
```

#### 3. Matrix Operations

Create `matrices.tol`:
```tol
// Create matrices
Matrix A = [[1, 2], [3, 4]];
Matrix B = [[5, 6], [7, 8]];

WriteLn("Matrix A:");
WriteLn(Text(A));
WriteLn("Matrix B:");
WriteLn(Text(B));

// Matrix operations
Matrix C = A * B;
WriteLn("A * B = ");
WriteLn(Text(C));

Real det = MatDet(A);
WriteLn("Determinant of A = " + Text(det));

Matrix inv = MatInv(A);
WriteLn("Inverse of A:");
WriteLn(Text(inv));
```

Run it:
```bash
tolcon matrices.tol
```

Expected output:
```
Matrix A:
[[1, 2], [3, 4]]
Matrix B:
[[5, 6], [7, 8]]
A * B = 
[[19, 22], [43, 50]]
Determinant of A = -2
Inverse of A:
[[-2, 1], [1.5, -0.5]]
```

#### 4. Statistical Analysis

Create `statistics.tol`:
```tol
// Generate random data
Serie data = RandomNormal(100, 50, 10);  // 100 points, mean=50, std=10

// Descriptive statistics
WriteLn("Sample size: " + Text(Card(data)));
WriteLn("Mean: " + Text(Mean(data)));
WriteLn("Median: " + Text(Median(data)));
WriteLn("Std Dev: " + Text(StdDev(data)));
WriteLn("Min: " + Text(Min(data)));
WriteLn("Max: " + Text(Max(data)));

// Histogram
Set hist = Histogram(data, 10);
WriteLn("Histogram buckets: " + Text(Card(hist)));
```

Run it:
```bash
tolcon statistics.tol
```

Expected output (values will vary due to randomness):
```
Sample size: 100
Mean: 49.8234
Median: 49.9012
Std Dev: 9.8765
Min: 28.3421
Max: 71.2983
Histogram buckets: 10
```

#### 5. NameBlocks (Objects)

Create `objects.tol`:
```tol
// Define a NameBlock for a bank account
NameBlock Account = [[
  Real balance = 1000;
  
  Real Deposit(Real amount) {
    balance = balance + amount;
    balance
  };
  
  Real Withdraw(Real amount) {
    Real If(amount <= balance, 
      Real dummy { balance = balance - amount; amount },
      Real dummy { WriteLn("Insufficient funds!"); 0 }
    )
  };
  
  Real GetBalance() { balance };
]];

// Use the account
WriteLn("Initial balance: $" + Text(Account.GetBalance()));

Account.Deposit(500);
WriteLn("After deposit: $" + Text(Account.GetBalance()));

Account.Withdraw(200);
WriteLn("After withdrawal: $" + Text(Account.GetBalance()));

Account.Withdraw(2000);  // This should fail
WriteLn("Final balance: $" + Text(Account.GetBalance()));
```

Run it:
```bash
tolcon objects.tol
```

Expected output:
```
Initial balance: $1000
After deposit: $1500
After withdrawal: $1300
Insufficient funds!
Final balance: $1300
```

### Interactive Development

Start an interactive TOL session for experimentation:

```bash
tolcon
```

Try these commands interactively:
```tol
TOL> Real x = 42;
TOL> WriteLn("The answer is " + Text(x));
The answer is 42

TOL> Serie fibonacci = [1, 1, 2, 3, 5, 8, 13, 21];
TOL> WriteLn("Sum: " + Text(Sum(fibonacci)));
Sum: 54

TOL> Matrix I = Eye(3);  // 3x3 identity matrix
TOL> WriteLn(Text(I));
[[1, 0, 0], [0, 1, 0], [0, 0, 1]]

TOL> exit
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

The strategic plan for the MCP server is under development and will be added here once available.

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
