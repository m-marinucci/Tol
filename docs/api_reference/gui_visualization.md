# GUI Visualization (tolbase)

## Module Overview
The GUI visualization utilities provided by **tolbase** build upon Tcl/Tk and BLT widgets. They allow interactive plots of sets and series using commands like `SetGraph` and `SerGraph`.

## Core Functions/Classes
### Void SetGraph(Set data, Text title)
Displays a graph from a two-column set of x/y values.

*Parameters*
- `data` (`Set`): table where first column is x and second column is y
- `title` (`Text`): window title

### Void SerGraph(Serie s, Text title)
Plots a time series using date or time information.

*Parameters*
- `s` (`Serie`): input series
- `title` (`Text`): window title

*Example*
```tol
SerGraph(mySerie, "Daily Prices");
```

## Data Types
- `Set`
- `Serie`
- `Text`

## Integration Notes
These visualization commands are typically invoked from Tolbase's GUI application but can also be called from standard TOL scripts if the Tcl/Tk environment is available.

## Performance Considerations
Rendering very large data sets may be slow; consider downsampling before plotting.
