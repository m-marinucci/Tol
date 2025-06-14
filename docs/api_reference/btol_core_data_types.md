# btol Core Data Types

## Module Overview
This reference summarizes fundamental data types implemented in the `btol` layer. These types are the building blocks for all TOL programs and are shared across modules.

## Data Types
### Real
Floating-point number used for most numerical calculations.

### Complex
Complex number with `Real` real and imaginary parts.

### Ratio
Rational number represented as numerator and denominator.

### Matrix
Dense numerical matrix supporting linear algebra operations.

### VMatrix
Sparse matrix optimized for memory efficiency when most elements are zero.

### Polynomial / PolMat
Polynomials and polynomial matrices for algebraic computations.

### Set
Unordered collection of elements (may hold heterogeneous types).

### Text
Unicode text string.

### Code
Represents executable TOL code blocks.

### NameBlock
Namespace-like structure used to organize identifiers.

## Integration Notes
These types are instantiated by various modules (`bmath`, `bstat`, `stdlib`) and are directly manipulable in TOL scripts. Many standard library functions accept or return these types.

## Performance Considerations
Use `VMatrix` for large sparse data. Operations on `Set` may involve dynamic typing overhead. `Text` values are immutable.
