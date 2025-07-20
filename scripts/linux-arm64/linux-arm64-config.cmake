# CMake configuration for Linux ARM64 builds

# Build type
set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")

# Compiler flags with ARM64 optimizations and PIC
set(CMAKE_CXX_FLAGS "-O3 -march=armv8-a -fPIC" CACHE STRING "C++ compiler flags")
set(CMAKE_C_FLAGS "-O3 -march=armv8-a -fPIC" CACHE STRING "C compiler flags")

# Position independent code (required for shared libraries on ARM64)
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "Enable position independent code")

# Use OpenBLAS for optimal ARM64 performance
set(BLA_VENDOR OpenBLAS CACHE STRING "BLAS implementation")

# Enable testing
set(ENABLE_TESTING ON CACHE BOOL "Enable testing")

# Optional: Set specific library paths for ARM64
# set(GSL_ROOT_DIR "/usr" CACHE PATH "GSL root directory")
# set(FFTW_ROOT "/usr" CACHE PATH "FFTW root directory")
