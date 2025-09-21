-- Project Phase-2(DDLMLQLC&COp) Pharmacy

-- Table 1: Suppliers Table Queries
-- Query 1: DDL - Add column for supplier status
ALTER TABLE Suppliers
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update supplier_name to uppercase
UPDATE Suppliers
SET supplier_name = UPPER(supplier_name)
WHERE city = 'Boston';

-- Query 3: Operator - Select suppliers from USA
SELECT supplier_name, city
FROM Suppliers
WHERE country = 'USA';

-- Query 4: Operator - Select recent suppliers
SELECT supplier_name, created_date
FROM Suppliers
WHERE created_date > '2024-01-01';

-- Query 5: Function - Count suppliers
SELECT COUNT(*) AS total_suppliers
FROM Suppliers;

-- Query 6: Function - Earliest created date
SELECT MIN(created_date) AS earliest_created
FROM Suppliers;

-- Query 7: Join - Join with Purchase_Orders
SELECT s.supplier_name, p.purchase_order_id
FROM Suppliers s
LEFT JOIN Purchase_Orders p ON s.supplier_id = p.supplier_id;

-- Query 8: Join - Join with Purchase_Order_Items
SELECT s.supplier_name, pi.product_id
FROM Suppliers s
LEFT JOIN Purchase_Orders po ON s.supplier_id = po.supplier_id
LEFT JOIN Purchase_Order_Items pi ON po.purchase_order_id = pi.purchase_order_id;

-- Query 9: Clause with Alias - Group by city
SELECT city AS City, COUNT(*) AS SupplierCount
FROM Suppliers
GROUP BY City;

-- Query 10: Clause with Alias - Order by created date
SELECT supplier_name AS Supplier, created_date AS CreatedDate
FROM Suppliers
ORDER BY CreatedDate DESC;


-- Table 2: Categories Table Queries
-- Query 1: DDL - Add column for category status
ALTER TABLE Categories
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update category_name to uppercase
UPDATE Categories
SET category_name = UPPER(category_name)
WHERE is_active = TRUE;

-- Query 3: Operator - Select active categories
SELECT category_name, description
FROM Categories
WHERE is_active = TRUE;

-- Query 4: Operator - Select top-level categories
SELECT category_name, category_id
FROM Categories
WHERE parent_category_id IS NULL;

-- Query 5: Function - Count categories
SELECT COUNT(*) AS total_categories
FROM Categories;

-- Query 6: Function - Maximum sort order
SELECT MAX(sort_order) AS max_sort_order
FROM Categories;

-- Query 7: Join - Join with Products
SELECT c.category_name, p.product_name
FROM Categories c
LEFT JOIN Products p ON c.category_id = p.category_id;

-- Query 8: Join - Self-join for parent categories
SELECT c.category_name, p.category_name AS parent_name
FROM Categories c
LEFT JOIN Categories p ON c.parent_category_id = p.category_id;

-- Query 9: Clause with Alias - Group by parent category
SELECT parent_category_id AS ParentID, COUNT(*) AS CategoryCount
FROM Categories
GROUP BY ParentID;

-- Query 10: Clause with Alias - Order by sort order
SELECT category_name AS Category, sort_order AS SortOrder
FROM Categories
ORDER BY SortOrder ASC;


-- Table 3: Manufacturers Table Queries
-- Query 1: DDL - Add column for manufacturer status
ALTER TABLE Manufacturers
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update manufacturer_name to uppercase
UPDATE Manufacturers
SET manufacturer_name = UPPER(manufacturer_name)
WHERE country = 'USA';

-- Query 3: Operator - Select manufacturers from USA
SELECT manufacturer_name, country
FROM Manufacturers
WHERE country = 'USA';

-- Query 4: Operator - Select recent manufacturers
SELECT manufacturer_name, created_date
FROM Manufacturers
WHERE created_date > '2024-01-01';

-- Query 5: Function - Count manufacturers
SELECT COUNT(*) AS total_manufacturers
FROM Manufacturers;

-- Query 6: Function - Earliest created date
SELECT MIN(created_date) AS earliest_created
FROM Manufacturers;

-- Query 7: Join - Join with Products
SELECT m.manufacturer_name, p.product_name
FROM Manufacturers m
LEFT JOIN Products p ON m.manufacturer_id = p.manufacturer_id;

-- Query 8: Join - Join with Products (count products)
SELECT m.manufacturer_name, COUNT(p.product_id) AS product_count
FROM Manufacturers m
LEFT JOIN Products p ON m.manufacturer_id = p.manufacturer_id
GROUP BY m.manufacturer_name;

-- Query 9: Clause with Alias - Group by country
SELECT country AS Country, COUNT(*) AS ManufacturerCount
FROM Manufacturers
GROUP BY Country;

-- Query 10: Clause with Alias - Order by created date
SELECT manufacturer_name AS Manufacturer, created_date AS CreatedDate
FROM Manufacturers
ORDER BY CreatedDate DESC;


-- Table 4: Products Table Queries
-- Query 1: DDL - Add column for product status
ALTER TABLE Products
ADD status VARCHAR(20) DEFAULT 'Available';

-- Query 2: DML - Update product_name to uppercase
UPDATE Products
SET product_name = UPPER(product_name)
WHERE unit_price < 10.00;

-- Query 3: Operator - Select low-priced products
SELECT product_name, unit_price
FROM Products
WHERE unit_price < 10.00;

-- Query 4: Operator - Select capsule dosage forms
SELECT product_name, dosage_form
FROM Products
WHERE dosage_form = 'Capsule';

-- Query 5: Function - Average unit price
SELECT AVG(unit_price) AS avg_price
FROM Products;

-- Query 6: Function - Maximum unit price
SELECT MAX(unit_price) AS max_price
FROM Products;

-- Query 7: Join - Join with Manufacturers
SELECT p.product_name, m.manufacturer_name
FROM Products p
LEFT JOIN Manufacturers m ON p.manufacturer_id = m.manufacturer_id;

-- Query 8: Join - Join with Categories
SELECT p.product_name, c.category_name
FROM Products p
LEFT JOIN Categories c ON p.category_id = c.category_id;

-- Query 9: Clause with Alias - Count products by category
SELECT category_id AS CatID, COUNT(*) AS ProductCount
FROM Products
GROUP BY CatID;

-- Query 10: Clause with Alias - Order by unit price
SELECT product_name AS Product, unit_price AS Price
FROM Products
ORDER BY Price DESC;


-- Table 5: Inventory Table Queries
-- Query 1: DDL - Add column for inventory status
ALTER TABLE Inventory
ADD status VARCHAR(20) DEFAULT 'In Stock';

-- Query 2: DML - Update location to uppercase
UPDATE Inventory
SET location = UPPER(location)
WHERE quantity_in_stock < 50;

-- Query 3: Operator - Select low stock items
SELECT product_id, quantity_in_stock
FROM Inventory
WHERE quantity_in_stock < reorder_level;

-- Query 4: Operator - Select items expiring soon
SELECT product_id, expiry_date
FROM Inventory
WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 3 MONTH);

-- Query 5: Function - Total quantity in stock
SELECT SUM(quantity_in_stock) AS total_stock
FROM Inventory;

-- Query 6: Function - Minimum quantity in stock
SELECT MIN(quantity_in_stock) AS min_stock
FROM Inventory;

-- Query 7: Join - Join with Products
SELECT i.quantity_in_stock, p.product_name
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id;

-- Query 8: Join - Join with Products (average price)
SELECT p.product_name, AVG(i.cost_price) AS avg_cost
FROM Inventory i
LEFT JOIN Products p ON i.product_id = p.product_id
GROUP BY p.product_name;

-- Query 9: Clause with Alias - Group by location
SELECT location AS Location, SUM(quantity_in_stock) AS TotalStock
FROM Inventory
GROUP BY Location;

-- Query 10: Clause with Alias - Order by quantity
SELECT product_id AS ProductID, quantity_in_stock AS Stock
FROM Inventory
ORDER BY Stock DESC;


-- Table 6: Customers Table Queries
-- Query 1: DDL - Add column for customer status
ALTER TABLE Customers
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update customer_name to uppercase
UPDATE Customers
SET customer_name = UPPER(customer_name)
WHERE gender = 'Male';

-- Query 3: Operator - Select male customers
SELECT customer_name, gender
FROM Customers
WHERE gender = 'Male';

-- Query 4: Operator - Select customers born after 1990
SELECT customer_name, date_of_birth
FROM Customers
WHERE date_of_birth > '1990-01-01';

-- Query 5: Function - Count customers
SELECT COUNT(*) AS total_customers
FROM Customers;

-- Query 6: Function - Earliest date of birth
SELECT MIN(date_of_birth) AS earliest_birth
FROM Customers;

-- Query 7: Join - Join with Prescriptions
SELECT c.customer_name, p.prescription_id
FROM Customers c
LEFT JOIN Prescriptions p ON c.customer_id = p.customer_id;

-- Query 8: Join - Join with Sales
SELECT c.customer_name, s.sale_id
FROM Customers c
LEFT JOIN Sales s ON c.customer_id = s.customer_id;

-- Query 9: Clause with Alias - Group by insurance provider
SELECT insurance_provider AS Provider, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY Provider;

-- Query 10: Clause with Alias - Order by created date
SELECT customer_name AS Customer, created_date AS CreatedDate
FROM Customers
ORDER BY CreatedDate DESC;


-- Table 7: Prescriptions Table Queries
-- Query 1: DDL - Add column for prescription priority
ALTER TABLE Prescriptions
ADD priority VARCHAR(10) DEFAULT 'Normal';

-- Query 2: DML - Update status to uppercase
UPDATE Prescriptions
SET status = UPPER(status)
WHERE total_amount > 100.00;

-- Query 3: Operator - Select active prescriptions
SELECT prescription_id, status
FROM Prescriptions
WHERE status = 'Active';

-- Query 4: Operator - Select recent prescriptions
SELECT prescription_id, prescription_date
FROM Prescriptions
WHERE prescription_date > '2024-01-01';

-- Query 5: Function - Sum of total amounts
SELECT SUM(total_amount) AS total_prescriptions
FROM Prescriptions;

-- Query 6: Function - Average patient copay
SELECT AVG(patient_copay) AS avg_copay
FROM Prescriptions;

-- Query 7: Join - Join with Customers
SELECT p.prescription_id, c.customer_name
FROM Prescriptions p
LEFT JOIN Customers c ON p.customer_id = c.customer_id;

-- Query 8: Join - Join with Prescription_Items
SELECT p.prescription_id, pi.product_id
FROM Prescriptions p
LEFT JOIN Prescription_Items pi ON p.prescription_id = pi.prescription_id;

-- Query 9: Clause with Alias - Group by status
SELECT status AS PrescriptionStatus, COUNT(*) AS PrescriptionCount
FROM Prescriptions
GROUP BY PrescriptionStatus;

-- Query 10: Clause with Alias - Order by total amount
SELECT prescription_id AS PrescriptionID, total_amount AS Total
FROM Prescriptions
ORDER BY Total DESC;


-- Table 8: Prescription_Items Table Queries
-- Query 1: DDL - Add column for item status
ALTER TABLE Prescription_Items
ADD status VARCHAR(20) DEFAULT 'Filled';

-- Query 2: DML - Update dosage_instructions to uppercase
UPDATE Prescription_Items
SET dosage_instructions = UPPER(dosage_instructions)
WHERE quantity > 10;

-- Query 3: Operator - Select items with refills
SELECT prescription_item_id, refills_remaining
FROM Prescription_Items
WHERE refills_remaining > 0;

-- Query 4: Operator - Select high-quantity items
SELECT prescription_item_id, quantity
FROM Prescription_Items
WHERE quantity > 5;

-- Query 5: Function - Average total price
SELECT AVG(total_price) AS avg_price
FROM Prescription_Items;

-- Query 6: Function - Maximum days supply
SELECT MAX(days_supply) AS max_days
FROM Prescription_Items;

-- Query 7: Join - Join with Prescriptions
SELECT pi.prescription_item_id, p.customer_id
FROM Prescription_Items pi
LEFT JOIN Prescriptions p ON pi.prescription_id = p.prescription_id;

-- Query 8: Join - Join with Products
SELECT pi.quantity, pr.product_name
FROM Prescription_Items pi
LEFT JOIN Products pr ON pi.product_id = pr.product_id;

-- Query 9: Clause with Alias - Group by product
SELECT product_id AS ProductID, SUM(quantity) AS TotalQuantity
FROM Prescription_Items
GROUP BY ProductID;

-- Query 10: Clause with Alias - Order by total price
SELECT prescription_item_id AS ItemID, total_price AS Total
FROM Prescription_Items
ORDER BY Total DESC;


-- Table 9: Purchase_Orders Table Queries
-- Query 1: DDL - Add column for order priority
ALTER TABLE Purchase_Orders
ADD priority VARCHAR(10) DEFAULT 'Normal';

-- Query 2: DML - Update order_status to uppercase
UPDATE Purchase_Orders
SET order_status = UPPER(order_status)
WHERE total_amount > 500.00;

-- Query 3: Operator - Select delivered orders
SELECT purchase_order_id, order_status
FROM Purchase_Orders
WHERE order_status = 'Delivered';

-- Query 4: Operator - Select recent orders
SELECT purchase_order_id, order_date
FROM Purchase_Orders
WHERE order_date > '2024-01-01';

-- Query 5: Function - Sum of total amounts
SELECT SUM(total_amount) AS total_purchases
FROM Purchase_Orders;

-- Query 6: Function - Average tax amount
SELECT AVG(tax_amount) AS avg_tax
FROM Purchase_Orders;

-- Query 7: Join - Join with Suppliers
SELECT po.purchase_order_id, s.supplier_name
FROM Purchase_Orders po
LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id;

-- Query 8: Join - Join with Purchase_Order_Items
SELECT po.purchase_order_id, pi.product_id
FROM Purchase_Orders po
LEFT JOIN Purchase_Order_Items pi ON po.purchase_order_id = pi.purchase_order_id;

-- Query 9: Clause with Alias - Group by order status
SELECT order_status AS OrderStatus, COUNT(*) AS OrderCount
FROM Purchase_Orders
GROUP BY OrderStatus;

-- Query 10: Clause with Alias - Order by total amount
SELECT purchase_order_id AS OrderID, total_amount AS Total
FROM Purchase_Orders
ORDER BY Total DESC;


-- Table 10: Purchase_Order_Items Table Queries
-- Query 1: DDL - Add column for item status
ALTER TABLE Purchase_Order_Items
ADD status VARCHAR(20) DEFAULT 'Received';

-- Query 2: DML - Update notes to uppercase
UPDATE Purchase_Order_Items
SET notes = UPPER(notes)
WHERE quantity_received > 50;

-- Query 3: Operator - Select fully received items
SELECT purchase_order_item_id, quantity_received
FROM Purchase_Order_Items
WHERE quantity_received = quantity_ordered;

-- Query 4: Operator - Select items with expiry soon
SELECT purchase_order_item_id, expiry_date
FROM Purchase_Order_Items
WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- Query 5: Function - Sum of total costs
SELECT SUM(total_cost) AS total_costs
FROM Purchase_Order_Items;

-- Query 6: Function - Average unit cost
SELECT AVG(unit_cost) AS avg_cost
FROM Purchase_Order_Items;

-- Query 7: Join - Join with Purchase_Orders
SELECT pi.purchase_order_item_id, po.supplier_id
FROM Purchase_Order_Items pi
LEFT JOIN Purchase_Orders po ON pi.purchase_order_id = po.purchase_order_id;

-- Query 8: Join - Join with Products
SELECT pi.quantity_ordered, p.product_name
FROM Purchase_Order_Items pi
LEFT JOIN Products p ON pi.product_id = p.product_id;

-- Query 9: Clause with Alias - Group by product
SELECT product_id AS ProductID, SUM(quantity_ordered) AS TotalOrdered
FROM Purchase_Order_Items
GROUP BY ProductID;

-- Query 10: Clause with Alias - Order by total cost
SELECT purchase_order_item_id AS ItemID, total_cost AS Total
FROM Purchase_Order_Items
ORDER BY Total DESC;


-- Table 11: Sales Table Queries
-- Query 1: DDL - Add column for sale priority
ALTER TABLE Sales
ADD priority VARCHAR(10) DEFAULT 'Normal';

-- Query 2: DML - Update payment_status to uppercase
UPDATE Sales
SET payment_status = UPPER(payment_status)
WHERE total_amount > 100.00;

-- Query 3: Operator - Select paid sales
SELECT sale_id, payment_status
FROM Sales
WHERE payment_status = 'Paid';

-- Query 4: Operator - Select recent sales
SELECT sale_id, sale_date
FROM Sales
WHERE sale_date > '2024-01-01';

-- Query 5: Function - Sum of total amounts
SELECT SUM(total_amount) AS total_sales
FROM Sales;

-- Query 6: Function - Average discount amount
SELECT AVG(discount_amount) AS avg_discount
FROM Sales;

-- Query 7: Join - Join with Customers
SELECT s.sale_id, c.customer_name
FROM Sales s
LEFT JOIN Customers c ON s.customer_id = c.customer_id;

-- Query 8: Join - Join with Employees (cashier)
SELECT s.sale_id, e.employee_name
FROM Sales s
LEFT JOIN Employees e ON s.cashier_id = e.employee_id;

-- Query 9: Clause with Alias - Group by payment method
SELECT payment_method AS Method, COUNT(*) AS SaleCount
FROM Sales
GROUP BY Method;

-- Query 10: Clause with Alias - Order by total amount
SELECT sale_id AS SaleID, total_amount AS Total
FROM Sales
ORDER BY Total DESC;


-- Table 12: Sale_Items Table Queries
-- Query 1: DDL - Add column for item status
ALTER TABLE Sale_Items
ADD status VARCHAR(20) DEFAULT 'Sold';

-- Query 2: DML - Update batch_number to uppercase
UPDATE Sale_Items
SET batch_number = UPPER(batch_number)
WHERE quantity > 5;

-- Query 3: Operator - Select items with discount
SELECT sale_item_id, discount_amount
FROM Sale_Items
WHERE discount_amount > 0.00;

-- Query 4: Operator - Select items expiring soon
SELECT sale_item_id, expiry_date
FROM Sale_Items
WHERE expiry_date < DATE_ADD(CURDATE(), INTERVAL 3 MONTH);

-- Query 5: Function - Sum of total prices
SELECT SUM(total_price) AS total_prices
FROM Sale_Items;

-- Query 6: Function - Average unit price
SELECT AVG(unit_price) AS avg_price
FROM Sale_Items;

-- Query 7: Join - Join with Sales
SELECT si.sale_item_id, s.customer_id
FROM Sale_Items si
LEFT JOIN Sales s ON si.sale_id = s.sale_id;

-- Query 8: Join - Join with Products
SELECT si.quantity, p.product_name
FROM Sale_Items si
LEFT JOIN Products p ON si.product_id = p.product_id;

-- Query 9: Clause with Alias - Group by product
SELECT product_id AS ProductID, SUM(quantity) AS TotalSold
FROM Sale_Items
GROUP BY ProductID;

-- Query 10: Clause with Alias - Order by total price
SELECT sale_item_id AS ItemID, total_price AS Total
FROM Sale_Items
ORDER BY Total DESC;


-- Table 13: Employees Table Queries
-- Query 1: DDL - Add column for employee status
ALTER TABLE Employees
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update position to uppercase
UPDATE Employees
SET position = UPPER(position)
WHERE salary > 50000.00;

-- Query 3: Operator - Select active employees
SELECT employee_name, position
FROM Employees
WHERE status = 'Active';

-- Query 4: Operator - Select high-salary employees
SELECT employee_name, salary
FROM Employees
WHERE salary > 60000.00;

-- Query 5: Function - Average salary
SELECT AVG(salary) AS avg_salary
FROM Employees;

-- Query 6: Function - Maximum salary
SELECT MAX(salary) AS max_salary
FROM Employees;

-- Query 7: Join - Join with Employee_Shifts
SELECT e.employee_name, es.shift_id
FROM Employees e
LEFT JOIN Employee_Shifts es ON e.employee_id = es.employee_id;

-- Query 8: Join - Join with Sales (cashier)
SELECT e.employee_name, COUNT(s.sale_id) AS sale_count
FROM Employees e
LEFT JOIN Sales s ON e.employee_id = s.cashier_id
GROUP BY e.employee_name;

-- Query 9: Clause with Alias - Group by department
SELECT department AS Dept, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Dept;

-- Query 10: Clause with Alias - Order by hire date
SELECT employee_name AS Name, hire_date AS HireDate
FROM Employees
ORDER BY HireDate ASC;


-- Table 14: Shifts Table Queries
-- Query 1: DDL - Add column for shift status
ALTER TABLE Shifts
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update shift_name to uppercase
UPDATE Shifts
SET shift_name = UPPER(shift_name)
WHERE is_active = TRUE;

-- Query 3: Operator - Select active shifts
SELECT shift_name, start_time
FROM Shifts
WHERE is_active = TRUE;

-- Query 4: Operator - Select morning shifts
SELECT shift_name, start_time
FROM Shifts
WHERE start_time < '12:00:00';

-- Query 5: Function - Average break duration
SELECT AVG(break_duration) AS avg_break
FROM Shifts;

-- Query 6: Function - Maximum hourly rate multiplier
SELECT MAX(hourly_rate_multiplier) AS max_multiplier
FROM Shifts;

-- Query 7: Join - Join with Employee_Shifts
SELECT sh.shift_name, es.employee_id
FROM Shifts sh
LEFT JOIN Employee_Shifts es ON sh.shift_id = es.shift_id;

-- Query 8: Join - Join with Employee_Shifts (count employees)
SELECT sh.shift_name, COUNT(es.employee_shift_id) AS shift_count
FROM Shifts sh
LEFT JOIN Employee_Shifts es ON sh.shift_id = es.shift_id
GROUP BY sh.shift_name;

-- Query 9: Clause with Alias - Group by shift type
SELECT shift_type AS Type, COUNT(*) AS ShiftCount
FROM Shifts
GROUP BY Type;

-- Query 10: Clause with Alias - Order by start time
SELECT shift_name AS Shift, start_time AS StartTime
FROM Shifts
ORDER BY StartTime ASC;


-- Table 15: Employee_Shifts Table Queries
-- Query 1: DDL - Add column for shift notes
ALTER TABLE Employee_Shifts
ADD notes TEXT;

-- Query 2: DML - Update hourly_rate
UPDATE Employee_Shifts
SET hourly_rate = hourly_rate * 1.1
WHERE overtime_minutes > 0;

-- Query 3: Operator - Select shifts with overtime
SELECT employee_shift_id, overtime_minutes
FROM Employee_Shifts
WHERE overtime_minutes > 0;

-- Query 4: Operator - Select long shifts
SELECT employee_shift_id, total_hours
FROM Employee_Shifts
WHERE total_hours > 8;

-- Query 5: Function - Sum of total hours
SELECT SUM(total_hours) AS total_hours_worked
FROM Employee_Shifts;

-- Query 6: Function - Average overtime minutes
SELECT AVG(overtime_minutes) AS avg_overtime
FROM Employee_Shifts;

-- Query 7: Join - Join with Employees
SELECT es.employee_shift_id, e.employee_name
FROM Employee_Shifts es
LEFT JOIN Employees e ON es.employee_id = e.employee_id;

-- Query 8: Join - Join with Shifts
SELECT es.total_hours, sh.shift_name
FROM Employee_Shifts es
LEFT JOIN Shifts sh ON es.shift_id = sh.shift_id;

-- Query 9: Clause with Alias - Group by employee
SELECT employee_id AS EmployeeID, SUM(total_hours) AS TotalHours
FROM Employee_Shifts
GROUP BY EmployeeID;

-- Query 10: Clause with Alias - Order by work date
SELECT employee_shift_id AS ShiftID, work_date AS WorkDate
FROM Employee_Shifts
ORDER BY WorkDate DESC;


-- Table 16: Vendors Table Queries
-- Query 1: DDL - Add column for vendor status
ALTER TABLE Vendors
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update vendor_name to uppercase
UPDATE Vendors
SET vendor_name = UPPER(vendor_name)
WHERE vendor_type = 'Supplier';

-- Query 3: Operator - Select active vendors
SELECT vendor_name, vendor_type
FROM Vendors
WHERE status = 'Active';

-- Query 4: Operator - Select vendors with website
SELECT vendor_name, website
FROM Vendors
WHERE website IS NOT NULL;

-- Query 5: Function - Count vendors
SELECT COUNT(*) AS total_vendors
FROM Vendors;

-- Query 6: Function - Earliest created date
SELECT MIN(created_date) AS earliest_created
FROM Vendors;

-- Query 7: Join - Join with Vendor_Contracts
SELECT v.vendor_name, vc.contract_id
FROM Vendors v
LEFT JOIN Vendor_Contracts vc ON v.vendor_id = vc.vendor_id;

-- Query 8: Join - Join with Expenses
SELECT v.vendor_name, e.expense_id
FROM Vendors v
LEFT JOIN Expenses e ON v.vendor_id = e.vendor_id;

-- Query 9: Clause with Alias - Group by vendor type
SELECT vendor_type AS Type, COUNT(*) AS VendorCount
FROM Vendors
GROUP BY Type;

-- Query 10: Clause with Alias - Order by created date
SELECT vendor_name AS Vendor, created_date AS CreatedDate
FROM Vendors
ORDER BY CreatedDate DESC;


-- Table 17: Vendor_Contracts Table Queries
-- Query 1: DDL - Add column for contract notes
ALTER TABLE Vendor_Contracts
ADD notes TEXT;

-- Query 2: DML - Update contract_status to uppercase
UPDATE Vendor_Contracts
SET contract_status = UPPER(contract_status)
WHERE contract_value > 10000.00;

-- Query 3: Operator - Select active contracts
SELECT contract_id, contract_status
FROM Vendor_Contracts
WHERE contract_status = 'Active';

-- Query 4: Operator - Select expiring contracts
SELECT contract_id, end_date
FROM Vendor_Contracts
WHERE end_date < DATE_ADD(CURDATE(), INTERVAL 3 MONTH);

-- Query 5: Function - Sum of contract values
SELECT SUM(contract_value) AS total_value
FROM Vendor_Contracts;

-- Query 6: Function - Minimum contract value
SELECT MIN(contract_value) AS min_value
FROM Vendor_Contracts;

-- Query 7: Join - Join with Vendors
SELECT vc.contract_id, v.vendor_name
FROM Vendor_Contracts vc
LEFT JOIN Vendors v ON vc.vendor_id = v.vendor_id;

-- Query 8: Join - Join with Vendors (average value)
SELECT v.vendor_name, AVG(vc.contract_value) AS avg_value
FROM Vendor_Contracts vc
LEFT JOIN Vendors v ON vc.vendor_id = v.vendor_id
GROUP BY v.vendor_name;

-- Query 9: Clause with Alias - Group by contract status
SELECT contract_status AS Status, COUNT(*) AS ContractCount
FROM Vendor_Contracts
GROUP BY Status;

-- Query 10: Clause with Alias - Order by start date
SELECT contract_id AS ContractID, start_date AS StartDate
FROM Vendor_Contracts
ORDER BY StartDate DESC;


-- Table 18: Expenses Table Queries
-- Query 1: DDL - Add column for expense status
ALTER TABLE Expenses
ADD expense_status VARCHAR(20) DEFAULT 'Approved';

-- Query 2: DML - Update expense_type to uppercase
UPDATE Expenses
SET expense_type = UPPER(expense_type)
WHERE amount > 500.00;

-- Query 3: Operator - Select approved expenses
SELECT expense_id, status
FROM Expenses
WHERE status = 'Approved';

-- Query 4: Operator - Select recent expenses
SELECT expense_id, expense_date
FROM Expenses
WHERE expense_date > '2024-01-01';

-- Query 5: Function - Sum of amounts
SELECT SUM(amount) AS total_expenses
FROM Expenses;

-- Query 6: Function - Average amount
SELECT AVG(amount) AS avg_amount
FROM Expenses;

-- Query 7: Join - Join with Vendors
SELECT e.expense_id, v.vendor_name
FROM Expenses e
LEFT JOIN Vendors v ON e.vendor_id = v.vendor_id;

-- Query 8: Join - Join with Employees (approved_by)
SELECT e.amount, emp.employee_name
FROM Expenses e
LEFT JOIN Employees emp ON e.approved_by = emp.employee_id;

-- Query 9: Clause with Alias - Group by expense type
SELECT expense_type AS Type, SUM(amount) AS TotalAmount
FROM Expenses
GROUP BY Type;

-- Query 10: Clause with Alias - Order by expense date
SELECT expense_id AS ExpenseID, expense_date AS ExpDate
FROM Expenses
ORDER BY ExpDate DESC;


-- Table 19: Payments Table Queries
-- Query 1: DDL - Add column for payment notes
ALTER TABLE Payments
ADD notes TEXT;

-- Query 2: DML - Update payment_type to uppercase
UPDATE Payments
SET payment_type = UPPER(payment_type)
WHERE amount > 200.00;

-- Query 3: Operator - Select successful payments
SELECT payment_id, status
FROM Payments
WHERE status = 'Success';

-- Query 4: Operator - Select high-amount payments
SELECT payment_id, amount
FROM Payments
WHERE amount > 500.00;

-- Query 5: Function - Sum of amounts
SELECT SUM(amount) AS total_payments
FROM Payments;

-- Query 6: Function - Minimum amount
SELECT MIN(amount) AS min_amount
FROM Payments;

-- Query 7: Join - Join with Employees (processed_by)
SELECT p.payment_id, e.employee_name
FROM Payments p
LEFT JOIN Employees e ON p.processed_by = e.employee_id;

-- Query 8: Join - Join with Sales (if reference_id is sale)
SELECT p.amount, s.sale_date
FROM Payments p
LEFT JOIN Sales s ON p.reference_id = s.sale_id;

-- Query 9: Clause with Alias - Group by payment method
SELECT payment_method AS Method, COUNT(*) AS PaymentCount
FROM Payments
GROUP BY Method;

-- Query 10: Clause with Alias - Order by payment date
SELECT payment_id AS PaymentID, payment_date AS PayDate
FROM Payments
ORDER BY PayDate DESC;


-- Table 20: Insurance_Providers Table Queries
-- Query 1: DDL - Add column for provider status
ALTER TABLE Insurance_Providers
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update provider_name to uppercase
UPDATE Insurance_Providers
SET provider_name = UPPER(provider_name)
WHERE discount_percentage > 10.00;

-- Query 3: Operator - Select active providers
SELECT provider_name, contract_start_date
FROM Insurance_Providers
WHERE status = 'Active';

-- Query 4: Operator - Select high-discount providers
SELECT provider_name, discount_percentage
FROM Insurance_Providers
WHERE discount_percentage > 15.00;

-- Query 5: Function - Average discount percentage
SELECT AVG(discount_percentage) AS avg_discount
FROM Insurance_Providers;

-- Query 6: Function - Maximum claim processing days
SELECT MAX(claim_processing_days) AS max_days
FROM Insurance_Providers;

-- Query 7: Join - Join with Insurance_Claims
SELECT ip.provider_name, ic.claim_id
FROM Insurance_Providers ip
LEFT JOIN Insurance_Claims ic ON ip.provider_id = ic.provider_id;

-- Query 8: Join - Join with Customers
SELECT ip.provider_name, c.customer_name
FROM Insurance_Providers ip
LEFT JOIN Customers c ON ip.provider_name = c.insurance_provider;

-- Query 9: Clause with Alias - Group by country (assuming address implies)
SELECT SUBSTRING_INDEX(address, ',', -1) AS Country, COUNT(*) AS ProviderCount
FROM Insurance_Providers
GROUP BY Country;

-- Query 10: Clause with Alias - Order by contract start date
SELECT provider_name AS Provider, contract_start_date AS StartDate
FROM Insurance_Providers
ORDER BY StartDate DESC;


-- Table 21: Insurance_Claims Table Queries
-- Query 1: DDL - Add column for claim priority
ALTER TABLE Insurance_Claims
ADD priority VARCHAR(10) DEFAULT 'Normal';

-- Query 2: DML - Update status to uppercase
UPDATE Insurance_Claims
SET status = UPPER(status)
WHERE claim_amount > 100.00;

-- Query 3: Operator - Select paid claims
SELECT claim_id, status
FROM Insurance_Claims
WHERE status = 'Paid';

-- Query 4: Operator - Select high-amount claims
SELECT claim_id, claim_amount
FROM Insurance_Claims
WHERE claim_amount > 500.00;

-- Query 5: Function - Sum of covered amounts
SELECT SUM(covered_amount) AS total_covered
FROM Insurance_Claims;

-- Query 6: Function - Average claim amount
SELECT AVG(claim_amount) AS avg_claim
FROM Insurance_Claims;

-- Query 7: Join - Join with Insurance_Providers
SELECT ic.claim_id, ip.provider_name
FROM Insurance_Claims ic
LEFT JOIN Insurance_Providers ip ON ic.provider_id = ip.provider_id;

-- Query 8: Join - Join with Prescriptions
SELECT ic.claim_amount, p.customer_id
FROM Insurance_Claims ic
LEFT JOIN Prescriptions p ON ic.prescription_id = p.prescription_id;

-- Query 9: Clause with Alias - Group by status
SELECT status AS ClaimStatus, COUNT(*) AS ClaimCount
FROM Insurance_Claims
GROUP BY ClaimStatus;

-- Query 10: Clause with Alias - Order by claim date
SELECT claim_id AS ClaimID, claim_date AS ClaimDate
FROM Insurance_Claims
ORDER BY ClaimDate DESC;


-- Table 22: Patient_Medical_History Table Queries
-- Query 1: DDL - Add column for history status
ALTER TABLE Patient_Medical_History
ADD status VARCHAR(20) DEFAULT 'Current';

-- Query 2: DML - Update condition_name to uppercase
UPDATE Patient_Medical_History
SET condition_name = UPPER(condition_name)
WHERE severity = 'Moderate';

-- Query 3: Operator - Select controlled conditions
SELECT condition_name, current_status
FROM Patient_Medical_History
WHERE current_status = 'Controlled';

-- Query 4: Operator - Select recent diagnoses
SELECT condition_name, diagnosis_date
FROM Patient_Medical_History
WHERE diagnosis_date > '2020-01-01';

-- Query 5: Function - Count histories
SELECT COUNT(*) AS total_histories
FROM Patient_Medical_History;

-- Query 6: Function - Earliest diagnosis date
SELECT MIN(diagnosis_date) AS earliest_diagnosis
FROM Patient_Medical_History;

-- Query 7: Join - Join with Customers
SELECT pmh.condition_name, c.customer_name
FROM Patient_Medical_History pmh
LEFT JOIN Customers c ON pmh.customer_id = c.customer_id;

-- Query 8: Join - Join with Prescriptions
SELECT pmh.condition_name, p.prescription_id
FROM Patient_Medical_History pmh
LEFT JOIN Prescriptions p ON pmh.customer_id = p.customer_id;

-- Query 9: Clause with Alias - Group by severity
SELECT severity AS SeverityLevel, COUNT(*) AS HistoryCount
FROM Patient_Medical_History
GROUP BY SeverityLevel;

-- Query 10: Clause with Alias - Order by diagnosis date
SELECT diagnosis_date AS DiagnosisDate
FROM Patient_Medical_History
ORDER BY DiagnosisDate DESC;

-- Table 23: Drug_Interactions Table Queries
-- Query 1: DDL - Add column for interaction status
ALTER TABLE Drug_Interactions
ADD status VARCHAR(20) DEFAULT 'Active';

-- Query 2: DML - Update interaction_type to uppercase
UPDATE Drug_Interactions
SET interaction_type = UPPER(interaction_type)
WHERE severity = 'Major';

-- Query 3: Operator - Select major interactions
SELECT interaction_id, severity
FROM Drug_Interactions
WHERE severity = 'Major';

-- Query 4: Operator - Select pharmacokinetic interactions
SELECT interaction_id, interaction_type
FROM Drug_Interactions
WHERE interaction_type = 'Pharmacokinetic';

-- Query 5: Function - Count interactions
SELECT COUNT(*) AS total_interactions
FROM Drug_Interactions;

-- Query 6: Function - Earliest created date
SELECT MIN(created_date) AS earliest_created
FROM Drug_Interactions;

-- Query 7: Join - Join with Products (product1)
SELECT di.interaction_id, p1.product_name
FROM Drug_Interactions di
LEFT JOIN Products p1 ON di.product_id1 = p1.product_id;

-- Query 8: Join - Join with Products (product2)
SELECT di.severity, p2.product_name
FROM Drug_Interactions di
LEFT JOIN Products p2 ON di.product_id2 = p2.product_id;

-- Query 9: Clause with Alias - Group by severity
SELECT severity AS SeverityLevel, COUNT(*) AS InteractionCount
FROM Drug_Interactions
GROUP BY SeverityLevel;

-- Query 10: Clause with Alias - Order by created date
SELECT interaction_id AS InteractionID, created_date AS CreatedDate
FROM Drug_Interactions
ORDER BY CreatedDate DESC;


-- Table 24: Inventory_Adjustments Table Queries
-- Query 1: DDL - Add column for adjustment status
ALTER TABLE Inventory_Adjustments
ADD status VARCHAR(20) DEFAULT 'Processed';

-- Query 2: DML - Update reason to uppercase
UPDATE Inventory_Adjustments
SET reason = UPPER(reason)
WHERE quantity_adjusted < 0;

-- Query 3: Operator - Select loss adjustments
SELECT adjustment_id, adjustment_type
FROM Inventory_Adjustments
WHERE adjustment_type = 'Loss';

-- Query 4: Operator - Select recent adjustments
SELECT adjustment_id, adjustment_date
FROM Inventory_Adjustments
WHERE adjustment_date > '2024-01-01';

-- Query 5: Function - Sum of quantity adjusted
SELECT SUM(quantity_adjusted) AS total_adjusted
FROM Inventory_Adjustments;

-- Query 6: Function - Minimum quantity adjusted
SELECT MIN(quantity_adjusted) AS min_adjusted
FROM Inventory_Adjustments;

-- Query 7: Join - Join with Products
SELECT ia.quantity_adjusted, p.product_name
FROM Inventory_Adjustments ia
LEFT JOIN Products p ON ia.product_id = p.product_id;

-- Query 8: Join - Join with Employees
SELECT ia.adjustment_id, e.employee_name
FROM Inventory_Adjustments ia
LEFT JOIN Employees e ON ia.adjusted_by = e.employee_id;

-- Query 9: Clause with Alias - Group by adjustment type
SELECT adjustment_type AS Type, COUNT(*) AS AdjustmentCount
FROM Inventory_Adjustments
GROUP BY Type;

-- Query 10: Clause with Alias - Order by adjustment date
SELECT adjustment_id AS AdjustmentID, adjustment_date AS AdjDate
FROM Inventory_Adjustments
ORDER BY AdjDate DESC;


-- Table 25: Notifications Table Queries
-- Query 1: DDL - Add column for notification urgency
ALTER TABLE Notifications
ADD urgency VARCHAR(10) DEFAULT 'Normal';

-- Query 2: DML - Update notification_type to uppercase
UPDATE Notifications
SET notification_type = UPPER(notification_type)
WHERE priority = 'High';

-- Query 3: Operator - Select high priority notifications
SELECT notification_id, priority
FROM Notifications
WHERE priority = 'High';

-- Query 4: Operator - Select pending notifications
SELECT notification_id, status
FROM Notifications
WHERE status = 'Pending';

-- Query 5: Function - Count notifications
SELECT COUNT(*) AS total_notifications
FROM Notifications;

-- Query 6: Function - Earliest created date
SELECT MIN(created_date) AS earliest_created
FROM Notifications;

-- Query 7: Join - Join with Employees (created_for)
SELECT n.message, e1.employee_name
FROM Notifications n
LEFT JOIN Employees e1 ON n.created_for = e1.employee_id;

-- Query 8: Join - Join with Employees (created_by)
SELECT n.notification_type, e2.employee_name
FROM Notifications n
LEFT JOIN Employees e2 ON n.created_by = e2.employee_id;

-- Query 9: Clause with Alias - Group by notification type
SELECT notification_type AS Type, COUNT(*) AS NotificationCount
FROM Notifications
GROUP BY Type;

-- Query 10: Clause with Alias - Order by created date
SELECT notification_id AS NotificationID, created_date AS CreatedDate
FROM Notifications
ORDER BY CreatedDate DESC;
