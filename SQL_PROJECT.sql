-- PROJECT: HR Compensation & Workforce Analytics in PostgreSQL

-- 1. DATABASE SETUP, TABLE CREATION (DDL) & BASIC RETRIEVAL

-- 1.1 Creating schema for the project

CREATE SCHEMA IF NOT EXISTS hr_project;
SET search_path TO hr_project;

-- 1.2 Creating the base table 
CREATE TABLE hr_project (
    employee_name      VARCHAR(100) NOT NULL,
    emp_id             INT PRIMARY KEY,
    dept_id            INT NOT NULL,
    salary             NUMERIC(10, 2) NOT NULL,
    position           VARCHAR(100) NOT NULL,
    sex                VARCHAR(10) NOT NULL,
    department         VARCHAR(50) NOT NULL,
    performance_score  VARCHAR(30) NOT NULL
);

SELECT * FROM hr_project;
-- 1.3 Importing CSV file into 'hr_data' using pgAdmin Import/Export Wizard:

-- 1.4 Check total number of rows imported
SELECT COUNT(*) AS total_employees
FROM hr_project;

-- 1.5 View all columns for the first 10 employees
SELECT *
FROM hr_project
LIMIT 10;

-- 1.6 View specific columns with column aliases
SELECT
    emp_id AS "Employee ID",
    employee_name AS "Employee Name",
    department AS "Department",
    salary AS "Annual Salary"
FROM hr_project
LIMIT 10;

-- 1.7 Find all unique departments and performance scores (DISTINCT)
SELECT DISTINCT department,performance_score
FROM hr_project
ORDER BY department;

-- 2. FILTERING (WHERE), SORTING (ORDER BY) & CONDITIONAL LOGIC (CASE)

-- 2.1 Filter employees earning more than $100,000 (Comparison Operator + ORDER BY)
SELECT emp_id, employee_name, department, position, salary
FROM hr_project
WHERE salary > 100000
ORDER BY salary DESC;

-- 2.2 Filter employees in specific departments using IN
SELECT emp_id, employee_name, department, position, salary
FROM hr_project
WHERE department IN ('IT/IS', 'Software Engineering')
ORDER BY department, salary DESC;

-- 2.3 Filter employees within a salary range using BETWEEN and AND
SELECT emp_id, employee_name, department, salary, performance_score
FROM hr_project
WHERE salary BETWEEN 60000 AND 80000
  AND performance_score = 'Exceeds'
ORDER BY salary DESC;

-- 2.4 Search job titles containing 'Manager' or 'Director' using LIKE
SELECT emp_id, employee_name, department, position, salary
FROM hr_project
WHERE position LIKE '%Manager%'
   OR position LIKE '%Director%'
ORDER BY salary DESC;

-- 2.5 Find the Top 5 highest-paid employees (ORDER BY + LIMIT)
SELECT emp_id, employee_name, department, position, salary
FROM hr_project
ORDER BY salary DESC
LIMIT 5;

-- 2.6 Find the Bottom 5 lowest-paid employees
SELECT emp_id, employee_name, department, position, salary
FROM hr_project
ORDER BY salary ASC
LIMIT 5;

-- 2.7 Use String & Numeric Functions to format names and calculate monthly salary
SELECT
    emp_id,
    UPPER(employee_name) AS employee_name_upper,
    salary AS annual_salary,
    ROUND(salary / 12.0, 2) AS monthly_salary
FROM hr_project
LIMIT 10;

-- 2.8 Categorize employees into Salary Tiers using CASE WHEN
SELECT
    emp_id,
    employee_name,
    department,
    salary,
    CASE
        WHEN salary >= 150000 THEN 'Executive Tier'
        WHEN salary >= 90000  THEN 'Senior Tier'
        WHEN salary >= 60000  THEN 'Mid-Level Tier'
        ELSE 'Entry / Operations Tier'
    END AS salary_category
FROM hr_project
ORDER BY salary DESC
LIMIT 15;

-- 3. RELATIONAL TABLES (PK/FK), JOINS & SUBQUERIES

-- 3.1 Create normalized 'departments' and 'employees' tables with constraints
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    dept_id     INT PRIMARY KEY,
    dept_name   VARCHAR(50) UNIQUE NOT NULL,
    cost_center VARCHAR(20) NOT NULL
);

CREATE TABLE employees (
    emp_id            INT PRIMARY KEY,
    employee_name     VARCHAR(100) NOT NULL,
    dept_id           INT NOT NULL REFERENCES departments(dept_id),
    position          VARCHAR(100) NOT NULL,
    sex               CHAR(1) CHECK (sex IN ('M', 'F')),
    salary            NUMERIC(10, 2) CHECK (salary > 0),
    performance_score VARCHAR(30) DEFAULT 'Fully Meets'
);

-- 3.2 Insert master department records
INSERT INTO departments (dept_id, dept_name, cost_center) VALUES
    (1, 'Admin Offices', 'CC-100'),
    (2, 'Executive Office', 'CC-200'),
    (3, 'IT/IS', 'CC-300'),
    (4, 'Software Engineering', 'CC-400'),
    (5, 'Production', 'CC-500'),
    (6, 'Sales', 'CC-600');

SELECT * FROM departments;

-- 3.3 Copy employee records from 'hr_data' into normalized 'employees' table
INSERT INTO employees (emp_id, employee_name, dept_id, position, sex, salary, performance_score)
SELECT emp_id, employee_name, dept_id, position, sex, salary, performance_score
FROM hr_project;

SELECT * FROM employees;

-- 3.4 INNER JOIN: Display employee details alongside their department name & cost center
SELECT
    e.emp_id,
    e.employee_name,
    d.dept_name,
    d.cost_center,
    e.position,
    e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
ORDER BY e.emp_id
LIMIT 15;

-- 3.5 LEFT JOIN: Check employee count across every department
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS total_staff
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY d.dept_id;

-- 3.6 Subquery in WHERE: Find employees earning above the company average salary
SELECT
    emp_id,
    employee_name,
    position,
    salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC
LIMIT 10;

-- 3.7 Correlated Subquery: Find the highest-paid employee in each department
SELECT
    d.dept_name,
    e.emp_id,
    e.employee_name,
    e.position,
    e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM employees e2
    WHERE e2.dept_id = e.dept_id
)
ORDER BY e.salary DESC;

-- 4. AGGREGATIONS (GROUP BY/HAVING), SAFE UPDATES & TRANSACTIONS

-- 4.1 Overall company payroll summary (COUNT, SUM, AVG, MIN, MAX)
SELECT
    COUNT(*) AS total_employees,
    SUM(salary) AS total_annual_payroll,
    ROUND(AVG(salary), 2) AS average_salary,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary
FROM employees;

-- 4.2 Departmental headcount and salary statistics (GROUP BY)
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    SUM(e.salary) AS total_payroll,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_payroll DESC;

-- 4.3 Filter grouped results using HAVING (Departments with payroll > $1,000,000)
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    SUM(e.salary) AS total_payroll
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING SUM(e.salary) > 1000000
ORDER BY total_payroll DESC;

-- 4.4 Headcount and average salary by Performance Score
SELECT
    performance_score,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY performance_score
ORDER BY avg_salary DESC;

-- 4.5 Headcount and average salary by Gender
SELECT
    sex,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY sex;

-- 4.6 Transaction Management (BEGIN, UPDATE, ROLLBACK / COMMIT)
-- Simulate giving a 5% bonus raise to 'Exceeds' performers safely
BEGIN;

UPDATE employees
SET salary = ROUND(salary * 1.05, 2)
WHERE performance_score = 'Exceeds';

-- Preview the updated salaries inside the transaction
SELECT emp_id, employee_name, performance_score, salary
FROM employees
WHERE performance_score = 'Exceeds'
LIMIT 10;

-- Undo the test change using ROLLBACK (or use COMMIT to save permanently)
ROLLBACK;

