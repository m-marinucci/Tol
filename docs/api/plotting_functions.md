---
module_id: plotter
category: visualization
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - btol
  - bmath
  - stdlib
mcp_compatible: true
tags:
  - plotting
  - visualization
  - charts
  - graphics
  - data-visualization
---

# Plotting Functions Module (plotter)

## Module Overview
The `plotter` module provides essential plotting utilities within TOL's standard library for creating charts, graphs, and visualizations. These functions generate charts from sets, matrices, function definitions, and time series data. The module is designed for quick visualization and exploratory data analysis rather than publication-quality graphics, making it ideal for interactive analysis and rapid prototyping.

Key capabilities include:
- Function plotting over specified ranges
- Matrix and time series visualization
- Statistical plots (histograms, scatter plots)
- Integration with GUI visualization components
- Export capabilities for various formats

## Core Functions/Classes

### Set Plot(Code func, Real from, Real until, Real points)
Evaluates a mathematical function over a specified range and generates a chart displaying the results.

**Parameters**
- `func` (`Code`): function of one real argument to be plotted
- `from` (`Real`): starting value of the domain
- `until` (`Real`): ending value of the domain
- `points` (`Real`): number of evaluation points (resolution)

**Returns**
- `Set`: table of x/y coordinate pairs used for the plot

**Example**
```tol
// Plot sine function
Real sine_func(Real x) { Sin(x) };
Set sine_plot = Plot(sine_func, 0, 6.28, 100);

// Plot polynomial function
Real poly_func(Real x) { x^3 - 2*x^2 + x - 1 };
Set poly_plot = Plot(poly_func, -2, 3, 200);

// Plot exponential decay
Real decay_func(Real x) { Exp(-x/2) };
Set decay_plot = Plot(decay_func, 0, 10, 150);
```

**Performance Notes**
- Higher `points` values provide smoother curves but increase computation time
- Optimal point count depends on function complexity and display resolution
- Consider function evaluation cost when choosing point density

### Set PlotMatrix(Matrix M)
Plots all columns of a matrix with automatic x-axis generation based on row indices.

**Parameters**
- `M` (`Matrix`): data matrix where each column represents a data series

**Returns**
- `Set`: formatted data table suitable for chart display

**Example**
```tol
// Plot multiple time series
Matrix stock_data = LoadMatrix("stock_prices.csv");
Set price_chart = PlotMatrix(stock_data);

// Plot statistical data
Matrix results = [[1, 4, 9], [2, 5, 8], [3, 6, 7]];  // 3 series
Set comparison_chart = PlotMatrix(results);
```

### Set PlotXMatrix(Matrix M, Real x0, Real x1)
Plots columns of a matrix against a custom x-axis range.

**Parameters**
- `M` (`Matrix`): data matrix to be plotted
- `x0` (`Real`): starting x-axis value
- `x1` (`Real`): ending x-axis value

**Returns**
- `Set`: chart data with custom x-axis scaling

**Example**
```tol
// Plot data over specific time range
Matrix monthly_data = LoadMatrix("monthly_sales.csv");
Set sales_chart = PlotXMatrix(monthly_data, 2023.0, 2024.0);

// Plot experimental results with custom scaling
Matrix experiment_results = RunExperiment();
Set results_chart = PlotXMatrix(experiment_results, 0.0, 100.0);
```

### Set PlotSet(Set functions, Real from, Real until, Real points)
Plots multiple functions simultaneously for comparison analysis.

**Parameters**
- `functions` (`Set`): collection of function codes to plot
- `from` (`Real`): domain start value
- `until` (`Real`): domain end value
- `points` (`Real`): number of evaluation points

**Returns**
- `Set`: multi-series chart data

**Example**
```tol
// Compare trigonometric functions
Real sin_func(Real x) { Sin(x) };
Real cos_func(Real x) { Cos(x) };
Real tan_func(Real x) { Tan(x) };
Set trig_functions = [sin_func, cos_func, tan_func];
Set trig_comparison = PlotSet(trig_functions, 0, 6.28, 100);
```

### Set PlotPolyn(Polynomial pol, Real x0, Real x1, Real points)
Specialized plotting function for polynomial objects.

**Parameters**
- `pol` (`Polynomial`): polynomial to be plotted
- `x0` (`Real`): domain start
- `x1` (`Real`): domain end
- `points` (`Real`): evaluation points

**Returns**
- `Set`: polynomial plot data

**Example**
```tol
// Plot quadratic polynomial
Polynomial quadratic = Polynomial([1, -2, 1]);  // x² - 2x + 1
Set quad_plot = PlotPolyn(quadratic, -3, 5, 100);

// Plot higher-order polynomial
Polynomial cubic = Polynomial([1, 0, -3, 2]);   // x³ - 3x + 2
Set cubic_plot = PlotPolyn(cubic, -2, 3, 150);
```

### Set Histogram(Set data, Real bins)
Creates histogram visualization for statistical data analysis.

**Parameters**
- `data` (`Set`): numerical data to be binned
- `bins` (`Real`): number of histogram bins

**Returns**
- `Set`: histogram data with bin centers and frequencies

**Example**
```tol
// Analyze distribution of random data
Set random_data = RandomGeneration("normal", 1000, [0, 1]);
Set hist_data = Histogram(random_data, 20);

// Analyze financial returns
Serie stock_prices = LoadSeries("stock_data.csv");
Set returns = CalculateReturns(stock_prices);
Set return_histogram = Histogram(returns, 30);
```

### Set ScatterPlot(Set x_data, Set y_data)
Creates scatter plot for correlation analysis.

**Parameters**
- `x_data` (`Set`): x-coordinate values
- `y_data` (`Set`): y-coordinate values

**Returns**
- `Set`: scatter plot data points

**Example**
```tol
// Analyze correlation between variables
Set heights = LoadData("heights.csv");
Set weights = LoadData("weights.csv");
Set correlation_plot = ScatterPlot(heights, weights);

// Plot model predictions vs actual values
Set predictions = ModelPredict(model, test_data);
Set actual = LoadActualValues("test_results.csv");
Set validation_plot = ScatterPlot(actual, predictions);
```

## Advanced Plotting Functions

### Set PlotSerie(Serie s)
Specialized plotting for time series data with proper temporal axis handling.

**Parameters**
- `s` (`Serie`): time series to be plotted

**Returns**
- `Set`: time series plot with date/time axis

**Example**
```tol
// Plot financial time series
Serie stock_prices = LoadSeries("AAPL_daily.csv");
Set price_chart = PlotSerie(stock_prices);

// Plot economic indicators
Serie gdp_data = LoadSeries("gdp_quarterly.csv");
Set gdp_chart = PlotSerie(gdp_data);
```

### Set PlotMultipleSeries(Set series_collection)
Plots multiple time series on the same chart for comparison.

**Parameters**
- `series_collection` (`Set`): collection of Serie objects

**Returns**
- `Set`: multi-series time plot

**Example**
```tol
// Compare multiple stock prices
Serie aapl = LoadSeries("AAPL.csv");
Serie googl = LoadSeries("GOOGL.csv");
Serie msft = LoadSeries("MSFT.csv");
Set stock_comparison = PlotMultipleSeries([aapl, googl, msft]);
```

## Data Types

### Input Types
- `Code`: Function definitions for mathematical plotting
- `Matrix`: Numerical data matrices for multi-series plots
- `Set`: Collections of data points or functions
- `Serie`: Time series data with temporal ordering
- `Polynomial`: Polynomial objects for algebraic plotting

### Output Types
- `Set`: Standardized chart data format compatible with GUI components
- Chart data structure: `[[x1, y1], [x2, y2], ...]` for single series
- Multi-series format: `[[x, y1, y2, y3, ...], ...]` for multiple data series

## Integration Notes

### GUI Integration
The plotting functions integrate seamlessly with TOL's GUI components:
- **tolbase**: Chart data can be displayed in interactive GUI windows
- **BLT widgets**: Advanced plotting capabilities with zoom and pan
- **Export functions**: Save charts to various image formats (PNG, SVG, PDF)

### Data Pipeline Integration
- **Database connectivity**: Plot data directly from SQL query results
- **Statistical analysis**: Visualize results from bstat module functions
- **Time series analysis**: Display temporal data from btol operations
- **Mathematical operations**: Plot results of bmath computations

### Chart Customization
```tol
// Basic chart with custom title and labels
Set chart_data = Plot(my_function, 0, 10, 100);
Set styled_chart = AddChartStyle(chart_data, "My Function", "X Values", "Y Values");

// Multi-series chart with legend
Set multi_data = PlotSet(functions, 0, 10, 100);
Set legend_chart = AddLegend(multi_data, ["Sin(x)", "Cos(x)", "Tan(x)"]);
```

## Performance Considerations

### Computational Efficiency
- **Point density**: Balance between visual quality and computation time
- **Function complexity**: Simple functions plot faster than complex calculations
- **Data size**: Large matrices may require memory optimization
- **Real-time plotting**: Consider update frequency for dynamic data

### Memory Usage
- Plot data is stored in memory as Set objects
- Large point counts increase memory consumption
- Consider data decimation for very large datasets
- Use appropriate data types for memory efficiency

### Optimization Tips
- Limit `points` parameter for interactive use (100-500 points typically sufficient)
- Use PlotXMatrix for pre-computed data rather than function evaluation
- Cache plot data for repeated visualizations
- Consider sparse sampling for smooth functions

### GUI Rendering Performance
- Very large point counts may slow down GUI rendering
- Optimize for target display resolution
- Use appropriate chart types for data characteristics
- Consider progressive rendering for large datasets

## Export and Output Options

### Supported Formats
- **Interactive GUI**: Display in tolbase windows with zoom/pan capabilities
- **Image export**: PNG, JPEG for presentations and reports
- **Vector graphics**: SVG, PDF for scalable publications
- **Data export**: CSV format for external analysis tools

### Export Examples
```tol
// Generate and export chart
Set plot_data = Plot(my_function, 0, 10, 200);
ExportChart(plot_data, "function_plot.png", "PNG");
ExportChart(plot_data, "function_plot.svg", "SVG");

// Export data for external tools
ExportData(plot_data, "plot_data.csv", "CSV");
```

## Common Use Cases

### Scientific Analysis
```tol
// Plot experimental data with error bars
Matrix experiment_data = LoadMatrix("experiment_results.csv");
Set data_plot = PlotMatrix(experiment_data);
Set error_plot = AddErrorBars(data_plot, error_values);
```

### Financial Analysis
```tol
// Technical analysis charts
Serie prices = LoadSeries("stock_prices.csv");
Serie ma_20 = MovingAverage(prices, 20);
Serie ma_50 = MovingAverage(prices, 50);
Set technical_chart = PlotMultipleSeries([prices, ma_20, ma_50]);
```

### Statistical Visualization
```tol
// Distribution analysis
Set sample_data = RandomGeneration("normal", 1000, [0, 1]);
Set histogram = Histogram(sample_data, 25);
Set qq_plot = QQPlot(sample_data, "normal");
```

## Error Handling
Common plotting errors and their handling:
- `InvalidDomainError`: Domain start >= end or invalid range
- `InsufficientPointsError`: Too few points for meaningful plot
- `FunctionEvaluationError`: Function fails to evaluate at some points
- `DimensionMismatchError`: Incompatible matrix dimensions
- `EmptyDataError`: No data provided for plotting

## Related Modules
- **[GUI Visualization (tolbase_viz)](gui_visualization.md)**: Interactive plotting components
- **[Mathematical Operations (bmath)](mathematical_operations.md)**: Functions to be plotted
- **[Statistical Analysis (bstat)](statistical_analysis.md)**: Statistical plots and analysis
- **[Time-Series Analysis (btol)](time_series_analysis.md)**: Temporal data visualization
- **[Standard Library (stdlib)](standard_library.md)**: Utility functions for data preparation
