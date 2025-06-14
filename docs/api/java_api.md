# Java API Module (`TolJava`)

## Module Overview
TolJava exposes TOL's functionality to Java programs via JNI. It provides a `TOLMachine` class that manages the interpreter and converts data between Java and TOL types.

## Core Functions/Classes
### `TOLMachine.start()`
Loads the native library and creates an interpreter instance.

### `TOLMachine.eval(String code) -> Object`
Evaluates TOL code and converts the result to the closest Java type.

### `TOLMachine.call(String name, Object... args) -> Object`
Calls a TOL function by name with automatic type conversion.

### `TOLMachine.shutdown()`
Destroys the interpreter and unloads resources.

## Data Types
Java primitives and arrays map to TOL `Real`, `Text`, `Matrix`, `Serie` and others. Complex structures become `NameBlock` representations.

## Integration Notes
Used when embedding TOL in larger Java applications or web services. Requires the compiled native `tol` library in the system path.

## Performance Considerations
JNI calls introduce overhead; batch large operations when possible. Data conversion of big matrices may incur copy costs.
