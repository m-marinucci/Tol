# Time-Series Analysis Module (`btol`)

## Module Overview
Provides specialized operations for temporal data such as `Serie`, `TimeSet`, `Date` and `CTime`. Targeted at analysts manipulating chronological datasets.

## Core Functions/Classes
### `Lag(Serie s, Integer k) -> Serie`
Returns a series shifted by `k` periods.
- **Parameters**
  - `s` – input series
  - `k` – lag amount (positive or negative)
- **Returns**: shifted series
- **Example**
```tol
Serie y1 = Lag(y,1);
```

### `Resample(TimeSet ts, Text freq) -> TimeSet`
Resamples a `TimeSet` to a new frequency (`"Monthly"`, `"Quarterly"`, etc.).
- **Parameters**
  - `ts` – original dataset
  - `freq` – target granularity
- **Returns**: resampled data

### `DateAdd(Date d, Integer days) -> Date`
Adds a number of days to a date.

## Data Types
- `Serie`
- `TimeSet`
- `Date`, `CTime`

## Integration Notes
Time series data feeds directly into statistical modeling modules like `bstat` and visualization components for plotting.

## Performance Considerations
Operations are implemented in native C++ for efficiency on large datasets.
