# Enterprise HR Compensation \& Workforce Analytics in PostgreSQL

**Institution:** IILM University, Greater Noida\[cite: 14]  
**Program:** MBA — Semester III (2026–27)\[cite: 1, 14]  
**Course:** SQL and Data Management (`PMDE30605`)\[cite: 1, 14]  
**Faculty Instructor:** Dr. Lalit Kumar\[cite: 1]

## Project Overview

This repository contains the relational database schema, beginner-to-intermediate PostgreSQL queries, and HR dataset (`Final HR DATASET-SQL.csv`) analyzing compensation distribution, departmental payroll concentration, gender pay parity, and performance appraisal alignment across **311 employees**.

## Repository Contents

* `Final HR DATASET-SQL.csv` — Source HR dataset (311 records, 8 attributes).
* `hr\_analytics\_queries.sql` — Complete PostgreSQL script covering:

  1. **DDL \& Basic Retrieval:** Schema creation, table definitions, CSV import, `SELECT`, `DISTINCT`, `LIMIT`.
  2. **Filtering, Sorting \& Functions:** `WHERE`, `BETWEEN`, `IN`, `LIKE`, `ORDER BY`, string/numeric functions, and `CASE WHEN` salary tier segmentation.
  3. **Relational Modeling \& Joins:** Normalized `departments` and `employees` tables (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`), `INNER JOIN`, `LEFT JOIN`, and subqueries.
  4. **Aggregations \& Transactions:** `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY`, `HAVING`, and ACID transaction testing (`BEGIN`, `UPDATE`, `ROLLBACK`).

## How to Run

1. Open **pgAdmin 4** and connect to your local PostgreSQL server\[cite: 8].
2. Open the Query Tool and run Section 1 of `hr\_analytics\_queries.sql` to create the `hr\_project` schema and `hr\_data` table.
3. Import `Final HR DATASET-SQL.csv` into `hr\_project.hr\_data` using the pgAdmin Import/Export Wizard (Header = Yes, Delimiter = `,`)\[cite: 8].
4. Execute Sections 2 through 4 sequentially to generate the analytical outputs.

## Group Members

* **\[Member 1-Shiva Kumari]**
* **\[Member 2-Shambhavi Shukla]**
* **\[Member 3-Faiz Azam]**
* **\[Member 4-Dhruv Sagar Dayma]**

