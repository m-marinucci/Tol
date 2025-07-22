# TolJava: TOL to Java Binding (`tol-master/TolJava/`)

## Overview

This directory provides **TolJava**, the integration layer for using the **TOL C++ engine** (`tol-master/tol/`) from **Java applications**. It consists of Java classes for the user-facing API and C/C++ JNI (Java Native Interface) code to bridge Java calls to the native TOL library.

## Code Functionality

- **Java API Classes (`TOLJava/`):** Contains the Java source files (`.java`) defining classes and methods that Java developers use to interact with TOL. This might include classes like `TolInterpreter`, `TolMatrix`, `TolSerie`, etc., mirroring TOL concepts.
- **JNI Bridge (`TOLJavaJNI/`):** Contains C/C++ source files (`.c`, `.cpp`) that implement the JNI functions. These native methods are called by the Java API classes. They use:
    - JNI functions (provided by the JDK) to interact with Java objects and types passed from the Java layer.
    - The internal C++ API of the TOL engine to execute the requested operations (e.g., run code, get/set variables, convert data).
    The JNI code is compiled into a native shared library (e.g., `.dll`, `.so`, `.dylib`) that the Java runtime loads.
- **Examples (`TOLJava-Ejemplos/`):** Provides sample Java code demonstrating how to use the TolJava API.
- **Web Demo (`WebTOLJavaDEMO/`):** Includes a sample web application showcasing the use of TolJava in a web context (potentially using Servlets/JSP).
- **Build System:** (Build files like `CMakeLists.txt` or Ant `build.xml` are likely within the subdirectories, especially `TOLJavaJNI/`). The build process involves:
    - Compiling the Java classes (`.java` -> `.class`).
    - Compiling the JNI C/C++ code into a native shared library.
    - Potentially packaging the Java classes and the native library into a JAR file.

## Potential API Functionality (Java Methods)

The API consists of public methods within the Java classes provided in `TOLJava/`:
- **Interpreter Control:** `TolInterpreter.initialize()`, `TolInterpreter.shutdown()`, `TolInterpreter.eval("...")`, `TolInterpreter.source("...")` (or similar).
- **Data Handling:** Methods to:
    - Create TOL data structures from Java types (e.g., `TolMatrix.fromDoubleArray(double[][])`, `TolSerie.fromDatesAndValues(...)`).
    - Get/Set TOL variables using Java objects.
    - Convert TOL results back into Java objects (e.g., `tolResult.toDoubleArray()`, `tolSerie.getDates()`).
- **Class Hierarchy:** Java classes mirroring TOL's data types (`TolMatrix`, `TolDate`, `TolSet`, etc.) with methods for manipulation.

## Appendix

- **Implementation Language:** Java, C/C++ (for JNI).
- **Dependencies:** Requires a Java Development Kit (JDK), a C++ compiler, and the compiled core TOL library (`tol-master/tol/`).
- **Build:** Involves compiling Java code, compiling C/C++ JNI code, and potentially packaging. Build scripts are likely in subdirectories.
- **License:** (License file missing, likely inherits - presumably GPL). 
