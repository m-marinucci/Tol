# Core Data Types Module (`btol`)

## Module Overview
Defines the fundamental objects used throughout TOL. It targets language developers and advanced users needing to understand how values are represented.

## Core Functions/Classes
### `Matrix` / `VMatrix`
Matrix representations; `VMatrix` is sparse. Constructors accept nested sets or arrays.

### `Set`
Unordered collection of items. Supports iteration and set algebra.

### `NameBlock`
Namespace-like structure containing variables and functions.

## Data Types
- `Real`, `Complex`, `Ratio`
- `Text`, `Code`
- `Polynomial`, `Matrix`, `VMatrix`
- `Set`, `NameBlock`

## Integration Notes
All modules rely on these types. They are created in C++ but accessible from TOL scripts.

## Performance Considerations
Large matrices and sets allocate dynamic memory; sparse matrices (`VMatrix`) reduce storage for mostly zero data.
