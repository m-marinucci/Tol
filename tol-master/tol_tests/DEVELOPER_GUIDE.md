# TOL Testing Framework - Developer Guide

**Issue**: NUM-11 - P0: Comprehensive Cross-Platform Testing Framework  
**Author**: Massimiliano Marinucci  
**Date**: 2025-07-06  

## Table of Contents

1. [Quick Start](#quick-start)
2. [Adding New Tests](#adding-new-tests)
3. [Test Categories](#test-categories)
4. [Platform-Specific Testing](#platform-specific-testing)
5. [Performance Testing](#performance-testing)
6. [CMake Integration](#cmake-integration)
7. [Reporting System](#reporting-system)
8. [Best Practices](#best-practices)

## Quick Start

### Prerequisites

- TOL interpreter installed and accessible
- CMake 3.16 or higher
- Python 3.6+ (for report generation)

### Building and Running Tests

```bash
# Configure with CMake
mkdir build && cd build
cmake ../tol_tests

# Run all tests
make test

# Run specific test categories
make test_unit
make test_performance
make test_integration

# Generate reports
make test_reports
```

## Adding New Tests

### 1. Unit Tests

Create a new unit test by adding a directory under `unit_tests/`:

```bash
mkdir unit_tests/my_new_module
```

Create `unit_tests/my_new_module/test.tol`:

```tol
//////////////////////////////////////////////////////////////////////////////
// FILE   : test.tol
// PURPOSE: Unit tests for my_new_module
// AUTHOR : Your Name
// DATE   : YYYY-MM-DD
//////////////////////////////////////////////////////////////////////////////

Text email_   = "your.email@company.com"; 
Text link_    = "https://linear.app/numinate/issue/NUM-XX";
Text summary_ = "my_new_module unit tests";

Real numErr0 = Copy(NError);

//////////////////////////////////////////////////////////////////////////////
// Test 1: Basic Functionality
//////////////////////////////////////////////////////////////////////////////

WriteLn("Testing basic functionality...");

// Your test implementation here
Real test1 = 1; // Replace with actual test logic

If(!test1, { 
  WriteLn("FAIL: Basic functionality test");
});

//////////////////////////////////////////////////////////////////////////////
// Test Results Compilation
//////////////////////////////////////////////////////////////////////////////

Real numErr1 = Copy(NError);

Set partialResults_ = 
[[
  Real numErr0,
  Real numErr1,
  Real test1
]];

Real quality_ = And(numErr0 == numErr1, test1);

Text platform = DetectPlatform();
Real executionTime = 1.0; // Measure actual execution time
Real memoryUsage = 10.0;  // Measure actual memory usage

Text resultStr_ = EnhancedTestStatus(summary_, link_, quality_,
                  "Partial results = " << partialResults_,
                  platform, executionTime, memoryUsage, email_);

WriteLn("" << resultStr_);
resultStr_
```

### 2. Integration Tests

Create integration tests under `integration_tests/`:

```bash
mkdir integration_tests/my_integration_test
```

Integration tests should focus on:
- Cross-module interactions
- Data flow validation
- End-to-end workflows
- System-level functionality

### 3. Performance Tests

Create performance tests under `performance_tests/`:

```bash
mkdir performance_tests/my_performance_test
```

Performance tests should include:
- Execution time measurement
- Memory usage monitoring
- Throughput testing
- Baseline comparisons

Example performance test structure:

```tol
Real startTime = StartTimer();

// Your performance test code here
For(1, iterations, Real(Real i)
{
  // Performance-critical operations
});

Real endTime = EndTimer(startTime);
Real executionTime = endTime;

// Compare against baseline
Real baseline = 5.0; // seconds
Real performanceQuality = If(executionTime <= baseline, 1, 0);
```

### 4. Platform-Specific Tests

Create platform tests under `platform_tests/`:

```bash
mkdir platform_tests/my_platform_test
```

Use platform detection:

```tol
Text platform = DetectPlatform();

If(platform == "Linux_x86_64", {
  // Linux-specific tests
});

If(platform == "Windows_x86_64", {
  // Windows-specific tests
});

If(platform == "macOS_x86_64", {
  // macOS-specific tests
});
```

## Test Categories

### Unit Tests (`unit_tests/`)
- **Purpose**: Test individual modules and functions
- **Scope**: Single module or component
- **Timeout**: 300 seconds (default)
- **Focus**: Correctness, edge cases, error handling

### Integration Tests (`integration_tests/`)
- **Purpose**: Test module interactions
- **Scope**: Multiple modules working together
- **Timeout**: 600 seconds (default)
- **Focus**: Data flow, interfaces, workflows

### Performance Tests (`performance_tests/`)
- **Purpose**: Measure and validate performance
- **Scope**: Performance-critical operations
- **Timeout**: 1200 seconds (default)
- **Focus**: Speed, memory usage, scalability

### Platform Tests (`platform_tests/`)
- **Purpose**: Validate cross-platform compatibility
- **Scope**: Platform-specific functionality
- **Timeout**: 300 seconds (default)
- **Focus**: Portability, platform differences

### Memory Tests (`memory_tests/`)
- **Purpose**: Detect memory issues
- **Scope**: Memory allocation and deallocation
- **Timeout**: 600 seconds (default)
- **Focus**: Memory leaks, usage patterns

## Platform-Specific Testing

### Supported Platforms

- **Linux**: `Linux_x86_32`, `Linux_x86_64`
- **Windows**: `Windows_x86_32`, `Windows_x86_64`
- **macOS**: `macOS_x86_64`, `macOS_arm64`

### Platform Detection

```tol
Text DetectPlatform()
{
  Real platformId = GetHardSoftPlattform(0);
  
  If(platformId == 1, { return "Linux_x86_32" });
  If(platformId == 2, { return "Linux_x86_64" });
  If(platformId == 3, { return "Windows_x86_32" });
  If(platformId == 4, { return "Windows_x86_64" });
  
  return "Unknown_Platform"
}
```

### Platform-Specific Test Execution

Tests can be conditionally executed based on platform:

```tol
Text currentPlatform = DetectPlatform();

If(currentPlatform == "Linux_x86_64", {
  // Linux-specific test logic
  Real linuxTest = TestLinuxSpecificFeature();
});

If(currentPlatform == "Windows_x86_64", {
  // Windows-specific test logic
  Real windowsTest = TestWindowsSpecificFeature();
});
```

## Performance Testing

### Performance Measurement

```tol
// Load performance framework
Set Include("enhanced_test_framework.tol");

// Create performance benchmark
@PerformanceBenchmark benchmark = BenchmarkOperation("matrix_multiplication", 
  Code({
    Matrix a = MatRand(100, 100);
    Matrix b = MatRand(100, 100);
    Matrix c = a * b;
  })
);

// Validate against threshold
Real threshold = 5.0; // seconds
Real quality = If(benchmark.executionTime <= threshold, 1, 0);
```

### Performance Baselines

Establish baselines for critical operations:

```tol
// Matrix operations (100x100, 5 iterations)
Real matrixCreationBaseline = 2.0;    // seconds
Real matrixAdditionBaseline = 1.0;    // seconds
Real matrixMultiplicationBaseline = 5.0; // seconds

// Memory usage
Real unitTestMemoryBaseline = 100.0;  // MB
Real performanceTestMemoryBaseline = 500.0; // MB
```

## CMake Integration

### Adding Tests to CMake

Tests are automatically discovered by CMake. To manually add a test:

```cmake
add_tol_test(
    NAME my_custom_test
    CATEGORY unit
    FILES "${CMAKE_CURRENT_SOURCE_DIR}/my_test.tol"
    TIMEOUT 300
    LABELS "custom;important"
)
```

### CMake Configuration Options

```bash
# Enable/disable test categories
cmake -DTOL_TESTS_ENABLE_PERFORMANCE=OFF ../tol_tests

# Set custom timeouts
cmake -DTOL_TESTS_UNIT_TIMEOUT=600 ../tol_tests

# Enable parallel execution
cmake -DTOL_TESTS_PARALLEL=ON ../tol_tests
```

### Custom CMake Targets

```bash
# Run specific test categories
make test_unit          # Unit tests only
make test_integration   # Integration tests only
make test_performance   # Performance tests only
make test_platform      # Platform tests only
make test_memory        # Memory tests only

# Run comprehensive suite
make test_comprehensive

# Run tests in parallel
make test_parallel

# Generate reports
make test_reports
```

## Reporting System

### Report Formats

The framework generates multiple report formats:

1. **JSON**: Machine-readable, API-friendly
2. **XML**: Structured data format
3. **JUnit XML**: CI/CD integration
4. **HTML**: Human-readable with interactive features

### Report Generation

```bash
# Automatic report generation
make test_reports

# Manual report generation
python3 scripts/generate_reports.py --input ./build --output ./reports
```

### Custom Reporting

Extend the reporting system by modifying `enhanced_reporting_framework.tol`:

```tol
// Add custom report format
Text GenerateCustomReport(@TestReport report)
{
  // Your custom report implementation
  Text customReport = "Custom format: " + report.testSuiteName;
  customReport
}
```

## Best Practices

### Test Design

1. **Isolation**: Each test should be independent
2. **Deterministic**: Tests should produce consistent results
3. **Fast**: Unit tests should complete quickly
4. **Clear**: Test names and purposes should be obvious
5. **Comprehensive**: Cover normal cases, edge cases, and error conditions

### Error Handling

```tol
Real numErr0 = Copy(NError);

Try
{
  // Test code that might fail
  Real result = RiskyOperation();
}
Catch(Text error)
{
  WriteLn("Expected error caught: " + error);
}

Real numErr1 = Copy(NError);
Real errorHandlingTest = EQ(numErr0, numErr1);
```

### Memory Management

```tol
// Monitor memory usage
Real startMemory = GetMemoryUsage();

// Test code
Matrix largeMatrix = MatRand(1000, 1000);

Real endMemory = GetMemoryUsage();
Real memoryUsed = endMemory - startMemory;

// Validate memory usage is within limits
Real memoryTest = LT(memoryUsed, 100.0); // 100 MB limit
```

### Performance Testing

```tol
// Use multiple iterations for stable measurements
Real iterations = 5;
Real totalTime = 0;

For(1, iterations, Real(Real i)
{
  Real startTime = StartTimer();
  
  // Performance test code
  PerformanceOperation();
  
  Real endTime = EndTimer(startTime);
  totalTime = totalTime + endTime;
});

Real averageTime = totalTime / iterations;
```

### Documentation

- Include clear test descriptions
- Document expected behavior
- Explain complex test logic
- Provide contact information
- Link to relevant issues/tickets

---

**Contact**: mmarinucci@numinate.com  
**Linear Issue**: https://linear.app/numinate/issue/NUM-11  
**Last Updated**: 2025-07-06
