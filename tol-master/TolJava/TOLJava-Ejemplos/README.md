# TolJava Examples (`tol-master/TolJava/TOLJava-Ejemplos/`)

## Overview

This directory contains example Java projects ("Ejemplos" is Spanish for "Examples") demonstrating how to use the **TolJava** API (`TolJava/TOLJava/`) to interact with the TOL engine from Java code.

## Contents

- **`src/`:** Contains the example Java source files (`.java`). These files provide practical demonstrations of TolJava usage, likely covering scenarios such as:
    - Initializing and terminating the embedded TOL interpreter.
    - Executing TOL code from strings or files.
    - Creating TOL data structures (matrices, series, etc.) from Java data.
    - Setting and getting TOL variables from Java.
    - Retrieving results from TOL computations back into Java variables.
    - Handling potential errors or exceptions.
- **`build.xml`:** An Apache Ant build script specifically for compiling and potentially running these example projects. It depends on the `TolJava.jar` produced by the build in `TolJava/TOLJava/`.
- **`manifest.mf`:** A JAR manifest file, possibly used if the examples are packaged into executable JAR files.
- **`nbproject/`:** Contains project configuration files for the NetBeans IDE, allowing the examples to be easily opened and run within NetBeans.

## Purpose

The primary purpose of this directory is educational. It provides concrete code examples that help Java developers understand how to integrate TOL into their applications using the TolJava binding. These examples serve as a starting point and reference for common tasks.

## Appendix

- **Implementation Language:** Java.
- **Dependencies:** Requires the compiled `TolJava.jar` from `TolJava/TOLJava/` and the associated JNI native library from `TOLJavaJNI/`.
- **Build Tool:** Apache Ant (`build.xml`).
- **IDE Support:** NetBeans (`nbproject/`). 
