# GUI Visualization Module (`tolbase`)

## Module Overview
Provides graphical widgets for plotting sets and series using the BLT toolkit. Intended for interactive data exploration within Tolbase.

## Core Functions/Classes
### `SetGraph(Set data, Text title)`
Displays multiple series contained in `data` on the same axes.

### `SerGraph(Serie s, Text title)`
Plots a single time series.

### `Histogram(Matrix m, Integer bins)`
Creates a histogram from matrix columns.

## Data Types
- `Set`, `Serie`, `Matrix`

## Integration Notes
These widgets are loaded by the Tolbase GUI and are used by the standard library plotting helpers.

## Performance Considerations
BLT rendering is efficient for moderate datasets. Extremely large sets may require thinning before display.
