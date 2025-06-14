---
module_id: system_io
category: data_handling
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - bbasic
  - stdlib
mcp_compatible: true
tags:
  - file-io
  - system-integration
  - data-export
  - utilities
  - networking
  - archives
---

# File System Integration Module (system_io)

## Module Overview
The `system_io` module provides comprehensive functions for interacting with the underlying operating system, file system, and network resources. This module is part of TOL's standard library and includes file operations, directory utilities, network access via HTTP/FTP, archive management, and system command execution. It serves as the bridge between TOL programs and the external environment.

Key capabilities include:
- File and directory operations
- System command execution
- Network resource access (HTTP/FTP)
- Archive compression and extraction
- Object serialization (OIS - Object Input/Output Streams)
- Cross-platform compatibility

## Core Functions/Classes

### Text OSCmdWait(Text cmd)
Executes a shell command and waits for completion, returning the command output.

**Parameters**
- `cmd` (`Text`): command line to execute in the system shell

**Returns**
- `Text`: standard output from the executed command

**Example**
```tol
// Execute system commands
Text ls_output = OSCmdWait("ls -la");
Text date_info = OSCmdWait("date");

// Data processing with external tools
Text csv_data = OSCmdWait("cat data.csv | head -10");
Text processed = OSCmdWait("python process_data.py input.txt");

// System information
Text memory_info = OSCmdWait("free -h");  // Linux
Text disk_usage = OSCmdWait("df -h");     // Unix-like systems
```

**Security Notes**
- Command injection risks: validate input carefully
- Use absolute paths when possible
- Consider using dedicated functions for common operations

### Bool OSFileExist(Text path)
Checks whether a file or directory exists at the specified path.

**Parameters**
- `path` (`Text`): file or directory path to check

**Returns**
- `Bool`: `True` if the file/directory exists, `False` otherwise

**Example**
```tol
// Check file existence before operations
Bool config_exists = OSFileExist("config.tol");
if (config_exists) {
    Set Include("config.tol");
}

// Validate data files
Bool data_ready = OSFileExist("data/input.csv");
if (!data_ready) {
    Write("Error: Input data file not found");
}

// Check directory structure
Bool output_dir = OSFileExist("output/");
if (!output_dir) {
    OSCmdWait("mkdir -p output");
}
```

### Text CurlGet(Text url)
Downloads content from a URL using the integrated Curl API, supporting HTTP and FTP protocols.

**Parameters**
- `url` (`Text`): HTTP or FTP address to download

**Returns**
- `Text`: downloaded content as text

**Example**
```tol
// Download web content
Text html_content = CurlGet("https://api.example.com/data");
Text json_data = CurlGet("https://api.github.com/repos/user/repo");

// Download data files
Text csv_data = CurlGet("https://data.gov/dataset.csv");
Text xml_feed = CurlGet("https://news.example.com/rss.xml");

// FTP file access
Text ftp_file = CurlGet("ftp://ftp.example.com/public/data.txt");
```

**Error Handling**
- Network timeouts and connection errors
- HTTP status codes (404, 500, etc.)
- SSL/TLS certificate validation
- Large file download considerations

### Text FileRead(Text path)
Reads the entire contents of a text file into memory.

**Parameters**
- `path` (`Text`): path to the file to read

**Returns**
- `Text`: complete file contents

**Example**
```tol
// Read configuration files
Text config_content = FileRead("settings.conf");
Text script_code = FileRead("analysis.tol");

// Read data files
Text csv_content = FileRead("data/sales.csv");
Text log_content = FileRead("logs/application.log");
```

### Void FileWrite(Text path, Text content)
Writes text content to a file, creating or overwriting as necessary.

**Parameters**
- `path` (`Text`): destination file path
- `content` (`Text`): text content to write

**Example**
```tol
// Write results to file
Text results = "Analysis complete: " + Text(final_result);
FileWrite("output/results.txt", results);

// Export data
Text csv_output = ConvertToCSV(data_matrix);
FileWrite("export/data.csv", csv_output);

// Generate reports
Text report = GenerateReport(analysis_results);
FileWrite("reports/monthly_report.html", report);
```

### Set ListDirectory(Text path)
Lists the contents of a directory, returning file and subdirectory names.

**Parameters**
- `path` (`Text`): directory path to list

**Returns**
- `Set`: collection of file and directory names

**Example**
```tol
// Process all files in a directory
Set files = ListDirectory("data/");
Set csv_files = FilterFiles(files, "*.csv");

// Batch processing
Set input_files = ListDirectory("input/");
For(1, Card(input_files), Real(Real i) {
    Text filename = input_files[i];
    ProcessFile("input/" + filename);
});
```

### Bool CreateDirectory(Text path)
Creates a directory (and parent directories if necessary).

**Parameters**
- `path` (`Text`): directory path to create

**Returns**
- `Bool`: `True` if successful, `False` if failed

**Example**
```tol
// Ensure output directories exist
Bool success = CreateDirectory("output/reports/2023");
Bool temp_dir = CreateDirectory("temp/processing");

// Create nested directory structure
CreateDirectory("data/raw/2023/Q1");
CreateDirectory("data/processed/2023/Q1");
```

## Network and Web Functions

### Text HttpPost(Text url, Text data)
Sends HTTP POST request with data payload.

**Parameters**
- `url` (`Text`): target URL
- `data` (`Text`): POST data payload

**Returns**
- `Text`: server response

**Example**
```tol
// API interactions
Text json_payload = '{"query": "SELECT * FROM data"}';
Text api_response = HttpPost("https://api.example.com/query", json_payload);

// Form submissions
Text form_data = "name=John&email=john@example.com";
Text result = HttpPost("https://forms.example.com/submit", form_data);
```

### Text DownloadFile(Text url, Text local_path)
Downloads a file from URL to local filesystem.

**Parameters**
- `url` (`Text`): source URL
- `local_path` (`Text`): destination file path

**Returns**
- `Text`: status message

**Example**
```tol
// Download datasets
Text status = DownloadFile("https://data.gov/large_dataset.zip", "data/dataset.zip");

// Download dependencies
DownloadFile("https://github.com/user/repo/archive/main.zip", "temp/repo.zip");
```

## Archive Management

### Bool ExtractArchive(Text archive_path, Text destination)
Extracts compressed archives (ZIP, TAR, GZ) to specified directory.

**Parameters**
- `archive_path` (`Text`): path to archive file
- `destination` (`Text`): extraction destination directory

**Returns**
- `Bool`: `True` if extraction successful

**Example**
```tol
// Extract downloaded data
Bool extracted = ExtractArchive("data/dataset.zip", "data/extracted/");

// Process archived logs
ExtractArchive("logs/archive.tar.gz", "temp/logs/");
Set log_files = ListDirectory("temp/logs/");
```

### Bool CreateArchive(Text archive_path, Set file_list)
Creates compressed archive from list of files.

**Parameters**
- `archive_path` (`Text`): output archive path
- `file_list` (`Set`): files to include in archive

**Returns**
- `Bool`: `True` if creation successful

**Example**
```tol
// Archive results
Set result_files = ["output/report.pdf", "output/data.csv", "output/charts/"];
Bool archived = CreateArchive("results_2023.zip", result_files);

// Backup important files
Set backup_files = ListDirectory("important/");
CreateArchive("backup_" + Text(Today()) + ".tar.gz", backup_files);
```

## Object Serialization (OIS)

### Void SaveObject(Text path, Any object)
Serializes TOL objects to disk using Object Input/Output Streams.

**Parameters**
- `path` (`Text`): file path for serialized object
- `object` (`Any`): TOL object to serialize

**Example**
```tol
// Save complex data structures
Matrix large_matrix = ComputeResults();
SaveObject("cache/matrix.ois", large_matrix);

// Save analysis state
NameBlock analysis_state = [[
    Matrix data = processed_data;
    Model fitted_model = arima_model;
    Set parameters = optimization_params;
]];
SaveObject("state/analysis.ois", analysis_state);
```

### Any LoadObject(Text path)
Deserializes TOL objects from disk.

**Parameters**
- `path` (`Text`): file path of serialized object

**Returns**
- `Any`: deserialized TOL object

**Example**
```tol
// Load cached computations
Matrix cached_matrix = LoadObject("cache/matrix.ois");

// Restore analysis state
NameBlock restored_state = LoadObject("state/analysis.ois");
Matrix data = restored_state.data;
Model model = restored_state.fitted_model;
```

## Data Types

### Core Types
- `Text`: File paths, URLs, command strings, file contents
- `Bool`: Success/failure indicators, existence checks
- `Set`: File lists, directory contents, archive file lists
- `Any`: Generic type for object serialization

### Path Handling
- Supports both absolute and relative paths
- Cross-platform path separators handled automatically
- Environment variable expansion in paths
- Tilde (~) expansion for home directory

## Integration Notes

### Data Pipeline Integration
- **Database connectivity**: Export query results to files
- **Statistical analysis**: Save/load analysis results and models
- **Plotting**: Export charts and visualizations
- **Time series**: Import/export temporal data from various sources

### External Tool Integration
- **Python/R scripts**: Execute data processing scripts
- **Command-line tools**: Integrate with system utilities
- **Web APIs**: Access external data sources and services
- **Version control**: Interface with Git and other VCS systems

### Configuration Management
```tol
// Load configuration from file
Text config_text = FileRead("config.json");
NameBlock config = ParseJSON(config_text);

// Environment-specific settings
Text env = OSCmdWait("echo $ENVIRONMENT");
Text config_file = "config_" + env + ".tol";
if (OSFileExist(config_file)) {
    Set Include(config_file);
}
```

## Performance Considerations

### File I/O Optimization
- **Buffered operations**: Use appropriate buffer sizes for large files
- **Streaming**: Process large files in chunks rather than loading entirely
- **Caching**: Cache frequently accessed files in memory
- **Batch operations**: Group multiple file operations when possible

### Network Performance
- **Connection reuse**: Maintain persistent connections for multiple requests
- **Compression**: Use compressed transfers for large data
- **Timeouts**: Set appropriate timeouts for network operations
- **Error handling**: Implement retry logic for transient failures

### Memory Management
- Large file operations may consume significant memory
- Use streaming for files larger than available RAM
- Clean up temporary files after processing
- Monitor disk space for large downloads and extractions

## Security Considerations

### File System Security
- Validate file paths to prevent directory traversal attacks
- Use appropriate file permissions
- Sanitize filenames from external sources
- Implement access controls for sensitive directories

### Network Security
- Validate URLs and implement allowlists when possible
- Use HTTPS for sensitive data transfers
- Implement certificate validation
- Sanitize downloaded content before processing

### Command Execution Security
- Avoid command injection by validating inputs
- Use parameterized commands when possible
- Run with minimal necessary privileges
- Log command executions for audit trails

## Error Handling
Comprehensive error handling for system operations:
- File not found or permission denied errors
- Network connectivity and timeout errors
- Disk space and memory limitations
- Archive corruption and extraction failures
- Command execution errors and return codes

## Common Use Cases

### Data Ingestion
```tol
// Download and process external data
Text csv_url = "https://data.source.com/daily_data.csv";
Text csv_content = CurlGet(csv_url);
FileWrite("data/daily_" + Text(Today()) + ".csv", csv_content);

// Process downloaded data
Matrix data = LoadCSV("data/daily_" + Text(Today()) + ".csv");
```

### Batch Processing
```tol
// Process all files in directory
Set input_files = ListDirectory("input/");
For(1, Card(input_files), Real(Real i) {
    Text filename = input_files[i];
    if (EndsWith(filename, ".csv")) {
        Matrix data = LoadCSV("input/" + filename);
        Matrix processed = ProcessData(data);
        SaveCSV("output/" + filename, processed);
    }
});
```

### System Integration
```tol
// Execute external analysis tools
Text python_script = "python analysis.py data.csv";
Text results = OSCmdWait(python_script);
FileWrite("results/python_output.txt", results);

// System monitoring
Text disk_usage = OSCmdWait("df -h");
Text memory_usage = OSCmdWait("free -m");
Text system_report = "Disk Usage:\n" + disk_usage + "\n\nMemory Usage:\n" + memory_usage;
FileWrite("monitoring/system_status.txt", system_report);
```

## Related Modules
- **[Database Connectivity (dbdrivers)](database_connectivity.md)**: Complement file I/O with database operations
- **[Standard Library (stdlib)](standard_library.md)**: Additional utility functions
- **[Statistical Analysis (bstat)](statistical_analysis.md)**: Save/load statistical models and results
- **[Plotting Functions (plotter)](plotting_functions.md)**: Export visualizations to files
