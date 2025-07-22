# CMake Functionality Tests (`tol-master/TestCMake/`)

## Overview

This directory contains small test projects used to verify specific functionalities of the CMake build system as used within the TOL project. These tests are likely used internally by developers working on the build system.

## Contents

- **`TestFileDownload/`:** Contains a minimal CMake project designed to test the `file(DOWNLOAD ...)` command or related CMake modules for downloading files during the build configuration or generation process.
- **`TestLAPACK/`:** Contains a minimal CMake project designed to test the `find_package(LAPACK ...)` command or custom CMake find modules used to locate and configure the LAPACK (Linear Algebra PACKage) library dependency. This ensures CMake can correctly find and link against LAPACK on different systems.

## Purpose

The primary purpose of this directory is to isolate and test specific CMake features relied upon by the main TOL build system. This helps ensure the build system is robust and works correctly across different environments and configurations, particularly concerning external dependencies and build-time operations.

## Appendix

- **Technology:** CMake.
- **Usage:** Internal testing for build system development. 
