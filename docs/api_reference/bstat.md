# bstat Module

## Module Overview
The `bstat` module offers statistical modeling and analysis capabilities. It implements algorithms such as ARIMA estimation, Bayesian Structural Regression (BSR), K-means clustering, and various probability distribution utilities. Designed for quantitative analysts and researchers who require advanced statistical tools.

## Core Functions/Classes
### Model ARIMA(Serie s, Real p, Real d, Real q)
Estimates an ARIMA(p,d,q) model for the given series.

*Parameters*
- `s` (`Serie`): input time series
- `p` (`Real`): AR order
- `d` (`Real`): differencing order
- `q` (`Real`): MA order

*Returns*
- `Model`: fitted ARIMA model object

*Example*
```tol
Model m = ARIMA(s, 1, 1, 1);
```

*Errors*
- `InvalidOrderError` if any order is negative
- `InsufficientDataError` if the series is too short

### Matrix KMeans(Matrix data, Real clusters)
Performs K-means clustering on a matrix where each row is an observation.

*Parameters*
- `data` (`Matrix`): input data
- `clusters` (`Real`): desired number of clusters

*Returns*
- `Matrix`: centroid matrix

## Data Types
- `Model`: statistical model representation
- `Matrix`: numeric matrix

## Integration Notes
`bstat` uses numerical routines from `bmath` and expects time-series structures from `btol`. Output models can be visualized with plotting utilities.

## Performance Considerations
Large datasets may result in long computation time. Some routines are iterative; using compiled BLAS/LAPACK libraries improves speed.
