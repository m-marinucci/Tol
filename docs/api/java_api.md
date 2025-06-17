---
module_id: toljava
category: integration
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - tol_core
  - jni
mcp_compatible: false
tags:
  - java
  - jni
  - integration
  - embedding
  - cross-platform
---

# Java API Module (toljava)

## Module Overview
The `toljava` module provides comprehensive Java language bindings for embedding the TOL engine within Java applications. Through the Java Native Interface (JNI), this module enables Java developers to leverage TOL's powerful time-series analysis, statistical modeling, and mathematical computation capabilities directly from Java code. The API provides seamless data exchange between Java and TOL environments while maintaining type safety and performance.

Key capabilities include:
- Embedded TOL interpreter management
- Bidirectional data exchange between Java and TOL
- Type-safe conversion between Java and TOL data structures
- Exception handling and error management
- Multi-threaded execution support
- Memory management and resource cleanup

## Core Classes

### TOLMachine
Primary interface for managing the embedded TOL interpreter and executing TOL code.

**Constructor**
```java
TOLMachine machine = new TOLMachine();
```

**Core Methods**

#### String initTOL()
Initializes the TOL interpreter instance.

**Returns**
- `String`: Initialization status message

**Example**
```java
TOLMachine machine = new TOLMachine();
String status = machine.initTOL();
if (status.contains("OK")) {
    System.out.println("TOL initialized successfully");
}
```

#### Object[] execute(String code)
Executes TOL code and returns results with error information.

**Parameters**
- `code` (`String`): TOL code to execute

**Returns**
- `Object[]`: Array where first element is error count, remaining elements are output messages

**Example**
```java
// Execute simple TOL code
Object[] result = machine.execute("Real x = 5 + 3; Write(x);");
int errorCount = Integer.parseInt((String)result[0]);

if (errorCount == 0) {
    System.out.println("Execution successful");
    // Process output messages in result[1], result[2], etc.
} else {
    System.out.println("Execution failed with " + errorCount + " errors");
}

// Execute complex analysis
String tolCode = """
    Serie prices = LoadSeries("stock_data.csv");
    Model arima = ARIMA(prices, 1, 1, 1);
    Serie forecast = Forecast(arima, 12);
    Write("Forecast completed");
    """;
Object[] analysisResult = machine.execute(tolCode);
```

#### Object callCode(String codeName, Object[] parameters)
Calls a previously defined TOL function with parameters.

**Parameters**
- `codeName` (`String`): Name of TOL function to call
- `parameters` (`Object[]`): Array of parameters to pass

**Returns**
- `Object`: Function return value

**Example**
```java
// Define function in TOL
machine.execute("Real Square(Real x) { x * x };");

// Call function from Java
Object[] params = {5.0};
Object result = machine.callCode("Square", params);
Double squared = (Double) result;  // Returns 25.0
```

#### Object getVariable(String varName)
Retrieves the value of a TOL variable.

**Parameters**
- `varName` (`String`): Name of TOL variable

**Returns**
- `Object`: Variable value converted to appropriate Java type

**Example**
```java
// Set variable in TOL
machine.execute("Real pi = 3.14159; Text greeting = \"Hello\";");

// Retrieve variables in Java
Double piValue = (Double) machine.getVariable("pi");
String greetingText = (String) machine.getVariable("greeting");
```

#### Object setVariableValue(String varName, TOLLObject varValue)
Sets the value of a TOL variable from Java.

**Parameters**
- `varName` (`String`): Name of TOL variable
- `varValue` (`TOLLObject`): Value to set (wrapped in TOL object)

**Returns**
- `Object`: Status of operation

### TOLVariable
Represents a TOL variable with type information and metadata.

**Properties**
- `name`: Variable name
- `type`: TOL type (Real, Text, Matrix, etc.)
- `value`: Variable value
- `description`: Optional description

**Example**
```java
TOLVariable[] realVars = machine.getRealVariables();
for (TOLVariable var : realVars) {
    System.out.println(var.name + " = " + var.value + " (" + var.type + ")");
}
```

### TOLLObject
Wrapper class for TOL objects to maintain type information during Java-TOL exchange.

**Constructor**
```java
TOLLObject tolObj = new TOLLObject(value, "Real");
```

**Methods**
- `getValue()`: Get the wrapped value
- `getType()`: Get the TOL type
- `toString()`: String representation

## Data Type Mapping

### Java to TOL Conversion
Automatic conversion between Java and TOL data types.

**Primitive Types**
- `double` ↔ `Real`
- `String` ↔ `Text`
- `boolean` ↔ `Real` (0/1)
- `int` ↔ `Real`

**Complex Types**
- `double[][]` ↔ `Matrix`
- `List<Double>` ↔ `Set`
- `Date` ↔ `Date`
- `Map<String, Object>` ↔ `NameBlock`

**Example**
```java
// Java matrix to TOL
double[][] javaMatrix = {{1, 2, 3}, {4, 5, 6}};
machine.execute("Matrix tolMatrix = " + convertMatrixToTOL(javaMatrix));

// TOL matrix to Java
machine.execute("Matrix result = MatMul(A, B);");
double[][] resultMatrix = (double[][]) machine.getVariable("result");
```

### Type Safety
Comprehensive type checking and validation.

**Type Validation**
```java
// Check variable type before conversion
Object var = machine.getVariable("myVar");
if (var instanceof Double) {
    Double realValue = (Double) var;
} else if (var instanceof String) {
    String textValue = (String) var;
}
```

## Advanced Features

### Multi-threading Support
Thread-safe operations for concurrent TOL execution.

**Thread Safety**
```java
// Create separate TOL instances for different threads
class TOLWorker extends Thread {
    private TOLMachine machine;
    
    public TOLWorker() {
        this.machine = new TOLMachine();
        this.machine.initTOL();
    }
    
    @Override
    public void run() {
        // Execute TOL code in separate thread
        Object[] result = machine.execute("// TOL analysis code");
        // Process results
    }
}
```

### Memory Management
Efficient memory usage and resource cleanup.

**Resource Management**
```java
try (TOLMachine machine = new TOLMachine()) {
    machine.initTOL();
    // Use TOL machine
    Object[] result = machine.execute("// TOL code");
} // Automatic cleanup
```

### Exception Handling
Comprehensive error handling for TOL operations.

**Error Management**
```java
try {
    Object[] result = machine.execute("Real x = 1/0;");  // Division by zero
    int errors = Integer.parseInt((String)result[0]);
    if (errors > 0) {
        // Handle TOL execution errors
        for (int i = 1; i < result.length; i++) {
            System.err.println("TOL Error: " + result[i]);
        }
    }
} catch (Exception e) {
    // Handle Java-level exceptions
    System.err.println("Java Exception: " + e.getMessage());
}
```

## Integration Patterns

### Data Analysis Pipeline
Complete data analysis workflow using Java and TOL.

**Example Pipeline**
```java
public class FinancialAnalysis {
    private TOLMachine tol;
    
    public FinancialAnalysis() {
        tol = new TOLMachine();
        tol.initTOL();
    }
    
    public ForecastResult analyzePrices(double[] prices, Date[] dates) {
        // Convert Java data to TOL
        String tolCode = String.format("""
            Serie prices = MakeSerie(%s, %s);
            Model arima = ARIMA(prices, 1, 1, 1);
            Serie forecast = Forecast(arima, 12);
            Real aic = GetAIC(arima);
            """, 
            convertDatesToTOL(dates), 
            convertArrayToTOL(prices));
        
        // Execute analysis
        Object[] result = tol.execute(tolCode);
        
        // Extract results
        double[] forecastValues = (double[]) tol.getVariable("forecast");
        double aicValue = (Double) tol.getVariable("aic");
        
        return new ForecastResult(forecastValues, aicValue);
    }
}
```

### Web Application Integration
Integration with Java web frameworks.

**Spring Boot Example**
```java
@RestController
public class AnalysisController {
    
    @Autowired
    private TOLService tolService;
    
    @PostMapping("/analyze")
    public ResponseEntity<AnalysisResult> analyze(@RequestBody DataRequest request) {
        try {
            AnalysisResult result = tolService.performAnalysis(request.getData());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }
}

@Service
public class TOLService {
    private final TOLMachine tol = new TOLMachine();
    
    @PostConstruct
    public void init() {
        tol.initTOL();
    }
    
    public AnalysisResult performAnalysis(double[] data) {
        // TOL analysis implementation
        String code = generateTOLCode(data);
        Object[] result = tol.execute(code);
        return parseResults(result);
    }
}
```

## Performance Considerations

### JNI Overhead
Minimizing the cost of Java-native transitions.

**Optimization Strategies**
- Batch multiple operations in single TOL execution
- Minimize frequent variable access across JNI boundary
- Use appropriate data structures for bulk operations
- Cache frequently accessed TOL functions

**Example**
```java
// Inefficient: Multiple JNI calls
for (int i = 0; i < 1000; i++) {
    machine.execute("Real x" + i + " = " + i + " * 2;");
}

// Efficient: Single JNI call
StringBuilder code = new StringBuilder();
for (int i = 0; i < 1000; i++) {
    code.append("Real x").append(i).append(" = ").append(i).append(" * 2; ");
}
machine.execute(code.toString());
```

### Memory Usage
Efficient memory management for large datasets.

**Memory Optimization**
- Use streaming for large datasets
- Clean up TOL variables when no longer needed
- Monitor memory usage in long-running applications
- Implement proper resource disposal patterns

## Error Handling and Debugging

### Comprehensive Error Reporting
Detailed error information for debugging.

**Error Analysis**
```java
public void executeWithErrorHandling(String tolCode) {
    Object[] result = machine.execute(tolCode);
    int errorCount = Integer.parseInt((String)result[0]);
    
    if (errorCount > 0) {
        System.err.println("TOL execution failed with " + errorCount + " errors:");
        for (int i = 1; i < result.length; i++) {
            System.err.println("  " + result[i]);
        }
    } else {
        System.out.println("TOL execution successful");
        // Process successful results
    }
}
```

### Debugging Support
Tools and techniques for debugging Java-TOL integration.

**Debugging Features**
- Verbose logging of JNI operations
- TOL variable inspection utilities
- Performance profiling capabilities
- Memory usage monitoring
- Exception stack trace integration

## Related Modules
- **[Mathematical Operations (bmath)](mathematical_operations.md)**: Core mathematical functions accessible from Java
- **[Statistical Analysis (bstat)](statistical_analysis.md)**: Statistical modeling through Java interface
- **[Time-Series Analysis (btol)](time_series_analysis.md)**: Time series operations in Java applications
- **[Database Connectivity (dbdrivers)](database_connectivity.md)**: Database integration in Java environments
