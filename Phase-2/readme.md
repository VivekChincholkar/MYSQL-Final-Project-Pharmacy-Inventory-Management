🧠 Pharmacy Inventory Management – SQL Project (Phase 2)  
--
📆 Phase 2 – (DDL<DML<DQL<C&C<OP) 
___
📌 Phase 2 Objective 
--
This phase focuses on applying advanced SQL concepts to the previously designed Pharmacy Database. It demonstrates a deeper understanding of query operations, joins, subqueries, constraints like CASCADE, and clean code documentation.  
___
✅ Requirements Covered  
--
Feature | Status  
--- | ---  
🔹 DDL, DML, DQL | ✅ Applied  
🔹 Operators, Clauses, Alias, Functions | ✅ Used  
🔹 Joins & Subqueries | ✅ Done  
🔹 ON DELETE / UPDATE CASCADE | ✅ Included  
🔹 Neatly Commented Queries | ✅ Followed 

🧠 What’s Included in Phase 2.sql  
--
**🔨 DDL (Data Definition Language)**    
Table updates and structure alterations  
Added CASCADE constraints (e.g., adding columns like status with defaults across tables)  

**✍️ DML (Data Manipulation Language)**  
Insert new records for testing joins and subqueries  
Update and delete statements with cascading effect (e.g., updating names to uppercase based on conditions)  

**🔍 DQL (Data Query Language)**   
Includes:  
SELECT with WHERE, ORDER BY, LIMIT, GROUP BY, HAVING  
Aliases using AS  
Functions like COUNT(), AVG(), SUM(), MIN(), MAX(), UPPER(), DATE_ADD()  
___
-- Example: Find total stock per location  
SELECT location AS Location, SUM(quantity_in_stock) AS TotalStock  
FROM Inventory  
GROUP BY Location  
ORDER BY TotalStock DESC;  

🔗 Joins & Subqueries  
INNER, LEFT, RIGHT, FULL OUTER joins  
Nested queries inside SELECT, WHERE, FROM (e.g., joining Suppliers with Purchase_Orders and Purchase_Order_Items)  
___
🧼 Clean Query Formatting & Commenting  
--
✅ All queries are clearly labeled with comments (e.g., -- Query 1: DDL - Add column for supplier status)  
✅ Used single-line (--) and multi-line (/* */) comments  
✅ Queries grouped logically by table for clarity  
___
💡 What You’ll See in the Code  
--
📌 250+ queries demonstrating:  
Logical joins across related tables (e.g., Products with Manufacturers and Categories)  
Use of aliases and functions (e.g., COUNT(*) AS total_suppliers)  
Smart use of subqueries and operators (e.g., WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 3 MONTH))  
Cascading behavior in action  
Production-ready formatting with one query per table section  
___
🙌 Author Info  
--
Built with 💙 by Vivek Shriram Chincholkar  
🎓 BSc IT | SQL Enthusiast | 2025
