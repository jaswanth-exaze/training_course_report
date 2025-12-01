# ALL BASIC QUERIERS (psql vs pgAdmin)

| ACTION                    | PostgreSQL (psql)                                                               | PostgreSQL (pgAdmin)                  |
| ------------------------- | ------------------------------------------------------------------------------- | ------------------------------------- |
| **Show all databases**    | `\l` or `\list`                                                                 | Expand **Servers → Databases**        |
| **Show current database** | `\c` or `SELECT current_database();`                                            | Run same query in Query Tool          |
| **Change database**       | `\c database_name`                                                              | Right-click database → **Query Tool** |
| **Show all tables**       | `\dt`                                                                           | Expand **Schemas → public → Tables**  |
| **List all tables (SQL)** | `SELECT table_name FROM information_schema.tables WHERE table_schema='public';` | Run same query in Query Tool          |
| **Describe a table**      | `\d table_name`                                                                 | Right-click table → **Properties**    |
| **Quit shell**            | `\q`                                                                            | Close Query Tool                      |
| **Clear screen**          | `\! cls` (Windows) or `\! clear` (Linux/Mac)                                    | Not needed (GUI)                      |

### SCHEMA OPERATIONS

| ACTION                              | PostgreSQL (psql)                  | PostgreSQL (pgAdmin)                                                                   |
| ----------------------------------- | ---------------------------------- | -------------------------------------------------------------------------------------- |
| **Create new schema**               | `CREATE SCHEMA schema_name;`       | Expand database → Schemas → Right-click **Create → Schema**                            |
| **Change schema (set search_path)** | `SET search_path TO schema_name;`  | Not direct. You choose schema while creating tables. Query Tool uses public by default |
| **Show all schemas**                | `\dn`                              | Expand database → Schemas                                                              |
| **Delete/Drop schema**              | `DROP SCHEMA schema_name;`         | Right-click schema → **Delete/Drop**                                                   |
| **Delete schema with all tables**   | `DROP SCHEMA schema_name CASCADE;` | Right-click schema → Delete → Confirm (cascade)                                        |

### TABLE OPERATIONS

| ACTION                             | PostgreSQL (psql)                | PostgreSQL (pgAdmin)                                             |
| ---------------------------------- | -------------------------------- | ---------------------------------------------------------------- |
| **Delete table**                   | `DROP TABLE table_name;`         | Right-click table → **Delete/Drop**                              |
| **Delete table with dependencies** | `DROP TABLE table_name CASCADE;` | Not shown by default; pgAdmin handles dependencies automatically |

### DATABASE OPERATIONS

| ACTION                       | PostgreSQL (psql)                                              | PostgreSQL (pgAdmin)                                               |
| ---------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------ |
| **Delete database**          | `DROP DATABASE database_name;` _(cannot drop while connected)_ | Right-click database → **Delete/Drop** (You must disconnect first) |
| **Disconnect from database** | `\c postgres` or connect to another DB                         | Right-click **Disconnect Database**                                |
