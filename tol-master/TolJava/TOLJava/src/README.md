# TolJava Core API Source Code (`tol-master/TolJava/TOLJava/src/`)

## Overview

This directory contains the Java source code (`.java` files) for the **core TolJava API**. This API provides the classes and interfaces that Java developers use to interact with the TOL engine.

## Contents

The source code is organized using standard Java package structure, likely starting under the `com/` subdirectory. Key classes expected within this structure include:

- Classes representing TOL data types (e.g., `TolObject`, `TolMatrix`, `TolSerie`, `TolDate`).
- Classes for managing the connection to and interaction with the TOL interpreter (e.g., `TolInterpreter`), which internally calls native methods implemented via JNI.
- Exception classes for handling errors.

## Purpose

This code defines the public Java interface for the TolJava binding. It allows Java applications to:
- Initialize and manage an embedded TOL interpreter.
- Execute TOL code.
- Transfer data between the Java environment and the TOL engine.
- Handle TOL data structures within Java.

The code here depends on the native JNI library built from `tol-master/TolJava/TOLJavaJNI/` for the actual communication with the C++ TOL engine.

## Appendix

- **Implementation Language:** Java.
- **Build:** Compiled into bytecode (`.class` files) and typically packaged into `TolJava.jar` using the Ant script (`build.xml`) in the parent directory. 
