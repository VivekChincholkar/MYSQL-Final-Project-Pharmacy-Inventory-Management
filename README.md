# 💊 Pharmacy Inventory Management Database Project (SQL)

A full-stack SQL project simulating a **Pharmacy Inventory & Prescription Tracker**. This project was built across multiple phases and showcases real-world use of **database design, data manipulation, and advanced querying techniques** in healthcare and pharmacy systems.

---

## 📌 Project Overview
This project implements a complete **Pharmacy Inventory & Prescription Management System** using **MySQL**. It covers **supplier management, medicine catalog, prescriptions, sales, employees, vendors, insurance claims**, and much more.  

The schema is designed with **25+ interconnected tables**, supporting **inventory control, purchase orders, prescriptions, billing, insurance processing, and employee shift management**.

---

## 📁 Phase Breakdown

### 🔹 Phase 1: Database Design  
- Designed and created **25 relational tables** including:  
  `Suppliers, Categories, Manufacturers, Products, Inventory, Customers, Prescriptions, Prescription_Items, Purchase_Orders, Sales, Employees, Shifts, Vendors, Insurance_Providers, Insurance_Claims, Drug_Interactions, Notifications` and more.  
- Defined **primary keys, foreign keys, and constraints** for integrity.  
- Populated sample data using `INSERT INTO` for each table.  

### 🔹 Phase 2: DDL, DML, Clauses & Operators  
- **DDL Commands**: `CREATE, ALTER, DROP, RENAME`  
- **DML Commands**: `INSERT, UPDATE, DELETE`  
- **SQL Clauses**: `WHERE, GROUP BY, HAVING, ORDER BY, LIMIT`  
- **Operators**: Logical (`AND, OR, NOT`) and Comparison (`=, >, <, BETWEEN, LIKE`).  

### 🔹 Phase 3: Joins, Subqueries & Functions  
- **Joins**: Inner, Left, Right, Full, and Self Joins across suppliers, products, prescriptions, and sales.  
- **Subqueries**: Scalar and correlated subqueries for nested queries like checking prescription fulfillment.  
- **Functions**:  
  - Built-in: `SUM(), AVG(), MAX(), NOW(), LENGTH()`  
  - UDFs: Custom logic for **discounts, insurance claims, and inventory valuation**.  

### 🔹 Phase 4: Advanced SQL Features  
- **Views**: Created reusable query views (`order_summary`, `prescription_report`, `inventory_alerts`).  
- **CTEs**: Used `WITH` for structured reporting (e.g., low-stock medicines).  
- **Stored Procedures**: Automated tasks such as generating **monthly sales reports** and **insurance claim summaries**.  
- **Triggers**: Example: auto-update inventory when a sale or prescription is completed.  
- **Transaction Control (TCL)**: `COMMIT, ROLLBACK, SAVEPOINT`.  
- **Window Functions**: `RANK(), ROW_NUMBER(), OVER()` for analytics like top-selling medicines.  

---

## 🧠 Key Learnings
- Designed a **real-world healthcare database schema**.  
- Practiced SQL from **basic queries to advanced triggers & procedures**.  
- Understood **data flow in pharmacies**: inventory → prescription → billing → insurance.  
- Learned to integrate **business logic** directly inside the database.  

---

## 💻 Technologies Used
- **Database**: MySQL 8.x  
- **Query Tool**: MySQL Workbench  
- **Language**: SQL  

---

## 🙌 Acknowledgements
This project was developed as part of the **Database Systems Curriculum** under academic evaluation.  
Inspired by **real-world pharmacy systems** and healthcare management requirements.  

---

## 📬 Contact
👨‍💻 **Vivek Shriram Chincholkar**  
📧 [chincholkarvivek007@gmail.com]  
🔗 [https://github.com/VivekChincholkar]
