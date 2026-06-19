🛡️ Pharmacy Inventory Management System – SQL Project
--
**📆 Phase 1 – SQL Database Design, Development & Documentation<br>  👨‍💻 By Vivek Shriram Chincholkar**
____

📌 Objective
--
Design and implement a complete SQL database system for a pharmacy inventory management platform. This project demonstrates core DBMS concepts: table design, relationships, query writing, and real-world data modeling.
____

🧠 Domain Overview – Pharmacy Inventory Management
--
>Pharmacies handle critical operations like drug inventory, prescriptions, patient records, supplier management, and employee scheduling. This project simulates a comprehensive system for tracking medications, sales, purchases, insurance claims, and more — all structured in a relational SQL database to ensure efficient operations and compliance.
___

🗃️ Database Summary
--
| Feature Details       | Description                                                                 |
| --------------------- | --------------------------------------------------------------------------- |
| **Database Name**     | Pharmacy\_Inventory\_Management                                             |
| **Total Tables**      | 15                                                                         |
| **Records per Table** | 10                                                                         |
| **Constraints Used**  | PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, DEFAULT, CHECK, AUTO\_INCREMENT |
___
🧱 Sample Tables & Entities
--

| Table Name        | Description                                            |
| ----------------- | ------------------------------------------------------ |
| **Suppliers**     | Supplier details and contact info                      |
| **Categories**    | Drug categories and hierarchies                        |
| **Manufacturers** | Manufacturer profiles and licenses                     |
| **Products**      | Product listings with details like strength and dosage |
| **Inventory**     | Stock levels, batches, and expiry tracking             |
| **Customers**     | Patient profiles with allergies and insurance          |
| **Prescriptions** | Prescription records and status                        |

✅ All 15 tables follow relational structure with valid constraints and normalization.
___
💾 Data Insertion
--
All tables are populated with at least 10 meaningful records:

● Logical relationships maintained (e.g., product_id links Products with Inventory and Prescriptions).  
● Realistic details included such as batch numbers, expiry dates, prices, and patient information.  
● All constraints respected — PRIMARY/FOREIGN KEYS, UNIQUE fields, and CHECK conditions. 
___
🔍 SQL Queries Executed
--
**🔨 DDL (Data Definition Language)**  
●CREATE DATABASE, CREATE TABLE, DROP TABLE, DROP DATABASE

**✍️ DML (Data Manipulation Language)**  
●INSERT INTO, TRUNCATE TABLE

**🔎 DQL (Data Query Language)**  
●SELECT *
Aggregates: (Implied for reporting, e.g., COUNT for stock levels)

🧠 Real-World Use Cases
--
|  Use Case                      |  Query Technique    |
| -------------------------------- | ---------------------------- |
| 💊 View patient prescriptions    | `SELECT`, `JOIN`, `WHERE`    |
| 💰 Calculate total sales revenue | `GROUP BY`, `SUM`            |
| 🧾 Generate prescription invoice | `JOIN`, `ORDER BY`           |
| 🔍 Check low-stock inventory     | `WHERE`, `ORDER BY`, `LIMIT` |
| ⭐ Monitor expiring batches       | `GROUP BY`, `ORDER BY`       |

___
💡 Reflection
--
**🧱 Challenges**

● Designing 15 meaningful, interconnected tables for pharmacy operations    
● Ensuring constraints like FOREIGN KEY integrity during data insertion  
● Handling date-based fields (e.g., expiry, created_date) accurately  

**🔧 Solutions**  
● Started with ER diagram and schema planning  
● Inserted data in FK-friendly order (e.g., categories before products)  
● Verified data with SELECT queries step-by-step  
___
🧰 Tool Used
--
💻 MySQL
___
🙌 Author Info
--
Built with 💙 by **Vivek Shriram Chincholkar**
🎓 BSc IT | SQL & Data Analyst Enthusiast | 2025

> All data in this project is fictional and created for academic purposes only.
