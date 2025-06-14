# File I/O and System Integration Module (`stdlib/system`)

## Module Overview
Supplies functions for reading/writing files, executing system commands and interacting with archives and network services via Curl.

## Core Functions/Classes
### `ReadFile(Text path) -> Text`
Returns the contents of a text file.

### `WriteFile(Text path, Text content)`
Writes text to a file, creating or overwriting it.

### `CurlGet(Text url) -> Text`
Downloads content from an HTTP URL using `CurlApi`.

### `PackArchive(Text srcDir, Text destFile)`
Creates a compressed archive from a directory.

## Data Types
- file paths are plain `Text`
- archive handles are returned as `Text` filenames

## Integration Notes
Used by build scripts and other modules that need filesystem access. Curl functions enable remote data retrieval.

## Performance Considerations
Large file operations allocate buffers proportional to file size. Network calls depend on external latency.
