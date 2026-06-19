-- ====================================================================
-- PHASE-4: VIEWS, STORED PROCEDURES, WINDOW FUNCTIONS, TRIGGERS
-- PHARMACY INVENTORY MANAGEMENT SYSTEM
-- ====================================================================

-- ====================================================================
-- TABLE: Suppliers
-- ====================================================================

-- Create a view to display all supplier records
DROP VIEW IF EXISTS vw_suppliers;
CREATE VIEW vw_suppliers AS SELECT * FROM Suppliers;

-- Retrieve all records from the suppliers view
SELECT * FROM vw_suppliers;

-- Create a stored procedure to fetch all suppliers
DROP PROCEDURE IF EXISTS Get_suppliers;
DELIMITER //
CREATE PROCEDURE Get_suppliers()
BEGIN
    SELECT * FROM Suppliers;
END //
DELIMITER ;

-- Assign sequential row numbers to suppliers ordered by supplier_id
SELECT supplier_id, supplier_name, ROW_NUMBER() OVER(ORDER BY supplier_id) AS RowNum FROM Suppliers;

-- Create trigger to set a message variable after inserting a supplier
DROP TRIGGER IF EXISTS trg_suppliers_insert;
DELIMITER //
CREATE TRIGGER trg_suppliers_insert
AFTER INSERT ON Suppliers
FOR EACH ROW
BEGIN
    SET @msg = 'Supplier Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Categories
-- ====================================================================

-- Create a view to display all category records
DROP VIEW IF EXISTS vw_categories;
CREATE VIEW vw_categories AS SELECT * FROM Categories;

-- Retrieve all records from the categories view
SELECT * FROM vw_categories;

-- Create a stored procedure to fetch all categories
DROP PROCEDURE IF EXISTS Get_categories;
DELIMITER //
CREATE PROCEDURE Get_categories()
BEGIN
    SELECT * FROM Categories;
END //
DELIMITER ;

-- Assign sequential row numbers to categories ordered by category_id
SELECT category_id, category_name, ROW_NUMBER() OVER(ORDER BY category_id) AS RowNum FROM Categories;

-- Create trigger to set a message variable after inserting a category
DROP TRIGGER IF EXISTS trg_categories_insert;
DELIMITER //
CREATE TRIGGER trg_categories_insert
AFTER INSERT ON Categories
FOR EACH ROW
BEGIN
    SET @msg = 'Category Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Manufacturers
-- ====================================================================

-- Create a view to display all manufacturer records
DROP VIEW IF EXISTS vw_manufacturers;
CREATE VIEW vw_manufacturers AS SELECT * FROM Manufacturers;

-- Retrieve all records from the manufacturers view
SELECT * FROM vw_manufacturers;

-- Create a stored procedure to fetch all manufacturers
DROP PROCEDURE IF EXISTS Get_manufacturers;
DELIMITER //
CREATE PROCEDURE Get_manufacturers()
BEGIN
    SELECT * FROM Manufacturers;
END //
DELIMITER ;

-- Assign sequential row numbers to manufacturers ordered by manufacturer_id
SELECT manufacturer_id, manufacturer_name, ROW_NUMBER() OVER(ORDER BY manufacturer_id) AS RowNum FROM Manufacturers;

-- Create trigger to set a message variable after inserting a manufacturer
DROP TRIGGER IF EXISTS trg_manufacturers_insert;
DELIMITER //
CREATE TRIGGER trg_manufacturers_insert
AFTER INSERT ON Manufacturers
FOR EACH ROW
BEGIN
    SET @msg = 'Manufacturer Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Products
-- ====================================================================

-- Create a view to display all product records
DROP VIEW IF EXISTS vw_products;
CREATE VIEW vw_products AS SELECT * FROM Products;

-- Retrieve all records from the products view
SELECT * FROM vw_products;

-- Create a stored procedure to fetch all products
DROP PROCEDURE IF EXISTS Get_products;
DELIMITER //
CREATE PROCEDURE Get_products()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;

-- Assign sequential row numbers to products ordered by product_id
SELECT product_id, product_name, ROW_NUMBER() OVER(ORDER BY product_id) AS RowNum FROM Products;

-- Create trigger to set a message variable after inserting a product
DROP TRIGGER IF EXISTS trg_products_insert;
DELIMITER //
CREATE TRIGGER trg_products_insert
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    SET @msg = 'Product Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Inventory
-- ====================================================================

-- Create a view to display all inventory records
DROP VIEW IF EXISTS vw_inventory;
CREATE VIEW vw_inventory AS SELECT * FROM Inventory;

-- Retrieve all records from the inventory view
SELECT * FROM vw_inventory;

-- Create a stored procedure to fetch all inventory items
DROP PROCEDURE IF EXISTS Get_inventory;
DELIMITER //
CREATE PROCEDURE Get_inventory()
BEGIN
    SELECT * FROM Inventory;
END //
DELIMITER ;

-- Assign sequential row numbers to inventory items ordered by inventory_id
SELECT inventory_id, product_id, ROW_NUMBER() OVER(ORDER BY inventory_id) AS RowNum FROM Inventory;

-- Create trigger to set a message variable after inserting an inventory record
DROP TRIGGER IF EXISTS trg_inventory_insert;
DELIMITER //
CREATE TRIGGER trg_inventory_insert
AFTER INSERT ON Inventory
FOR EACH ROW
BEGIN
    SET @msg = 'Inventory Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Customers
-- ====================================================================

-- Create a view to display all customer records
DROP VIEW IF EXISTS vw_customers;
CREATE VIEW vw_customers AS SELECT * FROM Customers;

-- Retrieve all records from the customers view
SELECT * FROM vw_customers;

-- Create a stored procedure to fetch all customers
DROP PROCEDURE IF EXISTS Get_customers;
DELIMITER //
CREATE PROCEDURE Get_customers()
BEGIN
    SELECT * FROM Customers;
END //
DELIMITER ;

-- Assign sequential row numbers to customers ordered by customer_id
SELECT customer_id, customer_name, ROW_NUMBER() OVER(ORDER BY customer_id) AS RowNum FROM Customers;

-- Create trigger to set a message variable after inserting a customer
DROP TRIGGER IF EXISTS trg_customers_insert;
DELIMITER //
CREATE TRIGGER trg_customers_insert
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
    SET @msg = 'Customer Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Prescriptions
-- ====================================================================

-- Create a view to display all prescription records
DROP VIEW IF EXISTS vw_prescriptions;
CREATE VIEW vw_prescriptions AS SELECT * FROM Prescriptions;

-- Retrieve all records from the prescriptions view
SELECT * FROM vw_prescriptions;

-- Create a stored procedure to fetch all prescriptions
DROP PROCEDURE IF EXISTS Get_prescriptions;
DELIMITER //
CREATE PROCEDURE Get_prescriptions()
BEGIN
    SELECT * FROM Prescriptions;
END //
DELIMITER ;

-- Assign sequential row numbers to prescriptions ordered by prescription_id
SELECT prescription_id, customer_id, ROW_NUMBER() OVER(ORDER BY prescription_id) AS RowNum FROM Prescriptions;

-- Create trigger to set a message variable after inserting a prescription
DROP TRIGGER IF EXISTS trg_prescriptions_insert;
DELIMITER //
CREATE TRIGGER trg_prescriptions_insert
AFTER INSERT ON Prescriptions
FOR EACH ROW
BEGIN
    SET @msg = 'Prescription Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Prescription_Items
-- ====================================================================

-- Create a view to display all prescription item records
DROP VIEW IF EXISTS vw_prescription_items;
CREATE VIEW vw_prescription_items AS SELECT * FROM Prescription_Items;

-- Retrieve all records from the prescription_items view
SELECT * FROM vw_prescription_items;

-- Create a stored procedure to fetch all prescription items
DROP PROCEDURE IF EXISTS Get_prescription_items;
DELIMITER //
CREATE PROCEDURE Get_prescription_items()
BEGIN
    SELECT * FROM Prescription_Items;
END //
DELIMITER ;

-- Assign sequential row numbers to prescription items ordered by prescription_item_id
SELECT prescription_item_id, prescription_id, ROW_NUMBER() OVER(ORDER BY prescription_item_id) AS RowNum FROM Prescription_Items;

-- Create trigger to set a message variable after inserting a prescription item
DROP TRIGGER IF EXISTS trg_prescription_items_insert;
DELIMITER //
CREATE TRIGGER trg_prescription_items_insert
AFTER INSERT ON Prescription_Items
FOR EACH ROW
BEGIN
    SET @msg = 'Prescription Item Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Purchase_Orders
-- ====================================================================

-- Create a view to display all purchase order records
DROP VIEW IF EXISTS vw_purchase_orders;
CREATE VIEW vw_purchase_orders AS SELECT * FROM Purchase_Orders;

-- Retrieve all records from the purchase_orders view
SELECT * FROM vw_purchase_orders;

-- Create a stored procedure to fetch all purchase orders
DROP PROCEDURE IF EXISTS Get_purchase_orders;
DELIMITER //
CREATE PROCEDURE Get_purchase_orders()
BEGIN
    SELECT * FROM Purchase_Orders;
END //
DELIMITER ;

-- Assign sequential row numbers to purchase orders ordered by purchase_order_id
SELECT purchase_order_id, supplier_id, ROW_NUMBER() OVER(ORDER BY purchase_order_id) AS RowNum FROM Purchase_Orders;

-- Create trigger to set a message variable after inserting a purchase order
DROP TRIGGER IF EXISTS trg_purchase_orders_insert;
DELIMITER //
CREATE TRIGGER trg_purchase_orders_insert
AFTER INSERT ON Purchase_Orders
FOR EACH ROW
BEGIN
    SET @msg = 'Purchase Order Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Purchase_Order_Items
-- ====================================================================

-- Create a view to display all purchase order item records
DROP VIEW IF EXISTS vw_purchase_order_items;
CREATE VIEW vw_purchase_order_items AS SELECT * FROM Purchase_Order_Items;

-- Retrieve all records from the purchase_order_items view
SELECT * FROM vw_purchase_order_items;

-- Create a stored procedure to fetch all purchase order items
DROP PROCEDURE IF EXISTS Get_purchase_order_items;
DELIMITER //
CREATE PROCEDURE Get_purchase_order_items()
BEGIN
    SELECT * FROM Purchase_Order_Items;
END //
DELIMITER ;

-- Assign sequential row numbers to purchase order items ordered by purchase_order_item_id
SELECT purchase_order_item_id, purchase_order_id, ROW_NUMBER() OVER(ORDER BY purchase_order_item_id) AS RowNum FROM Purchase_Order_Items;

-- Create trigger to set a message variable after inserting a purchase order item
DROP TRIGGER IF EXISTS trg_purchase_order_items_insert;
DELIMITER //
CREATE TRIGGER trg_purchase_order_items_insert
AFTER INSERT ON Purchase_Order_Items
FOR EACH ROW
BEGIN
    SET @msg = 'Purchase Order Item Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Sales
-- ====================================================================

-- Create a view to display all sales records
DROP VIEW IF EXISTS vw_sales;
CREATE VIEW vw_sales AS SELECT * FROM Sales;

-- Retrieve all records from the sales view
SELECT * FROM vw_sales;

-- Create a stored procedure to fetch all sales
DROP PROCEDURE IF EXISTS Get_sales;
DELIMITER //
CREATE PROCEDURE Get_sales()
BEGIN
    SELECT * FROM Sales;
END //
DELIMITER ;

-- Assign sequential row numbers to sales ordered by sale_id
SELECT sale_id, customer_id, ROW_NUMBER() OVER(ORDER BY sale_id) AS RowNum FROM Sales;

-- Create trigger to set a message variable after inserting a sale
DROP TRIGGER IF EXISTS trg_sales_insert;
DELIMITER //
CREATE TRIGGER trg_sales_insert
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
    SET @msg = 'Sales Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Sale_Items
-- ====================================================================

-- Create a view to display all sale item records
DROP VIEW IF EXISTS vw_sale_items;
CREATE VIEW vw_sale_items AS SELECT * FROM Sale_Items;

-- Retrieve all records from the sale_items view
SELECT * FROM vw_sale_items;

-- Create a stored procedure to fetch all sale items
DROP PROCEDURE IF EXISTS Get_sale_items;
DELIMITER //
CREATE PROCEDURE Get_sale_items()
BEGIN
    SELECT * FROM Sale_Items;
END //
DELIMITER ;

-- Assign sequential row numbers to sale items ordered by sale_item_id
SELECT sale_item_id, sale_id, ROW_NUMBER() OVER(ORDER BY sale_item_id) AS RowNum FROM Sale_Items;

-- Create trigger to set a message variable after inserting a sale item
DROP TRIGGER IF EXISTS trg_sale_items_insert;
DELIMITER //
CREATE TRIGGER trg_sale_items_insert
AFTER INSERT ON Sale_Items
FOR EACH ROW
BEGIN
    SET @msg = 'Sale Item Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Payments
-- ====================================================================

-- Create a view to display all payment records
DROP VIEW IF EXISTS vw_payments;
CREATE VIEW vw_payments AS SELECT * FROM Payments;

-- Retrieve all records from the payments view
SELECT * FROM vw_payments;

-- Create a stored procedure to fetch all payments
DROP PROCEDURE IF EXISTS Get_payments;
DELIMITER //
CREATE PROCEDURE Get_payments()
BEGIN
    SELECT * FROM Payments;
END //
DELIMITER ;

-- Assign sequential row numbers to payments ordered by payment_id
SELECT payment_id, payment_type, ROW_NUMBER() OVER(ORDER BY payment_id) AS RowNum FROM Payments;

-- Create trigger to set a message variable after inserting a payment
DROP TRIGGER IF EXISTS trg_payments_insert;
DELIMITER //
CREATE TRIGGER trg_payments_insert
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    SET @msg = 'Payment Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Drug_Interactions
-- ====================================================================

-- Create a view to display all drug interaction records
DROP VIEW IF EXISTS vw_drug_interactions;
CREATE VIEW vw_drug_interactions AS SELECT * FROM Drug_Interactions;

-- Retrieve all records from the drug_interactions view
SELECT * FROM vw_drug_interactions;

-- Create a stored procedure to fetch all drug interactions
DROP PROCEDURE IF EXISTS Get_drug_interactions;
DELIMITER //
CREATE PROCEDURE Get_drug_interactions()
BEGIN
    SELECT * FROM Drug_Interactions;
END //
DELIMITER ;

-- Assign sequential row numbers to drug interactions ordered by interaction_id
SELECT interaction_id, severity, ROW_NUMBER() OVER(ORDER BY interaction_id) AS RowNum FROM Drug_Interactions;

-- Create trigger to set a message variable after inserting a drug interaction
DROP TRIGGER IF EXISTS trg_drug_interactions_insert;
DELIMITER //
CREATE TRIGGER trg_drug_interactions_insert
AFTER INSERT ON Drug_Interactions
FOR EACH ROW
BEGIN
    SET @msg = 'Drug Interaction Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- TABLE: Inventory_Adjustments
-- ====================================================================

-- Create a view to display all inventory adjustment records
DROP VIEW IF EXISTS vw_inventory_adjustments;
CREATE VIEW vw_inventory_adjustments AS SELECT * FROM Inventory_Adjustments;

-- Retrieve all records from the inventory_adjustments view
SELECT * FROM vw_inventory_adjustments;

-- Create a stored procedure to fetch all inventory adjustments
DROP PROCEDURE IF EXISTS Get_inventory_adjustments;
DELIMITER //
CREATE PROCEDURE Get_inventory_adjustments()
BEGIN
    SELECT * FROM Inventory_Adjustments;
END //
DELIMITER ;

-- Assign sequential row numbers to inventory adjustments ordered by adjustment_id
SELECT adjustment_id, adjustment_type, ROW_NUMBER() OVER(ORDER BY adjustment_id) AS RowNum FROM Inventory_Adjustments;

-- Create trigger to set a message variable after inserting an inventory adjustment
DROP TRIGGER IF EXISTS trg_inventory_adjustments_insert;
DELIMITER //
CREATE TRIGGER trg_inventory_adjustments_insert
AFTER INSERT ON Inventory_Adjustments
FOR EACH ROW
BEGIN
    SET @msg = 'Inventory Adjustment Record Inserted';
END //
DELIMITER ;

-- ====================================================================
-- END OF PHASE-4
-- ====================================================================
