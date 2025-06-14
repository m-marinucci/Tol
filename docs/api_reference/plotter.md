# Plotter Module

## Module Overview
`_plotter.tol` provides basic plotting utilities within the standard library. Functions generate charts from sets, matrices, or function definitions. The module is geared toward quick visualization rather than high-end graphics.

## Core Functions/Classes
### Set Plot(Code func, Real from, Real until, Real points)
Evaluates a function over a range and displays the resulting chart.

*Parameters*
- `func` (`Code`): function of one real argument
- `from` (`Real`): starting value
- `until` (`Real`): end value
- `points` (`Real`): number of evaluation steps

*Returns*
- `Set`: table of x/y values used for the plot

*Example*
```tol
Real myfun(Real x) { Sin(x) };
Set table = Plot(myfun, 0, 6.28, 100);
```

### Set PlotMatrix(Matrix M, Real x0, Real x1)
Plots columns of a matrix against a generated x‑axis.

*Parameters*
- `M` (`Matrix`): data matrix
- `x0` (`Real`): starting x value
- `x1` (`Real`): ending x value

## Data Types
- `Set`
- `Matrix`
- `Code`

## Integration Notes
The resulting tables can be passed to GUI visualization components in `tolbase` for display. Histograms and other functions rely on matrix and set utilities from `btol`.

## Performance Considerations
Plot generation is lightweight, but very large point counts may slow down GUI rendering. Limit `points` for interactive use.
