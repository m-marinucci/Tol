---
module_id: bstat
category: core_computational
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - bmath
  - btol
mcp_compatible: true
tags:
  - statistics
  - time-series-modeling
  - machine-learning
  - econometrics
  - clustering
---

# Statistical Analysis Module (bstat)

## Module Overview
The `bstat` module offers comprehensive statistical modeling and analysis capabilities for TOL. It implements advanced algorithms such as ARIMA estimation, Bayesian Structural Regression (BSR), K-means clustering, and various probability distribution utilities. This module is designed for quantitative analysts, econometricians, and researchers who require sophisticated statistical tools for data analysis and modeling.

Key capabilities include:
- Time series modeling and forecasting
- Machine learning algorithms
- Statistical hypothesis testing
- Probability distribution functions
- Bayesian analysis methods

## Core Functions/Classes

### Model ARIMA(Serie s, Real p, Real d, Real q)
Estimates an ARIMA(p,d,q) model for the given time series using maximum likelihood estimation.

**Parameters**
- `s` (`Serie`): input time series data
- `p` (`Real`): autoregressive (AR) order
- `d` (`Real`): differencing order for stationarity
- `q` (`Real`): moving average (MA) order

**Returns**
- `Model`: fitted ARIMA model object with estimated parameters

**Example**
```tol
// Fit ARIMA(1,1,1) model to time series
Serie ts = LoadTimeSeries("data.csv");
Model arima_model = ARIMA(ts, 1, 1, 1);

// Access model properties
Real aic = GetAIC(arima_model);
Serie forecast = Forecast(arima_model, 12);  // 12-period forecast
```

**Errors**
- `InvalidOrderError` if any order parameter is negative
- `InsufficientDataError` if the series is too short for the specified model
- `ConvergenceError` if maximum likelihood estimation fails to converge

**Performance Notes**
- Uses optimized algorithms for parameter estimation
- Computational complexity increases with model order
- Large time series may require significant memory

### Matrix KMeans(Matrix data, Real clusters)
Performs K-means clustering on a dataset where each row represents an observation and each column represents a feature.

**Parameters**
- `data` (`Matrix`): input data matrix (n×p for n observations, p features)
- `clusters` (`Real`): desired number of clusters (k)

**Returns**
- `Matrix`: centroid matrix (k×p) containing cluster centers

**Example**
```tol
// Cluster customer data into 3 segments
Matrix customer_data = LoadMatrix("customers.csv");
Matrix centroids = KMeans(customer_data, 3);

// Get cluster assignments
Set assignments = GetClusterAssignments(customer_data, centroids);
```

**Errors**
- `InvalidClusterCountError` if clusters ≤ 0 or clusters > number of observations
- `EmptyDataError` if input matrix is empty
- `ConvergenceError` if algorithm fails to converge within maximum iterations

### Real DistNormal(Real x, Real mean, Real std)
Computes the probability density function of the normal distribution.

**Parameters**
- `x` (`Real`): value at which to evaluate the PDF
- `mean` (`Real`): distribution mean (μ)
- `std` (`Real`): standard deviation (σ > 0)

**Returns**
- `Real`: probability density at x

**Example**
```tol
Real density = DistNormal(0.0, 0.0, 1.0);  // Standard normal at x=0
Real prob = DistNormal(1.96, 0.0, 1.0);    // ~0.058 for 95% confidence
```

### Model BSR(Serie y, Matrix X, Real prior_variance)
Estimates a Bayesian Structural Regression model for time series analysis.

**Parameters**
- `y` (`Serie`): dependent variable time series
- `X` (`Matrix`): matrix of explanatory variables
- `prior_variance` (`Real`): prior variance for Bayesian estimation

**Returns**
- `Model`: fitted BSR model with posterior distributions

**Example**
```tol
Serie gdp = LoadSeries("gdp.csv");
Matrix regressors = LoadMatrix("economic_indicators.csv");
Model bsr_model = BSR(gdp, regressors, 1.0);
```

### Set RandomGeneration(Text distribution, Real n, Set parameters)
Generates random samples from specified probability distributions.

**Parameters**
- `distribution` (`Text`): distribution name ("normal", "uniform", "exponential", etc.)
- `n` (`Real`): number of samples to generate
- `parameters` (`Set`): distribution-specific parameters

**Returns**
- `Set`: random samples

**Example**
```tol
// Generate 1000 normal random variables
Set normal_samples = RandomGeneration("normal", 1000, [0.0, 1.0]);

// Generate uniform random variables
Set uniform_samples = RandomGeneration("uniform", 500, [0.0, 10.0]);
```

## Data Types

### Statistical Model Types
- `Model`: general statistical model representation with parameters and diagnostics
- `ARIMAModel`: specialized ARIMA model with forecasting capabilities
- `BSRModel`: Bayesian Structural Regression model

### Data Structures
- `Matrix`: numeric matrices for multivariate data
- `Serie`: time series data with temporal ordering
- `Set`: collections of values for various statistical operations

## Integration Notes
The `bstat` module integrates closely with other TOL components:

- **bmath**: Uses numerical routines for matrix operations and optimization
- **btol**: Expects time-series structures and date handling from btol
- **plotting utilities**: Output models can be visualized with TOL's plotting functions
- **database drivers**: Can work with data loaded from various database sources

## Performance Considerations

### Computational Complexity
- ARIMA estimation: O(n³) for parameter optimization
- K-means clustering: O(nkd) per iteration (n=observations, k=clusters, d=dimensions)
- Large datasets may result in significant computation time

### Memory Usage
- Time series models store historical data and fitted parameters
- Clustering algorithms require storing distance matrices for large datasets
- Consider data preprocessing for very large datasets

### Optimization Tips
- Use compiled BLAS/LAPACK libraries for improved matrix operation speed
- Consider parallel processing for independent statistical computations
- Profile iterative algorithms to identify bottlenecks

## Error Handling
Comprehensive error checking includes:
- Parameter validation (positive variances, valid orders)
- Data quality checks (missing values, infinite values)
- Convergence monitoring for iterative algorithms
- Memory allocation error handling

## Related Modules
- **bmath**: Provides underlying mathematical operations
- **btol**: Supplies time series data structures
- **plotter**: Visualizes statistical results and model diagnostics
- **stdlib**: Contains additional statistical utility functions
