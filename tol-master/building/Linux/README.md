# TOL Linux Build Scripts (`tol-master/building/Linux/`)

## Overview

This directory contains shell scripts (`.sh`) specifically designed to automate the build, packaging, and dependency management processes for the TOL project on Linux platforms.

## Contents

- **`build.sh`:** Main script to compile the TOL core, bindings, and GUI components.
- **`build_contrib.sh`:** Script to compile and integrate contributed TOL packages or third-party dependencies.
- **`build_installer.sh`:** Script to create a Linux installer (potentially a self-extracting archive or a script using system package managers).
- **`build_package.sh` / `produce_package.sh`:** Scripts likely using CMake/CPack to generate standard Linux packages (e.g., `.rpm`, `.deb`).
- **`current_version.sh`:** Utility script to determine or set the current version string used during the build and packaging.
- **`download_default_packages.sh`:** Script to download required build dependencies or the standard set of TOL library packages.

## Purpose

These scripts provide a convenient and automated way to build the entire TOL suite and create distributable packages specifically for Linux environments. They handle the complexities of compiling different components, managing dependencies, and invoking packaging tools.

## Appendix

- **Technology:** Shell scripting (Bash/sh).
- **Usage:** Executed by developers or build systems to compile and package TOL on Linux. 
