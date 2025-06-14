---
module_id: bmath
category: core_computational
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - bbasic
  - gsl
  - blas
  - lapack
  - fftw
mcp_compatible: true
api_level: public
complexity: intermediate
performance_notes:
  memory_usage: high
  cpu_intensive: true
  external_deps: ["BLAS", "LAPACK", "GSL", "FFTW"]
user_personas:
  - quantitative_analyst
  - software_developer
  - researcher
  - financial_analyst
examples_tested: true
tags:
  - mathematics
  - linear-algebra
  - numerical-computation
  - performance-critical
  - signal-processing
mcp_metadata:
  natural_language_aliases:
    - "math operations"
    - "mathematical functions"
    - "linear algebra"
    - "matrix operations"
  intent_categories:
    - calculation
    - matrix_operations
    - statistical_computation
    - signal_processing
  auto_generate_code: true
  parameter_validation:
    strict_types: true
    range_checking: true
doc_metadata:
  author: TOL Documentation Team
  reviewers:
    - m-marinucci
  source_files:
    - tol-master/tol/bmath/
    - tol-master/tol/bmath/barith/
    - tol-master/tol/bmath/blinalg/
    - tol-master/tol/bmath/fftw/
  related_modules:
    - module_id: bstat
      relationship: consumer
    - module_id: btol_core
      relationship: provider
  external_links:
    - title: "BLAS Documentation"
      url: "http://www.netlib.org/blas/"
    - title: "GSL Reference"
      url: "https://www.gnu.org/software/gsl/doc/html/"
    - title: "FFTW Documentation"
      url: "http://www.fftw.org/fftw3_doc/"
---

# Mathematical Operations Module (bmath)

## Module Overview
The `bmath` module provides TOL's core mathematical operations, including arithmetic, linear algebra, probability distributions, and interfaces to numerical libraries like BLAS, LAPACK, FFTW, and GSL. It targets users needing high‑performance numerical routines and serves as the foundation for many higher-level TOL features.

This module is essential for:
- Heavy mathematical computations requiring optimized performance
- Linear algebra operations on large matrices
- Signal processing with Fast Fourier Transforms
- Statistical calculations requiring numerical precision
- Building higher-level algorithms and models

**Target Users**: Quantitative analysts, researchers, financial modelers, engineers working with numerical data.

## Core Functions/Classes

### Real Add(Real a, Real b)
Adds two real numbers using optimized arithmetic operations with automatic precision handling.

**Parameters**
- `a` (`Real`): first operand
- `b` (`Real`): second operand

**Returns**
- `Real`: sum `a + b`

**Example**
```tol
// Basic addition
Real result = Add(3.0, 2.0);  // Returns 5.0

// Financial calculations
Real principal = 10000.0;
Real interest = 250.75;
Real total = Add(principal, interest);  // Returns 10250.75

// Scientific notation
Real large_num = Add(1.23e15, 4.56e14);
```

**Performance Notes**
- Optimized for high-precision arithmetic
- Handles overflow/underflow conditions automatically
- Uses IEEE 754 double precision standard

**MCP Natural Language Examples**
- "Add 3.5 and 2.1"
- "Calculate the sum of principal and interest"
- "What is 1000 plus 250?"

### Matrix MatMul(Matrix A, Matrix B)
Multiplies two matrices using the optimized BLAS/LAPACK backend for maximum performance.

**Parameters**
- `A` (`Matrix`): left operand, must have dimensions m×n
- `B` (`Matrix`): right operand, must have dimensions n×p

**Returns**
- `Matrix`: product matrix of size m×p

**Example**
```tol
// Basic matrix multiplication
Matrix A = [[1, 2], [3, 4]];
Matrix B = [[5, 6], [7, 8]];
Matrix C = MatMul(A, B);      // Returns [[19, 22], [43, 50]]

// Financial portfolio calculations
Matrix returns = LoadMatrix("stock_returns.csv");
Matrix weights = [[0.3], [0.4], [0.3]];  // Portfolio weights
Matrix portfolio_return = MatMul(Tra(weights), returns);

// Large-scale computations
Matrix large_A = RandomMatrix(1000, 500);
Matrix large_B = RandomMatrix(500, 800);
Matrix result = MatMul(large_A, large_B);  // Uses optimized BLAS
```

**Errors**
- `DimensionMismatchError` if the number of columns in `A` does not match rows in `B`
- `MemoryError` for extremely large matrices exceeding available memory
- `NullMatrixError` if either input matrix is null or uninitialized

**Performance Notes**
- Uses optimized BLAS routines (typically OpenBLAS or Intel MKL)
- Computational complexity: O(mnp) for m×n and n×p matrices
- Memory usage: O(mp) for result matrix plus temporary storage
- Automatically chooses optimal algorithm based on matrix dimensions

**MCP Natural Language Examples**
- "Multiply matrix A by matrix B"
- "Calculate the matrix product of returns and weights"
- "Perform matrix multiplication for portfolio analysis"

### Complex FFT(Serie s)
Performs a Fast Fourier Transform on a time series using the FFTW library for optimal performance.

**Parameters**
- `s` (`Serie`): input time series (real or complex values)

**Returns**
- `Serie`: complex frequency domain representation

**Example**
```tol
// Signal processing
Serie signal = MakeSerie(dates, values);
Serie frequencies = FFT(signal);

// Financial time series analysis
Serie stock_prices = LoadSeries("AAPL_daily.csv");
Serie price_spectrum = FFT(stock_prices);

// Audio signal processing
Serie audio_data = LoadAudioSeries("signal.wav");
Serie freq_domain = FFT(audio_data);
Serie filtered = ApplyFilter(freq_domain, low_pass_filter);
Serie clean_signal = IFFT(filtered);
```

**Performance Notes**
- Uses FFTW for O(n log n) complexity
- Automatically chooses optimal algorithm based on input size
- Supports both real and complex input
- Memory usage: O(n) for input plus O(n) for output

**Related Functions**
- `IFFT(Serie s)`: Inverse Fast Fourier Transform
- `PowerSpectrum(Serie s)`: Compute power spectral density
- `Spectrogram(Serie s, Real window_size)`: Time-frequency analysis

**MCP Natural Language Examples**
- "Perform FFT on this time series"
- "Convert signal to frequency domain"
- "Analyze the frequency components of stock prices"

## Advanced Functions

### Matrix Inverse(Matrix A)
Computes the matrix inverse using LU decomposition with partial pivoting.

**Parameters**
- `A` (`Matrix`): square matrix to invert

**Returns**
- `Matrix`: inverse matrix A⁻¹

**Example**
```tol
// Basic matrix inversion
Matrix A = [[2, 1], [1, 1]];
Matrix A_inv = Inverse(A);    // Returns [[1, -1], [-1, 2]]

// Solving linear systems: Ax = b becomes x = A⁻¹b
Matrix coeff_matrix = LoadMatrix("system_coefficients.csv");
Matrix constants = LoadMatrix("system_constants.csv");
Matrix solution = MatMul(Inverse(coeff_matrix), constants);
```

**Errors**
- `SingularMatrixError` if matrix is not invertible (determinant = 0)
- `NonSquareMatrixError` if matrix is not square
- `NumericalInstabilityError` if matrix is nearly singular

### VMatrix SparseMatMul(VMatrix A, VMatrix B)
Multiplies sparse matrices using specialized algorithms for improved performance.

**Parameters**
- `A` (`VMatrix`): sparse matrix in compressed format
- `B` (`VMatrix`): sparse matrix in compressed format

**Returns**
- `VMatrix`: sparse product matrix

**Example**
```tol
// Large sparse matrix operations
VMatrix sparse_A = ConvertToSparse(dense_matrix, 0.01);  // 1% density
VMatrix sparse_B = LoadSparseMatrix("large_sparse.mtx");
VMatrix result = SparseMatMul(sparse_A, sparse_B);
```

## Data Types

### Core Numeric Types
- `Real`: double-precision floating point numbers (IEEE 754)
- `Complex`: complex numbers with real and imaginary parts
- `Ratio`: rational numbers for exact arithmetic

### Matrix Types
- `Matrix`: dense matrices stored in column-major order for BLAS compatibility
- `VMatrix`: sparse matrices using compressed storage (CSR/CSC format)
- `Serie`: ordered list of values, typically time series data

### Specialized Types
- `Polynomial`: polynomial representations with coefficient arrays
- `PolMat`: polynomial matrices for control theory applications

## Integration Notes
The `bmath` module underpins many other TOL modules:

- **bstat**: Uses bmath for statistical computations and matrix operations
- **btol**: Relies on bmath for time series mathematical operations
- **stdlib**: Provides higher-level mathematical functions built on bmath
- **plotter**: Uses bmath for coordinate transformations and data processing

### External Library Dependencies
- **BLAS/LAPACK**: Linear algebra operations (OpenBLAS, Intel MKL, or reference BLAS)
- **FFTW**: Fast Fourier Transform computations
- **GSL**: Advanced mathematical functions and special functions
- **CHOLMOD**: Sparse matrix operations and factorizations

## Performance Considerations

### Memory Usage
- Large matrices may consume significant memory (8 bytes per Real element)
- Consider using sparse representations (`VMatrix`) when matrices have >90% zeros
- Memory allocation is optimized for cache efficiency
- Use memory-mapped files for extremely large datasets

### Computational Complexity
- Matrix multiplication: O(n³) for dense, optimized with BLAS
- FFT operations: O(n log n) with FFTW optimization
- Sparse operations: Complexity depends on sparsity pattern
- Linear system solving: O(n³) for dense, O(n^1.5) for sparse

### Best Practices
- Use appropriate data types (sparse vs dense matrices)
- Consider memory layout for cache optimization
- Profile performance-critical code sections
- Leverage parallel BLAS implementations when available

## Error Handling
Comprehensive error checking includes:
- Dimension compatibility for matrix operations
- Memory allocation failures with graceful degradation
- Numerical stability issues (singular matrices, overflow/underflow)
- Invalid input parameters with descriptive error messages

## Cross-References

### Related Modules
- **[Statistical Analysis (bstat)](statistical_analysis.md)**: Uses bmath for statistical computations
- **[Time-Series Analysis (btol)](time_series_analysis.md)**: Relies on bmath for temporal data operations
- **[Standard Library (stdlib)](standard_library.md)**: Provides higher-level functions built on bmath

### External Resources
- [BLAS Documentation](http://www.netlib.org/blas/)
- [GSL Reference Manual](https://www.gnu.org/software/gsl/doc/html/)
- [FFTW User Manual](http://www.fftw.org/fftw3_doc/)

## MCP Server Integration
This module is fully compatible with the TOL MCP server, supporting natural language queries such as:
- "Calculate the matrix product of A and B"
- "Perform FFT analysis on this time series"
- "Solve this system of linear equations"
- "Find the eigenvalues of this matrix"
