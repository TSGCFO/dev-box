# PostgreSQL Configuration for Development

# PostgreSQL Connection Info
- Host: localhost
- Port: 5432
- Default Database: postgres
- Default User: postgres
- Default Password: password (Change for production!)

## Common Connection Strings

### Node.js/JavaScript
```js
const connectionString = 'postgresql://postgres:password@localhost:5432/postgres';
```

### Python
```python
connection_string = "postgresql://postgres:password@localhost:5432/postgres"
```

### .NET
```csharp
var connectionString = "Host=localhost;Port=5432;Database=postgres;Username=postgres;Password=password";
```

## PostgreSQL Configuration
The following settings are recommended for development:

```
# postgresql.conf
listen_addresses = '*'
max_connections = 100
shared_buffers = 128MB
work_mem = 4MB
max_wal_size = 1GB
log_statement = 'all'
```

## Common Commands

### Create a new database
```sql
CREATE DATABASE mydb;
```

### Create a new user
```sql
CREATE USER myuser WITH ENCRYPTED PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;
```

### Backup a database
```bash
pg_dump -U postgres -F c -b -v -f backup.dump mydatabase
```

### Restore a database
```bash
pg_restore -U postgres -d mydatabase backup.dump
```