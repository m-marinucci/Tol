# TOL MinGW Build Scripts (`tol-master/building/MinGW/`)

## Overview

This directory contains Windows batch scripts (`.bat`) specifically designed to automate the build, packaging, and environment setup for the TOL project using the **MinGW (Minimalist GNU for Windows)** compiler toolchain on Windows.

## Contents

- **`build.bat`:** Main script to compile the TOL core, bindings, and GUI components using MinGW compilers (gcc/g++).
- **`build_installer.bat`:** Script to create a Windows installer (likely using NSIS), packaging the MinGW-built components.
- **`build_package.bat` / `produce_package.bat`:** Scripts likely using CMake/CPack to generate packages or installers from the MinGW build artifacts.
- **`download_default_packages.bat`:** Script to download required build dependencies or the standard set of TOL library packages suitable for a MinGW build.
- **`cmake_prepare.bat` / `start.bat`:** Helper scripts for setting up the build environment, potentially configuring paths or environment variables needed for CMake to work correctly with MinGW.
- **`path_cmake_readme.txt`:** A text file providing notes or instructions related to CMake paths in the MinGW environment.

## Purpose

These scripts provide a convenient and automated way to build the entire TOL suite and create distributable installers or packages using the MinGW toolchain on Windows. This offers an alternative to building with Microsoft Visual Studio.

## Appendix

- **Technology:** Windows Batch scripting, MinGW (GCC/G++ for Windows), CMake/CPack.
- **Usage:** Executed by developers or build systems to compile and package TOL using MinGW on Windows. 
