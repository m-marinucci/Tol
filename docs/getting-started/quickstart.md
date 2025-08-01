# TOL Quick Start Guide - Learn TOL in 15 Minutes

Welcome to TOL! This guide will teach you the fundamentals of TOL (Time-Oriented Language) in just 15 minutes. By the end, you'll be able to write basic TOL programs for time-series analysis and mathematical computations.

## Prerequisites

- TOL installed on your system ([Installation Guide](installation/README.md))
- Basic programming knowledge helpful but not required
- A text editor

## Table of Contents

1. [Your First TOL Program](#1-your-first-tol-program) (2 min)
2. [Variables and Basic Types](#2-variables-and-basic-types) (3 min)
3. [Functions](#3-functions) (2 min)
4. [Time Series - TOL's Superpower](#4-time-series---tols-superpower) (3 min)
5. [Matrices and Linear Algebra](#5-matrices-and-linear-algebra) (2 min)
6. [NameBlocks - Objects in TOL](#6-nameblocks---objects-in-tol) (2 min)
7. [Next Steps](#7-next-steps) (1 min)

---

## 1. Your First TOL Program (2 min)

Create a file `hello.tol`:

```tol
// This is a comment
WriteLn("Hello, TOL World!");

// TOL is autoevaluative - expressions evaluate immediately
Real pi = 3.14159;
WriteLn("Pi is approximately " + Text(pi));
```

Run it:
```bash
tolcon hello.tol
```

Output:
```
Hello, TOL World!
Pi is approximately 3.14159
```

**Key Concepts:**
- `WriteLn()` prints output
- Comments start with `//`
- `Text()` converts values to strings
- Statements are evaluated as they're defined

## 2. Variables and Basic Types (3 min)

TOL has several built-in types. Create `types.tol`:

```tol
// Numbers
Real x = 42.5;
Complex c = 3 + 4i;  // Complex numbers
Ratio r = 22/7;      // Exact rational numbers

WriteLn("Real: " + Text(x));
WriteLn("Complex: " + Text(c));
WriteLn("Ratio: " + Text(r));

// Text (strings)
Text name = "Alice";
Text greeting = "Hello, " + name + "!";
WriteLn(greeting);

// Dates and time
Date today = Today();
WriteLn("Today is: " + Text(today));

// Boolean logic
Real a = 5;
Real b = 10;
WriteLn("5 < 10 is " + Text(a < b));  // Prints: 5 < 10 is 1
```

Run it:
```bash
tolcon types.tol
```

**Key Types:**
- `Real` - Floating-point numbers
- `Complex` - Complex numbers (a + bi)
- `Text` - Strings
- `Date` - Calendar dates
- `Serie` - Time series (we'll see this next)

## 3. Functions (2 min)

Functions in TOL are first-class values. Create `functions.tol`:

```tol
// Simple function
Real Double(Real x) { x * 2 };

WriteLn("Double of 21 is " + Text(Double(21)));

// Functions can return functions
Real MakeMultiplier(Real factor) {
  Real Multiply(Real x) { x * factor }
};

Real Triple = MakeMultiplier(3);
WriteLn("Triple of 7 is " + Text(Triple(7)));

// Anonymous functions (lambdas)
Real Square = Real(Real x) { x * x };
WriteLn("5 squared is " + Text(Square(5)));

// Built-in math functions
WriteLn("Square root of 16: " + Text(Sqrt(16)));
WriteLn("e^2: " + Text(Exp(2)));
WriteLn("Natural log of 10: " + Text(Log(10)));
```

## 4. Time Series - TOL's Superpower (3 min)

This is where TOL shines! Create `timeseries.tol`:

```tol
// Create a time series
Serie prices = [100, 102, 101, 105, 103, 107, 106, 110];
WriteLn("Stock prices: " + Text(prices));

// The magic .B operator (backshift)
// prices.B gives you the previous value
Serie daily_change = prices - prices.B;
WriteLn("Daily changes: " + Text(daily_change));

// Calculate returns (percentage change)
Serie returns = (prices - prices.B) / prices.B * 100;
WriteLn("Returns (%): " + Text(returns));

// Statistics on series
WriteLn("Average price: " + Text(Mean(prices)));
WriteLn("Volatility (std dev): " + Text(StdDev(returns)));
WriteLn("Maximum price: " + Text(Max(prices)));

// Moving average
Serie ma3 = (prices + prices.B + prices.B.B) / 3;
WriteLn("3-day moving average: " + Text(ma3));

// Advanced: ARIMA forecasting (if you have time)
// SetOfSerie arima = ARIMA::Estimate(prices, 1, 0, 1);
// Serie forecast = ARIMA::Forecast(arima, 5);
```

**Key Serie Operations:**
- `.B` - Backshift (previous value)
- `.F` - Forward shift (next value)
- Arithmetic operations work element-wise
- Built-in statistics: Mean, StdDev, Max, Min

## 5. Matrices and Linear Algebra (2 min)

Create `matrices.tol`:

```tol
// Create matrices
Matrix A = [[1, 2, 3], 
            [4, 5, 6], 
            [7, 8, 9]];

Matrix B = [[9, 8, 7],
            [6, 5, 4],
            [3, 2, 1]];

WriteLn("Matrix A:");
WriteLn(Text(A));

// Matrix operations
Matrix C = A + B;
WriteLn("A + B = ");
WriteLn(Text(C));

// Matrix multiplication
Matrix I = Eye(3);  // 3x3 identity matrix
Matrix AI = A * I;
WriteLn("A * I = ");
WriteLn(Text(AI));

// Linear algebra
Matrix small = [[4, 7], [2, 6]];
Real det = MatDet(small);
WriteLn("Determinant: " + Text(det));

Matrix inv = MatInv(small);
WriteLn("Inverse:");
WriteLn(Text(inv));

// Solve Ax = b
Matrix coef = [[3, 2], [1, 2]];
Matrix rhs = [[7], [5]];
Matrix solution = MatSolve(coef, rhs);
WriteLn("Solution to system:");
WriteLn(Text(solution));
```

## 6. NameBlocks - Objects in TOL (2 min)

NameBlocks are TOL's way of creating objects. Create `objects.tol`:

```tol
// Define a NameBlock (like a class)
NameBlock Person = [[
  Text name = "Unknown";
  Real age = 0;
  
  Text Greet() {
    "Hello, I'm " + name + " and I'm " + Text(age) + " years old."
  };
  
  Real BirthYear() {
    Year(Today()) - age
  };
]];

// Use the NameBlock
Person.name = "Bob";
Person.age = 25;
WriteLn(Person.Greet());
WriteLn("Born in: " + Text(Person.BirthYear()));

// NameBlocks can contain complex data
NameBlock Portfolio = [[
  Serie prices;
  Text symbol;
  
  Real CurrentPrice() { Last(prices) };
  
  Real TotalReturn() {
    (Last(prices) - First(prices)) / First(prices) * 100
  };
  
  Real Volatility() { StdDev(Log(prices/prices.B)) };
]];

// Use the Portfolio
Portfolio.symbol = "AAPL";
Portfolio.prices = [150, 152, 149, 155, 158, 157, 160];
WriteLn("Portfolio: " + Portfolio.symbol);
WriteLn("Current price: $" + Text(Portfolio.CurrentPrice()));
WriteLn("Total return: " + Text(Portfolio.TotalReturn()) + "%");
```

## 7. Next Steps (1 min)

Congratulations! You've learned the basics of TOL. Here's what to explore next:

### Immediate Next Steps
1. **Run all the examples** - Make sure they work on your system
2. **Modify the examples** - Change values and see what happens
3. **Combine concepts** - Use series inside NameBlocks, etc.

### Further Learning
1. **[Language Reference](../user-guide/language-basics.md)** - Detailed syntax and semantics
2. **[API Documentation](../api/README.md)** - All built-in functions
3. **[Time Series Guide](../user-guide/time-series.md)** - Advanced time series operations
4. **[Statistical Functions](../api/statistical_analysis.md)** - ARIMA, regression, etc.

### Practice Projects
1. **Stock Portfolio Analyzer** - Track multiple stocks, calculate returns
2. **Weather Data Analysis** - Analyze temperature trends
3. **Sales Forecasting** - Use ARIMA to predict future sales
4. **Matrix Calculator** - Build a linear algebra toolkit

### Quick Reference Card

```tol
// Types
Real x = 3.14;
Text s = "hello";
Serie ts = [1, 2, 3, 4];
Matrix m = [[1, 2], [3, 4]];
Date d = Today();

// Serie Operations
ts.B          // Previous value
ts.F          // Next value
Mean(ts)      // Average
StdDev(ts)    // Standard deviation
Sum(ts)       // Sum all values

// Useful Functions
WriteLn(x)    // Print output
Text(x)       // Convert to string
Sqrt(x)       // Square root
Log(x)        // Natural log
Exp(x)        // e^x

// Matrix Operations
A * B         // Matrix multiply
A + B         // Element-wise add
MatInv(A)     // Inverse
MatDet(A)     // Determinant
Eye(n)        // Identity matrix
```

---

## Summary

In 15 minutes, you've learned:
- ✅ Basic TOL syntax and types
- ✅ How to define and use functions
- ✅ Time series operations with `.B` and `.F`
- ✅ Matrix operations and linear algebra
- ✅ Object-oriented programming with NameBlocks

TOL's strength is in its domain-specific features for time-series analysis. The `.B` operator alone makes many complex operations trivial. Combined with built-in statistical functions and autoevaluation, TOL is perfect for interactive data analysis.

**Happy coding with TOL!** 🚀