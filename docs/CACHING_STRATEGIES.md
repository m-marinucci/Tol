# TOL Build Caching Strategies

This document outlines the comprehensive caching strategies implemented in the TOL project to optimize build times, reduce resource usage, and improve developer productivity.

## Table of Contents

1. [Overview](#overview)
2. [Multi-Layer Caching Architecture](#multi-layer-caching-architecture)
3. [GitHub Actions Caching](#github-actions-caching)
4. [ccache Configuration](#ccache-configuration)
5. [Local Development Caching](#local-development-caching)
6. [Performance Monitoring](#performance-monitoring)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)

## Overview

TOL implements a sophisticated multi-layer caching strategy designed to minimize build times while maintaining build reliability and reproducibility. The caching system operates at multiple levels:

- **System Dependencies**: APT packages, libraries, and system tools
- **Build Tools**: CMake, compilers, and build utilities
- **Compilation Cache**: Source code compilation results (ccache)
- **Build Configuration**: CMake configuration files and generated makefiles
- **Test Dependencies**: Test data and compiled test artifacts
- **Artifacts**: Final build products and intermediate files

## Multi-Layer Caching Architecture

### Layer 1: System Dependencies

```yaml
Cache Path: /var/cache/apt/archives, /usr/local/{include,lib}
Cache Key: system-deps-{OS}-{workflow-hash}
Restore Keys: system-deps-{OS}-
Retention: Indefinite (until cache size limits)
```

**Purpose**: Cache system-level dependencies like GSL, LAPACK, FFTW, etc.

**Implementation**:
```bash
# Dependencies are marked when installed
sudo touch /var/cache/apt/tol-deps-installed

# Subsequent runs check for marker
if [ ! -f /var/cache/apt/tol-deps-installed ]; then
    # Install dependencies
else
    echo "Using cached dependencies"
fi
```

### Layer 2: Build Tools Cache

```yaml
Cache Path: ~/.cmake, /usr/share/cmake-*
Cache Key: build-tools-{OS}-{CMAKE_CACHE_VERSION}
Restore Keys: build-tools-{OS}-
Retention: Long-term (version-based invalidation)
```

**Purpose**: Cache CMake installations and configurations.

### Layer 3: Compilation Cache (ccache)

```yaml
Cache Path: ~/.ccache
Cache Key: ccache-{compiler}-{source-files-hash}
Restore Keys: ccache-{compiler}-, ccache-
Max Size: 2GB (configurable)
Compression: Level 6
```

**Purpose**: Cache compiled object files to avoid recompilation.

**Configuration**:
```ini
# ~/.ccache/ccache.conf
max_size = 2G
compression = true
compression_level = 6
sloppiness = file_macro,locale,time_macros
hash_dir = false
cache_dir_levels = 2
stats = true
log_file = ~/.ccache/ccache.log
```

### Layer 4: CMake Build Files

```yaml
Cache Path: build/CMakeFiles, build/CMakeCache.txt, build/Makefile
Cache Key: cmake-{compiler}-{version}-{cmake-files-hash}
Restore Keys: cmake-{compiler}-{version}-, cmake-{compiler}-
```

**Purpose**: Cache CMake-generated build files to speed up incremental builds.

### Layer 5: Test Dependencies

```yaml
Cache Path: tol_tests/test_cache, unit_tests/**/cache
Cache Key: test-deps-{compiler}-{test-files-hash}
Restore Keys: test-deps-{compiler}-, test-deps-
```

**Purpose**: Cache test data, compiled test binaries, and test results.

## GitHub Actions Caching

### Cache Configuration Example

```yaml
- name: Cache ccache Directory
  uses: actions/cache@v3
  with:
    path: ~/.ccache
    key: ccache-${{ matrix.cache_key_prefix }}-${{ hashFiles('tol-master/tol/**/*.cpp', 'tol-master/tol/**/*.h') }}
    restore-keys: |
      ccache-${{ matrix.cache_key_prefix }}-
      ccache-
```

### Cache Key Strategy

- **Primary Key**: Includes compiler and source file hashes for exact matches
- **Restore Keys**: Hierarchical fallback for partial matches
- **Invalidation**: Automatic when source files change

### Cache Performance Metrics

Each workflow run reports:
- Cache hit ratio
- Cache size utilization
- Build time improvements
- Cache effectiveness rating

## ccache Configuration

### Optimal Settings for TOL

```bash
# Maximum cache size (adjust based on available disk space)
ccache --max-size=2G

# Enable compression for better space efficiency
ccache --set-config=compression=true
ccache --set-config=compression_level=6

# Optimize for build speed
ccache --set-config=sloppiness=file_macro,locale,time_macros

# Enable statistics
ccache --set-config=stats=true
```

### Environment Variables

```bash
export CCACHE_COMPRESS=1
export CCACHE_COMPRESSLEVEL=6
export CCACHE_MAXSIZE=2G
export CCACHE_SLOPPINESS=file_macro,locale,time_macros
```

### Integration with CMake

```cmake
# Enable ccache in CMakeLists.txt
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
    set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
    message(STATUS "Using ccache: ${CCACHE_PROGRAM}")
endif()
```

## Local Development Caching

### Setting Up ccache Locally

1. **Install ccache**:
   ```bash
   # Ubuntu/Debian
   sudo apt install ccache
   
   # macOS
   brew install ccache
   
   # CentOS/RHEL
   sudo yum install ccache
   ```

2. **Configure ccache**:
   ```bash
   # Set maximum cache size
   ccache --max-size=4G
   
   # Enable compression
   ccache --set-config=compression=true
   
   # Show configuration
   ccache --show-config
   ```

3. **Environment Setup**:
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   export CC="ccache gcc"
   export CXX="ccache g++"
   
   # Or use cmake with launcher
   export CMAKE_C_COMPILER_LAUNCHER=ccache
   export CMAKE_CXX_COMPILER_LAUNCHER=ccache
   ```

### CMake Integration

```bash
# Configure build with ccache
cd tol-master/tol
mkdir build && cd build
cmake .. -DCMAKE_C_COMPILER_LAUNCHER=ccache \
         -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
         -DCMAKE_BUILD_TYPE=Release

# Build with caching
make -j$(nproc)

# Check cache statistics
ccache --show-stats
```

### Optimizing Cache Performance

1. **Monitor cache effectiveness**:
   ```bash
   ccache --show-stats
   
   # Look for high hit ratio (>80% is excellent)
   # Monitor cache size vs. max size
   ```

2. **Clean cache periodically**:
   ```bash
   # Clean old entries
   ccache --cleanup
   
   # Clear entire cache (if needed)
   ccache --clear
   
   # Reset statistics
   ccache --zero-stats
   ```

## Performance Monitoring

### Automated Monitoring

The enhanced CI/CD pipeline automatically monitors:

- **Cache Hit Ratios**: Percentage of cache hits vs. misses
- **Build Time Improvements**: Comparison between cached and non-cached builds
- **Cache Size Utilization**: Current usage vs. maximum size
- **Cache Effectiveness**: Rating based on performance metrics

### Performance Metrics

| Metric | Excellent | Good | Moderate | Poor |
|--------|-----------|------|----------|------|
| Hit Ratio | >80% | 60-80% | 30-60% | <30% |
| Build Speedup | >5x | 3-5x | 2-3x | <2x |
| Cache Utilization | 60-90% | 40-60% | 20-40% | <20% or >95% |

### Monitoring Commands

```bash
# Show detailed cache statistics
ccache --show-stats

# Show cache configuration
ccache --show-config

# Monitor cache directory size
du -sh ~/.ccache

# Show cache log (if enabled)
tail -f ~/.ccache/ccache.log
```

## Troubleshooting

### Common Issues

1. **Low Cache Hit Ratio**

   **Symptoms**: Hit ratio consistently below 60%
   
   **Causes**:
   - Frequently changing compiler flags
   - Timestamp-based dependencies
   - Large header files with frequent changes
   
   **Solutions**:
   ```bash
   # Adjust sloppiness settings
   ccache --set-config=sloppiness=file_macro,locale,time_macros,pch_defines
   
   # Check for problematic headers
   ccache --show-log-stats
   ```

2. **Cache Size Issues**

   **Symptoms**: Cache constantly at maximum size
   
   **Solutions**:
   ```bash
   # Increase cache size
   ccache --max-size=4G
   
   # Clean old entries more aggressively
   ccache --cleanup
   ```

3. **Build Inconsistencies**

   **Symptoms**: Different results between cached and non-cached builds
   
   **Solutions**:
   ```bash
   # Clear cache and rebuild
   ccache --clear
   
   # Disable problematic sloppiness options
   ccache --set-config=sloppiness=none
   ```

### Debugging Commands

```bash
# Show cache statistics with details
ccache --show-stats --verbose

# Print cache configuration
ccache --print-config

# Show cache directory structure
find ~/.ccache -type f | head -20

# Test cache with specific file
ccache --print-stats --zero-stats
# compile file
ccache --print-stats
```

## Best Practices

### For CI/CD Pipelines

1. **Use Hierarchical Cache Keys**:
   ```yaml
   key: cache-${{ compiler }}-${{ hashFiles('**/*.cpp', '**/*.h') }}
   restore-keys: |
     cache-${{ compiler }}-
     cache-
   ```

2. **Monitor Cache Performance**:
   - Track hit ratios across builds
   - Alert on performance degradation
   - Adjust cache sizes based on usage patterns

3. **Optimize Cache Invalidation**:
   - Include relevant files in hash calculation
   - Use semantic versioning for cache keys
   - Balance between cache hits and freshness

### For Local Development

1. **Regular Maintenance**:
   ```bash
   # Weekly cache cleanup
   ccache --cleanup
   
   # Monthly statistics review
   ccache --show-stats
   ```

2. **Project-Specific Configuration**:
   ```bash
   # Set project-specific ccache directory
   export CCACHE_DIR=/path/to/project/.ccache
   
   # Use project-specific configuration
   export CCACHE_CONFIGPATH=/path/to/project/.ccache/config
   ```

3. **Integration with IDEs**:
   - Configure IDE to use ccache
   - Set appropriate environment variables
   - Monitor cache usage during development

### Performance Optimization

1. **Compiler Flags**:
   ```cmake
   # Optimize for ccache
   set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe")
   set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe")
   ```

2. **Header Organization**:
   - Minimize header dependencies
   - Use forward declarations where possible
   - Group stable headers separately

3. **Build Configuration**:
   ```bash
   # Use optimal parallel build settings
   make -j$(nproc)
   
   # Monitor system resources
   htop  # Watch CPU and memory usage during builds
   ```

## Cache Storage Locations

### GitHub Actions Runners

- **Linux**: `/home/runner/.ccache`
- **Windows**: `C:\Users\runneradmin\AppData\Local\ccache`
- **macOS**: `/Users/runner/.ccache`

### Local Development

- **Linux**: `~/.ccache`  
- **Windows**: `%APPDATA%\ccache`
- **macOS**: `~/.ccache`

### Custom Locations

```bash
# Set custom ccache directory
export CCACHE_DIR=/custom/path/to/ccache

# Verify location
ccache --show-config | grep "cache directory"
```

## Integration Examples

### Complete CMake Integration

```cmake
# FindCCache.cmake
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    # Set compiler launchers
    set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
    set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
    
    # Optimize compiler flags for ccache
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe")
    
    message(STATUS "Using ccache: ${CCACHE_PROGRAM}")
    
    # Show cache statistics after build
    add_custom_target(ccache-stats
        COMMAND ${CCACHE_PROGRAM} --show-stats
        COMMENT "Showing ccache statistics"
    )
else()
    message(WARNING "ccache not found - builds will not be cached")
endif()
```

### Shell Script Integration

```bash
#!/bin/bash
# build-with-cache.sh

set -e

# Configure ccache
export CCACHE_MAXSIZE=2G
export CCACHE_COMPRESS=1
export CCACHE_SLOPPINESS=file_macro,locale,time_macros

# Show initial cache state
echo "Initial ccache statistics:"
ccache --show-stats

# Build with caching
mkdir -p build && cd build
cmake .. -DCMAKE_C_COMPILER_LAUNCHER=ccache \
         -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
         -DCMAKE_BUILD_TYPE=Release

make -j$(nproc)

# Show final cache state
echo "Final ccache statistics:"
ccache --show-stats
```

This comprehensive caching strategy ensures optimal build performance while maintaining reliability and providing detailed monitoring capabilities for continuous optimization.