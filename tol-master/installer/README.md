# Platform Installer Resources (`tol-master/installer/`)

## Overview

This directory organizes platform-specific resources and potentially CMake logic related to generating the final distributable installers or packages for TOL on different operating systems.

## Contents

- **`CMakeLists.txt`:** A CMake script likely responsible for including platform-specific installer logic or configuring CPack based on the target OS. It might define components, package metadata, or select the appropriate CPack generator (e.g., NSIS, RPM, DEB).
- **`linux/`:** Contains resources needed for creating Linux packages (e.g., RPM, DEB). This could include:
    - Template files for package specifications (`.spec` for RPM, `control` for DEB).
    - Desktop entry files (`.desktop`) for integrating with Linux desktop environments.
    - Icons in various sizes.
    - Post-installation/uninstallation scripts (like the one seen in `tol-master/cpack/`).
- **`windows/`:** Contains resources needed specifically for the Windows installer (likely NSIS, configured via `tol-master/NSIS/`). This might include:
    - License files (`.txt`, `.rtf`).
    - Additional icons or bitmaps not found in `tol-master/NSIS/`.
    - Helper scripts or configuration files specific to the Windows installation process.

## Purpose

This directory acts as a central point for CMake/CPack to find the necessary platform-specific files when generating installers. It separates the installer resource files (icons, templates, scripts) from the core source code and main build logic, keeping the project structure organized.

## Appendix

- **Technology:** CMake/CPack, potentially platform-specific packaging tools (RPM build tools, dpkg-deb, NSIS).
- **Usage:** Input files and configuration for the CPack packaging process defined in the main CMake build. 
