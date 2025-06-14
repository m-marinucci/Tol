# GUI Application (tolbase)

## Module Overview
Tolbase also provides the main GUI application for TOL. This interactive environment combines an editor, object browser, and console. It is built on Tcl/Tk and is intended for users who prefer graphical interaction over the command line.

## Core Functions/Classes
### Command tolbase::start(Text[] args)
Launches the Tolbase application with optional command-line arguments.

*Parameters*
- `args` (`Text[]`): command-line options such as script paths or flags

### Command tolbase::openFile(Text path)
Opens a script in the integrated editor.

*Parameters*
- `path` (`Text`): file system path

### Command tolbase::eval(Text code)
Evaluates TOL code within the running Tolbase interpreter.

*Parameters*
- `code` (`Text`): code to execute

*Example*
```tcl
# From a Tcl shell
package require tolbase
::tolbase::start {}
```

## Data Types
- `Text`

## Integration Notes
The GUI application communicates with the TOL interpreter via the TolTcl bridge. It can load additional modules like plotting or database support.

## Performance Considerations
Launching the full GUI consumes more resources than the command-line interpreter. Heavy graphical sessions may require ample memory.
