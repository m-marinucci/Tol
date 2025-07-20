# RTOL CMake Modules (`tol-master/rtol/cmake/modules/`)

## Overview

This directory contains custom CMake modules (`.cmake` files) specifically used to support the build configuration of the **RTOL** (R binding for TOL) component.

## Contents

- **`FindR.cmake`:** A CMake find-module responsible for locating the necessary components of an R installation on the system. This includes finding R's shared library (`libR.so`/`.dll`), include directories (containing `R.h`, `Rinternals.h`, etc.), and potentially the `R` executable.
- **`FindRINSIDE.cmake`:** A CMake find-module likely designed to locate the RInside C++ library, which facilitates embedding R within C++ applications. This suggests RTOL might leverage RInside.
- **`FindTOL.cmake`:** A CMake find-module to locate the core TOL library (`tollib`) required by the RTOL binding.
- **`LibFindMacros.cmake`:** Contains general-purpose CMake macros commonly used within find-modules to standardize the process of locating libraries and headers.
- **`MSysMacros.cmake`:** Contains CMake macros specifically helpful when building in an MSYS/MinGW environment on Windows.

## Purpose

These modules encapsulate the logic required for CMake to find RTOL's specific dependencies (R, core TOL, potentially RInside) and provide helper macros to streamline the build configuration process, particularly for cross-platform compatibility.

## Appendix

- **Technology:** CMake scripting language.
- **Usage:** Used internally by the `CMakeLists.txt` in the parent `rtol/` directory when configuring the RTOL build. 
