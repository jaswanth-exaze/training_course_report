
-- Setting up Postgres SQL
-- open SQL Shell(psql)
-- 
--         Server [localhost]: localhost
--         Database [postgres]: postgres
--         Port [5432]: 5432
--         Username [postgres]: postgres
--         Password for user postgres:
--         psql (17.6)


-- =============================
--   Creating report database
-- =============================

create DATABASE report;

-- =============================
--     Using Database


--         postgres=# \c report
--         You are now connected to database "report" as user "postgres".
CREATE SCHEMA  course_report;

set search_path to course_report;
-- SET
-- report=# show search_path;
--   search_path
-- ---------------
--  course_report
-- (1 row)


-- ============================
--      Creating tables 
-- =============================
-- 1. Departments Table
-- =============================
CREATE TABLE Departments (
dept_id INT PRIMARY KEY,
dept_name VARCHAR(100) NOT NULL UNIQUE,
location VARCHAR(100)
);
-- =============================
-- 2. Employees Table
-- =============================
CREATE TABLE Employees (
employee_id INT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE,
phone_number VARCHAR(20),
hire_date DATE NOT NULL,
salary DECIMAL(10,2) CHECK (salary > 0),
dept_id INT,
manager_id INT,
CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES
Employees(employee_id)
);
-- =============================
-- 3. Projects Table
-- =============================
CREATE TABLE Projects (
project_id INT PRIMARY KEY,
project_name VARCHAR(100) NOT NULL,
start_date DATE,
end_date DATE,
budget DECIMAL(12,2) CHECK (budget >= 0),
dept_id INT,
CONSTRAINT fk_project_dept FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);
-- =============================
-- 4. Employee_Projects (Many-to-Many)
-- =============================
CREATE TABLE Employee_Projects (
emp_proj_id INT PRIMARY KEY,
employee_id INT NOT NULL,
project_id INT NOT NULL,
role VARCHAR(50),
assigned_date DATE DEFAULT CURRENT_DATE,
CONSTRAINT fk_ep_emp FOREIGN KEY (employee_id) REFERENCES
Employees(employee_id),
CONSTRAINT fk_ep_proj FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);
-- =============================
-- 5. Timesheets Table
-- =============================
CREATE TABLE Timesheets (
timesheet_id INT PRIMARY KEY,
employee_id INT NOT NULL,
work_date DATE NOT NULL,
hours_worked DECIMAL(5,2) CHECK (hours_worked >= 0),
is_billable BOOLEAN DEFAULT TRUE,
CONSTRAINT fk_timesheet_emp FOREIGN KEY (employee_id) REFERENCES
Employees(employee_id)
);
-- =============================
-- 6. Training Table
-- =============================
CREATE TABLE Training (
training_id INT PRIMARY KEY,
course_name VARCHAR(100) UNIQUE,
duration_days INT CHECK (duration_days > 0),
employee_id INT,
CONSTRAINT fk_training_emp FOREIGN KEY (employee_id) REFERENCES
Employees(employee_id)
);
-- =============================
-- 7. Audit Table (for Triggers)
-- =============================
CREATE TABLE Employees_Audit (
audit_id INT PRIMARY KEY,
employee_id INT,
deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
deleted_by VARCHAR(50)
);

select * from information_schema.tables where table_schema='course_report';



-- =============================
-- Inserting Data Into 
-- Departments
-- =============================
INSERT INTO Departments VALUES
(1, 'Human Resources', 'New York'),
(2, 'Finance', 'London'),
(3, 'IT', 'Johannesburg'),
(4, 'Marketing', 'Toronto'),
(5, 'Operations', 'Singapore');
-- =============================
-- Inserting Data Into 
-- Employees
-- =============================
INSERT INTO Employees VALUES
(101, 'Alice', 'Smith', 'alice@company.com', '1234567890', '2019-01-10', 90000, 1, NULL),
(102, 'Bob', 'Johnson', 'bob@company.com', '2345678901', '2020-03-15', 60000, 2, 101),
(103, 'Charlie', 'Brown', 'charlie@company.com', '3456789012', '2021-06-01', 75000, 3, 101),
(104, 'Diana', 'Taylor', 'diana@company.com', '4567890123', '2018-11-20', 85000, 3, 101),
(105, 'Ethan', 'Williams', 'ethan@company.com', '5678901234', '2022-07-05', 50000, 2, 102),
(106, 'Fiona', 'Martinez', 'fiona@company.com', '6789012345', '2023-01-15', 70000, 4, 101),
(107, 'George', 'Davis', 'george@company.com', '7890123456', '2020-09-01', 72000, 5, 104),
(108, 'Hannah', 'Miller', 'hannah@company.com', '8901234567', '2017-04-18', 95000, 1, 101),
(109, 'Ian', 'Clark', 'ian@company.com', '9012345678', '2016-12-10', 110000, 3, 101),
(110, 'Jasmine', 'Lopez', 'jasmine@company.com', '0123456789', '2019-08-12', 65000, 4, 106);
-- =============================
-- Inserting Data Into 
-- Projects
-- =============================
INSERT INTO Projects VALUES
(201, 'ERP Upgrade', '2021-01-01', '2021-12-31', 500000, 3),
(202, 'Payroll Automation', '2022-02-01', NULL, 150000, 2),
(203, 'HR Onboarding Portal', '2020-06-01', '2021-03-31', 120000, 1),
(204, 'Marketing Analytics Platform', '2022-05-01', NULL, 300000, 4),
(205, 'Logistics Optimization', '2021-09-01', '2022-06-30', 450000, 5);
-- =============================
-- Inserting Data Into 
-- Employee_Projects
-- =============================
INSERT INTO Employee_Projects VALUES
(301, 101, 201, 'Lead', '2021-01-10'),
(302, 103, 201, 'Developer', '2021-02-15'),
(303, 104, 201, 'Architect', '2021-03-01'),
(304, 102, 202, 'Analyst', '2022-02-10'),
(305, 105, 202, 'Support Engineer', '2022-02-15'),
(306, 108, 203, 'HR Consultant', '2020-06-15'),
(307, 106, 204, 'Data Analyst', '2022-05-05'),
(308, 110, 204, 'Marketing Specialist', '2022-06-01'),
(309, 107, 205, 'Coordinator', '2021-09-15'),
(310, 109, 205, 'Project Manager', '2021-09-20');
-- =============================
-- Inserting Data Into 
-- Timesheets
-- =============================
INSERT INTO Timesheets VALUES
(401, 103, '2022-03-01', 8.0, TRUE),
(402, 103, '2022-03-02', 9.5, TRUE),
(403, 104, '2022-03-01', 7.0, TRUE),
(404, 105, '2022-03-05', 6.5, FALSE),
(405, 106, '2023-01-20', 8.0, TRUE),
(406, 107, '2021-10-10', 10.0, TRUE),
(407, 108, '2020-07-01', 8.0, TRUE),
(408, 109, '2022-04-18', 7.5, TRUE),
(409, 110, '2022-06-15', 8.5, TRUE);
-- =============================
-- Inserting Data Into 
-- Training
-- =============================
INSERT INTO Training VALUES
(501, 'Agile Fundamentals', 3, 101),
(502, 'SQL Advanced', 5, 103),
(503, 'Java Spring Boot Mastery', 7, 104),
(504, 'Data Visualization with Grafana', 4, 106),
(505, 'Project Management Professional', 10, 109),
(506, 'Effective Communication', 2, 108);
-- =============================
-- Example Trigger
-- =============================
CREATE OR REPLACE FUNCTION log_employee_deletion()
RETURNS TRIGGER AS
BEGIN
INSERT INTO Employees_Audit (employee_id, deleted_by)
VALUES (OLD.employee_id, current_user);
RETURN OLD;
END;
LANGUAGE plpgsql;
-- ========
CREATE TRIGGER trg_employee_delete
AFTER DELETE ON Employees
FOR EACH ROW
EXECUTE FUNCTION log_employee_deletion();


--                             +------------------------+
--                             |    employees_audit     |
--                             +------------------------+
--                             | PK audit_id            |
--                             | employee_id            |
--                             | deleted_at             |
--                             | deleted_by             |
--                             +-----------^------------+
--                                         |
--                                         |
-- +------------------------+              |
-- |     departments        |              |
-- +------------------------+              |
-- | PK dept_id             |              |
-- | dept_name              |              |
-- | location               |              |
-- +-----------+------------+              |
--             | 1---∞                     |
--             |                           |
--             v                           |
-- +------------------------+    +---------+
-- |       employees        |    |
-- +------------------------+    |
-- | PK employee_id         |    |
-- | first_name             |    |
-- | last_name              |    |
-- | email                  |    |
-- | phone_number           |    |
-- | hire_date              |    |
-- | salary                 |    |
-- | FK dept_id  -----------+----+
-- | FK manager_id  --┐          |
-- +---------+--------+          |
--           | 1---∞  (Self Manager relationship)
--           |                   |
--           |                   |
--           |
-- +------------------------+    |
-- |       projects         |    |
-- +------------------------+    |
-- | PK project_id          |    |
-- | project_name           |    |
-- | start_date             |    |
-- | end_date               |    |
-- | budget                 |    |
-- | FK dept_id  -----------+    |
-- +------------------------+    |
--                               |
--                               |
-- +------------------------+    |      +------------------------+
-- |   employee_projects    |    |      |       timesheets       |
-- +------------------------+    |      +------------------------+
-- | PK emp_proj_id         |    |      | PK timesheet_id        |
-- | FK employee_id  -------+---------->+ FK employee_id         |
-- | FK project_id   -------+-----+     | work_date              |
-- | role                   |     |     | hours_worked           |
-- | assigned_date          |     |     | is_billable            |
-- +------------------------+     |     +------------------------+
--                                |
--                                |
--                                |
--                       +--------v---------+
--                       |     training     |
--                       +------------------+
--                       | PK training_id   |
--                       | course_name      |
--                       | duration_days    |
--                       | FK employee_id --+
--                       +------------------+





--  =====================    SELECT      =================================

-- Q1) Display all employee details
SELECT * FROM Employees;

-- Q2) Display first name, last name, and salary of employees
SELECT first_name, last_name, salary FROM Employees;

-- Q3) Display unique department IDs from Employees
SELECT DISTINCT dept_id FROM Employees;

--  =====================    SELECT WITH WHERE      =================================


-- Q4) Display all projects with budget greater than 200000
SELECT * FROM Projects
WHERE budget > 200000;

-- Q5) List employees hired after 2020
SELECT first_name, hire_date FROM Employees
WHERE hire_date > '2020-01-01';




-- =================================== SQL OPERATORS  =====================================
--                   Arithmetic Operators (+, -, *, /, %)
--                   Comparison Operators (=, >, <, >=, <=, <>)
--                   Logical Operators (AND, OR, NOT)
--                   BETWEEN, IN
--                   LIKE
--                   IS NULL / IS NOT NULL

-- Q1: Show employee name and a 10% added bonus to salary (Arithmetic +)
SELECT first_name, salary, salary * 1.10 AS salary_with_bonus
FROM Employees;

-- Q2: Show employees whose salary is NOT equal to 75000 (Comparison <>)
SELECT employee_id, first_name, salary
FROM Employees
WHERE salary <> 75000;

-- Q3: Show employees who earn more than 80000 AND work in department 3 (Logical AND)
SELECT first_name, salary, dept_id
FROM Employees
WHERE salary > 80000 AND dept_id = 3;

-- Q4: Show employees who are in department 1 OR department 2 (Logical OR)
SELECT first_name, dept_id
FROM Employees
WHERE dept_id = 1 OR dept_id = 2;

-- Q5: Show employees earning salary BETWEEN 60000 and 90000 (BETWEEN)
SELECT first_name, salary
FROM Employees
WHERE salary BETWEEN 60000 AND 90000;

-- Q6: Show employees who work in Finance or IT departments using IN
SELECT first_name, dept_id
FROM Employees
WHERE dept_id IN (2, 3);

-- Q7: Show employees whose first name starts with 'D' (LIKE)
SELECT first_name
FROM Employees
WHERE first_name LIKE 'D%';

-- Q8: Show employees who do not have a manager (IS NULL)
SELECT first_name, manager_id
FROM Employees
WHERE manager_id IS NULL;

-- Q9: Show departments having more than 2 employees (Comparison in HAVING)
SELECT dept_id, COUNT(*) AS emp_count
FROM Employees
GROUP BY dept_id
HAVING COUNT(*) > 2;

-- Q10: Show employee name and salary remainder when divided by 1000 (Arithmetic %)
SELECT first_name, salary, salary % 1000 AS salary_remainder
FROM Employees;

-- =================================== String Functions  =====================================
-- Q1: Concatenate first_name and last_name as Full Name
SELECT first_name || ' ' || last_name AS full_name
FROM Employees;

-- Q2: Convert all employee names to uppercase
SELECT UPPER(first_name) AS upper_first_name
FROM Employees;

-- Q3: Find length of each employee's email
SELECT email, LENGTH(email) AS email_length
FROM Employees;

-- Q4: Extract first 3 characters of department name
SELECT dept_name, SUBSTRING(dept_name FROM 1 FOR 3) AS dept_code
FROM Departments;

-- Q5: Replace 'company.com' with 'corp.com' in emails
SELECT email,
       REPLACE(email, 'company.com', 'corp.com') AS new_email
FROM Employees;

-- Q6: Trim extra spaces around project_name (if exists)
SELECT project_name,
       TRIM(project_name) AS cleaned_project_name
FROM Projects;

-- Q7: Find position of '@' character in email
SELECT email,
       POSITION('@' IN email) AS at_position
FROM Employees;

-- Q8: Display employees whose first_name starts with 'A' (string pattern match)
SELECT employee_id, first_name
FROM Employees
WHERE first_name LIKE 'A%';

-- Q9: Mask phone number except last 4 digits (string formatting)
SELECT phone_number,
       '******' || RIGHT(phone_number, 4) AS masked_number
FROM Employees;

-- Q10: Left pad project_id with zeros to make 5 characters
SELECT project_id,
       LPAD(project_id::TEXT, 5, '0') AS padded_project_id
FROM Projects;

-- =================================== Filtering & Sorting  =====================================

-- Q6) List employees ordered by salary descending
SELECT employee_id, first_name, salary FROM Employees
ORDER BY salary DESC;

-- Q7) Show employees whose salary is between 60000 and 90000
SELECT employee_id, first_name, salary FROM Employees
WHERE salary BETWEEN 60000 AND 90000;

-- Q8) Show employees who have no manager (top-level managers)
SELECT employee_id, first_name FROM Employees
WHERE manager_id IS NULL;

-- =================================== Aggregation Functions  =====================================


-- Q14) Count number of employees in each department
SELECT dept_id, COUNT(*) AS total_employees
FROM Employees
GROUP BY dept_id;

-- Q15) Find the highest salary in company
SELECT MAX(salary) AS highest_salary
FROM Employees;

-- Q16) Total hours worked by each employee
SELECT employee_id, SUM(hours_worked) AS total_hours
FROM Timesheets
GROUP BY employee_id;

-- =================================== GROUP BY + HAVING  =====================================

-- Q1 (Easy): Show number of employees in each department 
-- (only departments having more than 1 employee)
SELECT dept_id, COUNT(*) AS employee_count
FROM Employees
GROUP BY dept_id
HAVING COUNT(*) > 1;

-- Q2 (Easy): List departments where total salary exceeds 150000
SELECT dept_id, SUM(salary) AS total_salary
FROM Employees
GROUP BY dept_id
HAVING SUM(salary) > 150000;

-- Q3 : Show number of projects handled by each department 
-- but only if they have at least 2 projects
SELECT dept_id, COUNT(*) AS project_count
FROM Projects
GROUP BY dept_id
HAVING COUNT(*) >= 2;

-- Q4 : Show employees who worked more than 15 total hours (billable only)
SELECT employee_id, SUM(hours_worked) AS total_billable_hours
FROM Timesheets
WHERE is_billable = TRUE
GROUP BY employee_id
HAVING SUM(hours_worked) > 15;

-- Q5 : Show projects where more than 1 employee is assigned,
-- and total assigned employees have an average salary greater than 70000
SELECT p.project_name,
       COUNT(e.employee_id) AS emp_count,
       AVG(e.salary) AS avg_salary
FROM Employee_Projects ep
JOIN Employees e ON ep.employee_id = e.employee_id
JOIN Projects p ON ep.project_id = p.project_id
GROUP BY p.project_name
HAVING COUNT(e.employee_id) > 1
   AND AVG(e.salary) > 70000;

-- =================================== CASE  =====================================


-- Q1: Categorize employees based on salary
SELECT first_name, salary,
       CASE 
          WHEN salary >= 90000 THEN 'High Salary'
          WHEN salary >= 60000 THEN 'Medium Salary'
          ELSE 'Low Salary'
       END AS salary_level
FROM Employees;

-- Q2: Show project status as 'Completed' or 'In Progress'
SELECT project_name,
       CASE 
          WHEN end_date IS NULL THEN 'In Progress'
          ELSE 'Completed'
       END AS project_status
FROM Projects;

-- Q3: Show working hours remark based on hours logged
SELECT employee_id, work_date, hours_worked,
       CASE 
          WHEN hours_worked > 8 THEN 'Overtime'
          WHEN hours_worked = 8 THEN 'Normal'
          ELSE 'Less'
       END AS hours_status
FROM Timesheets;

-- =================================== CAST  =====================================

-- Q4: Convert salary to integer for display
SELECT first_name,
       CAST(salary AS INT) AS salary_int
FROM Employees;

-- Q5: Convert work_date to TEXT format
SELECT employee_id,
       CAST(work_date AS VARCHAR) AS work_date_text
FROM Timesheets;

-- Q6: Convert budget to integer and show difference with original
SELECT project_name,
       budget,
       CAST(budget AS INT) AS budget_int
FROM Projects;


-- =================================== TYPE CONVERTIONS  =====================================
-- Q7: Convert date to formatted string (DD-MM-YYYY)
SELECT project_name,
       TO_CHAR(start_date, 'DD-MM-YYYY') AS formatted_start_date
FROM Projects;

-- Q8: Convert numeric salary to VARCHAR
SELECT first_name,
       salary::VARCHAR AS salary_text
FROM Employees;

-- Q9: Convert boolean to text
SELECT employee_id,
       is_billable::TEXT AS is_billable_text
FROM Timesheets;


-- =================================== NULL IF  =====================================

-- Q10: Compare salary with department id 
-- (returns NULL where salary = dept_id)
SELECT first_name, salary,
       NULLIF(salary, dept_id) AS salary_vs_dept
FROM Employees;
-- Q11: Avoid division by zero when calculating hours per project member
SELECT emp.emp_proj_id,
       hours_worked,
       hours_worked / NULLIF(emp_count, 0) AS divided_hours
FROM (
     SELECT ep.emp_proj_id,
            t.hours_worked,
            COUNT(ep.employee_id) OVER (PARTITION BY ep.project_id) AS emp_count
     FROM Employee_Projects ep
     LEFT JOIN Timesheets t ON ep.employee_id = t.employee_id
) AS emp;

-- Q12: Nullify phone_number if missing by comparing with empty string
SELECT first_name,
       NULLIF(phone_number, '') AS phone_number_nullified
FROM Employees;






-- ================================================================================================================================================================
--     JOINS
-- ================================================================================================================================================================

-- =================================== INNER JOIN  =====================================

-- Q1: Show employees with their department names
SELECT e.first_name, d.dept_name
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id;

-- Q2: Show employee name and project name they are working on
SELECT e.first_name, p.project_name
FROM Employees e
INNER JOIN Employee_Projects ep ON e.employee_id = ep.employee_id
INNER JOIN Projects p ON ep.project_id = p.project_id;

-- Q3: Show project name and number of assigned employees
SELECT p.project_name, COUNT(ep.employee_id) AS emp_count
FROM Projects p
INNER JOIN Employee_Projects ep ON p.project_id = ep.project_id
GROUP BY p.project_name;

-- Q4: Show training course and the employees attending
SELECT t.course_name, e.first_name
FROM Training t
INNER JOIN Employees e ON t.employee_id = e.employee_id;

-- Q5: Show timesheets with employee names (only where hours logged exist)
SELECT e.first_name, t.work_date, t.hours_worked
FROM Employees e
INNER JOIN Timesheets t ON e.employee_id = t.employee_id;

-- =================================== LEFT JOIN  =====================================
-- Q6: Show all employees and their managers (include employees with no manager)
SELECT e.first_name AS employee, m.first_name AS manager
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.employee_id;

-- Q7: Show all employees and the projects they are assigned to (include those without project)
SELECT e.first_name, p.project_name
FROM Employees e
LEFT JOIN Employee_Projects ep ON e.employee_id = ep.employee_id
LEFT JOIN Projects p ON ep.project_id = p.project_id;

-- Q8: Show all departments and count of employees in each department
SELECT d.dept_name, COUNT(e.employee_id) AS total_emp
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- Q9: Show departments even if no projects assigned
SELECT d.dept_name, p.project_name
FROM Departments d
LEFT JOIN Projects p ON d.dept_id = p.dept_id;

-- Q10: Show all employees with total hours worked (if no timesheet then NULL)
SELECT e.employee_id, e.first_name, SUM(t.hours_worked) AS total_hours
FROM Employees e
LEFT JOIN Timesheets t ON e.employee_id = t.employee_id
GROUP BY e.employee_id, e.first_name;

-- =================================== RIGHT JOIN  =====================================
-- Q11: Show project and employee names (include projects with no employees)
SELECT p.project_name, e.first_name
FROM Employees e
RIGHT JOIN Employee_Projects ep ON e.employee_id = ep.employee_id
RIGHT JOIN Projects p ON ep.project_id = p.project_id;

-- Q12: Show department name and employees (include departments without employees)
SELECT d.dept_name, e.first_name
FROM Employees e
RIGHT JOIN Departments d ON e.dept_id = d.dept_id;

-- Q13: Show all training entries (even if employee missing)
SELECT t.course_name, e.first_name
FROM Employees e
RIGHT JOIN Training t ON e.employee_id = t.employee_id;

-- Q14: Show all projects and departments owning them
SELECT d.dept_name, p.project_name
FROM Departments d
RIGHT JOIN Projects p ON p.dept_id = d.dept_id;

-- Q15: Show timesheet logs even if employee doesn’t exist in employee table
SELECT e.first_name, t.hours_worked
FROM Employees e
RIGHT JOIN Timesheets t ON e.employee_id = t.employee_id;

-- =================================== FULL OUTER JOIN  =====================================
-- Q16: Show all employees and all timesheet data (match when possible)
SELECT e.first_name, t.work_date, t.hours_worked
FROM Employees e
FULL OUTER JOIN Timesheets t ON e.employee_id = t.employee_id;

-- Q17: Show all departments and all projects
SELECT d.dept_name, p.project_name
FROM Departments d
FULL JOIN Projects p ON d.dept_id = p.dept_id;

-- Q18: Show all employees and all training data
SELECT e.first_name, t.course_name
FROM Employees e
FULL OUTER JOIN Training t ON e.employee_id = t.employee_id;

-- Q19: Show any employees or manager records (no matter if connection missing)
SELECT e.first_name AS employee, m.first_name AS manager
FROM Employees e
FULL OUTER JOIN Employees m ON e.manager_id = m.employee_id;

-- Q20: Show all possible mappings between employees and projects
SELECT e.first_name, p.project_name
FROM Employees e
FULL OUTER JOIN Employee_Projects ep ON e.employee_id = ep.employee_id
FULL OUTER JOIN Projects p ON ep.project_id = p.project_id;

-- =================================== SELF JOIN  =====================================
-- Q21: Show employees with their manager names
SELECT e.first_name AS employee, m.first_name AS manager
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.employee_id;

-- Q22: Show employees who share the same manager
SELECT e1.first_name AS emp1, e2.first_name AS emp2
FROM Employees e1
JOIN Employees e2 ON e1.manager_id = e2.manager_id
WHERE e1.employee_id <> e2.employee_id;

-- Q23: Show count of team members under each manager
SELECT m.first_name AS manager, COUNT(e.employee_id) AS team_size
FROM Employees e
JOIN Employees m ON e.manager_id = m.employee_id
GROUP BY m.first_name;

-- Q24: Show employees whose manager earns more salary
SELECT e.first_name AS employee, m.first_name AS manager
FROM Employees e
JOIN Employees m ON e.manager_id = m.employee_id
WHERE m.salary > e.salary;

-- Q25: Show employees who do not manage anyone
SELECT e.first_name
FROM Employees e
LEFT JOIN Employees m ON e.employee_id = m.manager_id
WHERE m.employee_id IS NULL;

-- =================================== SELF JOIN  =====================================

-- Q26: Pair every employee with every project (Cartesian product)
SELECT e.first_name, p.project_name
FROM Employees e
CROSS JOIN Projects p;

-- Q27: Pair departments with all courses
SELECT d.dept_name, t.course_name
FROM Departments d
CROSS JOIN Training t;

-- Q28: Get total combinations of employees and training
SELECT COUNT(*) AS total_combinations
FROM Employees CROSS JOIN Training;

-- Q29: Pair each manager with every department
SELECT DISTINCT m.first_name AS manager, d.dept_name
FROM Employees m
WHERE m.manager_id IS NULL
CROSS JOIN Departments d;

-- Q30: Create employee pair combinations (excluding self pair)
SELECT e1.first_name AS emp1, e2.first_name AS emp2
FROM Employees e1
CROSS JOIN Employees e2
WHERE e1.employee_id <> e2.employee_id;

-- =================================== VIEWS =====================================

-- Q1  : Create a view showing employee full names and salary
CREATE OR REPLACE VIEW emp_salary_view AS
SELECT employee_id,
       first_name || ' ' || last_name AS full_name,
       salary
FROM Employees;

-- Test the view
SELECT * FROM emp_salary_view;

-- Q2  : Create a view showing employees with department names
CREATE OR REPLACE VIEW emp_dept_view AS
SELECT e.employee_id,
       e.first_name,
       e.last_name,
       d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- Test the view
SELECT * FROM emp_dept_view;
-- Q3 : Create a view listing all active projects (end_date is NULL)
CREATE OR REPLACE VIEW active_projects_view AS
SELECT project_id,
       project_name,
       start_date,
       budget
FROM Projects
WHERE end_date IS NULL;

-- Test the view
SELECT * FROM active_projects_view;
-- Q4 : Create a view showing employees working more than 15 total hours
CREATE OR REPLACE VIEW hardworking_employees_view AS
SELECT t.employee_id,
       SUM(t.hours_worked) AS total_hours
FROM Timesheets t
GROUP BY t.employee_id
HAVING SUM(t.hours_worked) > 15;

-- Test the view
SELECT * FROM hardworking_employees_view;
-- Q5 : Create a view showing employees and the number of projects they work on
CREATE OR REPLACE VIEW emp_project_count_view AS
SELECT e.employee_id,
       e.first_name,
       COUNT(ep.project_id) AS project_count
FROM Employees e
LEFT JOIN Employee_Projects ep ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.first_name;

-- Test the view
SELECT * FROM emp_project_count_view;

-- =================================== SUBQUERY CTE & (Common Table Expressions)=====================================

-- Q1  : Show employees who earn more than the average salary
SELECT first_name, salary
FROM Employees
WHERE salary > (
    SELECT AVG(salary) FROM Employees
);

-- Q2 : Show projects handled by the department with maximum employees
SELECT project_name
FROM Projects
WHERE dept_id = (
    SELECT dept_id 
    FROM Employees
    GROUP BY dept_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Q3 : Show employees who are assigned to at least one project
SELECT employee_id, first_name
FROM Employees
WHERE employee_id IN (
    SELECT employee_id FROM Employee_Projects
);

-- Q4  : Get employee names with total hours worked using CTE
WITH emp_hours AS (
    SELECT employee_id, SUM(hours_worked) AS total_hours
    FROM Timesheets
    GROUP BY employee_id
)
SELECT employee_id, total_hours
FROM emp_hours;

-- Q5 : Show employees working on multiple projects
WITH emp_proj_count AS (
    SELECT employee_id, COUNT(project_id) AS project_count
    FROM Employee_Projects
    GROUP BY employee_id
)
SELECT employee_id, project_count
FROM emp_proj_count
WHERE project_count > 1;

-- Q6 : Find top 3 highest paid employees using CTE + Ranking
WITH salary_rank AS (
    SELECT employee_id, first_name, salary,
           RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM Employees
)
SELECT employee_id, first_name, salary
FROM salary_rank
WHERE rnk <= 3;

-- ===========================================================    WINDOW FUNCTIONS    ==========================================================

-- Q1  : Show employees with row numbers ordered by salary descending
SELECT employee_id, first_name, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM Employees;

-- Q2  : Rank employees by salary (tie → same rank)
SELECT employee_id, first_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Employees;

-- Q3 : Show employees with salary rank inside each department
SELECT employee_id, first_name, dept_id, salary,
       DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_salary_rank
FROM Employees;

-- Q4 : Show timesheet entries with cumulative total hours per employee
SELECT employee_id, work_date, hours_worked,
       SUM(hours_worked) OVER (PARTITION BY employee_id ORDER BY work_date) AS running_hours
FROM Timesheets;

-- Q5 : Compare employee salary with previous higher-salary employee
SELECT employee_id, first_name, salary,
       LAG(salary, 1) OVER (ORDER BY salary DESC) AS prev_salary
FROM Employees;

-- Q6 : Show next manager in ranking for each employee
SELECT employee_id, first_name, manager_id,
       LEAD(first_name) OVER (ORDER BY manager_id) AS next_manager
FROM Employees;

-- Q7 : Find highest salary in each department and salary difference for employees
SELECT employee_id, first_name, dept_id, salary,
       MAX(salary) OVER (PARTITION BY dept_id) AS max_salary_in_dept,
       MAX(salary) OVER (PARTITION BY dept_id) - salary AS diff_from_max
FROM Employees;


-- ===================================   PostgreSQL Stored Procedures & Functions    ==================================


-- Q1 : Create a function that returns full name of an employee
CREATE OR REPLACE FUNCTION get_full_name(emp_id INT)
RETURNS VARCHAR AS $$
DECLARE
    full_name VARCHAR;
BEGIN
    SELECT first_name || ' ' || last_name
    INTO full_name
    FROM Employees
    WHERE employee_id = emp_id;

    RETURN full_name;
END;
$$ LANGUAGE plpgsql;

-- Test
SELECT get_full_name(101);

-- Q2 : Create a function that returns department name for an employee
CREATE OR REPLACE FUNCTION get_emp_dept(emp_id INT)
RETURNS VARCHAR AS $$
DECLARE
    dept_name VARCHAR;
BEGIN
    SELECT d.dept_name INTO dept_name
    FROM Employees e
    JOIN Departments d ON e.dept_id = d.dept_id
    WHERE e.employee_id = emp_id;

    RETURN dept_name;
END;
$$ LANGUAGE plpgsql;

-- Test
SELECT get_emp_dept(106);

-- Q3 : Procedure to update employee salary by percentage
CREATE OR REPLACE PROCEDURE update_salary(emp_id INT, percent_inc DECIMAL)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Employees
    SET salary = salary + (salary * percent_inc / 100)
    WHERE employee_id = emp_id;
END;
$$;

-- Test
CALL update_salary(105, 10);

-- Q4 : Function to return total hours worked by an employee
CREATE OR REPLACE FUNCTION get_total_hours(emp_id INT)
RETURNS DECIMAL AS $$
DECLARE
    total_hours DECIMAL;
BEGIN
    SELECT COALESCE(SUM(hours_worked), 0)
    INTO total_hours
    FROM Timesheets
    WHERE employee_id = emp_id;

    RETURN total_hours;
END;
$$ LANGUAGE plpgsql;

-- Test
SELECT get_total_hours(103);

-- Q4 : Function to return total hours worked by an employee
CREATE OR REPLACE FUNCTION get_total_hours(emp_id INT)
RETURNS DECIMAL AS $$
DECLARE
    total_hours DECIMAL;
BEGIN
    SELECT COALESCE(SUM(hours_worked), 0)
    INTO total_hours
    FROM Timesheets
    WHERE employee_id = emp_id;

    RETURN total_hours;
END;
$$ LANGUAGE plpgsql;

-- Test
SELECT get_total_hours(103);




-- ============================================   Trigger    ============================================

-- Q1: Prevent inserting employees with salary <= 0
CREATE OR REPLACE FUNCTION prevent_negative_salary()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary <= 0 THEN
        RAISE EXCEPTION 'Salary must be greater than 0';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_salary
BEFORE INSERT ON Employees
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_salary();

--------------------------------------------------------------

-- Q2: Log department change in audit
CREATE OR REPLACE FUNCTION log_dept_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.dept_id <> OLD.dept_id THEN
        INSERT INTO Employees_Audit (employee_id, deleted_by)
        VALUES (OLD.employee_id, current_user);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_dept_change
AFTER UPDATE OF dept_id ON Employees
FOR EACH ROW
EXECUTE FUNCTION log_dept_change();

--------------------------------------------------------------

-- Q3: Insert audit log on employee deletion
CREATE OR REPLACE FUNCTION log_emp_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Employees_Audit (employee_id, deleted_by)
    VALUES (OLD.employee_id, current_user);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_emp_delete
AFTER DELETE ON Employees
FOR EACH ROW
EXECUTE FUNCTION log_emp_delete();

--------------------------------------------------------------

-- Q4: Validate hours_worked in timesheets (0 to 12 allowed)
CREATE OR REPLACE FUNCTION validate_hours()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.hours_worked > 12 OR NEW.hours_worked < 0 THEN
        RAISE EXCEPTION 'Invalid hours! Allowed: 0 to 12';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_hours
BEFORE INSERT OR UPDATE ON Timesheets
FOR EACH ROW
EXECUTE FUNCTION validate_hours();

--------------------------------------------------------------

-- Q5: Update end_date before deleting a project
CREATE OR REPLACE FUNCTION archive_project()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Projects
    SET end_date = CURRENT_DATE
    WHERE project_id = OLD.project_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_project_delete
BEFORE DELETE ON Projects
FOR EACH ROW
EXECUTE FUNCTION archive_project();


-- =================================== UPDATE  =====================================
-- Q1: Increase salary of all employees by 10%
UPDATE Employees
SET salary = salary * 1.10;
-- Q2: Change email of employee with id 105
UPDATE Employees
SET email = 'new.email@example.com'
WHERE employee_id = 105;
-- Q3: Set manager_id to NULL for employees working in department 3
UPDATE Employees
SET manager_id = NULL
WHERE dept_id = 3;
-- Q4: Decrease project budget by 5% where project is not completed
UPDATE Projects
SET budget = budget * 0.95
WHERE end_date IS NULL;
-- Q5: Update phone number for employees whose phone number is missing
UPDATE Employees
SET phone_number = '0000000000'
WHERE phone_number IS NULL OR phone_number = '';

-- =================================== DELETE  =====================================
-- Q6: Delete employees with salary less than 40000
DELETE FROM Employees
WHERE salary < 40000;
-- Q7: Delete all timesheet entries older than year 2020
DELETE FROM Timesheets
WHERE work_date < '2020-01-01';
-- Q8: Remove training records where duration is 0 or negative
DELETE FROM Training
WHERE duration_days <= 0;
-- Q9: Delete projects where no budget is assigned
DELETE FROM Projects
WHERE budget IS NULL;
-- Q10: Delete department if no employees exist in that department
DELETE FROM Departments
WHERE dept_id NOT IN (SELECT dept_id FROM Employees);

-- =================================== ALTER  =====================================
-- Q11: Add column 'status' to Employees table
ALTER TABLE Employees
ADD COLUMN status VARCHAR(20);
-- Q12: Modify data type of phone_number column
ALTER TABLE Employees
ALTER COLUMN phone_number TYPE VARCHAR(15);
-- Q13: Rename column 'dept_name' to 'department_name'
ALTER TABLE Departments
RENAME COLUMN dept_name TO department_name;
-- Q14: Drop column 'end_date' from Projects table
ALTER TABLE Projects
DROP COLUMN end_date;
-- Q15: Add a NOT NULL constraint to project_name column
ALTER TABLE Projects
ALTER COLUMN project_name SET NOT NULL;




-- ============================================
-- CLEANUP SCRIPT FOR OUR PRACTICE DATABASE
-- ============================================

-- Step 1 : Drop triggers
DROP TRIGGER IF EXISTS trg_project_delete ON Projects;
DROP TRIGGER IF EXISTS trg_validate_hours ON Timesheets;
DROP TRIGGER IF EXISTS trg_emp_delete ON Employees;
DROP TRIGGER IF EXISTS trg_dept_change ON Employees;
DROP TRIGGER IF EXISTS trg_check_salary ON Employees;
DROP TRIGGER IF EXISTS trg_employee_delete ON Employees; -- Original audit trigger

-- Step 2 : Drop trigger functions
DROP FUNCTION IF EXISTS archive_project();
DROP FUNCTION IF EXISTS validate_hours();
DROP FUNCTION IF EXISTS log_emp_delete();
DROP FUNCTION IF EXISTS log_dept_change();
DROP FUNCTION IF EXISTS prevent_negative_salary();
DROP FUNCTION IF EXISTS log_employee_deletion(); -- Original audit function

-- Step 3 : Drop stored functions & procedures
DROP FUNCTION IF EXISTS get_full_name(INT);
DROP FUNCTION IF EXISTS get_emp_dept(INT);
DROP FUNCTION IF EXISTS get_total_hours(INT);
DROP PROCEDURE IF EXISTS update_salary(INT, DECIMAL);
DROP PROCEDURE IF EXISTS soft_delete_employee(INT, VARCHAR);

-- Step 4 : Drop Views
DROP VIEW IF EXISTS emp_project_count_view;
DROP VIEW IF EXISTS hardworking_employees_view;
DROP VIEW IF EXISTS active_projects_view;
DROP VIEW IF EXISTS emp_dept_view;
DROP VIEW IF EXISTS emp_salary_view;

-- Step 5 : Drop Tables (correct dependency order)
DROP TABLE IF EXISTS Employee_Projects;
DROP TABLE IF EXISTS Timesheets;
DROP TABLE IF EXISTS Training;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Employees_Audit;



-- Step 6 : Drop Schema (removes leftover objects)
DROP SCHEMA IF EXISTS course_report CASCADE;

-- Optional Step 7 : Drop Entire Database (⚠️ irreversible)
-- Manually disconnect before running.
-- DROP DATABASE practice_db WITH (FORCE);

DROP DATABASE report WITH (FORCE);



--  DATABASE CLEANED SUCCESSFULLY!
