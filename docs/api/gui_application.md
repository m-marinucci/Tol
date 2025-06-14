# GUI Application Module (`tolbase`)

## Module Overview
Tolbase is the graphical front end built with Tcl/Tk. It includes an editor, object browser and interactive console for running TOL code. Aimed at end users wanting a complete IDE.

## Core Functions/Classes
### `Tolbase::Start()`
Initializes the Tcl/Tk environment and launches the main window.

### `Tolbase::OpenFile(Text path)`
Opens a `.tol` script in the editor.

### `Tolbase::Eval(Text code)`
Evaluates code in the embedded interpreter.

## Data Types
Uses standard Tcl/Tk widgets to manipulate text and windows.

## Integration Notes
The GUI can load plotting widgets from `tolbase` and invokes the core TOL interpreter underneath.

## Performance Considerations
Startup time depends on Tcl/Tk initialization. Heavy scripts run at native interpreter speed once loaded.
