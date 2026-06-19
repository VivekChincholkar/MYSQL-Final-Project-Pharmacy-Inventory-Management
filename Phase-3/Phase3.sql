-- ============================================================================
-- PHASE-3 : JOINS & SUBQUERIES (5 QUERIES FOR EACH TABLE)
-- PHARMACY INVENTORY MANAGEMENT SYSTEM
-- ============================================================================

-- ============================================================================
-- TABLE 1: SUPPLIERS
-- ============================================================================

-- Retrieve all suppliers with their purchase order details and amounts
SELECT s.supplier_name, po.purchase_order_id, po.total_amount
FROM Suppliers s
JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id;

-- Count total purchase orders for each supplier (including suppliers with zero orders)
SELECT s.supplier_name, COUNT(po.purchase_order_id) AS total_orders
FROM Suppliers s
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_name;

-- Find suppliers who have purchase orders exceeding $5000
SELECT supplier_name
FROM Suppliers
WHERE supplier_id IN
(SELECT supplier_id FROM Purchase_Orders WHERE total_amount > 5000);

-- List suppliers who have at least one purchase order (using EXISTS for efficiency)
SELECT supplier_name
FROM Suppliers s
WHERE EXISTS
(SELECT 1 FROM Purchase_Orders po WHERE po.supplier_id=s.supplier_id);

-- Find the supplier with the highest single purchase order amount
SELECT supplier_name
FROM Suppliers
WHERE supplier_id=
(SELECT supplier_id FROM Purchase_Orders ORDER BY total_amount DESC LIMIT 1);

-- ============================================================================
-- TABLE 2: CATEGORIES
-- ============================================================================

-- Display all products with their category names
SELECT c.category_name,p.product_name
FROM Categories c
JOIN Products p ON c.category_id=p.category_id;

-- Count the number of products in each category (including empty categories)
SELECT c.category_name,COUNT(p.product_id) total_products
FROM Categories c
LEFT JOIN Products p ON c.category_id=p.category_id
GROUP BY c.category_name;

-- Find categories that contain at least one product
SELECT category_name
FROM Categories
WHERE category_id IN
(SELECT category_id FROM Products);

-- Find the category with the most products
SELECT category_name
FROM Categories
WHERE category_id=
(SELECT category_id FROM Products GROUP BY category_id
ORDER BY COUNT(*) DESC LIMIT 1);

-- Retrieve all category details for categories that have products
SELECT *
FROM Categories c
WHERE EXISTS
(SELECT 1 FROM Products p WHERE p.category_id=c.category_id);

-- ============================================================================
-- TABLE 3: MANUFACTURERS
-- ============================================================================

-- List all products with their manufacturer names
SELECT m.manufacturer_name,p.product_name
FROM Manufacturers m
JOIN Products p ON m.manufacturer_id=p.manufacturer_id;

-- Count products manufactured by each manufacturer (including those with no products)
SELECT m.manufacturer_name,COUNT(p.product_id) total_products
FROM Manufacturers m
LEFT JOIN Products p ON m.manufacturer_id=p.manufacturer_id
GROUP BY m.manufacturer_name;

-- Find manufacturers who have products in the catalog
SELECT manufacturer_name
FROM Manufacturers
WHERE manufacturer_id IN
(SELECT manufacturer_id FROM Products);

-- Find the manufacturer with the most products in catalog
SELECT manufacturer_name
FROM Manufacturers
WHERE manufacturer_id=
(SELECT manufacturer_id FROM Products
GROUP BY manufacturer_id
ORDER BY COUNT(*) DESC LIMIT 1);

-- Retrieve all manufacturer details for those who have products
SELECT *
FROM Manufacturers m
WHERE EXISTS
(SELECT 1 FROM Products p
WHERE p.manufacturer_id=m.manufacturer_id);

-- ============================================================================
-- TABLE 4: PRODUCTS
-- ============================================================================

-- Display products with their manufacturer information
SELECT p.product_name,m.manufacturer_name
FROM Products p
JOIN Manufacturers m
ON p.manufacturer_id=m.manufacturer_id;

-- Show products with their category classification
SELECT p.product_name,c.category_name
FROM Products p
JOIN Categories c
ON p.category_id=c.category_id;

-- Find products priced above the average unit price
SELECT product_name
FROM Products
WHERE unit_price>
(SELECT AVG(unit_price) FROM Products);

-- Display products with their current stock levels
SELECT p.product_name,i.quantity_in_stock
FROM Products p
JOIN Inventory i
ON p.product_id=i.product_id;

-- Find products that have been sold at least once
SELECT product_name
FROM Products
WHERE product_id IN
(SELECT product_id FROM Sale_Items);

-- ============================================================================
-- TABLE 5: INVENTORY
-- ============================================================================

-- Show inventory levels with product names
SELECT p.product_name,i.quantity_in_stock
FROM Inventory i
JOIN Products p
ON i.product_id=p.product_id;

-- Find inventory items with below-average stock levels
SELECT *
FROM Inventory
WHERE quantity_in_stock<
(SELECT AVG(quantity_in_stock) FROM Inventory);

-- Display products with their expiration dates for rotation management
SELECT p.product_name,i.expiry_date
FROM Inventory i
JOIN Products p
ON i.product_id=p.product_id;

-- Find inventory items that have undergone adjustments
SELECT *
FROM Inventory
WHERE product_id IN
(SELECT product_id FROM Inventory_Adjustments);

-- Find the product with the highest selling price in inventory
SELECT p.product_name,i.selling_price
FROM Products p
JOIN Inventory i
ON p.product_id=i.product_id
WHERE i.selling_price=
(SELECT MAX(selling_price) FROM Inventory);

-- ============================================================================
-- TABLE 6: CUSTOMERS
-- ============================================================================

-- List customers with their prescription IDs
SELECT c.customer_name,p.prescription_id
FROM Customers c
JOIN Prescriptions p
ON c.customer_id=p.customer_id;

-- Show customers with their sales transactions and amounts
SELECT c.customer_name,s.sale_id,s.total_amount
FROM Customers c
JOIN Sales s
ON c.customer_id=s.customer_id;

-- Find customers who have made at least one purchase
SELECT customer_name
FROM Customers
WHERE customer_id IN
(SELECT customer_id FROM Sales);

-- Find customers who have never had a prescription
SELECT customer_name
FROM Customers
WHERE customer_id NOT IN
(SELECT customer_id FROM Prescriptions);

-- Find the customer with the highest single purchase amount
SELECT *
FROM Customers
WHERE customer_id=
(SELECT customer_id FROM Sales
ORDER BY total_amount DESC LIMIT 1);

-- ============================================================================
-- TABLE 7: PRESCRIPTIONS
-- ============================================================================

-- Display prescriptions with customer names
SELECT p.prescription_id,c.customer_name
FROM Prescriptions p
JOIN Customers c
ON p.customer_id=c.customer_id;

-- Count the number of items in each prescription
SELECT p.prescription_id,COUNT(pi.prescription_item_id) item_count
FROM Prescriptions p
JOIN Prescription_Items pi
ON p.prescription_id=pi.prescription_id
GROUP BY p.prescription_id;

-- Find prescriptions with above-average total amounts
SELECT *
FROM Prescriptions
WHERE total_amount>
(SELECT AVG(total_amount) FROM Prescriptions);

-- Validate all prescriptions have valid customer references
SELECT *
FROM Prescriptions
WHERE customer_id IN
(SELECT customer_id FROM Customers);

-- Find the prescription with the highest total amount
SELECT *
FROM Prescriptions
WHERE total_amount=
(SELECT MAX(total_amount) FROM Prescriptions);

-- ============================================================================
-- TABLE 8: PRESCRIPTION_ITEMS
-- ============================================================================

-- Show prescription items with product names
SELECT pi.prescription_item_id,p.product_name
FROM Prescription_Items pi
JOIN Products p
ON pi.product_id=p.product_id;

-- Link prescription items to their parent prescriptions
SELECT pi.prescription_item_id,pr.prescription_id
FROM Prescription_Items pi
JOIN Prescriptions pr
ON pi.prescription_id=pr.prescription_id;

-- Find prescription items with above-average quantities
SELECT *
FROM Prescription_Items
WHERE quantity>
(SELECT AVG(quantity) FROM Prescription_Items);

-- Validate all prescription items reference valid products
SELECT *
FROM Prescription_Items
WHERE product_id IN
(SELECT product_id FROM Products);

-- Find the prescription item with the highest total price
SELECT *
FROM Prescription_Items
WHERE total_price=
(SELECT MAX(total_price) FROM Prescription_Items);

-- ============================================================================
-- TABLE 9: PURCHASE_ORDERS
-- ============================================================================

-- Display purchase orders with supplier names
SELECT po.purchase_order_id,s.supplier_name
FROM Purchase_Orders po
JOIN Suppliers s
ON po.supplier_id=s.supplier_id;

-- Calculate total purchase amount spent with each supplier
SELECT s.supplier_name,SUM(po.total_amount) total_amount
FROM Purchase_Orders po
JOIN Suppliers s
ON po.supplier_id=s.supplier_id
GROUP BY s.supplier_name;

-- Find purchase orders with above-average total amounts
SELECT *
FROM Purchase_Orders
WHERE total_amount>
(SELECT AVG(total_amount) FROM Purchase_Orders);

-- Validate all purchase orders have valid supplier references
SELECT *
FROM Purchase_Orders
WHERE supplier_id IN
(SELECT supplier_id FROM Suppliers);

-- Find the purchase order with the highest total amount
SELECT *
FROM Purchase_Orders
WHERE total_amount=
(SELECT MAX(total_amount) FROM Purchase_Orders);

-- ============================================================================
-- TABLE 10: PURCHASE_ORDER_ITEMS
-- ============================================================================

-- Show purchase order items with product names
SELECT poi.purchase_order_item_id,p.product_name
FROM Purchase_Order_Items poi
JOIN Products p
ON poi.product_id=p.product_id;

-- Link purchase order items to their parent purchase orders
SELECT poi.purchase_order_item_id,po.purchase_order_id
FROM Purchase_Order_Items poi
JOIN Purchase_Orders po
ON poi.purchase_order_id=po.purchase_order_id;

-- Find purchase order items with above-average quantities
SELECT *
FROM Purchase_Order_Items
WHERE quantity_ordered>
(SELECT AVG(quantity_ordered) FROM Purchase_Order_Items);

-- Validate all purchase order items reference valid products
SELECT *
FROM Purchase_Order_Items
WHERE product_id IN
(SELECT product_id FROM Products);

-- Find the purchase order item with the highest total cost
SELECT *
FROM Purchase_Order_Items
WHERE total_cost=
(SELECT MAX(total_cost) FROM Purchase_Order_Items);

-- ============================================================================
-- TABLE 11: SALES
-- ============================================================================

-- Display sales with customer names
SELECT s.sale_id,c.customer_name
FROM Sales s
JOIN Customers c
ON s.customer_id=c.customer_id;

-- Calculate total amount spent by each customer (Customer Lifetime Value)
SELECT c.customer_name,SUM(s.total_amount) total_spent
FROM Sales s
JOIN Customers c
ON s.customer_id=c.customer_id
GROUP BY c.customer_name;

-- Find sales with above-average total amounts
SELECT *
FROM Sales
WHERE total_amount>
(SELECT AVG(total_amount) FROM Sales);

-- Validate all sales have valid customer references
SELECT *
FROM Sales
WHERE customer_id IN
(SELECT customer_id FROM Customers);

-- Find the sale with the highest total amount
SELECT *
FROM Sales
WHERE total_amount=
(SELECT MAX(total_amount) FROM Sales);

-- ============================================================================
-- TABLE 12: SALE_ITEMS
-- ============================================================================

-- Show sale items with product names
SELECT si.sale_item_id,p.product_name
FROM Sale_Items si
JOIN Products p
ON si.product_id=p.product_id;

-- Link sale items to their parent sales transactions
SELECT si.sale_item_id,s.sale_id
FROM Sale_Items si
JOIN Sales s
ON si.sale_id=s.sale_id;

-- Find sale items with above-average quantities
SELECT *
FROM Sale_Items
WHERE quantity>
(SELECT AVG(quantity) FROM Sale_Items);

-- Validate all sale items reference valid products
SELECT *
FROM Sale_Items
WHERE product_id IN
(SELECT product_id FROM Products);

-- Find the sale item with the highest total price
SELECT *
FROM Sale_Items
WHERE total_price=
(SELECT MAX(total_price) FROM Sale_Items);

-- ============================================================================
-- TABLE 13: PAYMENTS
-- ============================================================================

-- Retrieve payment details for purchase orders with supplier information
SELECT p.payment_id,po.purchase_order_id,p.amount
FROM Payments p
JOIN Purchase_Orders po
ON p.reference_id=po.purchase_order_id
WHERE p.payment_type='Purchase Order';

-- Count the number of payments made through each payment method
SELECT payment_method,COUNT(*) total_payments
FROM Payments
GROUP BY payment_method;

-- Find payments with above-average amounts
SELECT *
FROM Payments
WHERE amount>
(SELECT AVG(amount) FROM Payments);

-- Find the payment with the highest amount
SELECT *
FROM Payments
WHERE amount=
(SELECT MAX(amount) FROM Payments);

-- Validate payments reference valid purchase orders
SELECT *
FROM Payments
WHERE reference_id IN
(SELECT purchase_order_id FROM Purchase_Orders);

-- ============================================================================
-- TABLE 14: DRUG_INTERACTIONS
-- ============================================================================

-- Display drug interactions with actual product names for both drugs
SELECT d.interaction_id,p1.product_name Drug1,p2.product_name Drug2
FROM Drug_Interactions d
JOIN Products p1
ON d.product_id1=p1.product_id
JOIN Products p2
ON d.product_id2=p2.product_id;

-- Count the number of interactions by severity level (Minor, Moderate, Major)
SELECT severity,COUNT(*) total_interactions
FROM Drug_Interactions
GROUP BY severity;

-- Find all major severity drug interactions with valid product references
SELECT *
FROM Drug_Interactions
WHERE severity='Major'
AND product_id1 IN
(SELECT product_id FROM Products);

-- Retrieve a single drug interaction record (first record)
SELECT *
FROM Drug_Interactions
WHERE interaction_id=
(SELECT interaction_id FROM Drug_Interactions LIMIT 1);

-- Find drug interactions where the first product exists in the product catalog
SELECT *
FROM Drug_Interactions d
WHERE EXISTS
(SELECT 1 FROM Products p
WHERE p.product_id=d.product_id1);

-- ============================================================================
-- TABLE 15: INVENTORY_ADJUSTMENTS
-- ============================================================================

-- Show inventory adjustments with product names
SELECT ia.adjustment_id,p.product_name
FROM Inventory_Adjustments ia
JOIN Products p
ON ia.product_id=p.product_id;

-- Count the number of adjustments by type (Received, Damaged, Expired, etc.)
SELECT adjustment_type,COUNT(*) total_adjustments
FROM Inventory_Adjustments
GROUP BY adjustment_type;

-- Find inventory adjustments with below-average quantity changes
SELECT *
FROM Inventory_Adjustments
WHERE quantity_adjusted<
(SELECT AVG(quantity_adjusted)
FROM Inventory_Adjustments);

-- Validate all inventory adjustments reference valid products
SELECT *
FROM Inventory_Adjustments
WHERE product_id IN
(SELECT product_id FROM Products);

-- Find the inventory adjustment with the largest absolute quantity change
SELECT *
FROM Inventory_Adjustments
WHERE ABS(quantity_adjusted)=
(
SELECT MAX(ABS(quantity_adjusted))
FROM Inventory_Adjustments
);
