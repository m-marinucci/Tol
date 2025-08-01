# TOL NSIS Installer Scripts (`tol-master/NSIS/`)

## Overview

This directory contains the necessary scripts and resources for building a Windows installer package (`.exe`) for the TOL suite using the **Nullsoft Scriptable Install System (NSIS)**.

## Code Functionality

- **NSIS Scripts (`.nsi`, `.nsh`):**
    - `NSIS.template.in`: A template NSIS script. This file is likely processed by CMake during the build process (filling in variables like version number, installation paths, component lists) to generate the final `.nsi` script used by the NSIS compiler (`makensis.exe`).
    - `EnvVarUpdate.nsh`: An NSIS script header file containing functions specifically for managing Windows environment variable updates during installation and uninstallation.
- **Installer Resources (`.ico`, `.bmp`):**
    - `tolbase-install.ico`, `tolbase-uninstall.ico`: Icons used for the installer program itself and its entry in Windows' "Add/Remove Programs".
    - `nsis_tol.bmp`: Bitmap image likely used for installer window branding.

## Purpose

The files in this directory define the structure, behavior, and appearance of the Windows installer for TOL. The generated installer handles tasks like:
- Presenting license agreements.
- Allowing users to choose installation options/components.
- Copying TOL program files (`tol.exe`, `tolsh.exe`, libraries, documentation, etc.) to the target directory.
- Creating Start Menu shortcuts.
- Setting environment variables (e.g., updating `PATH`).
- Writing registry keys.
- Creating an uninstaller.

## Appendix

- **Technology:** NSIS (Nullsoft Scriptable Install System).
- **Build Process:** The `.nsi` script is compiled using `makensis.exe` (often triggered via CMake/CPack or a custom build script) to produce the final installer executable.
- **Dependencies:** Requires NSIS to be installed to build the installer. 
