# btol Time-Series Module

## Module Overview
The `btol` module manages TOL's temporal data structures and provides operations for manipulating `Serie`, `TimeSet`, `Date`, and `CTime` objects. It is used by analysts processing chronological data such as financial series or sensor readings.

## Core Functions/Classes
### Serie MakeSerie(Set dates, Set values)
Creates a time series from parallel collections of dates and numeric values.

*Parameters*
- `dates` (`Set` of `Date`): ordered observation dates
- `values` (`Set` of `Real`): values aligned with `dates`

*Returns*
- `Serie`: new series ordered by `dates`

*Example*
```tol
Serie s = MakeSerie(dates, values);
```

### Serie Lag(Serie s, Real k)
Shifts a series by `k` periods.

*Parameters*
- `s` (`Serie`): input series
- `k` (`Real`): lag size; positive values shift forward

*Returns*
- `Serie`: series shifted by `k`

*Errors*
- `IndexError` if `|k|` is greater than the series length

### Date AddDays(Date d, Real n)
Adds `n` days to a date.

*Parameters*
- `d` (`Date`): base date
- `n` (`Real`): number of days to add (can be negative)

*Returns*
- `Date`: resulting date

## Data Types
- `Serie`: sequence of dated values
- `TimeSet`: ordered collection of time points
- `Date`: calendar date
- `CTime`: calendar time with timezone information

## Integration Notes
Time-series objects are consumable by statistical modules (`bstat`) and by plotting functions for visualization. Many functions expect compatible `TimeSet` frequencies.

## Performance Considerations
Operations on very long series may consume large amounts of memory. Use vectorized functions where possible to avoid looping in TOL code.
