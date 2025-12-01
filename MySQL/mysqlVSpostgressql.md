# PostgreSQL vs MySQL 

## 1️⃣ OVERVIEW
| Feature | PostgreSQL | MySQL |
|--------|------------|--------|
| Type | Object-Relational DBMS | Relational DBMS |
| Focus | Complex queries, standards, data integrity | Speed, simplicity, web apps |
| Best For | Enterprise, analytics | Websites, CMS, eCommerce |

---

## 2️⃣ DATA INTEGRITY
| Feature | PostgreSQL | MySQL |
|--------|------------|--------|
| ACID compliance | ✔ Fully | ✔ Mostly (depends on engine) |
| CHECK constraint | ✔ Supported | ⚠️ Mostly ignored before MySQL 8 |
| Strict validation | Very strict | More lenient |
| Foreign key rules | Very strong | Good but less strict |

---

## 3️⃣ PERFORMANCE
| Area | PostgreSQL | MySQL |
|------|------------|--------|
| Read performance | Good | ✔ Excellent |
| Write performance | Slower | Faster |
| Complex queries | ✔ Best | Good but limited |
| Joins / Subqueries | ✔ Very strong | Good |

---

## 4️⃣ SQL FEATURES
| Feature | PostgreSQL | MySQL |
|---------|------------|--------|
| Window functions | ✔ Full | ✔ Supported |
| CTEs (WITH queries) | ✔ Advanced | ✔ Supported |
| FULL OUTER JOIN | ✔ Yes | ❌ No |
| Advanced datatypes | ✔ JSONB, Arrays, HSTORE | ⚠️ Limited |
| Stored procedures | ✔ Strong | ✔ Supported |

---

## 5️⃣ JSON SUPPORT
| Feature | PostgreSQL | MySQL |
|---------|------------|--------|
| JSONB | ✔ Yes | ❌ No |
| JSON indexing | ✔ Fast, advanced | Limited |
| Querying JSON | ✔ Powerful operators | Basic |

---

## 6️⃣ EXTENSIBILITY
| Feature | PostgreSQL | MySQL |
|---------|------------|--------|
| Custom Data Types | ✔ Yes | ❌ No |
| Custom Functions | ✔ Multiple languages | Limited |
| Extensions | ✔ Massive ecosystem | Very few |

---

## 7️⃣ INDEXING SUPPORT
| Index Type | PostgreSQL | MySQL |
|------------|------------|--------|
| B-Tree | ✔ | ✔ |
| Hash | ✔ | ✔ |
| Partial Index | ✔ Yes | ❌ No |
| Expression Index | ✔ Yes | ❌ No |
| GIN / GiST / RUM | ✔ Advanced | ❌ No |

# PostgreSQL vs MySQL — Syntax & Feature Differences (Complete Summary)

## 1️⃣ SQL SYNTAX THAT IS SAME IN BOTH
Most SQL commands work identically in MySQL & PostgreSQL:

### Common SQL
```sql
SELECT * FROM table;
INSERT INTO table (col) VALUES (...);
UPDATE table SET col = value WHERE id = 1;
DELETE FROM table WHERE id = 1;
```

### WHERE / ORDER BY / LIMIT
```sql
SELECT * FROM table WHERE age > 20 ORDER BY age DESC LIMIT 5;
```

### JOINS
```sql
SELECT * FROM a INNER JOIN b ON a.id = b.aid;
SELECT * FROM a LEFT JOIN b ON a.id = b.aid;
SELECT * FROM a RIGHT JOIN b ON a.id = b.aid;
```

### GROUP BY / HAVING
```sql
SELECT dept, COUNT(*) FROM emp GROUP BY dept HAVING COUNT(*) > 5;
```

➡️ **80% SQL syntax is same.**

---

## 2️⃣ SYNTAX DIFFERENCES BETWEEN POSTGRESQL & MYSQL

### 🔹 Current Database
PostgreSQL:
```sql
SELECT current_database();
```
MySQL:
```sql
SELECT DATABASE();
```

### 🔹 Change Database
PostgreSQL:
```sql
\c database_name     -- psql only
```
MySQL:
```sql
USE database_name;
```

### 🔹 Auto Increment Column
PostgreSQL:
```sql
id SERIAL PRIMARY KEY;
```
MySQL:
```sql
id INT AUTO_INCREMENT PRIMARY KEY;
```

### 🔹 String Concatenation
PostgreSQL:
```sql
SELECT 'Hi ' || 'There';
```
MySQL:
```sql
SELECT CONCAT('Hi ', 'There');
```

### 🔹 Case-Insensitive LIKE
PostgreSQL:
```sql
SELECT * FROM users WHERE name ILIKE 'a%';
```
MySQL:
❌ No ILIKE (but LIKE is case-insensitive by default).

### 🔹 LIMIT
PostgreSQL:
```sql
LIMIT 10 OFFSET 5;
```
MySQL (supports both):
```sql
LIMIT 5, 10;    -- offset, limit
LIMIT 10 OFFSET 5;
```

### 🔹 Boolean Type
PostgreSQL → Real BOOLEAN  
MySQL → TINYINT(1) used internally

---

## 3️⃣ FEATURES SUPPORTED IN POSTGRESQL BUT NOT IN MYSQL

### ✔ FULL OUTER JOIN
```sql
SELECT * FROM a FULL OUTER JOIN b USING(id);
```
MySQL: ❌ No support (must simulate with UNION)

---

### ✔ JSONB (Advanced JSON Storage)
PostgreSQL:
```sql
SELECT data->>'name' FROM users;
```
MySQL: Only basic JSON, no JSONB or advanced indexing.

---

### ✔ Arrays
```sql
tags TEXT[];
```
MySQL: ❌ No array datatype.

---

### ✔ Custom Data Types
```sql
CREATE TYPE mood AS ENUM ('happy','sad','ok');
```
MySQL: ENUM supported but no custom composite types.

---

### ✔ Expression Index
```sql
CREATE INDEX idx_lower_email ON users (lower(email));
```
MySQL: ❌ Cannot index expressions.

---

### ✔ Advanced Extensions (PostGIS, TimescaleDB, etc.)
MySQL: ❌ No comparable extension system.

---

## 4️⃣ FEATURES SUPPORTED IN MYSQL BUT NOT IN POSTGRESQL

### ✔ LIMIT offset,count
```sql
SELECT * FROM emp LIMIT 5, 10;
```
PostgreSQL: ❌ Not supported (use LIMIT + OFFSET)

---

### ✔ Multi-table UPDATE
MySQL:
```sql
UPDATE a JOIN b ON a.id=b.id SET a.name='X';
```
PostgreSQL: ❌ Not supported (must use CTE)

---

### ✔ REPLACE INTO (Upsert)
MySQL:
```sql
REPLACE INTO users VALUES (...);
```
PostgreSQL: ❌ No direct support  
Use:
```sql
INSERT ... ON CONFLICT DO UPDATE;
```

---

### ✔ Multiple Storage Engines
- InnoDB  
- MyISAM  
- MEMORY  
- ARCHIVE  

PostgreSQL: ❌ Single storage engine (but very powerful).

---

## 5️⃣ QUICK FINAL SUMMARY TABLE

| Feature / Behavior | PostgreSQL | MySQL |
|--------------------|------------|--------|
| FULL OUTER JOIN | ✔ Yes | ❌ No |
| JSONB | ✔ Advanced | Basic |
| Arrays | ✔ Yes | ❌ No |
| Custom types | ✔ Yes | ❌ No |
| Expression index | ✔ Yes | ❌ No |
| Multi-table UPDATE | ❌ No | ✔ Yes |
| REPLACE INTO | ❌ No | ✔ Yes |
| LIMIT offset,count | ❌ No | ✔ Yes |
| Data integrity | ✔ Strong | ⚠️ Less strict |
| Simple read speed | Good | ✔ Faster |
| Complex queries | ✔ Best | Good |

# PostgreSQL vs MySQL — Functions, Triggers, Window Functions (Comparison + Examples)

## 1️⃣ STORED FUNCTIONS

### PostgreSQL Function Example
```sql
CREATE OR REPLACE FUNCTION add_numbers(a INT, b INT)
RETURNS INT AS $$
BEGIN
    RETURN a + b;
END;
$$ LANGUAGE plpgsql;

SELECT add_numbers(5, 10);
```

### MySQL Function Example
```sql
CREATE FUNCTION add_numbers(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END;

SELECT add_numbers(5, 10);
```

### Key Differences
| Feature | PostgreSQL | MySQL |
|--------|------------|--------|
| Function Language | PL/pgSQL + others (Python, JS, C) | SQL/PSM only |
| RETURN mandatory | ✔ Yes | ✔ Yes |
| Overloading | ✔ Supported | ❌ No |
| Multiple languages | ✔ Yes | ❌ No |

---

## 2️⃣ TRIGGERS

### PostgreSQL Trigger Example
```sql
CREATE TABLE logs(id SERIAL, message TEXT, created_at TIMESTAMP);

CREATE OR REPLACE FUNCTION log_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO logs(message, created_at)
    VALUES ('Row inserted into users', NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION log_insert();
```

### MySQL Trigger Example
```sql
CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
INSERT INTO logs(message, created_at)
VALUES ('Row inserted into users', NOW());
```

### Key Differences
| Feature | PostgreSQL | MySQL |
|--------|------------|--------|
| Trigger function required | ✔ Yes (EXECUTE FUNCTION) | ❌ No (direct SQL allowed) |
| BEFORE / AFTER | ✔ Both | ✔ Both |
| INSTEAD OF triggers | ✔ Yes | ❌ No |
| Multiple triggers per event | ✔ Supported | ✔ Supported |

---

## 3️⃣ WINDOW FUNCTIONS (VERY IMPORTANT)

Window functions allow operations **on a set of rows without grouping them**.

### PostgreSQL Window Example
```sql
SELECT name, salary,
       RANK() OVER (ORDER BY salary DESC) AS sal_rank
FROM employees;
```

### MySQL Window Example
(Same syntax — supported since MySQL 8)
```sql
SELECT name, salary,
       RANK() OVER (ORDER BY salary DESC) AS sal_rank
FROM employees;
```

### Common Window Functions
```sql
ROW_NUMBER() OVER (...)
RANK() OVER (...)
DENSE_RANK() OVER (...)
LEAD() / LAG()
SUM() OVER (...)
AVG() OVER (...)
```

### Feature Differences
| Feature | PostgreSQL | MySQL |
|--------|------------|--------|
| All ANSI window functions | ✔ Full support | ✔ Supported (since 8.0) |
| Frame clauses | ✔ Advanced | ✔ Supported but fewer optimizations |
| Performance | Strong | Good but slower for large windows |

---

## 4️⃣ CHECKING FEATURES SUPPORT

### ✔ Check PostgreSQL version + feature
```sql
SELECT version();
```

### ✔ Check MySQL version + feature
```sql
SELECT VERSION();
```

### ✔ Does DB support window functions?
PostgreSQL → YES  
MySQL → YES (8.0+)  
MySQL 5.x → ❌ NO window functions

---

## 5️⃣ SUMMARY TABLE

| Feature | PostgreSQL | MySQL |
|--------|------------|--------|
| Functions | ✔ Advanced (PL/pgSQL, multiple languages) | ✔ Supported (basic) |
| Function overloading | ✔ Yes | ❌ No |
| Triggers | ✔ Very powerful | ✔ Supported |
| Trigger functions | ✔ Required | ❌ Not required |
| INSTEAD OF triggers | ✔ Supported | ❌ No |
| Window functions | ✔ Full, strong | ✔ Supported (8+) |
| JSON with window ops | ✔ Very good | ⚠️ Limited |
| Procedural language | ✔ PL/pgSQL | SQL/PSM only |
