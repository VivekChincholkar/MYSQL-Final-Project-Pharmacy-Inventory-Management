USE Pharmacy_Inventory_Management;

-- ===============================================
-- DDL (Data Definition Language) - 10 queries
-- ===============================================
-- 1. Create table 'ProductReviews' for customer reviews on products
CREATE TABLE ProductReviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    CustomerID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText TEXT,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(product_id),
    FOREIGN KEY (CustomerID) REFERENCES Customers(customer_id)
);

-- 2. Alter 'Products' to add an optional 'Description' column
ALTER TABLE Products
ADD COLUMN Description TEXT;

-- 3. Alter 'Suppliers' to add a 'rating' column for supplier performance
ALTER TABLE Suppliers
ADD COLUMN rating DECIMAL(3,2) DEFAULT 0.00;

-- 4. Create an index on Inventory(product_id) to speed up stock queries
CREATE INDEX idx_inventory_product ON Inventory(product_id);

-- 5. Add unique constraint to ensure one prescription per customer per date
ALTER TABLE Prescriptions
ADD CONSTRAINT uq_prescription_per_day UNIQUE (customer_id, prescription_date);

-- 6. Rename table 'Categories' to 'ProductCategories' for clarity
ALTER TABLE Categories RENAME TO ProductCategories;

-- 7. Drop an example table if it exists (demonstration)
DROP TABLE IF EXISTS ExampleTable;

-- 8. Add CHECK constraint on Inventory.quantity_in_stock to ensure it is non-negative
ALTER TABLE Inventory
ADD CONSTRAINT chk_stock_non_negative CHECK (quantity_in_stock >= 0);

-- 9. Alter 'Sales' to add a foreign key on customer_id with ON DELETE SET NULL
ALTER TABLE Sales
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
ON DELETE SET NULL;

-- 10. Create table 'PharmacyBranches' to store branch locations
CREATE TABLE PharmacyBranches (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100),
    Address TEXT,
    City VARCHAR(50),
    Phone VARCHAR(20),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(employee_id)
);

-- ===============================================
-- DML (Data Manipulation Language) - 10 queries
-- ===============================================
-- 1. Insert a new supplier record
INSERT INTO Suppliers (supplier_id, supplier_name, contact_person, phone, email, address, city, state, country, created_date)
VALUES (21, 'NewPharma Inc.', 'Alex Rivera', '+1-555-0121', 'alex@newpharma.com', '123 New Ave', 'Boston', 'MA', 'USA', '2025-01-01');

-- 2. Bulk insert new product records
INSERT INTO Products (product_id, product_name, generic_name, manufacturer_id, category_id, strength, dosage_form, unit_price, barcode, created_date)
VALUES
(21, 'New Antibiotic', 'GenericAntibio', 1, 1, '500mg', 'Tablet', 15.99, '1234567890121', '2025-01-02'),
(22, 'Pain Relief Gel', 'GenericGel', 2, 2, '2%', 'Topical', 8.50, '1234567890122', '2025-01-03');

-- 3. Insert a new inventory record for the new product (product_id = 21)
INSERT INTO Inventory (inventory_id, product_id, batch_number, quantity_in_stock, reorder_level, maximum_level, expiry_date, cost_price, selling_price, location, last_updated)
VALUES (101, 21, 'BATCH021', 200, 50, 500, '2026-01-01', 10.00, 15.99, 'Shelf A1', CURRENT_TIMESTAMP);

-- 4. Insert a new sale for customer 1 on product 21
INSERT INTO Sales (sale_id, customer_id, sale_date, total_amount, tax_amount, discount_amount, payment_method, payment_status, cashier_id, receipt_number, created_date)
VALUES (101, 1, '2025-01-04', 15.99, 1.60, 0.00, 'Cash', 'Completed', 101, 'REC101', CURRENT_TIMESTAMP);

-- 5. Create a new purchase order for supplier 21
INSERT INTO Purchase_Orders (purchase_order_id, supplier_id, order_date, expected_delivery_date, actual_delivery_date, order_status, total_amount, tax_amount, shipping_cost, notes, created_date)
VALUES (101, 21, '2025-01-05', '2025-01-10', NULL, 'Pending', 1000.00, 100.00, 50.00, 'Standard order', CURRENT_TIMESTAMP);

-- 6. Update product 21's unit_price after review
UPDATE Products
SET unit_price = 16.99
WHERE product_id = 21;

-- 7. Mark purchase order 101 as 'Delivered'
UPDATE Purchase_Orders
SET order_status = 'Delivered', actual_delivery_date = '2025-01-10'
WHERE purchase_order_id = 101;

-- 8. Delete old inventory records before 2024
DELETE FROM Inventory
WHERE expiry_date < '2024-01-01';

-- 9. Remove a cancelled prescription (ID = 5)
DELETE FROM Prescriptions
WHERE prescription_id = 5;

-- 10. Delete notifications marked as 'Resolved' older than 30 days
DELETE FROM Notifications
WHERE status = 'Resolved' AND created_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- ===============================================
-- DQL (Data Query Language) - 10 queries
-- ===============================================
-- 1. Select all active products ordered by product_name
SELECT product_id, product_name, unit_price
FROM Products
WHERE status = 'Available'  -- Assuming status added in Phase 2
ORDER BY product_name;

-- 2. Count of inventory items per product
SELECT p.product_id, p.product_name, COUNT(i.inventory_id) AS InventoryCount
FROM Products p
LEFT JOIN Inventory i ON p.product_id = i.product_id
GROUP BY p.product_id, p.product_name;

-- 3. Total quantity in stock per category from inventory
SELECT i.category_id, c.category_name, SUM(i.quantity_in_stock) AS TotalStock
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
JOIN ProductCategories c ON p.category_id = c.category_id  -- Renamed table
GROUP BY i.category_id, c.category_name;

-- 4. List suppliers by descending created_date
SELECT supplier_id, supplier_name, created_date
FROM Suppliers
ORDER BY created_date DESC;

-- 5. Sales made in 2025
SELECT sale_id, total_amount, sale_date
FROM Sales
WHERE YEAR(sale_date) = 2025;

-- 6. Total selling price of inventory per manufacturer
SELECT p.manufacturer_id, m.manufacturer_name, SUM(i.selling_price * i.quantity_in_stock) AS TotalValue
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
JOIN Manufacturers m ON p.manufacturer_id = m.manufacturer_id
GROUP BY p.manufacturer_id, m.manufacturer_name;

-- 7. Customers with allergies
SELECT customer_id, customer_name, allergies
FROM Customers
WHERE allergies IS NOT NULL AND allergies != '';

-- 8. Number of prescription items per prescription
SELECT pi.prescription_id, COUNT(pi.prescription_item_id) AS ItemCount
FROM Prescription_Items pi
GROUP BY pi.prescription_id;

-- 9. Upcoming expiry items (within 3 months)
SELECT product_id, expiry_date, quantity_in_stock
FROM Inventory
WHERE expiry_date <= DATE_ADD(CURDATE(), INTERVAL 3 MONTH)
ORDER BY expiry_date;

-- 10. Employees hired in the last year
SELECT employee_id, employee_name, hire_date
FROM Employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- ===============================================
-- Clauses & Operators - 10 queries
-- ===============================================
-- 1. Active inventory in Antibiotics or Pain Relief categories
SELECT i.inventory_id, p.product_name, i.quantity_in_stock
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.status = 'In Stock' AND (p.category_id = 1 OR p.category_id = 2);  -- Assuming IDs

-- 2. Products with unit_price between 10 and 20
SELECT product_id, product_name, unit_price
FROM Products
WHERE unit_price BETWEEN 10.00 AND 20.00;

-- 3. Suppliers whose name starts with 'Medi'
SELECT supplier_id, supplier_name
FROM Suppliers
WHERE supplier_name LIKE 'Medi%';

-- 4. Customers aged 30, 40, or 50 (approx)
SELECT customer_id, customer_name, date_of_birth
FROM Customers
WHERE YEAR(CURDATE()) - YEAR(date_of_birth) IN (30, 40, 50);

-- 5. Prescriptions with total_amount more than any low-amount prescription
SELECT prescription_id, total_amount
FROM Prescriptions
WHERE total_amount > ANY (SELECT total_amount FROM Prescriptions WHERE total_amount < 50);

-- 6. Inventory with quantity exceeding all reorder levels
SELECT inventory_id, quantity_in_stock, reorder_level
FROM Inventory
WHERE quantity_in_stock > ALL (SELECT reorder_level FROM Inventory WHERE reorder_level > 0);

-- 7. Unresolved notifications with high priority
SELECT notification_id, message, priority
FROM Notifications
WHERE status = 'Pending' AND priority = 'High';

-- 8. All filled or pending prescription items
SELECT prescription_item_id, status
FROM Prescription_Items
WHERE status = 'Filled' OR status = 'Pending';

-- 9. Vendors not providing IT services (assuming vendor_type)
SELECT vendor_id, vendor_name
FROM Vendors
WHERE vendor_type NOT LIKE '%IT%';

-- 10. Expenses in October 2025
SELECT expense_id, expense_date, amount
FROM Expenses
WHERE expense_date BETWEEN '2025-10-01' AND '2025-10-31';

-- ===============================================
-- Constraints & Cascades - 10 queries
-- ===============================================
-- 1. Create table with ON DELETE CASCADE for sale items under a sale
CREATE TABLE SaleItemDetails (
    DetailID INT PRIMARY KEY AUTO_INCREMENT,
    SaleItemID INT,
    AdditionalInfo VARCHAR(255),
    FOREIGN KEY (SaleItemID) REFERENCES Sale_Items(sale_item_id)
    ON DELETE CASCADE
);

-- 2. Ensure inventory adjustments are deleted when product is deleted
ALTER TABLE Inventory_Adjustments
ADD CONSTRAINT fk_adjustments_product
FOREIGN KEY (product_id) REFERENCES Products(product_id)
ON DELETE CASCADE;

-- 3. Link prescription items to prescriptions with ON UPDATE CASCADE on prescription_id
ALTER TABLE Prescription_Items
ADD CONSTRAINT fk_prescription_items_prescription
FOREIGN KEY (prescription_id) REFERENCES Prescriptions(prescription_id)
ON UPDATE CASCADE;

-- 4. Create junction table for products and categories with composite PK (if needed, but already exists)
CREATE TABLE ProductCategoryAssignments (
    ProductID INT,
    CategoryID INT,
    AssignedDate DATE,
    PRIMARY KEY (ProductID, CategoryID),
    FOREIGN KEY (ProductID) REFERENCES Products(product_id),
    FOREIGN KEY (CategoryID) REFERENCES ProductCategories(category_id)
);

-- 5. Cascade updates from Employees to notifications
ALTER TABLE Notifications
ADD CONSTRAINT fk_notifications_employee
FOREIGN KEY (created_by) REFERENCES Employees(employee_id)
ON UPDATE CASCADE;

-- 6. Set Drug_Interactions.product_id1 to NULL if product is removed
ALTER TABLE Drug_Interactions
ADD CONSTRAINT fk_interactions_product1
FOREIGN KEY (product_id1) REFERENCES Products(product_id)
ON DELETE SET NULL;

-- 7. Create table for batch assignments with cascading constraints
CREATE TABLE BatchAssignments (
    AssignmentID INT PRIMARY KEY AUTO_INCREMENT,
    BatchNumber VARCHAR(50),
    ProductID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 8. Create a self-referencing vendor hierarchy table
CREATE TABLE VendorHierarchy (
    VendorID INT PRIMARY KEY,
    ParentVendorID INT,
    FOREIGN KEY (VendorID) REFERENCES Vendors(vendor_id),
    FOREIGN KEY (ParentVendorID) REFERENCES Vendors(vendor_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 9. Cascade delete claims when prescription is removed
ALTER TABLE Insurance_Claims
ADD CONSTRAINT fk_claims_prescription
FOREIGN KEY (prescription_id) REFERENCES Prescriptions(prescription_id)
ON DELETE CASCADE;

-- 10. Cascade delete adjustments when inventory is deleted
ALTER TABLE Inventory_Adjustments
ADD CONSTRAINT fk_adjustments_inventory
FOREIGN KEY (product_id) REFERENCES Inventory(product_id)
ON DELETE CASCADE;

-- ===============================================
-- Joins - 10 queries
-- ===============================================
-- 1. Inner join products with categories to list product-category pairs
SELECT p.product_id, p.product_name, c.category_name
FROM Products p
INNER JOIN ProductCategories c ON p.category_id = c.category_id;

-- 2. Left join suppliers with purchase orders (include suppliers without orders)
SELECT s.supplier_id, s.supplier_name, po.purchase_order_id
FROM Suppliers s
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id;

-- 3. Right join manufacturers with products to list all products and manufacturer
SELECT m.manufacturer_name, p.product_name
FROM Manufacturers m
RIGHT JOIN Products p ON m.manufacturer_id = p.manufacturer_id;

-- 4. Self join customers to find pairs with same insurance_provider
SELECT a.customer_id AS CID1, b.customer_id AS CID2, a.insurance_provider
FROM Customers a
JOIN Customers b ON a.insurance_provider = b.insurance_provider AND a.customer_id <> b.customer_id;

-- 5. Join employees, shifts, and employee_shifts to show assignments
SELECT e.employee_name, sh.shift_name, esh.work_date
FROM Employees e
JOIN Employee_Shifts esh ON e.employee_id = esh.employee_id
JOIN Shifts sh ON esh.shift_id = sh.shift_id;

-- 6. Count delivered purchase orders per supplier (LEFT JOIN with GROUP BY)
SELECT s.supplier_id, s.supplier_name, COUNT(po.purchase_order_id) AS DeliveredOrders
FROM Suppliers s
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id AND po.order_status = 'Delivered'
GROUP BY s.supplier_id, s.supplier_name;

-- 7. Right join vendors with contracts to list all contracts and vendor
SELECT v.vendor_name, vc.contract_name
FROM Vendors v
RIGHT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id;

-- 8. Self join inventory to compare quantities on consecutive batches
SELECT i1.product_id, i1.batch_number AS Batch1, i1.quantity_in_stock AS Qty1, i2.batch_number AS Batch2, i2.quantity_in_stock AS Qty2
FROM Inventory i1
JOIN Inventory i2 ON i1.product_id = i2.product_id
WHERE i1.batch_number < i2.batch_number;  -- Simplified for consecutive

-- 9. Full outer join customers and prescriptions using UNION
SELECT c.customer_id, c.customer_name, pr.prescription_id
FROM Customers c
LEFT JOIN Prescriptions pr ON c.customer_id = pr.customer_id
UNION
SELECT c.customer_id, c.customer_name, pr.prescription_id
FROM Customers c
RIGHT JOIN Prescriptions pr ON c.customer_id = pr.customer_id;

-- 10. Self join drug interactions to find chains (simplified)
SELECT di1.interaction_id AS ID1, di2.interaction_id AS ID2, di1.severity
FROM Drug_Interactions di1
JOIN Drug_Interactions di2 ON di1.product_id2 = di2.product_id1 AND di1.interaction_id <> di2.interaction_id;

-- ===============================================
-- Subqueries - 10 queries
-- ===============================================
-- 1. Products with unit_price above average
SELECT product_id, product_name, unit_price
FROM Products
WHERE unit_price > (SELECT AVG(unit_price) FROM Products);

-- 2. Suppliers with orders above the average total_amount
SELECT supplier_id, supplier_name
FROM Suppliers s
WHERE (SELECT AVG(total_amount) FROM Purchase_Orders po WHERE po.supplier_id = s.supplier_id) > (SELECT AVG(total_amount) FROM Purchase_Orders);

-- 3. Customers with more prescriptions than average
SELECT customer_id, customer_name
FROM Customers c
WHERE (SELECT COUNT(*) FROM Prescriptions pr WHERE pr.customer_id = c.customer_id) >
      (SELECT AVG(cnt) FROM (SELECT COUNT(*) AS cnt FROM Prescriptions GROUP BY customer_id) AS sub);

-- 4. Employees who have at least one shift assigned
SELECT employee_id, employee_name
FROM Employees e
WHERE EXISTS (
    SELECT 1 FROM Employee_Shifts es
    WHERE es.employee_id = e.employee_id
);

-- 5. Categories with no products
SELECT category_id, category_name
FROM ProductCategories pc
WHERE NOT EXISTS (SELECT 1 FROM Products p WHERE p.category_id = pc.category_id);

-- 6. Sales with total_amount more than all small sales
SELECT sale_id, total_amount
FROM Sales
WHERE total_amount > ALL (SELECT total_amount FROM Sales WHERE total_amount < 50);

-- 7. Products where inventory quantity exceeds reorder level average
SELECT p.product_id, p.product_name
FROM Products p
WHERE (SELECT AVG(quantity_in_stock) FROM Inventory i WHERE i.product_id = p.product_id) > (SELECT AVG(reorder_level) FROM Inventory);

-- 8. Customers with multiple prescriptions
SELECT customer_id, customer_name
FROM Customers c
WHERE (SELECT COUNT(DISTINCT prescription_id) FROM Prescriptions pr WHERE pr.customer_id = c.customer_id) > 1;

-- 9. Inventory with cost_price above manufacturer average
SELECT i.inventory_id, p.product_name, i.cost_price
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.cost_price > (
    SELECT AVG(i2.cost_price) FROM Inventory i2
    JOIN Products p2 ON i2.product_id = p2.product_id
    WHERE p2.manufacturer_id = p.manufacturer_id
);

-- 10. Vendors with contracts ending before all their expenses
SELECT v.vendor_id, v.vendor_name
FROM Vendors v
WHERE (SELECT MIN(end_date) FROM Vendor_Contracts vc WHERE vc.vendor_id = v.vendor_id) < ALL (SELECT expense_date FROM Expenses e WHERE e.vendor_id = v.vendor_id);

-- ===============================================
-- Functions - 10 queries
-- ===============================================
-- 1. Total number of products
SELECT COUNT(*) AS TotalProducts
FROM Products;

-- 2. Average unit_price by category
SELECT category_id, AVG(unit_price) AS AvgPrice
FROM Products
GROUP BY category_id;

-- 3. Total quantity of low stock items
SELECT SUM(quantity_in_stock) AS TotalLowStock
FROM Inventory
WHERE quantity_in_stock < reorder_level;

-- 4. Maximum expiry_date in inventory
SELECT MAX(expiry_date) AS MaxExpiry
FROM Inventory;

-- 5. Length of the longest product_name
SELECT MAX(LENGTH(product_name)) AS MaxNameLength
FROM Products;

-- 6. Uppercase supplier names
SELECT UPPER(supplier_name) AS SupplierUpper
FROM Suppliers;

-- 7. Lowercase customer emails
SELECT LOWER(email) AS EmailLower
FROM Customers;

-- 8. Length of each prescription's notes
SELECT prescription_id, LENGTH(notes) AS NotesLength
FROM Prescriptions
WHERE notes IS NOT NULL;

-- 9. Count of sales by payment_status
SELECT payment_status, COUNT(*) AS SaleCount
FROM Sales
GROUP BY payment_status;

-- 10. Average days supply in prescription items
SELECT AVG(days_supply) AS AvgDaysSupply
FROM Prescription_Items
WHERE days_supply > 0;

-- ===============================================
-- Views & CTE - 10 queries
-- ===============================================
-- 1. Create a view for product ID, name, and price
CREATE VIEW ProductInfo AS
SELECT product_id, product_name, unit_price
FROM Products;

-- 2. Select all from ProductInfo view
SELECT * FROM ProductInfo;

-- 3. Create a view summarizing inventory basic details
CREATE VIEW InventorySummary AS
SELECT inventory_id, product_id, quantity_in_stock, expiry_date
FROM Inventory;

-- 4. Select low stock using InventorySummary view
SELECT * FROM InventorySummary
WHERE quantity_in_stock < 50;

-- 5. CTE to get item count per prescription
WITH ItemCount AS (
    SELECT prescription_id, COUNT(*) AS TotalItems
    FROM Prescription_Items
    GROUP BY prescription_id
)
SELECT pr.prescription_id, pr.total_amount, ic.TotalItems
FROM Prescriptions pr
JOIN ItemCount ic ON pr.prescription_id = ic.prescription_id;

-- 6. Recursive CTE to generate numbers 1 through 5
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 5
)
SELECT * FROM seq;

-- 7. CTE to calculate total sales per customer in 2025
WITH YearlySales AS (
    SELECT customer_id, SUM(total_amount) AS Sales2025
    FROM Sales
    WHERE YEAR(sale_date) = 2025
    GROUP BY customer_id
)
SELECT customer_id, Sales2025 FROM YearlySales;

-- 8. Create a view for high-value sales above 100
CREATE VIEW HighValueSales AS
SELECT sale_id, customer_id, total_amount
FROM Sales
WHERE total_amount > 100;

-- 9. Select from HighValueSales view
SELECT * FROM HighValueSales;

-- 10. Recursive CTE to calculate running total 1 to 5
WITH RECURSIVE nums AS (
    SELECT 1 AS num, 1 AS sum_val
    UNION ALL
    SELECT num+1, sum_val + num + 1 FROM nums WHERE num < 5
)
SELECT num, sum_val FROM nums;

-- ===============================================
-- Stored Procedures - 5 queries
-- ===============================================
-- 1. Procedure to add a new product
DELIMITER $$
CREATE PROCEDURE AddProduct(
    IN p_product_name VARCHAR(100), IN p_generic_name VARCHAR(100),
    IN p_manufacturer_id INT, IN p_category_id INT, IN p_strength VARCHAR(50),
    IN p_dosage_form VARCHAR(50), IN p_unit_price DECIMAL(10,2), IN p_barcode VARCHAR(50)
)
BEGIN
    INSERT INTO Products(product_name, generic_name, manufacturer_id, category_id, strength, dosage_form, unit_price, barcode)
    VALUES(p_product_name, p_generic_name, p_manufacturer_id, p_category_id, p_strength, p_dosage_form, p_unit_price, p_barcode);
END $$
DELIMITER ;

-- 2. Procedure to update a prescription's status
DELIMITER $$
CREATE PROCEDURE UpdatePrescriptionStatus(
    IN p_prescription_id INT, IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Prescriptions
    SET status = p_status
    WHERE prescription_id = p_prescription_id;
END $$
DELIMITER ;

-- 3. Procedure to delete an inventory record by ID
DELIMITER $$
CREATE PROCEDURE DeleteInventory(
    IN p_inventory_id INT
)
BEGIN
    DELETE FROM Inventory
    WHERE inventory_id = p_inventory_id;
END $$
DELIMITER ;

-- 4. Procedure to get total sales for a customer
DELIMITER $$
CREATE PROCEDURE GetCustomerSalesTotal(
    IN p_customer_id INT, OUT p_Total DECIMAL(12,2)
)
BEGIN
    SELECT SUM(total_amount) INTO p_Total
    FROM Sales
    WHERE customer_id = p_customer_id;
END $$
DELIMITER ;

-- 5. Procedure to insert a new notification
DELIMITER $$
CREATE PROCEDURE AddNotification(
    IN p_notification_type VARCHAR(50), IN p_related_id INT,
    IN p_message TEXT, IN p_priority VARCHAR(20), IN p_created_for INT, IN p_created_by INT
)
BEGIN
    INSERT INTO Notifications(notification_type, related_id, message, priority, status, created_for, created_by)
    VALUES (p_notification_type, p_related_id, p_message, p_priority, 'Pending', p_created_for, p_created_by);
END $$
DELIMITER ;

-- ===============================================
-- Window Functions - 5 queries
-- ===============================================
-- 1. Assign row numbers to products by descending unit_price
SELECT product_id, product_name, unit_price,
ROW_NUMBER() OVER (ORDER BY unit_price DESC) AS RowNum
FROM Products;

-- 2. Rank inventory by quantity_in_stock (highest gets rank 1)
SELECT inventory_id, product_id, quantity_in_stock,
RANK() OVER (ORDER BY quantity_in_stock DESC) AS StockRank
FROM Inventory;

-- 3. Show each sale with the next sale date (per customer)
SELECT sale_id, customer_id, sale_date,
LEAD(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) AS NextSaleDate
FROM Sales;

-- 4. Show each prescription with the previous prescription date (same customer)
SELECT prescription_id, customer_id, prescription_date,
LAG(prescription_date) OVER (PARTITION BY customer_id ORDER BY prescription_date) AS PrevPrescriptionDate
FROM Prescriptions;

-- 5. Rank customers within each insurance_provider by prescription count
SELECT c.customer_id, c.insurance_provider, COUNT(pr.prescription_id) AS PrescCount,
RANK() OVER (PARTITION BY c.insurance_provider ORDER BY COUNT(pr.prescription_id) DESC) AS ProviderRank
FROM Customers c
LEFT JOIN Prescriptions pr ON c.customer_id = pr.customer_id
GROUP BY c.customer_id, c.insurance_provider;

-- ===============================================
-- Transactions - 5 queries
-- ===============================================
-- 1. Transaction: update product price and inventory stock, then commit
START TRANSACTION;
UPDATE Products SET unit_price = unit_price * 1.1 WHERE product_id = 21;
UPDATE Inventory SET quantity_in_stock = quantity_in_stock + 100 WHERE product_id = 21;
COMMIT;

-- 2. Transaction: attempt update and delete, then rollback
START TRANSACTION;
UPDATE Customers SET phone = '+1-555-9999' WHERE customer_id = 1;
DELETE FROM Customers WHERE customer_id = 1;
ROLLBACK;

-- 3. Transaction with savepoint: partial rollback example
START TRANSACTION;
UPDATE Prescriptions SET status = 'Filled' WHERE prescription_id = 1;
SAVEPOINT sp1;
UPDATE Prescriptions SET status = 'Cancelled' WHERE prescription_id = 1;
ROLLBACK TO sp1;
COMMIT;

-- 4. Transaction: delete adjustments with savepoint and rollback to it
START TRANSACTION;
DELETE FROM Inventory_Adjustments WHERE adjustment_id = 1;
SAVEPOINT afterDelete;
DELETE FROM Inventory_Adjustments WHERE adjustment_id = 2;
ROLLBACK TO afterDelete;
COMMIT;

-- 5. Transaction: mark sale completed and insert payment record
START TRANSACTION;
UPDATE Sales SET payment_status = 'Completed' WHERE sale_id = 101;
INSERT INTO Payments(payment_id, payment_type, reference_id, payment_date, amount, payment_method, transaction_id, status, notes, processed_by)
VALUES (101, 'Sale', 101, CURDATE(), 17.59, 'Cash', 'TXN101', 'Completed', 'Cash payment', 101);
COMMIT;

-- ===============================================
-- Triggers - 5 queries
-- ===============================================
-- Create table for logging product deletions (used by trigger)
CREATE TABLE IF NOT EXISTS ProductDeletions (
    ProductID INT,
    DeletedDate DATETIME
);

-- 1. After insert on Sale_Items: update inventory stock
DELIMITER $$
CREATE TRIGGER after_sale_item_insert
AFTER INSERT ON Sale_Items
FOR EACH ROW
BEGIN
    UPDATE Inventory
    SET quantity_in_stock = quantity_in_stock - NEW.quantity
    WHERE product_id = NEW.product_id;
END $$
DELIMITER ;

-- 2. Before update on Inventory: prevent negative stock
DELIMITER $$
CREATE TRIGGER before_inventory_update
BEFORE UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity_in_stock < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock quantity cannot be negative';
    END IF;
END $$
DELIMITER ;

-- 3. After delete on Products: log deleted product ID
DELIMITER $$
CREATE TRIGGER after_product_delete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductDeletions(ProductID, DeletedDate)
    VALUES (OLD.product_id, NOW());
END $$
DELIMITER ;

-- 4. After update on Payments: update sale status
DELIMITER $$
CREATE TRIGGER after_payment_update_pharm
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed' THEN
        UPDATE Sales
        SET payment_status = 'Completed'
        WHERE sale_id = NEW.reference_id;
    END IF;
END $$
DELIMITER ;

-- 5. Before insert on Prescription_Items: set created_date to today if not provided
DELIMITER $$
CREATE TRIGGER before_prescription_item_insert
BEFORE INSERT ON Prescription_Items
FOR EACH ROW
BEGIN
    IF NEW.created_date IS NULL THEN
        SET NEW.created_date = CURRENT_TIMESTAMP;
    END IF;
END $$
DELIMITER ;
