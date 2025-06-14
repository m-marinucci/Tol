---
module_id: stdlib
category: utilities
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - bbasic
  - bmath
mcp_compatible: true
tags:
  - standard-library
  - utilities
  - configuration
  - text-processing
  - random-generation
---

# Standard Library Module (stdlib)

## Module Overview
The TOL standard library (`stdlib`) provides a comprehensive collection of utility functions ranging from mathematical helpers to text manipulation, random number generation, and configuration management. It is loaded automatically by the TOL interpreter and serves as the primary user-facing API for common programming tasks. This module forms the foundation for most TOL programs and provides essential functionality that other modules build upon.

Key capabilities include:
- Text processing and string manipulation
- Random number generation and statistical sampling
- Configuration management and package loading
- Utility functions for data manipulation
- Mathematical helpers and convenience functions
- System integration utilities

## Core Functions/Classes

### Real Rand(Real a, Real b)
Returns a uniformly distributed random real number in the interval `[a, b]`.

**Parameters**
- `a` (`Real`): lower bound (inclusive)
- `b` (`Real`): upper bound (inclusive)

**Returns**
- `Real`: random value uniformly distributed in `[a, b]`

**Example**
```tol
// Generate random numbers
Real r = Rand(0, 1);           // Random value between 0 and 1
Real price = Rand(50, 150);    // Random price between $50 and $150
Real temperature = Rand(-10, 35); // Random temperature

// Monte Carlo simulation
Set random_samples = For(1, 1000, Real(Real i) { Rand(0, 1) });
Real average = Mean(random_samples);
```

**Performance Notes**
- Uses high-quality pseudorandom number generator
- Thread-safe for parallel computations
- Seed can be set for reproducible results

### Text Join(Set items, Text sep)
Concatenates items from a set into a single string using a specified separator.

**Parameters**
- `items` (`Set`): collection of elements to join (automatically converted to text)
- `sep` (`Text`): separator string inserted between elements

**Returns**
- `Text`: concatenated string with separators

**Example**
```tol
// Join text elements
Set words = ["Hello", "World", "from", "TOL"];
Text sentence = Join(words, " ");  // "Hello World from TOL"

// Create CSV format
Set values = [123.45, 67.89, 90.12];
Text csv_line = Join(values, ",");  // "123.45,67.89,90.12"

// Build file paths
Set path_parts = ["data", "2023", "Q1", "sales.csv"];
Text file_path = Join(path_parts, "/");  // "data/2023/Q1/sales.csv"
```

### Set Split(Text str, Text sep)
Splits a text string into a set of substrings using a delimiter.

**Parameters**
- `str` (`Text`): string to split
- `sep` (`Text`): delimiter string

**Returns**
- `Set`: collection of substring parts

**Example**
```tol
// Parse CSV data
Text csv_line = "Apple,123.45,NASDAQ";
Set fields = Split(csv_line, ",");  // ["Apple", "123.45", "NASDAQ"]

// Parse file paths
Text path = "data/2023/Q1/sales.csv";
Set parts = Split(path, "/");  // ["data", "2023", "Q1", "sales.csv"]

// Process text data
Text sentence = "The quick brown fox";
Set words = Split(sentence, " ");
```

### Real Length(Text str)
Returns the length of a text string in characters.

**Parameters**
- `str` (`Text`): input string

**Returns**
- `Real`: number of characters in the string

**Example**
```tol
Text message = "Hello, World!";
Real len = Length(message);  // Returns 13

// Validate input length
Text user_input = GetUserInput();
if (Length(user_input) > 100) {
    Write("Input too long, maximum 100 characters");
}
```

### Text SubText(Text str, Real start, Real length)
Extracts a substring from a text string.

**Parameters**
- `str` (`Text`): source string
- `start` (`Real`): starting position (1-based)
- `length` (`Real`): number of characters to extract

**Returns**
- `Text`: extracted substring

**Example**
```tol
Text full_name = "John Smith";
Text first_name = SubText(full_name, 1, 4);    // "John"
Text last_name = SubText(full_name, 6, 5);     // "Smith"

// Extract file extension
Text filename = "data.csv";
Real dot_pos = Find(filename, ".");
Text extension = SubText(filename, dot_pos + 1, Length(filename));
```

### Real Find(Text str, Text pattern)
Finds the position of a pattern within a text string.

**Parameters**
- `str` (`Text`): string to search in
- `pattern` (`Text`): pattern to find

**Returns**
- `Real`: position of first occurrence (1-based), or 0 if not found

**Example**
```tol
Text email = "user@example.com";
Real at_pos = Find(email, "@");  // Returns 5

// Validate email format
if (at_pos > 0 && Find(email, ".") > at_pos) {
    Write("Valid email format");
}
```

## Mathematical Utility Functions

### Real Min(Set values)
Returns the minimum value from a collection.

**Parameters**
- `values` (`Set`): collection of numeric values

**Returns**
- `Real`: minimum value

**Example**
```tol
Set prices = [123.45, 67.89, 90.12, 156.78];
Real lowest_price = Min(prices);  // Returns 67.89

// Find minimum across multiple series
Serie sales_q1 = LoadSeries("Q1_sales.csv");
Serie sales_q2 = LoadSeries("Q2_sales.csv");
Real min_sales = Min([Min(sales_q1), Min(sales_q2)]);
```

### Real Max(Set values)
Returns the maximum value from a collection.

**Parameters**
- `values` (`Set`): collection of numeric values

**Returns**
- `Real`: maximum value

### Real Mean(Set values)
Calculates the arithmetic mean of a collection of values.

**Parameters**
- `values` (`Set`): collection of numeric values

**Returns**
- `Real`: arithmetic mean

**Example**
```tol
Set test_scores = [85, 92, 78, 96, 88];
Real average_score = Mean(test_scores);  // Returns 87.8

// Calculate portfolio return
Set stock_returns = [0.05, -0.02, 0.08, 0.03];
Real portfolio_return = Mean(stock_returns);
```

### Real Sum(Set values)
Calculates the sum of all values in a collection.

**Parameters**
- `values` (`Set`): collection of numeric values

**Returns**
- `Real`: sum of all values

## Configuration Management

### NameBlock TolConfigManager
Global configuration management system for TOL applications.

**Properties**
- `Config`: Configuration namespace containing user settings
- `path`: Path to configuration file

**Example**
```tol
// Access configuration settings
Real max_iterations = TolConfigManager.Config.MaxIterations;
Text data_directory = TolConfigManager.Config.DataPath;

// Update configuration
TolConfigManager.Config.LogLevel = "DEBUG";
TolConfigManager.SaveConfig();
```

### Void LoadConfig(Real force_reload)
Loads configuration from file.

**Parameters**
- `force_reload` (`Real`): if non-zero, forces reload even if already loaded

### Void SaveConfig()
Saves current configuration to file.

## Package and Module Management

### Void Include(Text filename)
Includes and executes another TOL file.

**Parameters**
- `filename` (`Text`): path to TOL file to include

**Example**
```tol
// Load utility functions
Set Include("utilities.tol");

// Load configuration
Set Include("config.tol");

// Conditional loading
if (OSFileExist("optional_module.tol")) {
    Set Include("optional_module.tol");
}
```

### Bool PackageLoaded(Text package_name)
Checks if a package has been loaded.

**Parameters**
- `package_name` (`Text`): name of package to check

**Returns**
- `Bool`: true if package is loaded

## Date and Time Utilities

### Date Today()
Returns the current date.

**Returns**
- `Date`: current system date

**Example**
```tol
Date current_date = Today();
Text date_string = Text(current_date);

// Generate timestamped filenames
Text filename = "report_" + Text(Today()) + ".csv";
```

### Real Year(Date d)
Extracts the year from a date.

**Parameters**
- `d` (`Date`): input date

**Returns**
- `Real`: year component

### Real Month(Date d)
Extracts the month from a date.

### Real Day(Date d)
Extracts the day from a date.

## Data Conversion Functions

### Text Text(Any value)
Converts any value to its text representation.

**Parameters**
- `value` (`Any`): value to convert

**Returns**
- `Text`: text representation

**Example**
```tol
Real number = 123.456;
Text number_text = Text(number);  // "123.456"

Date today = Today();
Text date_text = Text(today);     // "y2023m06d14"
```

### Real Real(Text str)
Converts text to real number.

**Parameters**
- `str` (`Text`): numeric string to convert

**Returns**
- `Real`: converted number

**Example**
```tol
Text price_text = "123.45";
Real price = Real(price_text);  // 123.45

// Parse user input
Text user_input = GetUserInput();
Real user_number = Real(user_input);
```

## Data Types

### Core Types
- `Real`: Numeric values and calculations
- `Text`: String data and text processing
- `Set`: Collections and data structures
- `Date`: Date and time values
- `Bool`: Boolean logic values

### Configuration Types
- `NameBlock`: Configuration containers and namespaces
- `Handle`: System resource handles

## Integration Notes

The standard library integrates with all other TOL modules:

- **Mathematical operations**: Provides utility functions that complement bmath
- **Statistical analysis**: Supplies data manipulation functions for bstat
- **File I/O**: Text processing functions work with system_io operations
- **Database connectivity**: Data conversion functions support database operations
- **Plotting**: Utility functions prepare data for visualization

### Package Loading System
```tol
// Standard package loading
Set Include("statistics_package.tol");
Set Include("plotting_utilities.tol");

// Conditional package loading
if (PackageLoaded("advanced_stats")) {
    // Use advanced statistical functions
} else {
    // Fall back to basic functions
}
```

## Performance Considerations

### Function Implementation
- Core functions implemented in optimized C++ for performance
- Text operations use efficient string handling
- Mathematical functions delegate to bmath for heavy computation
- Random number generation uses high-quality algorithms

### Memory Management
- Automatic memory management for all data types
- Efficient string handling with copy-on-write semantics
- Set operations optimized for common use cases
- Configuration data cached in memory

### Best Practices
- Use appropriate data types for specific tasks
- Leverage built-in functions rather than implementing from scratch
- Cache frequently accessed configuration values
- Use vectorized operations when possible

## Error Handling
Standard library functions provide comprehensive error handling:
- Type conversion errors with descriptive messages
- File access errors for Include operations
- Configuration loading and saving errors
- Invalid parameter validation
- Graceful handling of edge cases

## Common Use Cases

### Data Processing Pipeline
```tol
// Load and process data
Set raw_data = LoadCSV("input.csv");
Set processed = For(1, Card(raw_data), Real(Real i) {
    Text line = raw_data[i];
    Set fields = Split(line, ",");
    Real value = Real(fields[2]);
    value * 1.1  // Apply 10% markup
});
```

### Configuration-Driven Analysis
```tol
// Load configuration
Set Include("analysis_config.tol");

// Use configuration values
Real threshold = TolConfigManager.Config.Threshold;
Text output_dir = TolConfigManager.Config.OutputDirectory;

// Perform analysis based on configuration
if (threshold > 0) {
    Set filtered_data = FilterData(raw_data, threshold);
}
```

### Text Report Generation
```tol
// Generate formatted report
Set results = PerformAnalysis();
Text report_header = "Analysis Report - " + Text(Today());
Set report_lines = [report_header, "=" * Length(report_header)];

For(1, Card(results), Real(Real i) {
    Text line = "Result " + Text(i) + ": " + Text(results[i]);
    report_lines = report_lines + [line];
});

Text final_report = Join(report_lines, "\n");
```

## Related Modules
- **[Mathematical Operations (bmath)](mathematical_operations.md)**: Advanced mathematical functions
- **[File System Integration (system_io)](file_system_integration.md)**: File and system operations
- **[Statistical Analysis (bstat)](statistical_analysis.md)**: Statistical computations
- **[Core Data Types (btol_core)](core_data_types.md)**: Fundamental data type operations
