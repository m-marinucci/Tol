# dbdrivers Module

## Module Overview
`dbdrivers` contains the database connectors for TOL. It supports ODBC, MySQL, PostgreSQL, and SQLite. Users working with persistent data or integrating TOL with external databases rely on this module.

## Core Functions/Classes
### Handle DBOpen(Text dsn, Text user, Text pwd)
Opens a connection to the specified database.

*Parameters*
- `dsn` (`Text`): data source name or connection string
- `user` (`Text`): username (may be ignored by SQLite)
- `pwd` (`Text`): password

*Returns*
- `Handle`: connection handle used for subsequent calls

*Example*
```tol
Handle h = DBOpen("mydb", "user", "pass");
```

*Errors*
- `ConnectionError` if the connection cannot be established

### Void DBClose(Handle h)
Closes an open connection.

*Parameters*
- `h` (`Handle`): connection handle returned by `DBOpen`

### Set DBTable(Text sql)
Executes a SELECT query and returns the result as a set of rows.

*Parameters*
- `sql` (`Text`): SQL SELECT statement

*Returns*
- `Set`: set where each element is a row of column values

## Data Types
- `Handle`: opaque connection handle

## Integration Notes
Database drivers are dynamically loaded by the runtime. Combine with standard data types (`Matrix`, `Set`) to manipulate results. Results can be plotted or further analyzed.

## Performance Considerations
Fetching large result sets may be memory intensive. Use server-side cursors or limit queries when possible.
