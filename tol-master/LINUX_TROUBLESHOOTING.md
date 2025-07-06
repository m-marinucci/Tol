# TOL Linux Troubleshooting Guide

**Version**: 1.0.0  
**Date**: 2025-07-06  
**Issue**: NUM-12 - Linux Build Documentation & User Guides  

## 🎯 **Quick Diagnosis**

```bash
# Check TOL installation
which tolcon
tolcon --version

# Check dependencies
ldd $(which tolcon)

# Check environment
echo $PATH
echo $LD_LIBRARY_PATH

# Test basic functionality
tolcon -c "WriteLn(\"TOL is working!\")"
```

## 🔍 **Common Issues and Solutions**

### **1. Build Issues**

#### **CMake Configuration Fails**

**Error**: `CMake Error: Could not find CMAKE_ROOT`

**Solution**:
```bash
# Install newer CMake
sudo apt-get install cmake  # Ubuntu/Debian
sudo yum install cmake3     # CentOS 7
sudo dnf install cmake      # CentOS 8+/Fedora

# Or install from source
wget https://cmake.org/files/v3.20/cmake-3.20.0.tar.gz
tar -xzf cmake-3.20.0.tar.gz
cd cmake-3.20.0
./bootstrap && make && sudo make install
```

#### **Missing Dependencies**

**Error**: `fatal error: gsl/gsl_*.h: No such file or directory`

**Solution**:
```bash
# Install missing development packages
sudo apt-get install libgsl-dev liblapack-dev libblas-dev  # Ubuntu/Debian
sudo yum install gsl-devel lapack-devel blas-devel        # CentOS/RHEL
```

#### **Compiler Version Issues**

**Error**: `error: 'constexpr' does not name a type`

**Solution**:
```bash
# Check GCC version
gcc --version

# Install newer GCC (Ubuntu/Debian)
sudo apt-get install gcc-9 g++-9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 90

# For CentOS 7, enable devtoolset
sudo yum install centos-release-scl
sudo yum install devtoolset-9-gcc devtoolset-9-gcc-c++
scl enable devtoolset-9 bash
```

#### **Memory Issues During Build**

**Error**: `virtual memory exhausted: Cannot allocate memory`

**Solution**:
```bash
# Reduce parallel jobs
make -j2  # Instead of make -j$(nproc)

# Add swap space
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### **2. Runtime Issues**

#### **TOL Binary Not Found**

**Error**: `bash: tolcon: command not found`

**Solution**:
```bash
# Check installation path
find /usr -name "tolcon" 2>/dev/null
find /opt -name "tolcon" 2>/dev/null

# Add to PATH
export PATH=/usr/local/tol/bin:$PATH
echo 'export PATH=/usr/local/tol/bin:$PATH' >> ~/.bashrc

# Or create symlink
sudo ln -s /usr/local/tol/bin/tolcon /usr/local/bin/tolcon
```

#### **Library Loading Issues**

**Error**: `error while loading shared libraries: libtol.so.1: cannot open shared object file`

**Solution**:
```bash
# Check library path
ldd $(which tolcon)

# Add library path
export LD_LIBRARY_PATH=/usr/local/tol/lib:$LD_LIBRARY_PATH
echo 'export LD_LIBRARY_PATH=/usr/local/tol/lib:$LD_LIBRARY_PATH' >> ~/.bashrc

# Or configure system-wide
echo '/usr/local/tol/lib' | sudo tee /etc/ld.so.conf.d/tol.conf
sudo ldconfig
```

#### **Permission Denied**

**Error**: `bash: /usr/local/bin/tolcon: Permission denied`

**Solution**:
```bash
# Fix permissions
sudo chmod +x /usr/local/bin/tolcon

# Check file ownership
ls -la /usr/local/bin/tolcon
sudo chown root:root /usr/local/bin/tolcon
```

### **3. Performance Issues**

#### **Slow Matrix Operations**

**Symptoms**: Matrix operations significantly slower than expected

**Diagnosis**:
```bash
# Check BLAS/LAPACK libraries
tolcon -c "WriteLn(GetBLASInfo())"

# Performance test
time tolcon -c "Matrix m = MatRand(1000,1000); Matrix p = m*m; WriteLn(\"Done\")"
```

**Solution**:
```bash
# Install optimized BLAS
sudo apt-get install libopenblas-dev    # Ubuntu/Debian
sudo yum install openblas-devel         # CentOS/RHEL

# Set environment variables
export OPENBLAS_NUM_THREADS=$(nproc)
export OMP_NUM_THREADS=$(nproc)

# Rebuild TOL with optimized libraries
cd build
cmake .. -DBLA_VENDOR=OpenBLAS
make clean && make -j$(nproc)
```

#### **Memory Usage Issues**

**Symptoms**: Excessive memory consumption or out-of-memory errors

**Diagnosis**:
```bash
# Monitor memory usage
top -p $(pgrep tolcon)
valgrind --tool=massif tolcon -c "your_script.tol"
```

**Solution**:
```bash
# Increase system limits
ulimit -v 8388608  # 8GB virtual memory limit

# Configure TOL memory settings
export TOL_MAX_MEMORY=4G
export TOL_CACHE_SIZE=256M

# Use memory-efficient algorithms
tolcon -c "SetMemoryMode(\"conservative\")"
```

### **4. Testing Framework Issues**

#### **Test Execution Fails**

**Error**: `make: *** No rule to make target 'test'`

**Solution**:
```bash
# Ensure tests are enabled
cd build
cmake .. -DTOL_TESTS_ENABLE_PERFORMANCE=ON
make

# Run tests manually
cd ../tol_tests
./run_comprehensive_tests.sh
```

#### **Test Timeouts**

**Error**: Tests hanging or timing out

**Solution**:
```bash
# Increase timeout values
cmake .. -DTOL_TESTS_UNIT_TIMEOUT=600

# Run tests with verbose output
ctest --verbose --timeout 300

# Run individual tests
tolcon -v tol_tests/unit_tests/bmath/test.tol
```

### **5. Database Connectivity Issues**

#### **ODBC Driver Not Found**

**Error**: `Cannot load ODBC driver`

**Solution**:
```bash
# Install ODBC drivers
sudo apt-get install unixodbc unixodbc-dev  # Ubuntu/Debian
sudo yum install unixODBC unixODBC-devel    # CentOS/RHEL

# Configure ODBC
sudo odbcinst -i -d -f /path/to/driver.ini
```

#### **MySQL Connection Issues**

**Error**: `Can't connect to MySQL server`

**Solution**:
```bash
# Install MySQL client libraries
sudo apt-get install libmysqlclient-dev     # Ubuntu/Debian
sudo yum install mysql-devel                # CentOS/RHEL

# Test connection
mysql -h hostname -u username -p database_name

# Check TOL database configuration
tolcon -c "WriteLn(GetDatabaseDrivers())"
```

### **6. GUI (TOLBase) Issues**

#### **TOLBase Won't Start**

**Error**: `Application initialization failed`

**Solution**:
```bash
# Check X11 forwarding (if using SSH)
ssh -X username@hostname

# Install GUI dependencies
sudo apt-get install tcl-dev tk-dev libx11-dev

# Check display
echo $DISPLAY
xhost +local:

# Run with debug output
tolbase --debug
```

#### **Missing Tcl/Tk Libraries**

**Error**: `can't find package Tk`

**Solution**:
```bash
# Install Tcl/Tk
sudo apt-get install tcl tk tcl-dev tk-dev

# Check Tcl installation
echo 'puts $tcl_version' | tclsh
echo 'puts $tk_version' | wish

# Set Tcl library path
export TCL_LIBRARY=/usr/share/tcltk/tcl8.6
export TK_LIBRARY=/usr/share/tcltk/tk8.6
```

## 🔧 **Advanced Diagnostics**

### **System Information Collection**

```bash
#!/bin/bash
# TOL System Diagnostic Script

echo "=== TOL Linux Diagnostic Report ==="
echo "Date: $(date)"
echo "User: $(whoami)"
echo "Hostname: $(hostname)"
echo

echo "=== System Information ==="
uname -a
cat /etc/os-release
echo

echo "=== Hardware Information ==="
lscpu | grep -E "(Model name|CPU\(s\)|Thread|Core)"
free -h
df -h /
echo

echo "=== Compiler Information ==="
gcc --version | head -1
g++ --version | head -1
cmake --version | head -1
python3 --version
echo

echo "=== TOL Installation ==="
which tolcon
tolcon --version 2>/dev/null || echo "TOL not found or not working"
echo

echo "=== Library Dependencies ==="
if which tolcon >/dev/null 2>&1; then
    ldd $(which tolcon) | grep -E "(not found|gsl|blas|lapack)"
fi
echo

echo "=== Environment Variables ==="
echo "PATH: $PATH"
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
echo "TOL_HOME: $TOL_HOME"
echo

echo "=== Build Directory Status ==="
if [ -d "build" ]; then
    ls -la build/
    echo "CMake cache:"
    grep -E "(CMAKE_BUILD_TYPE|CMAKE_INSTALL_PREFIX)" build/CMakeCache.txt 2>/dev/null || echo "No CMakeCache.txt found"
fi
```

### **Performance Benchmarking**

```bash
#!/bin/bash
# TOL Performance Benchmark

echo "=== TOL Performance Benchmark ==="

# Basic arithmetic
echo "Testing basic arithmetic..."
time tolcon -c "Real sum = 0; For(1, 1000000, Real(Real i) { sum = sum + i }); WriteLn(sum)"

# Matrix operations
echo "Testing matrix operations..."
time tolcon -c "Matrix m = MatRand(500, 500); Matrix p = m * m; WriteLn(\"Matrix multiplication completed\")"

# Memory allocation
echo "Testing memory allocation..."
time tolcon -c "Matrix big = MatRand(2000, 2000); WriteLn(\"Large matrix created: \" + Text(Rows(big)) + \"x\" + Text(Cols(big)))"
```

## 📞 **Getting Help**

### **Log Collection**

```bash
# Collect system logs
journalctl -u tol* --since "1 hour ago" > tol_system.log

# Collect build logs
cd build
make 2>&1 | tee build.log

# Collect test logs
cd tol_tests
./run_comprehensive_tests.sh 2>&1 | tee test.log
```

### **Bug Reporting**

When reporting issues, please include:

1. **System Information**: Output of diagnostic script above
2. **Error Messages**: Complete error output
3. **Steps to Reproduce**: Exact commands that cause the issue
4. **Expected vs Actual**: What you expected vs what happened
5. **Workarounds**: Any temporary solutions you've found

### **Community Support**

- **GitHub Issues**: https://github.com/m-marinucci/Tol/issues
- **Contact**: mmarinucci@numinate.com
- **Documentation**: See `tol_tests/` directory for comprehensive guides

---

**Contact**: mmarinucci@numinate.com  
**Issue**: NUM-12 - Linux Build Documentation & User Guides  
**Last Updated**: 2025-07-06
