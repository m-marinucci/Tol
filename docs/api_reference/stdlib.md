# Standard Library (stdlib)

## Module Overview
The TOL standard library (`stdlib`) provides a broad collection of functions ranging from math utilities to text manipulation. It is loaded automatically by the interpreter and serves as the primary user-facing API.

## Core Functions/Classes
### Real Rand(Real a, Real b)
Returns a random real number in the interval `[a, b]`.

*Parameters*
- `a` (`Real`): lower bound
- `b` (`Real`): upper bound

*Returns*
- `Real`: random value

*Example*
```tol
Real r = Rand(0, 1);
```

### Text Join(Set items, Text sep)
Concatenates items from a set into a single string using a separator.

*Parameters*
- `items` (`Set`): collection of text elements
- `sep` (`Text`): separator string

*Returns*
- `Text`: concatenated string

## Data Types
- Standard types such as `Real`, `Text`, `Set`, `Matrix`

## Integration Notes
Many other modules build upon functions defined here, including configuration management via `TolConfigManager` and package loading.

## Performance Considerations
Library functions are implemented in TOL and C++. Performance is typically sufficient for scripting tasks, but heavy numeric work should delegate to `bmath`.
