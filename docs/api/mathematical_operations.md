---
module_id: bmath
category: core_computational
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - bbasic
  - gsl
mcp_compatible: true
tags:
  - mathematics
  - linear-algebra
  - numerical-computation
  - performance-critical
---

# Mathematical Operations Module (bmath)

## Module Overview
The `bmath` module provides TOL's core mathematical operations, including arithmetic, linear algebra, probability distributions, and interfaces to numerical libraries like BLAS, LAPACK, FFTW, and GSL. It targets users needing high‑performance numerical routines and serves as the foundation for many higher-level TOL features.

This module is essential for:
- Heavy mathematical computations
- Linear algebra operations
- Signal processing with FFT
- Statistical calculations requiring optimized routines
- Building higher-level algorithms

## Core Functions/Classes

### Real Add(Real a, Real b)
Adds two real numbers using optimized arithmetic operations.

**Parameters**
- `a` (`Real`): first operand
- `b` (`Real`): second operand

**Returns**
- `Real`: sum `a + b`

**Example**
```tol
Real result = Add(3.0, 2.0);  // Returns 5.0
Real x = Add(2.5, 7.3);       // Returns 9.8
```

**Performance Notes**
- Optimized for high-precision arithmetic
- Handles overflow/underflow conditions automatically

### Matrix MatMul(Matrix A, Matrix B)
Multiplies two matrices using the optimized BLAS/LAPACK backend for maximum performance.

**Parameters**
- `A` (`Matrix`): left operand, must have dimensions m×n
- `B` (`Matrix`): right operand, must have dimensions n×p

**Returns**
- `Matrix`: product matrix of size m×p

**Example**
```tol
Matrix A = [[1, 2], [3, 4]];
Matrix B = [[5, 6], [7, 8]];
Matrix C = MatMul(A, B);      // Returns [[19, 22], [43, 50]]
```

**Errors**
- Raises `DimensionMismatchError` if the number of columns in `A` does not match rows in `B`
- Raises `MemoryError` for extremely large matrices

**Performance Notes**
- Uses optimized BLAS routines (typically OpenBLAS or Intel MKL)
- Complexity: O(mnp) for m×n and n×p matrices
- Memory usage: O(mp) for result matrix

### Complex FFT(Serie s)
Performs a Fast Fourier Transform on a time series using the FFTW library for optimal performance.

**Parameters**
- `s` (`Serie`): input time series (real or complex values)

**Returns**
- `Serie`: complex frequency domain representation

**Example**
```tol
Serie signal = MakeSerie(dates, values);
Serie frequencies = FFT(signal);
```

**Performance Notes**
- Uses FFTW for O(n log n) complexity
- Automatically chooses optimal algorithm based on input size
- Supports both real and complex input

### Matrix Inverse(Matrix A)
Computes the matrix inverse using LU decomposition with partial pivoting.

**Parameters**
- `A` (`Matrix`): square matrix to invert

**Returns**
- `Matrix`: inverse matrix A⁻¹

**Example**
```tol
Matrix A = [[2, 1], [1, 1]];
Matrix A_inv = Inverse(A);    // Returns [[1, -1], [-1, 2]]
```

**Errors**
- Raises `SingularMatrixError` if matrix is not invertible
- Raises `NonSquareMatrixError` if matrix is not square

## Data Types

### Core Numeric Types
- `Real`: double-precision floating point numbers
- `Complex`: complex numbers with real and imaginary parts
- `Ratio`: rational numbers for exact arithmetic

### Matrix Types
- `Matrix`: dense matrices stored in column-major order
- `VMatrix`: sparse matrices using compressed storage
- `Serie`: ordered list of values (typically time series)

### Specialized Types
- `Polynomial`: polynomial representations
- `PolMat`: polynomial matrices

## Integration Notes
`bmath` underpins many other modules such as `bstat` and `btol`. It relies on external libraries which must be available at build time:

- **BLAS/LAPACK**: Linear algebra operations
- **FFTW**: Fast Fourier Transform computations
- **GSL**: Advanced mathematical functions
- **CHOLMOD**: Sparse matrix operations

## Performance Considerations

### Memory Usage
- Large matrices may consume significant memory
- Consider using sparse representations (`VMatrix`) when matrices have many zeros
- Memory allocation is optimized for cache efficiency

### Computational Complexity
- Matrix operations defer to optimized BLAS/LAPACK implementations
- FFT uses FFTW for O(n log n) complexity
- Sparse operations use specialized algorithms for better performance

### Best Practices
- Use appropriate data types (sparse vs dense matrices)
- Consider memory layout for cache optimization
- Profile performance-critical code sections

## Error Handling
All functions provide comprehensive error checking:
- Dimension compatibility for matrix operations
- Memory allocation failures
- Numerical stability issues (singular matrices, overflow/underflow)
- Invalid input parameters

## Related Modules
- **bstat**: Uses bmath for statistical computations
- **btol**: Relies on bmath for time series operations
- **stdlib**: Provides higher-level mathematical functions built on bmath
