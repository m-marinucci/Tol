# CMake File Download Test (`tol-master/TestCMake/TestFileDownload/`)

## Overview

This directory contains a minimal CMake project (`CMakeLists.txt`) specifically designed to test the functionality of the `file(DOWNLOAD ...)` command within CMake.

## Purpose

This test project helps verify that CMake can correctly download files from URLs during the build configuration or generation phase. This is important for the main TOL build system if it relies on downloading dependencies or resources at build time.

This serves as an isolated test case for developers working on the TOL CMake build system.

## Appendix

- **Technology:** CMake.
- **Usage:** Internal testing for the CMake build system. 
