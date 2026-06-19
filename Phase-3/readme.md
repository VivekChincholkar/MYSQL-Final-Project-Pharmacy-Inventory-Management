## 💊🏥  Pharmacy Inventory Management - Phase-3 SQL Queries  
---
## 🔤 Phase Overview  
This `.sql` file = 🏪 Pharmacy DB x ⚡ SQL skills  
Includes ➡️ Joins 🔗 | Subqueries 🧩 |  
Perfect for practice, portfolios, and flexing data logic skills 💪  

---


🧱 Database Vibes  
---
This is a mock **Pharmacy Management System** with all the essentials:  

🛍️ Tables include:  
- Suppliers, Categories, Manufacturers, Products  
- Inventory, Customers, Prescriptions 
- Purchase Orders, Sales,, and more...  

---
🚀 Query Categories  
---
A < Joins < SQ < Fun < B&UD  
(A = Basic, SQ = Subqueries)  

🔗 Joins (INNER / LEFT / RIGHT / FULL)  
```sql
SELECT s.supplier_id, s.supplier_name, po.order_date, poi.quantity_ordered
FROM Suppliers s
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id
LEFT JOIN Purchase_Order_Items poi ON po.purchase_order_id = poi.purchase_order_id;

LEFT JOIN Purchase_Order_Items poi ON po.purchase_order_id = poi.purchase_order_id;
```
---

🧩 Subqueries
---
Simple: Find products above average price
Complex: EXISTS, IN, nested SELECTs

```sql
SELECT customer_name
FROM Customers
WHERE EXISTS (SELECT 1 FROM Prescriptions pr WHERE pr.customer_id = Customers.customer_id);
```
---


📁 File Details
---  
| Property       | Value                         |  
|----------------|-------------------------------|  
| File Name      | Phase-3.sql                   |  
| Total Queries  | ~75+ SQL 🔥                   |  
| Tables Covered | 15+ 🧱                        |  
| Skill Level    | Intermediate – Advanced 👨‍💻  |  

🧠 Use It For
---
🎓 SQL Practice  
💼 Portfolio Projects  
🧪 Test Data Analytics Logic  
🎯 Interview Preparation  

---

🙌 Author
---
Made with 💙 by Vivek Shriram Chincholkar  
🎓 BSc-IT | 🧠 Data Explorer | 🧑‍💻 Future Full-Stack Dev

---

🏁 Ready to Run?
---
Open your SQL editor (MySQL Workbench, phpMyAdmin, DBeaver etc.)  
Load Phase-3.sql  
Execute section by section or table by table  
Watch the data magic happen! 💫  

--- 

🧊 Bonus Tip
---
Pair this SQL DB with a Power BI / Tableau dashboard OR even a React + Node app to see real-world pharmacy insights 🔥


