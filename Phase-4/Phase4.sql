-- Project Phase-4(V&C<SP<WF<D&TCL<Tri) Pharmacy
-- Table 1: Suppliers
-- 1. View: Active suppliers with recent creation
CREATE VIEW ActiveRecentSuppliers AS
SELECT supplier_id, supplier_name, contact_person, phone, email
FROM Suppliers
WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 2. View: Suppliers with purchase orders
CREATE VIEW SuppliersWithPurchaseOrders AS
SELECT s.supplier_id, s.supplier_name, COUNT(po.purchase_order_id) AS order_count
FROM Suppliers s
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id
GROUP BY s.supplier_id;

-- 3. View: Supplier contact details
CREATE VIEW SupplierContacts AS
SELECT supplier_id, supplier_name, email, phone
FROM Suppliers
WHERE email IS NOT NULL;

-- 4. CTE: Average orders by supplier
WITH SupplierAvgOrders AS (
    SELECT supplier_id, AVG(total_amount) AS avg_amount
    FROM Purchase_Orders
    GROUP BY supplier_id
)
SELECT s.supplier_id, s.supplier_name, o.avg_amount
FROM SupplierAvgOrders o
JOIN Suppliers s ON o.supplier_id = s.supplier_id
WHERE o.avg_amount > 1000;

-- 5. CTE: Suppliers with high orders
WITH HighOrderSuppliers AS (
    SELECT supplier_id, COUNT(*) AS order_count
    FROM Purchase_Orders
    GROUP BY supplier_id
)
SELECT s.supplier_name, h.order_count
FROM HighOrderSuppliers h
JOIN Suppliers s ON h.supplier_id = s.supplier_id
WHERE h.order_count > 2;

-- 6. CTE: Ranked suppliers by creation date
WITH RankedSuppliers AS (
    SELECT supplier_id, supplier_name, created_date,
           RANK() OVER (ORDER BY created_date DESC) AS create_rank
    FROM Suppliers
)
SELECT supplier_name, created_date, create_rank
FROM RankedSuppliers
WHERE create_rank <= 5;

-- 7. Stored Procedure: Update supplier email
DELIMITER //
CREATE PROCEDURE UpdateSupplierEmail(IN sup_id INT, IN new_email VARCHAR(100))
BEGIN
    UPDATE Suppliers SET email = new_email WHERE supplier_id = sup_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old suppliers
DELIMITER //
CREATE PROCEDURE DeleteOldSuppliers()
BEGIN
    DELETE FROM Suppliers WHERE created_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get suppliers by country
DELIMITER //
CREATE PROCEDURE GetSuppliersByCountry(IN cnt VARCHAR(50))
BEGIN
    SELECT supplier_id, supplier_name, email
    FROM Suppliers
    WHERE country = cnt;
END //
DELIMITER ;

-- 10. TCL: Update supplier details with rollback
START TRANSACTION;
UPDATE Suppliers SET email = 'new.email@email.com' WHERE supplier_id = 1;
UPDATE Suppliers SET phone = '555-9999' WHERE supplier_id = 2;
-- Simulate error
INSERT INTO Suppliers (supplier_id) VALUES (1); -- Duplicate key error
COMMIT;
ROLLBACK;

-- 11. TCL: Commit address update
START TRANSACTION;
UPDATE Suppliers SET address = '123 New St' WHERE supplier_id = 3;
SAVEPOINT address_updated;
UPDATE Suppliers SET city = 'New City' WHERE supplier_id = 3;
COMMIT;

-- 12. TCL: Rollback email update
START TRANSACTION;
UPDATE Suppliers SET email = 'test@email.com' WHERE supplier_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Suppliers TO 'user1'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Suppliers TO 'supply_manager';

-- 15. Trigger: Log supplier changes
DELIMITER //
CREATE TRIGGER LogSupplierChange
AFTER UPDATE ON Suppliers
FOR EACH ROW
BEGIN
    IF OLD.email != NEW.email THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Email Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Supplier ID: ', NEW.supplier_id, ' Email changed to ', NEW.email),
                'Suppliers', 'Contact update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid phone
DELIMITER //
CREATE TRIGGER PreventInvalidPhone
BEFORE UPDATE ON Suppliers
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.phone) < 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phone number must be at least 10 characters';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new supplier
DELIMITER //
CREATE TRIGGER LogNewSupplier
AFTER INSERT ON Suppliers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Supplier', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Supplier ID: ', NEW.supplier_id, ' added'),
            'Suppliers', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank suppliers by creation
SELECT supplier_id, supplier_name, created_date,
       RANK() OVER (ORDER BY created_date DESC) AS create_rank
FROM Suppliers;

-- 19. Window Function: Running total suppliers by country
SELECT supplier_id, supplier_name, country,
       COUNT(*) OVER (PARTITION BY country ORDER BY supplier_id) AS country_count
FROM Suppliers;

-- 20. Window Function: Supplier percentage by country
SELECT supplier_id, country,
       COUNT(*) OVER (PARTITION BY country) / COUNT(*) OVER () * 100 AS country_percentage
FROM Suppliers;


-- Table 2: Categories
-- 1. View: Active categories with notes
CREATE VIEW ActiveCategories AS
SELECT category_id, category_name, description
FROM Categories
WHERE is_active = TRUE AND notes IS NOT NULL;

-- 2. View: Categories with products
CREATE VIEW CategoriesWithProducts AS
SELECT c.category_id, c.category_name, COUNT(p.product_id) AS product_count
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_id;

-- 3. View: Top level categories
CREATE VIEW TopLevelCategories AS
SELECT category_id, category_name, sort_order
FROM Categories
WHERE parent_category_id IS NULL;

-- 4. CTE: Average products by category
WITH CategoryAvgProducts AS (
    SELECT category_id, COUNT(product_id) AS product_count
    FROM Products
    GROUP BY category_id
)
SELECT c.category_id, c.category_name, a.product_count
FROM CategoryAvgProducts a
JOIN Categories c ON a.category_id = c.category_id
WHERE a.product_count > 5;

-- 5. CTE: Categories with subcategories
WITH SubCategories AS (
    SELECT parent_category_id, COUNT(*) AS sub_count
    FROM Categories
    WHERE parent_category_id IS NOT NULL
    GROUP BY parent_category_id
)
SELECT c.category_name, s.sub_count
FROM SubCategories s
JOIN Categories c ON s.parent_category_id = c.category_id
WHERE s.sub_count > 1;

-- 6. CTE: Ranked categories by sort order
WITH RankedCategories AS (
    SELECT category_id, category_name, sort_order,
           RANK() OVER (ORDER BY sort_order ASC) AS sort_rank
    FROM Categories
)
SELECT category_name, sort_order, sort_rank
FROM RankedCategories
WHERE sort_rank <= 5;

-- 7. Stored Procedure: Update category description
DELIMITER //
CREATE PROCEDURE UpdateCategoryDescription(IN cat_id INT, IN new_desc TEXT)
BEGIN
    UPDATE Categories SET description = new_desc WHERE category_id = cat_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Deactivate inactive categories
DELIMITER //
CREATE PROCEDURE DeactivateInactiveCategories()
BEGIN
    UPDATE Categories SET is_active = FALSE WHERE updated_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get categories by parent
DELIMITER //
CREATE PROCEDURE GetCategoriesByParent(IN parent_id INT)
BEGIN
    SELECT category_id, category_name, description
    FROM Categories
    WHERE parent_category_id = parent_id AND is_active = TRUE;
END //
DELIMITER ;

-- 10. TCL: Update category details with rollback
START TRANSACTION;
UPDATE Categories SET description = 'New desc' WHERE category_id = 1;
UPDATE Categories SET sort_order = 10 WHERE category_id = 2;
-- Simulate error
INSERT INTO Categories (category_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit name update
START TRANSACTION;
UPDATE Categories SET category_name = 'New Name' WHERE category_id = 3;
SAVEPOINT name_updated;
UPDATE Categories SET notes = 'Updated notes' WHERE category_id = 3;
COMMIT;

-- 12. TCL: Rollback description update
START TRANSACTION;
UPDATE Categories SET description = 'Test desc' WHERE category_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Categories TO 'user2'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Categories TO 'category_manager';

-- 15. Trigger: Log category updates
DELIMITER //
CREATE TRIGGER LogCategoryUpdate
AFTER UPDATE ON Categories
FOR EACH ROW
BEGIN
    IF OLD.category_name != NEW.category_name THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Name Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Category ID: ', NEW.category_id, ' Name changed to ', NEW.category_name),
                'Categories', 'Name change');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid sort order
DELIMITER //
CREATE TRIGGER PreventInvalidSortOrder
BEFORE UPDATE ON Categories
FOR EACH ROW
BEGIN
    IF NEW.sort_order < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sort order cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new category
DELIMITER //
CREATE TRIGGER LogNewCategory
AFTER INSERT ON Categories
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.created_by, 'New Category', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Category ID: ', NEW.category_id, ' added'),
            'Categories', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank categories by sort order
SELECT category_id, category_name, sort_order,
       RANK() OVER (ORDER BY sort_order ASC) AS sort_rank
FROM Categories;

-- 19. Window Function: Running total subcategories
SELECT category_id, category_name, parent_category_id,
       COUNT(*) OVER (PARTITION BY parent_category_id ORDER BY category_id) AS sub_count
FROM Categories;

-- 20. Window Function: Category percentage by parent
SELECT category_id, parent_category_id,
       COUNT(*) OVER (PARTITION BY parent_category_id) / COUNT(*) OVER () * 100 AS parent_percentage
FROM Categories;


-- Table 3: Manufacturers
-- 1. View: Manufacturers with products
CREATE VIEW ManufacturersWithProducts AS
SELECT m.manufacturer_id, m.manufacturer_name, COUNT(p.product_id) AS product_count
FROM Manufacturers m
LEFT JOIN Products p ON m.manufacturer_id = p.manufacturer_id
GROUP BY m.manufacturer_id;

-- 2. View: Manufacturers contact details
CREATE VIEW ManufacturerContacts AS
SELECT manufacturer_id, manufacturer_name, email, phone
FROM Manufacturers
WHERE email IS NOT NULL;

-- 3. View: Licensed manufacturers
CREATE VIEW LicensedManufacturers AS
SELECT manufacturer_id, manufacturer_name, license_number
FROM Manufacturers
WHERE license_number IS NOT NULL;

-- 4. CTE: Average products by manufacturer
WITH ManufacturerAvgProducts AS (
    SELECT manufacturer_id, COUNT(product_id) AS product_count
    FROM Products
    GROUP BY manufacturer_id
)
SELECT m.manufacturer_id, m.manufacturer_name, a.product_count
FROM ManufacturerAvgProducts a
JOIN Manufacturers m ON a.manufacturer_id = m.manufacturer_id
WHERE a.product_count > 5;

-- 5. CTE: Manufacturers with website
WITH WebManufacturers AS (
    SELECT manufacturer_id, manufacturer_name
    FROM Manufacturers
    WHERE website IS NOT NULL
)
SELECT m.manufacturer_name, COUNT(p.product_id) AS product_count
FROM WebManufacturers w
JOIN Manufacturers m ON w.manufacturer_id = m.manufacturer_id
LEFT JOIN Products p ON m.manufacturer_id = p.manufacturer_id
GROUP BY m.manufacturer_name;

-- 6. CTE: Ranked manufacturers by creation
WITH RankedManufacturers AS (
    SELECT manufacturer_id, manufacturer_name, created_date,
           RANK() OVER (ORDER BY created_date DESC) AS create_rank
    FROM Manufacturers
)
SELECT manufacturer_name, created_date, create_rank
FROM RankedManufacturers
WHERE create_rank <= 5;

-- 7. Stored Procedure: Update manufacturer website
DELIMITER //
CREATE PROCEDURE UpdateManufacturerWebsite(IN man_id INT, IN new_web VARCHAR(100))
BEGIN
    UPDATE Manufacturers SET website = new_web WHERE manufacturer_id = man_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete unlicensed manufacturers
DELIMITER //
CREATE PROCEDURE DeleteUnlicensedManufacturers()
BEGIN
    DELETE FROM Manufacturers WHERE license_number IS NULL;
END //
DELIMITER ;

-- 9. Stored Procedure: Get manufacturers by country
DELIMITER //
CREATE PROCEDURE GetManufacturersByCountry(IN cnt VARCHAR(50))
BEGIN
    SELECT manufacturer_id, manufacturer_name, website
    FROM Manufacturers
    WHERE country = cnt;
END //
DELIMITER ;

-- 10. TCL: Update manufacturer details with rollback
START TRANSACTION;
UPDATE Manufacturers SET email = 'new.email@email.com' WHERE manufacturer_id = 1;
UPDATE Manufacturers SET phone = '555-9999' WHERE manufacturer_id = 2;
-- Simulate error
INSERT INTO Manufacturers (manufacturer_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit address update
START TRANSACTION;
UPDATE Manufacturers SET address = '123 New St' WHERE manufacturer_id = 3;
SAVEPOINT address_updated;
UPDATE Manufacturers SET country = 'New Country' WHERE manufacturer_id = 3;
COMMIT;

-- 12. TCL: Rollback email update
START TRANSACTION;
UPDATE Manufacturers SET email = 'test@email.com' WHERE manufacturer_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Manufacturers TO 'user3'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Manufacturers TO 'manuf_manager';

-- 15. Trigger: Log manufacturer changes
DELIMITER //
CREATE TRIGGER LogManufacturerChange
AFTER UPDATE ON Manufacturers
FOR EACH ROW
BEGIN
    IF OLD.website != NEW.website THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Website Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Manufacturer ID: ', NEW.manufacturer_id, ' Website changed to ', NEW.website),
                'Manufacturers', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid license
DELIMITER //
CREATE TRIGGER PreventInvalidLicense
BEFORE UPDATE ON Manufacturers
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.license_number) < 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'License number must be at least 5 characters';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new manufacturer
DELIMITER //
CREATE TRIGGER LogNewManufacturer
AFTER INSERT ON Manufacturers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Manufacturer', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Manufacturer ID: ', NEW.manufacturer_id, ' added'),
            'Manufacturers', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank manufacturers by creation
SELECT manufacturer_id, manufacturer_name, created_date,
       RANK() OVER (ORDER BY created_date DESC) AS create_rank
FROM Manufacturers;

-- 19. Window Function: Running total manufacturers by country
SELECT manufacturer_id, manufacturer_name, country,
       COUNT(*) OVER (PARTITION BY country ORDER BY manufacturer_id) AS country_count
FROM Manufacturers;

-- 20. Window Function: Manufacturer percentage by country
SELECT manufacturer_id, country,
       COUNT(*) OVER (PARTITION BY country) / COUNT(*) OVER () * 100 AS country_percentage
FROM Manufacturers;


-- Table 4: Products
-- 1. View: High priced products
CREATE VIEW HighPricedProducts AS
SELECT product_id, product_name, unit_price, category_id
FROM Products
WHERE unit_price > 100;

-- 2. View: Products with manufacturers
CREATE VIEW ProductsWithManufacturers AS
SELECT p.product_id, p.product_name, p.unit_price, m.manufacturer_name
FROM Products p
JOIN Manufacturers m ON p.manufacturer_id = m.manufacturer_id;

-- 3. View: Top strength products
CREATE VIEW TopStrengthProducts AS
SELECT product_id, product_name, strength
FROM Products
ORDER BY strength DESC LIMIT 10;

-- 4. CTE: Average price by category
WITH CategoryAvgPrice AS (
    SELECT category_id, AVG(unit_price) AS avg_price
    FROM Products
    GROUP BY category_id
)
SELECT p.product_id, p.product_name, p.unit_price, c.avg_price
FROM Products p
JOIN CategoryAvgPrice c ON p.category_id = c.category_id
WHERE p.unit_price > c.avg_price;

-- 5. CTE: Products with inventory
WITH ProductsWithInventory AS (
    SELECT product_id, SUM(quantity_in_stock) AS total_stock
    FROM Inventory
    GROUP BY product_id
)
SELECT p.product_name, i.total_stock
FROM ProductsWithInventory i
JOIN Products p ON i.product_id = p.product_id
WHERE i.total_stock < 50;

-- 6. CTE: Ranked products by price
WITH RankedProducts AS (
    SELECT product_id, product_name, unit_price,
           RANK() OVER (ORDER BY unit_price DESC) AS price_rank
    FROM Products
)
SELECT product_name, unit_price, price_rank
FROM RankedProducts
WHERE price_rank <= 5;

-- 7. Stored Procedure: Update product price
DELIMITER //
CREATE PROCEDURE UpdateProductPrice(IN prod_id INT, IN new_price DECIMAL(10,2))
BEGIN
    UPDATE Products SET unit_price = new_price WHERE product_id = prod_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete low stock products (logical delete if no is_active)
DELIMITER //
CREATE PROCEDURE DeleteLowStockProducts()
BEGIN
    DELETE FROM Products WHERE product_id IN (SELECT product_id FROM Inventory WHERE quantity_in_stock = 0);
END //
DELIMITER ;

-- 9. Stored Procedure: Get products by category
DELIMITER //
CREATE PROCEDURE GetProductsByCategory(IN cat_id INT)
BEGIN
    SELECT product_id, product_name, unit_price
    FROM Products
    WHERE category_id = cat_id;
END //
DELIMITER ;

-- 10. TCL: Update product details with rollback
START TRANSACTION;
UPDATE Products SET unit_price = unit_price * 1.1 WHERE category_id = 1;
UPDATE Products SET strength = 'New Strength' WHERE category_id = 2;
-- Simulate error
INSERT INTO Products (product_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit price update
START TRANSACTION;
UPDATE Products SET unit_price = unit_price * 1.05 WHERE manufacturer_id = 1;
SAVEPOINT price_updated;
UPDATE Products SET dosage_form = 'New Form' WHERE manufacturer_id = 2;
COMMIT;

-- 12. TCL: Rollback price update
START TRANSACTION;
UPDATE Products SET unit_price = 50.00 WHERE product_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Products TO 'user4'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Products TO 'product_manager';

-- 15. Trigger: Log price changes
DELIMITER //
CREATE TRIGGER LogProductPriceChange
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.unit_price != NEW.unit_price THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Price Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Product ID: ', NEW.product_id, ' Price changed from ', OLD.unit_price, ' to ', NEW.unit_price),
                'Products', 'Price adjustment');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid price
DELIMITER //
CREATE TRIGGER PreventInvalidPrice
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.unit_price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Unit price cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new product
DELIMITER //
CREATE TRIGGER LogNewProduct
AFTER INSERT ON Products
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Product', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Product ID: ', NEW.product_id, ' added'),
            'Products', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank products by price
SELECT product_id, product_name, unit_price, category_id,
       RANK() OVER (PARTITION BY category_id ORDER BY unit_price DESC) AS price_rank
FROM Products;

-- 19. Window Function: Running total price by category
SELECT product_id, product_name, unit_price, category_id,
       SUM(unit_price) OVER (PARTITION BY category_id ORDER BY product_id) AS running_total
FROM Products;

-- 20. Window Function: Price percentage by category
SELECT product_id, product_name, unit_price, category_id,
       unit_price / SUM(unit_price) OVER (PARTITION BY category_id) * 100 AS price_percentage
FROM Products;


-- Table 5: Inventory
-- 1. View: Low stock inventory
CREATE VIEW LowStockInventory AS
SELECT inventory_id, product_id, batch_number, quantity_in_stock
FROM Inventory
WHERE quantity_in_stock < reorder_level;

-- 2. View: Inventory with products
CREATE VIEW InventoryWithProducts AS
SELECT i.inventory_id, p.product_name, i.quantity_in_stock, i.expiry_date
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id;

-- 3. View: Expiring inventory
CREATE VIEW ExpiringInventory AS
SELECT inventory_id, product_id, expiry_date
FROM Inventory
WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 3 MONTH);

-- 4. CTE: Average stock by product
WITH ProductAvgStock AS (
    SELECT product_id, AVG(quantity_in_stock) AS avg_stock
    FROM Inventory
    GROUP BY product_id
)
SELECT i.inventory_id, i.product_id, i.quantity_in_stock, a.avg_stock
FROM ProductAvgStock a
JOIN Inventory i ON a.product_id = i.product_id
WHERE i.quantity_in_stock < a.avg_stock;

-- 5. CTE: High cost inventory
WITH HighCostInventory AS (
    SELECT inventory_id, product_id, cost_price
    FROM Inventory
    WHERE cost_price > 100
)
SELECT i.batch_number, h.cost_price, p.product_name
FROM HighCostInventory h
JOIN Inventory i ON h.inventory_id = i.inventory_id
JOIN Products p ON i.product_id = p.product_id;

-- 6. CTE: Ranked inventory by expiry
WITH RankedInventory AS (
    SELECT inventory_id, product_id, expiry_date,
           RANK() OVER (ORDER BY expiry_date ASC) AS expiry_rank
    FROM Inventory
    WHERE expiry_date IS NOT NULL
)
SELECT product_id, expiry_date, expiry_rank
FROM RankedInventory
WHERE expiry_rank <= 5;

-- 7. Stored Procedure: Update inventory stock
DELIMITER //
CREATE PROCEDURE UpdateInventoryStock(IN inv_id INT, IN new_qty INT)
BEGIN
    UPDATE Inventory SET quantity_in_stock = new_qty WHERE inventory_id = inv_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Remove expired inventory
DELIMITER //
CREATE PROCEDURE RemoveExpiredInventory()
BEGIN
    DELETE FROM Inventory WHERE expiry_date < CURDATE();
END //
DELIMITER ;

-- 9. Stored Procedure: Get inventory by product
DELIMITER //
CREATE PROCEDURE GetInventoryByProduct(IN prod_id INT)
BEGIN
    SELECT inventory_id, batch_number, quantity_in_stock
    FROM Inventory
    WHERE product_id = prod_id;
END //
DELIMITER ;

-- 10. TCL: Update inventory with rollback
START TRANSACTION;
UPDATE Inventory SET quantity_in_stock = quantity_in_stock - 10 WHERE product_id = 1;
UPDATE Inventory SET cost_price = cost_price * 1.05 WHERE product_id = 2;
-- Simulate error
INSERT INTO Inventory (inventory_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit location update
START TRANSACTION;
UPDATE Inventory SET location = 'New Location' WHERE inventory_id = 3;
SAVEPOINT location_updated;
UPDATE Inventory SET last_updated = NOW() WHERE inventory_id = 3;
COMMIT;

-- 12. TCL: Rollback stock update
START TRANSACTION;
UPDATE Inventory SET quantity_in_stock = 100 WHERE inventory_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Inventory TO 'user5'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Inventory TO 'inventory_manager';

-- 15. Trigger: Log stock changes
DELIMITER //
CREATE TRIGGER LogInventoryChange
AFTER UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF OLD.quantity_in_stock != NEW.quantity_in_stock THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Stock Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Inventory ID: ', NEW.inventory_id, ' Stock changed from ', OLD.quantity_in_stock, ' to ', NEW.quantity_in_stock),
                'Inventory', 'Stock adjustment');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative stock
DELIMITER //
CREATE TRIGGER PreventNegativeStockInventory
BEFORE UPDATE ON Inventory
FOR EACH ROW
BEGIN
    IF NEW.quantity_in_stock < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity in stock cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Update last updated on change
DELIMITER //
CREATE TRIGGER UpdateLastUpdated
BEFORE UPDATE ON Inventory
FOR EACH ROW
BEGIN
    SET NEW.last_updated = NOW();
END //
DELIMITER ;

-- 18. Window Function: Rank inventory by stock
SELECT inventory_id, product_id, quantity_in_stock,
       RANK() OVER (PARTITION BY product_id ORDER BY quantity_in_stock DESC) AS stock_rank
FROM Inventory;

-- 19. Window Function: Running total stock by product
SELECT inventory_id, product_id, quantity_in_stock,
       SUM(quantity_in_stock) OVER (PARTITION BY product_id ORDER BY inventory_id) AS running_stock
FROM Inventory;

-- 20. Window Function: Stock percentage by product
SELECT inventory_id, product_id, quantity_in_stock,
       quantity_in_stock / SUM(quantity_in_stock) OVER (PARTITION BY product_id) * 100 AS stock_percentage
FROM Inventory;


-- Table 6: Customers
-- 1. View: Recently registered customers
CREATE VIEW RecentCustomersPharmacy AS
SELECT customer_id, customer_name, date_of_birth, registration_date AS created_date
FROM Customers
WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 2. View: Customers with prescriptions
CREATE VIEW CustomersWithPrescriptions AS
SELECT c.customer_id, c.customer_name, COUNT(pr.prescription_id) AS prescription_count
FROM Customers c
LEFT JOIN Prescriptions pr ON c.customer_id = pr.customer_id
GROUP BY c.customer_id;

-- 3. View: Customer contact details
CREATE VIEW CustomerContactsPharmacy AS
SELECT customer_id, customer_name, email, phone
FROM Customers
WHERE email IS NOT NULL;

-- 4. CTE: High-value customers
WITH HighValueCustomersPharmacy AS (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM Prescriptions
    GROUP BY customer_id
)
SELECT c.customer_name, h.total_spent
FROM HighValueCustomersPharmacy h
JOIN Customers c ON h.customer_id = c.customer_id
WHERE h.total_spent > 1000;

-- 5. CTE: Customer prescription frequency
WITH PrescriptionFrequency AS (
    SELECT customer_id, COUNT(*) AS prescription_count
    FROM Prescriptions
    GROUP BY customer_id
)
SELECT c.customer_name, p.prescription_count
FROM PrescriptionFrequency p
JOIN Customers c ON p.customer_id = c.customer_id
WHERE p.prescription_count > 2;

-- 6. CTE: Latest registrations
WITH LatestRegistrationsPharmacy AS (
    SELECT customer_id, customer_name, created_date,
           RANK() OVER (ORDER BY created_date DESC) AS reg_rank
    FROM Customers
)
SELECT customer_name, created_date, reg_rank
FROM LatestRegistrationsPharmacy
WHERE reg_rank <= 5;

-- 7. Stored Procedure: Update customer email
DELIMITER //
CREATE PROCEDURE UpdateCustomerEmailPharmacy(IN cust_id INT, IN new_email VARCHAR(100))
BEGIN
    UPDATE Customers SET email = new_email WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old customers
DELIMITER //
CREATE PROCEDURE DeleteOldCustomersPharmacy()
BEGIN
    DELETE FROM Customers WHERE created_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get customers by gender
DELIMITER //
CREATE PROCEDURE GetCustomersByGender(IN gen VARCHAR(10))
BEGIN
    SELECT customer_id, customer_name, email
    FROM Customers
    WHERE gender = gen;
END //
DELIMITER ;

-- 10. TCL: Update customer details with rollback
START TRANSACTION;
UPDATE Customers SET email = 'new.email@email.com' WHERE customer_id = 1;
UPDATE Customers SET phone = '555-9999' WHERE customer_id = 2;
-- Simulate error
INSERT INTO Customers (customer_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit address update
START TRANSACTION;
UPDATE Customers SET address = '123 New St' WHERE customer_id = 3;
SAVEPOINT address_updated;
UPDATE Customers SET insurance_provider = 'New Provider' WHERE customer_id = 3;
COMMIT;

-- 12. TCL: Rollback email update
START TRANSACTION;
UPDATE Customers SET email = 'test@email.com' WHERE customer_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Customers TO 'user6'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Customers TO 'customer_manager';

-- 15. Trigger: Log customer updates
DELIMITER //
CREATE TRIGGER LogCustomerUpdatePharmacy
AFTER UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF OLD.email != NEW.email THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Email Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Customer ID: ', NEW.customer_id, ' Email changed to ', NEW.email),
                'Customers', 'Contact update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid gender
DELIMITER //
CREATE TRIGGER PreventInvalidGender
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF NEW.gender NOT IN ('Male', 'Female', 'Other') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid gender value';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new customer
DELIMITER //
CREATE TRIGGER LogNewCustomerPharmacy
AFTER INSERT ON Customers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Customer', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Customer ID: ', NEW.customer_id, ' added'),
            'Customers', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank customers by registration
SELECT customer_id, customer_name, created_date,
       RANK() OVER (ORDER BY created_date DESC) AS reg_rank
FROM Customers;

-- 19. Window Function: Running total customers by gender
SELECT customer_id, customer_name, gender,
       COUNT(*) OVER (PARTITION BY gender ORDER BY customer_id) AS gender_count
FROM Customers;

-- 20. Window Function: Customer percentage by insurance
SELECT customer_id, insurance_provider,
       COUNT(*) OVER (PARTITION BY insurance_provider) / COUNT(*) OVER () * 100 AS insurance_percentage
FROM Customers;


-- Table 7: Prescriptions
-- 1. View: Active prescriptions
CREATE VIEW ActivePrescriptions AS
SELECT prescription_id, customer_id, doctor_name, total_amount
FROM Prescriptions
WHERE status = 'Active';

-- 2. View: Prescriptions with customers
CREATE VIEW PrescriptionsWithCustomers AS
SELECT pr.prescription_id, c.customer_name, pr.total_amount, pr.insurance_covered
FROM Prescriptions pr
JOIN Customers c ON pr.customer_id = c.customer_id;

-- 3. View: High copay prescriptions
CREATE VIEW HighCopayPrescriptions AS
SELECT prescription_id, patient_copay
FROM Prescriptions
WHERE patient_copay > 50;

-- 4. CTE: Average amount by customer
WITH CustomerAvgAmount AS (
    SELECT customer_id, AVG(total_amount) AS avg_amount
    FROM Prescriptions
    GROUP BY customer_id
)
SELECT pr.prescription_id, pr.customer_id, pr.total_amount, a.avg_amount
FROM CustomerAvgAmount a
JOIN Prescriptions pr ON a.customer_id = pr.customer_id
WHERE pr.total_amount > a.avg_amount;

-- 5. CTE: Prescriptions with items
WITH PrescriptionsWithItems AS (
    SELECT prescription_id, COUNT(*) AS item_count
    FROM Prescription_Items
    GROUP BY prescription_id
)
SELECT pr.doctor_name, i.item_count
FROM PrescriptionsWithItems i
JOIN Prescriptions pr ON i.prescription_id = pr.prescription_id
WHERE i.item_count > 2;

-- 6. CTE: Ranked prescriptions by date
WITH RankedPrescriptions AS (
    SELECT prescription_id, customer_id, prescription_date,
           RANK() OVER (ORDER BY prescription_date DESC) AS date_rank
    FROM Prescriptions
)
SELECT customer_id, prescription_date, date_rank
FROM RankedPrescriptions
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update prescription status
DELIMITER //
CREATE PROCEDURE UpdatePrescriptionStatus(IN pres_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE Prescriptions SET status = new_status WHERE prescription_id = pres_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old prescriptions
DELIMITER //
CREATE PROCEDURE DeleteOldPrescriptions()
BEGIN
    DELETE FROM Prescriptions WHERE prescription_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get prescriptions by customer
DELIMITER //
CREATE PROCEDURE GetPrescriptionsByCustomer(IN cust_id INT)
BEGIN
    SELECT prescription_id, doctor_name, total_amount
    FROM Prescriptions
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 10. TCL: Update prescription with rollback
START TRANSACTION;
UPDATE Prescriptions SET total_amount = total_amount * 1.1 WHERE customer_id = 1;
UPDATE Prescriptions SET status = 'Filled' WHERE customer_id = 2;
-- Simulate error
INSERT INTO Prescriptions (prescription_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit copay update
START TRANSACTION;
UPDATE Prescriptions SET patient_copay = patient_copay + 10 WHERE prescription_id = 3;
SAVEPOINT copay_updated;
UPDATE Prescriptions SET notes = 'Updated notes' WHERE prescription_id = 3;
COMMIT;

-- 12. TCL: Rollback status update
START TRANSACTION;
UPDATE Prescriptions SET status = 'Cancelled' WHERE prescription_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Prescriptions TO 'user7'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Prescriptions TO 'prescription_manager';

-- 15. Trigger: Log prescription changes
DELIMITER //
CREATE TRIGGER LogPrescriptionChange
AFTER UPDATE ON Prescriptions
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Status Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Prescription ID: ', NEW.prescription_id, ' Status changed to ', NEW.status),
                'Prescriptions', 'Status change');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid amount
DELIMITER //
CREATE TRIGGER PreventInvalidAmount
BEFORE UPDATE ON Prescriptions
FOR EACH ROW
BEGIN
    IF NEW.total_amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new prescription
DELIMITER //
CREATE TRIGGER LogNewPrescription
AFTER INSERT ON Prescriptions
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.customer_id, 'New Prescription', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Prescription ID: ', NEW.prescription_id, ' added'),
            'Prescriptions', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank prescriptions by amount
SELECT prescription_id, customer_id, total_amount,
       RANK() OVER (PARTITION BY customer_id ORDER BY total_amount DESC) AS amount_rank
FROM Prescriptions;

-- 19. Window Function: Running total amount by customer
SELECT prescription_id, customer_id, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY prescription_id) AS running_total
FROM Prescriptions;

-- 20. Window Function: Amount percentage by customer
SELECT prescription_id, customer_id, total_amount,
       total_amount / SUM(total_amount) OVER (PARTITION BY customer_id) * 100 AS amount_percentage
FROM Prescriptions;


-- Table 8: Prescription_Items
-- 1. View: Items with refills
CREATE VIEW ItemsWithRefills AS
SELECT prescription_item_id, prescription_id, product_id, refills_remaining
FROM Prescription_Items
WHERE refills_remaining > 0;

-- 2. View: Prescription_Items with products
CREATE VIEW PrescriptionItemsWithProducts AS
SELECT pi.prescription_item_id, p.product_name, pi.quantity, pi.total_price
FROM Prescription_Items pi
JOIN Products p ON pi.product_id = p.product_id;

-- 3. View: High price items
CREATE VIEW HighPriceItems AS
SELECT prescription_item_id, total_price
FROM Prescription_Items
WHERE total_price > 100;

-- 4. CTE: Average quantity by prescription
WITH PrescriptionAvgQuantity AS (
    SELECT prescription_id, AVG(quantity) AS avg_quantity
    FROM Prescription_Items
    GROUP BY prescription_id
)
SELECT pi.prescription_item_id, pi.prescription_id, pi.quantity, a.avg_quantity
FROM PrescriptionAvgQuantity a
JOIN Prescription_Items pi ON a.prescription_id = pi.prescription_id
WHERE pi.quantity > a.avg_quantity;

-- 5. CTE: Items with high refills
WITH HighRefillItems AS (
    SELECT prescription_item_id, refills_remaining
    FROM Prescription_Items
    WHERE refills_remaining > 3
)
SELECT pi.dosage_instructions, h.refills_remaining
FROM HighRefillItems h
JOIN Prescription_Items pi ON h.prescription_item_id = pi.prescription_item_id;

-- 6. CTE: Ranked items by price
WITH RankedItems AS (
    SELECT prescription_item_id, prescription_id, total_price,
           RANK() OVER (ORDER BY total_price DESC) AS price_rank
    FROM Prescription_Items
)
SELECT prescription_id, total_price, price_rank
FROM RankedItems
WHERE price_rank <= 5;

-- 7. Stored Procedure: Update item quantity
DELIMITER //
CREATE PROCEDURE UpdateItemQuantity(IN item_id INT, IN new_qty INT)
BEGIN
    UPDATE Prescription_Items SET quantity = new_qty WHERE prescription_item_id = item_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete items without refills
DELIMITER //
CREATE PROCEDURE DeleteNoRefillItems()
BEGIN
    DELETE FROM Prescription_Items WHERE refills_remaining = 0;
END //
DELIMITER ;

-- 9. Stored Procedure: Get items by prescription
DELIMITER //
CREATE PROCEDURE GetItemsByPrescription(IN pres_id INT)
BEGIN
    SELECT prescription_item_id, product_id, quantity
    FROM Prescription_Items
    WHERE prescription_id = pres_id;
END //
DELIMITER ;

-- 10. TCL: Update item with rollback
START TRANSACTION;
UPDATE Prescription_Items SET quantity = quantity + 5 WHERE prescription_item_id = 1;
UPDATE Prescription_Items SET total_price = total_price * 1.05 WHERE prescription_item_id = 2;
-- Simulate error
INSERT INTO Prescription_Items (prescription_item_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit dosage update
START TRANSACTION;
UPDATE Prescription_Items SET dosage_instructions = 'New instructions' WHERE prescription_item_id = 3;
SAVEPOINT dosage_updated;
UPDATE Prescription_Items SET days_supply = 30 WHERE prescription_item_id = 3;
COMMIT;

-- 12. TCL: Rollback quantity update
START TRANSACTION;
UPDATE Prescription_Items SET quantity = 10 WHERE prescription_item_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Prescription_Items TO 'user8'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Prescription_Items TO 'item_manager';

-- 15. Trigger: Log item changes
DELIMITER //
CREATE TRIGGER LogItemChange
AFTER UPDATE ON Prescription_Items
FOR EACH ROW
BEGIN
    IF OLD.quantity != NEW.quantity THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Quantity Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Item ID: ', NEW.prescription_item_id, ' Quantity changed to ', NEW.quantity),
                'Prescription_Items', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative quantity
DELIMITER //
CREATE TRIGGER PreventNegativeQuantity
BEFORE UPDATE ON Prescription_Items
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new item
DELIMITER //
CREATE TRIGGER LogNewItem
AFTER INSERT ON Prescription_Items
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Item', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Item ID: ', NEW.prescription_item_id, ' added'),
            'Prescription_Items', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank items by price
SELECT prescription_item_id, prescription_id, total_price,
       RANK() OVER (PARTITION BY prescription_id ORDER BY total_price DESC) AS price_rank
FROM Prescription_Items;

-- 19. Window Function: Running total price by prescription
SELECT prescription_item_id, prescription_id, total_price,
       SUM(total_price) OVER (PARTITION BY prescription_id ORDER BY prescription_item_id) AS running_total
FROM Prescription_Items;

-- 20. Window Function: Price percentage by prescription
SELECT prescription_item_id, prescription_id, total_price,
       total_price / SUM(total_price) OVER (PARTITION BY prescription_id) * 100 AS price_percentage
FROM Prescription_Items;


-- Table 9: Purchase_Orders
-- 1. View: Delivered purchase orders
CREATE VIEW DeliveredPurchaseOrders AS
SELECT purchase_order_id, supplier_id, total_amount
FROM Purchase_Orders
WHERE order_status = 'Delivered';

-- 2. View: Purchase_Orders with suppliers
CREATE VIEW PurchaseOrdersWithSuppliers AS
SELECT po.purchase_order_id, s.supplier_name, po.total_amount, po.tax_amount
FROM Purchase_Orders po
JOIN Suppliers s ON po.supplier_id = s.supplier_id;

-- 3. View: High amount orders
CREATE VIEW HighAmountOrders AS
SELECT purchase_order_id, total_amount
FROM Purchase_Orders
WHERE total_amount > 500;

-- 4. CTE: Average amount by supplier
WITH SupplierAvgAmount AS (
    SELECT supplier_id, AVG(total_amount) AS avg_amount
    FROM Purchase_Orders
    GROUP BY supplier_id
)
SELECT po.purchase_order_id, po.supplier_id, po.total_amount, a.avg_amount
FROM SupplierAvgAmount a
JOIN Purchase_Orders po ON a.supplier_id = po.supplier_id
WHERE po.total_amount > a.avg_amount;

-- 5. CTE: Orders with items
WITH OrdersWithItems AS (
    SELECT purchase_order_id, COUNT(*) AS item_count
    FROM Purchase_Order_Items
    GROUP BY purchase_order_id
)
SELECT po.order_status, i.item_count
FROM OrdersWithItems i
JOIN Purchase_Orders po ON i.purchase_order_id = po.purchase_order_id
WHERE i.item_count > 5;

-- 6. CTE: Ranked orders by date
WITH RankedOrders AS (
    SELECT purchase_order_id, supplier_id, order_date,
           RANK() OVER (ORDER BY order_date DESC) AS date_rank
    FROM Purchase_Orders
)
SELECT supplier_id, order_date, date_rank
FROM RankedOrders
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update order status
DELIMITER //
CREATE PROCEDURE UpdateOrderStatus(IN order_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE Purchase_Orders SET order_status = new_status WHERE purchase_order_id = order_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old orders
DELIMITER //
CREATE PROCEDURE DeleteOldOrders()
BEGIN
    DELETE FROM Purchase_Orders WHERE order_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get orders by supplier
DELIMITER //
CREATE PROCEDURE GetOrdersBySupplier(IN sup_id INT)
BEGIN
    SELECT purchase_order_id, order_date, total_amount
    FROM Purchase_Orders
    WHERE supplier_id = sup_id;
END //
DELIMITER ;

-- 10. TCL: Update order with rollback
START TRANSACTION;
UPDATE Purchase_Orders SET total_amount = total_amount * 1.1 WHERE supplier_id = 1;
UPDATE Purchase_Orders SET shipping_cost = shipping_cost + 10 WHERE supplier_id = 2;
-- Simulate error
INSERT INTO Purchase_Orders (purchase_order_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit status update
START TRANSACTION;
UPDATE Purchase_Orders SET order_status = 'Delivered' WHERE purchase_order_id = 3;
SAVEPOINT status_updated;
UPDATE Purchase_Orders SET actual_delivery_date = NOW() WHERE purchase_order_id = 3;
COMMIT;

-- 12. TCL: Rollback amount update
START TRANSACTION;
UPDATE Purchase_Orders SET total_amount = 1000.00 WHERE purchase_order_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Purchase_Orders TO 'user9'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Purchase_Orders TO 'order_manager';

-- 15. Trigger: Log order changes
DELIMITER //
CREATE TRIGGER LogOrderChange
AFTER UPDATE ON Purchase_Orders
FOR EACH ROW
BEGIN
    IF OLD.order_status != NEW.order_status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Status Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Order ID: ', NEW.purchase_order_id, ' Status changed to ', NEW.order_status),
                'Purchase_Orders', 'Status change');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid amount
DELIMITER //
CREATE TRIGGER PreventInvalidOrderAmount
BEFORE UPDATE ON Purchase_Orders
FOR EACH ROW
BEGIN
    IF NEW.total_amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new order
DELIMITER //
CREATE TRIGGER LogNewOrder
AFTER INSERT ON Purchase_Orders
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Order', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Order ID: ', NEW.purchase_order_id, ' added'),
            'Purchase_Orders', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank orders by amount
SELECT purchase_order_id, supplier_id, total_amount,
       RANK() OVER (PARTITION BY supplier_id ORDER BY total_amount DESC) AS amount_rank
FROM Purchase_Orders;

-- 19. Window Function: Running total amount by supplier
SELECT purchase_order_id, supplier_id, total_amount,
       SUM(total_amount) OVER (PARTITION BY supplier_id ORDER BY purchase_order_id) AS running_total
FROM Purchase_Orders;

-- 20. Window Function: Amount percentage by supplier
SELECT purchase_order_id, supplier_id, total_amount,
       total_amount / SUM(total_amount) OVER (PARTITION BY supplier_id) * 100 AS amount_percentage
FROM Purchase_Orders;


-- Table 10: Purchase_Order_Items
-- 1. View: Received items
CREATE VIEW ReceivedItems AS
SELECT purchase_order_item_id, purchase_order_id, product_id, quantity_received
FROM Purchase_Order_Items
WHERE quantity_received = quantity_ordered;

-- 2. View: Purchase_Order_Items with products
CREATE VIEW PurchaseOrderItemsWithProducts AS
SELECT poi.purchase_order_item_id, p.product_name, poi.quantity_ordered, poi.total_cost
FROM Purchase_Order_Items poi
JOIN Products p ON poi.product_id = p.product_id;

-- 3. View: Expiring order items
CREATE VIEW ExpiringOrderItems AS
SELECT purchase_order_item_id, expiry_date
FROM Purchase_Order_Items
WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- 4. CTE: Average cost by order
WITH OrderAvgCost AS (
    SELECT purchase_order_id, AVG(unit_cost) AS avg_cost
    FROM Purchase_Order_Items
    GROUP BY purchase_order_id
)
SELECT poi.purchase_order_item_id, poi.purchase_order_id, poi.unit_cost, a.avg_cost
FROM OrderAvgCost a
JOIN Purchase_Order_Items poi ON a.purchase_order_id = poi.purchase_order_id
WHERE poi.unit_cost > a.avg_cost;

-- 5. CTE: Items with high quantity
WITH HighQuantityItems AS (
    SELECT purchase_order_item_id, quantity_ordered
    FROM Purchase_Order_Items
    WHERE quantity_ordered > 100
)
SELECT poi.batch_number, h.quantity_ordered
FROM HighQuantityItems h
JOIN Purchase_Order_Items poi ON h.purchase_order_item_id = poi.purchase_order_item_id;

-- 6. CTE: Ranked items by cost
WITH RankedOrderItems AS (
    SELECT purchase_order_item_id, purchase_order_id, total_cost,
           RANK() OVER (ORDER BY total_cost DESC) AS cost_rank
    FROM Purchase_Order_Items
)
SELECT purchase_order_id, total_cost, cost_rank
FROM RankedOrderItems
WHERE cost_rank <= 5;

-- 7. Stored Procedure: Update item quantity
DELIMITER //
CREATE PROCEDURE UpdateOrderItemQuantity(IN item_id INT, IN new_qty INT)
BEGIN
    UPDATE Purchase_Order_Items SET quantity_ordered = new_qty WHERE purchase_order_item_id = item_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete unreceived items
DELIMITER //
CREATE PROCEDURE DeleteUnreceivedItems()
BEGIN
    DELETE FROM Purchase_Order_Items WHERE quantity_received = 0;
END //
DELIMITER ;

-- 9. Stored Procedure: Get items by order
DELIMITER //
CREATE PROCEDURE GetItemsByOrder(IN order_id INT)
BEGIN
    SELECT purchase_order_item_id, product_id, quantity_ordered
    FROM Purchase_Order_Items
    WHERE purchase_order_id = order_id;
END //
DELIMITER ;

-- 10. TCL: Update item with rollback
START TRANSACTION;
UPDATE Purchase_Order_Items SET quantity_received = quantity_received + 10 WHERE purchase_order_item_id = 1;
UPDATE Purchase_Order_Items SET total_cost = total_cost * 1.05 WHERE purchase_order_item_id = 2;
-- Simulate error
INSERT INTO Purchase_Order_Items (purchase_order_item_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit batch update
START TRANSACTION;
UPDATE Purchase_Order_Items SET batch_number = 'New Batch' WHERE purchase_order_item_id = 3;
SAVEPOINT batch_updated;
UPDATE Purchase_Order_Items SET expiry_date = DATE_ADD(CURDATE(), INTERVAL 1 YEAR) WHERE purchase_order_item_id = 3;
COMMIT;

-- 12. TCL: Rollback quantity update
START TRANSACTION;
UPDATE Purchase_Order_Items SET quantity_ordered = 50 WHERE purchase_order_item_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Purchase_Order_Items TO 'user10'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Purchase_Order_Items TO 'order_item_manager';

-- 15. Trigger: Log item changes
DELIMITER //
CREATE TRIGGER LogOrderItemChange
AFTER UPDATE ON Purchase_Order_Items
FOR EACH ROW
BEGIN
    IF OLD.quantity_received != NEW.quantity_received THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Received Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Item ID: ', NEW.purchase_order_item_id, ' Received changed to ', NEW.quantity_received),
                'Purchase_Order_Items', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative quantity
DELIMITER //
CREATE TRIGGER PreventNegativeOrderQuantity
BEFORE UPDATE ON Purchase_Order_Items
FOR EACH ROW
BEGIN
    IF NEW.quantity_ordered < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity ordered cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new order item
DELIMITER //
CREATE TRIGGER LogNewOrderItem
AFTER INSERT ON Purchase_Order_Items
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Order Item', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Item ID: ', NEW.purchase_order_item_id, ' added'),
            'Purchase_Order_Items', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank items by cost
SELECT purchase_order_item_id, purchase_order_id, total_cost,
       RANK() OVER (PARTITION BY purchase_order_id ORDER BY total_cost DESC) AS cost_rank
FROM Purchase_Order_Items;

-- 19. Window Function: Running total cost by order
SELECT purchase_order_item_id, purchase_order_id, total_cost,
       SUM(total_cost) OVER (PARTITION BY purchase_order_id ORDER BY purchase_order_item_id) AS running_total
FROM Purchase_Order_Items;

-- 20. Window Function: Cost percentage by order
SELECT purchase_order_item_id, purchase_order_id, total_cost,
       total_cost / SUM(total_cost) OVER (PARTITION BY purchase_order_id) * 100 AS cost_percentage
FROM Purchase_Order_Items;


-- Table 11: Sales
-- 1. View: Paid sales
CREATE VIEW PaidSales AS
SELECT sale_id, customer_id, total_amount
FROM Sales
WHERE payment_status = 'Paid';

-- 2. View: Sales with customers
CREATE VIEW SalesWithCustomers AS
SELECT s.sale_id, c.customer_name, s.total_amount, s.discount_amount
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id;

-- 3. View: High discount sales
CREATE VIEW HighDiscountSales AS
SELECT sale_id, discount_amount
FROM Sales
WHERE discount_amount > 20;

-- 4. CTE: Average amount by customer
WITH CustomerAvgSale AS (
    SELECT customer_id, AVG(total_amount) AS avg_amount
    FROM Sales
    GROUP BY customer_id
)
SELECT s.sale_id, s.customer_id, s.total_amount, a.avg_amount
FROM CustomerAvgSale a
JOIN Sales s ON a.customer_id = s.customer_id
WHERE s.total_amount > a.avg_amount;

-- 5. CTE: Sales with items
WITH SalesWithItems AS (
    SELECT sale_id, COUNT(*) AS item_count
    FROM Sale_Items
    GROUP BY sale_id
)
SELECT s.payment_method, i.item_count
FROM SalesWithItems i
JOIN Sales s ON i.sale_id = s.sale_id
WHERE i.item_count > 3;

-- 6. CTE: Ranked sales by date
WITH RankedSales AS (
    SELECT sale_id, customer_id, sale_date,
           RANK() OVER (ORDER BY sale_date DESC) AS date_rank
    FROM Sales
)
SELECT customer_id, sale_date, date_rank
FROM RankedSales
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update sale status
DELIMITER //
CREATE PROCEDURE UpdateSaleStatus(IN sale_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE Sales SET payment_status = new_status WHERE sale_id = sale_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old sales
DELIMITER //
CREATE PROCEDURE DeleteOldSales()
BEGIN
    DELETE FROM Sales WHERE sale_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get sales by customer
DELIMITER //
CREATE PROCEDURE GetSalesByCustomer(IN cust_id INT)
BEGIN
    SELECT sale_id, sale_date, total_amount
    FROM Sales
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 10. TCL: Update sale with rollback
START TRANSACTION;
UPDATE Sales SET total_amount = total_amount * 1.1 WHERE customer_id = 1;
UPDATE Sales SET discount_amount = discount_amount + 5 WHERE customer_id = 2;
-- Simulate error
INSERT INTO Sales (sale_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit status update
START TRANSACTION;
UPDATE Sales SET payment_status = 'Paid' WHERE sale_id = 3;
SAVEPOINT status_updated;
UPDATE Sales SET receipt_number = 'New Receipt' WHERE sale_id = 3;
COMMIT;

-- 12. TCL: Rollback amount update
START TRANSACTION;
UPDATE Sales SET total_amount = 200.00 WHERE sale_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Sales TO 'user11'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Sales TO 'sales_manager';

-- 15. Trigger: Log sale changes
DELIMITER //
CREATE TRIGGER LogSaleChange
AFTER UPDATE ON Sales
FOR EACH ROW
BEGIN
    IF OLD.payment_status != NEW.payment_status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.cashier_id, 'Status Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Sale ID: ', NEW.sale_id, ' Status changed to ', NEW.payment_status),
                'Sales', 'Status change');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative amount
DELIMITER //
CREATE TRIGGER PreventNegativeSaleAmount
BEFORE UPDATE ON Sales
FOR EACH ROW
BEGIN
    IF NEW.total_amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new sale
DELIMITER //
CREATE TRIGGER LogNewSale
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.cashier_id, 'New Sale', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Sale ID: ', NEW.sale_id, ' added'),
            'Sales', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank sales by amount
SELECT sale_id, customer_id, total_amount,
       RANK() OVER (PARTITION BY customer_id ORDER BY total_amount DESC) AS amount_rank
FROM Sales;

-- 19. Window Function: Running total amount by customer
SELECT sale_id, customer_id, total_amount,
       SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY sale_id) AS running_total
FROM Sales;

-- 20. Window Function: Amount percentage by customer
SELECT sale_id, customer_id, total_amount,
       total_amount / SUM(total_amount) OVER (PARTITION BY customer_id) * 100 AS amount_percentage
FROM Sales;


-- Table 12: Sale_Items
-- 1. View: Discounted sale items
CREATE VIEW DiscountedSaleItems AS
SELECT sale_item_id, sale_id, product_id, discount_amount
FROM Sale_Items
WHERE discount_amount > 0;

-- 2. View: Sale_Items with products
CREATE VIEW SaleItemsWithProducts AS
SELECT si.sale_item_id, p.product_name, si.quantity, si.total_price
FROM Sale_Items si
JOIN Products p ON si.product_id = p.product_id;

-- 3. View: Expiring sale items
CREATE VIEW ExpiringSaleItems AS
SELECT sale_item_id, expiry_date
FROM Sale_Items
WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 3 MONTH);

-- 4. CTE: Average price by sale
WITH SaleAvgPrice AS (
    SELECT sale_id, AVG(unit_price) AS avg_price
    FROM Sale_Items
    GROUP BY sale_id
)
SELECT si.sale_item_id, si.sale_id, si.unit_price, a.avg_price
FROM SaleAvgPrice a
JOIN Sale_Items si ON a.sale_id = si.sale_id
WHERE si.unit_price > a.avg_price;

-- 5. CTE: Items with high quantity
WITH HighQuantitySaleItems AS (
    SELECT sale_item_id, quantity
    FROM Sale_Items
    WHERE quantity > 10
)
SELECT si.batch_number, h.quantity
FROM HighQuantitySaleItems h
JOIN Sale_Items si ON h.sale_item_id = si.sale_item_id;

-- 6. CTE: Ranked items by price
WITH RankedSaleItems AS (
    SELECT sale_item_id, sale_id, total_price,
           RANK() OVER (ORDER BY total_price DESC) AS price_rank
    FROM Sale_Items
)
SELECT sale_id, total_price, price_rank
FROM RankedSaleItems
WHERE price_rank <= 5;

-- 7. Stored Procedure: Update item discount
DELIMITER //
CREATE PROCEDURE UpdateItemDiscount(IN item_id INT, IN new_disc DECIMAL(10,2))
BEGIN
    UPDATE Sale_Items SET discount_amount = new_disc WHERE sale_item_id = item_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete zero quantity items
DELIMITER //
CREATE PROCEDURE DeleteZeroQuantityItems()
BEGIN
    DELETE FROM Sale_Items WHERE quantity = 0;
END //
DELIMITER ;

-- 9. Stored Procedure: Get items by sale
DELIMITER //
CREATE PROCEDURE GetItemsBySale(IN sale_id INT)
BEGIN
    SELECT sale_item_id, product_id, quantity
    FROM Sale_Items
    WHERE sale_id = sale_id;
END //
DELIMITER ;

-- 10. TCL: Update item with rollback
START TRANSACTION;
UPDATE Sale_Items SET quantity = quantity + 5 WHERE sale_item_id = 1;
UPDATE Sale_Items SET total_price = total_price * 1.05 WHERE sale_item_id = 2;
-- Simulate error
INSERT INTO Sale_Items (sale_item_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit batch update
START TRANSACTION;
UPDATE Sale_Items SET batch_number = 'New Batch' WHERE sale_item_id = 3;
SAVEPOINT batch_updated;
UPDATE Sale_Items SET expiry_date = DATE_ADD(CURDATE(), INTERVAL 1 YEAR) WHERE sale_item_id = 3;
COMMIT;

-- 12. TCL: Rollback quantity update
START TRANSACTION;
UPDATE Sale_Items SET quantity = 10 WHERE sale_item_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Sale_Items TO 'user12'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Sale_Items TO 'sale_item_manager';

-- 15. Trigger: Log item changes
DELIMITER //
CREATE TRIGGER LogSaleItemChange
AFTER UPDATE ON Sale_Items
FOR EACH ROW
BEGIN
    IF OLD.quantity != NEW.quantity THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Quantity Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Sale Item ID: ', NEW.sale_item_id, ' Quantity changed to ', NEW.quantity),
                'Sale_Items', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative discount
DELIMITER //
CREATE TRIGGER PreventNegativeDiscount
BEFORE UPDATE ON Sale_Items
FOR EACH ROW
BEGIN
    IF NEW.discount_amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Discount amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new sale item
DELIMITER //
CREATE TRIGGER LogNewSaleItem
AFTER INSERT ON Sale_Items
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Sale Item', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Sale Item ID: ', NEW.sale_item_id, ' added'),
            'Sale_Items', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank items by price
SELECT sale_item_id, sale_id, total_price,
       RANK() OVER (PARTITION BY sale_id ORDER BY total_price DESC) AS price_rank
FROM Sale_Items;

-- 19. Window Function: Running total price by sale
SELECT sale_item_id, sale_id, total_price,
       SUM(total_price) OVER (PARTITION BY sale_id ORDER BY sale_item_id) AS running_total
FROM Sale_Items;

-- 20. Window Function: Price percentage by sale
SELECT sale_item_id, sale_id, total_price,
       total_price / SUM(total_price) OVER (PARTITION BY sale_id) * 100 AS price_percentage
FROM Sale_Items;


-- Table 13: Employees
-- 1. View: Active employees
CREATE VIEW ActiveEmployees AS
SELECT employee_id, employee_name, position, hire_date
FROM Employees
WHERE hire_date IS NOT NULL;  -- Assuming no is_active, use hire_date as proxy

-- 2. View: Employees with shifts
CREATE VIEW EmployeesWithShifts AS
SELECT e.employee_id, e.employee_name, COUNT(es.employee_shift_id) AS shift_count
FROM Employees e
LEFT JOIN Employee_Shifts es ON e.employee_id = es.employee_id
GROUP BY e.employee_id;

-- 3. View: High salary employees
CREATE VIEW HighSalaryEmployees AS
SELECT employee_id, employee_name, salary
FROM Employees
WHERE salary > 50000;

-- 4. CTE: Average salary by department
WITH DepartmentAvgSalary AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department
)
SELECT e.employee_id, e.department, e.salary, a.avg_salary
FROM DepartmentAvgSalary a
JOIN Employees e ON a.department = e.department
WHERE e.salary > a.avg_salary;

-- 5. CTE: Employees with overtime
WITH OvertimeEmployees AS (
    SELECT employee_id, SUM(overtime_minutes) AS total_ot
    FROM Employee_Shifts
    GROUP BY employee_id
)
SELECT e.employee_name, o.total_ot
FROM OvertimeEmployees o
JOIN Employees e ON o.employee_id = e.employee_id
WHERE o.total_ot > 60;

-- 6. CTE: Ranked employees by hire date
WITH RankedEmployees AS (
    SELECT employee_id, employee_name, hire_date,
           RANK() OVER (ORDER BY hire_date ASC) AS hire_rank
    FROM Employees
)
SELECT employee_name, hire_date, hire_rank
FROM RankedEmployees
WHERE hire_rank <= 5;

-- 7. Stored Procedure: Update employee salary
DELIMITER //
CREATE PROCEDURE UpdateEmployeeSalary(IN emp_id INT, IN new_salary DECIMAL(10,2))
BEGIN
    UPDATE Employees SET salary = new_salary WHERE employee_id = emp_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old employees
DELIMITER //
CREATE PROCEDURE DeleteOldEmployees()
BEGIN
    DELETE FROM Employees WHERE hire_date < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get employees by department
DELIMITER //
CREATE PROCEDURE GetEmployeesByDepartment(IN dept VARCHAR(50))
BEGIN
    SELECT employee_id, employee_name, salary
    FROM Employees
    WHERE department = dept;
END //
DELIMITER ;

-- 10. TCL: Update employee details with rollback
START TRANSACTION;
UPDATE Employees SET salary = salary * 1.1 WHERE department = 'Pharmacy';
UPDATE Employees SET position = 'Senior' WHERE department = 'Admin';
-- Simulate error
INSERT INTO Employees (employee_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit phone update
START TRANSACTION;
UPDATE Employees SET phone = '555-1234' WHERE employee_id = 3;
SAVEPOINT phone_updated;
UPDATE Employees SET email = 'new@email.com' WHERE employee_id = 3;
COMMIT;

-- 12. TCL: Rollback salary update
START TRANSACTION;
UPDATE Employees SET salary = 60000 WHERE employee_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Employees TO 'user13'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Employees TO 'hr_manager';

-- 15. Trigger: Log salary changes
DELIMITER //
CREATE TRIGGER LogSalaryChange
AFTER UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.salary != NEW.salary THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.employee_id, 'Salary Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Employee ID: ', NEW.employee_id, ' Salary changed from ', OLD.salary, ' to ', NEW.salary),
                'Employees', 'Salary adjustment');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative salary
DELIMITER //
CREATE TRIGGER PreventNegativeSalary
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new employee
DELIMITER //
CREATE TRIGGER LogNewEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.employee_id, 'New Employee', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Employee ID: ', NEW.employee_id, ' added'),
            'Employees', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank employees by salary
SELECT employee_id, department, salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM Employees;

-- 19. Window Function: Running total salary by department
SELECT employee_id, department, salary,
       SUM(salary) OVER (PARTITION BY department ORDER BY employee_id) AS running_total
FROM Employees;

-- 20. Window Function: Salary percentage by department
SELECT employee_id, department, salary,
       salary / SUM(salary) OVER (PARTITION BY department) * 100 AS salary_percentage
FROM Employees;


-- Table 14: Shifts
-- 1. View: Active shifts
CREATE VIEW ActiveShifts AS
SELECT shift_id, shift_name, start_time, end_time
FROM Shifts
WHERE is_active = TRUE;

-- 2. View: Shifts with employees
CREATE VIEW ShiftsWithEmployees AS
SELECT sh.shift_id, sh.shift_name, COUNT(es.employee_shift_id) AS employee_count
FROM Shifts sh
LEFT JOIN Employee_Shifts es ON sh.shift_id = es.shift_id
GROUP BY sh.shift_id;

-- 3. View: Night shifts
CREATE VIEW NightShifts AS
SELECT shift_id, shift_name, shift_type
FROM Shifts
WHERE shift_type = 'Night';

-- 4. CTE: Average duration by type
WITH ShiftAvgDuration AS (
    SELECT shift_type, AVG(TIMEDIFF(end_time, start_time)) AS avg_duration
    FROM Shifts
    GROUP BY shift_type
)
SELECT sh.shift_id, sh.shift_type, sh.start_time, sh.end_time, a.avg_duration
FROM ShiftAvgDuration a
JOIN Shifts sh ON a.shift_type = sh.shift_type;

-- 5. CTE: Shifts with high multiplier
WITH HighMultiplierShifts AS (
    SELECT shift_id, hourly_rate_multiplier
    FROM Shifts
    WHERE hourly_rate_multiplier > 1.5
)
SELECT sh.shift_name, h.hourly_rate_multiplier
FROM HighMultiplierShifts h
JOIN Shifts sh ON h.shift_id = sh.shift_id;

-- 6. CTE: Ranked shifts by creation
WITH RankedShifts AS (
    SELECT shift_id, shift_name, created_date,
           RANK() OVER (ORDER BY created_date DESC) AS create_rank
    FROM Shifts
)
SELECT shift_name, created_date, create_rank
FROM RankedShifts
WHERE create_rank <= 5;

-- 7. Stored Procedure: Update shift time
DELIMITER //
CREATE PROCEDURE UpdateShiftTime(IN shift_id INT, IN new_start TIME)
BEGIN
    UPDATE Shifts SET start_time = new_start WHERE shift_id = shift_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Deactivate old shifts
DELIMITER //
CREATE PROCEDURE DeactivateOldShifts()
BEGIN
    UPDATE Shifts SET is_active = FALSE WHERE created_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get shifts by type
DELIMITER //
CREATE PROCEDURE GetShiftsByType(IN type VARCHAR(20))
BEGIN
    SELECT shift_id, shift_name, start_time
    FROM Shifts
    WHERE shift_type = type AND is_active = TRUE;
END //
DELIMITER ;

-- 10. TCL: Update shift with rollback
START TRANSACTION;
UPDATE Shifts SET start_time = '09:00:00' WHERE shift_id = 1;
UPDATE Shifts SET end_time = '17:00:00' WHERE shift_id = 2;
-- Simulate error
INSERT INTO Shifts (shift_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit type update
START TRANSACTION;
UPDATE Shifts SET shift_type = 'Day' WHERE shift_id = 3;
SAVEPOINT type_updated;
UPDATE Shifts SET notes = 'Updated notes' WHERE shift_id = 3;
COMMIT;

-- 12. TCL: Rollback time update
START TRANSACTION;
UPDATE Shifts SET start_time = '08:00:00' WHERE shift_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Shifts TO 'user14'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Shifts TO 'shift_manager';

-- 15. Trigger: Log shift changes
DELIMITER //
CREATE TRIGGER LogShiftChange
AFTER UPDATE ON Shifts
FOR EACH ROW
BEGIN
    IF OLD.start_time != NEW.start_time THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.created_by, 'Time Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Shift ID: ', NEW.shift_id, ' Start time changed to ', NEW.start_time),
                'Shifts', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid duration
DELIMITER //
CREATE TRIGGER PreventInvalidDuration
BEFORE UPDATE ON Shifts
FOR EACH ROW
BEGIN
    IF NEW.end_time <= NEW.start_time THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'End time must be after start time';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new shift
DELIMITER //
CREATE TRIGGER LogNewShift
AFTER INSERT ON Shifts
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.created_by, 'New Shift', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Shift ID: ', NEW.shift_id, ' added'),
            'Shifts', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank shifts by multiplier
SELECT shift_id, shift_type, hourly_rate_multiplier,
       RANK() OVER (PARTITION BY shift_type ORDER BY hourly_rate_multiplier DESC) AS multiplier_rank
FROM Shifts;

-- 19. Window Function: Running total breaks by type
SELECT shift_id, shift_type, break_duration,
       SUM(break_duration) OVER (PARTITION BY shift_type ORDER BY shift_id) AS running_break
FROM Shifts;

-- 20. Window Function: Break percentage by type
SELECT shift_id, shift_type, break_duration,
       break_duration / SUM(break_duration) OVER (PARTITION BY shift_type) * 100 AS break_percentage
FROM Shifts;


-- Table 15: Employee_Shifts
-- 1. View: Shifts with overtime
CREATE VIEW ShiftsWithOvertime AS
SELECT employee_shift_id, employee_id, overtime_minutes
FROM Employee_Shifts
WHERE overtime_minutes > 0;

-- 2. View: Employee_Shifts with employees
CREATE VIEW EmployeeShiftsWithEmployees AS
SELECT es.employee_shift_id, e.employee_name, es.total_hours, es.overtime_minutes
FROM Employee_Shifts es
JOIN Employees e ON es.employee_id = e.employee_id;

-- 3. View: Long shifts
CREATE VIEW LongShifts AS
SELECT employee_shift_id, total_hours
FROM Employee_Shifts
WHERE total_hours > 8;

-- 4. CTE: Average hours by employee
WITH EmployeeAvgHours AS (
    SELECT employee_id, AVG(total_hours) AS avg_hours
    FROM Employee_Shifts
    GROUP BY employee_id
)
SELECT es.employee_shift_id, es.employee_id, es.total_hours, a.avg_hours
FROM EmployeeAvgHours a
JOIN Employee_Shifts es ON a.employee_id = es.employee_id
WHERE es.total_hours > a.avg_hours;

-- 5. CTE: Employees with high overtime
WITH HighOvertime AS (
    SELECT employee_id, SUM(overtime_minutes) AS total_ot
    FROM Employee_Shifts
    GROUP BY employee_id
)
SELECT e.employee_name, h.total_ot
FROM HighOvertime h
JOIN Employees e ON h.employee_id = e.employee_id
WHERE h.total_ot > 120;

-- 6. CTE: Ranked shifts by hours
WITH RankedEmployeeShifts AS (
    SELECT employee_shift_id, employee_id, total_hours,
           RANK() OVER (ORDER BY total_hours DESC) AS hours_rank
    FROM Employee_Shifts
)
SELECT employee_id, total_hours, hours_rank
FROM RankedEmployeeShifts
WHERE hours_rank <= 5;

-- 7. Stored Procedure: Update shift hours
DELIMITER //
CREATE PROCEDURE UpdateShiftHours(IN shift_id INT, IN new_hours DECIMAL(5,2))
BEGIN
    UPDATE Employee_Shifts SET total_hours = new_hours WHERE employee_shift_id = shift_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old shifts
DELIMITER //
CREATE PROCEDURE DeleteOldEmployeeShifts()
BEGIN
    DELETE FROM Employee_Shifts WHERE work_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get shifts by employee
DELIMITER //
CREATE PROCEDURE GetShiftsByEmployee(IN emp_id INT)
BEGIN
    SELECT employee_shift_id, work_date, total_hours
    FROM Employee_Shifts
    WHERE employee_id = emp_id;
END //
DELIMITER ;

-- 10. TCL: Update shift with rollback
START TRANSACTION;
UPDATE Employee_Shifts SET total_hours = total_hours + 1 WHERE employee_id = 1;
UPDATE Employee_Shifts SET overtime_minutes = overtime_minutes + 30 WHERE employee_id = 2;
-- Simulate error
INSERT INTO Employee_Shifts (employee_shift_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit break update
START TRANSACTION;
UPDATE Employee_Shifts SET break_minutes = 60 WHERE employee_shift_id = 3;
SAVEPOINT break_updated;
UPDATE Employee_Shifts SET actual_end_time = ADDTIME(actual_end_time, '01:00:00') WHERE employee_shift_id = 3;
COMMIT;

-- 12. TCL: Rollback hours update
START TRANSACTION;
UPDATE Employee_Shifts SET total_hours = 8 WHERE employee_shift_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Employee_Shifts TO 'user15'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Employee_Shifts TO 'shift_supervisor';

-- 15. Trigger: Log shift changes
DELIMITER //
CREATE TRIGGER LogEmployeeShiftChange
AFTER UPDATE ON Employee_Shifts
FOR EACH ROW
BEGIN
    IF OLD.total_hours != NEW.total_hours THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.employee_id, 'Hours Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Shift ID: ', NEW.employee_shift_id, ' Hours changed to ', NEW.total_hours),
                'Employee_Shifts', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative overtime
DELIMITER //
CREATE TRIGGER PreventNegativeOvertime
BEFORE UPDATE ON Employee_Shifts
FOR EACH ROW
BEGIN
    IF NEW.overtime_minutes < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Overtime minutes cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new shift assignment
DELIMITER //
CREATE TRIGGER LogNewEmployeeShift
AFTER INSERT ON Employee_Shifts
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.employee_id, 'New Shift Assignment', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Shift ID: ', NEW.employee_shift_id, ' assigned'),
            'Employee_Shifts', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank shifts by hours
SELECT employee_shift_id, employee_id, total_hours,
       RANK() OVER (PARTITION BY employee_id ORDER BY total_hours DESC) AS hours_rank
FROM Employee_Shifts;

-- 19. Window Function: Running total hours by employee
SELECT employee_shift_id, employee_id, total_hours,
       SUM(total_hours) OVER (PARTITION BY employee_id ORDER BY employee_shift_id) AS running_total
FROM Employee_Shifts;

-- 20. Window Function: Hours percentage by employee
SELECT employee_shift_id, employee_id, total_hours,
       total_hours / SUM(total_hours) OVER (PARTITION BY employee_id) * 100 AS hours_percentage
FROM Employee_Shifts;


-- Table 16: Vendors
-- 1. View: Active vendors with terms
CREATE VIEW ActiveVendors AS
SELECT vendor_id, vendor_name, vendor_type, payment_terms
FROM Vendors
WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);  -- Proxy for active

-- 2. View: Vendors with contracts
CREATE VIEW VendorsWithContracts AS
SELECT v.vendor_id, v.vendor_name, COUNT(vc.contract_id) AS contract_count
FROM Vendors v
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id
GROUP BY v.vendor_id;

-- 3. View: Vendor contact details
CREATE VIEW VendorContacts AS
SELECT vendor_id, vendor_name, email, phone
FROM Vendors
WHERE email IS NOT NULL;

-- 4. CTE: Average value by vendor
WITH VendorAvgValue AS (
    SELECT vendor_id, AVG(contract_value) AS avg_value
    FROM Vendor_Contracts
    GROUP BY vendor_id
)
SELECT v.vendor_id, v.vendor_name, a.avg_value
FROM VendorAvgValue a
JOIN Vendors v ON a.vendor_id = v.vendor_id
WHERE a.avg_value > 10000;

-- 5. CTE: Vendors with expenses
WITH VendorsWithExpenses AS (
    SELECT vendor_id, SUM(amount) AS total_expense
    FROM Expenses
    GROUP BY vendor_id
)
SELECT v.vendor_name, e.total_expense
FROM VendorsWithExpenses e
JOIN Vendors v ON e.vendor_id = v.vendor_id
WHERE e.total_expense > 5000;

-- 6. CTE: Ranked vendors by creation
WITH RankedVendors AS (
    SELECT vendor_id, vendor_name, created_date,
           RANK() OVER (ORDER BY created_date DESC) AS create_rank
    FROM Vendors
)
SELECT vendor_name, created_date, create_rank
FROM RankedVendors
WHERE create_rank <= 5;

-- 7. Stored Procedure: Update vendor email
DELIMITER //
CREATE PROCEDURE UpdateVendorEmail(IN ven_id INT, IN new_email VARCHAR(100))
BEGIN
    UPDATE Vendors SET email = new_email WHERE vendor_id = ven_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete inactive vendors
DELIMITER //
CREATE PROCEDURE DeleteInactiveVendors()
BEGIN
    DELETE FROM Vendors WHERE created_date < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get vendors by type
DELIMITER //
CREATE PROCEDURE GetVendorsByType(IN type VARCHAR(50))
BEGIN
    SELECT vendor_id, vendor_name, website
    FROM Vendors
    WHERE vendor_type = type;
END //
DELIMITER ;

-- 10. TCL: Update vendor details with rollback
START TRANSACTION;
UPDATE Vendors SET email = 'new.email@email.com' WHERE vendor_id = 1;
UPDATE Vendors SET phone = '555-9999' WHERE vendor_id = 2;
-- Simulate error
INSERT INTO Vendors (vendor_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit address update
START TRANSACTION;
UPDATE Vendors SET address = '123 New St' WHERE vendor_id = 3;
SAVEPOINT address_updated;
UPDATE Vendors SET payment_terms = 'Net 30' WHERE vendor_id = 3;
COMMIT;

-- 12. TCL: Rollback email update
START TRANSACTION;
UPDATE Vendors SET email = 'test@email.com' WHERE vendor_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Vendors TO 'user16'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Vendors TO 'vendor_manager';

-- 15. Trigger: Log vendor changes
DELIMITER //
CREATE TRIGGER LogVendorChange
AFTER UPDATE ON Vendors
FOR EACH ROW
BEGIN
    IF OLD.email != NEW.email THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Email Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Vendor ID: ', NEW.vendor_id, ' Email changed to ', NEW.email),
                'Vendors', 'Contact update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid terms
DELIMITER //
CREATE TRIGGER PreventInvalidTerms
BEFORE UPDATE ON Vendors
FOR EACH ROW
BEGIN
    IF NEW.payment_terms NOT LIKE 'Net%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid payment terms format';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new vendor
DELIMITER //
CREATE TRIGGER LogNewVendor
AFTER INSERT ON Vendors
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Vendor', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Vendor ID: ', NEW.vendor_id, ' added'),
            'Vendors', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank vendors by creation
SELECT vendor_id, vendor_name, created_date,
       RANK() OVER (ORDER BY created_date DESC) AS create_rank
FROM Vendors;

-- 19. Window Function: Running total vendors by type
SELECT vendor_id, vendor_type, 
       COUNT(*) OVER (PARTITION BY vendor_type ORDER BY vendor_id) AS type_count
FROM Vendors;

-- 20. Window Function: Vendor percentage by type
SELECT vendor_id, vendor_type,
       COUNT(*) OVER (PARTITION BY vendor_type) / COUNT(*) OVER () * 100 AS type_percentage
FROM Vendors;


-- Table 17: Vendor_Contracts
-- 1. View: Active contracts
CREATE VIEW ActiveContracts AS
SELECT contract_id, vendor_id, contract_name
FROM Vendor_Contracts
WHERE contract_status = 'Active';

-- 2. View: Contracts with vendors
CREATE VIEW ContractsWithVendors AS
SELECT vc.contract_id, v.vendor_name, vc.contract_value, vc.payment_terms
FROM Vendor_Contracts vc
JOIN Vendors v ON vc.vendor_id = v.vendor_id;

-- 3. View: High value contracts
CREATE VIEW HighValueContracts AS
SELECT contract_id, contract_value
FROM Vendor_Contracts
WHERE contract_value > 10000;

-- 4. CTE: Average value by vendor
WITH VendorAvgContract AS (
    SELECT vendor_id, AVG(contract_value) AS avg_value
    FROM Vendor_Contracts
    GROUP BY vendor_id
)
SELECT vc.contract_id, vc.vendor_id, vc.contract_value, a.avg_value
FROM VendorAvgContract a
JOIN Vendor_Contracts vc ON a.vendor_id = vc.vendor_id
WHERE vc.contract_value > a.avg_value;

-- 5. CTE: Contracts expiring soon
WITH ExpiringContracts AS (
    SELECT contract_id, end_date
    FROM Vendor_Contracts
    WHERE end_date < DATE_ADD(CURDATE(), INTERVAL 3 MONTH)
)
SELECT vc.contract_name, e.end_date
FROM ExpiringContracts e
JOIN Vendor_Contracts vc ON e.contract_id = vc.contract_id;

-- 6. CTE: Ranked contracts by value
WITH RankedContracts AS (
    SELECT contract_id, vendor_id, contract_value,
           RANK() OVER (ORDER BY contract_value DESC) AS value_rank
    FROM Vendor_Contracts
)
SELECT vendor_id, contract_value, value_rank
FROM RankedContracts
WHERE value_rank <= 5;

-- 7. Stored Procedure: Update contract status
DELIMITER //
CREATE PROCEDURE UpdateContractStatus(IN cont_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE Vendor_Contracts SET contract_status = new_status WHERE contract_id = cont_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete expired contracts
DELIMITER //
CREATE PROCEDURE DeleteExpiredContracts()
BEGIN
    DELETE FROM Vendor_Contracts WHERE end_date < CURDATE();
END //
DELIMITER ;

-- 9. Stored Procedure: Get contracts by vendor
DELIMITER //
CREATE PROCEDURE GetContractsByVendor(IN ven_id INT)
BEGIN
    SELECT contract_id, contract_name, contract_value
    FROM Vendor_Contracts
    WHERE vendor_id = ven_id;
END //
DELIMITER ;

-- 10. TCL: Update contract with rollback
START TRANSACTION;
UPDATE Vendor_Contracts SET contract_value = contract_value * 1.1 WHERE vendor_id = 1;
UPDATE Vendor_Contracts SET payment_terms = 'Net 60' WHERE vendor_id = 2;
-- Simulate error
INSERT INTO Vendor_Contracts (contract_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit status update
START TRANSACTION;
UPDATE Vendor_Contracts SET contract_status = 'Active' WHERE contract_id = 3;
SAVEPOINT status_updated;
UPDATE Vendor_Contracts SET renewal_terms = 'Auto renew' WHERE contract_id = 3;
COMMIT;

-- 12. TCL: Rollback value update
START TRANSACTION;
UPDATE Vendor_Contracts SET contract_value = 15000 WHERE contract_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Vendor_Contracts TO 'user17'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Vendor_Contracts TO 'contract_manager';

-- 15. Trigger: Log contract changes
DELIMITER //
CREATE TRIGGER LogContractChange
AFTER UPDATE ON Vendor_Contracts
FOR EACH ROW
BEGIN
    IF OLD.contract_status != NEW.contract_status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Status Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Contract ID: ', NEW.contract_id, ' Status changed to ', NEW.contract_status),
                'Vendor_Contracts', 'Status change');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid value
DELIMITER //
CREATE TRIGGER PreventInvalidContractValue
BEFORE UPDATE ON Vendor_Contracts
FOR EACH ROW
BEGIN
    IF NEW.contract_value < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Contract value cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new contract
DELIMITER //
CREATE TRIGGER LogNewContract
AFTER INSERT ON Vendor_Contracts
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Contract', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Contract ID: ', NEW.contract_id, ' added'),
            'Vendor_Contracts', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank contracts by value
SELECT contract_id, vendor_id, contract_value,
       RANK() OVER (PARTITION BY vendor_id ORDER BY contract_value DESC) AS value_rank
FROM Vendor_Contracts;

-- 19. Window Function: Running total value by vendor
SELECT contract_id, vendor_id, contract_value,
       SUM(contract_value) OVER (PARTITION BY vendor_id ORDER BY contract_id) AS running_total
FROM Vendor_Contracts;

-- 20. Window Function: Value percentage by vendor
SELECT contract_id, vendor_id, contract_value,
       contract_value / SUM(contract_value) OVER (PARTITION BY vendor_id) * 100 AS value_percentage
FROM Vendor_Contracts;


-- Table 18: Expenses
-- 1. View: Approved expenses
CREATE VIEW ApprovedExpenses AS
SELECT expense_id, expense_type, amount
FROM Expenses
WHERE status = 'Approved';

-- 2. View: Expenses with vendors
CREATE VIEW ExpensesWithVendors AS
SELECT ex.expense_id, v.vendor_name, ex.amount, ex.payment_method
FROM Expenses ex
JOIN Vendors v ON ex.vendor_id = v.vendor_id;

-- 3. View: High amount expenses
CREATE VIEW HighAmountExpenses AS
SELECT expense_id, amount
FROM Expenses
WHERE amount > 500;

-- 4. CTE: Average amount by type
WITH TypeAvgAmount AS (
    SELECT expense_type, AVG(amount) AS avg_amount
    FROM Expenses
    GROUP BY expense_type
)
SELECT ex.expense_id, ex.expense_type, ex.amount, a.avg_amount
FROM TypeAvgAmount a
JOIN Expenses ex ON a.expense_type = ex.expense_type
WHERE ex.amount > a.avg_amount;

-- 5. CTE: Expenses with high reference
WITH HighReferenceExpenses AS (
    SELECT expense_id, reference_number
    FROM Expenses
    WHERE reference_number > 100
)
SELECT ex.description, h.reference_number
FROM HighReferenceExpenses h
JOIN Expenses ex ON h.expense_id = ex.expense_id;

-- 6. CTE: Ranked expenses by date
WITH RankedExpenses AS (
    SELECT expense_id, expense_type, expense_date,
           RANK() OVER (ORDER BY expense_date DESC) AS date_rank
    FROM Expenses
)
SELECT expense_type, expense_date, date_rank
FROM RankedExpenses
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update expense status
DELIMITER //
CREATE PROCEDURE UpdateExpenseStatus(IN exp_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE Expenses SET status = new_status WHERE expense_id = exp_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old expenses
DELIMITER //
CREATE PROCEDURE DeleteOldExpenses()
BEGIN
    DELETE FROM Expenses WHERE expense_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get expenses by vendor
DELIMITER //
CREATE PROCEDURE GetExpensesByVendor(IN ven_id INT)
BEGIN
    SELECT expense_id, expense_type, amount
    FROM Expenses
    WHERE vendor_id = ven_id;
END //
DELIMITER ;

-- 10. TCL: Update expense with rollback
START TRANSACTION;
UPDATE Expenses SET amount = amount * 1.1 WHERE vendor_id = 1;
UPDATE Expenses SET description = 'Updated desc' WHERE vendor_id = 2;
-- Simulate error
INSERT INTO Expenses (expense_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit status update
START TRANSACTION;
UPDATE Expenses SET status = 'Approved' WHERE expense_id = 3;
SAVEPOINT status_updated;
UPDATE Expenses SET approved_by = 1 WHERE expense_id = 3;
COMMIT;

-- 12. TCL: Rollback amount update
START TRANSACTION;
UPDATE Expenses SET amount = 1000 WHERE expense_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Expenses TO 'user18'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Expenses TO 'expense_manager';

-- 15. Trigger: Log expense changes
DELIMITER //
CREATE TRIGGER LogExpenseChange
AFTER UPDATE ON Expenses
FOR EACH ROW
BEGIN
    IF OLD.amount != NEW.amount THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.approved_by, 'Amount Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Expense ID: ', NEW.expense_id, ' Amount changed to ', NEW.amount),
                'Expenses', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative amount
DELIMITER //
CREATE TRIGGER PreventNegativeExpense
BEFORE UPDATE ON Expenses
FOR EACH ROW
BEGIN
    IF NEW.amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new expense
DELIMITER //
CREATE TRIGGER LogNewExpense
AFTER INSERT ON Expenses
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.approved_by, 'New Expense', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Expense ID: ', NEW.expense_id, ' added'),
            'Expenses', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank expenses by amount
SELECT expense_id, vendor_id, amount,
       RANK() OVER (PARTITION BY vendor_id ORDER BY amount DESC) AS amount_rank
FROM Expenses;

-- 19. Window Function: Running total amount by type
SELECT expense_id, expense_type, amount,
       SUM(amount) OVER (PARTITION BY expense_type ORDER BY expense_id) AS running_total
FROM Expenses;

-- 20. Window Function: Amount percentage by type
SELECT expense_id, expense_type, amount,
       amount / SUM(amount) OVER (PARTITION BY expense_type) * 100 AS amount_percentage
FROM Expenses;


-- Table 19: Payments
-- 1. View: Successful payments
CREATE VIEW SuccessfulPayments AS
SELECT payment_id, payment_type, amount
FROM Payments
WHERE status = 'Success';

-- 2. View: Payments with employees
CREATE VIEW PaymentsWithEmployees AS
SELECT p.payment_id, e.employee_name, p.amount, p.payment_method
FROM Payments p
JOIN Employees e ON p.processed_by = e.employee_id;

-- 3. View: High amount payments
CREATE VIEW HighAmountPayments AS
SELECT payment_id, amount
FROM Payments
WHERE amount > 200;

-- 4. CTE: Average amount by type
WITH TypeAvgPayment AS (
    SELECT payment_type, AVG(amount) AS avg_amount
    FROM Payments
    GROUP BY payment_type
)
SELECT p.payment_id, p.payment_type, p.amount, a.avg_amount
FROM TypeAvgPayment a
JOIN Payments p ON a.payment_type = p.payment_type
WHERE p.amount > a.avg_amount;

-- 5. CTE: Payments with notes
WITH NotedPayments AS (
    SELECT payment_id, notes
    FROM Payments
    WHERE notes IS NOT NULL
)
SELECT p.transaction_id, n.notes
FROM NotedPayments n
JOIN Payments p ON n.payment_id = p.payment_id;

-- 6. CTE: Ranked payments by date
WITH RankedPayments AS (
    SELECT payment_id, payment_type, payment_date,
           RANK() OVER (ORDER BY payment_date DESC) AS date_rank
    FROM Payments
)
SELECT payment_type, payment_date, date_rank
FROM RankedPayments
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update payment status
DELIMITER //
CREATE PROCEDURE UpdatePaymentStatus(IN pay_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE Payments SET status = new_status WHERE payment_id = pay_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old payments
DELIMITER //
CREATE PROCEDURE DeleteOldPayments()
BEGIN
    DELETE FROM Payments WHERE payment_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get payments by type
DELIMITER //
CREATE PROCEDURE GetPaymentsByType(IN type VARCHAR(20))
BEGIN
    SELECT payment_id, amount, transaction_id
    FROM Payments
    WHERE payment_type = type;
END //
DELIMITER ;

-- 10. TCL: Update payment with rollback
START TRANSACTION;
UPDATE Payments SET amount = amount * 1.1 WHERE payment_type = 'Credit';
UPDATE Payments SET notes = 'Updated notes' WHERE payment_type = 'Cash';
-- Simulate error
INSERT INTO Payments (payment_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit status update
START TRANSACTION;
UPDATE Payments SET status = 'Success' WHERE payment_id = 3;
SAVEPOINT status_updated;
UPDATE Payments SET processed_by = 1 WHERE payment_id = 3;
COMMIT;

-- 12. TCL: Rollback amount update
START TRANSACTION;
UPDATE Payments SET amount = 300 WHERE payment_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Payments TO 'user19'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Payments TO 'payment_manager';

-- 15. Trigger: Log payment changes
DELIMITER //
CREATE TRIGGER LogPaymentChange
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.processed_by, 'Status Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Payment ID: ', NEW.payment_id, ' Status changed to ', NEW.status),
                'Payments', 'Status change');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative amount
DELIMITER //
CREATE TRIGGER PreventNegativePayment
BEFORE UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF NEW.amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new payment
DELIMITER //
CREATE TRIGGER LogNewPayment
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.processed_by, 'New Payment', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Payment ID: ', NEW.payment_id, ' added'),
            'Payments', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank payments by amount
SELECT payment_id, payment_type, amount,
       RANK() OVER (PARTITION BY payment_type ORDER BY amount DESC) AS amount_rank
FROM Payments;

-- 19. Window Function: Running total amount by type
SELECT payment_id, payment_type, amount,
       SUM(amount) OVER (PARTITION BY payment_type ORDER BY payment_id) AS running_total
FROM Payments;

-- 20. Window Function: Amount percentage by type
SELECT payment_id, payment_type, amount,
       amount / SUM(amount) OVER (PARTITION BY payment_type) * 100 AS amount_percentage
FROM Payments;


-- Table 20: Insurance_Providers
-- 1. View: Active providers
CREATE VIEW ActiveProviders AS
SELECT provider_id, provider_name, discount_percentage
FROM Insurance_Providers
WHERE contract_end_date > CURDATE();

-- 2. View: Providers with claims
CREATE VIEW ProvidersWithClaims AS
SELECT ip.provider_id, ip.provider_name, COUNT(ic.claim_id) AS claim_count
FROM Insurance_Providers ip
LEFT JOIN Insurance_Claims ic ON ip.provider_id = ic.provider_id
GROUP BY ip.provider_id;

-- 3. View: High discount providers
CREATE VIEW HighDiscountProviders AS
SELECT provider_id, discount_percentage
FROM Insurance_Providers
WHERE discount_percentage > 15;

-- 4. CTE: Average discount by provider
WITH ProviderAvgDiscount AS (
    SELECT provider_id, discount_percentage
    FROM Insurance_Providers
)
SELECT ip.provider_id, ip.provider_name, AVG(ip.discount_percentage) AS avg_discount
FROM Insurance_Providers ip
GROUP BY ip.provider_id;

-- 5. CTE: Providers with high claims
WITH HighClaimProviders AS (
    SELECT provider_id, COUNT(*) AS claim_count
    FROM Insurance_Claims
    GROUP BY provider_id
)
SELECT ip.provider_name, h.claim_count
FROM HighClaimProviders h
JOIN Insurance_Providers ip ON h.provider_id = ip.provider_id
WHERE h.claim_count > 5;

-- 6. CTE: Ranked providers by start date
WITH RankedProviders AS (
    SELECT provider_id, provider_name, contract_start_date,
           RANK() OVER (ORDER BY contract_start_date DESC) AS start_rank
    FROM Insurance_Providers
)
SELECT provider_name, contract_start_date, start_rank
FROM RankedProviders
WHERE start_rank <= 5;

-- 7. Stored Procedure: Update provider discount
DELIMITER //
CREATE PROCEDURE UpdateProviderDiscount(IN prov_id INT, IN new_disc DECIMAL(5,2))
BEGIN
    UPDATE Insurance_Providers SET discount_percentage = new_disc WHERE provider_id = prov_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete expired providers
DELIMITER //
CREATE PROCEDURE DeleteExpiredProviders()
BEGIN
    DELETE FROM Insurance_Providers WHERE contract_end_date < CURDATE();
END //
DELIMITER ;

-- 9. Stored Procedure: Get providers by name
DELIMITER //
CREATE PROCEDURE GetProvidersByName(IN name VARCHAR(100))
BEGIN
    SELECT provider_id, provider_name, address
    FROM Insurance_Providers
    WHERE provider_name LIKE CONCAT('%', name, '%');
END //
DELIMITER ;

-- 10. TCL: Update provider with rollback
START TRANSACTION;
UPDATE Insurance_Providers SET discount_percentage = discount_percentage + 5 WHERE provider_id = 1;
UPDATE Insurance_Providers SET claim_processing_days = 10 WHERE provider_id = 2;
-- Simulate error
INSERT INTO Insurance_Providers (provider_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit end date update
START TRANSACTION;
UPDATE Insurance_Providers SET contract_end_date = DATE_ADD(contract_end_date, INTERVAL 1 YEAR) WHERE provider_id = 3;
SAVEPOINT end_updated;
UPDATE Insurance_Providers SET notes = 'Extended' WHERE provider_id = 3;
COMMIT;

-- 12. TCL: Rollback discount update
START TRANSACTION;
UPDATE Insurance_Providers SET discount_percentage = 20 WHERE provider_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Insurance_Providers TO 'user20'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Insurance_Providers TO 'insurance_manager';

-- 15. Trigger: Log provider changes
DELIMITER //
CREATE TRIGGER LogProviderChange
AFTER UPDATE ON Insurance_Providers
FOR EACH ROW
BEGIN
    IF OLD.discount_percentage != NEW.discount_percentage THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Discount Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Provider ID: ', NEW.provider_id, ' Discount changed to ', NEW.discount_percentage),
                'Insurance_Providers', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid discount
DELIMITER //
CREATE TRIGGER PreventInvalidDiscountProvider
BEFORE UPDATE ON Insurance_Providers
FOR EACH ROW
BEGIN
    IF NEW.discount_percentage < 0 OR NEW.discount_percentage > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Discount percentage must be between 0 and 100';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new provider
DELIMITER //
CREATE TRIGGER LogNewProvider
AFTER INSERT ON Insurance_Providers
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Provider', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Provider ID: ', NEW.provider_id, ' added'),
            'Insurance_Providers', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank providers by discount
SELECT provider_id, provider_name, discount_percentage,
       RANK() OVER (ORDER BY discount_percentage DESC) AS discount_rank
FROM Insurance_Providers;

-- 19. Window Function: Running total days by provider
SELECT provider_id, provider_name, claim_processing_days,
       SUM(claim_processing_days) OVER (ORDER BY provider_id) AS running_days
FROM Insurance_Providers;

-- 20. Window Function: Days percentage
SELECT provider_id, claim_processing_days,
       claim_processing_days / SUM(claim_processing_days) OVER () * 100 AS days_percentage
FROM Insurance_Providers;


-- Table 21: Insurance_Claims
-- 1. View: Processed claims
CREATE VIEW ProcessedClaims AS
SELECT claim_id, prescription_id, claim_amount
FROM Insurance_Claims
WHERE status = 'Processed';

-- 2. View: Claims with providers
CREATE VIEW ClaimsWithProviders AS
SELECT ic.claim_id, ip.provider_name, ic.covered_amount, ic.rejection_reason
FROM Insurance_Claims ic
JOIN Insurance_Providers ip ON ic.provider_id = ip.provider_id;

-- 3. View: High covered claims
CREATE VIEW HighCoveredClaims AS
SELECT claim_id, covered_amount
FROM Insurance_Claims
WHERE covered_amount > 200;

-- 4. CTE: Average covered by provider
WITH ProviderAvgCovered AS (
    SELECT provider_id, AVG(covered_amount) AS avg_covered
    FROM Insurance_Claims
    GROUP BY provider_id
)
SELECT ic.claim_id, ic.provider_id, ic.covered_amount, a.avg_covered
FROM ProviderAvgCovered a
JOIN Insurance_Claims ic ON a.provider_id = ic.provider_id
WHERE ic.covered_amount > a.avg_covered;

-- 5. CTE: Rejected claims
WITH RejectedClaims AS (
    SELECT claim_id, rejection_reason
    FROM Insurance_Claims
    WHERE rejection_reason IS NOT NULL
)
SELECT ic.status, r.rejection_reason
FROM RejectedClaims r
JOIN Insurance_Claims ic ON r.claim_id = ic.claim_id;

-- 6. CTE: Ranked claims by date
WITH RankedClaims AS (
    SELECT claim_id, provider_id, claim_date,
           RANK() OVER (ORDER BY claim_date DESC) AS date_rank
    FROM Insurance_Claims
)
SELECT provider_id, claim_date, date_rank
FROM RankedClaims
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update claim status
DELIMITER //
CREATE PROCEDURE UpdateClaimStatus(IN claim_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE Insurance_Claims SET status = new_status WHERE claim_id = claim_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old claims
DELIMITER //
CREATE PROCEDURE DeleteOldClaims()
BEGIN
    DELETE FROM Insurance_Claims WHERE claim_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get claims by provider
DELIMITER //
CREATE PROCEDURE GetClaimsByProvider(IN prov_id INT)
BEGIN
    SELECT claim_id, claim_amount, covered_amount
    FROM Insurance_Claims
    WHERE provider_id = prov_id;
END //
DELIMITER ;

-- 10. TCL: Update claim with rollback
START TRANSACTION;
UPDATE Insurance_Claims SET covered_amount = covered_amount * 1.1 WHERE provider_id = 1;
UPDATE Insurance_Claims SET status = 'Processed' WHERE provider_id = 2;
-- Simulate error
INSERT INTO Insurance_Claims (claim_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit reason update
START TRANSACTION;
UPDATE Insurance_Claims SET rejection_reason = 'New reason' WHERE claim_id = 3;
SAVEPOINT reason_updated;
UPDATE Insurance_Claims SET notes = 'Updated notes' WHERE claim_id = 3;
COMMIT;

-- 12. TCL: Rollback amount update
START TRANSACTION;
UPDATE Insurance_Claims SET claim_amount = 500 WHERE claim_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Insurance_Claims TO 'user21'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Insurance_Claims TO 'claims_manager';

-- 15. Trigger: Log claim changes
DELIMITER //
CREATE TRIGGER LogClaimChange
AFTER UPDATE ON Insurance_Claims
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Status Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Claim ID: ', NEW.claim_id, ' Status changed to ', NEW.status),
                'Insurance_Claims', 'Status change');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent negative covered
DELIMITER //
CREATE TRIGGER PreventNegativeCovered
BEFORE UPDATE ON Insurance_Claims
FOR EACH ROW
BEGIN
    IF NEW.covered_amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Covered amount cannot be negative';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new claim
DELIMITER //
CREATE TRIGGER LogNewClaim
AFTER INSERT ON Insurance_Claims
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Claim', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Claim ID: ', NEW.claim_id, ' added'),
            'Insurance_Claims', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank claims by amount
SELECT claim_id, provider_id, claim_amount,
       RANK() OVER (PARTITION BY provider_id ORDER BY claim_amount DESC) AS amount_rank
FROM Insurance_Claims;

-- 19. Window Function: Running total covered by provider
SELECT claim_id, provider_id, covered_amount,
       SUM(covered_amount) OVER (PARTITION BY provider_id ORDER BY claim_id) AS running_covered
FROM Insurance_Claims;

-- 20. Window Function: Covered percentage by provider
SELECT claim_id, provider_id, covered_amount,
       covered_amount / SUM(covered_amount) OVER (PARTITION BY provider_id) * 100 AS covered_percentage
FROM Insurance_Claims;


-- Table 22: Patient_Medical_History
-- 1. View: Controlled conditions
CREATE VIEW ControlledConditions AS
SELECT history_id, customer_id, condition_name
FROM Patient_Medical_History
WHERE current_status = 'Controlled';

-- 2. View: History with customers
CREATE VIEW HistoryWithCustomers AS
SELECT pmh.history_id, c.customer_name, pmh.condition_name, pmh.severity
FROM Patient_Medical_History pmh
JOIN Customers c ON pmh.customer_id = c.customer_id;

-- 3. View: Severe history
CREATE VIEW SevereHistory AS
SELECT history_id, severity
FROM Patient_Medical_History
WHERE severity = 'Severe';

-- 4. CTE: Average severity by customer
WITH CustomerAvgSeverity AS (
    SELECT customer_id, COUNT(*) AS condition_count  -- Proxy since severity is string
    FROM Patient_Medical_History
    GROUP BY customer_id
)
SELECT pmh.history_id, pmh.customer_id, a.condition_count
FROM CustomerAvgSeverity a
JOIN Patient_Medical_History pmh ON a.customer_id = pmh.customer_id;

-- 5. CTE: History with notes
WITH NotedHistory AS (
    SELECT history_id, notes
    FROM Patient_Medical_History
    WHERE notes IS NOT NULL
)
SELECT pmh.condition_name, n.notes
FROM NotedHistory n
JOIN Patient_Medical_History pmh ON n.history_id = pmh.history_id;

-- 6. CTE: Ranked history by date
WITH RankedHistory AS (
    SELECT history_id, customer_id, diagnosis_date,
           RANK() OVER (ORDER BY diagnosis_date DESC) AS date_rank
    FROM Patient_Medical_History
)
SELECT customer_id, diagnosis_date, date_rank
FROM RankedHistory
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update history status
DELIMITER //
CREATE PROCEDURE UpdateHistoryStatus(IN hist_id INT, IN new_status VARCHAR(20))
BEGIN
    UPDATE Patient_Medical_History SET current_status = new_status WHERE history_id = hist_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old history
DELIMITER //
CREATE PROCEDURE DeleteOldHistory()
BEGIN
    DELETE FROM Patient_Medical_History WHERE diagnosis_date < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get history by customer
DELIMITER //
CREATE PROCEDURE GetHistoryByCustomer(IN cust_id INT)
BEGIN
    SELECT history_id, condition_name, diagnosis_date
    FROM Patient_Medical_History
    WHERE customer_id = cust_id;
END //
DELIMITER ;

-- 10. TCL: Update history with rollback
START TRANSACTION;
UPDATE Patient_Medical_History SET severity = 'Moderate' WHERE customer_id = 1;
UPDATE Patient_Medical_History SET current_status = 'Controlled' WHERE customer_id = 2;
-- Simulate error
INSERT INTO Patient_Medical_History (history_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit description update
START TRANSACTION;
UPDATE Patient_Medical_History SET treatment_description = 'New treatment' WHERE history_id = 3;
SAVEPOINT desc_updated;
UPDATE Patient_Medical_History SET notes = 'Updated notes' WHERE history_id = 3;
COMMIT;

-- 12. TCL: Rollback status update
START TRANSACTION;
UPDATE Patient_Medical_History SET current_status = 'Uncontrolled' WHERE history_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Patient_Medical_History TO 'user22'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Patient_Medical_History TO 'medical_manager';

-- 15. Trigger: Log history changes
DELIMITER //
CREATE TRIGGER LogHistoryChange
AFTER UPDATE ON Patient_Medical_History
FOR EACH ROW
BEGIN
    IF OLD.current_status != NEW.current_status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.customer_id, 'Status Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('History ID: ', NEW.history_id, ' Status changed to ', NEW.current_status),
                'Patient_Medical_History', 'Status change');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid severity
DELIMITER //
CREATE TRIGGER PreventInvalidSeverity
BEFORE UPDATE ON Patient_Medical_History
FOR EACH ROW
BEGIN
    IF NEW.severity NOT IN ('Mild', 'Moderate', 'Severe') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid severity value';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new history
DELIMITER //
CREATE TRIGGER LogNewHistory
AFTER INSERT ON Patient_Medical_History
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.customer_id, 'New History', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('History ID: ', NEW.history_id, ' added'),
            'Patient_Medical_History', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank history by date
SELECT history_id, customer_id, diagnosis_date,
       RANK() OVER (PARTITION BY customer_id ORDER BY diagnosis_date DESC) AS date_rank
FROM Patient_Medical_History;

-- 19. Window Function: Running total conditions by customer
SELECT history_id, customer_id,
       COUNT(*) OVER (PARTITION BY customer_id ORDER BY history_id) AS condition_count
FROM Patient_Medical_History;

-- 20. Window Function: Condition percentage by customer
SELECT history_id, customer_id,
       1 / COUNT(*) OVER (PARTITION BY customer_id) * 100 AS cond_percentage
FROM Patient_Medical_History;


-- Table 23: Drug_Interactions
-- 1. View: Major interactions
CREATE VIEW MajorInteractions AS
SELECT interaction_id, product_id1, product_id2, severity
FROM Drug_Interactions
WHERE severity = 'Major';

-- 2. View: Interactions with products
CREATE VIEW InteractionsWithProducts AS
SELECT di.interaction_id, p1.product_name AS product1, p2.product_name AS product2
FROM Drug_Interactions di
JOIN Products p1 ON di.product_id1 = p1.product_id
JOIN Products p2 ON di.product_id2 = p2.product_id;

-- 3. View: Pharmacokinetic interactions
CREATE VIEW PharmacokineticInteractions AS
SELECT interaction_id, interaction_type
FROM Drug_Interactions
WHERE interaction_type = 'Pharmacokinetic';

-- 4. CTE: Count by type
WITH InteractionTypeCount AS (
    SELECT interaction_type, COUNT(*) AS count
    FROM Drug_Interactions
    GROUP BY interaction_type
)
SELECT di.interaction_id, di.interaction_type, t.count
FROM InteractionTypeCount t
JOIN Drug_Interactions di ON t.interaction_type = di.interaction_type;

-- 5. CTE: Severe interactions
WITH SevereInteractions AS (
    SELECT interaction_id, severity
    FROM Drug_Interactions
    WHERE severity = 'Severe'
)
SELECT di.description, s.severity
FROM SevereInteractions s
JOIN Drug_Interactions di ON s.interaction_id = di.interaction_id;

-- 6. CTE: Ranked interactions by date
WITH RankedInteractions AS (
    SELECT interaction_id, created_date,
           RANK() OVER (ORDER BY created_date DESC) AS date_rank
    FROM Drug_Interactions
)
SELECT created_date, date_rank
FROM RankedInteractions
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update interaction severity
DELIMITER //
CREATE PROCEDURE UpdateInteractionSeverity(IN int_id INT, IN new_sev VARCHAR(20))
BEGIN
    UPDATE Drug_Interactions SET severity = new_sev WHERE interaction_id = int_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old interactions
DELIMITER //
CREATE PROCEDURE DeleteOldInteractions()
BEGIN
    DELETE FROM Drug_Interactions WHERE created_date < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get interactions by type
DELIMITER //
CREATE PROCEDURE GetInteractionsByType(IN type VARCHAR(50))
BEGIN
    SELECT interaction_id, product_id1, product_id2
    FROM Drug_Interactions
    WHERE interaction_type = type;
END //
DELIMITER ;

-- 10. TCL: Update interaction with rollback
START TRANSACTION;
UPDATE Drug_Interactions SET severity = 'Moderate' WHERE product_id1 = 1;
UPDATE Drug_Interactions SET description = 'New desc' WHERE product_id2 = 2;
-- Simulate error
INSERT INTO Drug_Interactions (interaction_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit type update
START TRANSACTION;
UPDATE Drug_Interactions SET interaction_type = 'New Type' WHERE interaction_id = 3;
SAVEPOINT type_updated;
UPDATE Drug_Interactions SET management_guidance = 'Updated guidance' WHERE interaction_id = 3;
COMMIT;

-- 12. TCL: Rollback severity update
START TRANSACTION;
UPDATE Drug_Interactions SET severity = 'Minor' WHERE interaction_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Drug_Interactions TO 'user23'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Drug_Interactions TO 'interaction_manager';

-- 15. Trigger: Log interaction changes
DELIMITER //
CREATE TRIGGER LogInteractionChange
AFTER UPDATE ON Drug_Interactions
FOR EACH ROW
BEGIN
    IF OLD.severity != NEW.severity THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (1, 'Severity Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Interaction ID: ', NEW.interaction_id, ' Severity changed to ', NEW.severity),
                'Drug_Interactions', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid type
DELIMITER //
CREATE TRIGGER PreventInvalidType
BEFORE UPDATE ON Drug_Interactions
FOR EACH ROW
BEGIN
    IF NEW.interaction_type NOT IN ('Pharmacokinetic', 'Pharmacodynamic') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid interaction type';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log new interaction
DELIMITER //
CREATE TRIGGER LogNewInteraction
AFTER INSERT ON Drug_Interactions
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (1, 'New Interaction', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Interaction ID: ', NEW.interaction_id, ' added'),
            'Drug_Interactions', 'Addition');
END //
DELIMITER ;

-- 18. Window Function: Rank interactions by severity (assuming numeric mapping)
SELECT interaction_id, severity,
       RANK() OVER (ORDER BY CASE severity WHEN 'Major' THEN 3 WHEN 'Moderate' THEN 2 ELSE 1 END DESC) AS sev_rank
FROM Drug_Interactions;

-- 19. Window Function: Count by type
SELECT interaction_id, interaction_type,
       COUNT(*) OVER (PARTITION BY interaction_type) AS type_count
FROM Drug_Interactions;

-- 20. Window Function: Type percentage
SELECT interaction_id, interaction_type,
       COUNT(*) OVER (PARTITION BY interaction_type) / COUNT(*) OVER () * 100 AS type_percentage
FROM Drug_Interactions;


-- Table 24: Inventory_Adjustments
-- 1. View: Loss adjustments
CREATE VIEW LossAdjustments AS
SELECT adjustment_id, product_id, quantity_adjusted
FROM Inventory_Adjustments
WHERE adjustment_type = 'Loss';

-- 2. View: Adjustments with products
CREATE VIEW AdjustmentsWithProducts AS
SELECT ia.adjustment_id, p.product_name, ia.quantity_adjusted, ia.reason
FROM Inventory_Adjustments ia
JOIN Products p ON ia.product_id = p.product_id;

-- 3. View: Recent adjustments
CREATE VIEW RecentAdjustments AS
SELECT adjustment_id, adjustment_date
FROM Inventory_Adjustments
WHERE adjustment_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 4. CTE: Total adjusted by product
WITH ProductTotalAdjusted AS (
    SELECT product_id, SUM(quantity_adjusted) AS total_adjusted
    FROM Inventory_Adjustments
    GROUP BY product_id
)
SELECT ia.adjustment_id, ia.product_id, ia.quantity_adjusted, t.total_adjusted
FROM ProductTotalAdjusted t
JOIN Inventory_Adjustments ia ON t.product_id = ia.product_id;

-- 5. CTE: Adjustments with notes
WITH NotedAdjustments AS (
    SELECT adjustment_id, notes
    FROM Inventory_Adjustments
    WHERE notes IS NOT NULL
)
SELECT ia.reason, n.notes
FROM NotedAdjustments n
JOIN Inventory_Adjustments ia ON n.adjustment_id = ia.adjustment_id;

-- 6. CTE: Ranked adjustments by date
WITH RankedAdjustments AS (
    SELECT adjustment_id, product_id, adjustment_date,
           RANK() OVER (ORDER BY adjustment_date DESC) AS date_rank
    FROM Inventory_Adjustments
)
SELECT product_id, adjustment_date, date_rank
FROM RankedAdjustments
WHERE date_rank <= 5;

-- 7. Stored Procedure: Update adjustment reason
DELIMITER //
CREATE PROCEDURE UpdateAdjustmentReason(IN adj_id INT, IN new_reason VARCHAR(100))
BEGIN
    UPDATE Inventory_Adjustments SET reason = new_reason WHERE adjustment_id = adj_id;
END //
DELIMITER ;

-- 8. Stored Procedure: Delete old adjustments
DELIMITER //
CREATE PROCEDURE DeleteOldAdjustments()
BEGIN
    DELETE FROM Inventory_Adjustments WHERE adjustment_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END //
DELIMITER ;

-- 9. Stored Procedure: Get adjustments by product
DELIMITER //
CREATE PROCEDURE GetAdjustmentsByProduct(IN prod_id INT)
BEGIN
    SELECT adjustment_id, quantity_adjusted, reason
    FROM Inventory_Adjustments
    WHERE product_id = prod_id;
END //
DELIMITER ;

-- 10. TCL: Update adjustment with rollback
START TRANSACTION;
UPDATE Inventory_Adjustments SET quantity_adjusted = quantity_adjusted - 5 WHERE product_id = 1;
UPDATE Inventory_Adjustments SET notes = 'Updated notes' WHERE product_id = 2;
-- Simulate error
INSERT INTO Inventory_Adjustments (adjustment_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit type update
START TRANSACTION;
UPDATE Inventory_Adjustments SET adjustment_type = 'Gain' WHERE adjustment_id = 3;
SAVEPOINT type_updated;
UPDATE Inventory_Adjustments SET reason = 'New reason' WHERE adjustment_id = 3;
COMMIT;

-- 12. TCL: Rollback quantity update
START TRANSACTION;
UPDATE Inventory_Adjustments SET quantity_adjusted = -10 WHERE adjustment_id = 4;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Inventory_Adjustments TO 'user24'@'localhost';

-- 14. DCL: Grant update permission
GRANT UPDATE ON Inventory_Adjustments TO 'adjustment_manager';

-- 15. Trigger: Log adjustment updates
DELIMITER //
CREATE TRIGGER LogAdjustmentUpdate
AFTER UPDATE ON Inventory_Adjustments
FOR EACH ROW
BEGIN
    IF OLD.quantity_adjusted != NEW.quantity_adjusted THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.adjusted_by, 'Quantity Update', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Adjustment ID: ', NEW.adjustment_id, ' Quantity changed to ', NEW.quantity_adjusted),
                'Inventory_Adjustments', 'Update');
    END IF;
END //
DELIMITER ;

-- 16. Trigger: Prevent invalid type
DELIMITER //
CREATE TRIGGER ValidateAdjustmentType
BEFORE INSERT ON Inventory_Adjustments
FOR EACH ROW
BEGIN
    IF NEW.adjustment_type NOT IN ('Gain', 'Loss') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid adjustment type';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log adjustment approval (proxy)
DELIMITER //
CREATE TRIGGER LogAdjustmentApproval
AFTER UPDATE ON Inventory_Adjustments
FOR EACH ROW
BEGIN
    IF OLD.reason != NEW.reason AND NEW.reason LIKE '%approved%' THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.adjusted_by, 'Adjustment Approval', NOW(), '127.0.0.1', 'Unknown', 'Success',
                CONCAT('Adjustment ID: ', NEW.adjustment_id, ' approved'),
                'Inventory_Adjustments', 'Approval');
    END IF;
END //
DELIMITER ;

-- 18. Window Function: Rank adjustments by quantity
SELECT adjustment_id, product_id, quantity_adjusted,
       RANK() OVER (PARTITION BY product_id ORDER BY quantity_adjusted DESC) AS qty_rank
FROM Inventory_Adjustments;

-- 19. Window Function: Running total adjusted by product
SELECT adjustment_id, product_id, quantity_adjusted,
       SUM(quantity_adjusted) OVER (PARTITION BY product_id ORDER BY adjustment_id) AS running_adjusted
FROM Inventory_Adjustments;

-- 20. Window Function: Adjusted percentage by product
SELECT adjustment_id, product_id, quantity_adjusted,
       quantity_adjusted / SUM(quantity_adjusted) OVER (PARTITION BY product_id) * 100 AS adjusted_percentage
FROM Inventory_Adjustments;


-- Table 25: Notifications
-- 1. View: Recent notifications
CREATE VIEW RecentNotifications AS
SELECT notification_id, notification_type, message
FROM Notifications
WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 2. View: Pending notifications
CREATE VIEW PendingNotifications AS
SELECT notification_id, priority, message
FROM Notifications
WHERE status = 'Pending';

-- 3. View: Notifications by type
CREATE VIEW NotificationsByType AS
SELECT notification_id, notification_type, related_id
FROM Notifications
WHERE notification_type IS NOT NULL;

-- 4. CTE: Notification count by employee
WITH EmployeeNotifCount AS (
    SELECT created_for, COUNT(*) AS notif_count
    FROM Notifications
    GROUP BY created_for
)
SELECT e.employee_name, n.notif_count
FROM EmployeeNotifCount n
JOIN Employees e ON n.created_for = e.employee_id;

-- 5. CTE: Recent messages
WITH RecentMessages AS (
    SELECT notification_id, created_for, message, created_date
    FROM Notifications
    WHERE created_date >= DATE_SUB(CURDATE(), INTERVAL 24 HOUR)
)
SELECT n.notification_id, e.employee_name, n.message
FROM RecentMessages r
JOIN Notifications n ON r.notification_id = n.notification_id
JOIN Employees e ON n.created_for = e.employee_id;

-- 6. CTE: Ranked notifications by priority (assuming numeric)
WITH RankedNotifications AS (
    SELECT notification_id, priority, created_date,
           RANK() OVER (ORDER BY CASE priority WHEN 'High' THEN 3 WHEN 'Medium' THEN 2 ELSE 1 END DESC) AS pri_rank
    FROM Notifications
)
SELECT priority, created_date, pri_rank
FROM RankedNotifications
WHERE pri_rank <= 5;

-- 7. Stored Procedure: Add notification
DELIMITER //
CREATE PROCEDURE AddNotification(IN type VARCHAR(50), IN msg TEXT)
BEGIN
    INSERT INTO Notifications (notification_id, notification_type, message, priority, status, created_for, created_by)
    VALUES ((SELECT COALESCE(MAX(notification_id), 0) + 1 FROM Notifications), type, msg, 'Medium', 'Pending', 1, 1);
END //
DELIMITER ;

-- 8. Stored Procedure: Get notifications by employee
DELIMITER //
CREATE PROCEDURE GetNotificationsByEmployee(IN emp_id INT)
BEGIN
    SELECT notification_id, message, created_date
    FROM Notifications
    WHERE created_for = emp_id;
END //
DELIMITER ;

-- 9. Stored Procedure: Clear resolved notifications
DELIMITER //
CREATE PROCEDURE ClearResolvedNotifications()
BEGIN
    DELETE FROM Notifications WHERE status = 'Resolved';
END //
DELIMITER ;

-- 10. TCL: Update notification with rollback
START TRANSACTION;
UPDATE Notifications SET status = 'Resolved' WHERE notification_id = 1;
UPDATE Notifications SET resolved_date = NOW() WHERE notification_id = 1;
-- Simulate error
INSERT INTO Notifications (notification_id) VALUES (1);
COMMIT;
ROLLBACK;

-- 11. TCL: Commit message update
START TRANSACTION;
UPDATE Notifications SET message = 'Updated message' WHERE notification_id = 2;
SAVEPOINT message_updated;
UPDATE Notifications SET priority = 'High' WHERE notification_id = 2;
COMMIT;

-- 12. TCL: Rollback status update
START TRANSACTION;
UPDATE Notifications SET status = 'Pending' WHERE notification_id = 3;
ROLLBACK;

-- 13. DCL: Grant select permission
GRANT SELECT ON Notifications TO 'user25'@'localhost';

-- 14. DCL: Grant insert permission
GRANT INSERT ON Notifications TO 'notif_admin';

-- 15. Trigger: Log notification insertion
DELIMITER //
CREATE TRIGGER LogNotificationInsertion
AFTER INSERT ON Notifications
FOR EACH ROW
BEGIN
    INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
    VALUES (NEW.created_by, 'Notification Insert', NOW(), '127.0.0.1', 'Unknown', 'Success', 
            CONCAT('Notification ID: ', NEW.notification_id, ' created'),
            'Notifications', 'Meta log');
END //
DELIMITER ;

-- 16. Trigger: Validate notification priority
DELIMITER //
CREATE TRIGGER ValidateNotificationPriority
BEFORE INSERT ON Notifications
FOR EACH ROW
BEGIN
    IF NEW.priority NOT IN ('Low', 'Medium', 'High') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid priority';
    END IF;
END //
DELIMITER ;

-- 17. Trigger: Log notification updates
DELIMITER //
CREATE TRIGGER LogNotificationUpdate
AFTER UPDATE ON Notifications
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO Logs (user_id, action, log_date, ip_address, device_info, status, details, module, notes)
        VALUES (NEW.created_by, 'Notification Update', NOW(), '127.0.0.1', 'Unknown', 'Success', 
                CONCAT('Notification ID: ', NEW.notification_id, ' Status changed to ', NEW.status),
                'Notifications', 'Meta log');
    END IF;
END //
DELIMITER ;

-- 18. Window Function: Rank notifications by date
SELECT notification_id, created_for, created_date,
       RANK() OVER (PARTITION BY created_for ORDER BY created_date DESC) AS date_rank
FROM Notifications;

-- 19. Window Function: Running total notifications by employee
SELECT notification_id, created_for,
       COUNT(*) OVER (PARTITION BY created_for ORDER BY created_date) AS notif_count
FROM Notifications;

-- 20. Window Function: Notification percentage by type
SELECT notification_id, notification_type,
       COUNT(*) OVER (PARTITION BY notification_type) / COUNT(*) OVER () * 100 AS type_percentage
FROM Notifications;
