# bmath Module

## Module Overview
The `bmath` module provides TOL's core mathematical operations, including arithmetic, linear algebra, probability distributions, and interfaces to numerical libraries like BLAS, LAPACK, FFTW, and GSL. It targets users needing high‑performance numerical routines and serves as the foundation for many higher-level TOL features.

## Core Functions/Classes
### Real Add(Real a, Real b)
Adds two real numbers.

*Parameters*
- `a` (`Real`): first operand
- `b` (`Real`): second operand

*Returns*
- `Real`: sum `a + b`

*Example*
```tol
Real result = Add(3.0, 2.0);
```

### Matrix MatMul(Matrix A, Matrix B)
Multiplies two matrices using the optimized BLAS/LAPACK backend.

*Parameters*
- `A` (`Matrix`): left operand, must have dimensions m×n
- `B` (`Matrix`): right operand, must have dimensions n×p

*Returns*
- `Matrix`: product matrix of size m×p

*Example*
```tol
Matrix C = MatMul(A, B);
```

*Errors*
- Raises `DimensionMismatchError` if the number of columns in `A` does not match rows in `B`.

### Complex FFT(Serie s)
Performs a Fast Fourier Transform on a time series using FFTW.

*Parameters*
- `s` (`Serie`): input series

*Returns*
- `Serie`: complex frequency series

## Data Types
- `Real`, `Complex`: numeric primitives
- `Matrix`: dense matrices
- `Serie`: ordered list of values (time series)

## Integration Notes
`bmath` underpins many other modules such as `bstat` and `btol`. It relies on external libraries which must be available at build time.

## Performance Considerations
Functions call optimized libraries (BLAS/LAPACK, FFTW) for heavy computations. Large matrices may consume significant memory. Consider using sparse representations (`VMatrix`) when possible.
