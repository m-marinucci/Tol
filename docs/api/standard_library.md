# Standard Library Module (`stdlib`)

## Module Overview
Contains pure TOL functions packaged for general use: configuration handling, text utilities and numerical helpers. It is the first set of modules loaded when the interpreter starts.

## Core Functions/Classes
### `Include(Text module)`
Loads a standard library module by name.

### `TolConfigManager::Get(Text key) -> Text`
Retrieves a configuration value.

### `Split(Text str, Text sep) -> Set`
Divides a string into a set of substrings.

### `Map(Set s, Code f) -> Set`
Applies function `f` to each element of `s`.

## Data Types
Mostly operates on built-in types such as `Set`, `Text` and numeric values.

## Integration Notes
Standard library modules depend on the core data types and may call into `bmath` or `bstat` for heavy computations.

## Performance Considerations
Functions are written in TOL, benefiting from lazy evaluation. Performance depends on the underlying native functions they call.
