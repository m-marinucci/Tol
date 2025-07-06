# TOL Linux Developer Guide

**Version**: 1.0.0  
**Date**: 2025-07-06  
**Issue**: NUM-12 - Linux Build Documentation & User Guides  

## 🎯 **Quick Start for Developers**

```bash
# Set up development environment
git clone https://github.com/m-marinucci/Tol.git
cd Tol
./scripts/install-deps-ubuntu.sh  # or install-deps-centos.sh

# Configure development build
mkdir build-dev && cd build-dev
cmake .. \
    -DCMAKE_BUILD_TYPE=Debug \
    -DTOL_ENABLE_TESTING=ON \
    -DTOL_ENABLE_COVERAGE=ON \
    -DTOL_ENABLE_SANITIZERS=ON

# Build and test
make -j$(nproc)
make test
```

## 📋 **Development Environment Setup**

### **Required Tools**

| Tool | Purpose | Installation |
|------|---------|-------------|
| **Git** | Version control | `sudo apt-get install git` |
| **CMake** | Build system | `sudo apt-get install cmake` |
| **GCC/Clang** | Compiler | `sudo apt-get install build-essential` |
| **GDB** | Debugger | `sudo apt-get install gdb` |
| **Valgrind** | Memory analysis | `sudo apt-get install valgrind` |
| **Python** | Scripting/testing | `sudo apt-get install python3` |

### **Recommended IDE Setup**

#### **Visual Studio Code**
```bash
# Install VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update && sudo apt-get install code

# Install extensions
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.cmake-tools
code --install-extension ms-python.python
```

#### **CLion/Qt Creator**
```bash
# CLion (JetBrains)
# Download from https://www.jetbrains.com/clion/

# Qt Creator
sudo apt-get install qtcreator
```

### **Development Configuration**

```bash
# Create development environment script
cat > ~/.tol_dev_env << 'EOF'
# TOL Development Environment

# Build configuration
export CMAKE_BUILD_TYPE=Debug
export TOL_ENABLE_TESTING=ON
export TOL_ENABLE_COVERAGE=ON

# Development paths
export TOL_SOURCE_DIR=$HOME/Tol
export TOL_BUILD_DIR=$TOL_SOURCE_DIR/build-dev
export TOL_INSTALL_DIR=$HOME/tol-dev

# Testing configuration
export TOL_TEST_OUTPUT_DIR=$HOME/tol_test_results
export TOL_TEST_TIMEOUT=300

# Performance optimization for development
export OMP_NUM_THREADS=4
export OPENBLAS_NUM_THREADS=4

# Debugging
export ASAN_OPTIONS=detect_leaks=1:abort_on_error=1
export UBSAN_OPTIONS=print_stacktrace=1:abort_on_error=1
EOF

# Source in bashrc
echo "source ~/.tol_dev_env" >> ~/.bashrc
```

## 🏗️ **Build System Architecture**

### **CMake Structure**

```
TOL/
├── CMakeLists.txt              # Main CMake configuration
├── tol/
│   ├── CMakeLists.txt         # Core TOL library
│   ├── bbasic/CMakeLists.txt  # Basic types module
│   ├── bmath/CMakeLists.txt   # Math module
│   └── ...
├── tolbase/CMakeLists.txt     # GUI application
├── toltcl/CMakeLists.txt      # Tcl bindings
└── tol_tests/CMakeLists.txt   # Testing framework
```

### **Build Targets**

```bash
# Core targets
make tol                    # Core TOL library
make tolcon                 # TOL console interpreter
make tolbase               # GUI application
make toltcl                # Tcl bindings

# Testing targets
make test                  # Run all tests
make test_unit            # Unit tests only
make test_performance     # Performance tests
make test_coverage        # Generate coverage report

# Development targets
make format               # Format code
make lint                 # Static analysis
make docs                 # Generate documentation
```

### **Build Configurations**

```bash
# Debug build (default for development)
cmake .. -DCMAKE_BUILD_TYPE=Debug

# Release build (optimized)
cmake .. -DCMAKE_BUILD_TYPE=Release

# Release with debug info
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo

# Minimum size release
cmake .. -DCMAKE_BUILD_TYPE=MinSizeRel
```

## 🧪 **Testing Framework Integration**

### **Adding New Tests**

```bash
# Create new unit test
mkdir tol_tests/unit_tests/my_module
cat > tol_tests/unit_tests/my_module/test.tol << 'EOF'
// Unit test for my_module
// Author: Your Name
// Date: $(date +%Y-%m-%d)

#include "enhanced_test_framework.tol"

NameBlock test_my_module = {
    Real test_basic_functionality() {
        // Test implementation
        return TestAssert(true, "Basic functionality works");
    };
    
    Real test_edge_cases() {
        // Edge case testing
        return TestAssert(true, "Edge cases handled");
    };
    
    // Main test runner
    Real main() {
        TestSuite suite = TestSuite("MyModule Tests");
        suite.AddTest("BasicFunctionality", test_basic_functionality);
        suite.AddTest("EdgeCases", test_edge_cases);
        return suite.Run();
    };
};
EOF
```

### **Running Tests During Development**

```bash
# Run specific test
tolcon -v tol_tests/unit_tests/my_module/test.tol

# Run test category
make test_unit

# Run with verbose output
ctest --verbose

# Run specific test pattern
ctest -R "bmath.*"

# Run tests in parallel
ctest -j$(nproc)
```

### **Test Coverage Analysis**

```bash
# Enable coverage in build
cmake .. -DTOL_ENABLE_COVERAGE=ON

# Build with coverage
make -j$(nproc)

# Run tests
make test

# Generate coverage report
make coverage

# View HTML report
firefox coverage/index.html
```

## 🔍 **Debugging and Profiling**

### **GDB Debugging**

```bash
# Debug TOL interpreter
gdb --args tolcon -v my_script.tol

# Common GDB commands
(gdb) run                    # Start execution
(gdb) break main            # Set breakpoint
(gdb) continue              # Continue execution
(gdb) step                  # Step into function
(gdb) next                  # Step over function
(gdb) print variable        # Print variable value
(gdb) backtrace            # Show call stack
```

### **Valgrind Memory Analysis**

```bash
# Check for memory leaks
valgrind --leak-check=full --show-leak-kinds=all tolcon -v test.tol

# Check for memory errors
valgrind --tool=memcheck tolcon -v test.tol

# Profile memory usage
valgrind --tool=massif tolcon -v test.tol
ms_print massif.out.* > memory_profile.txt
```

### **AddressSanitizer (ASan)**

```bash
# Build with AddressSanitizer
cmake .. -DTOL_ENABLE_SANITIZERS=ON
make -j$(nproc)

# Run with ASan
export ASAN_OPTIONS=detect_leaks=1:abort_on_error=1
tolcon -v test.tol
```

### **Performance Profiling**

```bash
# Profile with perf
perf record tolcon -v performance_test.tol
perf report

# Profile with gprof
cmake .. -DCMAKE_CXX_FLAGS="-pg"
make -j$(nproc)
tolcon -v test.tol
gprof tolcon gmon.out > profile.txt
```

## 📝 **Code Style and Standards**

### **C++ Coding Standards**

```cpp
// File header template
/*
 * File: module_name.cpp
 * Purpose: Brief description
 * Author: Your Name
 * Date: YYYY-MM-DD
 * Issue: NUM-XX (if applicable)
 */

// Naming conventions
class MyClass {                    // PascalCase for classes
private:
    int member_variable_;          // snake_case with trailing underscore
    
public:
    void PublicMethod();           // PascalCase for public methods
    
private:
    void private_method();         // snake_case for private methods
};

// Constants
const int MAX_BUFFER_SIZE = 1024;  // UPPER_CASE for constants

// Functions
void calculate_matrix_product();    // snake_case for functions
```

### **TOL Coding Standards**

```tol
// TOL script header template
/*
 * Script: script_name.tol
 * Purpose: Brief description
 * Author: Your Name
 * Date: YYYY-MM-DD
 * Issue: NUM-XX (if applicable)
 */

// Naming conventions
NameBlock MyModule = {
    Real PublicFunction(Real param) {    // PascalCase for public functions
        Real localVar = 0;               // camelCase for local variables
        return localVar;
    };
    
    Real _privateFunction(Real param) {  // Leading underscore for private
        return param * 2;
    };
};

// Constants
Real PI = 3.14159265359;                // UPPER_CASE for constants
```

### **Code Formatting**

```bash
# Install clang-format
sudo apt-get install clang-format

# Format C++ code
find . -name "*.cpp" -o -name "*.h" | xargs clang-format -i

# Format TOL code (custom formatter)
python3 scripts/format_tol.py tol_tests/
```

## 🚀 **Contribution Workflow**

### **Git Workflow**

```bash
# Fork and clone
git clone https://github.com/your-username/Tol.git
cd Tol
git remote add upstream https://github.com/m-marinucci/Tol.git

# Create feature branch
git checkout -b feature/my-new-feature

# Make changes and commit
git add .
git commit -m "Add new feature: brief description

- Detailed description of changes
- Any breaking changes
- Related issue: NUM-XX"

# Push and create PR
git push origin feature/my-new-feature
# Create pull request on GitHub
```

### **Pull Request Guidelines**

1. **Branch Naming**: `feature/description`, `bugfix/description`, `docs/description`
2. **Commit Messages**: Follow conventional commits format
3. **Testing**: All tests must pass
4. **Documentation**: Update relevant documentation
5. **Code Review**: Address all review comments

### **Pre-commit Checks**

```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# TOL pre-commit hook

# Run tests
echo "Running tests..."
cd build-dev && make test
if [ $? -ne 0 ]; then
    echo "Tests failed. Commit aborted."
    exit 1
fi

# Check code format
echo "Checking code format..."
# Add format checking here

echo "Pre-commit checks passed."
EOF

chmod +x .git/hooks/pre-commit
```

## 📚 **Documentation Guidelines**

### **Code Documentation**

```cpp
/**
 * @brief Calculate matrix determinant using LU decomposition
 * @param matrix Input matrix (must be square)
 * @param size Matrix dimension
 * @return Determinant value
 * @throws std::invalid_argument if matrix is not square
 * @note Uses partial pivoting for numerical stability
 * @see MatrixLU for LU decomposition details
 */
double calculate_determinant(const double* matrix, int size);
```

### **API Documentation**

```tol
/*
 * @function MatrixMultiply
 * @brief Multiply two matrices
 * @param A First matrix (m x n)
 * @param B Second matrix (n x p)
 * @return Result matrix (m x p)
 * @example
 *   Matrix A = [[1,2],[3,4]];
 *   Matrix B = [[5,6],[7,8]];
 *   Matrix C = MatrixMultiply(A, B);
 */
```

## 🔗 **Related Resources**

- **[Testing Framework Guide](tol_tests/COMPREHENSIVE_TESTING_FRAMEWORK.md)**
- **[Build Guide](LINUX_BUILD_GUIDE.md)**
- **[Troubleshooting](LINUX_TROUBLESHOOTING.md)**
- **[Dependencies](LINUX_DEPENDENCIES.md)**

---

**Contact**: mmarinucci@numinate.com  
**Issue**: NUM-12 - Linux Build Documentation & User Guides  
**Last Updated**: 2025-07-06
