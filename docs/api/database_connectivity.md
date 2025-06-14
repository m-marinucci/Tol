# Database Connectivity Module (`dbdrivers`)

## Module Overview
Provides drivers for interacting with relational databases through ODBC, MySQL, PostgreSQL and SQLite. Intended for users needing to load or store data persistently.

## Core Functions/Classes
### `DBOpen(Text dsn, Text user, Text pwd) -> Handle`
Opens a connection to a database.
- **Parameters**
  - `dsn` – data source name or file path
  - `user` – user name
  - `pwd` – password
- **Returns**: connection handle
- **Errors**: raises `DBError` if connection fails.
- **Example**
```tol
Handle h = DBOpen("mydb", "user", "secret");
```

### `DBExecQuery(Handle h, Text sql) -> Integer`
Executes a statement that does not return rows.

### `DBTable(Handle h, Text sql) -> Matrix`
Executes a query and returns the result table.

### `DBClose(Handle h)`
Closes the connection.

## Data Types
- `Handle` – opaque connection context
- result matrices contain rows as sets of basic types

## Integration Notes
Standard library modules can load these drivers dynamically. They rely on external DB client libraries.

## Performance Considerations
Fetching large result sets may require significant memory. Drivers stream rows when possible to reduce usage.
