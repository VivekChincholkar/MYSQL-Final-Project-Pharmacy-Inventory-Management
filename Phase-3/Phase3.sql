-- Project Phase-3 (A<Joins<SQ<Fun<B&UD) Pharmacy

-- Table 1: Suppliers
-- Query 1: JOIN - Suppliers with Purchase_Orders and Purchase_Order_Items
SELECT s.supplier_id, s.supplier_name, po.order_date, poi.quantity_ordered
FROM Suppliers s
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id
LEFT JOIN Purchase_Order_Items poi ON po.purchase_order_id = poi.purchase_order_id;

-- Query 2: JOIN - Suppliers with Vendors and Vendor_Contracts
SELECT s.supplier_name, v.vendor_name, vc.contract_name
FROM Suppliers s
LEFT JOIN Vendors v ON s.supplier_name = v.vendor_name
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id;

-- Query 3: JOIN - Suppliers with Products and Manufacturers
SELECT s.supplier_name, p.product_name, m.manufacturer_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.manufacturer_id
LEFT JOIN Manufacturers m ON p.manufacturer_id = m.manufacturer_id;

-- Query 4: JOIN - Suppliers with Inventory and Products
SELECT s.supplier_name, i.quantity_in_stock, p.product_name
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.manufacturer_id
LEFT JOIN Inventory i ON p.product_id = i.product_id;

-- Query 5: JOIN - Suppliers with Purchase_Orders and Expenses
SELECT s.supplier_name, po.total_amount, e.amount AS expense_amount
FROM Suppliers s
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id
LEFT JOIN Expenses e ON po.purchase_order_id = e.reference_number;

-- Query 6: Subquery - Suppliers with any purchase orders
SELECT supplier_name
FROM Suppliers
WHERE EXISTS (SELECT 1 FROM Purchase_Orders po WHERE po.supplier_id = Suppliers.supplier_id);

-- Query 7: Subquery - Suppliers in a specific country
SELECT supplier_name
FROM Suppliers
WHERE country IN (SELECT country FROM Suppliers WHERE country = 'USA');

-- Query 8: Subquery - Suppliers with products
SELECT supplier_name
FROM Suppliers
WHERE EXISTS (SELECT 1 FROM Products p WHERE p.manufacturer_id = Suppliers.supplier_id);

-- Query 9: Subquery - Suppliers with recent creation date
SELECT supplier_name
FROM Suppliers
WHERE created_date > (SELECT MIN(created_date) FROM Suppliers);

-- Query 10: Subquery - Suppliers with vendors
SELECT supplier_name
FROM Suppliers
WHERE EXISTS (SELECT 1 FROM Vendors v WHERE v.vendor_name = Suppliers.supplier_name);

-- Query 11: Built-in Function - Supplier name length
SELECT supplier_name, LENGTH(supplier_name) AS name_length
FROM Suppliers
WHERE LENGTH(supplier_name) > 10;

-- Query 12: Built-in Function - Formatted created date
SELECT supplier_name, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Suppliers
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase city
SELECT UPPER(city) AS uppercase_city
FROM Suppliers;

-- Query 14: Built-in Function - Rounded phone length
SELECT supplier_name, ROUND(LENGTH(phone), 0) AS phone_length
FROM Suppliers;

-- Query 15: Built-in Function - Country status
SELECT supplier_name, 
       CASE 
           WHEN country = 'USA' THEN 'Domestic'
           ELSE 'International'
       END AS supplier_type
FROM Suppliers;

-- Query 16: User-Defined Function - Get supplier full address
DELIMITER //
CREATE FUNCTION GetSupplierAddress(
    p_address VARCHAR(255),
    p_city VARCHAR(50),
    p_state VARCHAR(50),
    p_country VARCHAR(50)
)
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
    RETURN CONCAT(p_address, ', ', p_city, ', ', p_state, ', ', p_country);
END //
DELIMITER ;

-- Query 17: User-Defined Function - Check recent supplier
DELIMITER //
CREATE FUNCTION IsRecentSupplier(created_date TIMESTAMP)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF DATEDIFF(CURDATE(), created_date) < 365 THEN
        RETURN 'Recent';
    ELSE
        RETURN 'Established';
    END IF;
END //
DELIMITER ;
SELECT supplier_name, IsRecentSupplier(created_date) AS supplier_status
FROM Suppliers;

-- Query 18: User-Defined Function - Format supplier name
DELIMITER //
CREATE FUNCTION FormatSupplierName(p_name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN IFNULL(UPPER(p_name), 'UNKNOWN');
END //
DELIMITER ;

-- Query 19: User-Defined Function - Calculate supplier age
DELIMITER //
CREATE FUNCTION GetSupplierAge(created_date TIMESTAMP)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT supplier_name, GetSupplierAge(created_date) AS age_in_days
FROM Suppliers;

-- Query 20: User-Defined Function - Get purchase order count
DELIMITER //
CREATE FUNCTION GetSupplierPOCount(supplier_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE po_count INT;
    SELECT COUNT(*) INTO po_count FROM Purchase_Orders WHERE supplier_id = supplier_id;
    RETURN po_count;
END //
DELIMITER ;
SELECT supplier_name, GetSupplierPOCount(supplier_id) AS po_count
FROM Suppliers;


-- Table 2: Categories
-- Query 1: JOIN - Categories with Products and Manufacturers
SELECT c.category_id, c.category_name, p.product_name, m.manufacturer_name
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Manufacturer m ON p.manufacturer_id = m.manufacturer_id;

-- Query 2: JOIN - Categories with Inventory and Products
SELECT c.category_name, i.quantity_in_stock, p.product_name
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Inventory i ON p.product_id = i.product_id;

-- Query 3: JOIN - Categories with Sale_Items and Sales
SELECT c.category_name, si.quantity, s.sale_date
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Sale_Items si ON p.product_id = si.product_id
LEFT JOIN Sales s ON si.sale_id = s.sale_id;

-- Query 4: JOIN - Categories with Prescription_Items and Prescriptions
SELECT c.category_name, pi.quantity, pr.prescription_date
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
LEFT JOIN Prescription_Items pi ON p.product_id = pi.product_id
LEFT JOIN Prescriptions pr ON pi.prescription_id = pr.prescription_id;

-- Query 5: JOIN - Categories with Drug_Interactions and Products
SELECT c.category_name, di.interaction_type, p1.product_name AS product1, p2.product_name AS product2
FROM Categories c
LEFT JOIN Products p1 ON c.category_id = p1.category_id
LEFT JOIN Drug_Interactions di ON p1.product_id = di.product_id1
LEFT JOIN Products p2 ON di.product_id2 = p2.product_id;

-- Query 6: Subquery - Categories with active products
SELECT category_name
FROM Categories
WHERE EXISTS (SELECT 1 FROM Products p WHERE p.category_id = Categories.category_id AND p.unit_price > 0);

-- Query 7: Subquery - Categories with parent categories
SELECT category_name
FROM Categories
WHERE parent_category_id IN (SELECT category_id FROM Categories);

-- Query 8: Subquery - Active categories
SELECT category_name
FROM Categories
WHERE is_active = TRUE;

-- Query 9: Subquery - Categories with inventory
SELECT category_name
FROM Categories
WHERE EXISTS (SELECT 1 FROM Products p JOIN Inventory i ON p.product_id = i.product_id WHERE p.category_id = Categories.category_id);

-- Query 10: Subquery - Categories with sales
SELECT category_name
FROM Categories
WHERE EXISTS (SELECT 1 FROM Products p JOIN Sale_Items si ON p.product_id = si.product_id WHERE p.category_id = Categories.category_id);

-- Query 11: Built-in Function - Category name length
SELECT category_name, LENGTH(category_name) AS name_length
FROM Categories
WHERE LENGTH(category_name) > 5;

-- Query 12: Built-in Function - Formatted created date
SELECT category_name, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Categories
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase description
SELECT UPPER(description) AS uppercase_desc
FROM Categories
WHERE description IS NOT NULL;

-- Query 14: Built-in Function - Rounded sort order
SELECT category_name, ROUND(sort_order, 0) AS rounded_order
FROM Categories;

-- Query 15: Built-in Function - Active status
SELECT category_name, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Categories;

-- Query 16: User-Defined Function - Get category full name
DELIMITER //
CREATE FUNCTION GetCategoryFullName(name VARCHAR(100), description TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN CONCAT(name, ' - ', LEFT(description, 50));
END //
DELIMITER ;
SELECT category_name, GetCategoryFullName(category_name, description) AS full_name
FROM Categories;

-- Query 17: User-Defined Function - Check active category
DELIMITER //
CREATE FUNCTION IsActiveCategory(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Inactive';
    END IF;
END //
DELIMITER ;
SELECT category_name, IsActiveCategory(is_active) AS category_status
FROM Categories;

-- Query 18: User-Defined Function - Format category name
DELIMITER //
CREATE FUNCTION FormatCategoryName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT category_name, FormatCategoryName(category_name) AS formatted_name
FROM Categories;

-- Query 19: User-Defined Function - Calculate category age
DELIMITER //
CREATE FUNCTION GetCategoryAge(created_date TIMESTAMP)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT category_name, GetCategoryAge(created_date) AS age_in_days
FROM Categories;

-- Query 20: User-Defined Function - Get product count
DELIMITER //
CREATE FUNCTION GetCategoryProductCount(category_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE prod_count INT;
    SELECT COUNT(*) INTO prod_count FROM Products WHERE category_id = category_id;
    RETURN prod_count;
END //
DELIMITER ;
SELECT category_name, GetCategoryProductCount(category_id) AS product_count
FROM Categories;


-- Table 3: Manufacturers
-- Query 1: JOIN - Manufacturers with Products and Categories
SELECT m.manufacturer_id, m.manufacturer_name, p.product_name, c.category_name
FROM Manufacturer m
LEFT JOIN Products p ON m.manufacturer_id = p.manufacturer_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 2: JOIN - Manufacturers with Inventory and Products
SELECT m.manufacturer_name, i.quantity_in_stock, p.product_name
FROM Manufacturer m
LEFT JOIN Products p ON m.manufacturer_id = p.manufacturer_id
LEFT JOIN Inventory i ON p.product_id = i.product_id;

-- Query 3: JOIN - Manufacturers with Suppliers and Purchase_Orders
SELECT m.manufacturer_name, s.supplier_name, po.order_date
FROM Manufacturers m
LEFT JOIN Suppliers s ON m.manufacturer_name = s.supplier_name
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id;

-- Query 4: JOIN - Manufacturers with Drug_Interactions and Products
SELECT m.manufacturer_name, di.interaction_type, p1.product_name AS product1
FROM Manufacturers m
LEFT JOIN Products p1 ON m.manufacturer_id = p1.manufacturer_id
LEFT JOIN Drug_Interactions di ON p1.product_id = di.product_id1;

-- Query 5: JOIN - Manufacturers with Sale_Items and Products
SELECT m.manufacturer_name, si.quantity, p.product_name
FROM Manufacturers m
LEFT JOIN Products p ON m.manufacturer_id = p.manufacturer_id
LEFT JOIN Sale_Items si ON p.product_id = si.product_id;

-- Query 6: Subquery - Manufacturers with products
SELECT manufacturer_name
FROM Manufacturers
WHERE EXISTS (SELECT 1 FROM Products p WHERE p.manufacturer_id = Manufacturers.manufacturer_id);

-- Query 7: Subquery - Manufacturers in specific country
SELECT manufacturer_name
FROM Manufacturers
WHERE country IN (SELECT country FROM Manufacturers WHERE country = 'USA');

-- Query 8: Subquery - Manufacturers with website
SELECT manufacturer_name
FROM Manufacturers
WHERE website IS NOT NULL;

-- Query 9: Subquery - Manufacturers with recent creation
SELECT manufacturer_name
FROM Manufacturers
WHERE created_date > (SELECT MIN(created_date) FROM Manufacturers);

-- Query 10: Subquery - Manufacturers with inventory
SELECT manufacturer_name
FROM Manufacturers
WHERE EXISTS (SELECT 1 FROM Products p JOIN Inventory i ON p.product_id = i.product_id WHERE p.manufacturer_id = Manufacturers.manufacturer_id);

-- Query 11: Built-in Function - Manufacturer name length
SELECT manufacturer_name, LENGTH(manufacturer_name) AS name_length
FROM Manufacturers
WHERE LENGTH(manufacturer_name) > 10;

-- Query 12: Built-in Function - Formatted created date
SELECT manufacturer_name, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Manufacturers
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase country
SELECT UPPER(country) AS uppercase_country
FROM Manufacturers;

-- Query 14: Built-in Function - Rounded license length
SELECT manufacturer_name, ROUND(LENGTH(license_number), 0) AS license_length
FROM Manufacturers;

-- Query 15: Built-in Function - Website status
SELECT manufacturer_name, 
       CASE 
           WHEN website IS NOT NULL THEN 'Has Website'
           ELSE 'No Website'
       END AS website_status
FROM Manufacturers;

-- Query 16: User-Defined Function - Get manufacturer full address
DELIMITER //
CREATE FUNCTION GetManufacturerAddress(address TEXT, country VARCHAR(50))
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN CONCAT(address, ', ', country);
END //
DELIMITER ;
SELECT manufacturer_name, GetManufacturerAddress(address, country) AS full_address
FROM Manufacturers;

-- Query 17: User-Defined Function - Check recent manufacturer
DELIMITER //
CREATE FUNCTION IsRecentManufacturer(created_date TIMESTAMP)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF DATEDIFF(CURDATE(), created_date) < 365 THEN
        RETURN 'Recent';
    ELSE
        RETURN 'Established';
    END IF;
END //
DELIMITER ;
SELECT manufacturer_name, IsRecentManufacturer(created_date) AS manufacturer_status
FROM Manufacturers;

-- Query 18: User-Defined Function - Format manufacturer name
DELIMITER //
CREATE FUNCTION FormatManufacturerName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT manufacturer_name, FormatManufacturerName(manufacturer_name) AS formatted_name
FROM Manufacturers;

-- Query 19: User-Defined Function - Calculate manufacturer age
DELIMITER //
CREATE FUNCTION GetManufacturerAge(created_date TIMESTAMP)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT manufacturer_name, GetManufacturerAge(created_date) AS age_in_days
FROM Manufacturers;

-- Query 20: User-Defined Function - Get product count
DELIMITER //
CREATE FUNCTION GetManufacturerProductCount(manufacturer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE prod_count INT;
    SELECT COUNT(*) INTO prod_count FROM Products WHERE manufacturer_id = manufacturer_id;
    RETURN prod_count;
END //
DELIMITER ;
SELECT manufacturer_name, GetManufacturerProductCount(manufacturer_id) AS product_count
FROM Manufacturers;


-- Table 4: Products
-- Query 1: JOIN - Products with Categories and Manufacturers
SELECT p.product_id, p.product_name, c.category_name, m.manufacturer_name
FROM Products p
LEFT JOIN Categories c ON p.category_id = c.category_id
LEFT JOIN Manufacturers m ON p.manufacturer_id = m.manufacturer_id;

-- Query 2: JOIN - Products with Inventory and Purchase_Order_Items
SELECT p.product_name, i.quantity_in_stock, poi.quantity_ordered
FROM Products p
LEFT JOIN Inventory i ON p.product_id = i.product_id
LEFT JOIN Purchase_Order_Items poi ON p.product_id = poi.product_id;

-- Query 3: JOIN - Products with Sale_Items and Sales
SELECT p.product_name, si.quantity, s.sale_date
FROM Products p
LEFT JOIN Sale_Items si ON p.product_id = si.product_id
LEFT JOIN Sales s ON si.sale_id = s.sale_id;

-- Query 4: JOIN - Products with Prescription_Items and Prescriptions
SELECT p.product_name, pi.quantity, pr.prescription_date
FROM Products p
LEFT JOIN Prescription_Items pi ON p.product_id = pi.product_id
LEFT JOIN Prescriptions pr ON pi.prescription_id = pr.prescription_id;

-- Query 5: JOIN - Products with Drug_Interactions and Inventory_Adjustments
SELECT p.product_name, di.severity, ia.quantity_adjusted
FROM Products p
LEFT JOIN Drug_Interactions di ON p.product_id = di.product_id1
LEFT JOIN Inventory_Adjustments ia ON p.product_id = ia.product_id;

-- Query 6: Subquery - Products with inventory
SELECT product_name
FROM Products
WHERE EXISTS (SELECT 1 FROM Inventory i WHERE i.product_id = Products.product_id AND i.quantity_in_stock > 0);

-- Query 7: Subquery - Products in specific category
SELECT product_name
FROM Products
WHERE category_id IN (SELECT category_id FROM Categories WHERE is_active = TRUE);

-- Query 8: Subquery - Products with sales
SELECT product_name
FROM Products
WHERE EXISTS (SELECT 1 FROM Sale_Items si WHERE si.product_id = Products.product_id);

-- Query 9: Subquery - Products with prescriptions
SELECT product_name
FROM Products
WHERE EXISTS (SELECT 1 FROM Prescription_Items pi WHERE pi.product_id = Products.product_id);

-- Query 10: Subquery - Products from manufacturers
SELECT product_name
FROM Products
WHERE manufacturer_id IN (SELECT manufacturer_id FROM Manufacturers);

-- Query 11: Built-in Function - Product name length
SELECT product_name, LENGTH(product_name) AS name_length
FROM Products
WHERE LENGTH(product_name) > 5;

-- Query 12: Built-in Function - Formatted created date
SELECT product_name, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Products
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded unit price
SELECT product_name, ROUND(unit_price, 2) AS rounded_price
FROM Products;

-- Query 14: Built-in Function - Uppercase dosage form
SELECT UPPER(dosage_form) AS uppercase_dosage
FROM Products;

-- Query 15: Built-in Function - Price status
SELECT product_name, 
       CASE 
           WHEN unit_price < 10 THEN 'Low'
           ELSE 'High'
       END AS price_level
FROM Products;

-- Query 16: User-Defined Function - Get discounted price
DELIMITER //
CREATE FUNCTION GetDiscountedPrice(price DECIMAL(10,2), discount DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price * (1 - discount / 100);
END //
DELIMITER ;
SELECT product_name, unit_price, GetDiscountedPrice(unit_price, 10) AS discounted_price
FROM Products;

-- Query 17: User-Defined Function - Get stock status
DELIMITER //
CREATE FUNCTION GetProductStockStatus(product_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE qty INT;
    SELECT quantity_in_stock INTO qty FROM Inventory WHERE product_id = product_id LIMIT 1;
    IF qty > 0 THEN
        RETURN 'In Stock';
    ELSE
        RETURN 'Out of Stock';
    END IF;
END //
DELIMITER ;
SELECT product_name, GetProductStockStatus(product_id) AS stock_status
FROM Products;

-- Query 18: User-Defined Function - Format product name
DELIMITER //
CREATE FUNCTION FormatProductName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT product_name, FormatProductName(product_name) AS formatted_name
FROM Products;

-- Query 19: User-Defined Function - Calculate product age
DELIMITER //
CREATE FUNCTION GetProductAge(created_date TIMESTAMP)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT product_name, GetProductAge(created_date) AS age_in_days
FROM Products;

-- Query 20: User-Defined Function - Get sales count
DELIMITER //
CREATE FUNCTION GetProductSalesCount(product_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE sales_count INT;
    SELECT COUNT(*) INTO sales_count FROM Sale_Items WHERE product_id = product_id;
    RETURN sales_count;
END //
DELIMITER ;
SELECT product_name, GetProductSalesCount(product_id) AS sales_count
FROM Products;


-- Table 5: Inventory
-- Query 1: JOIN - Inventory with Products and Categories
SELECT i.inventory_id, p.product_name, c.category_name, i.quantity_in_stock
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 2: JOIN - Inventory with Inventory_Adjustments and Employees
SELECT i.batch_number, ia.quantity_adjusted, e.employee_name
FROM Inventory i
LEFT JOIN Inventory_Adjustments ia ON i.product_id = ia.product_id
LEFT JOIN Employees e ON ia.adjusted_by = e.employee_id;

-- Query 3: JOIN - Inventory with Purchase_Order_Items and Purchase_Orders
SELECT i.quantity_in_stock, poi.quantity_received, po.order_date
FROM Inventory i
LEFT JOIN Purchase_Order_Items poi ON i.product_id = poi.product_id
LEFT JOIN Purchase_Orders po ON poi.purchase_order_id = po.purchase_order_id;

-- Query 4: JOIN - Inventory with Sale_Items and Sales
SELECT i.expiry_date, si.quantity, s.sale_date
FROM Inventory i
LEFT JOIN Sale_Items si ON i.product_id = si.product_id
LEFT JOIN Sales s ON si.sale_id = s.sale_id;

-- Query 5: JOIN - Inventory with Drug_Interactions and Products
SELECT i.location, di.severity, p.product_name
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id
LEFT JOIN Drug_Interactions di ON p.product_id = di.product_id1;

-- Query 6: Subquery - Inventory with low stock
SELECT batch_number
FROM Inventory
WHERE quantity_in_stock < (SELECT AVG(quantity_in_stock) FROM Inventory);

-- Query 7: Subquery - Inventory expiring soon
SELECT batch_number
FROM Inventory
WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- Query 8: Subquery - Inventory with adjustments
SELECT batch_number
FROM Inventory
WHERE EXISTS (SELECT 1 FROM Inventory_Adjustments ia WHERE ia.product_id = Inventory.product_id);

-- Query 9: Subquery - Inventory for products in categories
SELECT batch_number
FROM Inventory
WHERE product_id IN (SELECT product_id FROM Products WHERE category_id IN (SELECT category_id FROM Categories));

-- Query 10: Subquery - Inventory with sales
SELECT batch_number
FROM Inventory
WHERE EXISTS (SELECT 1 FROM Sale_Items si WHERE si.product_id = Inventory.product_id);

-- Query 11: Built-in Function - Quantity length (as string)
SELECT batch_number, LENGTH(CAST(quantity_in_stock AS CHAR)) AS qty_length
FROM Inventory;

-- Query 12: Built-in Function - Formatted expiry date
SELECT batch_number, DATE_FORMAT(expiry_date, '%M %d, %Y') AS formatted_expiry
FROM Inventory
WHERE expiry_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded cost price
SELECT batch_number, ROUND(cost_price, 2) AS rounded_cost
FROM Inventory;

-- Query 14: Built-in Function - Uppercase location
SELECT UPPER(location) AS uppercase_location
FROM Inventory;

-- Query 15: Built-in Function - Stock status
SELECT batch_number, 
       CASE 
           WHEN quantity_in_stock < reorder_level THEN 'Low'
           ELSE 'Sufficient'
       END AS stock_level
FROM Inventory;

-- Query 16: User-Defined Function - Get days to expiry
DELIMITER //
CREATE FUNCTION GetDaysToExpiry(expiry_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(expiry_date, CURDATE());
END //
DELIMITER ;
SELECT batch_number, GetDaysToExpiry(expiry_date) AS days_to_expiry
FROM Inventory;

-- Query 17: User-Defined Function - Check low stock
DELIMITER //
CREATE FUNCTION IsLowStock(qty INT, reorder INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF qty < reorder THEN
        RETURN 'Low Stock';
    ELSE
        RETURN 'Adequate';
    END IF;
END //
DELIMITER ;
SELECT batch_number, IsLowStock(quantity_in_stock, reorder_level) AS stock_status
FROM Inventory;

-- Query 18: User-Defined Function - Format batch number
DELIMITER //
CREATE FUNCTION FormatBatchNumber(batch VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(batch);
END //
DELIMITER ;
SELECT batch_number, FormatBatchNumber(batch_number) AS formatted_batch
FROM Inventory;

-- Query 19: User-Defined Function - Calculate profit margin
DELIMITER //
CREATE FUNCTION GetProfitMargin(cost DECIMAL(10,2), selling DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (selling - cost) / cost * 100;
END //
DELIMITER ;
SELECT batch_number, GetProfitMargin(cost_price, selling_price) AS profit_margin
FROM Inventory;

-- Query 20: User-Defined Function - Get adjustment count
DELIMITER //
CREATE FUNCTION GetInventoryAdjustmentCount(product_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE adj_count INT;
    SELECT COUNT(*) INTO adj_count FROM Inventory_Adjustments WHERE product_id = product_id;
    RETURN adj_count;
END //
DELIMITER ;
SELECT batch_number, GetInventoryAdjustmentCount(product_id) AS adjustment_count
FROM Inventory;


-- Table 6: Customers
-- Query 1: JOIN - Customers with Prescriptions and Prescription_Items
SELECT cu.customer_id, cu.customer_name, pr.prescription_date, pi.quantity
FROM Customers cu
LEFT JOIN Prescriptions pr ON cu.customer_id = pr.customer_id
LEFT JOIN Prescription_Items pi ON pr.prescription_id = pi.prescription_id;

-- Query 2: JOIN - Customers with Sales and Sale_Items
SELECT cu.customer_name, s.sale_date, si.quantity
FROM Customers cu
LEFT JOIN Sales s ON cu.customer_id = s.customer_id
LEFT JOIN Sale_Items si ON s.sale_id = si.sale_id;

-- Query 3: JOIN - Customers with Patient_Medical_History and Insurance_Claims
SELECT cu.customer_name, pmh.condition_name, ic.claim_amount
FROM Customers cu
LEFT JOIN Patient_Medical_History pmh ON cu.customer_id = pmh.customer_id
LEFT JOIN Prescriptions pr ON cu.customer_id = pr.customer_id
LEFT JOIN Insurance_Claims ic ON pr.prescription_id = ic.prescription_id;

-- Query 4: JOIN - Customers with Insurance_Providers and Payments
SELECT cu.customer_name, ip.provider_name, p.amount
FROM Customers cu
LEFT JOIN Insurance_Providers ip ON cu.insurance_provider = ip.provider_name
LEFT JOIN Sales s ON cu.customer_id = s.customer_id
LEFT JOIN Payments p ON s.sale_id = p.reference_id;

-- Query 5: JOIN - Customers with Notifications and Employees
SELECT cu.customer_name, n.message, e.employee_name
FROM Customers cu
LEFT JOIN Prescriptions pr ON cu.customer_id = pr.customer_id
LEFT JOIN Notifications n ON pr.prescription_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 6: Subquery - Customers with prescriptions
SELECT customer_name
FROM Customers
WHERE EXISTS (SELECT 1 FROM Prescriptions pr WHERE pr.customer_id = Customers.customer_id);

-- Query 7: Subquery - Customers with allergies
SELECT customer_name
FROM Customers
WHERE allergies IS NOT NULL;

-- Query 8: Subquery - Customers with sales
SELECT customer_name
FROM Customers
WHERE EXISTS (SELECT 1 FROM Sales s WHERE s.customer_id = Customers.customer_id);

-- Query 9: Subquery - Customers with medical history
SELECT customer_name
FROM Customers
WHERE EXISTS (SELECT 1 FROM Patient_Medical_History pmh WHERE pmh.customer_id = Customers.customer_id);

-- Query 10: Subquery - Customers born after certain date
SELECT customer_name
FROM Customers
WHERE date_of_birth > (SELECT MIN(date_of_birth) FROM Customers);

-- Query 11: Built-in Function - Customer name length
SELECT customer_name, LENGTH(customer_name) AS name_length
FROM Customers
WHERE LENGTH(customer_name) > 5;

-- Query 12: Built-in Function - Formatted birth date
SELECT customer_name, DATE_FORMAT(date_of_birth, '%M %d, %Y') AS formatted_birth
FROM Customers
WHERE date_of_birth IS NOT NULL;

-- Query 13: Built-in Function - Uppercase gender
SELECT UPPER(gender) AS uppercase_gender
FROM Customers;

-- Query 14: Built-in Function - Rounded age (approx)
SELECT customer_name, ROUND(DATEDIFF(CURDATE(), date_of_birth)/365, 0) AS approx_age
FROM Customers;

-- Query 15: Built-in Function - Insurance status
SELECT customer_name, 
       CASE 
           WHEN insurance_number IS NOT NULL THEN 'Insured'
           ELSE 'Uninsured'
       END AS insurance_status
FROM Customers;

-- Query 16: User-Defined Function - Get customer age
DELIMITER //
CREATE FUNCTION GetCustomerAge(dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN FLOOR(DATEDIFF(CURDATE(), dob)/365);
END //
DELIMITER ;
SELECT customer_name, GetCustomerAge(date_of_birth) AS age
FROM Customers;

-- Query 17: User-Defined Function - Check has allergies
DELIMITER //
CREATE FUNCTION HasAllergies(allergies TEXT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF allergies IS NOT NULL THEN
        RETURN 'Has Allergies';
    ELSE
        RETURN 'No Allergies';
    END IF;
END //
DELIMITER ;
SELECT customer_name, HasAllergies(allergies) AS allergy_status
FROM Customers;

-- Query 18: User-Defined Function - Format customer name
DELIMITER //
CREATE FUNCTION FormatCustomerName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT customer_name, FormatCustomerName(customer_name) AS formatted_name
FROM Customers;

-- Query 19: User-Defined Function - Calculate days registered
DELIMITER //
CREATE FUNCTION GetDaysRegistered(created_date TIMESTAMP)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT customer_name, GetDaysRegistered(created_date) AS days_registered
FROM Customers;

-- Query 20: User-Defined Function - Get prescription count
DELIMITER //
CREATE FUNCTION GetCustomerPrescriptionCount(customer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE pr_count INT;
    SELECT COUNT(*) INTO pr_count FROM Prescriptions WHERE customer_id = customer_id;
    RETURN pr_count;
END //
DELIMITER ;
SELECT customer_name, GetCustomerPrescriptionCount(customer_id) AS prescription_count
FROM Customers;


-- Table 7: Prescriptions
-- Query 1: JOIN - Prescriptions with Customers and Prescription_Items
SELECT pr.prescription_id, cu.customer_name, pi.quantity, pi.dosage_instructions
FROM Prescriptions pr
LEFT JOIN Customers cu ON pr.customer_id = cu.customer_id
LEFT JOIN Prescription_Items pi ON pr.prescription_id = pi.prescription_id;

-- Query 2: JOIN - Prescriptions with Insurance_Claims and Insurance_Providers
SELECT pr.total_amount, ic.covered_amount, ip.provider_name
FROM Prescriptions pr
LEFT JOIN Insurance_Claims ic ON pr.prescription_id = ic.prescription_id
LEFT JOIN Insurance_Providers ip ON ic.provider_id = ip.provider_id;

-- Query 3: JOIN - Prescriptions with Patient_Medical_History and Products
SELECT pr.prescription_date, pmh.condition_name, p.product_name
FROM Prescriptions pr
LEFT JOIN Patient_Medical_History pmh ON pr.customer_id = pmh.customer_id
LEFT JOIN Prescription_Items pi ON pr.prescription_id = pi.prescription_id
LEFT JOIN Products p ON pi.product_id = p.product_id;

-- Query 4: JOIN - Prescriptions with Notifications and Employees
SELECT pr.status, n.message, e.employee_name
FROM Prescriptions pr
LEFT JOIN Notifications n ON pr.prescription_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Prescriptions with Payments and Sales
SELECT pr.patient_copay, p.amount, s.sale_date
FROM Prescriptions pr
LEFT JOIN Insurance_Claims ic ON pr.prescription_id = ic.prescription_id
LEFT JOIN Payments p ON ic.claim_id = p.reference_id
LEFT JOIN Sales s ON pr.customer_id = s.customer_id;

-- Query 6: Subquery - Prescriptions with items
SELECT doctor_name
FROM Prescriptions
WHERE EXISTS (SELECT 1 FROM Prescription_Items pi WHERE pi.prescription_id = Prescriptions.prescription_id);

-- Query 7: Subquery - Active prescriptions
SELECT doctor_name
FROM Prescriptions
WHERE status = 'Active';

-- Query 8: Subquery - Prescriptions with claims
SELECT doctor_name
FROM Prescriptions
WHERE EXISTS (SELECT 1 FROM Insurance_Claims ic WHERE ic.prescription_id = Prescriptions.prescription_id);

-- Query 9: Subquery - Prescriptions for customers with history
SELECT doctor_name
FROM Prescriptions
WHERE customer_id IN (SELECT customer_id FROM Patient_Medical_History);

-- Query 10: Subquery - Recent prescriptions
SELECT doctor_name
FROM Prescriptions
WHERE prescription_date > (SELECT MIN(prescription_date) FROM Prescriptions);

-- Query 11: Built-in Function - Doctor name length
SELECT doctor_name, LENGTH(doctor_name) AS name_length
FROM Prescriptions
WHERE LENGTH(doctor_name) > 5;

-- Query 12: Built-in Function - Formatted prescription date
SELECT doctor_name, DATE_FORMAT(prescription_date, '%M %d, %Y') AS formatted_date
FROM Prescriptions
WHERE prescription_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded total amount
SELECT doctor_name, ROUND(total_amount, 2) AS rounded_total
FROM Prescriptions;

-- Query 14: Built-in Function - Uppercase status
SELECT UPPER(status) AS uppercase_status
FROM Prescriptions;

-- Query 15: Built-in Function - Coverage status
SELECT doctor_name, 
       CASE 
           WHEN insurance_covered > 0 THEN 'Covered'
           ELSE 'Not Covered'
       END AS coverage
FROM Prescriptions;

-- Query 16: User-Defined Function - Get net amount
DELIMITER //
CREATE FUNCTION GetNetAmount(total DECIMAL(10,2), covered DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN total - covered;
END //
DELIMITER ;
SELECT doctor_name, GetNetAmount(total_amount, insurance_covered) AS net_amount
FROM Prescriptions;

-- Query 17: User-Defined Function - Check active prescription
DELIMITER //
CREATE FUNCTION IsActivePrescription(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Active' THEN
        RETURN 'Valid';
    ELSE
        RETURN 'Expired';
    END IF;
END //
DELIMITER ;
SELECT doctor_name, IsActivePrescription(status) AS prescription_status
FROM Prescriptions;

-- Query 18: User-Defined Function - Format doctor name
DELIMITER //
CREATE FUNCTION FormatDoctorName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT doctor_name, FormatDoctorName(doctor_name) AS formatted_name
FROM Prescriptions;

-- Query 19: User-Defined Function - Calculate days since prescription
DELIMITER //
CREATE FUNCTION GetDaysSincePrescription(pres_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), pres_date);
END //
DELIMITER ;
SELECT doctor_name, GetDaysSincePrescription(prescription_date) AS days_since
FROM Prescriptions;

-- Query 20: User-Defined Function - Get item count
DELIMITER //
CREATE FUNCTION GetPrescriptionItemCount(pres_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE item_count INT;
    SELECT COUNT(*) INTO item_count FROM Prescription_Items WHERE prescription_id = pres_id;
    RETURN item_count;
END //
DELIMITER ;
SELECT doctor_name, GetPrescriptionItemCount(prescription_id) AS item_count
FROM Prescriptions;


-- Table 8: Prescription_Items
-- Query 1: JOIN - Prescription_Items with Prescriptions and Customers
SELECT pi.prescription_item_id, pr.prescription_date, cu.customer_name
FROM Prescription_Items pi
LEFT JOIN Prescriptions pr ON pi.prescription_id = pr.prescription_id
LEFT JOIN Customers cu ON pr.customer_id = cu.customer_id;

-- Query 2: JOIN - Prescription_Items with Products and Categories
SELECT pi.quantity, p.product_name, c.category_name
FROM Prescription_Items pi
LEFT JOIN Products p ON pi.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 3: JOIN - Prescription_Items with Drug_Interactions and Products
SELECT pi.dosage_instructions, di.severity, p2.product_name AS interacting_product
FROM Prescription_Items pi
LEFT JOIN Drug_Interactions di ON pi.product_id = di.product_id1
LEFT JOIN Products p2 ON di.product_id2 = p2.product_id;

-- Query 4: JOIN - Prescription_Items with Inventory and Inventory_Adjustments
SELECT pi.total_price, i.quantity_in_stock, ia.reason
FROM Prescription_Items pi
LEFT JOIN Inventory i ON pi.product_id = i.product_id
LEFT JOIN Inventory_Adjustments ia ON pi.product_id = ia.product_id;

-- Query 5: JOIN - Prescription_Items with Sale_Items and Sales
SELECT pi.refills_remaining, si.quantity, s.payment_status
FROM Prescription_Items pi
LEFT JOIN Sale_Items si ON pi.prescription_item_id = si.prescription_item_id
LEFT JOIN Sales s ON si.sale_id = s.sale_id;

-- Query 6: Subquery - Items with refills
SELECT dosage_instructions
FROM Prescription_Items
WHERE refills_remaining > 0;

-- Query 7: Subquery - Items in prescriptions
SELECT dosage_instructions
FROM Prescription_Items
WHERE prescription_id IN (SELECT prescription_id FROM Prescriptions WHERE status = 'Active');

-- Query 8: Subquery - Items with high quantity
SELECT dosage_instructions
FROM Prescription_Items
WHERE quantity > (SELECT AVG(quantity) FROM Prescription_Items);

-- Query 9: Subquery - Items for products with inventory
SELECT dosage_instructions
FROM Prescription_Items
WHERE product_id IN (SELECT product_id FROM Inventory WHERE quantity_in_stock > 0);

-- Query 10: Subquery - Items with sales
SELECT dosage_instructions
FROM Prescription_Items
WHERE EXISTS (SELECT 1 FROM Sale_Items si WHERE si.prescription_item_id = Prescription_Items.prescription_item_id);

-- Query 11: Built-in Function - Dosage length
SELECT dosage_instructions, LENGTH(dosage_instructions) AS instr_length
FROM Prescription_Items
WHERE dosage_instructions IS NOT NULL;

-- Query 12: Built-in Function - Formatted created date
SELECT quantity, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Prescription_Items
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded total price
SELECT quantity, ROUND(total_price, 2) AS rounded_price
FROM Prescription_Items;

-- Query 14: Built-in Function - Uppercase dosage
SELECT UPPER(dosage_instructions) AS uppercase_dosage
FROM Prescription_Items;

-- Query 15: Built-in Function - Refill status
SELECT quantity, 
       CASE 
           WHEN refills_remaining > 0 THEN 'Refills Available'
           ELSE 'No Refills'
       END AS refill_status
FROM Prescription_Items;

-- Query 16: User-Defined Function - Get total with tax
DELIMITER //
CREATE FUNCTION GetItemTotalWithTax(price DECIMAL(10,2), tax DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price * (1 + tax / 100);
END //
DELIMITER ;
SELECT quantity, GetItemTotalWithTax(total_price, 5) AS total_with_tax
FROM Prescription_Items;

-- Query 17: User-Defined Function - Check refills
DELIMITER //
CREATE FUNCTION HasRefills(refills INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF refills > 0 THEN
        RETURN 'Refills Available';
    ELSE
        RETURN 'No Refills';
    END IF;
END //
DELIMITER ;
SELECT quantity, HasRefills(refills_remaining) AS refill_status
FROM Prescription_Items;

-- Query 18: User-Defined Function - Format dosage
DELIMITER //
CREATE FUNCTION FormatDosage(instr TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN UPPER(instr);
END //
DELIMITER ;
SELECT dosage_instructions, FormatDosage(dosage_instructions) AS formatted_dosage
FROM Prescription_Items;

-- Query 19: User-Defined Function - Calculate days supply left (simplified)
DELIMITER //
CREATE FUNCTION GetDaysSupplyLeft(days INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN days - 1;  -- Simplified
END //
DELIMITER ;
SELECT quantity, GetDaysSupplyLeft(days_supply) AS supply_left
FROM Prescription_Items;

-- Query 20: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetItemProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT quantity, GetItemProductName(product_id) AS product_name
FROM Prescription_Items;


-- Table 9: Purchase_Orders
-- Query 1: JOIN - Purchase_Orders with Suppliers and Purchase_Order_Items
SELECT po.purchase_order_id, s.supplier_name, poi.quantity_ordered
FROM Purchase_Orders po
LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id
LEFT JOIN Purchase_Order_Items poi ON po.purchase_order_id = poi.purchase_order_id;

-- Query 2: JOIN - Purchase_Orders with Expenses and Vendors
SELECT po.total_amount, e.amount, v.vendor_name
FROM Purchase_Orders po
LEFT JOIN Expenses e ON po.purchase_order_id = e.reference_number
LEFT JOIN Vendors v ON e.vendor_id = v.vendor_id;

-- Query 3: JOIN - Purchase_Orders with Inventory and Products
SELECT po.order_status, i.quantity_in_stock, p.product_name
FROM Purchase_Orders po
LEFT JOIN Purchase_Order_Items poi ON po.purchase_order_id = poi.purchase_order_id
LEFT JOIN Inventory i ON poi.product_id = i.product_id
LEFT JOIN Products p ON poi.product_id = p.product_id;

-- Query 4: JOIN - Purchase_Orders with Notifications and Employees
SELECT po.expected_delivery_date, n.message, e.employee_name
FROM Purchase_Orders po
LEFT JOIN Notifications n ON po.purchase_order_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Purchase_Orders with Payments and Vendors
SELECT po.shipping_cost, p.amount, v.vendor_name
FROM Purchase_Orders po
LEFT JOIN Payments p ON po.purchase_order_id = p.reference_id
LEFT JOIN Vendors v ON po.supplier_id = v.vendor_id;

-- Query 6: Subquery - Orders with items
SELECT order_status
FROM Purchase_Orders
WHERE EXISTS (SELECT 1 FROM Purchase_Order_Items poi WHERE poi.purchase_order_id = Purchase_Orders.purchase_order_id);

-- Query 7: Subquery - Delivered orders
SELECT order_status
FROM Purchase_Orders
WHERE order_status = 'Delivered';

-- Query 8: Subquery - Orders with expenses
SELECT order_status
FROM Purchase_Orders
WHERE EXISTS (SELECT 1 FROM Expenses e WHERE e.reference_number = Purchase_Orders.purchase_order_id);

-- Query 9: Subquery - Recent orders
SELECT order_status
FROM Purchase_Orders
WHERE order_date > (SELECT MIN(order_date) FROM Purchase_Orders);

-- Query 10: Subquery - Orders from suppliers
SELECT order_status
FROM Purchase_Orders
WHERE supplier_id IN (SELECT supplier_id FROM Suppliers);

-- Query 11: Built-in Function - Order date formatted
SELECT purchase_order_id, DATE_FORMAT(order_date, '%M %d, %Y') AS formatted_date
FROM Purchase_Orders
WHERE order_date IS NOT NULL;

-- Query 12: Built-in Function - Rounded total amount
SELECT purchase_order_id, ROUND(total_amount, 2) AS rounded_total
FROM Purchase_Orders;

-- Query 13: Built-in Function - Uppercase order status
SELECT UPPER(order_status) AS uppercase_status
FROM Purchase_Orders;

-- Query 14: Built-in Function - Notes length
SELECT purchase_order_id, LENGTH(notes) AS notes_length
FROM Purchase_Orders
WHERE notes IS NOT NULL;

-- Query 15: Built-in Function - Delivery status
SELECT purchase_order_id, 
       CASE 
           WHEN actual_delivery_date IS NOT NULL THEN 'Delivered'
           ELSE 'Pending'
       END AS delivery_status
FROM Purchase_Orders;

-- Query 16: User-Defined Function - Get days to delivery
DELIMITER //
CREATE FUNCTION GetDaysToDelivery(expected DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(expected, CURDATE());
END //
DELIMITER ;
SELECT purchase_order_id, GetDaysToDelivery(expected_delivery_date) AS days_to_delivery
FROM Purchase_Orders;

-- Query 17: User-Defined Function - Check order status
DELIMITER //
CREATE FUNCTION IsDeliveredOrder(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Delivered' THEN
        RETURN 'Completed';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT purchase_order_id, IsDeliveredOrder(order_status) AS order_status_check
FROM Purchase_Orders;

-- Query 18: User-Defined Function - Format supplier name from ID
DELIMITER //
CREATE FUNCTION GetPOSupplierName(supplier_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE sup_name VARCHAR(100);
    SELECT supplier_name INTO sup_name FROM Suppliers WHERE supplier_id = supplier_id;
    RETURN sup_name;
END //
DELIMITER ;
SELECT purchase_order_id, GetPOSupplierName(supplier_id) AS supplier_name
FROM Purchase_Orders;

-- Query 19: User-Defined Function - Calculate net cost
DELIMITER //
CREATE FUNCTION GetNetCost(total DECIMAL(10,2), tax DECIMAL(10,2), shipping DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN total + tax + shipping;
END //
DELIMITER ;
SELECT purchase_order_id, GetNetCost(total_amount, tax_amount, shipping_cost) AS net_cost
FROM Purchase_Orders;

-- Query 20: User-Defined Function - Get item count
DELIMITER //
CREATE FUNCTION GetPOItemCount(po_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE item_count INT;
    SELECT COUNT(*) INTO item_count FROM Purchase_Order_Items WHERE purchase_order_id = po_id;
    RETURN item_count;
END //
DELIMITER ;
SELECT purchase_order_id, GetPOItemCount(purchase_order_id) AS item_count
FROM Purchase_Orders;


-- Table 10: Purchase_Order_Items
-- Query 1: JOIN - Purchase_Order_Items with Purchase_Orders and Suppliers
SELECT poi.purchase_order_item_id, po.order_date, s.supplier_name
FROM Purchase_Order_Items poi
LEFT JOIN Purchase_Orders po ON poi.purchase_order_id = po.purchase_order_id
LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id;

-- Query 2: JOIN - Purchase_Order_Items with Products and Manufacturers
SELECT poi.quantity_received, p.product_name, m.manufacturer_name
FROM Purchase_Order_Items poi
LEFT JOIN Products p ON poi.product_id = p.product_id
LEFT JOIN Manufacturers m ON p.manufacturer_id = m.manufacturer_id;

-- Query 3: JOIN - Purchase_Order_Items with Inventory and Inventory_Adjustments
SELECT poi.total_cost, i.quantity_in_stock, ia.reason
FROM Purchase_Order_Items poi
LEFT JOIN Inventory i ON poi.product_id = i.product_id
LEFT JOIN Inventory_Adjustments ia ON poi.product_id = ia.product_id;

-- Query 4: JOIN - Purchase_Order_Items with Expenses and Vendors
SELECT poi.unit_cost, e.amount, v.vendor_name
FROM Purchase_Order_Items poi
LEFT JOIN Purchase_Orders po ON poi.purchase_order_id = po.purchase_order_id
LEFT JOIN Expenses e ON po.purchase_order_id = e.reference_number
LEFT JOIN Vendors v ON e.vendor_id = v.vendor_id;

-- Query 5: JOIN - Purchase_Order_Items with Notifications and Employees
SELECT poi.expiry_date, n.message, e.employee_name
FROM Purchase_Order_Items poi
LEFT JOIN Notifications n ON poi.purchase_order_item_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 6: Subquery - Items fully received
SELECT batch_number
FROM Purchase_Order_Items
WHERE quantity_received = quantity_ordered;

-- Query 7: Subquery - Items with expiry
SELECT batch_number
FROM Purchase_Order_Items
WHERE expiry_date IS NOT NULL;

-- Query 8: Subquery - Items in orders
SELECT batch_number
FROM Purchase_Order_Items
WHERE purchase_order_id IN (SELECT purchase_order_id FROM Purchase_Orders WHERE order_status = 'Delivered');

-- Query 9: Subquery - Items for products in inventory
SELECT batch_number
FROM Purchase_Order_Items
WHERE product_id IN (SELECT product_id FROM Inventory);

-- Query 10: Subquery - High cost items
SELECT batch_number
FROM Purchase_Order_Items
WHERE total_cost > (SELECT AVG(total_cost) FROM Purchase_Order_Items);

-- Query 11: Built-in Function - Batch length
SELECT batch_number, LENGTH(batch_number) AS batch_length
FROM Purchase_Order_Items;

-- Query 12: Built-in Function - Formatted received date
SELECT quantity_received, DATE_FORMAT(received_date, '%M %d, %Y') AS formatted_date
FROM Purchase_Order_Items
WHERE received_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded unit cost
SELECT quantity_received, ROUND(unit_cost, 2) AS rounded_cost
FROM Purchase_Order_Items;

-- Query 14: Built-in Function - Uppercase notes
SELECT UPPER(notes) AS uppercase_notes
FROM Purchase_Order_Items
WHERE notes IS NOT NULL;

-- Query 15: Built-in Function - Received status
SELECT quantity_received, 
       CASE 
           WHEN quantity_received = quantity_ordered THEN 'Fully Received'
           ELSE 'Partial'
       END AS receive_status
FROM Purchase_Order_Items;

-- Query 16: User-Defined Function - Get days to expiry
DELIMITER //
CREATE FUNCTION GetPOItemDaysToExpiry(expiry DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(expiry, CURDATE());
END //
DELIMITER ;
SELECT batch_number, GetPOItemDaysToExpiry(expiry_date) AS days_to_expiry
FROM Purchase_Order_Items;

-- Query 17: User-Defined Function - Check fully received
DELIMITER //
CREATE FUNCTION IsFullyReceived(ordered INT, received INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF received = ordered THEN
        RETURN 'Fully Received';
    ELSE
        RETURN 'Partial';
    END IF;
END //
DELIMITER ;
SELECT batch_number, IsFullyReceived(quantity_ordered, quantity_received) AS receive_status
FROM Purchase_Order_Items;

-- Query 18: User-Defined Function - Format batch
DELIMITER //
CREATE FUNCTION FormatPOBatch(batch VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(batch);
END //
DELIMITER ;
SELECT batch_number, FormatPOBatch(batch_number) AS formatted_batch
FROM Purchase_Order_Items;

-- Query 19: User-Defined Function - Calculate variance
DELIMITER //
CREATE FUNCTION GetQuantityVariance(ordered INT, received INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN ordered - received;
END //
DELIMITER ;
SELECT batch_number, GetQuantityVariance(quantity_ordered, quantity_received) AS variance
FROM Purchase_Order_Items;

-- Query 20: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetPOItemProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT batch_number, GetPOItemProductName(product_id) AS product_name
FROM Purchase_Order_Items;


-- Table 11: Sales
-- Query 1: JOIN - Sales with Customers and Sale_Items
SELECT s.sale_id, cu.customer_name, si.quantity
FROM Sales s
LEFT JOIN Customers cu ON s.customer_id = cu.customer_id
LEFT JOIN Sale_Items si ON s.sale_id = si.sale_id;

-- Query 2: JOIN - Sales with Payments and Employees
SELECT s.total_amount, p.amount, e.employee_name
FROM Sales s
LEFT JOIN Payments p ON s.sale_id = p.reference_id
LEFT JOIN Employees e ON s.cashier_id = e.employee_id;

-- Query 3: JOIN - Sales with Prescription_Items and Prescriptions
SELECT s.payment_status, pi.quantity, pr.prescription_date
FROM Sales s
LEFT JOIN Sale_Items si ON s.sale_id = si.sale_id
LEFT JOIN Prescription_Items pi ON si.prescription_item_id = pi.prescription_item_id
LEFT JOIN Prescriptions pr ON pi.prescription_id = pr.prescription_id;

-- Query 4: JOIN - Sales with Notifications and Employees
SELECT s.discount_amount, n.message, e.employee_name
FROM Sales s
LEFT JOIN Notifications n ON s.sale_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Sales with Expenses and Vendors
SELECT s.tax_amount, e.amount, v.vendor_name
FROM Sales s
LEFT JOIN Expenses e ON s.sale_id = e.reference_number
LEFT JOIN Vendors v ON e.vendor_id = v.vendor_id;

-- Query 6: Subquery - Sales with items
SELECT payment_method
FROM Sales
WHERE EXISTS (SELECT 1 FROM Sale_Items si WHERE si.sale_id = Sales.sale_id);

-- Query 7: Subquery - Paid sales
SELECT payment_method
FROM Sales
WHERE payment_status = 'Paid';

-- Query 8: Subquery - Sales with discounts
SELECT payment_method
FROM Sales
WHERE discount_amount > 0;

-- Query 9: Subquery - Recent sales
SELECT payment_method
FROM Sales
WHERE sale_date > (SELECT MIN(sale_date) FROM Sales);

-- Query 10: Subquery - Sales for customers
SELECT payment_method
FROM Sales
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 11: Built-in Function - Sale date formatted
SELECT sale_id, DATE_FORMAT(sale_date, '%M %d, %Y') AS formatted_date
FROM Sales
WHERE sale_date IS NOT NULL;

-- Query 12: Built-in Function - Rounded total amount
SELECT sale_id, ROUND(total_amount, 2) AS rounded_total
FROM Sales;

-- Query 13: Built-in Function - Uppercase payment method
SELECT UPPER(payment_method) AS uppercase_method
FROM Sales;

-- Query 14: Built-in Function - Receipt length
SELECT sale_id, LENGTH(receipt_number) AS receipt_length
FROM Sales
WHERE receipt_number IS NOT NULL;

-- Query 15: Built-in Function - Payment status
SELECT sale_id, 
       CASE 
           WHEN payment_status = 'Paid' THEN 'Completed'
           ELSE 'Pending'
       END AS pay_status
FROM Sales;

-- Query 16: User-Defined Function - Get net total
DELIMITER //
CREATE FUNCTION GetSaleNetTotal(total DECIMAL(10,2), tax DECIMAL(10,2), discount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN total + tax - discount;
END //
DELIMITER ;
SELECT sale_id, GetSaleNetTotal(total_amount, tax_amount, discount_amount) AS net_total
FROM Sales;

-- Query 17: User-Defined Function - Check paid sale
DELIMITER //
CREATE FUNCTION IsPaidSale(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Paid' THEN
        RETURN 'Completed';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT sale_id, IsPaidSale(payment_status) AS pay_status
FROM Sales;

-- Query 18: User-Defined Function - Format customer name from ID
DELIMITER //
CREATE FUNCTION GetSaleCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT customer_name INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT sale_id, GetSaleCustomerName(customer_id) AS customer_name
FROM Sales;

-- Query 19: User-Defined Function - Calculate days since sale
DELIMITER //
CREATE FUNCTION GetDaysSinceSale(sale_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), sale_date);
END //
DELIMITER ;
SELECT sale_id, GetDaysSinceSale(sale_date) AS days_since
FROM Sales;

-- Query 20: User-Defined Function - Get item count
DELIMITER //
CREATE FUNCTION GetSaleItemCount(sale_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE item_count INT;
    SELECT COUNT(*) INTO item_count FROM Sale_Items WHERE sale_id = sale_id;
    RETURN item_count;
END //
DELIMITER ;
SELECT sale_id, GetSaleItemCount(sale_id) AS item_count
FROM Sales;


-- Table 12: Sale_Items
-- Query 1: JOIN - Sale_Items with Sales and Customers
SELECT si.sale_item_id, s.sale_date, cu.customer_name
FROM Sale_Items si
LEFT JOIN Sales s ON si.sale_id = s.sale_id
LEFT JOIN Customers cu ON s.customer_id = cu.customer_id;

-- Query 2: JOIN - Sale_Items with Products and Categories
SELECT si.quantity, p.product_name, c.category_name
FROM Sale_Items si
LEFT JOIN Products p ON si.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 3: JOIN - Sale_Items with Prescription_Items and Prescriptions
SELECT si.total_price, pi.dosage_instructions, pr.doctor_name
FROM Sale_Items si
LEFT JOIN Prescription_Items pi ON si.prescription_item_id = pi.prescription_item_id
LEFT JOIN Prescriptions pr ON pi.prescription_id = pr.prescription_id;

-- Query 4: JOIN - Sale_Items with Inventory and Inventory_Adjustments
SELECT si.discount_amount, i.quantity_in_stock, ia.quantity_adjusted
FROM Sale_Items si
LEFT JOIN Inventory i ON si.product_id = i.product_id
LEFT JOIN Inventory_Adjustments ia ON si.product_id = ia.product_id;

-- Query 5: JOIN - Sale_Items with Drug_Interactions and Products
SELECT si.expiry_date, di.description, p2.product_name AS interacting
FROM Sale_Items si
LEFT JOIN Drug_Interactions di ON si.product_id = di.product_id1
LEFT JOIN Products p2 ON di.product_id2 = p2.product_id;

-- Query 6: Subquery - Items with discounts
SELECT batch_number
FROM Sale_Items
WHERE discount_amount > 0;

-- Query 7: Subquery - Items in sales
SELECT batch_number
FROM Sale_Items
WHERE sale_id IN (SELECT sale_id FROM Sales WHERE payment_status = 'Paid');

-- Query 8: Subquery - Items with expiry
SELECT batch_number
FROM Sale_Items
WHERE expiry_date IS NOT NULL;

-- Query 9: Subquery - Items for products
SELECT batch_number
FROM Sale_Items
WHERE product_id IN (SELECT product_id FROM Products);

-- Query 10: Subquery - High price items
SELECT batch_number
FROM Sale_Items
WHERE total_price > (SELECT AVG(total_price) FROM Sale_Items);

-- Query 11: Built-in Function - Batch length
SELECT batch_number, LENGTH(batch_number) AS batch_length
FROM Sale_Items;

-- Query 12: Built-in Function - Formatted expiry
SELECT quantity, DATE_FORMAT(expiry_date, '%M %d, %Y') AS formatted_expiry
FROM Sale_Items
WHERE expiry_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded total price
SELECT quantity, ROUND(total_price, 2) AS rounded_price
FROM Sale_Items;

-- Query 14: Built-in Function - Uppercase batch
SELECT UPPER(batch_number) AS uppercase_batch
FROM Sale_Items;

-- Query 15: Built-in Function - Discount status
SELECT quantity, 
       CASE 
           WHEN discount_amount > 0 THEN 'Discounted'
           ELSE 'Full Price'
       END AS discount_status
FROM Sale_Items;

-- Query 16: User-Defined Function - Get net price
DELIMITER //
CREATE FUNCTION GetItemNetPrice(price DECIMAL(10,2), discount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price - discount;
END //
DELIMITER ;
SELECT quantity, GetItemNetPrice(total_price, discount_amount) AS net_price
FROM Sale_Items;

-- Query 17: User-Defined Function - Check discounted
DELIMITER //
CREATE FUNCTION IsDiscounted(discount DECIMAL(10,2))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF discount > 0 THEN
        RETURN 'Discounted';
    ELSE
        RETURN 'Full Price';
    END IF;
END //
DELIMITER ;
SELECT quantity, IsDiscounted(discount_amount) AS discount_status
FROM Sale_Items;

-- Query 18: User-Defined Function - Format batch
DELIMITER //
CREATE FUNCTION FormatSaleBatch(batch VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(batch);
END //
DELIMITER ;
SELECT batch_number, FormatSaleBatch(batch_number) AS formatted_batch
FROM Sale_Items;

-- Query 19: User-Defined Function - Get days to expiry
DELIMITER //
CREATE FUNCTION GetSaleItemDaysToExpiry(expiry DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(expiry, CURDATE());
END //
DELIMITER ;
SELECT batch_number, GetSaleItemDaysToExpiry(expiry_date) AS days_to_expiry
FROM Sale_Items;

-- Query 20: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetSaleItemProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT batch_number, GetSaleItemProductName(product_id) AS product_name
FROM Sale_Items;


-- Table 13: Employees
-- Query 1: JOIN - Employees with Employee_Shifts and Shifts
SELECT e.employee_id, e.employee_name, es.total_hours, sh.shift_name
FROM Employees e
LEFT JOIN Employee_Shifts es ON e.employee_id = es.employee_id
LEFT JOIN Shifts sh ON es.shift_id = sh.shift_id;

-- Query 2: JOIN - Employees with Sales and Payments
SELECT e.employee_name, s.total_amount, p.amount
FROM Employees e
LEFT JOIN Sales s ON e.employee_id = s.cashier_id
LEFT JOIN Payments p ON s.sale_id = p.reference_id;

-- Query 3: JOIN - Employees with Notifications and Inventory_Adjustments
SELECT e.employee_name, n.message, ia.reason
FROM Employees e
LEFT JOIN Notifications n ON e.employee_id = n.created_by
LEFT JOIN Inventory_Adjustments ia ON e.employee_id = ia.adjusted_by;

-- Query 4: JOIN - Employees with Expenses and Vendors
SELECT e.employee_name, ex.amount, v.vendor_name
FROM Employees e
LEFT JOIN Expenses ex ON e.employee_id = ex.approved_by
LEFT JOIN Vendors v ON ex.vendor_id = v.vendor_id;

-- Query 5: JOIN - Employees with Vendor_Contracts and Vendors
SELECT e.employee_name, vc.contract_name, v.vendor_name
FROM Employees e
LEFT JOIN Expenses ex ON e.employee_id = ex.approved_by
LEFT JOIN Vendors v ON ex.vendor_id = v.vendor_id
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id;

-- Query 6: Subquery - Employees with shifts
SELECT employee_name
FROM Employees
WHERE EXISTS (SELECT 1 FROM Employee_Shifts es WHERE es.employee_id = Employees.employee_id);

-- Query 7: Subquery - High salary employees
SELECT employee_name
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- Query 8: Subquery - Employees in departments
SELECT employee_name
FROM Employees
WHERE department IN (SELECT department FROM Employees);

-- Query 9: Subquery - Recent hires
SELECT employee_name
FROM Employees
WHERE hire_date > (SELECT MIN(hire_date) FROM Employees);

-- Query 10: Subquery - Employees with sales
SELECT employee_name
FROM Employees
WHERE EXISTS (SELECT 1 FROM Sales s WHERE s.cashier_id = Employees.employee_id);

-- Query 11: Built-in Function - Employee name length
SELECT employee_name, LENGTH(employee_name) AS name_length
FROM Employees
WHERE LENGTH(employee_name) > 5;

-- Query 12: Built-in Function - Formatted hire date
SELECT employee_name, DATE_FORMAT(hire_date, '%M %d, %Y') AS formatted_hire
FROM Employees
WHERE hire_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded salary
SELECT employee_name, ROUND(salary, 2) AS rounded_salary
FROM Employees;

-- Query 14: Built-in Function - Uppercase position
SELECT UPPER(position) AS uppercase_position
FROM Employees;

-- Query 15: Built-in Function - Emergency contact status
SELECT employee_name, 
       CASE 
           WHEN emergency_contact IS NOT NULL THEN 'Has Contact'
           ELSE 'No Contact'
       END AS contact_status
FROM Employees;

-- Query 16: User-Defined Function - Get full address
DELIMITER //
CREATE FUNCTION GetEmployeeAddress(address TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN UPPER(address);
END //
DELIMITER ;
SELECT employee_name, GetEmployeeAddress(address) AS full_address
FROM Employees;

-- Query 17: User-Defined Function - Check high salary
DELIMITER //
CREATE FUNCTION IsHighSalary(salary DECIMAL(10,2))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF salary > 50000 THEN
        RETURN 'High';
    ELSE
        RETURN 'Standard';
    END IF;
END //
DELIMITER ;
SELECT employee_name, IsHighSalary(salary) AS salary_level
FROM Employees;

-- Query 18: User-Defined Function - Format employee name
DELIMITER //
CREATE FUNCTION FormatEmployeeName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT employee_name, FormatEmployeeName(employee_name) AS formatted_name
FROM Employees;

-- Query 19: User-Defined Function - Calculate tenure
DELIMITER //
CREATE FUNCTION GetTenure(hire_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), hire_date);
END //
DELIMITER ;
SELECT employee_name, GetTenure(hire_date) AS tenure_days
FROM Employees;

-- Query 20: User-Defined Function - Get shift count
DELIMITER //
CREATE FUNCTION GetEmployeeShiftCount(employee_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE shift_count INT;
    SELECT COUNT(*) INTO shift_count FROM Employee_Shifts WHERE employee_id = employee_id;
    RETURN shift_count;
END //
DELIMITER ;
SELECT employee_name, GetEmployeeShiftCount(employee_id) AS shift_count
FROM Employees;


-- Table 14: Shifts
-- Query 1: JOIN - Shifts with Employee_Shifts and Employees
SELECT sh.shift_id, sh.shift_name, es.total_hours, e.employee_name
FROM Shifts sh
LEFT JOIN Employee_Shifts es ON sh.shift_id = es.shift_id
LEFT JOIN Employees e ON es.employee_id = e.employee_id;

-- Query 2: JOIN - Shifts with Notifications and Employees
SELECT sh.start_time, n.message, e.employee_name
FROM Shifts sh
LEFT JOIN Employee_Shifts es ON sh.shift_id = es.shift_id
LEFT JOIN Notifications n ON es.employee_shift_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 3: JOIN - Shifts with Expenses and Employees
SELECT sh.end_time, ex.amount, e.employee_name
FROM Shifts sh
LEFT JOIN Employee_Shifts es ON sh.shift_id = es.shift_id
LEFT JOIN Employees e ON es.employee_id = e.employee_id
LEFT JOIN Expenses ex ON e.employee_id = ex.approved_by;

-- Query 4: JOIN - Shifts with Vendor_Contracts and Vendors
SELECT sh.break_duration, vc.contract_name, v.vendor_name
FROM Shifts sh
LEFT JOIN Employee_Shifts es ON sh.shift_id = es.shift_id
LEFT JOIN Employees e ON es.employee_id = e.employee_id
LEFT JOIN Expenses ex ON e.employee_id = ex.approved_by
LEFT JOIN Vendors v ON ex.vendor_id = v.vendor_id
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id;

-- Query 5: JOIN - Shifts with Payments and Sales
SELECT sh.shift_type, p.amount, s.total_amount
FROM Shifts sh
LEFT JOIN Employee_Shifts es ON sh.shift_id = es.shift_id
LEFT JOIN Employees e ON es.employee_id = e.employee_id
LEFT JOIN Sales s ON e.employee_id = s.cashier_id
LEFT JOIN Payments p ON s.sale_id = p.reference_id;

-- Query 6: Subquery - Active shifts
SELECT shift_name
FROM Shifts
WHERE is_active = TRUE;

-- Query 7: Subquery - Shifts with employees
SELECT shift_name
FROM Shifts
WHERE EXISTS (SELECT 1 FROM Employee_Shifts es WHERE es.shift_id = Shifts.shift_id);

-- Query 8: Subquery - Night shifts
SELECT shift_name
FROM Shifts
WHERE shift_type = 'Night';

-- Query 9: Subquery - Shifts with notes
SELECT shift_name
FROM Shifts
WHERE notes IS NOT NULL;

-- Query 10: Subquery - Recent shifts
SELECT shift_name
FROM Shifts
WHERE created_date > (SELECT MIN(created_date) FROM Shifts);

-- Query 11: Built-in Function - Shift name length
SELECT shift_name, LENGTH(shift_name) AS name_length
FROM Shifts
WHERE LENGTH(shift_name) > 5;

-- Query 12: Built-in Function - Formatted start time
SELECT shift_name, TIME_FORMAT(start_time, '%H:%i') AS formatted_start
FROM Shifts;

-- Query 13: Built-in Function - Rounded multiplier
SELECT shift_name, ROUND(hourly_rate_multiplier, 2) AS rounded_multiplier
FROM Shifts;

-- Query 14: Built-in Function - Uppercase shift type
SELECT UPPER(shift_type) AS uppercase_type
FROM Shifts;

-- Query 15: Built-in Function - Active status
SELECT shift_name, 
       CASE 
           WHEN is_active = TRUE THEN 'Active'
           ELSE 'Inactive'
       END AS status
FROM Shifts;

-- Query 16: User-Defined Function - Get shift duration
DELIMITER //
CREATE FUNCTION GetShiftDuration(start TIME, end TIME)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMEDIFF(end, start) / 3600;
END //
DELIMITER ;
SELECT shift_name, GetShiftDuration(start_time, end_time) AS duration_hours
FROM Shifts;

-- Query 17: User-Defined Function - Check active shift
DELIMITER //
CREATE FUNCTION IsActiveShift(is_active BOOLEAN)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF is_active THEN
        RETURN 'Active';
    ELSE
        RETURN 'Inactive';
    END IF;
END //
DELIMITER ;
SELECT shift_name, IsActiveShift(is_active) AS shift_status
FROM Shifts;

-- Query 18: User-Defined Function - Format shift name
DELIMITER //
CREATE FUNCTION FormatShiftName(name VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT shift_name, FormatShiftName(shift_name) AS formatted_name
FROM Shifts;

-- Query 19: User-Defined Function - Calculate effective rate
DELIMITER //
CREATE FUNCTION GetEffectiveRate(multiplier DECIMAL(5,2))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    RETURN multiplier * 1.1;  -- Example
END //
DELIMITER ;
SELECT shift_name, GetEffectiveRate(hourly_rate_multiplier) AS effective_rate
FROM Shifts;

-- Query 20: User-Defined Function - Get employee count
DELIMITER //
CREATE FUNCTION GetShiftEmployeeCount(shift_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE emp_count INT;
    SELECT COUNT(*) INTO emp_count FROM Employee_Shifts WHERE shift_id = shift_id;
    RETURN emp_count;
END //
DELIMITER ;
SELECT shift_name, GetShiftEmployeeCount(shift_id) AS employee_count
FROM Shifts;


-- Table 15: Employee_Shifts
-- Query 1: JOIN - Employee_Shifts with Employees and Shifts
SELECT es.employee_shift_id, e.employee_name, sh.shift_name
FROM Employee_Shifts es
LEFT JOIN Employees e ON es.employee_id = e.employee_id
LEFT JOIN Shifts sh ON es.shift_id = sh.shift_id;

-- Query 2: JOIN - Employee_Shifts with Notifications and Employees
SELECT es.total_hours, n.message, e.employee_name AS created_by
FROM Employee_Shifts es
LEFT JOIN Notifications n ON es.employee_shift_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 3: JOIN - Employee_Shifts with Sales and Payments
SELECT es.overtime_minutes, s.total_amount, p.amount
FROM Employee_Shifts es
LEFT JOIN Employees e ON es.employee_id = e.employee_id
LEFT JOIN Sales s ON e.employee_id = s.cashier_id
LEFT JOIN Payments p ON s.sale_id = p.reference_id;

-- Query 4: JOIN - Employee_Shifts with Expenses and Vendors
SELECT es.break_minutes, ex.amount, v.vendor_name
FROM Employee_Shifts es
LEFT JOIN Employees e ON es.employee_id = e.employee_id
LEFT JOIN Expenses ex ON e.employee_id = ex.approved_by
LEFT JOIN Vendors v ON ex.vendor_id = v.vendor_id;

-- Query 5: JOIN - Employee_Shifts with Vendor_Contracts and Vendors
SELECT es.hourly_rate, vc.contract_value, v.vendor_name
FROM Employee_Shifts es
LEFT JOIN Employees e ON es.employee_id = e.employee_id
LEFT JOIN Expenses ex ON e.employee_id = ex.approved_by
LEFT JOIN Vendors v ON ex.vendor_id = v.vendor_id
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id;

-- Query 6: Subquery - Shifts with overtime
SELECT work_date
FROM Employee_Shifts
WHERE overtime_minutes > 0;

-- Query 7: Subquery - Shifts for active employees
SELECT work_date
FROM Employee_Shifts
WHERE employee_id IN (SELECT employee_id FROM Employees WHERE position = 'Pharmacist');

-- Query 8: Subquery - Long shifts
SELECT work_date
FROM Employee_Shifts
WHERE total_hours > 8;

-- Query 9: Subquery - Shifts with breaks
SELECT work_date
FROM Employee_Shifts
WHERE break_minutes > 0;

-- Query 10: Subquery - Recent shifts
SELECT work_date
FROM Employee_Shifts
WHERE work_date > (SELECT MIN(work_date) FROM Employee_Shifts);

-- Query 11: Built-in Function - Work date formatted
SELECT employee_shift_id, DATE_FORMAT(work_date, '%M %d, %Y') AS formatted_date
FROM Employee_Shifts;

-- Query 12: Built-in Function - Rounded total hours
SELECT employee_shift_id, ROUND(total_hours, 2) AS rounded_hours
FROM Employee_Shifts;

-- Query 13: Built-in Function - Formatted start time
SELECT employee_shift_id, TIME_FORMAT(actual_start_time, '%H:%i') AS formatted_start
FROM Employee_Shifts;

-- Query 14: Built-in Function - Uppercase shift type (via join)
SELECT es.employee_shift_id, UPPER(sh.shift_type) AS uppercase_type
FROM Employee_Shifts es
LEFT JOIN Shifts sh ON es.shift_id = sh.shift_id;

-- Query 15: Built-in Function - Overtime status
SELECT employee_shift_id, 
       CASE 
           WHEN overtime_minutes > 0 THEN 'Overtime'
           ELSE 'Regular'
       END AS overtime_status
FROM Employee_Shifts;

-- Query 16: User-Defined Function - Calculate pay
DELIMITER //
CREATE FUNCTION CalculateShiftPay(hours DECIMAL(5,2), rate DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN hours * rate;
END //
DELIMITER ;
SELECT employee_shift_id, CalculateShiftPay(total_hours, hourly_rate) AS pay
FROM Employee_Shifts;

-- Query 17: User-Defined Function - Check overtime
DELIMITER //
CREATE FUNCTION HasOvertime(ot_minutes INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF ot_minutes > 0 THEN
        RETURN 'Overtime';
    ELSE
        RETURN 'Regular';
    END IF;
END //
DELIMITER ;
SELECT employee_shift_id, HasOvertime(overtime_minutes) AS ot_status
FROM Employee_Shifts;

-- Query 18: User-Defined Function - Format employee name from ID
DELIMITER //
CREATE FUNCTION GetShiftEmployeeName(employee_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE emp_name VARCHAR(100);
    SELECT employee_name INTO emp_name FROM Employees WHERE employee_id = employee_id;
    RETURN emp_name;
END //
DELIMITER ;
SELECT employee_shift_id, GetShiftEmployeeName(employee_id) AS employee_name
FROM Employee_Shifts;

-- Query 19: User-Defined Function - Get net hours
DELIMITER //
CREATE FUNCTION GetNetHours(total DECIMAL(5,2), breaks INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    RETURN total - (breaks / 60);
END //
DELIMITER ;
SELECT employee_shift_id, GetNetHours(total_hours, break_minutes) AS net_hours
FROM Employee_Shifts;

-- Query 20: User-Defined Function - Get shift name
DELIMITER //
CREATE FUNCTION GetShiftName(shift_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE sh_name VARCHAR(50);
    SELECT shift_name INTO sh_name FROM Shifts WHERE shift_id = shift_id;
    RETURN sh_name;
END //
DELIMITER ;
SELECT employee_shift_id, GetShiftName(shift_id) AS shift_name
FROM Employee_Shifts;


-- Table 16: Vendors
-- Query 1: JOIN - Vendors with Vendor_Contracts and Expenses
SELECT v.vendor_id, v.vendor_name, vc.contract_name, ex.amount
FROM Vendors v
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id
LEFT JOIN Expenses ex ON v.vendor_id = ex.vendor_id;

-- Query 2: JOIN - Vendors with Payments and Sales
SELECT v.vendor_name, p.amount, s.total_amount
FROM Vendors v
LEFT JOIN Expenses ex ON v.vendor_id = ex.vendor_id
LEFT JOIN Payments p ON ex.expense_id = p.reference_id
LEFT JOIN Sales s ON p.payment_id = s.sale_id;  -- Adjusted

-- Query 3: JOIN - Vendors with Suppliers and Purchase_Orders
SELECT v.vendor_name, s.supplier_name, po.total_amount
FROM Vendors v
LEFT JOIN Suppliers s ON v.vendor_name = s.supplier_name
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id;

-- Query 4: JOIN - Vendors with Notifications and Employees
SELECT v.vendor_type, n.message, e.employee_name
FROM Vendors v
LEFT JOIN Notifications n ON v.vendor_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Vendors with Insurance_Providers and Insurance_Claims
SELECT v.vendor_name, ip.provider_name, ic.claim_amount
FROM Vendors v
LEFT JOIN Insurance_Providers ip ON v.vendor_name = ip.provider_name
LEFT JOIN Insurance_Claims ic ON ip.provider_id = ic.provider_id;

-- Query 6: Subquery - Vendors with contracts
SELECT vendor_name
FROM Vendors
WHERE EXISTS (SELECT 1 FROM Vendor_Contracts vc WHERE vc.vendor_id = Vendors.vendor_id);

-- Query 7: Subquery - Vendors with website
SELECT vendor_name
FROM Vendors
WHERE website IS NOT NULL;

-- Query 8: Subquery - Suppliers as vendors
SELECT vendor_name
FROM Vendors
WHERE vendor_name IN (SELECT supplier_name FROM Suppliers);

-- Query 9: Subquery - Vendors with expenses
SELECT vendor_name
FROM Vendors
WHERE EXISTS (SELECT 1 FROM Expenses ex WHERE ex.vendor_id = Vendors.vendor_id);

-- Query 10: Subquery - Recent vendors
SELECT vendor_name
FROM Vendors
WHERE created_date > (SELECT MIN(created_date) FROM Vendors);

-- Query 11: Built-in Function - Vendor name length
SELECT vendor_name, LENGTH(vendor_name) AS name_length
FROM Vendors
WHERE LENGTH(vendor_name) > 5;

-- Query 12: Built-in Function - Formatted created date
SELECT vendor_name, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Vendors
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase vendor type
SELECT UPPER(vendor_type) AS uppercase_type
FROM Vendors;

-- Query 14: Built-in Function - Payment terms length
SELECT vendor_name, LENGTH(payment_terms) AS terms_length
FROM Vendors
WHERE payment_terms IS NOT NULL;

-- Query 15: Built-in Function - Tax ID status
SELECT vendor_name, 
       CASE 
           WHEN tax_id IS NOT NULL THEN 'Taxed'
           ELSE 'No Tax ID'
       END AS tax_status
FROM Vendors;

-- Query 16: User-Defined Function - Get full address
DELIMITER //
CREATE FUNCTION GetVendorAddress(address TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN UPPER(address);
END //
DELIMITER ;
SELECT vendor_name, GetVendorAddress(address) AS full_address
FROM Vendors;

-- Query 17: User-Defined Function - Check has website
DELIMITER //
CREATE FUNCTION HasVendorWebsite(website VARCHAR(100))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF website IS NOT NULL THEN
        RETURN 'Has Website';
    ELSE
        RETURN 'No Website';
    END IF;
END //
DELIMITER ;
SELECT vendor_name, HasVendorWebsite(website) AS website_status
FROM Vendors;

-- Query 18: User-Defined Function - Format vendor name
DELIMITER //
CREATE FUNCTION FormatVendorName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT vendor_name, FormatVendorName(vendor_name) AS formatted_name
FROM Vendors;

-- Query 19: User-Defined Function - Calculate vendor age
DELIMITER //
CREATE FUNCTION GetVendorAge(created_date TIMESTAMP)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT vendor_name, GetVendorAge(created_date) AS age_in_days
FROM Vendors;

-- Query 20: User-Defined Function - Get contract count
DELIMITER //
CREATE FUNCTION GetVendorContractCount(vendor_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cont_count INT;
    SELECT COUNT(*) INTO cont_count FROM Vendor_Contracts WHERE vendor_id = vendor_id;
    RETURN cont_count;
END //
DELIMITER ;
SELECT vendor_name, GetVendorContractCount(vendor_id) AS contract_count
FROM Vendors;


-- Table 17: Vendor_Contracts
-- Query 1: JOIN - Vendor_Contracts with Vendors and Expenses
SELECT vc.contract_id, v.vendor_name, ex.amount
FROM Vendor_Contracts vc
LEFT JOIN Vendors v ON vc.vendor_id = v.vendor_id
LEFT JOIN Expenses ex ON v.vendor_id = ex.vendor_id;

-- Query 2: JOIN - Vendor_Contracts with Payments and Employees
SELECT vc.contract_value, p.amount, e.employee_name
FROM Vendor_Contracts vc
LEFT JOIN Vendors v ON vc.vendor_id = v.vendor_id
LEFT JOIN Expenses ex ON v.vendor_id = ex.vendor_id
LEFT JOIN Payments p ON ex.expense_id = p.reference_id
LEFT JOIN Employees e ON p.processed_by = e.employee_id;

-- Query 3: JOIN - Vendor_Contracts with Notifications and Employees
SELECT vc.contract_status, n.message, e.employee_name
FROM Vendor_Contracts vc
LEFT JOIN Notifications n ON vc.contract_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 4: JOIN - Vendor_Contracts with Suppliers and Purchase_Orders
SELECT vc.renewal_terms, s.supplier_name, po.total_amount
FROM Vendor_Contracts vc
LEFT JOIN Vendors v ON vc.vendor_id = v.vendor_id
LEFT JOIN Suppliers s ON v.vendor_name = s.supplier_name
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id;

-- Query 5: JOIN - Vendor_Contracts with Insurance_Providers and Insurance_Claims
SELECT vc.termination_clause, ip.provider_name, ic.claim_amount
FROM Vendor_Contracts vc
LEFT JOIN Vendors v ON vc.vendor_id = v.vendor_id
LEFT JOIN Insurance_Providers ip ON v.vendor_name = ip.provider_name
LEFT JOIN Insurance_Claims ic ON ip.provider_id = ic.provider_id;

-- Query 6: Subquery - Active contracts
SELECT contract_name
FROM Vendor_Contracts
WHERE contract_status = 'Active';

-- Query 7: Subquery - Contracts expiring soon
SELECT contract_name
FROM Vendor_Contracts
WHERE end_date < DATE_ADD(CURDATE(), INTERVAL 3 MONTH);

-- Query 8: Subquery - Contracts with payments
SELECT contract_name
FROM Vendor_Contracts
WHERE EXISTS (SELECT 1 FROM Payments p JOIN Expenses ex ON p.reference_id = ex.expense_id WHERE ex.vendor_id = Vendor_Contracts.vendor_id);

-- Query 9: Subquery - High value contracts
SELECT contract_name
FROM Vendor_Contracts
WHERE contract_value > (SELECT AVG(contract_value) FROM Vendor_Contracts);

-- Query 10: Subquery - Contracts for vendors
SELECT contract_name
FROM Vendor_Contracts
WHERE vendor_id IN (SELECT vendor_id FROM Vendors);

-- Query 11: Built-in Function - Contract name length
SELECT contract_name, LENGTH(contract_name) AS name_length
FROM Vendor_Contracts
WHERE LENGTH(contract_name) > 5;

-- Query 12: Built-in Function - Formatted start date
SELECT contract_name, DATE_FORMAT(start_date, '%M %d, %Y') AS formatted_start
FROM Vendor_Contracts
WHERE start_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded contract value
SELECT contract_name, ROUND(contract_value, 2) AS rounded_value
FROM Vendor_Contracts;

-- Query 14: Built-in Function - Uppercase contract status
SELECT UPPER(contract_status) AS uppercase_status
FROM Vendor_Contracts;

-- Query 15: Built-in Function - Renewal status
SELECT contract_name, 
       CASE 
           WHEN renewal_terms IS NOT NULL THEN 'Renewable'
           ELSE 'Non-Renewable'
       END AS renewal_status
FROM Vendor_Contracts;

-- Query 16: User-Defined Function - Get days to end
DELIMITER //
CREATE FUNCTION GetDaysToContractEnd(end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, CURDATE());
END //
DELIMITER ;
SELECT contract_name, GetDaysToContractEnd(end_date) AS days_to_end
FROM Vendor_Contracts;

-- Query 17: User-Defined Function - Check active contract
DELIMITER //
CREATE FUNCTION IsActiveContract(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Active' THEN
        RETURN 'Valid';
    ELSE
        RETURN 'Expired';
    END IF;
END //
DELIMITER ;
SELECT contract_name, IsActiveContract(contract_status) AS contract_status_check
FROM Vendor_Contracts;

-- Query 18: User-Defined Function - Format vendor name from ID
DELIMITER //
CREATE FUNCTION GetContractVendorName(vendor_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE ven_name VARCHAR(100);
    SELECT vendor_name INTO ven_name FROM Vendors WHERE vendor_id = vendor_id;
    RETURN ven_name;
END //
DELIMITER ;
SELECT contract_name, GetContractVendorName(vendor_id) AS vendor_name
FROM Vendor_Contracts;

-- Query 19: User-Defined Function - Calculate duration
DELIMITER //
CREATE FUNCTION GetContractDuration(start DATE, end DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end, start);
END //
DELIMITER ;
SELECT contract_name, GetContractDuration(start_date, end_date) AS duration_days
FROM Vendor_Contracts;

-- Query 20: User-Defined Function - Get expense count
DELIMITER //
CREATE FUNCTION GetContractExpenseCount(vendor_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE exp_count INT;
    SELECT COUNT(*) INTO exp_count FROM Expenses WHERE vendor_id = vendor_id;
    RETURN exp_count;
END //
DELIMITER ;
SELECT contract_name, GetContractExpenseCount(vendor_id) AS expense_count
FROM Vendor_Contracts;


-- Table 18: Expenses
-- Query 1: JOIN - Expenses with Vendors and Vendor_Contracts
SELECT ex.expense_id, v.vendor_name, vc.contract_name
FROM Expenses ex
LEFT JOIN Vendors v ON ex.vendor_id = v.vendor_id
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id;

-- Query 2: JOIN - Expenses with Payments and Employees
SELECT ex.amount, p.transaction_id, e.employee_name
FROM Expenses ex
LEFT JOIN Payments p ON ex.expense_id = p.reference_id
LEFT JOIN Employees e ON ex.approved_by = e.employee_id;

-- Query 3: JOIN - Expenses with Notifications and Employees
SELECT ex.description, n.message, e.employee_name AS created_by
FROM Expenses ex
LEFT JOIN Notifications n ON ex.expense_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 4: JOIN - Expenses with Sales and Customers
SELECT ex.reference_number, s.total_amount, cu.customer_name
FROM Expenses ex
LEFT JOIN Sales s ON ex.reference_number = s.sale_id
LEFT JOIN Customers cu ON s.customer_id = cu.customer_id;

-- Query 5: JOIN - Expenses with Purchase_Orders and Suppliers
SELECT ex.status, po.total_amount, s.supplier_name
FROM Expenses ex
LEFT JOIN Purchase_Orders po ON ex.reference_number = po.purchase_order_id
LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id;

-- Query 6: Subquery - Approved expenses
SELECT expense_type
FROM Expenses
WHERE status = 'Approved';

-- Query 7: Subquery - Expenses with payments
SELECT expense_type
FROM Expenses
WHERE EXISTS (SELECT 1 FROM Payments p WHERE p.reference_id = Expenses.expense_id);

-- Query 8: Subquery - High amount expenses
SELECT expense_type
FROM Expenses
WHERE amount > (SELECT AVG(amount) FROM Expenses);

-- Query 9: Subquery - Recent expenses
SELECT expense_type
FROM Expenses
WHERE expense_date > (SELECT MIN(expense_date) FROM Expenses);

-- Query 10: Subquery - Expenses for vendors
SELECT expense_type
FROM Expenses
WHERE vendor_id IN (SELECT vendor_id FROM Vendors);

-- Query 11: Built-in Function - Expense date formatted
SELECT expense_id, DATE_FORMAT(expense_date, '%M %d, %Y') AS formatted_date
FROM Expenses
WHERE expense_date IS NOT NULL;

-- Query 12: Built-in Function - Rounded amount
SELECT expense_id, ROUND(amount, 2) AS rounded_amount
FROM Expenses;

-- Query 13: Built-in Function - Uppercase expense type
SELECT UPPER(expense_type) AS uppercase_type
FROM Expenses;

-- Query 14: Built-in Function - Description length
SELECT expense_id, LENGTH(description) AS desc_length
FROM Expenses
WHERE description IS NOT NULL;

-- Query 15: Built-in Function - Status case
SELECT expense_id, 
       CASE 
           WHEN status = 'Approved' THEN 'Processed'
           ELSE 'Pending'
       END AS exp_status
FROM Expenses;

-- Query 16: User-Defined Function - Get amount with tax
DELIMITER //
CREATE FUNCTION GetExpenseWithTax(amount DECIMAL(10,2), tax DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN amount * (1 + tax / 100);
END //
DELIMITER ;
SELECT expense_id, GetExpenseWithTax(amount, 5) AS amount_with_tax
FROM Expenses;

-- Query 17: User-Defined Function - Check approved
DELIMITER //
CREATE FUNCTION IsApprovedExpense(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Approved' THEN
        RETURN 'Processed';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT expense_id, IsApprovedExpense(status) AS exp_status
FROM Expenses;

-- Query 18: User-Defined Function - Format vendor name from ID
DELIMITER //
CREATE FUNCTION GetExpenseVendorName(vendor_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE ven_name VARCHAR(100);
    SELECT vendor_name INTO ven_name FROM Vendors WHERE vendor_id = vendor_id;
    RETURN ven_name;
END //
DELIMITER ;
SELECT expense_id, GetExpenseVendorName(vendor_id) AS vendor_name
FROM Expenses;

-- Query 19: User-Defined Function - Calculate days since expense
DELIMITER //
CREATE FUNCTION GetDaysSinceExpense(exp_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), exp_date);
END //
DELIMITER ;
SELECT expense_id, GetDaysSinceExpense(expense_date) AS days_since
FROM Expenses;

-- Query 20: User-Defined Function - Get payment count
DELIMITER //
CREATE FUNCTION GetExpensePaymentCount(exp_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE pay_count INT;
    SELECT COUNT(*) INTO pay_count FROM Payments WHERE reference_id = exp_id;
    RETURN pay_count;
END //
DELIMITER ;
SELECT expense_id, GetExpensePaymentCount(expense_id) AS payment_count
FROM Expenses;


-- Table 19: Payments
-- Query 1: JOIN - Payments with Sales and Customers
SELECT p.payment_id, s.total_amount, cu.customer_name
FROM Payments p
LEFT JOIN Sales s ON p.reference_id = s.sale_id
LEFT JOIN Customers cu ON s.customer_id = cu.customer_id;

-- Query 2: JOIN - Payments with Expenses and Vendors
SELECT p.amount, ex.expense_type, v.vendor_name
FROM Payments p
LEFT JOIN Expenses ex ON p.reference_id = ex.expense_id
LEFT JOIN Vendors v ON ex.vendor_id = v.vendor_id;

-- Query 3: JOIN - Payments with Employees and Employee_Shifts
SELECT p.transaction_id, e.employee_name, es.total_hours
FROM Payments p
LEFT JOIN Employees e ON p.processed_by = e.employee_id
LEFT JOIN Employee_Shifts es ON e.employee_id = es.employee_id;

-- Query 4: JOIN - Payments with Notifications and Employees
SELECT p.status, n.message, e.employee_name AS created_by
FROM Payments p
LEFT JOIN Notifications n ON p.payment_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Payments with Insurance_Claims and Insurance_Providers
SELECT p.notes, ic.claim_amount, ip.provider_name
FROM Payments p
LEFT JOIN Insurance_Claims ic ON p.reference_id = ic.claim_id
LEFT JOIN Insurance_Providers ip ON ic.provider_id = ip.provider_id;

-- Query 6: Subquery - Successful payments
SELECT payment_type
FROM Payments
WHERE status = 'Success';

-- Query 7: Subquery - Payments for sales
SELECT payment_type
FROM Payments
WHERE reference_id IN (SELECT sale_id FROM Sales);

-- Query 8: Subquery - High amount payments
SELECT payment_type
FROM Payments
WHERE amount > (SELECT AVG(amount) FROM Payments);

-- Query 9: Subquery - Recent payments
SELECT payment_type
FROM Payments
WHERE payment_date > (SELECT MIN(payment_date) FROM Payments);

-- Query 10: Subquery - Payments with notes
SELECT payment_type
FROM Payments
WHERE notes IS NOT NULL;

-- Query 11: Built-in Function - Payment date formatted
SELECT payment_id, DATE_FORMAT(payment_date, '%M %d, %Y') AS formatted_date
FROM Payments
WHERE payment_date IS NOT NULL;

-- Query 12: Built-in Function - Rounded amount
SELECT payment_id, ROUND(amount, 2) AS rounded_amount
FROM Payments;

-- Query 13: Built-in Function - Uppercase payment method
SELECT UPPER(payment_method) AS uppercase_method
FROM Payments;

-- Query 14: Built-in Function - Transaction ID length
SELECT payment_id, LENGTH(transaction_id) AS tx_length
FROM Payments
WHERE transaction_id IS NOT NULL;

-- Query 15: Built-in Function - Status case
SELECT payment_id, 
       CASE 
           WHEN status = 'Success' THEN 'Completed'
           ELSE 'Failed'
       END AS pay_status
FROM Payments;

-- Query 16: User-Defined Function - Get amount with fee
DELIMITER //
CREATE FUNCTION GetPaymentWithFee(amount DECIMAL(10,2), fee DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN amount + fee;
END //
DELIMITER ;
SELECT payment_id, GetPaymentWithFee(amount, 1.5) AS amount_with_fee
FROM Payments;

-- Query 17: User-Defined Function - Check success
DELIMITER //
CREATE FUNCTION IsSuccessfulPayment(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Success' THEN
        RETURN 'Completed';
    ELSE
        RETURN 'Failed';
    END IF;
END //
DELIMITER ;
SELECT payment_id, IsSuccessfulPayment(status) AS pay_status
FROM Payments;

-- Query 18: User-Defined Function - Format employee name from ID
DELIMITER //
CREATE FUNCTION GetPaymentProcessorName(processed_by INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE emp_name VARCHAR(100);
    SELECT employee_name INTO emp_name FROM Employees WHERE employee_id = processed_by;
    RETURN emp_name;
END //
DELIMITER ;
SELECT payment_id, GetPaymentProcessorName(processed_by) AS processor_name
FROM Payments;

-- Query 19: User-Defined Function - Calculate days since payment
DELIMITER //
CREATE FUNCTION GetDaysSincePayment(pay_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), pay_date);
END //
DELIMITER ;
SELECT payment_id, GetDaysSincePayment(payment_date) AS days_since
FROM Payments;

-- Query 20: User-Defined Function - Get reference type
DELIMITER //
CREATE FUNCTION GetReferenceType(ref_id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF EXISTS (SELECT 1 FROM Sales WHERE sale_id = ref_id) THEN
        RETURN 'Sale';
    ELSEIF EXISTS (SELECT 1 FROM Expenses WHERE expense_id = ref_id) THEN
        RETURN 'Expense';
    ELSE
        RETURN 'Unknown';
    END IF;
END //
DELIMITER ;
SELECT payment_id, GetReferenceType(reference_id) AS ref_type
FROM Payments;


-- Table 20: Insurance_Providers
-- Query 1: JOIN - Insurance_Providers with Insurance_Claims and Prescriptions
SELECT ip.provider_id, ip.provider_name, ic.claim_amount, pr.total_amount
FROM Insurance_Providers ip
LEFT JOIN Insurance_Claims ic ON ip.provider_id = ic.provider_id
LEFT JOIN Prescriptions pr ON ic.prescription_id = pr.prescription_id;

-- Query 2: JOIN - Insurance_Providers with Customers and Patient_Medical_History
SELECT ip.provider_name, cu.customer_name, pmh.condition_name
FROM Insurance_Providers ip
LEFT JOIN Customers cu ON ip.provider_name = cu.insurance_provider
LEFT JOIN Patient_Medical_History pmh ON cu.customer_id = pmh.customer_id;

-- Query 3: JOIN - Insurance_Providers with Vendors and Vendor_Contracts
SELECT ip.discount_percentage, v.vendor_name, vc.contract_value
FROM Insurance_Providers ip
LEFT JOIN Vendors v ON ip.provider_name = v.vendor_name
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id;

-- Query 4: JOIN - Insurance_Providers with Notifications and Employees
SELECT ip.claim_processing_days, n.message, e.employee_name
FROM Insurance_Providers ip
LEFT JOIN Notifications n ON ip.provider_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Insurance_Providers with Payments and Sales
SELECT ip.contract_start_date, p.amount, s.total_amount
FROM Insurance_Providers ip
LEFT JOIN Insurance_Claims ic ON ip.provider_id = ic.provider_id
LEFT JOIN Payments p ON ic.claim_id = p.reference_id
LEFT JOIN Sales s ON p.reference_id = s.sale_id;

-- Query 6: Subquery - Providers with claims
SELECT provider_name
FROM Insurance_Providers
WHERE EXISTS (SELECT 1 FROM Insurance_Claims ic WHERE ic.provider_id = Insurance_Providers.provider_id);

-- Query 7: Subquery - Providers with high discount
SELECT provider_name
FROM Insurance_Providers
WHERE discount_percentage > 10;

-- Query 8: Subquery - Active providers
SELECT provider_name
FROM Insurance_Providers
WHERE contract_end_date > CURDATE();

-- Query 9: Subquery - Providers for customers
SELECT provider_name
FROM Insurance_Providers
WHERE provider_name IN (SELECT insurance_provider FROM Customers);

-- Query 10: Subquery - Recent providers
SELECT provider_name
FROM Insurance_Providers
WHERE contract_start_date > (SELECT MIN(contract_start_date) FROM Insurance_Providers);

-- Query 11: Built-in Function - Provider name length
SELECT provider_name, LENGTH(provider_name) AS name_length
FROM Insurance_Providers
WHERE LENGTH(provider_name) > 5;

-- Query 12: Built-in Function - Formatted contract start
SELECT provider_name, DATE_FORMAT(contract_start_date, '%M %d, %Y') AS formatted_start
FROM Insurance_Providers
WHERE contract_start_date IS NOT NULL;

-- Query 13: Built-in Function - Rounded discount
SELECT provider_name, ROUND(discount_percentage, 2) AS rounded_discount
FROM Insurance_Providers;

-- Query 14: Built-in Function - Uppercase address
SELECT UPPER(address) AS uppercase_address
FROM Insurance_Providers;

-- Query 15: Built-in Function - Processing days status
SELECT provider_name, 
       CASE 
           WHEN claim_processing_days < 30 THEN 'Fast'
           ELSE 'Standard'
       END AS processing_status
FROM Insurance_Providers;

-- Query 16: User-Defined Function - Get contract duration
DELIMITER //
CREATE FUNCTION GetProviderDuration(start DATE, end DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end, start);
END //
DELIMITER ;
SELECT provider_name, GetProviderDuration(contract_start_date, contract_end_date) AS duration_days
FROM Insurance_Providers;

-- Query 17: User-Defined Function - Check high discount
DELIMITER //
CREATE FUNCTION HasHighDiscount(discount DECIMAL(5,2))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF discount > 10 THEN
        RETURN 'High Discount';
    ELSE
        RETURN 'Standard';
    END IF;
END //
DELIMITER ;
SELECT provider_name, HasHighDiscount(discount_percentage) AS discount_level
FROM Insurance_Providers;

-- Query 18: User-Defined Function - Format provider name
DELIMITER //
CREATE FUNCTION FormatProviderName(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT provider_name, FormatProviderName(provider_name) AS formatted_name
FROM Insurance_Providers;

-- Query 19: User-Defined Function - Calculate days to end
DELIMITER //
CREATE FUNCTION GetDaysToContractEndProvider(end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, CURDATE());
END //
DELIMITER ;
SELECT provider_name, GetDaysToContractEndProvider(contract_end_date) AS days_to_end
FROM Insurance_Providers;

-- Query 20: User-Defined Function - Get claim count
DELIMITER //
CREATE FUNCTION GetProviderClaimCount(provider_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE claim_count INT;
    SELECT COUNT(*) INTO claim_count FROM Insurance_Claims WHERE provider_id = provider_id;
    RETURN claim_count;
END //
DELIMITER ;
SELECT provider_name, GetProviderClaimCount(provider_id) AS claim_count
FROM Insurance_Providers;


-- Table 21: Insurance_Claims
-- Query 1: JOIN - Insurance_Claims with Insurance_Providers and Prescriptions
SELECT ic.claim_id, ip.provider_name, pr.prescription_date
FROM Insurance_Claims ic
LEFT JOIN Insurance_Providers ip ON ic.provider_id = ip.provider_id
LEFT JOIN Prescriptions pr ON ic.prescription_id = pr.prescription_id;

-- Query 2: JOIN - Insurance_Claims with Customers and Patient_Medical_History
SELECT ic.claim_amount, cu.customer_name, pmh.condition_name
FROM Insurance_Claims ic
LEFT JOIN Prescriptions pr ON ic.prescription_id = pr.prescription_id
LEFT JOIN Customers cu ON pr.customer_id = cu.customer_id
LEFT JOIN Patient_Medical_History pmh ON cu.customer_id = pmh.customer_id;

-- Query 3: JOIN - Insurance_Claims with Payments and Employees
SELECT ic.covered_amount, p.amount, e.employee_name
FROM Insurance_Claims ic
LEFT JOIN Payments p ON ic.claim_id = p.reference_id
LEFT JOIN Employees e ON p.processed_by = e.employee_id;

-- Query 4: JOIN - Insurance_Claims with Notifications and Employees
SELECT ic.status, n.message, e.employee_name AS created_by
FROM Insurance_Claims ic
LEFT JOIN Notifications n ON ic.claim_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Insurance_Claims with Prescription_Items and Products
SELECT ic.processed_date, pi.quantity, p.product_name
FROM Insurance_Claims ic
LEFT JOIN Prescriptions pr ON ic.prescription_id = pr.prescription_id
LEFT JOIN Prescription_Items pi ON pr.prescription_id = pi.prescription_id
LEFT JOIN Products p ON pi.product_id = p.product_id;

-- Query 6: Subquery - Processed claims
SELECT claim_date
FROM Insurance_Claims
WHERE status = 'Processed';

-- Query 7: Subquery - Claims with rejection
SELECT claim_date
FROM Insurance_Claims
WHERE rejection_reason IS NOT NULL;

-- Query 8: Subquery - High covered claims
SELECT claim_date
FROM Insurance_Claims
WHERE covered_amount > (SELECT AVG(covered_amount) FROM Insurance_Claims);

-- Query 9: Subquery - Claims for prescriptions
SELECT claim_date
FROM Insurance_Claims
WHERE prescription_id IN (SELECT prescription_id FROM Prescriptions);

-- Query 10: Subquery - Recent claims
SELECT claim_date
FROM Insurance_Claims
WHERE claim_date > (SELECT MIN(claim_date) FROM Insurance_Claims);

-- Query 11: Built-in Function - Claim date formatted
SELECT claim_id, DATE_FORMAT(claim_date, '%M %d, %Y') AS formatted_date
FROM Insurance_Claims
WHERE claim_date IS NOT NULL;

-- Query 12: Built-in Function - Rounded claim amount
SELECT claim_id, ROUND(claim_amount, 2) AS rounded_claim
FROM Insurance_Claims;

-- Query 13: Built-in Function - Uppercase status
SELECT UPPER(status) AS uppercase_status
FROM Insurance_Claims;

-- Query 14: Built-in Function - Rejection reason length
SELECT claim_id, LENGTH(rejection_reason) AS reason_length
FROM Insurance_Claims
WHERE rejection_reason IS NOT NULL;

-- Query 15: Built-in Function - Coverage status
SELECT claim_id, 
       CASE 
           WHEN covered_amount = claim_amount THEN 'Fully Covered'
           ELSE 'Partial'
       END AS coverage_status
FROM Insurance_Claims;

-- Query 16: User-Defined Function - Get uncovered amount
DELIMITER //
CREATE FUNCTION GetUncoveredAmount(claim DECIMAL(10,2), covered DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN claim - covered;
END //
DELIMITER ;
SELECT claim_id, GetUncoveredAmount(claim_amount, covered_amount) AS uncovered
FROM Insurance_Claims;

-- Query 17: User-Defined Function - Check processed
DELIMITER //
CREATE FUNCTION IsProcessedClaim(status VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF status = 'Processed' THEN
        RETURN 'Done';
    ELSE
        RETURN 'Pending';
    END IF;
END //
DELIMITER ;
SELECT claim_id, IsProcessedClaim(status) AS claim_status
FROM Insurance_Claims;

-- Query 18: User-Defined Function - Format provider name from ID
DELIMITER //
CREATE FUNCTION GetClaimProviderName(provider_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prov_name VARCHAR(100);
    SELECT provider_name INTO prov_name FROM Insurance_Providers WHERE provider_id = provider_id;
    RETURN prov_name;
END //
DELIMITER ;
SELECT claim_id, GetClaimProviderName(provider_id) AS provider_name
FROM Insurance_Claims;

-- Query 19: User-Defined Function - Calculate days processed
DELIMITER //
CREATE FUNCTION GetDaysProcessed(claim_date DATE, processed DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(processed, claim_date);
END //
DELIMITER ;
SELECT claim_id, GetDaysProcessed(claim_date, processed_date) AS days_processed
FROM Insurance_Claims;

-- Query 20: User-Defined Function - Get prescription count
DELIMITER //
CREATE FUNCTION GetClaimPrescriptionDoctor(pres_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE doc_name VARCHAR(100);
    SELECT doctor_name INTO doc_name FROM Prescriptions WHERE prescription_id = pres_id;
    RETURN doc_name;
END //
DELIMITER ;
SELECT claim_id, GetClaimPrescriptionDoctor(prescription_id) AS doctor_name
FROM Insurance_Claims;


-- Table 22: Patient_Medical_History
-- Query 1: JOIN - Patient_Medical_History with Customers and Prescriptions
SELECT pmh.history_id, cu.customer_name, pr.doctor_name
FROM Patient_Medical_History pmh
LEFT JOIN Customers cu ON pmh.customer_id = cu.customer_id
LEFT JOIN Prescriptions pr ON cu.customer_id = pr.customer_id;

-- Query 2: JOIN - Patient_Medical_History with Insurance_Claims and Insurance_Providers
SELECT pmh.condition_name, ic.claim_amount, ip.provider_name
FROM Patient_Medical_History pmh
LEFT JOIN Customers cu ON pmh.customer_id = cu.customer_id
LEFT JOIN Prescriptions pr ON cu.customer_id = pr.customer_id
LEFT JOIN Insurance_Claims ic ON pr.prescription_id = ic.prescription_id
LEFT JOIN Insurance_Providers ip ON ic.provider_id = ip.provider_id;

-- Query 3: JOIN - Patient_Medical_History with Prescription_Items and Products
SELECT pmh.severity, pi.quantity, p.product_name
FROM Patient_Medical_History pmh
LEFT JOIN Customers cu ON pmh.customer_id = cu.customer_id
LEFT JOIN Prescriptions pr ON cu.customer_id = pr.customer_id
LEFT JOIN Prescription_Items pi ON pr.prescription_id = pi.prescription_id
LEFT JOIN Products p ON pi.product_id = p.product_id;

-- Query 4: JOIN - Patient_Medical_History with Notifications and Employees
SELECT pmh.current_status, n.message, e.employee_name
FROM Patient_Medical_History pmh
LEFT JOIN Notifications n ON pmh.history_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Patient_Medical_History with Drug_Interactions and Products
SELECT pmh.treatment_description, di.severity, p1.product_name
FROM Patient_Medical_History pmh
LEFT JOIN Prescriptions pr ON pmh.customer_id = pr.customer_id
LEFT JOIN Prescription_Items pi ON pr.prescription_id = pi.prescription_id
LEFT JOIN Drug_Interactions di ON pi.product_id = di.product_id1
LEFT JOIN Products p1 ON di.product_id1 = p1.product_id;

-- Query 6: Subquery - History with controlled status
SELECT condition_name
FROM Patient_Medical_History
WHERE current_status = 'Controlled';

-- Query 7: Subquery - Severe history
SELECT condition_name
FROM Patient_Medical_History
WHERE severity = 'Severe';

-- Query 8: Subquery - History with notes
SELECT condition_name
FROM Patient_Medical_History
WHERE notes IS NOT NULL;

-- Query 9: Subquery - Recent diagnoses
SELECT condition_name
FROM Patient_Medical_History
WHERE diagnosis_date > (SELECT MIN(diagnosis_date) FROM Patient_Medical_History);

-- Query 10: Subquery - History for customers
SELECT condition_name
FROM Patient_Medical_History
WHERE customer_id IN (SELECT customer_id FROM Customers);

-- Query 11: Built-in Function - Condition length
SELECT condition_name, LENGTH(condition_name) AS cond_length
FROM Patient_Medical_History
WHERE LENGTH(condition_name) > 5;

-- Query 12: Built-in Function - Formatted diagnosis date
SELECT condition_name, DATE_FORMAT(diagnosis_date, '%M %d, %Y') AS formatted_diag
FROM Patient_Medical_History
WHERE diagnosis_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase severity
SELECT UPPER(severity) AS uppercase_severity
FROM Patient_Medical_History;

-- Query 14: Built-in Function - Treatment length
SELECT condition_name, LENGTH(treatment_description) AS treat_length
FROM Patient_Medical_History
WHERE treatment_description IS NOT NULL;

-- Query 15: Built-in Function - Status case
SELECT condition_name, 
       CASE 
           WHEN current_status = 'Controlled' THEN 'Stable'
           ELSE 'Unstable'
       END AS health_status
FROM Patient_Medical_History;

-- Query 16: User-Defined Function - Get days since diagnosis
DELIMITER //
CREATE FUNCTION GetDaysSinceDiagnosis(diag_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), diag_date);
END //
DELIMITER ;
SELECT condition_name, GetDaysSinceDiagnosis(diagnosis_date) AS days_since_diag
FROM Patient_Medical_History;

-- Query 17: User-Defined Function - Check severe
DELIMITER //
CREATE FUNCTION IsSevereCondition(severity VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF severity = 'Severe' THEN
        RETURN 'Critical';
    ELSE
        RETURN 'Manageable';
    END IF;
END //
DELIMITER ;
SELECT condition_name, IsSevereCondition(severity) AS cond_level
FROM Patient_Medical_History;

-- Query 18: User-Defined Function - Format doctor name
DELIMITER //
CREATE FUNCTION FormatDoctorNameHistory(name VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(name);
END //
DELIMITER ;
SELECT condition_name, FormatDoctorNameHistory(doctor_name) AS formatted_doctor
FROM Patient_Medical_History;

-- Query 19: User-Defined Function - Get customer name from ID
DELIMITER //
CREATE FUNCTION GetHistoryCustomerName(customer_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE cust_name VARCHAR(100);
    SELECT customer_name INTO cust_name FROM Customers WHERE customer_id = customer_id;
    RETURN cust_name;
END //
DELIMITER ;
SELECT condition_name, GetHistoryCustomerName(customer_id) AS customer_name
FROM Patient_Medical_History;

-- Query 20: User-Defined Function - Get prescription count for patient
DELIMITER //
CREATE FUNCTION GetPatientPrescriptionCount(customer_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE pr_count INT;
    SELECT COUNT(*) INTO pr_count FROM Prescriptions WHERE customer_id = customer_id;
    RETURN pr_count;
END //
DELIMITER ;
SELECT condition_name, GetPatientPrescriptionCount(customer_id) AS prescription_count
FROM Patient_Medical_History;


-- Table 23: Drug_Interactions
-- Query 1: JOIN - Drug_Interactions with Products and Categories (for product1)
SELECT di.interaction_id, p1.product_name, c1.category_name
FROM Drug_Interactions di
LEFT JOIN Products p1 ON di.product_id1 = p1.product_id
LEFT JOIN Categories c1 ON p1.category_id = c1.category_id;

-- Query 2: JOIN - Drug_Interactions with Products and Manufacturers (for product2)
SELECT di.severity, p2.product_name, m2.manufacturer_name
FROM Drug_Interactions di
LEFT JOIN Products p2 ON di.product_id2 = p2.product_id
LEFT JOIN Manufacturers m2 ON p2.manufacturer_id = m2.manufacturer_id;

-- Query 3: JOIN - Drug_Interactions with Prescription_Items and Prescriptions
SELECT di.description, pi.quantity, pr.doctor_name
FROM Drug_Interactions di
LEFT JOIN Prescription_Items pi ON di.product_id1 = pi.product_id
LEFT JOIN Prescriptions pr ON pi.prescription_id = pr.prescription_id;

-- Query 4: JOIN - Drug_Interactions with Inventory and Inventory_Adjustments
SELECT di.management_guidance, i.quantity_in_stock, ia.reason
FROM Drug_Interactions di
LEFT JOIN Inventory i ON di.product_id1 = i.product_id
LEFT JOIN Inventory_Adjustments ia ON i.product_id = ia.product_id;

-- Query 5: JOIN - Drug_Interactions with Notifications and Employees
SELECT di.reference_source, n.message, e.employee_name
FROM Drug_Interactions di
LEFT JOIN Notifications n ON di.interaction_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 6: Subquery - Major interactions
SELECT interaction_type
FROM Drug_Interactions
WHERE severity = 'Major';

-- Query 7: Subquery - Interactions with products
SELECT interaction_type
FROM Drug_Interactions
WHERE product_id1 IN (SELECT product_id FROM Products);

-- Query 8: Subquery - Pharmacokinetic interactions
SELECT interaction_type
FROM Drug_Interactions
WHERE interaction_type = 'Pharmacokinetic';

-- Query 9: Subquery - Recent interactions
SELECT interaction_type
FROM Drug_Interactions
WHERE created_date > (SELECT MIN(created_date) FROM Drug_Interactions);

-- Query 10: Subquery - Interactions with description
SELECT interaction_type
FROM Drug_Interactions
WHERE description IS NOT NULL;

-- Query 11: Built-in Function - Description length
SELECT interaction_id, LENGTH(description) AS desc_length
FROM Drug_Interactions
WHERE description IS NOT NULL;

-- Query 12: Built-in Function - Formatted created date
SELECT interaction_id, DATE_FORMAT(created_date, '%M %d, %Y') AS formatted_date
FROM Drug_Interactions
WHERE created_date IS NOT NULL;

-- Query 13: Built-in Function - Uppercase severity
SELECT UPPER(severity) AS uppercase_severity
FROM Drug_Interactions;

-- Query 14: Built-in Function - Reference length
SELECT interaction_id, LENGTH(reference_source) AS ref_length
FROM Drug_Interactions
WHERE reference_source IS NOT NULL;

-- Query 15: Built-in Function - Type case
SELECT interaction_id, 
       CASE 
           WHEN interaction_type = 'Pharmacokinetic' THEN 'PK'
           ELSE 'PD'
       END AS type_abbr
FROM Drug_Interactions;

-- Query 16: User-Defined Function - Get product1 name
DELIMITER //
CREATE FUNCTION GetInteractionProduct1Name(product_id1 INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id1;
    RETURN prod_name;
END //
DELIMITER ;
SELECT interaction_id, GetInteractionProduct1Name(product_id1) AS product1_name
FROM Drug_Interactions;

-- Query 17: User-Defined Function - Check major severity
DELIMITER //
CREATE FUNCTION IsMajorInteraction(severity VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF severity = 'Major' THEN
        RETURN 'Critical';
    ELSE
        RETURN 'Minor';
    END IF;
END //
DELIMITER ;
SELECT interaction_id, IsMajorInteraction(severity) AS severity_level
FROM Drug_Interactions;

-- Query 18: User-Defined Function - Format interaction type
DELIMITER //
CREATE FUNCTION FormatInteractionType(type VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(type);
END //
DELIMITER ;
SELECT interaction_id, FormatInteractionType(interaction_type) AS formatted_type
FROM Drug_Interactions;

-- Query 19: User-Defined Function - Get age of interaction
DELIMITER //
CREATE FUNCTION GetInteractionAge(created_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), created_date);
END //
DELIMITER ;
SELECT interaction_id, GetInteractionAge(created_date) AS age_days
FROM Drug_Interactions;

-- Query 20: User-Defined Function - Get product2 name
DELIMITER //
CREATE FUNCTION GetInteractionProduct2Name(product_id2 INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id2;
    RETURN prod_name;
END //
DELIMITER ;
SELECT interaction_id, GetInteractionProduct2Name(product_id2) AS product2_name
FROM Drug_Interactions;


-- Table 24: Inventory_Adjustments
-- Query 1: JOIN - Inventory_Adjustments with Products and Categories
SELECT ia.adjustment_id, p.product_name, c.category_name
FROM Inventory_Adjustments ia
LEFT JOIN Products p ON ia.product_id = p.product_id
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 2: JOIN - Inventory_Adjustments with Employees and Employee_Shifts
SELECT ia.quantity_adjusted, e.employee_name, es.total_hours
FROM Inventory_Adjustments ia
LEFT JOIN Employees e ON ia.adjusted_by = e.employee_id
LEFT JOIN Employee_Shifts es ON e.employee_id = es.employee_id;

-- Query 3: JOIN - Inventory_Adjustments with Inventory and Purchase_Order_Items
SELECT ia.reason, i.quantity_in_stock, poi.quantity_received
FROM Inventory_Adjustments ia
LEFT JOIN Inventory i ON ia.product_id = i.product_id
LEFT JOIN Purchase_Order_Items poi ON ia.product_id = poi.product_id;

-- Query 4: JOIN - Inventory_Adjustments with Notifications and Employees
SELECT ia.adjustment_type, n.message, e.employee_name AS created_by
FROM Inventory_Adjustments ia
LEFT JOIN Notifications n ON ia.adjustment_id = n.related_id
LEFT JOIN Employees e ON n.created_by = e.employee_id;

-- Query 5: JOIN - Inventory_Adjustments with Drug_Interactions and Products
SELECT ia.notes, di.severity, p.product_name
FROM Inventory_Adjustments ia
LEFT JOIN Products p ON ia.product_id = p.product_id
LEFT JOIN Drug_Interactions di ON p.product_id = di.product_id1;

-- Query 6: Subquery - Loss adjustments
SELECT reason
FROM Inventory_Adjustments
WHERE adjustment_type = 'Loss';

-- Query 7: Subquery - Adjustments with notes
SELECT reason
FROM Inventory_Adjustments
WHERE notes IS NOT NULL;

-- Query 8: Subquery - Recent adjustments
SELECT reason
FROM Inventory_Adjustments
WHERE adjustment_date > (SELECT MIN(adjustment_date) FROM Inventory_Adjustments);

-- Query 9: Subquery - Adjustments for products
SELECT reason
FROM Inventory_Adjustments
WHERE product_id IN (SELECT product_id FROM Products);

-- Query 10: Subquery - Positive adjustments
SELECT reason
FROM Inventory_Adjustments
WHERE quantity_adjusted > 0;

-- Query 11: Built-in Function - Adjustment date formatted
SELECT adjustment_id, DATE_FORMAT(adjustment_date, '%M %d, %Y') AS formatted_date
FROM Inventory_Adjustments
WHERE adjustment_date IS NOT NULL;

-- Query 12: Built-in Function - Quantity absolute
SELECT adjustment_id, ABS(quantity_adjusted) AS abs_quantity
FROM Inventory_Adjustments;

-- Query 13: Built-in Function - Uppercase reason
SELECT UPPER(reason) AS uppercase_reason
FROM Inventory_Adjustments;

-- Query 14: Built-in Function - Notes length
SELECT adjustment_id, LENGTH(notes) AS notes_length
FROM Inventory_Adjustments
WHERE notes IS NOT NULL;

-- Query 15: Built-in Function - Type case
SELECT adjustment_id, 
       CASE 
           WHEN adjustment_type = 'Loss' THEN 'Negative'
           ELSE 'Positive'
       END AS adj_type
FROM Inventory_Adjustments;

-- Query 16: User-Defined Function - Get adjusted by name
DELIMITER //
CREATE FUNCTION GetAdjustmentEmployeeName(adjusted_by INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE emp_name VARCHAR(100);
    SELECT employee_name INTO emp_name FROM Employees WHERE employee_id = adjusted_by;
    RETURN emp_name;
END //
DELIMITER ;
SELECT adjustment_id, GetAdjustmentEmployeeName(adjusted_by) AS employee_name
FROM Inventory_Adjustments;

-- Query 17: User-Defined Function - Check loss type
DELIMITER //
CREATE FUNCTION IsLossAdjustment(type VARCHAR(20))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF type = 'Loss' THEN
        RETURN 'Negative';
    ELSE
        RETURN 'Positive';
    END IF;
END //
DELIMITER ;
SELECT adjustment_id, IsLossAdjustment(adjustment_type) AS adj_status
FROM Inventory_Adjustments;

-- Query 18: User-Defined Function - Format reason
DELIMITER //
CREATE FUNCTION FormatAdjustmentReason(reason VARCHAR(100))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    RETURN UPPER(reason);
END //
DELIMITER ;
SELECT adjustment_id, FormatAdjustmentReason(reason) AS formatted_reason
FROM Inventory_Adjustments;

-- Query 19: User-Defined Function - Get days since adjustment
DELIMITER //
CREATE FUNCTION GetDaysSinceAdjustment(adj_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), adj_date);
END //
DELIMITER ;
SELECT adjustment_id, GetDaysSinceAdjustment(adjustment_date) AS days_since
FROM Inventory_Adjustments;

-- Query 20: User-Defined Function - Get product name
DELIMITER //
CREATE FUNCTION GetAdjustmentProductName(product_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE prod_name VARCHAR(100);
    SELECT product_name INTO prod_name FROM Products WHERE product_id = product_id;
    RETURN prod_name;
END //
DELIMITER ;
SELECT adjustment_id, GetAdjustmentProductName(product_id) AS product_name
FROM Inventory_Adjustments;


-- Table 25: Notifications
-- Query 1: JOIN - Notifications with Employees (created_for) and Employees (created_by)
SELECT n.notification_id, e1.employee_name AS for_name, e2.employee_name AS by_name
FROM Notifications n
LEFT JOIN Employees e1 ON n.created_for = e1.employee_id
LEFT JOIN Employees e2 ON n.created_by = e2.employee_id;

-- Query 2: JOIN - Notifications with Inventory_Adjustments and Products
SELECT n.message, ia.reason, p.product_name
FROM Notifications n
LEFT JOIN Inventory_Adjustments ia ON n.related_id = ia.adjustment_id
LEFT JOIN Products p ON ia.product_id = p.product_id;

-- Query 3: JOIN - Notifications with Prescriptions and Customers
SELECT n.priority, pr.doctor_name, cu.customer_name
FROM Notifications n
LEFT JOIN Prescriptions pr ON n.related_id = pr.prescription_id
LEFT JOIN Customers cu ON pr.customer_id = cu.customer_id;

-- Query 4: JOIN - Notifications with Sales and Customers
SELECT n.status, s.total_amount, cu.customer_name
FROM Notifications n
LEFT JOIN Sales s ON n.related_id = s.sale_id
LEFT JOIN Customers cu ON s.customer_id = cu.customer_id;

-- Query 5: JOIN - Notifications with Purchase_Orders and Suppliers
SELECT n.created_date, po.total_amount, s.supplier_name
FROM Notifications n
LEFT JOIN Purchase_Orders po ON n.related_id = po.purchase_order_id
LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id;

-- Query 6: Subquery - High priority notifications
SELECT message
FROM Notifications
WHERE priority = 'High';

-- Query 7: Subquery - Pending notifications
SELECT message
FROM Notifications
WHERE status = 'Pending';

-- Query 8: Subquery - Notifications for employees
SELECT message
FROM Notifications
WHERE created_for IN (SELECT employee_id FROM Employees);

-- Query 9: Subquery - Resolved notifications
SELECT message
FROM Notifications
WHERE resolved_date IS NOT NULL;

-- Query 10: Subquery - Recent notifications
SELECT message
FROM Notifications
WHERE created_date > (SELECT MIN(created_date) FROM Notifications);

-- Query 11: Built-in Function - Message length
SELECT notification_id, LENGTH(message) AS msg_length
FROM Notifications
WHERE message IS NOT NULL;

-- Query 12: Built-in Function - Formatted created date
SELECT notification_id, DATE_FORMAT(created_date, '%M %d, %Y %H:%i') AS formatted_created
FROM Notifications;

-- Query 13: Built-in Function - Uppercase type
SELECT UPPER(notification_type) AS uppercase_type
FROM Notifications;

-- Query 14: Built-in Function - Priority upper
SELECT UPPER(priority) AS uppercase_priority
FROM Notifications;

-- Query 15: Built-in Function - Status case
SELECT notification_id, 
       CASE 
           WHEN status = 'Pending' THEN 'Open'
           ELSE 'Closed'
       END AS notif_status
FROM Notifications;

-- Query 16: User-Defined Function - Get days to resolve
DELIMITER //
CREATE FUNCTION GetDaysToResolve(created TIMESTAMP, resolved TIMESTAMP)
RETURNS INT
DETERMINISTIC
BEGIN
    IF resolved IS NULL THEN RETURN 0;
    ELSE RETURN TIMESTAMPDIFF(DAY, created, resolved);
    END IF;
END //
DELIMITER ;
SELECT notification_id, GetDaysToResolve(created_date, resolved_date) AS days_to_resolve
FROM Notifications;

-- Query 17: User-Defined Function - Check high priority
DELIMITER //
CREATE FUNCTION IsHighPriority(priority VARCHAR(20))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF priority = 'High' THEN
        RETURN 'Urgent';
    ELSE
        RETURN 'Normal';
    END IF;
END //
DELIMITER ;
SELECT notification_id, IsHighPriority(priority) AS priority_level
FROM Notifications;

-- Query 18: User-Defined Function - Format message
DELIMITER //
CREATE FUNCTION FormatNotificationMessage(msg TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    RETURN UPPER(LEFT(msg, 1)) + SUBSTRING(msg, 2);
END //
DELIMITER ;
SELECT notification_id, FormatNotificationMessage(message) AS formatted_message
FROM Notifications;

-- Query 19: User-Defined Function - Get created for name
DELIMITER //
CREATE FUNCTION GetNotifCreatedForName(created_for INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE emp_name VARCHAR(100);
    SELECT employee_name INTO emp_name FROM Employees WHERE employee_id = created_for;
    RETURN emp_name;
END //
DELIMITER ;
SELECT notification_id, GetNotifCreatedForName(created_for) AS for_name
FROM Notifications;

-- Query 20: User-Defined Function - Get created by name
DELIMITER //
CREATE FUNCTION GetNotifCreatedByName(created_by INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE emp_name VARCHAR(100);
    SELECT employee_name INTO emp_name FROM Employees WHERE employee_id = created_by;
    RETURN emp_name;
END //
DELIMITER ;
SELECT notification_id, GetNotifCreatedByName(created_by) AS by_name
FROM Notifications;
