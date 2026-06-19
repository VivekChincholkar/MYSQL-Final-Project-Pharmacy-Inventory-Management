DROP DATABASE IF EXISTS Pharmacy_Inventory_Management1;

CREATE DATABASE Pharmacy_Inventory_Management1;

USE Pharmacy_Inventory_Management1;

-- ============================================================================
-- TABLE 1: SUPPLIERS (10 Records)
-- ============================================================================
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Suppliers VALUES
(1, 'MediCorp Pharmaceuticals', 'John Smith', '+1-555-0101', 'john@medicorp.com', '123 Medical Ave', 'Boston', 'MA', 'USA', '2024-01-15'),
(2, 'Global Health Supplies', 'Sarah Johnson', '+1-555-0102', 'sarah@globalhealth.com', '456 Health St', 'Chicago', 'IL', 'USA', '2024-01-16'),
(3, 'PharmaTech Solutions', 'Mike Davis', '+1-555-0103', 'mike@pharmatech.com', '789 Tech Blvd', 'San Francisco', 'CA', 'USA', '2024-01-17'),
(4, 'BioMed Distributors', 'Emily Brown', '+1-555-0104', 'emily@biomed.com', '321 Bio Lane', 'New York', 'NY', 'USA', '2024-01-18'),
(5, 'HealthCare Partners', 'David Wilson', '+1-555-0105', 'david@healthcare.com', '654 Care Drive', 'Miami', 'FL', 'USA', '2024-01-19'),
(6, 'Medical Supply Co', 'Lisa Anderson', '+1-555-0106', 'lisa@medsupply.com', '987 Supply Road', 'Seattle', 'WA', 'USA', '2024-01-20'),
(7, 'Pharma Direct', 'James Taylor', '+1-555-0107', 'james@pharmadirect.com', '147 Direct St', 'Denver', 'CO', 'USA', '2024-01-21'),
(8, 'MedSource International', 'Anna Garcia', '+1-555-0108', 'anna@medsource.com', '258 Source Ave', 'Phoenix', 'AZ', 'USA', '2024-01-22'),
(9, 'Healthcare Logistics', 'Robert Miller', '+1-555-0109', 'robert@healthlog.com', '369 Logistics Blvd', 'Atlanta', 'GA', 'USA', '2024-01-23'),
(10, 'Pharmacy Plus', 'Jennifer Lee', '+1-555-0110', 'jennifer@pharmacyplus.com', '741 Plus Street', 'Las Vegas', 'NV', 'USA', '2024-01-24');

-- Retrieve all records from Suppliers
SELECT * FROM Suppliers;

-- Clear all data from Suppliers table
TRUNCATE TABLE Suppliers;

-- Drop Suppliers table if it exists
DROP TABLE IF EXISTS Suppliers;

-- ============================================================================
-- TABLE 2: CATEGORIES (10 Records)
-- ============================================================================
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    notes TEXT,
    sort_order INT DEFAULT 0
);

INSERT INTO Categories VALUES
(1, 'Prescription Medications', 'Medications requiring prescription', NULL, TRUE, 'admin', '2024-01-01', '2024-01-01', 'Main category for Rx drugs', 1),
(2, 'Over-the-Counter', 'Non-prescription medications', NULL, TRUE, 'admin', '2024-01-02', '2024-01-02', 'OTC medications', 2),
(3, 'Antibiotics', 'Bacterial infection treatments', 1, TRUE, 'admin', '2024-01-03', '2024-01-03', 'Prescription antibiotics', 3),
(4, 'Pain Relief', 'Pain management medications', 2, TRUE, 'admin', '2024-01-04', '2024-01-04', 'OTC pain relievers', 4),
(5, 'Cardiovascular', 'Heart and blood pressure medications', 1, TRUE, 'admin', '2024-01-05', '2024-01-05', 'Heart medications', 5),
(6, 'Diabetes', 'Diabetes management supplies', 1, TRUE, 'admin', '2024-01-06', '2024-01-06', 'Diabetic medications', 6),
(7, 'Vitamins', 'Vitamin supplements', 2, TRUE, 'admin', '2024-01-07', '2024-01-07', 'Vitamin supplements', 7),
(8, 'Cold & Flu', 'Cold and flu remedies', 2, TRUE, 'admin', '2024-01-08', '2024-01-08', 'Cold/flu treatments', 8),
(9, 'Dermatology', 'Skin condition treatments', 1, TRUE, 'admin', '2024-01-09', '2024-01-09', 'Skin medications', 9),
(10, 'Respiratory', 'Breathing and lung medications', 1, TRUE, 'admin', '2024-01-10', '2024-01-10', 'Respiratory drugs', 10),
(11, 'Gastrointestinal', 'Digestive system medications', 1, TRUE, 'admin', '2024-01-11', '2024-01-11', 'GI medications', 11),
(12, 'Neurology', 'Nervous system medications', 1, TRUE, 'admin', '2024-01-12', '2024-01-12', 'Neurology medications', 12);

-- Retrieve all records from Categories
SELECT * FROM Categories;

-- Clear all data from Categories table
TRUNCATE TABLE Categories;

-- Drop Categories table if it exists
DROP TABLE IF EXISTS Categories;

-- ============================================================================
-- TABLE 3: MANUFACTURERS (10 Records)
-- ============================================================================
CREATE TABLE Manufacturers (
    manufacturer_id INT PRIMARY KEY AUTO_INCREMENT,
    manufacturer_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100),
    address TEXT,
    country VARCHAR(50),
    license_number VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Manufacturers VALUES
(1, 'Pfizer Inc', 'Dr. Michael Chen', '+1-212-555-0001', 'michael.chen@pfizer.com', 'www.pfizer.com', '235 E 42nd St, New York', 'USA', 'FDA-001-2020', '2024-01-01'),
(2, 'Johnson & Johnson', 'Dr. Sarah Williams', '+1-732-555-0002', 'sarah.williams@jnj.com', 'www.jnj.com', '1 J&J Plaza, New Brunswick', 'USA', 'FDA-002-2020', '2024-01-02'),
(3, 'Merck & Co', 'Dr. David Brown', '+1-908-555-0003', 'david.brown@merck.com', 'www.merck.com', '126 E Lincoln Ave, Rahway', 'USA', 'FDA-003-2020', '2024-01-03'),
(4, 'Abbott Laboratories', 'Dr. Lisa Davis', '+1-847-555-0004', 'lisa.davis@abbott.com', 'www.abbott.com', '100 Abbott Park Rd, Abbott Park', 'USA', 'FDA-004-2020', '2024-01-04'),
(5, 'Novartis', 'Dr. James Wilson', '+41-61-555-0005', 'james.wilson@novartis.com', 'www.novartis.com', 'Lichtstrasse 35, Basel', 'Switzerland', 'EU-005-2020', '2024-01-05'),
(6, 'Roche', 'Dr. Maria Garcia', '+41-61-555-0006', 'maria.garcia@roche.com', 'www.roche.com', 'Grenzacherstrasse 124, Basel', 'Switzerland', 'EU-006-2020', '2024-01-06'),
(7, 'GlaxoSmithKline', 'Dr. Robert Taylor', '+44-20-555-0007', 'robert.taylor@gsk.com', 'www.gsk.com', '980 Great West Rd, Brentford', 'UK', 'EU-007-2020', '2024-01-07'),
(8, 'Sanofi', 'Dr. Anna Martinez', '+33-1-555-0008', 'anna.martinez@sanofi.com', 'www.sanofi.com', '54 rue La Boétie, Paris', 'France', 'EU-008-2020', '2024-01-08'),
(9, 'AstraZeneca', 'Dr. Kevin Anderson', '+44-20-555-0009', 'kevin.anderson@astrazeneca.com', 'www.astrazeneca.com', '1 Francis Crick Ave, Cambridge', 'UK', 'EU-009-2020', '2024-01-09'),
(10, 'Eli Lilly', 'Dr. Jennifer Lee', '+1-317-555-0010', 'jennifer.lee@lilly.com', 'www.lilly.com', 'Lilly Corporate Center, Indianapolis', 'USA', 'FDA-010-2020', '2024-01-10');

-- Retrieve all records from Manufacturers
SELECT * FROM Manufacturers;

-- Clear all data from Manufacturers table
TRUNCATE TABLE Manufacturers;

-- Drop Manufacturers table if it exists
DROP TABLE IF EXISTS Manufacturers;

-- ============================================================================
-- TABLE 4: PRODUCTS (10 Records)
-- ============================================================================
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    generic_name VARCHAR(100),
    manufacturer_id INT,
    category_id INT,
    strength VARCHAR(50),
    dosage_form VARCHAR(50),
    unit_price DECIMAL(10,2),
    barcode VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (manufacturer_id) REFERENCES Manufacturers(manufacturer_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

INSERT INTO Products VALUES
(1, 'Amoxicillin 500mg', 'Amoxicillin', 1, 3, '500mg', 'Capsule', 15.50, '123456789001', '2024-01-01'),
(2, 'Ibuprofen 200mg', 'Ibuprofen', 2, 4, '200mg', 'Tablet', 8.75, '123456789002', '2024-01-02'),
(3, 'Lisinopril 10mg', 'Lisinopril', 3, 5, '10mg', 'Tablet', 12.25, '123456789003', '2024-01-03'),
(4, 'Metformin 500mg', 'Metformin', 4, 6, '500mg', 'Tablet', 9.50, '123456789004', '2024-01-04'),
(5, 'Vitamin D3 1000IU', 'Cholecalciferol', 5, 7, '1000IU', 'Capsule', 6.99, '123456789005', '2024-01-05'),
(6, 'Tylenol Cold & Flu', 'Acetaminophen/Phenylephrine', 6, 8, '325mg/5mg', 'Tablet', 11.25, '123456789006', '2024-01-06'),
(7, 'Hydrocortisone Cream', 'Hydrocortisone', 7, 9, '1%', 'Cream', 7.50, '123456789007', '2024-01-07'),
(8, 'Albuterol Inhaler', 'Albuterol', 8, 10, '90mcg', 'Inhaler', 45.00, '123456789008', '2024-01-08'),
(9, 'Omeprazole 20mg', 'Omeprazole', 9, 11, '20mg', 'Capsule', 18.75, '123456789009', '2024-01-09'),
(10, 'Gabapentin 300mg', 'Gabapentin', 10, 12, '300mg', 'Capsule', 22.50, '123456789010', '2024-01-10');

-- Retrieve all records from Products
SELECT * FROM Products;

-- Clear all data from Products table
TRUNCATE TABLE Products;

-- Drop Products table if it exists
DROP TABLE IF EXISTS Products;

-- ============================================================================
-- TABLE 5: INVENTORY (10 Records)
-- ============================================================================
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    batch_number VARCHAR(50),
    quantity_in_stock INT,
    reorder_level INT,
    maximum_level INT,
    expiry_date DATE,
    cost_price DECIMAL(10,2),
    selling_price DECIMAL(10,2),
    location VARCHAR(100),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Inventory VALUES
(1, 1, 'BATCH001', 250, 50, 500, '2025-12-31', 12.50, 15.50, 'Shelf A1', '2024-01-01'),
(2, 2, 'BATCH002', 180, 30, 300, '2025-11-30', 6.75, 8.75, 'Shelf A2', '2024-01-02'),
(3, 3, 'BATCH003', 320, 40, 400, '2025-10-31', 10.25, 12.25, 'Shelf B1', '2024-01-03'),
(4, 4, 'BATCH004', 420, 60, 600, '2025-09-30', 7.50, 9.50, 'Shelf B2', '2024-01-04'),
(5, 5, 'BATCH005', 150, 25, 250, '2025-08-31', 5.99, 6.99, 'Shelf C1', '2024-01-05'),
(6, 6, 'BATCH006', 200, 35, 350, '2025-07-31', 9.25, 11.25, 'Shelf C2', '2024-01-06'),
(7, 7, 'BATCH007', 80, 15, 150, '2025-06-30', 6.50, 7.50, 'Shelf D1', '2024-01-07'),
(8, 8, 'BATCH008', 45, 10, 100, '2025-05-31', 38.00, 45.00, 'Refrigerator R1', '2024-01-08'),
(9, 9, 'BATCH009', 180, 30, 300, '2025-04-30', 16.75, 18.75, 'Shelf D2', '2024-01-09'),
(10, 10, 'BATCH010', 120, 20, 200, '2025-03-31', 20.50, 22.50, 'Shelf E1', '2024-01-10');

-- Retrieve all records from Inventory
SELECT * FROM Inventory;

-- Clear all data from Inventory table
TRUNCATE TABLE Inventory;

-- Drop Inventory table if it exists
DROP TABLE IF EXISTS Inventory;

-- ============================================================================
-- TABLE 6: CUSTOMERS (10 Records)
-- ============================================================================
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    insurance_provider VARCHAR(100),
    insurance_number VARCHAR(50),
    allergies TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Customers VALUES
(1, 'John Doe', '1985-05-15', 'Male', '+1-555-1001', 'john.doe@email.com', '123 Main St, Anytown', 'BlueCross BlueShield', 'BC123456789', 'Penicillin', '2024-01-01'),
(2, 'Jane Smith', '1990-08-22', 'Female', '+1-555-1002', 'jane.smith@email.com', '456 Oak Ave, Somewhere', 'Aetna', 'AE987654321', 'None', '2024-01-02'),
(3, 'Michael Johnson', '1978-12-10', 'Male', '+1-555-1003', 'michael.j@email.com', '789 Pine St, Elsewhere', 'Cigna', 'CI456789123', 'Aspirin', '2024-01-03'),
(4, 'Sarah Williams', '1992-03-25', 'Female', '+1-555-1004', 'sarah.w@email.com', '321 Elm Dr, Nowhere', 'UnitedHealth', 'UH789123456', 'None', '2024-01-04'),
(5, 'David Brown', '1967-11-08', 'Male', '+1-555-1005', 'david.brown@email.com', '654 Maple Ln, Anywhere', 'Humana', 'HU321654987', 'Sulfa drugs', '2024-01-05'),
(6, 'Emily Davis', '1988-07-14', 'Female', '+1-555-1006', 'emily.davis@email.com', '987 Cedar Ct, Somewhere', 'Kaiser Permanente', 'KP654987321', 'Latex', '2024-01-06'),
(7, 'Robert Wilson', '1975-09-30', 'Male', '+1-555-1007', 'robert.wilson@email.com', '147 Birch St, Anyplace', 'Anthem', 'AN987321654', 'None', '2024-01-07'),
(8, 'Lisa Anderson', '1983-04-18', 'Female', '+1-555-1008', 'lisa.anderson@email.com', '258 Spruce Ave, Elsewhere', 'Medicaid', 'MD123789456', 'Shellfish', '2024-01-08'),
(9, 'James Taylor', '1995-01-12', 'Male', '+1-555-1009', 'james.taylor@email.com', '369 Willow Dr, Nowhere', 'Medicare', 'MC456123789', 'None', '2024-01-09'),
(10, 'Anna Garcia', '1981-06-27', 'Female', '+1-555-1010', 'anna.garcia@email.com', '741 Poplar Ln, Anywhere', 'Tricare', 'TC789456123', 'Codeine', '2024-01-10');

-- Retrieve all records from Customers
SELECT * FROM Customers;

-- Clear all data from Customers table
TRUNCATE TABLE Customers;

-- Drop Customers table if it exists
DROP TABLE IF EXISTS Customers;

-- ============================================================================
-- TABLE 7: PRESCRIPTIONS (10 Records)
-- ============================================================================
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    doctor_name VARCHAR(100),
    doctor_license VARCHAR(50),
    prescription_date DATE,
    status VARCHAR(20),
    total_amount DECIMAL(10,2),
    insurance_covered DECIMAL(10,2),
    patient_copay DECIMAL(10,2),
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Prescriptions VALUES
(1, 1, 'Dr. Sarah Johnson', 'MD123456', '2024-01-15', 'Filled', 45.75, 36.60, 9.15, 'Take with food', '2024-01-15'),
(2, 2, 'Dr. Michael Chen', 'MD234567', '2024-01-16', 'Filled', 23.50, 18.80, 4.70, 'Twice daily', '2024-01-16'),
(3, 3, 'Dr. Emily Davis', 'MD345678', '2024-01-17', 'Pending', 67.25, 53.80, 13.45, 'Monitor blood pressure', '2024-01-17'),
(4, 4, 'Dr. David Wilson', 'MD456789', '2024-01-18', 'Filled', 34.00, 27.20, 6.80, 'With meals', '2024-01-18'),
(5, 5, 'Dr. Lisa Anderson', 'MD567890', '2024-01-19', 'Filled', 19.99, 15.99, 4.00, 'Daily supplement', '2024-01-19'),
(6, 6, 'Dr. James Taylor', 'MD678901', '2024-01-20', 'Filled', 33.75, 27.00, 6.75, 'Complete full course', '2024-01-20'),
(7, 7, 'Dr. Anna Garcia', 'MD789012', '2024-01-21', 'Ready', 22.50, 18.00, 4.50, 'Apply as needed', '2024-01-21'),
(8, 8, 'Dr. Robert Miller', 'MD890123', '2024-01-22', 'Filled', 135.00, 108.00, 27.00, 'Emergency inhaler', '2024-01-22'),
(9, 9, 'Dr. Jennifer Lee', 'MD901234', '2024-01-23', 'Filled', 56.25, 45.00, 11.25, 'Before meals', '2024-01-23'),
(10, 10, 'Dr. Christopher White', 'MD012345', '2024-01-24', 'Pending', 67.50, 54.00, 13.50, 'Gradual dose increase', '2024-01-24');

-- Retrieve all records from Prescriptions
SELECT * FROM Prescriptions;

-- Clear all data from Prescriptions table
TRUNCATE TABLE Prescriptions;

-- Drop Prescriptions table if it exists
DROP TABLE IF EXISTS Prescriptions;

-- ============================================================================
-- TABLE 8: PRESCRIPTION_ITEMS (10 Records)
-- ============================================================================
CREATE TABLE Prescription_Items (
    prescription_item_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    dosage_instructions TEXT,
    days_supply INT,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    refills_remaining INT,
    original_refills INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (prescription_id) REFERENCES Prescriptions(prescription_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Prescription_Items VALUES
(1, 1, 1, 30, 'Take 1 capsule three times daily with food', 10, 15.50, 15.50, 2, 3, '2024-01-15'),
(2, 1, 2, 60, 'Take 1 tablet every 6 hours as needed for pain', 30, 8.75, 17.50, 0, 0, '2024-01-15'),
(3, 2, 3, 30, 'Take 1 tablet daily in the morning', 30, 12.25, 12.25, 5, 6, '2024-01-16'),
(4, 3, 4, 60, 'Take 1 tablet twice daily with meals', 30, 9.50, 19.00, 2, 3, '2024-01-17'),
(5, 4, 5, 30, 'Take 1 capsule daily with breakfast', 30, 6.99, 6.99, 0, 0, '2024-01-18'),
(6, 5, 6, 20, 'Take 2 tablets every 4 hours as needed', 10, 11.25, 22.50, 0, 0, '2024-01-19'),
(7, 6, 7, 1, 'Apply thin layer to affected area twice daily', 14, 7.50, 7.50, 1, 2, '2024-01-20'),
(8, 7, 8, 1, 'Inhale 2 puffs every 4-6 hours as needed', 30, 45.00, 45.00, 5, 6, '2024-01-21'),
(9, 8, 9, 30, 'Take 1 capsule daily before breakfast', 30, 18.75, 18.75, 2, 3, '2024-01-22'),
(10, 9, 10, 90, 'Take 1 capsule three times daily', 30, 22.50, 67.50, 1, 2, '2024-01-23');

-- Retrieve all records from Prescription_Items
SELECT * FROM Prescription_Items;

-- Clear all data from Prescription_Items table
TRUNCATE TABLE Prescription_Items;

-- Drop Prescription_Items table if it exists
DROP TABLE IF EXISTS Prescription_Items;

-- ============================================================================
-- TABLE 9: PURCHASE_ORDERS (10 Records)
-- ============================================================================
CREATE TABLE Purchase_Orders (
    purchase_order_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT NOT NULL,
    order_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    order_status VARCHAR(20),
    total_amount DECIMAL(12,2),
    tax_amount DECIMAL(10,2),
    shipping_cost DECIMAL(10,2),
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

INSERT INTO Purchase_Orders VALUES
(1, 1, '2024-01-10', '2024-01-17', '2024-01-16', 'Delivered', 5250.00, 420.00, 75.00, 'Urgent order for antibiotics', '2024-01-10'),
(2, 2, '2024-01-11', '2024-01-18', '2024-01-18', 'Delivered', 3200.00, 256.00, 50.00, 'Regular monthly order', '2024-01-11'),
(3, 3, '2024-01-12', '2024-01-19', '2024-01-20', 'Delivered', 4800.00, 384.00, 60.00, 'Cardiovascular medications', '2024-01-12'),
(4, 4, '2024-01-13', '2024-01-20', '2024-01-19', 'Delivered', 7500.00, 600.00, 100.00, 'Diabetes supplies', '2024-01-13'),
(5, 5, '2024-01-14', '2024-01-21', '2024-01-22', 'Delivered', 2100.00, 168.00, 35.00, 'Vitamin supplements', '2024-01-14'),
(6, 6, '2024-01-15', '2024-01-22', '2024-01-21', 'Delivered', 3600.00, 288.00, 45.00, 'Cold and flu medications', '2024-01-15'),
(7, 7, '2024-01-16', '2024-01-23', '2024-01-24', 'Delivered', 1800.00, 144.00, 30.00, 'Topical medications', '2024-01-16'),
(8, 8, '2024-01-17', '2024-01-24', '2024-01-23', 'Delivered', 9000.00, 720.00, 120.00, 'Respiratory medications', '2024-01-17'),
(9, 9, '2024-01-18', '2024-01-25', '2024-01-26', 'Delivered', 4200.00, 336.00, 55.00, 'GI medications', '2024-01-18'),
(10, 10, '2024-01-19', '2024-01-26', '2024-01-25', 'Delivered', 6300.00, 504.00, 85.00, 'Neurological drugs', '2024-01-19');

-- Retrieve all records from Purchase_Orders
SELECT * FROM Purchase_Orders;

-- Clear all data from Purchase_Orders table
TRUNCATE TABLE Purchase_Orders;

-- Drop Purchase_Orders table if it exists
DROP TABLE IF EXISTS Purchase_Orders;

-- ============================================================================
-- TABLE 10: PURCHASE_ORDER_ITEMS (10 Records)
-- ============================================================================
CREATE TABLE Purchase_Order_Items (
    purchase_order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity_ordered INT,
    quantity_received INT,
    unit_cost DECIMAL(10,2),
    total_cost DECIMAL(12,2),
    batch_number VARCHAR(50),
    expiry_date DATE,
    received_date DATE,
    notes TEXT,
    FOREIGN KEY (purchase_order_id) REFERENCES Purchase_Orders(purchase_order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Purchase_Order_Items VALUES
(1, 1, 1, 500, 500, 10.50, 5250.00, 'BATCH001', '2025-12-31', '2024-01-16', 'Good condition'),
(2, 2, 2, 400, 400, 8.00, 3200.00, 'BATCH002', '2025-11-30', '2024-01-18', 'All items received'),
(3, 3, 3, 600, 600, 8.00, 4800.00, 'BATCH003', '2025-10-31', '2024-01-20', 'Perfect condition'),
(4, 4, 4, 1000, 1000, 7.50, 7500.00, 'BATCH004', '2025-09-30', '2024-01-19', 'Complete order'),
(5, 5, 5, 350, 350, 6.00, 2100.00, 'BATCH005', '2025-08-31', '2024-01-22', 'No issues'),
(6, 6, 6, 400, 400, 9.00, 3600.00, 'BATCH006', '2025-07-31', '2024-01-21', 'Delivered on time'),
(7, 7, 7, 300, 300, 6.00, 1800.00, 'BATCH007', '2025-06-30', '2024-01-24', 'Good packaging'),
(8, 8, 8, 200, 200, 45.00, 9000.00, 'BATCH008', '2025-05-31', '2024-01-23', 'Cold storage maintained'),
(9, 9, 9, 300, 300, 14.00, 4200.00, 'BATCH009', '2025-04-30', '2024-01-26', 'All good'),
(10, 10, 10, 350, 350, 18.00, 6300.00, 'BATCH010', '2025-03-31', '2024-01-25', 'Excellent quality');

-- Retrieve all records from Purchase_Order_Items
SELECT * FROM Purchase_Order_Items;

-- Clear all data from Purchase_Order_Items table
TRUNCATE TABLE Purchase_Order_Items;

-- Drop Purchase_Order_Items table if it exists
DROP TABLE IF EXISTS Purchase_Order_Items;

-- ============================================================================
-- TABLE 11: SALES (10 Records)
-- ============================================================================
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    sale_date DATE,
    total_amount DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    cashier_id INT,
    receipt_number VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Sales VALUES
(1, 1, '2024-01-15', 45.75, 3.66, 0.00, 'Credit Card', 'Completed', 101, 'RCP001', '2024-01-15'),
(2, 2, '2024-01-16', 23.50, 1.88, 2.35, 'Cash', 'Completed', 102, 'RCP002', '2024-01-16'),
(3, 3, '2024-01-17', 67.25, 5.38, 0.00, 'Insurance', 'Completed', 103, 'RCP003', '2024-01-17'),
(4, 4, '2024-01-18', 34.00, 2.72, 3.40, 'Debit Card', 'Completed', 101, 'RCP004', '2024-01-18'),
(5, 5, '2024-01-19', 19.99, 1.60, 0.00, 'Cash', 'Completed', 102, 'RCP005', '2024-01-19'),
(6, 6, '2024-01-20', 33.75, 2.70, 0.00, 'Credit Card', 'Completed', 103, 'RCP006', '2024-01-20'),
(7, 7, '2024-01-21', 22.50, 1.80, 2.25, 'Cash', 'Completed', 101, 'RCP007', '2024-01-21'),
(8, 8, '2024-01-22', 135.00, 10.80, 0.00, 'Insurance', 'Completed', 102, 'RCP008', '2024-01-22'),
(9, 9, '2024-01-23', 56.25, 4.50, 0.00, 'Credit Card', 'Completed', 103, 'RCP009', '2024-01-23'),
(10, 10, '2024-01-24', 67.50, 5.40, 6.75, 'Debit Card', 'Completed', 101, 'RCP010', '2024-01-24');

-- Retrieve all records from Sales
SELECT * FROM Sales;

-- Clear all data from Sales table
TRUNCATE TABLE Sales;

-- Drop Sales table if it exists
DROP TABLE IF EXISTS Sales;

-- ============================================================================
-- TABLE 12: SALE_ITEMS (10 Records)
-- ============================================================================
CREATE TABLE Sale_Items (
    sale_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    total_price DECIMAL(10,2),
    batch_number VARCHAR(50),
    expiry_date DATE,
    prescription_item_id INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (prescription_item_id) REFERENCES Prescription_Items(prescription_item_id)
);

INSERT INTO Sale_Items VALUES
(1, 1, 1, 30, 15.50, 0.00, 15.50, 'BATCH001', '2025-12-31', 1, '2024-01-15'),
(2, 1, 2, 60, 8.75, 0.00, 17.50, 'BATCH002', '2025-11-30', 2, '2024-01-15'),
(3, 2, 3, 30, 12.25, 2.35, 12.25, 'BATCH003', '2025-10-31', 3, '2024-01-16'),
(4, 3, 4, 60, 9.50, 0.00, 19.00, 'BATCH004', '2025-09-30', 4, '2024-01-17'),
(5, 4, 5, 30, 6.99, 3.40, 6.99, 'BATCH005', '2025-08-31', 5, '2024-01-18'),
(6, 5, 6, 20, 11.25, 0.00, 22.50, 'BATCH006', '2025-07-31', 6, '2024-01-19'),
(7, 6, 7, 1, 7.50, 2.25, 7.50, 'BATCH007', '2025-06-30', 7, '2024-01-20'),
(8, 7, 8, 1, 45.00, 0.00, 45.00, 'BATCH008', '2025-05-31', 8, '2024-01-21'),
(9, 8, 9, 30, 18.75, 0.00, 18.75, 'BATCH009', '2025-04-30', 9, '2024-01-22'),
(10, 9, 10, 90, 22.50, 6.75, 67.50, 'BATCH010', '2025-03-31', 10, '2024-01-23');

-- Retrieve all records from Sale_Items
SELECT * FROM Sale_Items;

-- Clear all data from Sale_Items table
TRUNCATE TABLE Sale_Items;

-- Drop Sale_Items table if it exists
DROP TABLE IF EXISTS Sale_Items;

-- ============================================================================
-- TABLE 13: PAYMENTS (10 Records)
-- ============================================================================
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_type VARCHAR(50) NOT NULL,
    reference_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_method VARCHAR(20),
    transaction_id VARCHAR(50),
    status VARCHAR(20),
    notes TEXT,
    processed_by INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Payments VALUES
(1, 'Expense', 1, '2024-01-05', 1000.00, 'Credit Card', 'CC-001', 'Completed', 'Equipment maintenance', 101, '2024-01-05'),
(2, 'Expense', 2, '2024-01-10', 1500.00, 'Bank Transfer', 'BT-001', 'Completed', 'Logistics payment', 101, '2024-01-10'),
(3, 'Expense', 3, '2024-01-15', 2000.00, 'Check', 'CH-001', 'Completed', 'Medical supplies', 101, '2024-01-15'),
(4, 'Expense', 4, '2024-01-20', 2500.00, 'Credit Card', 'CC-002', 'Completed', 'IT services', 101, '2024-01-20'),
(5, 'Expense', 5, '2024-01-25', 800.00, 'Bank Transfer', 'BT-002', 'Completed', 'Cleaning services', 101, '2024-01-25'),
(6, 'Purchase Order', 1, '2024-01-17', 5250.00, 'Bank Transfer', 'BT-004', 'Completed', 'Supplier payment', 101, '2024-01-17'),
(7, 'Purchase Order', 2, '2024-01-18', 3200.00, 'Check', 'CH-003', 'Completed', 'Supplier payment', 101, '2024-01-18'),
(8, 'Purchase Order', 3, '2024-01-20', 4800.00, 'Bank Transfer', 'BT-005', 'Completed', 'Supplier payment', 101, '2024-01-20'),
(9, 'Purchase Order', 4, '2024-01-19', 7500.00, 'Credit Card', 'CC-004', 'Completed', 'Supplier payment', 101, '2024-01-19'),
(10, 'Salary', 101, '2024-01-31', 7083.33, 'Bank Transfer', 'BT-009', 'Completed', 'Monthly salary', 101, '2024-01-31');

-- Retrieve all records from Payments
SELECT * FROM Payments;

-- Clear all data from Payments table
TRUNCATE TABLE Payments;

-- Drop Payments table if it exists
DROP TABLE IF EXISTS Payments;

-- ============================================================================
-- TABLE 14: DRUG_INTERACTIONS (10 Records)
-- ============================================================================
CREATE TABLE Drug_Interactions (
    interaction_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id1 INT NOT NULL,
    product_id2 INT NOT NULL,
    interaction_type VARCHAR(50),
    severity VARCHAR(20),
    description TEXT,
    management_guidance TEXT,
    reference_source VARCHAR(100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id1) REFERENCES Products(product_id),
    FOREIGN KEY (product_id2) REFERENCES Products(product_id)
);

INSERT INTO Drug_Interactions VALUES
(1, 1, 2, 'Pharmacokinetic', 'Moderate', 'Amoxicillin may decrease the effectiveness of ibuprofen', 'Monitor for reduced pain relief; consider alternative pain reliever', 'Micromedex', '2024-01-01'),
(2, 3, 4, 'Pharmacodynamic', 'Major', 'Lisinopril and metformin may increase risk of lactic acidosis', 'Monitor renal function and electrolytes regularly', 'Lexicomp', '2024-01-02'),
(3, 5, 6, 'Pharmacokinetic', 'Minor', 'Vitamin D may increase absorption of acetaminophen', 'No action needed, but be aware of potential increased effect', 'Clinical Pharmacology', '2024-01-03'),
(4, 7, 8, 'Pharmacodynamic', 'Moderate', 'Hydrocortisone cream may reduce effectiveness of albuterol', 'Space applications by at least 2 hours', 'Drugs.com', '2024-01-04'),
(5, 9, 10, 'Pharmacokinetic', 'Major', 'Omeprazole may decrease gabapentin absorption', 'Administer gabapentin at least 2 hours before omeprazole', 'Micromedex', '2024-01-05'),
(6, 1, 3, 'Pharmacokinetic', 'Moderate', 'Amoxicillin may increase lisinopril effects', 'Monitor blood pressure closely', 'Clinical Pharmacology', '2024-01-06'),
(7, 2, 4, 'Pharmacodynamic', 'Major', 'Ibuprofen may decrease metformin effectiveness', 'Consider alternative pain reliever', 'Drugs.com', '2024-01-07'),
(8, 5, 7, 'Pharmacokinetic', 'Minor', 'Vitamin D may increase hydrocortisone absorption', 'Monitor for increased steroid effects', 'Micromedex', '2024-01-08'),
(9, 6, 8, 'Pharmacodynamic', 'Moderate', 'Tylenol Cold may increase heart rate with albuterol', 'Monitor for tachycardia', 'Lexicomp', '2024-01-09'),
(10, 9, 1, 'Pharmacokinetic', 'Major', 'Omeprazole may increase amoxicillin levels', 'Use lower dose of amoxicillin if needed', 'Clinical Pharmacology', '2024-01-10');

-- Retrieve all records from Drug_Interactions
SELECT * FROM Drug_Interactions;

-- Clear all data from Drug_Interactions table
TRUNCATE TABLE Drug_Interactions;

-- Drop Drug_Interactions table if it exists
DROP TABLE IF EXISTS Drug_Interactions;

-- ============================================================================
-- TABLE 15: INVENTORY_ADJUSTMENTS (10 Records)
-- ============================================================================
CREATE TABLE Inventory_Adjustments (
    adjustment_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    adjustment_date DATE,
    quantity_adjusted INT,
    reason VARCHAR(100),
    adjusted_by INT,
    adjustment_type VARCHAR(20),
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Inventory_Adjustments VALUES
(1, 1, '2024-07-01', -5, 'Damaged stock', 101, 'Loss', 'Broken during transport', '2024-07-01'),
(2, 2, '2024-07-02', 10, 'Found in storage', 102, 'Gain', 'Missed in last count', '2024-07-02'),
(3, 3, '2024-07-03', -2, 'Expired', 103, 'Loss', 'Removed from shelves', '2024-07-03'),
(4, 4, '2024-07-04', -3, 'Theft', 101, 'Loss', 'Reported to security', '2024-07-04'),
(5, 5, '2024-07-05', 8, 'Supplier overdelivery', 102, 'Gain', 'Verified with supplier', '2024-07-05'),
(6, 6, '2024-07-06', -4, 'Recalled', 103, 'Loss', 'Drug recall action', '2024-07-06'),
(7, 7, '2024-07-07', 6, 'Counting error', 101, 'Gain', 'Corrected inventory', '2024-07-07'),
(8, 8, '2024-07-08', -1, 'Sample given', 102, 'Loss', 'Free sample to customer', '2024-07-08'),
(9, 9, '2024-07-09', -7, 'Damaged in store', 103, 'Loss', 'Spilled container', '2024-07-09'),
(10, 10, '2024-07-10', 5, 'Return processed', 101, 'Gain', 'Customer return', '2024-07-10');

-- Retrieve all records from Inventory_Adjustments
SELECT * FROM Inventory_Adjustments;

-- Clear all data from Inventory_Adjustments table
TRUNCATE TABLE Inventory_Adjustments;

-- Drop Inventory_Adjustments table if it exists
DROP TABLE IF EXISTS Inventory_Adjustments;
