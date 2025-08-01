# Windows Installer NSIS Resources (`tol-master/installer/windows/NSIS/`)

## Overview

This directory provides supplementary resources for the NSIS (Nullsoft Scriptable Install System) used to build the TOL Windows installer. These files are likely included or referenced by the main NSIS script (`tol-master/NSIS/NSIS.template.in`) or the CMake configuration in the parent directory (`tol-master/installer/windows/`).

## Contents

- **`EnvVarUpdate.nsh`:** An NSIS Script Header (`.nsh`) file containing reusable functions for safely updating Windows environment variables (like `PATH`) during the installation and uninstallation process.
- **`NSIS.template.in`:** An NSIS script template (`.nsi.in`). Its exact role relative to the template in `tol-master/NSIS/` is unclear without deeper analysis, but it might define specific sections or components handled by the CMake script in the parent directory.
- **`nsis_tol.bmp`:** A bitmap image used for branding elements within the NSIS installer windows.
- **`tolbase-install.ico` / `tolbase-uninstall.ico`:** Icon files (`.ico`) specifically for the Tolbase component, used for the installer application and its entry in the Windows "Add/Remove Programs" list.

## Purpose

This directory gathers specific NSIS resources needed for the Windows installer, particularly helper functions (`EnvVarUpdate.nsh`) and component-specific assets (icons, potentially script sections).

## Appendix

- **Technology:** NSIS.
- **Usage:** Used internally by the NSIS compiler (`makensis.exe`) when building the TOL installer, typically invoked via CMake/CPack. 
