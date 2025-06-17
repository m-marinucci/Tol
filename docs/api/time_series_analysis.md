---
module_id: btol_time_series
category: core_computational
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - bbasic
  - bmath
mcp_compatible: true
tags:
  - time-series
  - temporal-data
  - financial-analysis
  - econometrics
  - data-manipulation
---

# Time-Series Analysis Module (btol)

## Module Overview
The `btol` module manages TOL's temporal data structures and provides comprehensive operations for manipulating `Serie`, `TimeSet`, `Date`, and `CTime` objects. This module is essential for analysts processing chronological data such as financial time series, economic indicators, sensor readings, and any data with temporal dependencies.

TOL's time-oriented design makes it particularly powerful for:
- Financial market analysis
- Economic forecasting
- Signal processing
- IoT sensor data analysis
- Business intelligence with temporal components

## Core Functions/Classes

### Serie MakeSerie(Set dates, Set values)
Creates a time series from parallel collections of dates and numeric values, ensuring proper temporal ordering.

**Parameters**
- `dates` (`Set` of `Date`): ordered observation dates
- `values` (`Set` of `Real`): values aligned with corresponding dates

**Returns**
- `Serie`: new time series ordered chronologically by dates

**Example**
```tol
// Create a simple time series
Set dates = [y2023m01d01, y2023m01d02, y2023m01d03];
Set values = [100.5, 102.3, 98.7];
Serie stock_prices = MakeSerie(dates, values);

// Create from loaded data
Set price_dates = LoadDates("dates.csv");
Set price_values = LoadValues("prices.csv");
Serie market_data = MakeSerie(price_dates, price_values);
```

**Errors**
- `MismatchedLengthError` if dates and values have different lengths
- `InvalidDateOrderError` if dates are not in chronological order
- `DuplicateDateError` if the same date appears multiple times

### Serie Lag(Serie s, Real k)
Shifts a time series by `k` periods, useful for creating lagged variables in econometric analysis.

**Parameters**
- `s` (`Serie`): input time series
- `k` (`Real`): lag size; positive values shift forward, negative values shift backward

**Returns**
- `Serie`: time series shifted by `k` periods

**Example**
```tol
Serie prices = LoadSeries("stock_prices.csv");
Serie lagged_prices = Lag(prices, 1);     // Previous day's prices
Serie lead_prices = Lag(prices, -1);      // Next day's prices (for backtesting)

// Create multiple lags for regression analysis
Serie lag1 = Lag(prices, 1);
Serie lag2 = Lag(prices, 2);
Serie lag5 = Lag(prices, 5);
```

**Errors**
- `IndexError` if `|k|` is greater than the series length
- `EmptySeriesError` if input series is empty

### Date AddDays(Date d, Real n)
Adds `n` days to a date, handling calendar arithmetic including leap years and month boundaries.

**Parameters**
- `d` (`Date`): base date
- `n` (`Real`): number of days to add (can be negative for subtraction)

**Returns**
- `Date`: resulting date after adding n days

**Example**
```tol
Date start_date = y2023m01d15;
Date future_date = AddDays(start_date, 30);    // February 14, 2023
Date past_date = AddDays(start_date, -10);     // January 5, 2023

// Business day calculations
Date today = Today();
Date next_week = AddDays(today, 7);
```

### Serie DifEq(Real operator, Serie s, Real initial)
Applies difference equation operators to time series, fundamental for time series transformations.

**Parameters**
- `operator` (`Real`): difference operator specification
- `s` (`Serie`): input time series
- `initial` (`Real`): initial condition for the transformation

**Returns**
- `Serie`: transformed time series

**Example**
```tol
// First difference (common for making series stationary)
Serie prices = LoadSeries("prices.csv");
Serie returns = DifEq(1-B, prices, 0);  // B is the lag operator

// Seasonal differencing
Serie seasonal_diff = DifEq(1-B^12, prices, 0);  // 12-period seasonal difference
```

### TimeSet MakeTimeSet(Date start, Date end, Text frequency)
Creates a regular time set between two dates with specified frequency.

**Parameters**
- `start` (`Date`): starting date
- `end` (`Date`): ending date
- `frequency` (`Text`): frequency specification ("daily", "weekly", "monthly", etc.)

**Returns**
- `TimeSet`: regular sequence of dates

**Example**
```tol
// Create monthly time set for a year
TimeSet monthly = MakeTimeSet(y2023m01d01, y2023m12d31, "monthly");

// Create business days only
TimeSet business_days = MakeTimeSet(y2023m01d01, y2023m12d31, "business_daily");

// Weekly time set
TimeSet weekly = MakeTimeSet(y2023m01d01, y2023m12d31, "weekly");
```

### Real SerieLength(Serie s)
Returns the number of observations in a time series.

**Parameters**
- `s` (`Serie`): input time series

**Returns**
- `Real`: number of observations

**Example**
```tol
Serie data = LoadSeries("data.csv");
Real n_obs = SerieLength(data);
Write("Series contains " + Text(n_obs) + " observations");
```

## Data Types

### Core Temporal Types
- `Serie`: sequence of dated values with automatic temporal ordering
- `TimeSet`: ordered collection of time points with regular or irregular spacing
- `Date`: calendar date with year, month, day precision
- `CTime`: calendar time with time zone information for precise timestamps

### Specialized Types
- `Frequency`: enumeration of common time frequencies (daily, weekly, monthly, quarterly, yearly)
- `DateRange`: specification of date intervals with start and end points

## Integration Notes
Time-series objects integrate seamlessly with other TOL modules:

- **Statistical modules (bstat)**: Time series are primary inputs for ARIMA, regression, and other statistical models
- **Plotting functions**: Direct visualization support for time series charts and plots
- **Database drivers**: Can load time series directly from SQL databases with temporal columns
- **Mathematical operations (bmath)**: Support for vectorized operations on time series values

### Frequency Compatibility
Many functions expect compatible `TimeSet` frequencies when working with multiple series:
- Automatic alignment for series with matching frequencies
- Interpolation options for mismatched frequencies
- Warning systems for potential temporal misalignment

## Performance Considerations

### Memory Usage
- Long time series can consume significant memory
- Consider using sparse representations for series with many missing values
- Memory-mapped files for extremely large historical datasets

### Computational Efficiency
- Use vectorized functions to avoid explicit loops in TOL code
- Batch operations on multiple series when possible
- Consider parallel processing for independent time series operations

### Best Practices
- Maintain consistent time frequencies within analysis workflows
- Use appropriate date precision (Date vs CTime) based on requirements
- Cache frequently accessed time series transformations

## Error Handling
Comprehensive temporal error checking:
- Date validity and calendar arithmetic
- Time zone consistency for CTime objects
- Frequency compatibility between series
- Missing value handling in temporal operations

## Common Use Cases

### Financial Analysis
```tol
// Load stock price data
Serie prices = LoadSeries("AAPL_prices.csv");

// Calculate returns
Serie returns = DifEq(1-B, Log(prices), 0);

// Create moving averages
Serie ma_20 = MovingAverage(prices, 20);
Serie ma_50 = MovingAverage(prices, 50);
```

### Economic Forecasting
```tol
// Load economic indicators
Serie gdp = LoadSeries("gdp_quarterly.csv");
Serie inflation = LoadSeries("cpi_monthly.csv");

// Align frequencies (convert monthly to quarterly)
Serie inflation_q = AggregateToQuarterly(inflation, "average");

// Create lagged variables
Serie gdp_lag1 = Lag(gdp, 1);
Serie gdp_lag2 = Lag(gdp, 2);
```

## Related Modules
- **bstat**: Consumes time series for statistical modeling and analysis
- **plotter**: Provides visualization capabilities for temporal data
- **bmath**: Supplies mathematical operations for time series transformations
- **dbdrivers**: Enables loading time series from various database sources
