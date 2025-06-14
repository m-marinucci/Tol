# Statistical Analysis Module (`bstat`)

## Module Overview
Implements modeling algorithms such as ARIMA, Bayesian Sparse Regression (BSR) and K-means clustering. Intended for statisticians and data scientists.

## Core Functions/Classes
### `ARIMA(Serie data, Set orders) -> NameBlock`
Fits an ARIMA model.
- **Parameters**
  - `data` – input series
  - `orders` – set `[p,d,q]` describing AR, differencing and MA orders
- **Returns**: `NameBlock` containing fitted coefficients and diagnostics.
- **Example**
```tol
NameBlock model = ARIMA(mySeries, [1,1,1]);
```

### `BSR(Matrix X, Serie y) -> NameBlock`
Performs Bayesian Sparse Regression.

### `KMeans(Matrix data, Integer k) -> Set`
Clusters `data` into `k` groups.

## Data Types
- `Matrix`, `VMatrix`
- `NameBlock` results with fields like `coeff`, `aic`, `residuals`

## Integration Notes
`bstat` depends on `bmath` for linear algebra and on time series utilities from `btol`.

## Performance Considerations
Algorithms may be computationally intensive; native implementations leverage optimized mathematical libraries.
