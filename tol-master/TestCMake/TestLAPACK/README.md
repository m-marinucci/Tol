# CMake LAPACK Test (`tol-master/TestCMake/TestLAPACK/`)

## Overview

This directory contains a minimal CMake project (`CMakeLists.txt`) specifically designed to test the functionality of finding and configuring the **LAPACK (Linear Algebra PACKage)** library using CMake's `find_package(LAPACK ...)` command or related custom modules.

## Purpose

This test project helps verify that CMake can correctly locate the necessary LAPACK headers and libraries on the system. This is important for the main TOL build system, which likely relies on LAPACK for numerical linear algebra operations.

This serves as an isolated test case for developers working on the TOL CMake build system to ensure dependency detection works correctly.

## Appendix

- **Technology:** CMake, LAPACK.
- **Usage:** Internal testing for the CMake build system. 
