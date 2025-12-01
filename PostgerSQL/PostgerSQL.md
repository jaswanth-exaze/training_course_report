### The Complete SQL Bootcamp: Go from Zero to Hero (PostgreSQL Focus)



## PostgreSQL and PgAdmin with Database Setup

This section covers setting up your PostgreSQL database environment.
PgAdmin is a popular graphical tool for managing PostgreSQL databases,
allowing you to interact with your data, run queries, and manage
database objects visually.

**1. Download pgAdmin**

- Go to the official download page: [pgAdmin
  Download](https://www.pgadmin.org/download/?utm_source=chatgpt.com)
  [pgAdmin+1](https://www.pgadmin.org/download/?utm_source=chatgpt.com)

- Under "Windows" (or your OS) pick the appropriate version. For
  modern Windows 10/11 you'll choose a 64-bit installer.
  [pgAdmin+1](https://www.pgadmin.org/download/pgadmin-4-windows/?utm_source=chatgpt.com)

- Download the .exe installer file.

**2. Run the Installer**

- Double click the downloaded pgAdmin4-...exe file.

- If Windows shows "Do you want to allow this app to make changes?"
  click Yes.

- The Setup Wizard will appear.

**3. Setup Wizard Details**

- You'll be asked to choose installation location; you can accept the
  default or pick your own.

- Choose components: typically, "pgAdmin 4" (desktop runtime), maybe
  "pgAdmin Web mode" if you want server mode.

- Accept the default unless you have a reason to change. (Some
  installers include parts of PostgreSQL if bundled.)
  [coding-bootcamp-netflix-data-sci-adv-prework.readthedocs-hosted.com+1](https://coding-bootcamp-netflix-data-sci-adv-prework.readthedocs-hosted.com/en/latest/modules/02-installing-pgAdmin-and-Postgres-Windows/?utm_source=chatgpt.com)

**4. Configure Password & Port (if required)**

- Some installers will ask for a master password for pgAdmin (so you
  will log in to pgAdmin GUI).
  [pgAdmin+1](https://www.pgadmin.org/docs/pgadmin4/9.5/getting_started.html?utm_source=chatgpt.com)

- Accept the default port (usually 5432 for PostgreSQL) unless you
  have port conflicts.
  [Neon](https://neon.com/postgresql/postgresql-getting-started/install-postgresql?utm_source=chatgpt.com)

**5. Complete Installation**

- Click Install and wait for the process to finish.

- Afterward, you might get a "Finish" screen; you can choose to launch
  pgAdmin immediately.

**6. First Launch & Set-Up**

- Launch pgAdmin from Start Menu (look for "pgAdmin 4").

- It may prompt you for the master password you set.

- Once inside, you'll see the interface and will need to register a
  server (i.e., connect to a PostgreSQL instance) before you can use
  it.

  - Right-click "Servers" → "Create" → "Server..."

  - Under Connection tab fill in: Host (e.g., localhost), Port
    (5432), Maintenance DB (postgres), Username (postgres), Password
    (the one you set when you installed PostgreSQL)
    [W3Schools+1](https://www.w3schools.com/postgresql/postgresql_pgadmin4.php?utm_source=chatgpt.com)

**Getting Started with pgAdmin**

**1. Launch & Login**

- Open pgAdmin from your start menu (Windows) or application launcher.

- You'll be prompted to enter the master password you set during
  installation.
  [W3Schools+1](https://www.w3schools.com/postgresql/postgresql_pgadmin4.php?utm_source=chatgpt.com)

- After login, you will see the Browser panel on the left and the main
  workspace on the right.

**2. Connect/Register a Server**

- In the left-Browser tree you'll see a node called Servers.

- Right-click on _Servers → Create → Server..._.

- In the dialog:

  - Under _General_, give the server a name (e.g., "Local
    PostgreSQL").

  - Under _Connection_, enter Host (e.g., localhost), Port
    (typically 5432), Maintenance database (postgres), Username &
    Password of your PostgreSQL server.
    [W3Schools+1](https://www.w3schools.com/postgresql/postgresql_pgadmin4.php?utm_source=chatgpt.com)

- Click Save. You'll now have the server listed and expandable to view
  its databases, schemas, tables, etc.

**🔧 Basic Tasks & Features**

**A. Exploring Objects**

- Expand the server: you'll see Databases → your_db → Schemas → public
  → Tables, etc.

- Right-click on objects (tables, schemas, functions) to perform
  actions like _View/Edit Data_, _Create_, _Properties_, _Delete_.

- Example: To view/edit table data: right-click the table → _View/Edit
  Data → All Rows_.
  [pgAdmin+1](https://www.pgadmin.org/docs/pgadmin4/development/editgrid.html?utm_source=chatgpt.com)

**B. Query Tool**

- To run SQL queries: right-click a database → _Query Tool_.

  - You'll see an editor where you can type SQL statements, and a
    "Play/Execute" button to run them.
    [W3Schools+1](https://www.w3schools.com/postgresql/postgresql_pgadmin4.php?utm_source=chatgpt.com)

- After execution, results appear in the _Data Output_ panel.

- Use this tool for your SELECT, INSERT, UPDATE, DELETE, etc.

**C. Creating Tables/Databases via UI**

- Right-click on Databases → _Create → Database..._ to make a new
  database.

- Similarly, navigate to Tables under a schema → right-click → _Create
  → Table..._ to define columns, data types, constraints. [SQL
  Shack+1](https://www.sqlshack.com/postgresql-tutorial-for-beginners/?utm_source=chatgpt.com)

- You can also alter tables, drop them, and manage structure via the
  GUI.

**D. Roles/Users & Permissions**

- Under the server node: find Login/Group Roles → right-click →
  _Create New Login Role_. You can define a username, password,
  privileges.
  [Atlassian](https://www.atlassian.com/data/admin/create-a-user-with-pgadmin?utm_source=chatgpt.com)

- This is useful when you want to create restricted users (read-only
  etc).

**E. View/Edit Data**

- As noted above, once you choose _View/Edit Data_, you get a grid
  where you can edit cell values (if table has a PK).
  [pgAdmin](https://www.pgadmin.org/docs/pgadmin4/development/editgrid.html?utm_source=chatgpt.com)

- Good for quick manual data updates rather than writing UPDATE
  statements.




## SQL Statement Fundamentals

This covers the basic building blocks of SQL queries.

**SELECT:** Retrieves data from a database table.

`SELECT column1, column2 FROM table_name;`

**DISTINCT:** Removes duplicate rows from the result set.

`SELECT DISTINCT column_name FROM table_name;`

**COUNT():** An aggregate function that returns the number of rows.

`SELECT COUNT(*) FROM table_name;`

**WHERE:** Filters records based on a specified condition.

`SELECT * FROM table_ name WHERE condition;`

**ORDER BY:** Sorts the result set in ascending or descending order.

`SELECT * FROM table_name ORDER BY column_name ASC;` (ASC is default,
DESC for descending).

**LIMIT:** Restricts the number of rows returned.

`SELECT * FROM table_name LIMIT 10;`

**BETWEEN:** Selects values within a given range.

`SELECT * FROM table_name WHERE column_name BETWEEN value1 AND value2;`

**IN:** Selects values from a list of specified values.

`SELECT * FROM table_name WHERE column_name IN (value1, value2, ...);`

**LIKE:** Searches for a specified pattern in a column. Uses wildcards:
`%` (any sequence of characters) and `_` (any single character).

`SELECT * FROM table_name WHERE column_name LIKE 'A%';` (Starts with A)

**ILIKE:** Case-insensitive version of LIKE (PostgreSQL specific).

`SELECT * FROM table_name WHERE column_name ILIKE 'a%';`



## Aggregation Functions, GROUP BY, HAVING

These are used to perform calculations on sets of rows and group them.

**Aggregation Functions:** Perform calculations across multiple rows.
Common functions include `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`.
`SELECT AVG(price) FROM products;`

**GROUP BY:** Groups rows that have the same values in specified columns
into summary rows.

`SELECT category, COUNT(*) FROM products GROUP BY category;`

**HAVING:** Filters groups based on a specified condition (used with
`GROUP BY`).

`SELECT category, COUNT(*) FROM products GROUP BY category HAVING COUNT(*) > 5;`



## JOINS

Used to combine rows from two or more tables based on a related column.

**Inner Join:** Returns rows when there is a match in both tables.

`SELECT * FROM orders INNER JOIN customers ON orders.customer_id = customers.id;`

**Outer Join (Left, Right, Full):** Returns rows even if there is no
match.

**Left Join:** Returns all rows from the left table, and the matched
rows from the right table.

`SELECT * FROM customers LEFT JOIN orders ON customers.id = orders.customer_id;`

**Right Join:** Returns all rows from the right table, and the matched
rows from the left table.

` SELECT * FROM customers RIGHT JOIN orders ON customers.id = ``orders.customer_id``; `

**Full Outer Join:** Returns rows when there is a match in one of the
tables.

**UNION:** Combines the result-set of two or more SELECT statements.
Removes duplicate rows.

**UNION ALL:** Combines the result-set of two or more SELECT statements.
Includes all rows, including duplicates.



## TIMESTAMPS

Working with date and time data types.

**Timestamp and Extract:** Storing and retrieving precise point-in-time
data. `EXTRACT(YEAR FROM timestamp_column)` retrieves the year part.

**TO_CHAR():** Formats a timestamp into a string representation.

` SELECT TO_CHAR(``created_at``, 'YYYY-MM-DD HH24:MI:SS') FROM my_table; `



## Mathematical Functions, String Functions

Built-in functions for manipulating numbers and text.

**Mathematical Functions:** `ABS()`, `ROUND()`, `CEIL()`, `FLOOR()`,
`POWER()`, etc.

`SELECT ROUND(price, 2) FROM products;`

**String Functions:** `LENGTH()`, `UPPER()`, `LOWER()`, `SUBSTRING()`,
`CONCAT()`,

`REPLACE()`. `SELECT CONCAT(first_name, ' ', last_name) FROM users;`



## SubQuery and Self Join

**SubQuery:** A query nested inside another SQL query. Often used in
`WHERE` clauses.

`SELECT * FROM products WHERE price > (SELECT AVG(price) FROM products);`

**Self Join:** A regular join, but the table is joined with itself.
Useful for querying hierarchical data or comparing rows within the same
table.

> `SELECT e1.name AS Employee, e2.name AS Manager FROM employees e1 JOIN employees e2 ON e1.manager_id = e2.employee_id;`



## DATATYPES

Different types of data that can be stored in columns (e.g., `INTEGER`,
`VARCHAR`, `TEXT`, `BOOLEAN`, `DATE`, `TIMESTAMP`).



## CONSTRAINTS

Rules enforced on data columns to ensure data integrity.

**UNIQUE:** Ensures all values in a column are different.

**NOT NULL:** Ensures a column cannot have a NULL value.

**PRIMARY KEY:** A column (or set of columns) that uniquely identifies
each row in a table.

**FOREIGN KEY:** A column (or set of columns) in one table that refers
to the PRIMARY KEY in another table, establishing a link between them.

**SERIAL:** PostgreSQL specific pseudo-type that creates an
auto-incrementing integer column (often used for Primary Keys).



## CREATING TABLES AND DATABASES

Data Definition Language (DDL) and Data Manipulation Language (DML)
commands.

**CREATE:** Used to create databases and tables.

`CREATE TABLE users (id SERIAL PRIMARY KEY, username VARCHAR(50) UNIQUE NOT NULL);`

**INSERT:** Adds new records to a table.

`INSERT INTO users (username) VALUES ('john_doe');`

**UPDATE:** Modifies existing records.

`UPDATE users SET username = 'johndoe_updated' WHERE id = 1;`

**DELETE:** Removes records from a table.

`DELETE FROM users WHERE id = 1;`

**ALTER:** Modifies an existing table structure (e.g., adding columns,
constraints).

`ALTER TABLE users ADD COLUMN email VARCHAR(100);`

**DROP:** Deletes databases, tables, or other database objects.

`DROP TABLE users;`

**CHECK:** Ensures that all values in a column satisfy a specific
condition.

`CREATE TABLE products (price DECIMAL CHECK (price > 0));`



## Conditional Expressions and Procedures

**CASE:** Allows you to write if-then-else logic in SQL.

`SELECT CASE WHEN status = 'A' THEN 'Active' ELSE 'Inactive' END FROM orders;`

**COALESCE():** Returns the first non-null expression.

`SELECT COALESCE(column1, column2, 'Default') FROM my_table;`

**CAST():** Converts one data type to another.

` SELECT CAST(``order_id`` AS VARCHAR) FROM orders; `



## VIEWS

Virtual tables based on the result-set of an SQL statement. They contain
rows and columns, just like a real table. The fields in a view are
fields from one or more real tables in the database.

**Creating Views:**
` CREATE VIEW ``active_users`` AS SELECT * FROM users WHERE status = 'Active'; `

**Querying Views:** `SELECT * FROM active_users;`
