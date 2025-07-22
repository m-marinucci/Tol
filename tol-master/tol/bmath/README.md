# TOL Base Math Library (`tol-master/tol/bmath/`)

## Overview

This directory houses the core C++ implementation of mathematical, statistical, and linear algebra functionalities available within the TOL environment. It includes both native implementations and interfaces to common external numerical libraries.

## Code Functionality

The code is organized into subdirectories and files covering various mathematical domains:
- **Basic Math Operations:**
    - `barith/`: Fundamental arithmetic operations.
    - `bfunct/`: Common mathematical functions (e.g., `sin`, `cos`, `log`, `exp`).
- **Linear Algebra:**
    - `blinalg/`: Basic linear algebra operations (vector/matrix manipulation).
    - `csparse/`: Implementation or integration related to sparse matrices (possibly using the CSparse library).
    - `matfun.cpp`: Higher-level functions operating on matrices.
- **Statistics & Probability:**
    - `bstat/`: Basic statistical calculations (mean, variance, standard deviation).
    - `bprdist/`: Implementation or wrappers for probability distributions.
    - `dcdflib/`: Contains or interfaces with DCDFLIB, providing routines for CDFs, inverse CDFs, etc.
- **Signal Processing:**
    - `fftw/`: Contains or interfaces with the FFTW library for Fast Fourier Transforms.
- **External Library Integration:**
    - `gsl_ext/`: Wrappers, extensions, or interfaces for the GNU Scientific Library (GSL).
- **Core Representations:**
    - `mathobjects/`: Possibly contains base C++ classes for representing mathematical entities used by the functions.
- **Build System Integration:** `CMakeLists.txt`, `Jamfile`, and `Makefile.am` link these mathematical components into the main TOL library.

## Purpose

`bmath` provides the computational engine for TOL's numerical capabilities. It offers a range of mathematical functions, linear algebra routines, statistical tools, and integrates with established external libraries (GSL, FFTW, LAPACK likely via `blinalg`, CSparse, DCDFLIB) to provide robust and efficient computations. These C++ functions are ultimately exposed to the TOL language user through built-in functions or standard library modules.

## Appendix

- **Implementation Language:** C++.
- **Dependencies:** May require external libraries like GSL, FFTW, LAPACK, CSparse, DCDFLIB (the build system likely handles finding these).
- **Build:** Compiled as part of the main `tol` library. 
