# TOL CI/CD Pipeline Documentation

## Overview

This document describes the comprehensive CI/CD pipeline implemented for the TOL (Time Oriented Language) project. The pipeline provides automated builds, testing, quality assurance, documentation deployment, and release management across multiple platforms.

## Pipeline Components

### 1. GitHub Actions Workflows

#### Main CI/CD Pipeline (`.github/workflows/ci-cd.yml`)
- **Multi-platform builds**: Linux (GCC 9-12) + Windows (MSVC)
- **Automated testing**: Unit tests, integration tests, memory leak detection
- **Quality assurance**: Static analysis, code formatting, coverage reporting
- **Performance monitoring**: Benchmarking with regression detection
- **Documentation deployment**: Automated Doxygen + user manual generation
- **Release automation**: Multi-platform package creation with checksums

#### Infrastructure Validation (`.github/workflows/ci-test.yml`)
- **Component verification**: All CI/CD files and scripts validated
- **Permission checks**: Executable scripts and syntax validation
- **Integration testing**: CMake testing framework verification

### 2. Automation Scripts

#### Performance Monitoring (`performance_monitor.sh`)
- System information collection
- Multi-iteration benchmarking with statistical analysis
- Baseline comparison and regression detection
- JSON output for CI/CD integration

#### Documentation Deployment (`deploy_docs.sh`)
- Automated Doxygen API documentation generation
- User manual creation with examples
- GitHub Pages deployment ready

#### Release Automation (`create_release.sh`)
- Multi-platform package creation (Linux tar.gz, Windows zip)
- Source code packaging with checksums
- Installation script generation
- Release notes automation

### 3. CMake Testing Integration

#### Testing Framework (`tol/cmake/Testing.cmake`)
- CTest integration with automated test discovery
- Code coverage analysis with lcov
- Memory leak detection with Valgrind
- Performance benchmarking capabilities
- Cross-platform test execution

## Usage

### Enabling Testing

To enable the testing framework during build:

```bash
cd tol
mkdir build && cd build
cmake .. -DENABLE_TESTING=ON -DCOVERAGE_ENABLED=ON
make -j$(nproc)
ctest --output-on-failure
```

### Running Specific Test Categories

```bash
# Run all tests
make test_all

# Run only unit tests
make test_unit

# Run performance tests
make test_performance

# Run memory leak tests
make test_memory
```

### Manual Performance Monitoring

```bash
# Run performance benchmarks
./.github/scripts/performance_monitor.sh ./tol/build/bin/tolcon results.json

# Compare with baseline
./.github/scripts/performance_monitor.sh ./tol/build/bin/tolcon results.json baseline.json
```

### Manual Documentation Generation

```bash
# Generate documentation
./.github/scripts/deploy_docs.sh

# Documentation will be available in docs/index.html
```

### Manual Release Creation

```bash
# Create release packages
./.github/scripts/create_release.sh v1.0.0

# Packages will be available in release/ directory
```

## Workflow Triggers

### Automatic Triggers
- **Push to branches**: master, develop, feature/cicd-pipeline-clean
- **Pull requests to**: master, develop
- **Tag-based releases**: v* (e.g., v1.0.0)

### Manual Triggers
- **Workflow dispatch**: Can be triggered manually from GitHub Actions UI

## Build Matrix

### Linux Builds
- **OS**: Ubuntu Latest
- **Compilers**: GCC 9, 10, 11, 12
- **Dependencies**: GSL, FFTW3, LAPACK, BLAS, zlib

### Windows Builds
- **OS**: Windows Latest
- **Compiler**: MSVC with vcpkg dependencies
- **Dependencies**: GSL, FFTW3, LAPACK, zlib (via vcpkg)

## Quality Gates

### Static Analysis
- **Tool**: cppcheck
- **Scope**: All C/C++ source files
- **Output**: XML report uploaded as artifact

### Code Formatting
- **Tool**: clang-format-12
- **Standard**: Project-defined formatting rules
- **Enforcement**: Dry-run check with error on violations

### Code Coverage
- **Tool**: lcov (Linux GCC-11 build only)
- **Integration**: Codecov for reporting
- **Threshold**: Configurable (currently informational)

### Memory Leak Detection
- **Tool**: Valgrind
- **Scope**: Key executables and test cases
- **Suppressions**: External library false positives suppressed

## Performance Monitoring

### Benchmarks
- **Arithmetic operations**: 1M iteration performance test
- **Startup time**: Application initialization benchmark
- **Memory allocation**: Array creation and manipulation
- **Cross-platform comparison**: Performance across build configurations

### Regression Detection
- **Threshold**: 10% performance degradation triggers alert
- **Baseline**: Automatically maintained and updated
- **Reporting**: JSON format with statistical analysis

## Documentation Deployment

### API Documentation
- **Generator**: Doxygen
- **Format**: HTML with search functionality
- **Scope**: All public APIs and interfaces

### User Manual
- **Format**: HTML with responsive design
- **Content**: Installation guides, examples, tutorials
- **Deployment**: GitHub Pages (on master branch pushes)

## Release Management

### Artifact Types
- **Linux packages**: tar.gz for each GCC version
- **Windows packages**: zip with MSVC build
- **Source packages**: Clean source code without build artifacts
- **Documentation packages**: Complete documentation bundle

### Verification
- **Checksums**: SHA256 for all packages
- **Signatures**: Available for release verification
- **Installation scripts**: Automated installers for both platforms

## Troubleshooting

### Common Issues

#### Build Failures
1. **Dependency issues**: Check package installation in workflow
2. **Compiler errors**: Verify GCC/MSVC compatibility
3. **CMake configuration**: Check CMakeLists.txt modifications

#### Test Failures
1. **Test discovery**: Verify test files exist in expected locations
2. **Environment**: Check TOL_BIN_PATH environment variable
3. **Timeouts**: Adjust CTEST_TEST_TIMEOUT if needed

#### Performance Regressions
1. **False positives**: Check system load during benchmarking
2. **Baseline drift**: Update baseline if legitimate changes occurred
3. **Platform differences**: Compare like-with-like configurations

### Debug Information

#### Workflow Logs
- All steps provide detailed logging
- Artifacts are preserved for analysis
- Error messages include context and suggestions

#### Local Testing
- All scripts can be run locally for debugging
- CMake testing framework works in development environment
- Performance monitoring provides detailed statistics

## Maintenance

### Regular Tasks
- **Baseline updates**: Review and update performance baselines quarterly
- **Dependency updates**: Keep CI dependencies current
- **Documentation review**: Ensure documentation stays current with code changes

### Configuration Updates
- **Compiler versions**: Add new GCC versions as they become stable
- **Dependencies**: Update library versions in CI configuration
- **Test coverage**: Add new test categories as project grows

## Security Considerations

### Secrets Management
- **GitHub tokens**: Used for documentation deployment and releases
- **Access control**: Limited to necessary permissions only
- **Artifact security**: Checksums prevent tampering

### Code Quality
- **Static analysis**: Identifies potential security issues
- **Memory safety**: Valgrind detects memory-related vulnerabilities
- **Dependency scanning**: Regular updates prevent known vulnerabilities

---

For questions or issues with the CI/CD pipeline, please create an issue in the GitHub repository or contact the development team.
