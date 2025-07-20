# Windows Installer Configuration (`tol-master/installer/windows/`)

## Overview

This directory contains CMake scripts and resources used to configure the generation of the Windows installer (likely using NSIS) for the TOL project.

## Contents

- **`CMakeLists.txt`:** Contains CMake logic specifically for the Windows installer build. This script likely:
    - Locates the NSIS compiler (`makensis.exe`).
    - Configures CPack to use the NSIS generator.
    - Defines Windows-specific installation components.
    - Sets installer metadata (version, publisher, etc.).
    - References NSIS scripts and resources from this directory or the main `tol-master/NSIS/` directory.
- **`NSIS/`:** A subdirectory containing additional resources specifically for the Windows NSIS installer, supplementing those found in `tol-master/NSIS/`. This might include:
    - License files (`.txt`, `.rtf`).
    - Additional icons or graphics.
    - Specific NSIS header files (`.nsh`) or script snippets.

## Purpose

This directory centralizes the CMake configuration and specific resources required to build the distributable Windows installer (`.exe`) for TOL. It integrates the Windows installer build process with the main CMake/CPack system.

## Appendix

- **Technology:** CMake, CPack, NSIS.
- **Usage:** Used internally by the CMake/CPack process when generating the Windows installer. 
