### The Ultimate MySQL Bootcamp: Go from SQL Beginner to Expert (MySQL Focus)

﻿

## INTRODUCTION, DATABASE, SQL vs MYSQL, MySQL and Workbench Installation

**✅ What is a Database?**

A **database** is a **collection of organized data** that can be stored,
accessed, and managed easily.

**📌 Example**

-   Contacts in your phone (Name, Phone Number, Email) = A database

-   Student records in a school system = A database

-   Amazon Order History = A database

**✅ What is SQL?**

SQL = **Structured Query Language**

It is a **language** used to **communicate** with databases.

**✅ What is MySQL?**

MySQL is a **Database Management System (DBMS)** that **uses SQL** to
interact with data.

✔ Free & Open Source\
✔ Widely used in web applications\
✔ Stores data in tables\
✔ SQL commands are executed inside MySQL

**✅ Relationship**

  -----------------------------------------------------------------------
  **Term**   **Category**     **Purpose**
  ---------- ---------------- -------------------------------------------
  Database   Storage          Holds data

  SQL        Language         Query & manage data

  MySQL      DBMS Software    Stores, organizes, secures data using SQL
  -----------------------------------------------------------------------

**Step-by‐Step Installation (Windows)**

**1. Download MySQL Server + Installer**

-   Go to the official MySQL downloads page: [MySQL
    Downloads](https://www.mysql.com/downloads/?utm_source=chatgpt.com)

-   Under "MySQL Community Server" pick your OS (Windows) and version.
    [MySQL](https://dev.mysql.com/downloads/mysql/8.0.html?utm_source=chatgpt.com)

-   Download the "MySQL Installer" for Windows (usually named something
    like mysql-installer-web-community-x.x.x.msi).
    [MySQL+1](https://dev.mysql.com/downloads/installer/?utm_source=chatgpt.com)

**2. Run the Installer**

-   Locate the downloaded .msi file and double-click it.

-   If Windows prompts "Do you want to allow this app to make changes?"
    click **Yes**.

-   The MySQL Setup Wizard opens.

**3. Choose Setup Type**

-   In the wizard you'll see options like **Developer Default**,
    **Server only**, **Full**, **Custom**.
    [GeeksforGeeks+1](https://www.geeksforgeeks.org/mysql/how-to-install-mysql-in-windows/?utm_source=chatgpt.com)

-   For most beginners: choose **Developer Default** (this installs
    MySQL Server, Workbench, and sample models).

-   Click **Next**.

**4. Check & Resolve Requirements**

-   The installer may check for required prerequisites (e.g., Visual C++
    Redistributable).

-   If some components are missing, the installer will prompt to
    download/install them.
    [GeeksforGeeks+1](https://www.geeksforgeeks.org/mysql/how-to-install-mysql-in-windows/?utm_source=chatgpt.com)

**5. Install MySQL Server**

-   Choose configuration type: Standalone MySQL Server, configure as
    Windows service etc.

-   Set **root password** (very important).

-   Optionally add user accounts.

-   Select port (default 3306) unless you have reason to change.

-   Click **Next** and then **Execute** to install.

**6. Download & Install Workbench (if not included)**

-   If your installer option included Workbench, it should install
    automatically.

-   If not, you can download Workbench separately: go to MySQL Workbench
    Download
    [cphapps.temple.edu+1](https://cphapps.temple.edu/wiki/it/student/mysql_instructions/mysql_workbench_installation?utm_source=chatgpt.com)

-   Run the installer for Workbench and follow prompts (Choose
    "Complete" or "Custom" set-up). [Oracle
    Documentation+1](https://docs.oracle.com/cd/E19078-01/mysql/mysql-workbench/wb-installing.html?utm_source=chatgpt.com)

**7. Finish & Configure**

-   After installation, the services should start automatically (for
    Windows).
    [MySQL+1](https://dev.mysql.com/doc/mysql-getting-started/en/?utm_source=chatgpt.com)

-   Launch MySQL Workbench.

-   In Workbench: create a new connection to your local server: usually
    hostname = localhost, port = 3306, user = root, password = the one
    you set.

-   Test connection, save it.

﻿

## Creating DATABASES and TABLES

**CREATE:** `CREATE DATABASE ``mydatabase;`,

`CREATE TABLE ``tablename`` (...);`

**SHOW:** `SHOW ``DATABASES;`,

`SHOW TABLES;`

**USE:** `USE ``mydatabas``e``;` (to select a database to work with)

**DROP:** `DROP DATABASE ``mydatabase``;` ,

> `DROP TABLE ``tablename``;`

﻿

## INSERTING DATA

**INSERT:**

`INSERT INTO ``tablename`` (column1, column2) VALUES (value1, value2);`

**Multi Inserts:**

`INSERT INTO ``tablename`` (column1, column2) VALUES (value1, value2), (value3, value4);`

**NOT NULL:** Constraint ensuring a column must have a value.

**DEFAULT:** Assigns a default value to a column if no value is
specified during insertion. `price DECIMAL DEFAULT 0.00`

**PRIMARY KEY:** Uniquely identifies each record.

**AUTO_INCREMENT:** Automatically assigns a unique sequential number to
a column (usually PK) when a new row is inserted.
`id INT AUTO_INCREMENT PRIMARY KEY`

﻿

## CRUD OPERATIONS

Core operations for data management.

**CREATE:** Used to create databases and tables.

`CREATE TABLE users (id SERIAL PRIMARY KEY, username VARCHAR(50) UNIQUE NOT NULL);`

**INSERT:** Adds new records to a table.

`INSERT INTO users (username) VALUES ('``john_doe``');`

**UPDATE:** Modifies existing records.

`UPDATE users SET username = '``johndoe_updated``' WHERE id = 1;`

**DELETE:** Removes records from a table.

`DELETE FROM users WHERE id = 1;`

**SELECT:** Retrieves data from a database table.

`SELECT column1, column2 FROM table_name;`

**WHERE:** Filters records based on a specified condition.

`SELECT * FROM table_ name WHERE condition;`

**Aliases:** Temporary names for tables or columns to make queries more
readable.

`SELECT c.name AS ``customer_name`` FROM customers c WHERE c.id = 1;`

**UPDATE:**

`UPDATE ``tablename`` SET column1 = value1 WHERE condition;`

**DELETE:**

`DELETE FROM ``tablename`` WHERE condition;`

﻿

## STRING FUNCTIONS

**CONCAT():** Joins two or more strings.

`SELECT CONCAT(``first_name``, ' ', ``last_name``) AS full_name FROM users;`

**SUBSTRING():** Extracts a part of a string.

`SELECT SUBSTRING(description, 1, 10) FROM products;` (Starts at
position 1, 10 characters long)

**REPLACE():** Replaces all occurrences of a substring within a string.

`SELECT REPLACE(email, '@example.com', '@newdomain.com') FROM users;`

**REVERSE():** Reverses a string.

`SELECT REVERSE('hello');` -\> \'olleh\'

**CHAR_LENGTH():** Returns the length of a string in characters.

**UPPER():** Converts string to uppercase.

**LOWER():** Converts string to lowercase.

﻿

## DISTINCT, ORDER BY, LIMIT, LIKE, WILDCARDS

Basic query modifiers.

**DISTINCT:** Removes duplicate rows.

**ORDER BY:** Sorts results.

**LIMIT:** Restricts number of rows.

**LIKE:** Pattern matching.

**Wildcards:** `%` (any sequence of characters), `_` (any single
character). `SELECT * FROM customers WHERE name LIKE 'J%';`

﻿

## AGGREGATE FUNCTIONS

**COUNT(), MIN(), MAX(), SUM(), AVG():** Perform calculations on data.
`SELECT SUM(quantity) FROM order_items;`

﻿

## GROUP BY, HAVING, WITH ROLLUP

**✅ Why do we need GROUP BY?**

**When we want to group rows based on a column and then apply
aggregation functions (like SUM, COUNT, AVG...), we use GROUP BY.**

**📌 GROUP BY *always* works with aggregation.**

**✅ Example Table: sales**

  -------------------------------------------------------------------------
  **id**   **product**            **region**         **amount**
  -------- ---------------------- ------------------ ----------------------
  **1**    **Mobile**             **East**           **20000**

  **2**    **Laptop**             **West**           **45000**

  **3**    **Mobile**             **West**           **30000**

  **4**    **Laptop**             **East**           **50000**

  **5**    **Mobile**             **East**           **15000**
  -------------------------------------------------------------------------

**✅ GROUP BY Example 1**

**Find total sales for each product:**

SELECT product, SUM(amount) AS total_sales FROM sales GROUP BY product;

**✅ Result:**

  -----------------------------------------------------------------------
  **product**                    **total_sales**
  ------------------------------ ----------------------------------------
  **Mobile**                     **65000**

  **Laptop**                     **95000**
  -----------------------------------------------------------------------

**✅ GROUP BY Example 2**

**Count how many sales per region:**

SELECT region, COUNT(\*) AS total_sales_count FROM sales GROUP BY
region;

**✅ Result:**

  -----------------------------------------------------------------------
  **region**          **total_sales_count**
  ------------------- ---------------------------------------------------
  **East**            **3**

  **West**            **2**
  -----------------------------------------------------------------------

**✅ Why do we need HAVING?**

**HAVING works like WHERE, but for aggregated results.**

**📌 WHERE filters rows before grouping\
📌 HAVING filters groups after aggregation**

**❌ Incorrect usage example:**

SELECT product, SUM(amount)

FROM sales

WHERE SUM(amount) \> 60000; \-- ❌ Cannot use aggregate with WHERE

GROUP BY product;

**✅ Correct usage with HAVING:**

**Find products where total sales amount is more than 60,000:**

SELECT product, SUM(amount) AS total_sales

FROM sales

GROUP BY product

HAVING SUM(amount) \> 60000;

**✅ Result:**

  -----------------------------------------------------------------------
  **product**                    **total_sales**
  ------------------------------ ----------------------------------------
  **Laptop**                     **95000**

  -----------------------------------------------------------------------

**✅ GROUP BY + WHERE + HAVING Together**

**📌 WHERE → filters rows\
📌 GROUP BY → groups results\
📌 HAVING → filters grouped results**

**Example:\
Find total sales per region only for Mobiles and show groups where total
\> 20000:**

SELECT region, SUM(amount) AS total_sales

FROM sales

WHERE product = \'Mobile\'

GROUP BY region

HAVING SUM(amount) \> 20000;

**✅ Explanation:**

-   **WHERE → Only Mobile rows taken**

-   **GROUP → Group by region**

-   **HAVING → Only totals \> 20000 shown**

**✅ Summary Table**

  ------------------------------------------------------------------------
  Feature   Used For               Works On     Example
  --------- ---------------------- ------------ --------------------------
  WHERE     Filter rows before     Individual   WHERE product = \'Mobile\'
            grouping               rows         

  GROUP BY  Group data             Sets of rows GROUP BY product

  HAVING    Filter aggregated data Groups       HAVING SUM(amount) \>
                                                50000
  ------------------------------------------------------------------------

**WITH ROLLUP:** Adds an extra row to the result set that represents a
grand total (or summary) for the grouped data.

`SELECT country, SUM(sales) FROM ``sales_data`` GROUP BY country WITH ROLLUP;`

﻿

## DATATYPES {#datatypes-2}

**✅ MySQL Data Types --- Quick Summary with Bytes**

  -------------------------------------------------------------------------------
  **Category**   **Data Type**      **Storage   **Notes**
                                    Size**      
  -------------- ------------------ ----------- ---------------------------------
  🔢 Numeric     **TINYINT**        1 byte      Small values (Range: -128 to 127
                                                or 0--255)

                 **INT**            4 bytes     Most commonly used integer type

                 **BIGINT**         8 bytes     Very large integers (like phone
                                                numbers)

                 **DECIMAL(M,D)**   Varies      Exact math → For money values

                 **FLOAT**          4 bytes     Approx decimal (less accurate)

                 **DOUBLE**         8 bytes     Larger approx decimal values

  🔤 String      **CHAR(n)**        n bytes     Fixed length (pads with spaces)

                 **VARCHAR(n)**     n + 1 or 2  Variable length (extra 1--2 bytes
                                    bytes       for length storage)

  📅 Date & Time **DATE**           3 bytes     Stores only YYYY-MM-DD

                 **TIME**           3 bytes     HH:MM:SS

                 **DATETIME**       8 bytes     Full timestamp (date + time)

                 **TIMESTAMP**      4 bytes     Auto-update/logging,
                                                timezone-aware
  -------------------------------------------------------------------------------

﻿

## WORKING WITH DATES

**CURRENT_DATE () / CURDATE (), CURRENT_TIME ()/CURTIME/NOW ():**
Functions to get the current date/time.

`SELECT NOW();`

**DATE FUNCTIONS:** Functions for date manipulation (e.g., `DATE_ADD()`,
`DATEDIFF()`).

**TIME FUNCTIONS:** Functions for time manipulation.

**FORMATTING DATES:** Using functions like `DATE_FORMAT()`.

`SELECT DATE_FORMAT(``order_date``, '%Y-%m-%d') FROM orders;`

**DATE MATH:** Performing arithmetic on dates.

**TIMESTAMPS:** Data type for storing date and time values.

﻿

## COMPARISION AND LOGICAL OPERATORS

**Comparison:** `=`, `<>` or `!=`, `>`, `<`, `<=`, `>=`.

**Logical:** `AND`, `OR`, `IN`, `CASE`, `NOT NULL`, `IS NULL`,
`BETWEEN`.

﻿

## CONSTRAINTS & ALTER

**UNIQUE:** Ensures unique values.

**CHECK:** Ensures values meet a condition.

**NAMED CONSTRAINTS:** Defining constraints with specific names for
easier management.

**ALTER TABLE:** Modifying table structure.

**Adding, Renaming, Dropping, Modifying Columns:**

> `ALTER TABLE products ADD COLUMN description ``TEXT;`,
>
> `ALTER TABLE products RENAME COLUMN description TO ``product_``description``;`,
>
> `ALTER TABLE products MODIFY COLUMN price DECIMAL(10, 2);`

**Alter Constraints:** Adding or dropping constraints from existing
tables.

`ALTER TABLE products ADD CONSTRAINT chk_price CHECK (price >= 0);`

﻿

## TABLE RELATIONSHIPS

**Types of Constraints in MySQL**

  -------------------------------------------------------------------------
  **Constraint**       **Purpose**                      **Example Use**
  -------------------- -------------------------------- -------------------
  **PRIMARY KEY**      **Uniquely identifies each row** **Employee ID**

  **UNIQUE**           **Ensures data is not            **Email, username**
                       duplicated**                     

  **NOT NULL**         **Field must contain a value**   **Name, price**

  **FOREIGN KEY**      **Links data between tables**    **Customer →
                                                        Orders**

  **DEFAULT**          **Sets default value if none     **Created
                       provided**                       date/time**

  **CHECK**            **Restricts values in a column** **Age must be \>
                                                        18**

  **AUTO_INCREMENT**   **Auto-generated numeric ID**    **Serial numbers**
  -------------------------------------------------------------------------

**What are JOINS?**

**A JOIN is used to combine data from two or more tables based on a
related column.**

**Let's use these sample tables: 👇**

**students**

  -----------------------------------------------------------------------
  **student_id**                     **name**
  ---------------------------------- ------------------------------------
  **1**                              **Ravi**

  **2**                              **Priya**

  **3**                              **Arjun**
  -----------------------------------------------------------------------

**marks**

  ------------------------------------------------------------------------
  **student_id**                  **subject**            **score**
  ------------------------------- ---------------------- -----------------
  **1**                           **Math**               **90**

  **2**                           **Math**               **80**

  **4**                           **Math**               **88**
  ------------------------------------------------------------------------

**🔹1️⃣ INNER JOIN**

**→ Returns matching records only from both tables ✅**

**SELECT students.name, marks.subject, marks.score**

**FROM students**

**INNER JOIN marks**

**ON students.student_id = marks.student_id;**

**✅ Output (only IDs 1 & 2 match):**

  -----------------------------------------------------------------------
  **name**              **subject**                 **score**
  --------------------- --------------------------- ---------------------
  **Ravi**              **Math**                    **90**

  **Priya**             **Math**                    **80**
  -----------------------------------------------------------------------

**❌ Arjun (3) not included\
❌ ID 4 in marks not included**

**🔹2️⃣ LEFT JOIN (LEFT OUTER JOIN)**

**→ Returns all records from left table + matched from right\
→ Missing matches become NULL**

**SELECT students.name, marks.score**

**FROM students**

**LEFT JOIN marks**

**ON students.student_id = marks.student_id;**

**✅ Output:**

  -----------------------------------------------------------------------
  **name**                            **score**
  ----------------------------------- -----------------------------------
  **Ravi**                            **90**

  **Priya**                           **80**

  **Arjun**                           **NULL**
  -----------------------------------------------------------------------

**❌ Right table extra rows ignored (ID 4)**

**🔹3️⃣ RIGHT JOIN (RIGHT OUTER JOIN)**

**→ Returns all records from right table + matched from left\
→ Missing matches become NULL**

**SELECT students.name, marks.score**

**FROM students**

**RIGHT JOIN marks**

**ON students.student_id = marks.student_id;**

**✅ Output:**

  -----------------------------------------------------------------------
  **name**                            **score**
  ----------------------------------- -----------------------------------
  **Ravi**                            **90**

  **Priya**                           **80**

  **NULL**                            **88**
  -----------------------------------------------------------------------

**🔹4️⃣ FULL OUTER JOIN**

**→ Returns all records from both tables\
→ Unmatched = NULL**

**📌 PostgreSQL supports it\
📌 MySQL does NOT support directly\
(must use LEFT JOIN + RIGHT JOIN + UNION workaround)**

**SELECT students.name, marks.score**

**FROM students**

**FULL OUTER JOIN marks**

**ON students.student_id = marks.student_id;**

**✅ Output:**

  -----------------------------------------------------------------------
  **name**                            **score**
  ----------------------------------- -----------------------------------
  **Ravi**                            **90**

  **Priya**                           **80**

  **Arjun**                           **NULL**

  **NULL**                            **88**
  -----------------------------------------------------------------------

**🔹5️⃣ CROSS JOIN**

**→ Returns all possible combinations (Cartesian Product)**

**SELECT students.name, marks.subject**

**FROM students**

**CROSS JOIN marks;**

**📌 If students = 3 rows & marks = 3 rows → Output = 3 × 3 = 9 rows**

**✅ Used rarely (mostly for testing or special cases)**

**🔹6️⃣ SELF JOIN**

**→ Table joins with itself\
✔ Used for hierarchical data (Manager → Employee)**

**Example Table: employees**

  -----------------------------------------------------------------------
  **emp_id**        **emp_name**              **manager_id**
  ----------------- ------------------------- ---------------------------
  **1**             **A**                     **NULL**

  **2**             **B**                     **1**

  **3**             **C**                     **1**

  **4**             **D**                     **2**
  -----------------------------------------------------------------------

**✅ Query:**

**SELECT e.emp_name AS Employee, m.emp_name AS Manager**

**FROM employees e**

**LEFT JOIN employees m**

**ON e.manager_id = m.emp_id;**

**✅ Output:**

  -----------------------------------------------------------------------
  **Employee**                          **Manager**
  ------------------------------------- ---------------------------------
  **A**                                 **NULL**

  **B**                                 **A**

  **C**                                 **A**

  **D**                                 **B**
  -----------------------------------------------------------------------

**✅ Join Summary (Most Important Table)**

  -----------------------------------------------------------------------------
  **JOIN      **Matched Left**          **Matched   **Unmatched   **Unmatched
  Type**                                Right**     Left**        Right**
  ----------- ------------------------- ----------- ------------- -------------
  **INNER**   **✅**                    **✅**      **❌**        **❌**

  **LEFT**    **✅**                    **✅**      **✅**        **❌**

  **RIGHT**   **✅**                    **✅**      **❌**        **✅**

  **FULL**    **✅**                    **✅**      **✅**        **✅**

  **CROSS**   **🔹 All combinations                               
              (Cartesian Product)**                               

  **SELF**    **Joining table with                                
              itself**                                            
  -----------------------------------------------------------------------------

**FULL OUTER JOIN:** Emulated by `LEFT JOIN UNION ALL RIGHT JOIN` (MySQL
does not directly support `FULL OUTER JOIN`).

**ON DELETE CASCADE:** If a row in the parent table is deleted,
corresponding rows in the child table are also deleted.

﻿

## VIEWS

**Creating, Retrieving, Updating, Replacing/Altering Views:** Similar to
PostgreSQL, views provide a way to abstract complex queries into a
virtual table.

`CREATE OR REPLACE VIEW ``customer_orders`` AS SELECT c.name, o.order_date FROM customers c JOIN orders o ON c.id = o.customer_id;`

**SQL MODES:** Settings that affect how MySQL handles SQL syntax and
data.

﻿

## WINDOW FUNCTIONS

Perform calculations across a set of table rows that are related to the
current row.

**OVER ():** Clause that defines the window (set of rows) for a window
function.

**PARTITION BY:** Divides rows into partitions for window functions.

**RANK (), DENSE_RANK (), ROW_NUMBER ():** Functions for ranking rows
within a partition.

**NTILE ():** Divides rows into a specified number of groups.

**FIRST_VALUE (), LAG (), LEAD ():** Accessing values from previous or
subsequent rows within a partition.

**Example:**
`SELECT product_name, price, ROW_NUMBER() OVER (ORDER BY price DESC) as rank_num FROM products;`

﻿

## TRIGGERS

Blocks of SQL code that are automatically executed (fired) in response
to certain events (INSERT, UPDATE, DELETE) on a table.

**TIME(AFTER/BEFORE):** Specifies when the trigger should execute
relative to the event.

**EVENT(INSERT/UPDATE/DELETE):** Specifies the DML operation that fires
the trigger.

**LOGGER TRIGGERS:** Triggers used to log changes made to a table.

**MANAGING TRIGGERS:** Creating, viewing, and dropping triggers.

`CREATE TRIGGER ``update_stock`` `

`AFTER INSERT ON ``order_items`

` FOR EACH ROW `

`UPDATE products SET stock = stock - NEW.quantity `

`WHERE id = ``NEW.product_id``;`

`
`

\-- =============================

\-- 1. Departments Table

\-- =============================

CREATE TABLE Departments (

  dept_id INT PRIMARY KEY,

  dept_name VARCHAR(100) NOT NULL UNIQUE,

  location VARCHAR(100)

);

 

\-- =============================

\-- 2. Employees Table

\-- =============================

CREATE TABLE Employees (

  employee_id INT PRIMARY KEY,

  first_name VARCHAR(50) NOT NULL,

  last_name VARCHAR(50) NOT NULL,

  email VARCHAR(100) UNIQUE,

  phone_number VARCHAR(20),

  hire_date DATE NOT NULL,

  salary DECIMAL(10,2) CHECK (salary \> 0),

  dept_id INT,

  manager_id INT,

  CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES
Departments(dept_id),

  CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES
Employees(employee_id)

);

 

\-- =============================

\-- 3. Projects Table

\-- =============================

CREATE TABLE Projects (

  project_id INT PRIMARY KEY,

  project_name VARCHAR(100) NOT NULL,

  start_date DATE,

  end_date DATE,

  budget DECIMAL(12,2) CHECK (budget \>= 0),

  dept_id INT,

  CONSTRAINT fk_project_dept FOREIGN KEY (dept_id) REFERENCES
Departments(dept_id)

);

 

\-- =============================

\-- 4. Employee_Projects (Many-to-Many)

\-- =============================

CREATE TABLE Employee_Projects (

  emp_proj_id INT PRIMARY KEY,

  employee_id INT NOT NULL,

  project_id INT NOT NULL,

  role VARCHAR(50),

  assigned_date DATE DEFAULT (CURRENT_DATE),

  CONSTRAINT fk_ep_emp FOREIGN KEY (employee_id) REFERENCES
Employees(employee_id),

  CONSTRAINT fk_ep_proj FOREIGN KEY (project_id) REFERENCES
Projects(project_id)

);

 

\-- =============================

\-- 5. Timesheets Table

\-- =============================

CREATE TABLE Timesheets (

  timesheet_id INT PRIMARY KEY,

  employee_id INT NOT NULL,

  work_date DATE NOT NULL,

  hours_worked DECIMAL(5,2) CHECK (hours_worked \>= 0),

  is_billable TINYINT(1) DEFAULT 1,

  CONSTRAINT fk_timesheet_emp FOREIGN KEY (employee_id) REFERENCES
Employees(employee_id)

);

 

\-- =============================

\-- 6. Training Table

\-- =============================

CREATE TABLE Training (

  training_id INT PRIMARY KEY,

  course_name VARCHAR(100) UNIQUE,

  duration_days INT CHECK (duration_days \> 0),

  employee_id INT,

  CONSTRAINT fk_training_emp FOREIGN KEY (employee_id) REFERENCES
Employees(employee_id)

);

 

\-- =============================

\-- 7. Audit Table (for Triggers)

\-- =============================

CREATE TABLE Employees_Audit (

  audit_id INT PRIMARY KEY AUTO_INCREMENT,

  employee_id INT,

  deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  deleted_by VARCHAR(50)

);

 

\-- =============================

\-- Inserts: Departments

\-- =============================

INSERT INTO Departments VALUES

(1, \'Human Resources\', \'New York\'),

(2, \'Finance\', \'London\'),

(3, \'IT\', \'Johannesburg\'),

(4, \'Marketing\', \'Toronto\'),

(5, \'Operations\', \'Singapore\');

 

\-- =============================

\-- Inserts: Employees

\-- =============================

INSERT INTO Employees VALUES

(101, \'Alice\', \'Smith\', \'alice@company.com\', \'1234567890\',
\'2019-01-10\', 90000, 1, NULL),

(102, \'Bob\', \'Johnson\', \'bob@company.com\', \'2345678901\',
\'2020-03-15\', 60000, 2, 101),

(103, \'Charlie\', \'Brown\', \'charlie@company.com\', \'3456789012\',
\'2021-06-01\', 75000, 3, 101),

(104, \'Diana\', \'Taylor\', \'diana@company.com\', \'4567890123\',
\'2018-11-20\', 85000, 3, 101),

(105, \'Ethan\', \'Williams\', \'ethan@company.com\', \'5678901234\',
\'2022-07-05\', 50000, 2, 102),

(106, \'Fiona\', \'Martinez\', \'fiona@company.com\', \'6789012345\',
\'2023-01-15\', 70000, 4, 101),

(107, \'George\', \'Davis\', \'george@company.com\', \'7890123456\',
\'2020-09-01\', 72000, 5, 104),

(108, \'Hannah\', \'Miller\', \'hannah@company.com\', \'8901234567\',
\'2017-04-18\', 95000, 1, 101),

(109, \'Ian\', \'Clark\', \'ian@company.com\', \'9012345678\',
\'2016-12-10\', 110000, 3, 101),

(110, \'Jasmine\', \'Lopez\', \'jasmine@company.com\', \'0123456789\',
\'2019-08-12\', 65000, 4, 106);

 

\-- =============================

\-- Inserts: Projects

\-- =============================

INSERT INTO Projects VALUES

(201, \'ERP Upgrade\', \'2021-01-01\', \'2021-12-31\', 500000, 3),

(202, \'Payroll Automation\', \'2022-02-01\', NULL, 150000, 2),

(203, \'HR Onboarding Portal\', \'2020-06-01\', \'2021-03-31\', 120000,
1),

(204, \'Marketing Analytics Platform\', \'2022-05-01\', NULL, 300000,
4),

(205, \'Logistics Optimization\', \'2021-09-01\', \'2022-06-30\',
450000, 5);

 

\-- =============================

\-- Inserts: Employee_Projects

\-- =============================

INSERT INTO Employee_Projects VALUES

(301, 101, 201, \'Lead\', \'2021-01-10\'),

(302, 103, 201, \'Developer\', \'2021-02-15\'),

(303, 104, 201, \'Architect\', \'2021-03-01\'),

(304, 102, 202, \'Analyst\', \'2022-02-10\'),

(305, 105, 202, \'Support Engineer\', \'2022-02-15\'),

(306, 108, 203, \'HR Consultant\', \'2020-06-15\'),

(307, 106, 204, \'Data Analyst\', \'2022-05-05\'),

(308, 110, 204, \'Marketing Specialist\', \'2022-06-01\'),

(309, 107, 205, \'Coordinator\', \'2021-09-15\'),

(310, 109, 205, \'Project Manager\', \'2021-09-20\');

 

\-- =============================

\-- Inserts: Timesheets

\-- =============================

INSERT INTO Timesheets VALUES

(401, 103, \'2022-03-01\', 8.0, 1),

(402, 103, \'2022-03-02\', 9.5, 1),

(403, 104, \'2022-03-01\', 7.0, 1),

(404, 105, \'2022-03-05\', 6.5, 0),

(405, 106, \'2023-01-20\', 8.0, 1),

(406, 107, \'2021-10-10\', 10.0, 1),

(407, 108, \'2020-07-01\', 8.0, 1),

(408, 109, \'2022-04-18\', 7.5, 1),

(409, 110, \'2022-06-15\', 8.5, 1);

 

\-- =============================

\-- Inserts: Training

\-- =============================

INSERT INTO Training VALUES

(501, \'Agile Fundamentals\', 3, 101),

(502, \'SQL Advanced\', 5, 103),

(503, \'Java Spring Boot Mastery\', 7, 104),

(504, \'Data Visualization with Grafana\', 4, 106),

(505, \'Project Management Professional\', 10, 109),

(506, \'Effective Communication\', 2, 108);

 

\-- =============================

\-- Trigger for Employee Delete

\-- =============================

DELIMITER \$\$

 

CREATE TRIGGER trg_employee_delete

AFTER DELETE ON Employees

FOR EACH ROW

BEGIN

  INSERT INTO Employees_Audit (employee_id, deleted_by)

  VALUES (OLD.employee_id, CURRENT_USER());

END \$\$

DELIMITER ;

\-- 1. List all employees with department name

SELECT e.employee_id, e.first_name, e.last_name, d.dept_name

FROM Employees e

JOIN Departments d ON e.dept_id = d.dept_id;

\-- 2. Find employees who joined before 2020

SELECT \* FROM Employees WHERE hire_date \< \'2020-01-01\';

\-- 3. Find total salary per department

SELECT d.dept_name, SUM(e.salary) AS TotalSalary

FROM Employees e

JOIN Departments d ON e.dept_id = d.dept_id

GROUP BY d.dept_name;

\-- 4. Second highest salary

SELECT MAX(salary) AS SecondHighestSalary

FROM Employees

WHERE salary \< (SELECT MAX(salary) FROM Employees);

\-- 5. Self join: Employees and Managers

SELECT e.first_name AS Employee, m.first_name AS Manager

FROM Employees e

LEFT JOIN Employees m ON e.manager_id = m.employee_id;

\-- 6. Window functions: Rank by salary

SELECT first_name, salary, RANK() OVER (ORDER BY salary DESC) AS
RankBySalary

FROM Employees;

\-- 7. Lead and Lag Example

SELECT first_name, salary,

       LAG(salary) OVER (ORDER BY salary DESC) AS PrevSalary,

       LEAD(salary) OVER (ORDER BY salary DESC) AS NextSalary

FROM Employees;

\-- 8. String functions

SELECT UPPER(first_name) AS UpperName, LOWER(last_name) AS LowerName,

       LEN(first_name + \' \' + last_name) AS FullNameLength

FROM Employees;

\-- 9. Date difference

SELECT first_name, DATEDIFF(YEAR, hire_date, GETDATE()) AS YearsWorked

FROM Employees;

\-- 10. Subquery: Employees earning above department average

SELECT first_name, salary FROM Employees e

WHERE salary \> (SELECT AVG(salary) FROM Employees WHERE dept_id =
e.dept_id);

\-- 11. EXISTS vs IN

SELECT first_name FROM Employees e

WHERE EXISTS (SELECT 1 FROM Employee_Projects ep WHERE ep.employee_id =
e.employee_id);

SELECT first_name FROM Employees

WHERE employee_id IN (SELECT employee_id FROM Employee_Projects);

\-- 12. Delete example (triggers audit)

DELETE FROM Employees WHERE employee_id = 105;

\-- 13. View example

CREATE VIEW vw_EmployeeSalary AS

SELECT e.first_name, e.last_name, d.dept_name, e.salary

FROM Employees e

JOIN Departments d ON e.dept_id = d.dept_id;