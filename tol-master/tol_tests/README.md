# TOL Comprehensive Cross-Platform Testing Framework

[![Linux Tests](https://img.shields.io/badge/Linux-Supported-green)](PLATFORM_EXAMPLES.md#linux-examples)
[![Windows Tests](https://img.shields.io/badge/Windows-Supported-green)](PLATFORM_EXAMPLES.md#windows-examples)
[![macOS Tests](https://img.shields.io/badge/macOS-Supported-green)](PLATFORM_EXAMPLES.md#macos-examples)

**Issue**: NUM-11 - P0: Comprehensive Cross-Platform Testing Framework
**Author**: Massimiliano Marinucci
**Date**: 2025-07-06
**Status**: ✅ Implemented

## Overview

This is a comprehensive, cross-platform testing framework for the TOL (Tree of Life) project, designed to ensure robust testing across Linux, Windows, and macOS platforms. The framework addresses critical testing requirements following the Linux compatibility fixes in PR 26.

## 🚀 Quick Start

### Prerequisites

- TOL interpreter installed and accessible
- CMake 3.16 or higher
- Python 3.6+ (for report generation)

### Run Tests (Any Platform)

```bash
# Configure and build
mkdir build && cd build
cmake ../

# Run all tests
make test  # Linux/macOS
# OR
cmake --build . && ctest  # Windows

# Generate reports
make test_reports  # Linux/macOS
# OR
cmake --build . --target test_reports  # Windows
```

## 📁 Framework Structure

```
tol_tests/
├── CMakeLists.txt                          # Main CMake configuration
├── cmake/FindTOL.cmake                     # TOL detection module
├── enhanced_test_framework.tol             # Core testing framework
├── enhanced_test_runner.tol                # Main test orchestrator
├── enhanced_reporting_framework.tol        # Multi-format reporting
├── scripts/generate_reports.py             # Report generation tool
├── unit_tests/                             # Unit tests for individual modules
├── integration_tests/                      # Cross-module integration tests
├── platform_tests/                        # Platform-specific tests
├── performance_tests/                      # Performance benchmarks
├── memory_tests/                           # Memory management tests
├── run_comprehensive_tests.sh              # Linux test runner
├── run_comprehensive_tests.bat             # Windows test runner
├── run_comprehensive_tests_macos.sh        # macOS test runner
└── docs/                                   # Documentation
    ├── COMPREHENSIVE_TESTING_FRAMEWORK.md  # Framework overview
    ├── DEVELOPER_GUIDE.md                  # Developer documentation
    └── PLATFORM_EXAMPLES.md                # Platform-specific examples
```

## 🧪 Test Categories

| Category | Purpose | Timeout | Focus |
|----------|---------|---------|-------|
| **Unit Tests** | Individual module validation | 300s | Correctness, edge cases |
| **Integration Tests** | Cross-module functionality | 600s | Data flow, interfaces |
| **Performance Tests** | Performance benchmarking | 1200s | Speed, memory usage |
| **Platform Tests** | Cross-platform compatibility | 300s | Portability |
| **Memory Tests** | Memory management validation | 600s | Leak detection |

## 🎯 Key Features

### ✅ Cross-Platform Support
- **Linux**: Full support with shell script and CMake
- **Windows**: Batch script and CMake integration
- **macOS**: Native support with Homebrew integration

### ✅ Multiple Execution Methods
- **CMake Integration**: Professional build system integration
- **Shell Scripts**: Platform-specific optimized runners
- **Manual Execution**: Direct TOL interpreter usage

### ✅ Comprehensive Reporting
- **JSON**: Machine-readable API-friendly format
- **XML**: Structured data format
- **JUnit XML**: CI/CD integration ready
- **HTML**: Interactive human-readable reports

### ✅ Performance Monitoring
- Execution time measurement
- Memory usage tracking
- Performance baseline validation
- Cross-platform performance comparison

### ✅ CI/CD Ready
- GitHub Actions integration examples
- Docker support
- Vagrant configurations
- Automated report generation

## 📊 Test Coverage

### Modules Tested (PR 26 Fixes)
- **Core Libraries**: bbasic, bmath, bparser, btol
- **Math Libraries**: barith, blinalg, bstat, gsl_ext
- **Data Types**: matrix_type, text_type, serie_type, real_type
- **System Integration**: Platform detection, memory management

### Quality Metrics
- **Success Rate**: ≥ 95% required
- **Code Coverage**: ≥ 80% target
- **Performance**: Baseline compliance
- **Memory**: Zero leak tolerance

## 🛠️ Usage Examples

### Linux
```bash
# Using CMake
mkdir build && cd build && cmake .. && make test

# Using shell script
./run_comprehensive_tests.sh

# Manual execution
tolcon -v enhanced_test_runner.tol
```

### Windows
```cmd
REM Using CMake
mkdir build && cd build && cmake .. && cmake --build . && ctest

REM Using batch script
run_comprehensive_tests.bat

REM Manual execution
tolsh.exe -v enhanced_test_runner.tol
```

### macOS
```bash
# Using CMake
mkdir build && cd build && cmake .. && make test

# Using macOS script
./run_comprehensive_tests_macos.sh

# Manual execution
tolcon -v enhanced_test_runner.tol
```

## 📈 Performance Baselines

| Operation | Baseline | Unit | Platform |
|-----------|----------|------|----------|
| Matrix Creation (100x100) | ≤ 2.0 | seconds | All |
| Matrix Addition | ≤ 1.0 | seconds | All |
| Matrix Multiplication | ≤ 5.0 | seconds | All |
| Unit Test Memory | ≤ 100 | MB | All |
| Performance Test Memory | ≤ 500 | MB | All |

## 🔧 Configuration Options

### CMake Options
```bash
# Enable/disable test categories
-DTOL_TESTS_ENABLE_PERFORMANCE=ON/OFF
-DTOL_TESTS_ENABLE_MEMORY=ON/OFF
-DTOL_TESTS_ENABLE_INTEGRATION=ON/OFF
-DTOL_TESTS_ENABLE_PLATFORM=ON/OFF

# Timeout configuration
-DTOL_TESTS_UNIT_TIMEOUT=300
-DTOL_TESTS_PERFORMANCE_TIMEOUT=1200

# Execution options
-DTOL_TESTS_PARALLEL=ON/OFF
-DTOL_TESTS_GENERATE_REPORTS=ON/OFF
```

### Environment Variables
```bash
export TOL_TEST_OUTPUT_DIR="./test_results"
export TOL_TEST_PLATFORM="Linux_x86_64"
```

## 📚 Documentation

- **[Framework Overview](COMPREHENSIVE_TESTING_FRAMEWORK.md)**: Complete framework documentation
- **[Developer Guide](DEVELOPER_GUIDE.md)**: How to add and modify tests
- **[Platform Examples](PLATFORM_EXAMPLES.md)**: Platform-specific usage examples

## 🚀 Getting Started for Developers

### Adding a New Unit Test

1. Create test directory:
   ```bash
   mkdir unit_tests/my_new_module
   ```

2. Create test file `unit_tests/my_new_module/test.tol`:
   ```tol
   Text summary_ = "my_new_module unit tests";
   Real test1 = 1; // Your test logic here
   Real quality_ = test1;
   Text resultStr_ = EnhancedTestStatus(summary_, "", quality_, "", DetectPlatform(), 1.0, 10.0, "");
   WriteLn(resultStr_);
   resultStr_
   ```

3. Run tests:
   ```bash
   cd build && make test_unit
   ```

## 🔍 Troubleshooting

### Common Issues

1. **TOL Binary Not Found**
   - Ensure TOL is in PATH
   - Check FindTOL.cmake search paths
   - Verify TOL installation

2. **Test Timeouts**
   - Increase timeout values in CMake
   - Check system performance
   - Review test complexity

3. **Memory Issues**
   - Monitor system memory
   - Check for memory leaks
   - Adjust memory limits

## 📞 Support

- **Contact**: mmarinucci@numinate.com
- **Linear Issue**: https://linear.app/numinate/issue/NUM-11
- **Documentation**: See documentation files in this directory

## 🏆 Acceptance Criteria Status

- ✅ Unit tests for all modules fixed in PR 26
- ✅ Integration tests for cross-module functionality
- ✅ Platform-specific test suites (Linux, Windows, macOS)
- ✅ Regression tests for critical functionality
- ✅ Performance benchmarks for mathematical operations
- ✅ Memory leak detection tests
- ✅ Automated test execution scripts
- ✅ Performance baseline measurements
- ✅ Test documentation and guidelines
- ✅ 80% code coverage target framework
- ✅ Cross-platform validation capability

---

**Last Updated**: 2025-07-06
**Framework Version**: 1.0.0
**TOL Compatibility**: All supported versions