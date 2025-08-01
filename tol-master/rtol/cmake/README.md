# RTOL CMake Support Files (`tol-master/rtol/cmake/`)

## Overview

This directory contains helper files for the CMake build system specifically tailored for building the **RTOL** R binding layer (`tol-master/rtol/`). It primarily consists of custom CMake modules.

## Contents

- **Custom Modules (`modules/`):** This subdirectory contains RTOL-specific CMake modules (`.cmake` files). These modules likely define functions or macros to:
    - Find the R installation, including necessary headers (like `R.h`, `Rinternals.h`), libraries (`libR.so`/`.dll`), and potentially the `R` executable itself (e.g., `FindR.cmake`).
    - Find the core TOL library dependency (`FindTOL.cmake` or similar).
    - Configure build options specific to the RTOL C++ binding code (`tolRlink.cpp`).
    - Handle the creation and installation of the shared library used by the R package.

## Purpose

This directory supports the CMake build process for the RTOL binding by:
- Encapsulating the logic needed to find its specific dependencies (R environment, core TOL library).
- Separating RTOL-specific CMake logic from the CMake files for other components.

## Appendix

- **Technology:** CMake scripting language.
- **Usage:** Used internally by the CMake build process when building RTOL. Modules are likely added to `CMAKE_MODULE_PATH` by the main `rtol/CMakeLists.txt`. 
