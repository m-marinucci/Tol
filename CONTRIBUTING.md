# Contributing to TOL

Thank you for your interest in contributing to TOL (Time-Oriented Language)! We welcome contributions from the community and are grateful for any help you can provide.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)
- [Documentation](#documentation)
- [Community](#community)

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- **Be respectful** - Treat all contributors with respect and kindness
- **Be constructive** - Provide helpful feedback and suggestions
- **Be inclusive** - Welcome contributors of all backgrounds and experience levels
- **Be collaborative** - Work together to improve the project

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:

   ```bash
   git clone https://github.com/YOUR-USERNAME/Tol.git
   cd Tol
```text

3. **Add the upstream remote**:

   ```bash
   git remote add upstream https://github.com/InverenceBBS/Tol.git
```text

4. **Keep your fork up to date**:

   ```bash
   git fetch upstream
   git checkout master
   git merge upstream/master
```bash

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **Bug fixes** - Fix reported issues or bugs you discover
- **Features** - Implement new features or enhance existing ones
- **Documentation** - Improve or add documentation
- **Tests** - Add test coverage for existing code
- **Performance** - Optimize code for better performance
- **Refactoring** - Improve code structure and maintainability

### Finding Issues to Work On

- Check our [Issues](https://github.com/InverenceBBS/Tol/issues) page
- Look for issues labeled `good first issue` for beginner-friendly tasks
- Issues labeled `help wanted` need community assistance
- Feel free to propose new features by creating an issue first

## Development Setup

### Prerequisites

Ensure you have the following installed:

- C++ compiler (GCC 7+ or Clang 5+)
- CMake 3.10+ or Autotools
- Git
- Required libraries:
  - GSL (GNU Scientific Library)
  - FFTW3
  - LAPACK/BLAS
  - Boost
  - CHOLMOD (optional)
  - Tcl/Tk 8.5+ (optional, for GUI components)

### Building TOL

#### Using CMake (Recommended)

```bash
cd tol-master
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j$(nproc)

#### Using Autotools

```bash
cd tol-master/tol
./bootstrap
./configure --enable-debug
make -j$(nproc)

### Running Tests

```bash
# From the build directory
make test

# Or run the test suite directly
cd ../tol_tests
./run_all_tests.sh
```text

## Coding Standards

### C++ Code Style

- **Indentation**: Use 2 spaces (no tabs)
- **Line length**: Maximum 80 characters
- **Naming conventions**:
  - Classes: `PascalCase` (e.g., `BMatrix`, `TimeSet`)
  - Functions/Methods: `PascalCase` (e.g., `GetValue`, `Calculate`)
  - Variables: `camelCase` (e.g., `timeValue`, `matrixSize`)
  - Constants: `UPPER_SNAKE_CASE` (e.g., `MAX_SIZE`)
  - Private members: prefix with underscore (e.g., `_privateVar`)

- **File organization**:
  - Headers: `.h` extension in appropriate module directory
  - Implementation: `.cpp` files
  - One class per file when possible

Example:

```cpp
// tol_bmatrix.h
#ifndef TOL_BMATRIX_H
#define TOL_BMATRIX_H

class BMatrix {
private:
  int _rows;
  int _cols;
  double* _data;

public:
  BMatrix(int rows, int cols);
  ~BMatrix();
  
  double GetElement(int row, int col) const;
  void SetElement(int row, int col, double value);
};

#endif // TOL_BMATRIX_H
```text

### TOL Language Style

- **Indentation**: Use 2 spaces
- **Function definitions**: Return type, name, parameters
- **Comments**: Use `//` for single-line, `/* */` for multi-line

Example:

```tol
// Calculate moving average of a time series
Serie MovingAverage(Serie data, Real window) {
  Real weight = 1.0 / window;
  Serie result = Filter(data, weight * Ones(window));
  result
};
```text

### Commit Messages

Follow these guidelines for commit messages:

- **Format**:
```text
  <type>: <subject>
  
  <body>
  
  <footer>
```text

- **Types**:
  - `feat`: New feature
  - `fix`: Bug fix
  - `docs`: Documentation changes
  - `style`: Code style changes (formatting, etc.)
  - `refactor`: Code refactoring
  - `perf`: Performance improvements
  - `test`: Test additions or modifications
  - `build`: Build system changes
  - `ci`: CI configuration changes

- **Subject**: 50 characters or less, imperative mood
- **Body**: Detailed explanation if needed, wrapped at 72 characters
- **Footer**: Reference issues (e.g., `Fixes #123`)

Example:

```text
feat: Add sparse matrix multiplication support

Implement efficient sparse matrix multiplication using CHOLMOD
library. This improves performance for large sparse matrices
commonly used in time series analysis.

Fixes #456
```text

## Testing

### Writing Tests

- Place tests in `tol_tests/tol/` directory
- Follow naming convention: `test_<feature>.tol`
- Use the test framework: `_tolTester.tol`

Example test:

```tol
// test_matrix_operations.tol
Include("_tolTester.tol");

Text testName = "Matrix Operations Test";

// Test matrix multiplication
Matrix A = ((1, 2), (3, 4));
Matrix B = ((5, 6), (7, 8));
Matrix expected = ((19, 22), (43, 50));
Matrix result = A * B;

Real CheckMatrixMultiplication(Real dummy) {
  Real isEqual = MatrixEqual(result, expected);
  Real isEqual
};

Set tests = [[
  NameBlock("Matrix Multiplication", CheckMatrixMultiplication)
]];

Real RunTests(Real dummy) {
  Real TestGroup(testName, tests)
};
```text

### Test Requirements

- All new features must include tests
- Bug fixes should include regression tests
- Maintain or improve code coverage
- Ensure all tests pass before submitting PR

## Pull Request Process

1. **Create a feature branch**:

   ```bash
   git checkout -b feature/your-feature-name

2. **Make your changes**:
   - Write clean, well-documented code
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes**:

   ```bash
   make test

4. **Commit your changes**:

   ```bash
   git add .
   git commit -m "feat: Add your feature description"
```text

5. **Push to your fork**:

   ```bash
   git push origin feature/your-feature-name
```text

6. **Create a Pull Request**:
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Select your fork and branch
   - Fill out the PR template with:
     - Description of changes
     - Related issue numbers
     - Test results
     - Screenshots (if applicable)

7. **PR Review Process**:
   - Address reviewer feedback promptly
   - Make requested changes
   - Keep PR up to date with master branch
   - Be patient - reviews may take time

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Tests pass locally
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages follow guidelines
- [ ] PR description is complete
- [ ] No merge conflicts with master

## Reporting Issues

### Bug Reports

When reporting bugs, please include:

1. **Environment information**:
   - TOL version
   - Operating system
   - Compiler version
   - Library versions

2. **Steps to reproduce**:
   - Minimal code example
   - Expected behavior
   - Actual behavior

3. **Error messages**:
   - Complete error output
   - Stack traces if available

### Feature Requests

For feature requests, please:

1. **Check existing issues** to avoid duplicates
2. **Describe the feature** clearly
3. **Explain the use case** and benefits
4. **Provide examples** if possible

## Documentation

### Documentation Standards

- **Code comments**: Explain "why" not "what"
- **Function documentation**: Include purpose, parameters, return values
- **Module documentation**: Overview of module functionality
- **User documentation**: Clear, example-driven explanations

Example documentation:

```cpp
/**
 * Performs ARIMA model estimation on time series data
 * 
 * @param series Input time series data
 * @param p AR order
 * @param d Differencing order
 * @param q MA order
 * @return Estimated ARIMA model parameters
 * 
 * @throws InvalidOrderException if orders are negative
 * @throws InsufficientDataException if series too short
 */
ARIMAModel EstimateARIMA(const Serie& series, int p, int d, int q);
```cpp

### Areas Needing Documentation

- API reference for core functions
- Tutorial examples
- Performance optimization guides
- Integration guides for external libraries

## Community

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and discussions
- **Pull Requests**: Code contributions and reviews

### Getting Help

- Check existing documentation
- Search closed issues for similar problems
- Ask in GitHub Discussions
- Be specific and provide context

### Recognition

Contributors are recognized in:

- The AUTHORS file
- Release notes
- Project documentation

## Additional Resources

- [TOL User Manual](tol-master/doc/general/TOL%20User%20Manual.pdf)
- [Development Guide](tol-master/doc/general/comoDesarrolloDeTOL.pdf)
- [Performance Testing](tol-master/doc/performance/)

Thank you for contributing to TOL! Your efforts help make TOL better for everyone in the time-series analysis and mathematical computing community.
