# ARM64 Linux Build Notes for TOL

## Architecture-Specific Considerations

### ARM64 vs x86_64 Differences

1. **Library Paths**
   - ARM64: `/usr/lib/aarch64-linux-gnu/`
   - x86_64: `/usr/lib/x86_64-linux-gnu/`

2. **Compiler Flags**
   - ARM64: `-march=armv8-a+crc+crypto`
   - x86_64: `-march=native`

3. **SIMD Instructions**
   - ARM64: NEON
   - x86_64: SSE/AVX

### ARM64-Optimized Dependencies

```bash
# Install ARM64-optimized BLAS
sudo apt install -y libopenblas-openmp-dev

# Alternative: ARM Performance Libraries (if available)
# sudo apt install -y libarmpl-dev

# Eigen with NEON support
sudo apt install -y libeigen3-dev
```

### Build Configuration for ARM64

```cmake
# Optimal CMake configuration for ARM64
cmake ../tol-master/tol \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS="-O3 -march=armv8-a+crc+crypto -mtune=cortex-a72" \
    -DCMAKE_C_FLAGS="-O3 -march=armv8-a+crc+crypto -mtune=cortex-a72" \
    -DBLA_VENDOR=OpenBLAS \
    -DENABLE_TESTING=ON
```

### Performance Tuning

1. **OpenBLAS Threading**
```bash
# Set optimal thread count for M4 (in ~/.bashrc)
export OPENBLAS_NUM_THREADS=4
export OMP_NUM_THREADS=4
```

2. **Memory Alignment**
   - ARM64 prefers 64-byte alignment for cache lines
   - TOL's memory allocator should handle this automatically

### Known Issues and Workarounds

#### Issue 1: Missing ARM64 packages
Some older packages might not have ARM64 builds.

**Solution**: Build from source
```bash
# Example: Building GSL from source
wget https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz
tar -xzf gsl-2.7.tar.gz
cd gsl-2.7
./configure --prefix=/usr/local
make -j$(nproc)
sudo make install
```

#### Issue 2: BLAS/LAPACK Detection
CMake might have trouble finding the correct BLAS on ARM64.

**Solution**: Explicitly specify BLAS
```bash
cmake .. -DBLA_VENDOR=OpenBLAS \
         -DBLAS_LIBRARIES=/usr/lib/aarch64-linux-gnu/libopenblas.so \
         -DLAPACK_LIBRARIES=/usr/lib/aarch64-linux-gnu/liblapack.so
```

#### Issue 3: Compiler Optimization Flags
Some x86-specific optimizations won't work on ARM64.

**Solution**: Use ARM64-specific flags
```bash
# Replace -msse2, -mavx with ARM equivalents
-march=armv8-a+crc+crypto+fp+simd
```

### Testing ARM64 Build

```bash
# Verify architecture
file build-linux-arm64/tolcon
# Should show: ELF 64-bit LSB executable, ARM aarch64

# Check linked libraries
ldd build-linux-arm64/tolcon | grep -E "blas|lapack|gsl"

# Run basic test
./tolcon -c "WriteLn(\"ARM64 build working!\")"

# Performance test
time ./tolcon -c "Real x = 0; For(Real i = 1, i <= 1000000, i++, x += Sin(i)); WriteLn(x)"
```

### Cross-Compilation (Optional)

To build x86_64 binaries on ARM64 (not recommended, but possible):

```bash
# Install cross-compiler
sudo apt install -y gcc-x86-64-linux-gnu g++-x86-64-linux-gnu

# Configure for cross-compilation
cmake .. -DCMAKE_TOOLCHAIN_FILE=../cmake/x86_64-toolchain.cmake
```

### Packaging for Distribution

```bash
# Create .deb package for ARM64
cd build-linux-arm64
cpack -G DEB

# Create tarball for generic Linux ARM64
cpack -G TGZ

# Verify package architecture
dpkg --info tol-*.deb | grep Architecture
# Should show: aarch64 or arm64
```

### Benchmarking

Compare ARM64 vs x86_64 performance:

```bash
# Simple benchmark script
cat > benchmark.tol << 'EOF'
Real startTime = Now();
Real sum = 0;
For(Real i = 1, i <= 1000000, i++, sum += Sqrt(i));
Real elapsed = Now() - startTime;
WriteLn("Time: " + Text(elapsed) + " seconds");
WriteLn("Result: " + Text(sum));
EOF

# Run on ARM64
./tolcon benchmark.tol
```

### Docker Support (Future)

For CI/CD, you can use ARM64 Docker images:

```dockerfile
FROM arm64v8/ubuntu:22.04
# TOL build steps...
```

### Notes

1. **Performance**: ARM64 builds typically perform well for numerical computations due to efficient NEON SIMD instructions
2. **Compatibility**: Binaries built on ARM64 won't run on x86_64 and vice versa
3. **Testing**: Always test ARM64 builds thoroughly as some numerical algorithms might behave differently
4. **Future**: Apple Silicon native builds (macOS) share many optimizations with Linux ARM64