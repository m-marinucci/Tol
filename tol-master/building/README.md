# Platform-Specific Build Support (`tol-master/building/`)

## Overview

This directory contains scripts, configuration files, and potentially tools used to support the build and packaging process of TOL on specific platforms or using particular toolchains. It complements the primary build system definitions (CMakeLists.txt, configure.in) found in other directories.

## Contents

- **`Linux/`:** Contains resources specifically for building or packaging TOL on Linux systems. This might include helper scripts, environment setup files, or configuration snippets specific to Linux distributions or build environments.
- **`MinGW/`:** Contains resources specifically for building TOL on Windows using the MinGW (Minimalist GNU for Windows) compiler suite. This might include toolchain files for CMake, build scripts, or patches needed for MinGW compatibility.
- **`produce_package.tol`:** A script written in the TOL language. This suggests TOL is used to automate or assist in its own packaging process, possibly by running CPack or other external tools, gathering files, or generating metadata based on the build configuration.

## Purpose

The files here provide targeted support for building and packaging TOL in specific environments (Linux, MinGW) that might require special handling beyond the standard CMake or Autotools processes. It also showcases the use of TOL itself (`produce_package.tol`) in managing its build artifacts.

## Appendix

- **Technology:** Shell scripts, Batch files, CMake scripts, TOL scripts.
- **Usage:** Used internally by the TOL build and packaging process. 
