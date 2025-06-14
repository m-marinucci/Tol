# TolJava Module

## Module Overview
TolJava exposes the TOL interpreter to Java applications. It provides a `TOLMachine` class and supporting utilities, implemented using JNI. Java developers can evaluate TOL code, exchange data, and embed the interpreter in larger systems.

## Core Functions/Classes
### class TOLMachine
Main entry point for interacting with TOL.

#### TOLMachine()
Constructor that initializes the interpreter.

#### void eval(String code)
Evaluates a snippet of TOL code.

*Parameters*
- `code` (`String`): TOL code to execute

#### Object getValue(String name)
Retrieves a variable from the TOL environment, converting it to an appropriate Java type.

*Parameters*
- `name` (`String`): variable name

*Returns*
- `Object`: Java representation of the value

*Example*
```java
TOLMachine tm = new TOLMachine();
tm.eval("Real x = 5");
Double x = (Double) tm.getValue("x");
```

## Data Types
- `String`
- Java objects corresponding to TOL types (e.g., matrices become `double[][]`)

## Integration Notes
TolJava relies on the JNI shared library produced from the C++ core. Ensure the native library is on your system's library path. Data type conversions mirror TOL primitives whenever possible.

## Performance Considerations
Crossing the Java/native boundary incurs overhead. Batch evaluations or large data transfers may impact speed.
