# Core Plotting Functions Module (`stdlib/various/_plotter.tol`)

## Module Overview
Contains high level routines for generating charts and histograms. Targeted at users who need quick visualization from within TOL scripts.

## Core Functions/Classes
### `Plot(Code f, Real from, Real until, Real points) -> Set`
Evaluates function `f` over the given range and returns a table of results. Also displays a chart.

### `PlotSet(Set funcSet, Real from, Real until, Real points) -> Set`
Plots multiple functions over the same domain.

### `PlotMatrix(Matrix m)`
Draws lines for each column of `m` against row index.

### `SetHistConMult(Set dataSet, Set colS, Real bins) -> Set`
Generates a multivariate histogram.

## Data Types
- input data as `Set` or `Matrix`
- charts are displayed via the GUI subsystem but return tables for further use

## Integration Notes
These utilities rely on the plotting widgets provided by `tolbase`.

## Performance Considerations
For large matrices the plotting routines may perform aggregation to reduce rendering time.
