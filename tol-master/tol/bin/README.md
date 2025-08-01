# TOL Launch/Environment Scripts (`tol-master/tol/bin/`)

## Overview

This directory contains utility shell scripts designed for Unix-like operating systems (Linux, macOS, etc.) to help configure the runtime environment and launch TOL executables.

## Contents

- **`confenv.sh`:** A shell script responsible for setting up the necessary environment variables for TOL. This could include:
    - Modifying the `PATH` to include the directory containing TOL executables.
    - Setting `LD_LIBRARY_PATH` (or `DYLD_LIBRARY_PATH` on macOS) so the system can find TOL's shared libraries.
    - Setting other environment variables used by TOL for configuration (e.g., `TOL_PATH`).
    This script is likely intended to be sourced (e.g., `. ./confenv.sh`) or executed by other wrapper scripts.
- **`tolcon.sh`:** A wrapper script for launching the main TOL console interpreter (`tolcon`). It likely performs necessary environment setup (potentially by calling `confenv.sh`) before executing the actual `tolcon` binary, ensuring it runs with the correct settings and library paths.
- **`CMakeLists.txt`:** A CMake script possibly used to install these wrapper scripts to the target system's binary directory (e.g., `/usr/local/bin`) during the `make install` process.

## Purpose

These scripts provide a user-friendly way to run TOL from the command line on Unix-like systems without requiring manual configuration of environment variables. They encapsulate the setup logic needed for the TOL executables and libraries to function correctly.

## Appendix

- **Implementation Language:** Shell script (sh/bash).
- **Platform:** Unix-like systems (Linux, macOS, etc.).
- **Usage:** Execute `tolcon.sh` to start the TOL console, or source `confenv.sh` to configure the environment in the current shell. 
