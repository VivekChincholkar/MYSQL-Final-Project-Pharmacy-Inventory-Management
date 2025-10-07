# 📊 Pharmacy Inventory Management (Phase 5)

This repository contains Phase 5 of the Pharmacy Inventory Management System.  
It extends the system by implementing advanced SQL concepts including DDL, DML, DQL, constraints, joins, subqueries, functions, views, CTEs, stored procedures, window functions, transactions, and triggers.

## 📌 Project Overview
The database models the operations of a pharmacy, covering products, suppliers, customers, employees, inventory, sales, prescriptions, manufacturers, purchase orders, and more.  
Phase 5 builds on previous phases by integrating comprehensive SQL operations for database management and business rule enforcement.

## 🏗️ SQL Components Implemented
✅ **DDL (Data Definition Language) – 10 Queries**  
Create new tables (e.g., ProductReviews, PharmacyBranches).  
Alter tables to add/drop columns, constraints, and indexes.  
Add ON DELETE / ON UPDATE CASCADE relationships for data integrity.  
Rename and drop tables as demonstrations.

✅ **DML (Data Manipulation Language) – 10 Queries**  
Insert supplier, product, inventory, sale, and purchase order records.  
Update product prices and purchase order statuses.  
Delete old/unwanted inventory, prescriptions, and notifications.

✅ **DQL (Data Query Language) – 10 Queries**  
Select queries for insights:  
Active products  
Inventory items per product  
Total stock per category  
Suppliers by creation date  
Sales made in 2025

✅ **Clauses & Operators – 10 Queries**  
Usage of WHERE, LIKE, BETWEEN, IN, ANY, ALL, OR, NOT operators.  
Examples include:  
Active inventory in specific categories.  
Products with prices between 10 and 20.  
Suppliers whose name starts with 'Medi'.  
Expenses in October 2025.

✅ **Constraints & Cascades – 10 Queries**  
Unique, Check, Cascade constraints.  
Examples:  
Unique prescription per customer per day.  
Cascade delete sale items when sales are deleted.  
Self-referencing vendor hierarchy.

✅ **Joins – 10 Queries**  
INNER JOIN, LEFT JOIN, RIGHT JOIN, SELF JOIN, FULL OUTER JOIN (via UNION).  
Examples:  
Product–category pairs.  
Customers with same insurance provider.  
Inventory comparisons across consecutive batches.

✅ **Subqueries – 10 Queries**  
Used for filtering and aggregations.  
Examples:  
Products with prices above average.  
Customers with more prescriptions than average.  
Categories with no products.  
Vendors with contracts ending before expenses.

✅ **Functions – 10 Queries**  
Aggregate and string functions:  
COUNT, SUM, AVG, MAX, MIN, LENGTH, UPPER, LOWER.  
Task count by status, average days supply, longest product name.

✅ **Views & CTEs – 10 Queries**  
Views like ProductInfo, InventorySummary, HighValueSales.  
CTEs for:  
Item counts per prescription.  
Yearly sales per customer.  
Recursive sequences and running totals.

✅ **Stored Procedures – 5 Queries**  
Add new products, update prescription status.  
Delete inventory by ID.  
Get total sales for a customer.  
Insert new notification.

✅ **Window Functions – 5 Queries**  
Ranking and analytic queries:  
Row numbers for products by price.  
Rank inventory by stock quantity.  
LEAD/LAG for sale and prescription dates.  
Rank customers within insurance provider by prescription count.

✅ **Transactions – 5 Queries**  
Demonstrations of COMMIT, ROLLBACK, SAVEPOINT.  
Examples:  
Update product prices and inventory stock.  
Mark sales completed and insert payments.  
Partial rollback on prescription updates.

✅ **Triggers – 5 Queries**  
Enforcing business rules and logging:  
Update inventory stock after sale item insert.  
Prevent negative stock on inventory update.  
Log deleted products.  
Auto-update sale status after payment.  
Auto-set creation date on prescription items.

## 🚀 Getting Started
### Prerequisites
- MySQL (or compatible RDBMS) installed.  
- Database name: Pharmacy_Inventory_Management.

### Steps
1. Clone the repository:  
   ```
   git clone https://github.com/your-username/pharmacy-inventory-management-phase5.git
   ```
2. Navigate to the directory:  
   ```
   cd pharmacy-inventory-management-phase5
   ```
3. Execute the SQL script to set up and populate the database.
