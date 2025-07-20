# RTOL C++ Binding Source (`tol-master/rtol/source/`)

## Overview

This directory contains the core C++ source code that implements the **RTOL binding**, connecting the R statistical environment with the TOL engine.

## Contents

- **`tolRlink.cpp`:** The main C++ implementation file for the RTOL binding. This code uses the R Programming Interface (defined in headers like `R.h`, `Rinternals.h`) and the TOL C++ API (`tol/tol_b*.h`). It defines C functions that:
    - Can be called from R using `.Call()` or `.External()`.
    - Receive R objects (SEXP) as input.
    - Convert R data types to corresponding TOL C++ objects.
    - Invoke functions within the TOL C++ engine.
    - Convert results from TOL back into R objects (SEXP).
    - Handle memory management and error propagation between the two systems.
- **`CMakeLists.txt`:** The CMake script responsible for compiling `tolRlink.cpp` into a shared library (`.so` or `.dll`) and linking it against the required libraries (core TOL library `tollib`, R library `libR`).

## Purpose

This C++ code forms the essential translation layer enabling R users to call TOL functions and exchange data with the TOL engine directly from within their R sessions. It allows leveraging TOL's capabilities within the R ecosystem.

## Appendix

- **Implementation Language:** C++.
- **Technology:** R C API, TOL C++ API.
- **Build:** Compiled into a shared library using CMake. 
