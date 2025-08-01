# Linux Installer/Package Configuration (`tol-master/installer/linux/`)

## Overview

This directory contains CMake scripts and related templates used to configure the generation of Linux installers or packages (e.g., RPM, DEB, TGZ) for the TOL project via CPack.

## Contents

- **`CMakeLists.txt`:** Contains CMake logic specifically for Linux packaging. This script likely:
    - Detects necessary packaging tools (e.g., `rpmbuild`, `dpkg-deb`).
    - Defines package components specific to the Linux installation.
    - Sets metadata (dependencies, descriptions, etc.) for RPM and DEB formats.
    - Includes logic for handling icons, desktop entries, and installation paths on Linux.
- **`cpack_generator.cmake`:** A CMake script used to select or configure the appropriate CPack generator (e.g., `CPACK_GENERATOR = RPM` or `DEB`) for the Linux build.
- **`rpm_post_install.sh.in`:** A template shell script (`.sh.in`) that is processed by CMake (using `configure_file`) to create the post-installation script embedded within RPM packages. This script runs after installation on the target system (e.g., to run `ldconfig`).

## Purpose

This directory centralizes the CMake configuration required to build distributable packages for various Linux distributions. It works in conjunction with the main CMake build system and the top-level CPack configuration.

## Appendix

- **Technology:** CMake, CPack, Shell scripting.
- **Usage:** Used internally by the CMake/CPack process when generating Linux packages. 
