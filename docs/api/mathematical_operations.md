# Mathematical Operations Module (`bmath`)

## Module Overview
`bmath` provides TOL's low level numerical routines including arithmetic helpers, linear algebra wrappers and statistical utilities. It is aimed at users performing heavy mathematical computation or implementing high level algorithms.

## Core Functions/Classes
### `Add(Real a, Real b) -> Real`
Adds two real numbers.
- **Parameters**
  - `a` – first operand
  - `b` – second operand
- **Returns**: result of `a + b`.
- **Example**
```tol
Real x = Add(2, 3);  // 5
```

### `MatMul(Matrix A, Matrix B) -> Matrix`
Multiplies matrices using BLAS/LAPACK routines.
- **Parameters**
  - `A` – left matrix; must have compatible dimensions
  - `B` – right matrix
- **Returns**: product matrix
- **Errors**: raises `DimensionError` if shapes are incompatible.
- **Example**
```tol
Matrix C = MatMul(A, B);
```

### `FFT(Set data) -> Set`
Computes the discrete Fourier transform using FFTW.
- **Parameters**
  - `data` – set of real or complex values
- **Returns**: transformed data
- **Example**
```tol
Set freq = FFT(signal);
```

## Data Types
- `Matrix`, `VMatrix` – dense and sparse matrices
- `Real`, `Complex`, `Ratio`

## Integration Notes
`bmath` functions are used by higher level modules such as `bstat` and the standard library. They rely on external libraries like GSL and LAPACK.

## Performance Considerations
Matrix operations defer to optimized BLAS/LAPACK implementations. FFT uses FFTW for O(n log n) complexity.
