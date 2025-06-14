# System and File I/O Module

## Module Overview
Part of the standard library, the `system` module provides functions for interacting with the underlying operating system. It includes file operations, directory utilities, and wrappers around external tools (via `CurlApi`, `PackArchive`, and `OIS`).

## Core Functions/Classes
### Text OSCmdWait(Text cmd)
Executes a shell command and waits for completion.

*Parameters*
- `cmd` (`Text`): command line to execute

*Returns*
- `Text`: command output

### Bool OSFilExist(Text path)
Checks whether a file exists.

*Parameters*
- `path` (`Text`): file path

*Returns*
- `Bool`: `True` if the file exists

### Text CurlGet(Text url)
Downloads a URL using the Curl API.

*Parameters*
- `url` (`Text`): HTTP or FTP address

*Returns*
- `Text`: downloaded content

*Example*
```tol
Text html = CurlGet("https://example.com");
```

## Data Types
- `Text`
- `Bool`

## Integration Notes
File and system utilities are often used in data ingestion scripts. `PackArchive` works with compressed archives, and `OIS` integrates the Object Input/Output Stream for serialization.

## Performance Considerations
File operations are I/O bound. Use buffered reads for large files and check return values to handle errors gracefully.
