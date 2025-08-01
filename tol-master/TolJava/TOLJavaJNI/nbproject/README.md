# NetBeans Project Files (JNI C++) (`tol-master/TolJava/TOLJavaJNI/nbproject/`)

## Overview

This directory contains project configuration files specifically for the **NetBeans Integrated Development Environment (IDE)**, used to manage the **TolJava JNI C++ project** located in the parent directory (`tol-master/TolJava/TOLJavaJNI/`).

## Contents

Unlike typical Java `nbproject` directories, this one contains files related to building a C++ project within NetBeans:

- **`project.xml`, `configurations.xml`:** Define project metadata, C/C++ source file locations, compiler/linker options, build configurations (Debug, Release), and other settings for the native JNI library build.
- **`Makefile-*.mk`:** Makefiles generated or used by NetBeans to orchestrate the C++ compilation and linking process (e.g., invoking `g++`, `ld`).
- **`Package-*.bash`:** Shell scripts possibly used by NetBeans for packaging or deployment steps related to the built JNI library (e.g., `.so` or `.dll`).
- **`private/`:** Contains user-specific NetBeans settings or metadata for the JNI project.

## Purpose

These files enable developers using the NetBeans IDE to easily manage, build, and potentially debug the C++ JNI code that bridges the TolJava API and the core TOL engine. They store the IDE-specific configuration needed for compiling the native shared library (`libtoljavajni.so` or `toljavajni.dll`).

## Appendix

- **Technology:** NetBeans IDE C/C++ project format, Makefiles.
- **Usage:** Used automatically by the NetBeans IDE when working with the TolJava JNI C++ project. 
