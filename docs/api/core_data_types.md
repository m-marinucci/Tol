---
module_id: btol_core
category: core_computational
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - bbasic
mcp_compatible: true
tags:
  - data-types
  - core-functionality
  - matrix-operations
  - text-processing
---

# Core Data Types Module (btol_core)

## Module Overview
This module defines the fundamental data types implemented in the `btol` layer that serve as building blocks for all TOL programs. These types are shared across modules and provide the foundation for TOL's rich type system, supporting everything from basic arithmetic to complex mathematical operations and data structures.

The core data types enable:
- Numerical computations with various precision levels
- Text and string processing
- Matrix and linear algebra operations
- Set-based operations and collections
- Code representation and execution
- Namespace organization

## Core Data Types

### Real
Double-precision floating-point number used for most numerical calculations in TOL.

**Properties**
- IEEE 754 double precision (64-bit)
- Range: approximately ±1.7 × 10^308
- Precision: ~15-17 decimal digits

**Example**
```tol
Real pi = 3.14159265359;
Real temperature = -40.5;
Real large_number = 1.23e15;
```

**Operations**
- Arithmetic: `+`, `-`, `*`, `/`, `^` (power)
- Comparison: `<`, `<=`, `>`, `>=`, `==`, `!=`
- Mathematical functions: `Sin`, `Cos`, `Log`, `Exp`, etc.

### Complex
Complex number with `Real` real and imaginary parts for advanced mathematical computations.

**Properties**
- Real and imaginary components stored as `Real` values
- Full support for complex arithmetic
- Integration with FFT and signal processing functions

**Example**
```tol
Complex z1 = 3 + 4i;
Complex z2 = Complex(2.5, -1.8);
Complex result = z1 * z2;
Real magnitude = Abs(z1);  // Returns 5.0
```

**Operations**
- Arithmetic: addition, subtraction, multiplication, division
- Functions: `Abs`, `Arg`, `Conj`, `Real`, `Imag`
- Exponential: `Exp`, `Log`, `Pow`

### Ratio
Rational number represented as numerator and denominator for exact arithmetic.

**Properties**
- Exact representation of fractions
- Automatic simplification to lowest terms
- No rounding errors for rational operations

**Example**
```tol
Ratio half = Ratio(1, 2);
Ratio third = Ratio(1, 3);
Ratio sum = half + third;  // Exactly 5/6
```

### Matrix
Dense numerical matrix supporting comprehensive linear algebra operations.

**Properties**
- Column-major storage for BLAS compatibility
- Dynamic sizing with efficient memory management
- Support for both real and complex elements

**Example**
```tol
Matrix A = [[1, 2, 3], [4, 5, 6]];  // 2×3 matrix
Matrix B = RandomMatrix(100, 100);   // 100×100 random matrix
Matrix C = MatMul(A, Tra(A));        // Matrix multiplication
Real det = Det(C);                   // Determinant
```

**Operations**
- Arithmetic: `+`, `-`, `*` (element-wise), `MatMul` (matrix multiplication)
- Linear algebra: `Inverse`, `Det`, `Eigenvalues`, `SVD`
- Utilities: `Tra` (transpose), `Rows`, `Cols`, `Reshape`

### VMatrix
Sparse matrix optimized for memory efficiency when most elements are zero.

**Properties**
- Compressed storage format (CSR/CSC)
- Significant memory savings for sparse data
- Specialized algorithms for sparse operations

**Example**
```tol
VMatrix sparse = ConvertToSparse(dense_matrix, 0.01);  // 1% density threshold
VMatrix identity = SparseIdentity(1000);               // 1000×1000 sparse identity
VMatrix result = SparseMatMul(sparse, identity);
```

### Polynomial / PolMat
Polynomials and polynomial matrices for algebraic computations and control theory.

**Properties**
- Coefficient-based representation
- Support for polynomial arithmetic
- Integration with control system analysis

**Example**
```tol
Polynomial p = Polynomial([1, -2, 1]);  // x² - 2x + 1
Real value = EvalPol(p, 3.0);           // Evaluate at x=3
Polynomial derivative = DerPol(p);       // Derivative
```

### Set
Unordered collection of elements that may hold heterogeneous types.

**Properties**
- Dynamic sizing with automatic memory management
- Support for mixed data types
- Set operations: union, intersection, difference

**Example**
```tol
Set numbers = [1, 2, 3, 4, 5];
Set mixed = [1.5, "hello", y2023m01d01];
Set union_set = numbers + mixed;
Real length = Card(numbers);  // Cardinality (5)
```

**Operations**
- Set algebra: `+` (union), `*` (intersection), `-` (difference)
- Membership: `In`, `NotIn`
- Utilities: `Card` (cardinality), `EvalSet`, `For`

### Text
Unicode text string for all text processing operations.

**Properties**
- Immutable string representation
- Full Unicode support
- Efficient string operations

**Example**
```tol
Text greeting = "Hello, World!";
Text name = "TOL";
Text message = greeting + " Welcome to " + name;
Real length = Length(message);
Text upper = UpCase(message);
```

**Operations**
- Concatenation: `+`
- Comparison: `<`, `<=`, `>`, `>=`, `==`, `!=`
- Functions: `Length`, `SubText`, `UpCase`, `DownCase`, `Find`

### Code
Represents executable TOL code blocks for meta-programming and dynamic execution.

**Properties**
- Stores TOL code as executable objects
- Enables dynamic code generation and execution
- Support for closures and functional programming

**Example**
```tol
Code square = Real(Real x) { x * x };
Real result = square(5);  // Returns 25

Code dynamic_func = Compile("Real(Real x) { x + 10 }");
Real value = dynamic_func(5);  // Returns 15
```

### NameBlock
Namespace-like structure used to organize identifiers and create modular code.

**Properties**
- Hierarchical namespace organization
- Scope management for variables and functions
- Module system foundation

**Example**
```tol
NameBlock Math = [[
  Real pi = 3.14159265359;
  Real e = 2.71828182846;
  Real CircleArea(Real radius) { pi * radius * radius };
]];

Real area = Math.CircleArea(5.0);
```

## Type Conversion Functions

### Automatic Conversions
TOL provides automatic type conversions where safe and meaningful:
- `Real` to `Complex`: real part only
- `Real` to `Ratio`: exact representation when possible
- `Ratio` to `Real`: floating-point approximation

### Explicit Conversions
```tol
Real r = Real(ratio_value);
Complex c = Complex(real_value);
Text t = Text(numeric_value);
Set s = SetOfReal(1, 2, 3, 4, 5);
```

## Integration Notes
These core data types integrate seamlessly with all TOL modules:

- **bmath**: Provides mathematical operations for all numeric types
- **bstat**: Uses these types for statistical computations
- **plotting**: Visualizes data stored in these types
- **database drivers**: Maps SQL types to TOL types
- **standard library**: Provides utility functions for type manipulation

## Performance Considerations

### Memory Usage
- `Real`: 8 bytes per value
- `Complex`: 16 bytes per value
- `Matrix`: 8 bytes per element plus overhead
- `VMatrix`: Storage proportional to non-zero elements
- `Text`: Variable length with UTF-8 encoding
- `Set`: Dynamic allocation with growth strategies

### Computational Efficiency
- Use `VMatrix` for large sparse data (>90% zeros)
- `Ratio` operations are exact but slower than `Real`
- `Set` operations may involve dynamic typing overhead
- `Text` values are immutable (concatenation creates new strings)
- `Matrix` operations leverage optimized BLAS routines

### Best Practices
- Choose appropriate numeric types based on precision requirements
- Use sparse matrices for large, mostly-zero data
- Consider memory usage when working with large datasets
- Leverage type-specific optimizations in mathematical operations

## Error Handling
Type-related errors include:
- `TypeMismatchError`: Incompatible types in operations
- `DimensionError`: Matrix dimension mismatches
- `OverflowError`: Numeric overflow in calculations
- `IndexError`: Invalid set or matrix indices
- `ConversionError`: Failed type conversions

## Related Modules
- **[Mathematical Operations (bmath)](mathematical_operations.md)**: Provides operations for numeric types
- **[Time-Series Analysis (btol)](time_series_analysis.md)**: Uses these types for temporal data
- **[Statistical Analysis (bstat)](statistical_analysis.md)**: Statistical operations on these types
- **[Standard Library (stdlib)](standard_library.md)**: Utility functions for type manipulation
