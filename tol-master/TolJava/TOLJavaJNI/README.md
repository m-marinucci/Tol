# TolJava JNI Implementation (`tol-master/TolJava/TOLJavaJNI/`)

## Overview

This directory contains the C++ source code and build configuration for the **Java Native Interface (JNI)** component of the TolJava binding. This native library acts as the bridge between the TolJava Java API (`TolJava/TOLJava/`) and the core C++ TOL engine (`tol-master/tol/`).

## Contents

- **JNI C++ Source (`toljavajni.cpp`, `toljavajni.h`):** These files implement the native C++ functions that correspond to `native` methods declared in the TolJava Java classes. They perform tasks such as:
    - Receiving arguments from Java calls via the JNI interface.
    - Converting Java data types (e.g., `jstring`, `jdoubleArray`, `jobject`) into C++ representations usable by the TOL engine.
    - Including TOL C++ headers and calling the appropriate TOL engine API functions.
    - Converting results from the TOL engine back into Java data types.
    - Handling exceptions and errors, propagating them back to the Java layer if necessary.
    - The JNI function names typically follow a pattern like `Java_package_ClassName_methodName`.
- **Build Configuration (`Makefile`):** A standard Makefile used to compile the JNI C++ code (`toljavajni.cpp`) into a platform-specific native shared library (e.g., `libtoljavajni.so`, `toljavajni.dll`). This build process requires:
    - A C++ compiler.
    - Access to JNI headers (`jni.h`, `jni_md.h`) from a Java Development Kit (JDK).
    - Linking against the compiled core TOL library (`tollib`).
- **IDE Support (`nbproject/`):** NetBeans IDE project files for managing the C++ JNI code within NetBeans.

## Purpose

The JNI library built from this code is the essential link enabling TolJava. The Java Virtual Machine (JVM) loads this native library, and calls made to `native` methods in the TolJava Java classes are dispatched to the corresponding C++ functions implemented here. This allows Java applications to leverage the computational power and features of the C++ TOL engine.

## Appendix

- **Implementation Language:** C++.
- **Technology:** Java Native Interface (JNI).
- **Dependencies:** Requires a JDK and the compiled core TOL library (`tollib`).
- **Build:** Compiled into a native shared library using the provided `Makefile`. 
