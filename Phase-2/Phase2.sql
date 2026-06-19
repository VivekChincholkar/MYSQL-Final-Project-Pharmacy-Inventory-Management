---- Project Phase-2(DDL<DML<DQL<C&C<OP)
-- ============================================================================
-- PROJECT PHASE-2: 5 QUERIES FOR EACH TABLE
-- ============================================================================

-- ============================================================================
-- TABLE 1: SUPPLIERS
-- ============================================================================

-- Query 1: DDL - Add column for supplier status
ALTER TABLE Suppliers ADD COLUMN status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Insert new supplier
INSERT INTO Suppliers (supplier_name, contact_person, phone, email, city, country) 
VALUES ('New Medical Supplies', 'John Doe', '+1-555-9999', 'john@newsupply.com', 'Austin', 'USA');

-- Query 3: DML - Update supplier name
UPDATE Suppliers SET supplier_name = UPPER(supplier_name) WHERE city = 'Boston';

-- Query 4: DQL - Select suppliers from USA with ORDER BY
SELECT supplier_name, city FROM Suppliers WHERE country = 'USA' ORDER BY supplier_name ASC;

-- Query 5: Aggregate Function - Count suppliers by city
SELECT city, COUNT(*) AS supplier_count FROM Suppliers GROUP BY city;

-- ============================================================================
-- TABLE 2: CATEGORIES
-- ============================================================================

-- Query 1: DDL - Add column for category color code
ALTER TABLE Categories ADD COLUMN color_code VARCHAR(10);

-- Query 2: DML - Insert new category
INSERT INTO Categories (category_name, description, is_active, created_by) 
VALUES ('Supplements', 'Dietary supplements and vitamins', TRUE, 'admin');

-- Query 3: DML - Update category description
UPDATE Categories SET description = 'All prescription medications' WHERE category_id = 1;


-- Query 4: DQL - Select active categories with LIMIT
SELECT category_name, description FROM Categories WHERE is_active = TRUE LIMIT 10;

-- Query 5: Aggregate Function - Count active vs inactive categories
SELECT SUM(CASE WHEN is_active = TRUE THEN 1 ELSE 0 END) AS active_count, 
        SUM(CASE WHEN is_active = FALSE THEN 1 ELSE 0 END) AS inactive_count FROM Categories;

-- ============================================================================
-- TABLE 3: PRODUCTS
-- ============================================================================

-- Query 1: DDL - Add column for product discount
ALTER TABLE Products ADD COLUMN discount_percentage DECIMAL(5,2) DEFAULT 0;

-- Query 2: DML - Insert new product
INSERT INTO Products (product_name, generic_name, category_id, strength, dosage_form, unit_price, barcode) 
VALUES ('New Medicine', 'Generic Medicine', 3, '100mg', 'Tablet', 25.00, '999999999999');

-- Query 3: DML - Update product price for specific category
UPDATE Products SET unit_price = unit_price * 1.10 WHERE category_id = 5;

-- Query 4: DQL - Select expensive products with ORDER BY
SELECT product_name, unit_price FROM Products WHERE unit_price > 50 ORDER BY unit_price DESC;

-- Query 5: Aggregate Function - Average product price by category
SELECT category_id, COUNT(*) AS product_count, AVG(unit_price) AS average_price FROM Products GROUP BY category_id;

-- ============================================================================
-- TABLE 4: CUSTOMERS
-- ============================================================================

-- Query 1: DDL - Add column for membership status
ALTER TABLE Customers ADD COLUMN membership_status VARCHAR(20) DEFAULT 'Regular';

-- Query 2: DML - Insert new customer
INSERT INTO Customers (customer_name, gender, phone, email, insurance_provider) 
VALUES ('New Customer', 'Male', '+1-555-9998', 'newcustomer@email.com', 'ABC Insurance');

-- Query 3: DML - Update customer insurance
UPDATE Customers SET insurance_provider = 'New Insurance' WHERE customer_id = 5;

-- Query 4: DQL - Select customers by gender with ORDER BY
SELECT customer_name, gender FROM Customers WHERE gender = 'Male' ORDER BY customer_name ASC;

-- Query 5: Aggregate Function - Count customers by insurance provider
SELECT insurance_provider, COUNT(*) AS customer_count FROM Customers GROUP BY insurance_provider;

-- ============================================================================
-- TABLE 5: INVENTORY
-- ============================================================================

-- Query 1: DDL - Add column for last restock date
ALTER TABLE Inventory ADD COLUMN last_restock_date DATE;

-- Query 2: DML - Insert new inventory record
INSERT INTO Inventory (product_id, batch_number, quantity_in_stock, reorder_level, maximum_level, location) 
VALUES (15, 'NEW001', 100, 20, 200, 'Shelf Z1');

-- Query 3: DML - Update inventory quantity
UPDATE Inventory SET quantity_in_stock = quantity_in_stock + 50 WHERE product_id = 1;

-- Query 4: DQL - Select low stock items with WHERE and ORDER BY
SELECT product_id, quantity_in_stock, reorder_level FROM Inventory WHERE quantity_in_stock < reorder_level ORDER BY quantity_in_stock ASC;

-- Query 5: Aggregate Function - Total inventory value and count by location
SELECT location, COUNT(*) AS item_count, SUM(quantity_in_stock * cost_price) AS total_value FROM Inventory GROUP BY location;

-- ============================================================================
-- TABLE 6: PRESCRIPTIONS
-- ============================================================================

-- Query 1: DDL - Add column for refill count
ALTER TABLE Prescriptions ADD COLUMN refill_count INT DEFAULT 0;

-- Query 2: DML - Insert new prescription
INSERT INTO Prescriptions (customer_id, doctor_name, prescription_date, status, total_amount) 
VALUES (1, 'Dr. New Doctor', '2024-02-01', 'Pending', 50.00);

-- Query 3: DML - Update prescription status
UPDATE Prescriptions SET status = 'Completed' WHERE prescription_id = 1;

-- Query 4: DQL - Select filled prescriptions with JOIN
SELECT c.customer_name, pr.prescription_id, pr.total_amount FROM Prescriptions pr 
LEFT JOIN Customers c ON pr.customer_id = c.customer_id WHERE pr.status = 'Filled';

-- Query 5: Aggregate Function - Count prescriptions by status
SELECT status, COUNT(*) AS prescription_count, SUM(total_amount) AS total_amount FROM Prescriptions GROUP BY status;

-- ============================================================================
-- TABLE 7: PURCHASE_ORDERS
-- ============================================================================

-- Query 1: DDL - Add column for order priority
ALTER TABLE Purchase_Orders ADD COLUMN priority VARCHAR(20) DEFAULT 'Normal';

-- Query 2: DML - Insert new purchase order
INSERT INTO Purchase_Orders (supplier_id, order_date, expected_delivery_date, order_status, total_amount) 
VALUES (5, '2024-02-01', '2024-02-10', 'Processing', 5000.00);

-- Query 3: DML - Update order status
UPDATE Purchase_Orders SET order_status = 'Delivered' WHERE purchase_order_id = 1;

-- Query 4: DQL - Select pending orders with JOIN and ORDER BY
SELECT s.supplier_name, po.purchase_order_id, po.total_amount FROM Purchase_Orders po 
LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id WHERE po.order_status = 'Pending' ORDER BY po.order_date DESC;

-- Query 5: Aggregate Function - Total orders and amount by supplier
SELECT s.supplier_name, COUNT(po.purchase_order_id) AS total_orders, SUM(po.total_amount) AS total_spent FROM Purchase_Orders po 
LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id GROUP BY po.supplier_id, s.supplier_name;

-- ============================================================================
-- TABLE 8: SALES
-- ============================================================================

-- Query 1: DDL - Add column for sale channel
ALTER TABLE Sales ADD COLUMN sale_channel VARCHAR(20) DEFAULT 'In-Store';

-- Query 2: DML - Insert new sale
INSERT INTO Sales (customer_id, sale_date, total_amount, tax_amount, payment_method, payment_status) 
VALUES (2, '2024-02-01', 150.00, 12.00, 'Cash', 'Completed');

-- Query 3: DML - Update payment status
UPDATE Sales SET payment_status = 'Completed' WHERE sale_id = 1;

-- Query 4: DQL - Select sales by payment method with JOIN
SELECT c.customer_name, s.sale_id, s.total_amount, s.payment_method FROM Sales s 
LEFT JOIN Customers c ON s.customer_id = c.customer_id WHERE s.payment_method = 'Cash';

-- Query 5: Aggregate Function - Sales statistics by payment method
SELECT payment_method, COUNT(*) AS transaction_count, SUM(total_amount) AS total_sales, AVG(total_amount) AS average_sale FROM Sales GROUP BY payment_method;

-- ============================================================================
-- TABLE 9: PRESCRIPTION_ITEMS
-- ============================================================================

-- Query 1: DDL - Add column for special instructions
ALTER TABLE Prescription_Items ADD COLUMN special_instructions VARCHAR(255);

-- Query 2: DML - Insert new prescription item
INSERT INTO Prescription_Items (prescription_id, product_id, quantity, dosage_instructions, days_supply) 
VALUES (1, 5, 30, 'Take one daily', 30);

-- Query 3: DML - Update refills remaining
UPDATE Prescription_Items SET refills_remaining = 2 WHERE prescription_item_id = 1;

-- Query 4: DQL - Select items with available refills and JOIN
SELECT pi.prescription_item_id, p.product_name, pi.quantity, pi.refills_remaining FROM Prescription_Items pi 
LEFT JOIN Products p ON pi.product_id = p.product_id WHERE pi.refills_remaining > 0;

-- Query 5: Aggregate Function - Item statistics by prescription
SELECT pi.prescription_id, COUNT(pi.prescription_item_id) AS item_count, SUM(pi.total_price) AS total_price FROM Prescription_Items pi GROUP BY pi.prescription_id;

-- ============================================================================
-- TABLE 10: INVENTORY_ADJUSTMENTS
-- ============================================================================

-- Query 1: DDL - Add column for adjustment cost
ALTER TABLE Inventory_Adjustments ADD COLUMN adjustment_cost DECIMAL(10,2);

-- Query 2: DML - Insert new adjustment
INSERT INTO Inventory_Adjustments (product_id, adjustment_date, quantity_adjusted, reason, adjustment_type) 
VALUES (3, '2024-02-01', -5, 'Found damaged', 'Loss');

-- Query 3: DML - Update adjustment reason
UPDATE Inventory_Adjustments SET reason = 'Damage during transport' WHERE adjustment_id = 1;

-- Query 4: DQL - Select loss adjustments with JOIN
SELECT ia.adjustment_id, p.product_name, ia.quantity_adjusted, ia.reason FROM Inventory_Adjustments ia 
LEFT JOIN Products p ON ia.product_id = p.product_id WHERE ia.adjustment_type = 'Loss';

-- Query 5: Aggregate Function - Total adjustments by type
SELECT adjustment_type, COUNT(*) AS adjustment_count, SUM(quantity_adjusted) AS total_quantity FROM Inventory_Adjustments GROUP BY adjustment_type;

-- ============================================================================
-- TABLE 11: SALE_ITEMS
-- ============================================================================

-- Query 1: DDL - Add column for discount reason
ALTER TABLE Sale_Items ADD COLUMN discount_reason VARCHAR(100);

-- Query 2: DML - Insert new sale item
INSERT INTO Sale_Items (sale_id, product_id, quantity, unit_price, total_price) 
VALUES (1, 2, 5, 8.75, 43.75);

-- Query 3: DML - Update item discount
UPDATE Sale_Items SET discount_amount = 5.00 WHERE sale_item_id = 1;

-- Query 4: DQL - Select high value items with JOIN and ORDER BY
SELECT si.sale_item_id, p.product_name, si.quantity, si.total_price FROM Sale_Items si 
LEFT JOIN Products p ON si.product_id = p.product_id WHERE si.total_price > 100 ORDER BY si.total_price DESC;

-- Query 5: Aggregate Function - Sales statistics by product
SELECT p.product_name, COUNT(si.sale_item_id) AS times_sold, SUM(si.quantity) AS total_quantity FROM Sale_Items si 
LEFT JOIN Products p ON si.product_id = p.product_id GROUP BY si.product_id, p.product_name;

-- ============================================================================
-- TABLE 12: PURCHASE_ORDER_ITEMS
-- ============================================================================

-- Query 1: DDL - Add column for delivery status
ALTER TABLE Purchase_Order_Items ADD COLUMN delivery_status VARCHAR(20);

-- Query 2: DML - Insert new purchase item
INSERT INTO Purchase_Order_Items (purchase_order_id, product_id, quantity_ordered, unit_cost, total_cost) 
VALUES (1, 5, 300, 6.00, 1800.00);

-- Query 3: DML - Update received quantity
UPDATE Purchase_Order_Items SET quantity_received = 500 WHERE purchase_order_item_id = 1;

-- Query 4: DQL - Select partial deliveries with JOIN
SELECT poi.purchase_order_item_id, p.product_name, poi.quantity_ordered, poi.quantity_received FROM Purchase_Order_Items poi 
LEFT JOIN Products p ON poi.product_id = p.product_id WHERE poi.quantity_ordered > poi.quantity_received;

-- Query 5: Aggregate Function - Cost statistics by purchase order
SELECT poi.purchase_order_id, COUNT(*) AS item_count, SUM(poi.total_cost) AS total_cost FROM Purchase_Order_Items poi GROUP BY poi.purchase_order_id;

-- ============================================================================
-- TABLE 13: DRUG_INTERACTIONS
-- ============================================================================

-- Query 1: DDL - Add column for review date
ALTER TABLE Drug_Interactions ADD COLUMN last_reviewed DATE;

-- Query 2: DML - Insert new interaction
INSERT INTO Drug_Interactions (product_id1, product_id2, interaction_type, severity, description) 
VALUES (5, 10, 'Pharmacokinetic', 'Moderate', 'May reduce effectiveness');

-- Query 3: DML - Update interaction severity
UPDATE Drug_Interactions SET severity = 'Critical' WHERE interaction_id = 1;

-- Query 4: DQL - Select major interactions with JOIN
SELECT di.interaction_id, p1.product_name AS drug1, p2.product_name AS drug2, di.severity FROM Drug_Interactions di 
LEFT JOIN Products p1 ON di.product_id1 = p1.product_id 
LEFT JOIN Products p2 ON di.product_id2 = p2.product_id WHERE di.severity = 'Major';

-- Query 5: Aggregate Function - Count interactions by severity
SELECT severity, COUNT(*) AS interaction_count FROM Drug_Interactions GROUP BY severity;

-- ============================================================================
-- TABLE 14: NOTIFICATIONS
-- ============================================================================

-- Query 1: DDL - Add column for notification channel
ALTER TABLE Notifications ADD COLUMN notification_channel VARCHAR(20) DEFAULT 'Email';

-- Query 2: DML - Insert new notification
INSERT INTO Notifications (notification_type, message, priority, status, created_for) 
VALUES ('Low Stock', 'Product ID 5 below reorder level', 'High', 'Pending', 104);

-- Query 3: DML - Update notification status
UPDATE Notifications SET status = 'Read' WHERE notification_id = 1;

-- Query 4: DQL - Select pending high priority notifications with ORDER BY
SELECT notification_id, notification_type, message FROM Notifications WHERE priority = 'High' AND status = 'Pending' ORDER BY created_date DESC;

-- Query 5: Aggregate Function - Count notifications by type and priority
SELECT notification_type, priority, COUNT(*) AS notification_count FROM Notifications GROUP BY notification_type, priority;

-- ============================================================================
-- TABLE 15: EMPLOYEES
-- ============================================================================

-- Query 1: DDL - Add column for performance rating
ALTER TABLE Employees ADD COLUMN performance_rating DECIMAL(3,2);

-- Query 2: DML - Insert new employee
INSERT INTO Employees (employee_name, position, department, hire_date, salary) 
VALUES ('Lisa Anderson', 'Pharmacy Technician', 'Pharmacy', '2024-02-01', 42000.00);

-- Query 3: DML - Update employee salary
UPDATE Employees SET salary = salary * 1.05 WHERE position = 'Senior Pharmacist';

-- Query 4: DQL - Select employees by department with ORDER BY
SELECT employee_name, position, salary FROM Employees WHERE department = 'Pharmacy' ORDER BY salary DESC;

-- Query 5: Aggregate Function - Salary statistics by department
SELECT department, COUNT(*) AS employee_count, AVG(salary) AS average_salary, MAX(salary) AS highest_salary FROM Employees GROUP BY department;
