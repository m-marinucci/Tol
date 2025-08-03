# Contributing to TOL

Thank you for your interest in contributing to TOL (Time-Oriented Language)! This document provides guidelines for contributing to the project.

## Getting Started

### Prerequisites

Before contributing, ensure you have:
- A working TOL development environment (see [README.md](README.md) for setup instructions)
- Git configured with your name and email
- Familiarity with C++ and TOL language syntax

### Development Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/m-marinucci/Tol.git
   cd Tol/tol-master/tol
   ```

2. **Build the project:**
   ```bash
   mkdir build && cd build
   cmake .. -DCMAKE_BUILD_TYPE=Debug -DENABLE_TESTING=ON
   make -j$(nproc)
   ```

3. **Run tests:**
   ```bash
   make test
   ```

## Contribution Guidelines

### Code Quality Standards

All contributions must meet the following quality standards:

#### C++ Code Standards
- **Compiler Warnings**: Code must compile cleanly with `-Wall -Wextra` on GCC and Clang
- **Memory Safety**: No memory leaks detected by valgrind
- **Static Analysis**: Clean results from cppcheck and clang-tidy
- **Modern C++**: Use C++11+ features appropriately (auto, nullptr, range-based loops)

#### Documentation Standards
- **Markdown Linting**: All markdown files must pass markdownlint validation
- **Code Comments**: Complex algorithms and public APIs must be documented
- **Commit Messages**: Follow conventional commit format

### Issue Management and Escalation Path

#### Agent Coordination System

When working on complex issues, follow this escalation path for efficient collaboration:

1. **Phase 1: Individual Agent Work**
   - Agents work on focused, well-defined sub-issues
   - Each agent addresses their specific domain (memory, warnings, analysis, modernization)
   - Regular status updates via issue comments

2. **Phase 2: Integration Coordination**
   - Cross-dependencies between agents are identified and managed
   - Integration testing performed across all changes
   - Conflicts resolved through collaborative discussion

3. **Phase 3: Quality Assurance**
   - Combined changes tested as a cohesive unit
   - Performance impact assessed
   - Final quality gates verified

#### Issue Splitting Best Practices

Large issues should be split into focused sub-issues following this pattern:

- **Memory Issues** (#85): Focus on valgrind-detected leaks
- **Compiler Warnings** (#86): Address all warning categories systematically  
- **Static Analysis** (#87): Handle cppcheck, clang-tidy findings
- **Code Modernization** (#88): Apply C++11+ features appropriately

Each sub-issue should have:
- Clear acceptance criteria
- Independent deliverables where possible
- Cross-reference to related issues
- Testing strategy specific to the changes

### Code Review Process

1. **Pre-submission Checklist:**
   - [ ] Code compiles without warnings (`-Wall -Wextra`)
   - [ ] All tests pass (`make test`)
   - [ ] No memory leaks (`valgrind --leak-check=full`)
   - [ ] Static analysis clean (`cppcheck`, `clang-tidy`)
   - [ ] Documentation updated if needed

2. **Pull Request Requirements:**
   - Descriptive title and summary
   - Reference to related issues
   - Test plan description
   - Screenshots/examples for UI changes

3. **Review Criteria:**
   - Code functionality and correctness
   - Performance impact assessment
   - Security considerations
   - Maintainability and readability

## Markdown Linting Configuration

This project uses markdownlint to ensure consistent documentation formatting. The configuration is in `.markdownlint.json`.

### Key Configuration Settings

- **MD040 (code-language)**: Disabled to resolve conflicts with AI code suggestions
- **MD013 (line-length)**: Disabled to allow longer lines where appropriate
- **MD046 (code-block-style)**: Set to "fenced" for consistency
- **MD033 (no-inline-html)**: Allows specific HTML elements (details, summary, img, etc.)

### Running Markdownlint

```bash
# Install markdownlint-cli if not already installed
npm install -g markdownlint-cli

# Check all markdown files
markdownlint **/*.md

# Fix auto-fixable issues
markdownlint --fix **/*.md
```

### Handling Markdownlint Issues

1. **Auto-fix when possible:** Use `markdownlint --fix` for mechanical fixes
2. **Manual review required:** Some issues need contextual decisions
3. **Suppression:** Use HTML comments for legitimate exceptions:
   ```html
   <!-- markdownlint-disable MD001 -->
   ### This heading is intentionally not H2
   <!-- markdownlint-enable MD001 -->
   ```

## Testing

### Test Categories

1. **Unit Tests**: Test individual components and functions
2. **Integration Tests**: Test component interactions
3. **Performance Tests**: Ensure no performance regressions
4. **Memory Tests**: Verify no memory leaks with valgrind
5. **Platform Tests**: Cross-platform compatibility

### Running Specific Test Types

```bash
# Run all tests
make test

# Run specific test categories
make test_unit
make test_performance
make test_memory

# Run comprehensive test suite
cd ../tol_tests
./run_comprehensive_tests.sh
```

## Build System

TOL uses CMake as its primary build system. Key files:

- `CMakeLists.txt`: Main build configuration
- `cmake/Testing.cmake`: Test framework configuration
- `cmake/modules/`: CMake helper modules

### Common Build Configurations

```bash
# Debug build with all tests
cmake .. -DCMAKE_BUILD_TYPE=Debug -DENABLE_TESTING=ON

# Release build
cmake .. -DCMAKE_BUILD_TYPE=Release

# Build with static analysis
cmake .. -DCMAKE_CXX_FLAGS="-Wall -Wextra -Werror"
```

## Debugging

### Common Debugging Scenarios

1. **Memory Issues:**
   ```bash
   valgrind --leak-check=full --show-leak-kinds=all ./tolcon script.tol
   ```

2. **Performance Issues:**
   ```bash
   perf record ./tolcon script.tol
   perf report
   ```

3. **Crash Analysis:**
   ```bash
   gdb ./tolcon
   (gdb) run script.tol
   (gdb) bt
   ```

## Platform-Specific Notes

### Linux
- Use system package manager for dependencies
- Ensure BLAS/LAPACK compatibility

### macOS
- Use Homebrew for dependencies
- Consider Apple Silicon vs Intel differences
- Use Accelerate framework when available

### Windows
- MinGW and Visual Studio builds supported
- Handle path separator differences
- Ensure proper library linking

## Community

### Communication Channels

- **Issues**: Use GitHub issues for bug reports and feature requests
- **Discussions**: Use GitHub discussions for questions and ideas
- **Code Review**: All changes reviewed via pull requests

### Code of Conduct

- Be respectful and professional
- Focus on technical merit
- Help others learn and contribute
- Follow project coding standards

## Release Process

1. **Version Preparation**: Update version numbers and changelog
2. **Quality Gates**: All tests pass, documentation updated
3. **Release Notes**: Document new features and breaking changes
4. **Packaging**: Create platform-specific packages
5. **Announcement**: Communicate release to community

## Getting Help

- Check existing issues and documentation first
- Create detailed bug reports with reproduction steps
- Include system information and build configuration
- Provide minimal test cases when possible

Thank you for contributing to TOL! Your efforts help make this project better for everyone.