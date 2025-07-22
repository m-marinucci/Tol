# TOL Core Implementation (`tol-master/tol/`)

## Overview

This directory contains the core C++ source code, build system files, and documentation for the **TOL (Time-Oriented Language)** interpreter. TOL is described as a declarative, autoevaluative programming language featuring dynamic memory management and lazy evaluation, specifically designed for time-oriented tasks.

## Code Functionality

The code implements the TOL language interpreter itself, including:
- **Parsing and Evaluation:** Likely handled by modules in subdirectories like `bparser/`.
- **Core Language Features:** Implementation of TOL's syntax, data types (potentially time-series related given the name), dynamic memory, and lazy evaluation logic (likely within `btol/`, `bmath/`, `bbasic/`).
- **Initialization and Execution:** Files like `init.cpp`, `tol.cpp`, `tolcon.cpp` manage the startup, execution environment (console), and potentially dynamic loading (`toldll.cpp`).
- **Standard Library:** The `stdlib/` directory probably contains built-in functions and modules for the TOL language.
- **Database Connectivity:** `dbdrivers/` suggests support for connecting to databases.
- **Build System:** Utilizes Autotools (`configure`, `Makefile.am`), CMake (`CMakeLists.txt`), and possibly Boost Jam (`Jamroot`) for compilation across different platforms (Linux, Windows indicated by `win-VC*` dirs).

## Potential API Functionality

Based on the interpreter nature and file structure, potential external APIs (e.g., if used as a library via `toldll.cpp`) could include:
- **Initialization/Termination:** Functions to start and stop the TOL interpreter environment.
- **Script Execution:** APIs to load and execute TOL code from files or strings.
- **Variable Access:** Functions to set/get variables within the TOL environment from the host application (C++).
- **Function Calling:** Mechanisms to call TOL functions from C++ and potentially vice-versa.
- **Data Exchange:** APIs to marshal data structures (especially time-series or custom TOL types) between C++ and the TOL environment.
- **Error Handling:** Functions to query interpreter state and retrieve error messages.

## Appendix

- **Build:** Requires standard C++ build tools (Make, CMake, potentially Boost Jam) and a C++ compiler. See `INSTALL` for details.
- **Dependencies:** May include libraries like `libltdl` (for dynamic loading).
- **License:** GNU General Public License (GPL). See `COPYING`.
- **Contact/Bugs:** See the main `README` in this directory for reporting bugs and contribution information. 
