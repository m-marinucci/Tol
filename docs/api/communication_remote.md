# Communication and Remote Access Module (`tolcomm`)

## Module Overview
Provides client and server components for executing TOL code across a network. Supports custom protocols and remote procedure calls.

## Core Functions/Classes
### `tolclient::connect(Text host, Integer port) -> Handle`
Opens a client connection to a remote TOL server.

### `tolclient::eval(Handle h, Text code) -> Text`
Sends code to be executed on the server and returns the textual result.

### `tolserver::start(Integer port)`
Starts a server listening for remote requests.

### `tolserver::stop()`
Stops the server.

## Data Types
Handles are opaque references to network connections.

## Integration Notes
Used to build distributed applications or to run heavy computations on separate machines. Can be combined with the Java API for remote execution from Java clients.

## Performance Considerations
Network latency dominates; keep payloads small. Connections should be reused rather than reopened frequently.
