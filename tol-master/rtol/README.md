# RTOL: TOL to R Binding (`tol-master/rtol/`)

## Overview

This directory contains **RTOL**, the binding layer that connects the core **TOL C++ engine** (`tol-master/tol/`) with the **R statistical programming language**. It enables R users to interact with the TOL interpreter, execute TOL code, and potentially exchange data structures between R and TOL.

## Code Functionality

- **R Binding Implementation (C++):** The `source/` directory contains the C++ code (`tolRlink.cpp`) that implements the interface between R and TOL. This code uses:
    - R's C API (functions and types defined in R includes like `R.h`, `Rinternals.h`) to create R functions and handle R objects (SEXP).
    - The internal C++ API of the TOL engine to call TOL functions and manipulate TOL data.
- **Build System:** Uses CMake (`CMakeLists.txt`) to compile the C++ binding code (`tolRlink.cpp`) into a shared library. This library is typically linked into an R package. The standard R package build mechanism (`R CMD build`, `R CMD INSTALL`) would likely use this compiled library.

## Potential API Functionality (R Functions)

The API provided by this binding would consist of R functions available after loading the resulting R package (e.g., `library(RTOL)`):
- **Interpreter Management:** R functions to initialize or manage the embedded TOL interpreter session.
- **Code Execution:** `tol.eval("TOL code string")`, `tol.source("filename.tol")` (or similar functions).
- **Data Exchange:** R functions to:
    - Convert R data structures (vectors, matrices, lists, data frames) into corresponding TOL types (Real, Matrix, Set, etc.).
    - Convert results returned from TOL (e.g., TolMatrix, TolSerie) back into R objects.
- **Direct Function Calls:** Potentially R functions that wrap specific, commonly used TOL functions for easier access from R.

## Appendix

- **Implementation Language:** C++.
- **Dependencies:** Requires an R installation (including development headers/tools like `R CMD`) and the compiled core TOL library (`tol-master/tol/`).
- **Build:** Compiled into a shared library, intended to be part of an R package build process. See `CMakeLists.txt`.
- **License:** (License file missing in this directory, likely inherits from parent or `tol/` - presumably GPL). 
