# TolJava Core Java API (`tol-master/TolJava/TOLJava/`)

## Overview

This directory contains the core Java source code and Apache Ant build configuration for the **TolJava** API. These are the Java classes and interfaces that developers use to interact with the TOL engine from their Java applications.

## Contents

- **`src/`:** Contains the Java source files (`.java`). This includes classes representing TOL concepts (e.g., `TolObject`, `TolMatrix`, `TolSerie`, `TolDate`) and classes for managing the interaction with the native TOL engine (e.g., `TolInterpreter`, which would likely use JNI calls defined in `TOLJavaJNI/`).
- **`build.xml`:** An Apache Ant build script. This file defines targets for common Java build tasks:
    - Compiling the Java source files in `src/` into bytecode (`.class` files).
    - Packaging the compiled classes and resources into a JAR file (`TolJava.jar`).
    - Potentially running unit tests.
    - Potentially generating Javadoc documentation from the source code comments.
- **`manifest.mf`:** A standard Java JAR manifest file used when creating `TolJava.jar`. It contains metadata for the JAR archive.
- **`nbproject/`:** Contains project configuration files specific to the NetBeans Integrated Development Environment (IDE), indicating that NetBeans might have been used for developing this component.

## Purpose

This directory provides the Java language bindings for TOL. It defines the public API that Java developers use to embed and control the TOL interpreter, execute TOL code, and exchange data between Java and TOL. The actual communication with the C++ TOL engine happens via JNI (Java Native Interface) calls, which are implemented in the `TOLJavaJNI/` directory and invoked by the Java classes defined here.

## Appendix

- **Implementation Language:** Java.
- **Build Tool:** Apache Ant (`build.xml`).
- **IDE Support:** NetBeans (`nbproject/`).
- **Usage:** This component is typically compiled into a JAR file (`TolJava.jar`) which developers include in their Java application's classpath along with the native JNI library produced by `TOLJavaJNI/`. 
