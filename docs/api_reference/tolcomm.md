# tolcomm Module

## Module Overview
`tolcomm` implements client/server communication for TOL. It defines protocols for remote execution, allowing one TOL process to evaluate code on another host. Useful for distributed computation or interactive sessions across machines.

## Core Functions/Classes
### Command tolserver::start(Real port)
Starts a server that listens for client requests.

*Parameters*
- `port` (`Real`): TCP port number

### Handle tolclient::connect(Text host, Real port)
Connects to a TOL server.

*Parameters*
- `host` (`Text`): server hostname
- `port` (`Real`): TCP port

*Returns*
- `Handle`: connection handle

### Text tolclient::eval(Handle h, Text code)
Sends code to be executed on the server and returns the result as text.

*Parameters*
- `h` (`Handle`): connection handle
- `code` (`Text`): code to execute remotely

## Data Types
- `Handle`
- `Text`

## Integration Notes
The communication layer relies on Tcl's socket facilities and can be used together with GUI or headless TOL instances. Authentication may need to be implemented externally.

## Performance Considerations
Network latency and bandwidth affect remote execution speed. Keep payloads small and manage connections carefully.
