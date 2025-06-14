---
module_id: dbdrivers
category: data_handling
version: 1.0.0
last_updated: 2025-06-14
dependencies:
  - bbasic
mcp_compatible: true
tags:
  - database
  - sql
  - data-import
  - connectivity
  - odbc
  - mysql
  - postgresql
  - sqlite
---

# Database Connectivity Module (dbdrivers)

## Module Overview
The `dbdrivers` module provides comprehensive database connectivity for TOL, supporting multiple database systems including ODBC, MySQL, PostgreSQL, and SQLite. This module is essential for users working with persistent data storage, data warehouses, or integrating TOL with existing database infrastructure.

Key features include:
- Multi-database support with unified API
- Connection pooling and management
- SQL query execution and result handling
- Transaction support
- Metadata access and schema introspection

## Core Functions/Classes

### Handle DBOpen(Text dsn, Text user, Text pwd)
Opens a connection to the specified database using appropriate driver based on DSN format.

**Parameters**
- `dsn` (`Text`): data source name or connection string
- `user` (`Text`): username (may be ignored by SQLite)
- `pwd` (`Text`): password (may be ignored by SQLite)

**Returns**
- `Handle`: connection handle used for subsequent database operations

**Example**
```tol
// MySQL connection
Handle mysql_conn = DBOpen("mysql://localhost:3306/mydb", "user", "password");

// PostgreSQL connection
Handle pg_conn = DBOpen("postgresql://localhost:5432/mydb", "user", "password");

// SQLite connection (user/password ignored)
Handle sqlite_conn = DBOpen("sqlite:///path/to/database.db", "", "");

// ODBC connection
Handle odbc_conn = DBOpen("DSN=MyODBCSource", "user", "password");
```

**Errors**
- `ConnectionError` if the connection cannot be established
- `AuthenticationError` if credentials are invalid
- `DatabaseNotFoundError` if the specified database doesn't exist
- `DriverNotFoundError` if the required database driver is not available

### Void DBClose(Handle h)
Closes an open database connection and releases associated resources.

**Parameters**
- `h` (`Handle`): connection handle returned by `DBOpen`

**Example**
```tol
Handle conn = DBOpen("sqlite:///data.db", "", "");
// ... perform database operations ...
DBClose(conn);  // Always close connections when done
```

**Best Practices**
- Always close connections to prevent resource leaks
- Use try-finally blocks for guaranteed cleanup
- Consider connection pooling for high-frequency operations

### Set DBTable(Text sql)
Executes a SELECT query and returns the result as a structured set of rows.

**Parameters**
- `sql` (`Text`): SQL SELECT statement

**Returns**
- `Set`: set where each element represents a row with column values

**Example**
```tol
Handle conn = DBOpen("mysql://localhost/sales", "user", "pass");

// Simple query
Set customers = DBTable("SELECT id, name, email FROM customers");

// Query with conditions
Set recent_orders = DBTable("SELECT * FROM orders WHERE order_date >= '2023-01-01'");

// Aggregated data
Set monthly_sales = DBTable("
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') as month,
        SUM(amount) as total_sales
    FROM orders 
    GROUP BY month 
    ORDER BY month
");

DBClose(conn);
```

### Real DBExecQuery(Text sql)
Executes non-SELECT SQL statements (INSERT, UPDATE, DELETE, CREATE, etc.).

**Parameters**
- `sql` (`Text`): SQL statement to execute

**Returns**
- `Real`: number of affected rows (for DML statements)

**Example**
```tol
Handle conn = DBOpen("sqlite:///inventory.db", "", "");

// Insert new record
Real inserted = DBExecQuery("INSERT INTO products (name, price) VALUES ('Widget', 19.99)");

// Update existing records
Real updated = DBExecQuery("UPDATE products SET price = price * 1.1 WHERE category = 'electronics'");

// Delete records
Real deleted = DBExecQuery("DELETE FROM products WHERE discontinued = 1");

DBClose(conn);
```

### Set DBMetadata(Handle h, Text object_type)
Retrieves database metadata such as table names, column information, and schema details.

**Parameters**
- `h` (`Handle`): active database connection
- `object_type` (`Text`): type of metadata ("tables", "columns", "indexes", etc.)

**Returns**
- `Set`: metadata information as structured data

**Example**
```tol
Handle conn = DBOpen("postgresql://localhost/mydb", "user", "pass");

// Get list of all tables
Set tables = DBMetadata(conn, "tables");

// Get column information for a specific table
Set columns = DBMetadata(conn, "columns:customers");

// Get index information
Set indexes = DBMetadata(conn, "indexes:orders");

DBClose(conn);
```

### Handle DBBeginTransaction(Handle h)
Begins a database transaction for atomic operations.

**Parameters**
- `h` (`Handle`): database connection handle

**Returns**
- `Handle`: transaction handle

**Example**
```tol
Handle conn = DBOpen("mysql://localhost/accounting", "user", "pass");
Handle trans = DBBeginTransaction(conn);

// Perform multiple related operations
DBExecQuery("INSERT INTO accounts (name, balance) VALUES ('Account A', 1000)");
DBExecQuery("INSERT INTO transactions (account, amount) VALUES ('Account A', -100)");
DBExecQuery("UPDATE accounts SET balance = balance - 100 WHERE name = 'Account A'");

// Commit or rollback based on success
DBCommitTransaction(trans);
// or DBRollbackTransaction(trans);

DBClose(conn);
```

## Data Types

### Connection Types
- `Handle`: opaque connection handle for database operations
- `TransactionHandle`: handle for transaction management

### Result Types
- `Set`: query results as collections of rows
- `Row`: individual database record
- `Column`: column metadata and values

## Database-Specific Features

### SQLite
- Embedded database with no server required
- File-based storage with ACID properties
- Excellent for development and small to medium datasets
- Full SQL support with extensions

### MySQL
- High-performance relational database
- Excellent for web applications and data warehouses
- Support for replication and clustering
- Optimized for read-heavy workloads

### PostgreSQL
- Advanced open-source relational database
- Excellent for complex queries and data integrity
- Support for JSON, arrays, and custom data types
- Strong ACID compliance and concurrency

### ODBC
- Universal database connectivity
- Access to any ODBC-compliant database
- Useful for legacy systems and proprietary databases
- Platform-specific driver requirements

## Integration Notes
Database drivers integrate seamlessly with other TOL components:

- **Data Analysis**: Query results can be directly used with statistical functions
- **Time Series**: Load temporal data directly into Serie objects
- **Visualization**: Plot query results using TOL's plotting capabilities
- **Matrix Operations**: Convert query results to matrices for mathematical analysis

### Data Type Mapping
- SQL INTEGER → TOL Real
- SQL FLOAT/DOUBLE → TOL Real
- SQL VARCHAR/TEXT → TOL Text
- SQL DATE/TIMESTAMP → TOL Date
- SQL BOOLEAN → TOL Real (0/1)

## Performance Considerations

### Query Optimization
- Use appropriate indexes for frequently queried columns
- Limit result sets with WHERE clauses and LIMIT statements
- Consider server-side aggregation instead of client-side processing
- Use prepared statements for repeated queries

### Memory Management
- Large result sets may consume significant memory
- Consider pagination for very large datasets
- Use streaming for processing large amounts of data
- Close connections promptly to free resources

### Connection Management
- Reuse connections when possible
- Implement connection pooling for high-frequency operations
- Monitor connection limits and timeouts
- Handle connection failures gracefully

## Error Handling
Comprehensive error handling for database operations:
- Connection establishment and authentication errors
- SQL syntax and execution errors
- Transaction rollback and recovery
- Network and timeout errors
- Resource exhaustion and limits

## Security Considerations
- Use parameterized queries to prevent SQL injection
- Implement proper authentication and authorization
- Encrypt sensitive data in transit and at rest
- Audit database access and modifications
- Follow principle of least privilege for database users

## Common Use Cases

### Data Loading
```tol
// Load financial data for analysis
Handle conn = DBOpen("mysql://datawarehouse/finance", "analyst", "password");
Set stock_data = DBTable("
    SELECT date, symbol, close_price, volume 
    FROM stock_prices 
    WHERE date >= '2023-01-01' 
    ORDER BY date, symbol
");

// Convert to time series for analysis
Serie prices = ConvertToSerie(stock_data, "date", "close_price");
DBClose(conn);
```

### Data Export
```tol
// Export analysis results back to database
Handle conn = DBOpen("postgresql://results/analytics", "user", "pass");

// Create results table
DBExecQuery("CREATE TABLE IF NOT EXISTS forecast_results (
    model_id TEXT,
    forecast_date DATE,
    predicted_value REAL,
    confidence_interval REAL
)");

// Insert forecast results
Real inserted = DBExecQuery("INSERT INTO forecast_results VALUES (...)");
DBClose(conn);
```

## Related Modules
- **bstat**: Statistical analysis of database query results
- **btol**: Time series analysis with database-loaded temporal data
- **plotter**: Visualization of database query results
- **stdlib**: Utility functions for data transformation and formatting
