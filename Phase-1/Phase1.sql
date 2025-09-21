-- Creating the pharmacy inventory management  
CREATE DATABASE Pharmacy_Inventory_Management;

USE Pharmacy_Inventory_Management;

-- Drop the database if it already exists  
DROP DATABASE IF EXISTS Pharmacy_Inventory_Management;

-- ------------------------------------------------------------------------------------- Database Analysis----------------------------------------------------
/*
T1  : Suppliers(supplier_id, supplier_name, contact_person, phone, email, address, city, state, country, created_date)

T2  : Categories(category_id, category_name, description, parent_category_id, is_active, created_by, created_date, updated_date, notes, sort_order)

T3  : Manufacturers(manufacturer_id, manufacturer_name, contact_person, phone, email, website, address, country, license_number, created_date)

T4  : Products(product_id, product_name, generic_name, manufacturer_id, category_id, strength, dosage_form, unit_price, barcode, created_date)

T5  : Inventory(inventory_id, product_id, batch_number, quantity_in_stock, reorder_level, maximum_level, expiry_date, cost_price, selling_price, location, last_updated)

T6  : Customers(customer_id, customer_name, date_of_birth, gender, phone, email, address, insurance_provider, insurance_number, allergies, created_date)

T7  : Prescriptions(prescription_id, customer_id, doctor_name, doctor_license, prescription_date, status, total_amount, insurance_covered, patient_copay, notes, created_date)

T8  : Prescription_Items(prescription_item_id, prescription_id, product_id, quantity, dosage_instructions, days_supply, unit_price, total_price, refills_remaining, original_refills, created_date)

T9  : Purchase_Orders(purchase_order_id, supplier_id, order_date, expected_delivery_date, actual_delivery_date, order_status, total_amount, tax_amount, shipping_cost, notes, created_date)

T10 : Purchase_Order_Items(purchase_order_item_id, purchase_order_id, product_id, quantity_ordered, quantity_received, unit_cost, total_cost, batch_number, expiry_date, received_date, notes)

T11 : Sales(sale_id, customer_id, sale_date, total_amount, tax_amount, discount_amount, payment_method, payment_status, cashier_id, receipt_number, created_date)

T12 : Sale_Items(sale_item_id, sale_id, product_id, quantity, unit_price, discount_amount, total_price, batch_number, expiry_date, prescription_item_id, created_date)

T13 : Employees(employee_id, employee_name, position, department, hire_date, salary, phone, email, address, emergency_contact, created_date)

T14 : Shifts(shift_id, shift_name, start_time, end_time, break_duration, shift_type, hourly_rate_multiplier, is_active, created_by, notes, created_date)

T15 : Employee_Shifts(employee_shift_id, employee_id, shift_id, work_date, actual_start_time, actual_end_time, break_minutes, overtime_minutes, hourly_rate, total_hours, created_date)

T16 : Vendors(vendor_id, vendor_name, vendor_type, contact_person, phone, email, website, address, payment_terms, tax_id, created_date)

T17 : Vendor_Contracts(contract_id, vendor_id, contract_name, start_date, end_date, contract_value, payment_terms, renewal_terms, termination_clause, contract_status, created_date)

T18 : Expenses(expense_id, expense_type, vendor_id, expense_date, amount, payment_method, description, reference_number, status, approved_by, created_date)

T19 : Payments(payment_id, payment_type, reference_id, payment_date, amount, payment_method, transaction_id, status, notes, processed_by, created_date)

T20 : Insurance_Providers(provider_id, provider_name, contact_person, phone, email, address, contract_start_date, contract_end_date, discount_percentage, claim_processing_days, created_date)

T21 : Insurance_Claims(claim_id, prescription_id, provider_id, claim_date, claim_amount, covered_amount, status, processed_date, rejection_reason, notes, created_date)

T22 : Patient_Medical_History(history_id, customer_id, condition_name, diagnosis_date, severity, current_status, treatment_description, doctor_name, doctor_contact, notes, created_date)

T23 : Drug_Interactions(interaction_id, product_id1, product_id2, interaction_type, severity, description, management_guidance, reference_source, created_date)

T24 : Inventory_Adjustments(adjustment_id, product_id, adjustment_date, quantity_adjusted, reason, adjusted_by, adjustment_type, notes, created_date)

T25 : Notifications(notification_id, notification_type, related_id, message, priority, status, created_for, created_by, created_date, resolved_date)
*/

-- TABLE 1: SUPPLIERS
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

-- Insert sample records
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
(10, 'Pharmacy Plus', 'Jennifer Lee', '+1-555-0110', 'jennifer@pharmacyplus.com', '741 Plus Street', 'Las Vegas', 'NV', 'USA', '2024-01-24'),
(11, 'MedTech Innovations', 'Chris White', '+1-555-0111', 'chris@medtech.com', '852 Innovation Way', 'Portland', 'OR', 'USA', '2024-01-25'),
(12, 'BioSupply Chain', 'Michelle Clark', '+1-555-0112', 'michelle@biosupply.com', '963 Chain Road', 'Austin', 'TX', 'USA', '2024-01-26'),
(13, 'Wellness Distributors', 'Kevin Rodriguez', '+1-555-0113', 'kevin@wellness.com', '174 Wellness Ave', 'Minneapolis', 'MN', 'USA', '2024-01-27'),
(14, 'PharmaCare Solutions', 'Amanda Martinez', '+1-555-0114', 'amanda@pharmacare.com', '285 Care Circle', 'San Diego', 'CA', 'USA', '2024-01-28'),
(15, 'Health Direct', 'Steven Thomas', '+1-555-0115', 'steven@healthdirect.com', '396 Direct Drive', 'Detroit', 'MI', 'USA', '2024-01-29'),
(16, 'Medical Express', 'Rachel Harris', '+1-555-0116', 'rachel@medexpress.com', '507 Express Lane', 'Tampa', 'FL', 'USA', '2024-01-30'),
(17, 'BioPharm Networks', 'Daniel Lewis', '+1-555-0117', 'daniel@biopharm.com', '618 Network St', 'Nashville', 'TN', 'USA', '2024-01-31'),
(18, 'Pharmacy Connections', 'Laura Young', '+1-555-0118', 'laura@pharmaconnect.com', '729 Connect Ave', 'Cleveland', 'OH', 'USA', '2024-02-01'),
(19, 'MedLink Systems', 'Brian Walker', '+1-555-0119', 'brian@medlink.com', '840 Link Road', 'Salt Lake City', 'UT', 'USA', '2024-02-02'),
(20, 'Healthcare Hub', 'Nicole Green', '+1-555-0120', 'nicole@healthhub.com', '951 Hub Boulevard', 'Kansas City', 'MO', 'USA', '2024-02-03');


-- Retrieve all records from Suppliers
SELECT * FROM Suppliers;

-- Clear all data from Suppliers table
TRUNCATE TABLE Suppliers;

-- Drop Suppliers table if it exists
DROP TABLE IF EXISTS Suppliers;

-- TABLE 2: CATEGORIES
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

-- Insert sample records
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
(12, 'Neurological', 'Brain and nervous system drugs', 1, TRUE, 'admin', '2024-01-12', '2024-01-12', 'Neuro medications', 12),
(13, 'Pediatric', 'Children specific medications', NULL, TRUE, 'admin', '2024-01-13', '2024-01-13', 'Kids medications', 13),
(14, 'Oncology', 'Cancer treatment medications', 1, TRUE, 'admin', '2024-01-14', '2024-01-14', 'Cancer drugs', 14),
(15, 'Psychiatric', 'Mental health medications', 1, TRUE, 'admin', '2024-01-15', '2024-01-15', 'Psychiatric drugs', 15),
(16, 'Immunology', 'Immune system medications', 1, TRUE, 'admin', '2024-01-16', '2024-01-16', 'Immune drugs', 16),
(17, 'Ophthalmology', 'Eye care medications', 1, TRUE, 'admin', '2024-01-17', '2024-01-17', 'Eye medications', 17),
(18, 'Orthopedic', 'Bone and joint medications', 1, TRUE, 'admin', '2024-01-18', '2024-01-18', 'Bone medications', 18),
(19, 'Hormonal', 'Hormone related medications', 1, TRUE, 'admin', '2024-01-19', '2024-01-19', 'Hormone drugs', 19),
(20, 'Emergency', 'Emergency medications', 1, TRUE, 'admin', '2024-01-20', '2024-01-20', 'Emergency drugs', 20);


-- Retrieve all records from Categories
SELECT * FROM Categories;

-- Clear all data from Categories table
TRUNCATE TABLE Categories;

-- Drop Categories table if it exists
DROP TABLE IF EXISTS Categories;

-- TABLE 3: MANUFACTURERS
create table Manufacturers (
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

-- Insert sample records
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
(10, 'Eli Lilly', 'Dr. Jennifer Lee', '+1-317-555-0010', 'jennifer.lee@lilly.com', 'www.lilly.com', 'Lilly Corporate Center, Indianapolis', 'USA', 'FDA-010-2020', '2024-01-10'),
(11, 'Bristol Myers Squibb', 'Dr. Chris White', '+1-609-555-0011', 'chris.white@bms.com', 'www.bms.com', '430 E 29th St, New York', 'USA', 'FDA-011-2020', '2024-01-11'),
(12, 'Amgen', 'Dr. Michelle Clark', '+1-805-555-0012', 'michelle.clark@amgen.com', 'www.amgen.com', '1 Amgen Center Dr, Thousand Oaks', 'USA', 'FDA-012-2020', '2024-01-12'),
(13, 'Gilead Sciences', 'Dr. Steven Rodriguez', '+1-650-555-0013', 'steven.rodriguez@gilead.com', 'www.gilead.com', '333 Lakeside Dr, Foster City', 'USA', 'FDA-013-2020', '2024-01-13'),
(14, 'Biogen', 'Dr. Amanda Thomas', '+1-617-555-0014', 'amanda.thomas@biogen.com', 'www.biogen.com', '225 Binney St, Cambridge', 'USA', 'FDA-014-2020', '2024-01-14'),
(15, 'Regeneron', 'Dr. Daniel Harris', '+1-914-555-0015', 'daniel.harris@regeneron.com', 'www.regeneron.com', '777 Old Saw Mill River Rd, Tarrytown', 'USA', 'FDA-015-2020', '2024-01-15'),
(16, 'Moderna', 'Dr. Laura Lewis', '+1-617-555-0016', 'laura.lewis@moderna.com', 'www.moderna.com', '200 Technology Square, Cambridge', 'USA', 'FDA-016-2020', '2024-01-16'),
(17, 'Vertex Pharmaceuticals', 'Dr. Brian Young', '+1-617-555-0017', 'brian.young@vertex.com', 'www.vertex.com', '50 Northern Ave, Boston', 'USA', 'FDA-017-2020', '2024-01-17'),
(18, 'Celgene', 'Dr. Nicole Walker', '+1-908-555-0018', 'nicole.walker@celgene.com', 'www.celgene.com', '86 Morris Ave, Summit', 'USA', 'FDA-018-2020', '2024-01-18'),
(19, 'Teva Pharmaceutical', 'Dr. Mark Green', '+972-3-555-0019', 'mark.green@teva.com', 'www.teva.com', '5 Basel St, Petah Tikva', 'Israel', 'FDA-019-2020', '2024-01-19'),
(20, 'Mylan', 'Dr. Patricia Hall', '+1-724-555-0020', 'patricia.hall@mylan.com', 'www.mylan.com', '1000 Mylan Blvd, Canonsburg', 'USA', 'FDA-020-2020', '2024-01-20');


-- Retrieve all records from Manufacturers
SELECT * FROM Manufacturers;

-- Clear all data from Manufacturers table
TRUNCATE TABLE Manufacturers;

-- Drop Manufacturers table if it exists
DROP TABLE IF EXISTS Manufacturers;


-- TABLE 4: PRODUCTS
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
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Insert sample records
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
(10, 'Gabapentin 300mg', 'Gabapentin', 10, 12, '300mg', 'Capsule', 22.50, '123456789010', '2024-01-10'),
(11, 'Children Tylenol', 'Acetaminophen', 11, 13, '160mg/5ml', 'Liquid', 8.99, '123456789011', '2024-01-11'),
(12, 'Tamoxifen 20mg', 'Tamoxifen', 12, 14, '20mg', 'Tablet', 125.00, '123456789012', '2024-01-12'),
(13, 'Sertraline 50mg', 'Sertraline', 13, 15, '50mg', 'Tablet', 28.75, '123456789013', '2024-01-13'),
(14, 'Prednisone 10mg', 'Prednisone', 14, 16, '10mg', 'Tablet', 14.25, '123456789014', '2024-01-14'),
(15, 'Latanoprost Eye Drops', 'Latanoprost', 15, 17, '0.005%', 'Drops', 85.00, '123456789015', '2024-01-15'),
(16, 'Celecoxib 200mg', 'Celecoxib', 16, 18, '200mg', 'Capsule', 35.50, '123456789016', '2024-01-16'),
(17, 'Levothyroxine 50mcg', 'Levothyroxine', 17, 19, '50mcg', 'Tablet', 13.75, '123456789017', '2024-01-17'),
(18, 'Epinephrine Auto-injector', 'Epinephrine', 18, 20, '0.3mg', 'Injector', 650.00, '123456789018', '2024-01-18'),
(19, 'Azithromycin 250mg', 'Azithromycin', 19, 3, '250mg', 'Tablet', 32.50, '123456789019', '2024-01-19'),
(20, 'Aspirin 81mg', 'Aspirin', 20, 4, '81mg', 'Tablet', 5.25, '123456789020', '2024-01-20');

-- Retrieve all records from Products
SELECT * FROM Products;

-- Clear all data from Products table
TRUNCATE TABLE Products;

-- Drop Products table if it exists
DROP TABLE IF EXISTS Products;


-- TABLE 5: INVENTORY
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
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

-- Insert sample records
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
(10, 10, 'BATCH010', 120, 20, 200, '2025-03-31', 20.50, 22.50, 'Shelf E1', '2024-01-10'),
(11, 11, 'BATCH011', 95, 15, 150, '2025-02-28', 7.99, 8.99, 'Shelf E2', '2024-01-11'),
(12, 12, 'BATCH012', 30, 5, 50, '2025-01-31', 105.00, 125.00, 'Secure Cabinet S1', '2024-01-12'),
(13, 13, 'BATCH013', 85, 15, 150, '2025-12-31', 26.75, 28.75, 'Shelf F1', '2024-01-13'),
(14, 14, 'BATCH014', 110, 20, 200, '2025-11-30', 12.25, 14.25, 'Shelf F2', '2024-01-14'),
(15, 15, 'BATCH015', 25, 5, 50, '2025-10-31', 75.00, 85.00, 'Refrigerator R2', '2024-01-15'),
(16, 16, 'BATCH016', 65, 10, 100, '2025-09-30', 32.50, 35.50, 'Shelf G1', '2024-01-16'),
(17, 17, 'BATCH017', 275, 50, 500, '2025-08-31', 11.75, 13.75, 'Shelf G2', '2024-01-17'),
(18, 18, 'BATCH018', 12, 3, 30, '2025-07-31', 550.00, 650.00, 'Emergency Kit E1', '2024-01-18'),
(19, 19, 'BATCH019', 75, 15, 150, '2025-06-30', 28.50, 32.50, 'Shelf H1', '2024-01-19'),
(20, 20, 'BATCH020', 500, 100, 1000, '2025-05-31', 4.25, 5.25, 'Shelf H2', '2024-01-20');

-- Retrieve all records from Inventory
SELECT * FROM Inventory;

-- Clear all data from Inventory table
TRUNCATE TABLE Inventory;

-- Drop Inventory table if it exists
DROP TABLE IF EXISTS Inventory;

-- TABLE 6: CUSTOMERS
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

-- Insert sample records
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
(10, 'Anna Garcia', '1981-06-27', 'Female', '+1-555-1010', 'anna.garcia@email.com', '741 Poplar Ln, Anywhere', 'Tricare', 'TC789456123', 'Codeine', '2024-01-10'),
(11, 'Christopher Lee', '1969-10-05', 'Male', '+1-555-1011', 'chris.lee@email.com', '852 Ash St, Someplace', 'BCBS', 'BC246810357', 'Iodine', '2024-01-11'),
(12, 'Michelle White', '1987-02-20', 'Female', '+1-555-1012', 'michelle.white@email.com', '963 Hickory Ave, Anytown', 'Aetna', 'AE135792468', 'None', '2024-01-12'),
(13, 'Kevin Rodriguez', '1973-08-16', 'Male', '+1-555-1013', 'kevin.rodriguez@email.com', '174 Sycamore Dr, Somewhere', 'Cigna', 'CI579246813', 'Morphine', '2024-01-13'),
(14, 'Amanda Martinez', '1991-12-03', 'Female', '+1-555-1014', 'amanda.martinez@email.com', '285 Chestnut Ct, Elsewhere', 'UnitedHealth', 'UH802468135', 'None', '2024-01-14'),
(15, 'Steven Thomas', '1984-05-09', 'Male', '+1-555-1015', 'steven.thomas@email.com', '396 Walnut St, Nowhere', 'Humana', 'HU913579246', 'Eggs', '2024-01-15'),
(16, 'Rachel Harris', '1979-09-24', 'Female', '+1-555-1016', 'rachel.harris@email.com', '507 Beech Ave, Anywhere', 'Kaiser Permanente', 'KP024681357', 'None', '2024-01-16'),
(17, 'Daniel Lewis', '1986-01-31', 'Male', '+1-555-1017', 'daniel.lewis@email.com', '618 Redwood Dr, Someplace', 'Anthem', 'AN468135792', 'Nuts', '2024-01-17'),
(18, 'Laura Young', '1994-07-07', 'Female', '+1-555-1018', 'laura.young@email.com', '729 Magnolia Ln, Anytown', 'Medicaid', 'MD579246813', 'None', '2024-01-18'),
(19, 'Brian Walker', '1976-11-13', 'Male', '+1-555-1019', 'brian.walker@email.com', '840 Dogwood St, Somewhere', 'Medicare', 'MC135792468', 'Contrast dye', '2024-01-19'),
(20, 'Nicole Green', '1989-03-28', 'Female', '+1-555-1020', 'nicole.green@email.com', '951 Cypress Ave, Elsewhere', 'Tricare', 'TC791357246', 'None', '2024-01-20');

-- Retrieve all records from Customers
SELECT * FROM Customers;

-- Clear all data from Customers table
TRUNCATE TABLE Customers;

-- Drop Customers table if it exists
DROP TABLE IF EXISTS Customers;

-- TABLE 7: PRESCRIPTIONS
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
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

-- Insert sample records
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
(10, 10, 'Dr. Christopher White', 'MD012345', '2024-01-24', 'Pending', 67.50, 54.00, 13.50, 'Gradual dose increase', '2024-01-24'),
(11, 11, 'Dr. Michelle Clark', 'MD123457', '2024-01-25', 'Filled', 26.97, 21.58, 5.39, 'Pediatric dosing', '2024-01-25'),
(12, 12, 'Dr. Kevin Rodriguez', 'MD234568', '2024-01-26', 'Filled', 375.00, 300.00, 75.00, 'Oncology treatment', '2024-01-26'),
(13, 13, 'Dr. Amanda Martinez', 'MD345679', '2024-01-27', 'Ready', 86.25, 69.00, 17.25, 'Mental health medication', '2024-01-27'),
(14, 14, 'Dr. Steven Thomas', 'MD456780', '2024-01-28', 'Filled', 42.75, 34.20, 8.55, 'Anti-inflammatory', '2024-01-28'),
(15, 15, 'Dr. Rachel Harris', 'MD567891', '2024-01-29', 'Filled', 255.00, 204.00, 51.00, 'Eye drops - refrigerate', '2024-01-29'),
(16, 16, 'Dr. Daniel Lewis', 'MD678902', '2024-01-30', 'Pending', 106.50, 85.20, 21.30, 'Pain management', '2024-01-30'),
(17, 17, 'Dr. Laura Young', 'MD789013', '2024-01-31', 'Filled', 41.25, 33.00, 8.25, 'Thyroid medication', '2024-01-31'),
(18, 18, 'Dr. Brian Walker', 'MD890124', '2024-02-01', 'Filled', 1950.00, 1560.00, 390.00, 'Emergency medication', '2024-02-01'),
(19, 19, 'Dr. Nicole Green', 'MD901235', '2024-02-02', 'Ready', 97.50, 78.00, 19.50, 'Antibiotic course', '2024-02-02'),
(20, 20, 'Dr. Patricia Hall', 'MD012346', '2024-02-03', 'Filled', 15.75, 12.60, 3.15, 'Daily aspirin', '2024-02-03');


-- Retrieve all records from Prescriptions
SELECT * FROM Prescriptions;

-- Clear all data from Prescriptions table
TRUNCATE TABLE Prescriptions;

-- Drop Prescriptions table if it exists
DROP TABLE IF EXISTS Prescriptions;

-- TABLE 8: PRESCRIPTION_ITEMS
CREATE TABLE Prescription_Items (
    prescription_item_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT,
    product_id INT,
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

-- Insert sample records
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
(10, 9, 10, 90, 'Take 1 capsule three times daily', 30, 22.50, 67.50, 1, 2, '2024-01-23'),
(11, 10, 11, 1, 'Give 1 teaspoon every 6 hours as needed', 10, 8.99, 8.99, 0, 0, '2024-01-24'),
(12, 11, 12, 30, 'Take 1 tablet daily', 30, 125.00, 125.00, 11, 12, '2024-01-25'),
(13, 12, 13, 30, 'Take 1 tablet daily with food', 30, 28.75, 28.75, 2, 3, '2024-01-26'),
(14, 13, 14, 21, 'Take 2 tablets daily for 7 days, then 1 daily', 21, 14.25, 29.93, 0, 0, '2024-01-27'),
(15, 14, 15, 1, 'Instill 1 drop in each eye at bedtime', 30, 85.00, 85.00, 5, 6, '2024-01-28'),
(16, 15, 16, 60, 'Take 1 capsule twice daily with food', 30, 35.50, 71.00, 1, 2, '2024-01-29'),
(17, 16, 17, 30, 'Take 1 tablet daily on empty stomach', 30, 13.75, 13.75, 5, 6, '2024-01-30'),
(18, 17, 18, 2, 'Use as directed for severe allergic reactions', 365, 650.00, 1300.00, 0, 0, '2024-01-31'),
(19, 18, 19, 6, 'Take 2 tablets daily for 3 days', 3, 32.50, 32.50, 0, 0, '2024-02-01'),
(20, 19, 20, 30, 'Take 1 tablet daily with food', 30, 5.25, 5.25, 0, 0, '2024-02-02');

-- Retrieve all records from Prescription_Items
SELECT * FROM Prescription_Items;

-- Clear all data from Prescription_Items table
TRUNCATE TABLE Prescription_Items;

-- Drop Prescription_Items table if it exists
DROP TABLE IF EXISTS Prescription_Items;

-- TABLE 9: PURCHASE_ORDERS
CREATE TABLE Purchase_Orders (
    purchase_order_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
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

-- Insert sample records
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
(10, 10, '2024-01-19', '2024-01-26', '2024-01-25', 'Delivered', 6300.00, 504.00, 85.00, 'Neurological drugs', '2024-01-19'),
(11, 11, '2024-01-20', '2024-01-27', NULL, 'Pending', 2700.00, 216.00, 40.00, 'Pediatric medications', '2024-01-20'),
(12, 12, '2024-01-21', '2024-01-28', NULL, 'Shipped', 15000.00, 1200.00, 200.00, 'Oncology medications', '2024-01-21'),
(13, 13, '2024-01-22', '2024-01-29', NULL, 'Processing', 8100.00, 648.00, 110.00, 'Psychiatric medications', '2024-01-22'),
(14, 14, '2024-01-23', '2024-01-30', NULL, 'Pending', 3900.00, 312.00, 50.00, 'Immunology drugs', '2024-01-23'),
(15, 15, '2024-01-24', '2024-01-31', NULL, 'Processing', 12000.00, 960.00, 150.00, 'Ophthalmology medications', '2024-01-24'),
(16, 16, '2024-01-25', '2024-02-01', NULL, 'Pending', 5400.00, 432.00, 70.00, 'Orthopedic medications', '2024-01-25'),
(17, 17, '2024-01-26', '2024-02-02', NULL, 'Processing', 4050.00, 324.00, 60.00, 'Hormonal medications', '2024-01-26'),
(18, 18, '2024-01-27', '2024-02-03', NULL, 'Pending', 18000.00, 1440.00, 250.00, 'Emergency medications', '2024-01-27'),
(19, 19, '2024-01-28', '2024-02-04', NULL, 'Processing', 6750.00, 540.00, 90.00, 'Additional antibiotics', '2024-01-28'),
(20, 20, '2024-01-29', '2024-02-05', NULL, 'Pending', 1500.00, 120.00, 25.00, 'OTC pain relievers', '2024-01-29');

-- Retrieve all records from Purchase_Orders
SELECT * FROM Purchase_Orders;

-- Clear all data from Purchase_Orders table
TRUNCATE TABLE Purchase_Orders;

-- Drop Purchase_Orders table if it exists
DROP TABLE IF EXISTS Purchase_Orders;


-- TABLE 10: PURCHASE_ORDER_ITEMS
CREATE TABLE Purchase_Order_Items (
    purchase_order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_order_id INT,
    product_id INT,
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

-- Insert sample records
INSERT INTO Purchase_Order_Items 
VALUES
(1, 1, 1, 500, 500, 10.50, 5250.00, 'BATCH001', '2025-12-31', '2024-01-16', 'Good condition'),
(2, 2, 2, 400, 400, 8.00, 3200.00, 'BATCH002', '2025-11-30', '2024-01-18', 'All items received'),
(3, 3, 3, 600, 600, 8.00, 4800.00, 'BATCH003', '2025-10-31', '2024-01-20', 'Perfect condition'),
(4, 4, 4, 1000, 1000, 7.50, 7500.00, 'BATCH004', '2025-09-30', '2024-01-19', 'Complete order'),
(5, 5, 5, 350, 350, 6.00, 2100.00, 'BATCH005', '2025-08-31', '2024-01-22', 'No issues'),
(6, 6, 6, 400, 400, 9.00, 3600.00, 'BATCH006', '2025-07-31', '2024-01-21', 'Delivered on time'),
(7, 7, 7, 300, 300, 6.00, 1800.00, 'BATCH007', '2025-06-30', '2024-01-24', 'Good packaging'),
(8, 8, 8, 200, 200, 45.00, 9000.00, 'BATCH008', '2025-05-31', '2024-01-23', 'Cold storage maintained'),
(9, 9, 9, 300, 300, 14.00, 4200.00, 'BATCH009', '2025-04-30', '2024-01-26', 'All good'),
(10, 10, 10, 350, 350, 18.00, 6300.00, 'BATCH010', '2025-03-31', '2024-01-25', 'Excellent quality'),
(11, 11, 11, 300, 0, 9.00, 2700.00, 'BATCH011', '2025-02-28', NULL, 'Pending delivery'),
(12, 12, 12, 150, 0, 100.00, 15000.00, 'BATCH012', '2025-01-31', NULL, 'In transit'),
(13, 13, 13, 300, 0, 27.00, 8100.00, 'BATCH013', '2025-12-31', NULL, 'Processing'),
(14, 14, 14, 300, 0, 13.00, 3900.00, 'BATCH014', '2025-11-30', NULL, 'Awaiting shipment'),
(15, 15, 15, 150, 0, 80.00, 12000.00, 'BATCH015', '2025-10-31', NULL, 'Order confirmed'),
(16, 16, 16, 200, 0, 27.00, 5400.00, 'BATCH016', '2025-09-30', NULL, 'Preparing shipment'),
(17, 17, 17, 350, 0, 11.57, 4050.00, 'BATCH017', '2025-08-31', NULL, 'Order placed'),
(18, 18, 18, 30, 0, 600.00, 18000.00, 'BATCH018', '2025-07-31', NULL, 'Special handling required'),
(19, 19, 19, 250, 0, 27.00, 6750.00, 'BATCH019', '2025-06-30', NULL, 'Rush order'),
(20, 20, 20, 300, 0, 5.00, 1500.00, 'BATCH020', '2025-05-31', NULL, 'Standard delivery');

-- Retrieve all records from Purchase_Order_Items
SELECT * FROM Purchase_Order_Items;

-- Clear all data from Purchase_Order_Items table
TRUNCATE TABLE Purchase_Order_Items;

-- Drop Purchase_Order_Items table if it exists
DROP TABLE IF EXISTS Purchase_Order_Items;

-- TABLE 11: SALES
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
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

-- Insert sample records
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
(10, 10, '2024-01-24', 67.50, 5.40, 6.75, 'Debit Card', 'Completed', 101, 'RCP010', '2024-01-24'),
(11, 11, '2024-01-25', 26.97, 2.16, 0.00, 'Cash', 'Completed', 102, 'RCP011', '2024-01-25'),
(12, 12, '2024-01-26', 375.00, 30.00, 0.00, 'Insurance', 'Completed', 103, 'RCP012', '2024-01-26'),
(13, 13, '2024-01-27', 86.25, 6.90, 0.00, 'Credit Card', 'Completed', 101, 'RCP013', '2024-01-27'),
(14, 14, '2024-01-28', 42.75, 3.42, 4.28, 'Cash', 'Completed', 102, 'RCP014', '2024-01-28'),
(15, 15, '2024-01-29', 255.00, 20.40, 0.00, 'Insurance', 'Completed', 103, 'RCP015', '2024-01-29'),
(16, 16, '2024-01-30', 106.50, 8.52, 0.00, 'Credit Card', 'Completed', 101, 'RCP016', '2024-01-30'),
(17, 17, '2024-01-31', 41.25, 3.30, 0.00, 'Debit Card', 'Completed', 102, 'RCP017', '2024-01-31'),
(18, 18, '2024-02-01', 1950.00, 156.00, 0.00, 'Insurance', 'Completed', 103, 'RCP018', '2024-02-01'),
(19, 19, '2024-02-02', 97.50, 7.80, 0.00, 'Credit Card', 'Completed', 101, 'RCP019', '2024-02-02'),
(20, 20, '2024-02-03', 15.75, 1.26, 1.58, 'Cash', 'Completed', 102, 'RCP020', '2024-02-03');

-- Retrieve all records from Sales
SELECT * FROM Sales;

-- Clear all data from Sales table
TRUNCATE TABLE Sales;

-- Drop Sales table if it exists
DROP TABLE IF EXISTS Sales;

-- TABLE 12: SALE_ITEMS
CREATE TABLE Sale_Items (
    sale_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT,
    product_id INT,
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

-- Insert sample records
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
(10, 9, 10, 90, 22.50, 6.75, 67.50, 'BATCH010', '2025-03-31', 10, '2024-01-23'),
(11, 10, 11, 1, 8.99, 0.00, 8.99, 'BATCH011', '2025-02-28', 11, '2024-01-24'),
(12, 11, 12, 30, 125.00, 0.00, 125.00, 'BATCH012', '2025-01-31', 12, '2024-01-25'),
(13, 12, 13, 30, 28.75, 0.00, 28.75, 'BATCH013', '2025-12-31', 13, '2024-01-26'),
(14, 13, 14, 21, 14.25, 4.28, 29.93, 'BATCH014', '2025-11-30', 14, '2024-01-27'),
(15, 14, 15, 1, 85.00, 0.00, 85.00, 'BATCH015', '2025-10-31', 15, '2024-01-28'),
(16, 15, 16, 60, 35.50, 0.00, 71.00, 'BATCH016', '2025-09-30', 16, '2024-01-29'),
(17, 16, 17, 30, 13.75, 0.00, 13.75, 'BATCH017', '2025-08-31', 17, '2024-01-30'),
(18, 17, 18, 2, 650.00, 0.00, 1300.00, 'BATCH018', '2025-07-31', 18, '2024-01-31'),
(19, 18, 19, 6, 32.50, 0.00, 32.50, 'BATCH019', '2025-06-30', 19, '2024-02-01'),
(20, 19, 20, 30, 5.25, 1.58, 5.25, 'BATCH020', '2025-05-31', 20, '2024-02-02');

-- Retrieve all records from Sale_Items
SELECT * FROM Sale_Items;

-- Clear all data from Sale_Items table
TRUNCATE TABLE Sale_Items;

-- Drop Sale_Items table if it exists
DROP TABLE IF EXISTS Sale_Items;

-- TABLE 13: EMPLOYEES
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    department VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10,2),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    emergency_contact VARCHAR(100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample records
INSERT INTO Employees VALUES
(101, 'Alice Johnson', 'Senior Pharmacist', 'Pharmacy', '2020-03-15', 85000.00, '+1-555-2001', 'alice.johnson@pharmacy.com', '123 Pharmacy Lane', 'Bob Johnson +1-555-2101', '2024-01-01'),
(102, 'Mark Thompson', 'Pharmacy Technician', 'Pharmacy', '2021-06-20', 45000.00, '+1-555-2002', 'mark.thompson@pharmacy.com', '456 Tech Street', 'Lisa Thompson +1-555-2102', '2024-01-02'),
(103, 'Sarah Davis', 'Pharmacist', 'Pharmacy', '2019-11-10', 78000.00, '+1-555-2003', 'sarah.davis@pharmacy.com', '789 Medical Ave', 'John Davis +1-555-2103', '2024-01-03'),
(104, 'Michael Brown', 'Inventory Manager', 'Inventory', '2018-08-05', 65000.00, '+1-555-2004', 'michael.brown@pharmacy.com', '321 Supply Road', 'Emily Brown +1-555-2104', '2024-01-04'),
(105, 'Jennifer Wilson', 'Cashier', 'Sales', '2022-01-25', 32000.00, '+1-555-2005', 'jennifer.wilson@pharmacy.com', '654 Cash Street', 'David Wilson +1-555-2105', '2024-01-05'),
(106, 'Robert Anderson', 'Pharmacy Manager', 'Management', '2017-04-12', 95000.00, '+1-555-2006', 'robert.anderson@pharmacy.com', '987 Manager Blvd', 'Lisa Anderson +1-555-2106', '2024-01-06'),
(107, 'Linda Taylor', 'Purchasing Agent', 'Purchasing', '2020-09-30', 55000.00, '+1-555-2007', 'linda.taylor@pharmacy.com', '147 Purchase Ave', 'James Taylor +1-555-2107', '2024-01-07'),
(108, 'Christopher Lee', 'Pharmacist', 'Pharmacy', '2021-12-08', 82000.00, '+1-555-2008', 'christopher.lee@pharmacy.com', '258 Pharma Drive', 'Anna Lee +1-555-2108', '2024-01-08'),
(109, 'Michelle Garcia', 'Pharmacy Technician', 'Pharmacy', '2022-05-15', 42000.00, '+1-555-2009', 'michelle.garcia@pharmacy.com', '369 Tech Lane', 'Carlos Garcia +1-555-2109', '2024-01-09'),
(110, 'Kevin Martinez', 'Store Assistant', 'Sales', '2023-02-20', 28000.00, '+1-555-2010', 'kevin.martinez@pharmacy.com', '741 Store Street', 'Maria Martinez +1-555-2110', '2024-01-10'),
(111, 'Amanda Rodriguez', 'Quality Control', 'Quality', '2019-07-18', 58000.00, '+1-555-2011', 'amanda.rodriguez@pharmacy.com', '852 Quality Road', 'Luis Rodriguez +1-555-2111', '2024-01-11'),
(112, 'Daniel Thomas', 'IT Support', 'IT', '2021-03-22', 52000.00, '+1-555-2012', 'daniel.thomas@pharmacy.com', '963 IT Avenue', 'Rachel Thomas +1-555-2112', '2024-01-12'),
(113, 'Laura Harris', 'Customer Service', 'Customer Care', '2020-11-05', 38000.00, '+1-555-2013', 'laura.harris@pharmacy.com', '174 Service Lane', 'Brian Harris +1-555-2113', '2024-01-13'),
(114, 'Steven White', 'Delivery Driver', 'Delivery', '2022-08-10', 35000.00, '+1-555-2014', 'steven.white@pharmacy.com', '285 Delivery Street', 'Nancy White +1-555-2114', '2024-01-14'),
(115, 'Rachel Lewis', 'Accountant', 'Finance', '2018-12-01', 62000.00, '+1-555-2015', 'rachel.lewis@pharmacy.com', '396 Finance Blvd', 'Daniel Lewis +1-555-2115', '2024-01-15'),
(116, 'Brian Young', 'Security Guard', 'Security', '2021-10-15', 40000.00, '+1-555-2016', 'brian.young@pharmacy.com', '507 Security Road', 'Jennifer Young +1-555-2116', '2024-01-16'),
(117, 'Nicole Walker', 'HR Manager', 'Human Resources', '2019-05-28', 72000.00, '+1-555-2017', 'nicole.walker@pharmacy.com', '618 HR Avenue', 'Michael Walker +1-555-2117', '2024-01-17'),
(118, 'David Green', 'Maintenance', 'Facilities', '2020-02-14', 43000.00, '+1-555-2018', 'david.green@pharmacy.com', '729 Maintenance Lane', 'Susan Green +1-555-2118', '2024-01-18'),
(119, 'Patricia Hall', 'Receptionist', 'Front Desk', '2022-07-03', 30000.00, '+1-555-2019', 'patricia.hall@pharmacy.com', '840 Front Street', 'Robert Hall +1-555-2119', '2024-01-19'),
(120, 'Jason Clark', 'Pharmacist', 'Pharmacy', '2018-01-20', 88000.00, '+1-555-2020', 'jason.clark@pharmacy.com', '951 Pharmacy Drive', 'Michelle Clark +1-555-2120', '2024-01-20');

-- Retrieve all records from Employees
SELECT * FROM Employees;

-- Clear all data from Employees table
TRUNCATE TABLE Employees;

-- Drop Employees table if it exists
DROP TABLE IF EXISTS Employees;

-- TABLE 14: SHIFTS
CREATE TABLE Shifts (
    shift_id INT PRIMARY KEY AUTO_INCREMENT,
    shift_name VARCHAR(50) NOT NULL,
    start_time TIME,
    end_time TIME,
    break_duration INT,
    shift_type VARCHAR(20),
    hourly_rate_multiplier DECIMAL(3,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_by VARCHAR(50),
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample records
INSERT INTO Shifts VALUES
(1, 'Morning Shift', '06:00:00', '14:00:00', 60, 'Regular', 1.00, TRUE, 'admin', '8-hour morning shift', '2024-01-01'),
(2, 'Afternoon Shift', '14:00:00', '22:00:00', 60, 'Regular', 1.00, TRUE, 'admin', '8-hour afternoon shift', '2024-01-02'),
(3, 'Night Shift', '22:00:00', '06:00:00', 60, 'Night', 1.15, TRUE, 'admin', '8-hour night shift with premium', '2024-01-03'),
(4, 'Weekend Day', '08:00:00', '16:00:00', 60, 'Weekend', 1.25, TRUE, 'admin', '8-hour weekend day shift', '2024-01-04'),
(5, 'Weekend Night', '16:00:00', '00:00:00', 60, 'Weekend', 1.40, TRUE, 'admin', '8-hour weekend night shift', '2024-01-05'),
(6, 'Holiday Shift', '08:00:00', '16:00:00', 60, 'Holiday', 1.50, TRUE, 'admin', '8-hour holiday shift', '2024-01-06'),
(7, 'Part-time Morning', '08:00:00', '12:00:00', 30, 'Part-time', 1.00, TRUE, 'admin', '4-hour part-time morning', '2024-01-07'),
(8, 'Part-time Afternoon', '12:00:00', '16:00:00', 30, 'Part-time', 1.00, TRUE, 'admin', '4-hour part-time afternoon', '2024-01-08'),
(9, 'Part-time Evening', '16:00:00', '20:00:00', 30, 'Part-time', 1.10, TRUE, 'admin', '4-hour part-time evening', '2024-01-09'),
(10, 'Emergency On-call', '00:00:00', '23:59:59', 0, 'Emergency', 2.00, TRUE, 'admin', '24-hour emergency coverage', '2024-01-10'),
(11, 'Double Shift', '06:00:00', '22:00:00', 120, 'Extended', 1.20, TRUE, 'admin', '16-hour double shift', '2024-01-11'),
(12, 'Split Shift A', '08:00:00', '12:00:00', 30, 'Split', 1.00, TRUE, 'admin', 'Morning part of split shift', '2024-01-12'),
(13, 'Split Shift B', '16:00:00', '20:00:00', 30, 'Split', 1.00, TRUE, 'admin', 'Evening part of split shift', '2024-01-13'),
(14, 'Supervisor Day', '07:00:00', '15:00:00', 60, 'Supervisor', 1.30, TRUE, 'admin', '8-hour supervisor day shift', '2024-01-14'),
(15, 'Supervisor Night', '15:00:00', '23:00:00', 60, 'Supervisor', 1.45, TRUE, 'admin', '8-hour supervisor night shift', '2024-01-15'),
(16, 'Training Shift', '09:00:00', '17:00:00', 60, 'Training', 0.85, TRUE, 'admin', '8-hour training shift', '2024-01-16'),
(17, 'Inventory Shift', '05:00:00', '13:00:00', 60, 'Inventory', 1.10, TRUE, 'admin', '8-hour inventory management', '2024-01-17'),
(18, 'Delivery Shift', '10:00:00', '18:00:00', 60, 'Delivery', 1.05, TRUE, 'admin', '8-hour delivery shift', '2024-01-18'),
(19, 'Customer Service', '08:00:00', '20:00:00', 90, 'Customer', 1.00, TRUE, 'admin', '12-hour customer service', '2024-01-19'),
(20, 'Closing Shift', '18:00:00', '02:00:00', 60, 'Closing', 1.25, TRUE, 'admin', '8-hour closing shift', '2024-01-20');

-- Retrieve all records from Shifts
SELECT * FROM Shifts;

-- Clear all data from Shifts table
TRUNCATE TABLE Shifts;

-- Drop Shifts table if it exists
DROP TABLE IF EXISTS Shifts;

-- TABLE 15: EMPLOYEE_SHIFTS
CREATE TABLE Employee_Shifts (
    employee_shift_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    shift_id INT,
    work_date DATE,
    actual_start_time TIME,
    actual_end_time TIME,
    break_minutes INT,
    overtime_minutes INT,
    hourly_rate DECIMAL(8,2),
    total_hours DECIMAL(5,2),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (shift_id) REFERENCES Shifts(shift_id)
);

-- Insert sample records
INSERT INTO Employee_Shifts VALUES
(1, 101, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 40.87, 8.0, '2024-01-15'),
(2, 102, 1, '2024-01-15', '06:05:00', '14:10:00', 60, 10, 21.63, 8.1, '2024-01-15'),
(3, 103, 2, '2024-01-15', '14:00:00', '22:00:00', 60, 0, 37.50, 8.0, '2024-01-15'),
(4, 104, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 31.25, 8.0, '2024-01-15'),
(5, 105, 2, '2024-01-15', '14:00:00', '22:00:00', 60, 0, 15.38, 8.0, '2024-01-15'),
(6, 106, 14, '2024-01-15', '07:00:00', '15:00:00', 60, 0, 49.62, 8.0, '2024-01-15'),
(7, 107, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 26.44, 8.0, '2024-01-15'),
(8, 108, 2, '2024-01-15', '14:00:00', '22:00:00', 60, 0, 39.42, 8.0, '2024-01-15'),
(9, 109, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 20.19, 8.0, '2024-01-15'),
(10, 110, 2, '2024-01-15', '14:00:00', '22:00:00', 60, 0, 13.46, 8.0, '2024-01-15'),
(11, 111, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 27.88, 8.0, '2024-01-15'),
(12, 112, 2, '2024-01-15', '14:00:00', '22:00:00', 60, 0, 25.00, 8.0, '2024-01-15'),
(13, 113, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 18.27, 8.0, '2024-01-15'),
(14, 114, 18, '2024-01-15', '10:00:00', '18:00:00', 60, 0, 17.79, 8.0, '2024-01-15'),
(15, 115, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 29.81, 8.0, '2024-01-15'),
(16, 116, 3, '2024-01-15', '22:00:00', '06:00:00', 60, 0, 23.08, 8.0, '2024-01-15'),
(17, 117, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 34.62, 8.0, '2024-01-15'),
(18, 118, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 20.67, 8.0, '2024-01-15'),
(19, 119, 2, '2024-01-15', '14:00:00', '22:00:00', 60, 0, 14.42, 8.0, '2024-01-15'),
(20, 120, 1, '2024-01-15', '06:00:00', '14:00:00', 60, 0, 42.31, 8.0, '2024-01-15');

-- Retrieve all records from Employee_Shifts
SELECT * FROM Employee_Shifts;

-- Clear all data from Employee_Shifts table
TRUNCATE TABLE Employee_Shifts;

-- Drop Employee_Shifts table if it exists
DROP TABLE IF EXISTS Employee_Shifts;

-- TABLE 16: VENDORS
CREATE TABLE Vendors (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_name VARCHAR(100) NOT NULL,
    vendor_type VARCHAR(50),
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100),
    address TEXT,
    payment_terms VARCHAR(50),
    tax_id VARCHAR(50),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample records
INSERT INTO Vendors VALUES
(1, 'MedEquip Solutions', 'Equipment', 'John Carter', '+1-555-3001', 'john.carter@medequip.com', 'www.medequip.com', '123 Equipment St', 'Net 30', 'TAX001', '2024-01-01'),
(2, 'Pharma Logistics', 'Logistics', 'Sarah Kim', '+1-555-3002', 'sarah.kim@pharmalog.com', 'www.pharmalog.com', '456 Logistics Ave', 'Net 15', 'TAX002', '2024-01-02'),
(3, 'Medical Supplies Inc', 'Supplies', 'Mike Johnson', '+1-555-3003', 'mike.johnson@medsupplies.com', 'www.medsupplies.com', '789 Supply Road', 'Net 45', 'TAX003', '2024-01-03'),
(4, 'IT Healthcare Systems', 'Technology', 'Emily Chen', '+1-555-3004', 'emily.chen@ithealthcare.com', 'www.ithealthcare.com', '321 Tech Blvd', 'Net 30', 'TAX004', '2024-01-04'),
(5, 'CleanCare Services', 'Cleaning', 'David Brown', '+1-555-3005', 'david.brown@cleancare.com', 'www.cleancare.com', '654 Clean Street', 'Net 15', 'TAX005', '2024-01-05'),
(6, 'SecurePharm Systems', 'Security', 'Lisa Davis', '+1-555-3006', 'lisa.davis@securepharm.com', 'www.securepharm.com', '987 Security Ave', 'Net 30', 'TAX006', '2024-01-06'),
(7, 'PowerMed Utilities', 'Utilities', 'Robert Wilson', '+1-555-3007', 'robert.wilson@powermed.com', 'www.powermed.com', '147 Power Lane', 'Net 30', 'TAX007', '2024-01-07'),
(8, 'Office Supplies Plus', 'Office Supplies', 'Jennifer Taylor', '+1-555-3008', 'jennifer.taylor@officeplus.com', 'www.officeplus.com', '258 Office Drive', 'Net 30', 'TAX008', '2024-01-08'),
(9, 'Uniform Healthcare', 'Uniforms', 'Chris Anderson', '+1-555-3009', 'chris.anderson@uniformhc.com', 'www.uniformhc.com', '369 Uniform Street', 'Net 15', 'TAX009', '2024-01-09'),
(10, 'Consulting Partners', 'Consulting', 'Anna Martinez', '+1-555-3010', 'anna.martinez@consultingp.com', 'www.consultingp.com', '741 Consult Ave', 'Net 30', 'TAX010', '2024-01-10'),
(11, 'Waste Management Pro', 'Waste Management', 'Kevin Lee', '+1-555-3011', 'kevin.lee@wastepro.com', 'www.wastepro.com', '852 Waste Road', 'Net 15', 'TAX011', '2024-01-11'),
(12, 'Insurance Brokers Ltd', 'Insurance', 'Michelle White', '+1-555-3012', 'michelle.white@insurebrokers.com', 'www.insurebrokers.com', '963 Insurance Blvd', 'Net 30', 'TAX012', '2024-01-12'),
(13, 'Training Solutions', 'Training', 'Steven Garcia', '+1-555-3013', 'steven.garcia@trainingsol.com', 'www.trainingsol.com', '174 Training Lane', 'Net 30', 'TAX013', '2024-01-13'),
(14, 'Marketing Experts', 'Marketing', 'Amanda Rodriguez', '+1-555-3014', 'amanda.rodriguez@marketexp.com', 'www.marketexp.com', '285 Marketing St', 'Net 15', 'TAX014', '2024-01-14'),
(15, 'Legal Services Pro', 'Legal', 'Daniel Thomas', '+1-555-3015', 'daniel.thomas@legalpro.com', 'www.legalpro.com', '396 Legal Avenue', 'Net 30', 'TAX015', '2024-01-15'),
(16, 'Accounting Solutions', 'Accounting', 'Laura Harris', '+1-555-3016', 'laura.harris@accountsol.com', 'www.accountsol.com', '507 Account Drive', 'Net 30', 'TAX016', '2024-01-16'),
(17, 'Construction Services', 'Construction', 'Brian Lewis', '+1-555-3017', 'brian.lewis@constructsvc.com', 'www.constructsvc.com', '618 Construct Road', 'Net 30', 'TAX017', '2024-01-17'),
(18, 'Delivery Express', 'Delivery', 'Nicole Young', '+1-555-3018', 'nicole.young@deliveryexp.com', 'www.deliveryexp.com', '729 Delivery Lane', 'Net 15', 'TAX018', '2024-01-18'),
(19, 'Maintenance Masters', 'Maintenance', 'Patrick Walker', '+1-555-3019', 'patrick.walker@maintmasters.com', 'www.maintmasters.com', '840 Maintenance St', 'Net 30', 'TAX019', '2024-01-19'),
(20, 'Telecommunications Co', 'Communications', 'Jessica Green', '+1-555-3020', 'jessica.green@telecom.com', 'www.telecom.com', '951 Telecom Blvd', 'Net 30', 'TAX020', '2024-01-20');

-- Retrieve all records from Vendors
SELECT * FROM Vendors;

-- Clear all data from Vendors table
TRUNCATE TABLE Vendors;

-- Drop Vendors table if it exists
DROP TABLE IF EXISTS Vendors;

-- TABLE 17: VENDOR_CONTRACTS
CREATE TABLE Vendor_Contracts (
    contract_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT,
    contract_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    contract_value DECIMAL(12,2),
    payment_terms VARCHAR(50),
    renewal_terms VARCHAR(100),
    termination_clause TEXT,
    contract_status VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Insert sample records
INSERT INTO Vendor_Contracts VALUES
(1, 1, 'Medical Equipment Maintenance', '2024-01-01', '2024-12-31', 12000.00, 'Quarterly', 'Annual renewal', '30 days notice', 'Active', '2024-01-01'),
(2, 2, 'Pharmaceutical Logistics', '2024-01-15', '2024-12-31', 18000.00, 'Monthly', 'Biannual review', '60 days notice', 'Active', '2024-01-02'),
(3, 3, 'Medical Supplies Agreement', '2024-02-01', '2025-01-31', 24000.00, 'Net 30', 'Annual renewal', '90 days notice', 'Active', '2024-01-03'),
(4, 4, 'IT Support Services', '2024-01-01', '2024-06-30', 15000.00, 'Monthly', '6-month renewal', '30 days notice', 'Active', '2024-01-04'),
(5, 5, 'Cleaning Services Contract', '2024-01-01', '2024-12-31', 9600.00, 'Bi-weekly', 'Annual renewal', '30 days notice', 'Active', '2024-01-05'),
(6, 6, 'Security Services Agreement', '2024-01-15', '2024-12-31', 30000.00, 'Monthly', 'Annual renewal', '60 days notice', 'Active', '2024-01-06'),
(7, 7, 'Utility Management', '2024-01-01', '2024-12-31', 24000.00, 'Monthly', 'Annual renewal', '30 days notice', 'Active', '2024-01-07'),
(8, 8, 'Office Supplies Agreement', '2024-01-01', '2024-12-31', 6000.00, 'Net 30', 'Annual renewal', '30 days notice', 'Active', '2024-01-08'),
(9, 9, 'Uniform Services Contract', '2024-02-01', '2024-12-31', 8400.00, 'Quarterly', 'Annual renewal', '30 days notice', 'Pending', '2024-01-09'),
(10, 10, 'Consulting Services', '2024-01-15', '2024-06-30', 18000.00, 'Monthly', '6-month renewal', '30 days notice', 'Active', '2024-01-10'),
(11, 11, 'Waste Disposal Services', '2024-01-01', '2024-12-31', 12000.00, 'Monthly', 'Annual renewal', '30 days notice', 'Active', '2024-01-11'),
(12, 12, 'Insurance Brokerage', '2024-01-01', '2024-12-31', 36000.00, 'Quarterly', 'Annual renewal', '60 days notice', 'Active', '2024-01-12'),
(13, 13, 'Employee Training Program', '2024-02-01', '2024-12-31', 15000.00, 'Monthly', 'Annual renewal', '30 days notice', 'Pending', '2024-01-13'),
(14, 14, 'Marketing Services', '2024-01-15', '2024-06-30', 24000.00, 'Monthly', '6-month renewal', '30 days notice', 'Active', '2024-01-14'),
(15, 15, 'Legal Services Retainer', '2024-01-01', '2024-12-31', 48000.00, 'Monthly', 'Annual renewal', '30 days notice', 'Active', '2024-01-15'),
(16, 16, 'Accounting Services', '2024-01-01', '2024-12-31', 36000.00, 'Monthly', 'Annual renewal', '30 days notice', 'Active', '2024-01-16'),
(17, 17, 'Facility Maintenance', '2024-02-01', '2024-12-31', 42000.00, 'Monthly', 'Annual renewal', '60 days notice', 'Pending', '2024-01-17'),
(18, 18, 'Delivery Services', '2024-01-15', '2024-12-31', 30000.00, 'Monthly', 'Annual renewal', '30 days notice', 'Active', '2024-01-18'),
(19, 19, 'Equipment Maintenance', '2024-01-01', '2024-06-30', 18000.00, 'Monthly', '6-month renewal', '30 days notice', 'Active', '2024-01-19'),
(20, 20, 'Telecom Services', '2024-01-01', '2024-12-31', 24000.00, 'Monthly', 'Annual renewal', '30 days notice', 'Active', '2024-01-20');

-- Retrieve all records from Vendor_Contracts
SELECT * FROM Vendor_Contracts;

-- Clear all data from Vendor_Contracts table
TRUNCATE TABLE Vendor_Contracts;

-- Drop Vendor_Contracts table if it exists
DROP TABLE IF EXISTS Vendor_Contracts;

-- TABLE 18: EXPENSES
CREATE TABLE Expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    expense_type VARCHAR(50) NOT NULL,
    vendor_id INT,
    expense_date DATE,
    amount DECIMAL(10,2),
    payment_method VARCHAR(20),
    description TEXT,
    reference_number VARCHAR(50),
    status VARCHAR(20),
    approved_by VARCHAR(100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Insert sample records
INSERT INTO Expenses VALUES
(1, 'Equipment Maintenance', 1, '2024-01-05', 1000.00, 'Credit Card', 'Quarterly equipment service', 'EQ-2024-001', 'Approved', 'Robert Anderson', '2024-01-05'),
(2, 'Logistics', 2, '2024-01-10', 1500.00, 'Bank Transfer', 'Monthly logistics fee', 'LG-2024-001', 'Approved', 'Robert Anderson', '2024-01-10'),
(3, 'Medical Supplies', 3, '2024-01-15', 2000.00, 'Check', 'Monthly supply order', 'MS-2024-001', 'Approved', 'Robert Anderson', '2024-01-15'),
(4, 'IT Services', 4, '2024-01-20', 2500.00, 'Credit Card', 'Monthly IT support', 'IT-2024-001', 'Approved', 'Robert Anderson', '2024-01-20'),
(5, 'Cleaning Services', 5, '2024-01-25', 800.00, 'Bank Transfer', 'Bi-weekly cleaning', 'CS-2024-001', 'Approved', 'Robert Anderson', '2024-01-25'),
(6, 'Security Services', 6, '2024-01-30', 2500.00, 'Check', 'Monthly security', 'SC-2024-001', 'Approved', 'Robert Anderson', '2024-01-30'),
(7, 'Utilities', 7, '2024-02-05', 2000.00, 'Credit Card', 'Monthly utilities', 'UT-2024-001', 'Approved', 'Robert Anderson', '2024-02-05'),
(8, 'Office Supplies', 8, '2024-02-10', 500.00, 'Bank Transfer', 'Office supplies order', 'OS-2024-001', 'Approved', 'Robert Anderson', '2024-02-10'),
(9, 'Uniforms', 9, '2024-02-15', 700.00, 'Check', 'Quarterly uniform service', 'UN-2024-001', 'Pending', NULL, '2024-02-15'),
(10, 'Consulting', 10, '2024-02-20', 3000.00, 'Credit Card', 'Monthly consulting fee', 'CN-2024-001', 'Approved', 'Robert Anderson', '2024-02-20'),
(11, 'Waste Disposal', 11, '2024-02-25', 1000.00, 'Bank Transfer', 'Monthly waste disposal', 'WD-2024-001', 'Approved', 'Robert Anderson', '2024-02-25'),
(12, 'Insurance', 12, '2024-03-01', 3000.00, 'Check', 'Quarterly insurance premium', 'IN-2024-001', 'Approved', 'Robert Anderson', '2024-03-01'),
(13, 'Training', 13, '2024-03-05', 1250.00, 'Credit Card', 'Employee training session', 'TR-2024-001', 'Pending', NULL, '2024-03-05'),
(14, 'Marketing', 14, '2024-03-10', 2000.00, 'Bank Transfer', 'Monthly marketing services', 'MK-2024-001', 'Approved', 'Robert Anderson', '2024-03-10'),
(15, 'Legal', 15, '2024-03-15', 4000.00, 'Check', 'Monthly legal retainer', 'LG-2024-001', 'Approved', 'Robert Anderson', '2024-03-15'),
(16, 'Accounting', 16, '2024-03-20', 3000.00, 'Credit Card', 'Monthly accounting services', 'AC-2024-001', 'Approved', 'Robert Anderson', '2024-03-20'),
(17, 'Maintenance', 17, '2024-03-25', 3500.00, 'Bank Transfer', 'Facility maintenance', 'MN-2024-001', 'Pending', NULL, '2024-03-25'),
(18, 'Delivery', 18, '2024-03-30', 2500.00, 'Check', 'Monthly delivery services', 'DL-2024-001', 'Approved', 'Robert Anderson', '2024-03-30'),
(19, 'Equipment', 19, '2024-04-05', 1500.00, 'Credit Card', 'Monthly equipment maintenance', 'EQ-2024-002', 'Approved', 'Robert Anderson', '2024-04-05'),
(20, 'Telecom', 20, '2024-04-10', 2000.00, 'Bank Transfer', 'Monthly telecom services', 'TC-2024-001', 'Approved', 'Robert Anderson', '2024-04-10');

-- Retrieve all records from Expenses
SELECT * FROM Expenses;

-- Clear all data from Expenses table
TRUNCATE TABLE Expenses;

-- Drop Expenses table if it exists
DROP TABLE IF EXISTS Expenses;

-- TABLE 19: PAYMENTS
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
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (processed_by) REFERENCES Employees(employee_id)
);

-- Insert sample records
INSERT INTO Payments VALUES
(1, 'Expense', 1, '2024-01-05', 1000.00, 'Credit Card', 'CC-001', 'Completed', 'Equipment maintenance', 106, '2024-01-05'),
(2, 'Expense', 2, '2024-01-10', 1500.00, 'Bank Transfer', 'BT-001', 'Completed', 'Logistics payment', 106, '2024-01-10'),
(3, 'Expense', 3, '2024-01-15', 2000.00, 'Check', 'CH-001', 'Completed', 'Medical supplies', 106, '2024-01-15'),
(4, 'Expense', 4, '2024-01-20', 2500.00, 'Credit Card', 'CC-002', 'Completed', 'IT services', 106, '2024-01-20'),
(5, 'Expense', 5, '2024-01-25', 800.00, 'Bank Transfer', 'BT-002', 'Completed', 'Cleaning services', 106, '2024-01-25'),
(6, 'Expense', 6, '2024-01-30', 2500.00, 'Check', 'CH-002', 'Completed', 'Security services', 106, '2024-01-30'),
(7, 'Expense', 7, '2024-02-05', 2000.00, 'Credit Card', 'CC-003', 'Completed', 'Utilities payment', 106, '2024-02-05'),
(8, 'Expense', 8, '2024-02-10', 500.00, 'Bank Transfer', 'BT-003', 'Completed', 'Office supplies', 106, '2024-02-10'),
(9, 'Purchase Order', 1, '2024-01-17', 5250.00, 'Bank Transfer', 'BT-004', 'Completed', 'Supplier payment', 106, '2024-01-17'),
(10, 'Purchase Order', 2, '2024-01-18', 3200.00, 'Check', 'CH-003', 'Completed', 'Supplier payment', 106, '2024-01-18'),
(11, 'Purchase Order', 3, '2024-01-20', 4800.00, 'Bank Transfer', 'BT-005', 'Completed', 'Supplier payment', 106, '2024-01-20'),
(12, 'Purchase Order', 4, '2024-01-19', 7500.00, 'Credit Card', 'CC-004', 'Completed', 'Supplier payment', 106, '2024-01-19'),
(13, 'Purchase Order', 5, '2024-01-22', 2100.00, 'Bank Transfer', 'BT-006', 'Completed', 'Supplier payment', 106, '2024-01-22'),
(14, 'Purchase Order', 6, '2024-01-21', 3600.00, 'Check', 'CH-004', 'Completed', 'Supplier payment', 106, '2024-01-21'),
(15, 'Purchase Order', 7, '2024-01-24', 1800.00, 'Bank Transfer', 'BT-007', 'Completed', 'Supplier payment', 106, '2024-01-24'),
(16, 'Purchase Order', 8, '2024-01-23', 9000.00, 'Credit Card', 'CC-005', 'Completed', 'Supplier payment', 106, '2024-01-23'),
(17, 'Purchase Order', 9, '2024-01-26', 4200.00, 'Bank Transfer', 'BT-008', 'Completed', 'Supplier payment', 106, '2024-01-26'),
(18, 'Purchase Order', 10, '2024-01-25', 6300.00, 'Check', 'CH-005', 'Completed', 'Supplier payment', 106, '2024-01-25'),
(19, 'Salary', 101, '2024-01-31', 7083.33, 'Bank Transfer', 'BT-009', 'Completed', 'Monthly salary', 106, '2024-01-31'),
(20, 'Salary', 102, '2024-01-31', 3750.00, 'Bank Transfer', 'BT-010', 'Completed', 'Monthly salary', 106, '2024-01-31');

-- Retrieve all records from Payments
SELECT * FROM Payments;

-- Clear all data from Payments table
TRUNCATE TABLE Payments;

-- Drop Payments table if it exists
DROP TABLE IF EXISTS Payments;

-- TABLE 20: INSURANCE_PROVIDERS
CREATE TABLE Insurance_Providers (
    provider_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    contract_start_date DATE,
    contract_end_date DATE,
    discount_percentage DECIMAL(5,2),
    claim_processing_days INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample records
INSERT INTO Insurance_Providers VALUES
(1, 'BlueCross BlueShield', 'Michael Johnson', '+1-555-4001', 'michael.johnson@bcbs.com', '123 Insurance Plaza', '2024-01-01', '2024-12-31', 15.00, 14, '2024-01-01'),
(2, 'Aetna', 'Sarah Williams', '+1-555-4002', 'sarah.williams@aetna.com', '456 Coverage Ave', '2024-01-01', '2024-12-31', 12.50, 21, '2024-01-02'),
(3, 'Cigna', 'David Brown', '+1-555-4003', 'david.brown@cigna.com', '789 Health St', '2024-01-01', '2024-12-31', 10.00, 30, '2024-01-03'),
(4, 'UnitedHealth', 'Lisa Davis', '+1-555-4004', 'lisa.davis@unitedhealth.com', '321 Benefit Blvd', '2024-01-01', '2024-12-31', 17.50, 10, '2024-01-04'),
(5, 'Humana', 'Robert Wilson', '+1-555-4005', 'robert.wilson@humana.com', '654 Care Lane', '2024-01-01', '2024-12-31', 13.75, 18, '2024-01-05'),
(6, 'Kaiser Permanente', 'Jennifer Taylor', '+1-555-4006', 'jennifer.taylor@kaiser.com', '987 Medical Way', '2024-01-01', '2024-12-31', 20.00, 7, '2024-01-06'),
(7, 'Anthem', 'Christopher Anderson', '+1-555-4007', 'christopher@anthem.com', '147 Health Ave', '2024-01-01', '2024-12-31', 11.25, 25, '2024-01-07'),
(8, 'Medicaid', 'Amanda Martinez', '+1-555-4008', 'amanda.martinez@medicaid.gov', '258 Government St', '2024-01-01', '2024-12-31', 5.00, 35, '2024-01-08'),
(9, 'Medicare', 'Daniel Thomas', '+1-555-4009', 'daniel.thomas@medicare.gov', '369 Federal Blvd', '2024-01-01', '2024-12-31', 7.50, 28, '2024-01-09'),
(10, 'Tricare', 'Laura Harris', '+1-555-4010', 'laura.harris@tricare.mil', '741 Military Ave', '2024-01-01', '2024-12-31', 10.00, 21, '2024-01-10'),
(11, 'Health Net', 'Brian Lewis', '+1-555-4011', 'brian.lewis@healthnet.com', '852 Coverage Dr', '2024-01-01', '2024-12-31', 12.50, 14, '2024-01-11'),
(12, 'Molina Healthcare', 'Nicole Young', '+1-555-4012', 'nicole.young@molina.com', '963 Insurance Rd', '2024-01-01', '2024-12-31', 8.75, 30, '2024-01-12'),
(13, 'Centene Corporation', 'Patrick Walker', '+1-555-4013', 'patrick.walker@centene.com', '174 Managed Care St', '2024-01-01', '2024-12-31', 9.50, 25, '2024-01-13'),
(14, 'WellCare', 'Jessica Green', '+1-555-4014', 'jessica.green@wellcare.com', '285 Benefit Ave', '2024-01-01', '2024-12-31', 11.25, 18, '2024-01-14'),
(15, 'Oscar Health', 'Matthew Hall', '+1-555-4015', 'matthew.hall@oscar.com', '396 Digital Blvd', '2024-01-01', '2024-12-31', 15.00, 10, '2024-01-15'),
(16, 'Bright Health', 'Stephanie King', '+1-555-4016', 'stephanie.king@bright.com', '507 Health Way', '2024-01-01', '2024-12-31', 12.50, 14, '2024-01-16'),
(17, 'Ambetter', 'Andrew Scott', '+1-555-4017', 'andrew.scott@ambetter.com', '618 Care Lane', '2024-01-01', '2024-12-31', 10.00, 21, '2024-01-17'),
(18, 'Harvard Pilgrim', 'Melissa Adams', '+1-555-4018', 'melissa.adams@harvardpilgrim.com', '729 University Ave', '2024-01-01', '2024-12-31', 17.50, 7, '2024-01-18'),
(19, 'Tufts Health Plan', 'Joshua Nelson', '+1-555-4019', 'joshua.nelson@tufts.com', '840 Academic St', '2024-01-01', '2024-12-31', 13.75, 14, '2024-01-19'),
(20, 'EmblemHealth', 'Rebecca White', '+1-555-4020', 'rebecca.white@emblemhealth.com', '951 Metro Plaza', '2024-01-01', '2024-12-31', 11.25, 18, '2024-01-20');

-- Retrieve all records from Insurance_Providers
SELECT * FROM Insurance_Providers;

-- Clear all data from Insurance_Providers table
TRUNCATE TABLE Insurance_Providers;

-- Drop Insurance_Providers table if it exists
DROP TABLE IF EXISTS Insurance_Providers;

-- TABLE 21: INSURANCE_CLAIMS
CREATE TABLE Insurance_Claims (
    claim_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT,
    provider_id INT,
    claim_date DATE,
    claim_amount DECIMAL(10,2),
    covered_amount DECIMAL(10,2),
    status VARCHAR(20),
    processed_date DATE,
    rejection_reason TEXT,
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (prescription_id) REFERENCES Prescriptions(prescription_id),
    FOREIGN KEY (provider_id) REFERENCES Insurance_Providers(provider_id)
);

-- Insert sample records
INSERT INTO Insurance_Claims VALUES
(1, 1, 1, '2024-01-15', 45.75, 36.60, 'Paid', '2024-01-29', NULL, 'Standard claim processing', '2024-01-15'),
(2, 2, 2, '2024-01-16', 23.50, 18.80, 'Paid', '2024-02-06', NULL, 'Standard claim processing', '2024-01-16'),
(3, 3, 3, '2024-01-17', 67.25, 53.80, 'Pending', NULL, NULL, 'Awaiting processing', '2024-01-17'),
(4, 4, 4, '2024-01-18', 34.00, 27.20, 'Paid', '2024-01-28', NULL, 'Fast processing', '2024-01-18'),
(5, 5, 5, '2024-01-19', 19.99, 15.99, 'Paid', '2024-02-06', NULL, 'Standard claim processing', '2024-01-19'),
(6, 6, 6, '2024-01-20', 33.75, 27.00, 'Paid', '2024-01-27', NULL, 'Fast processing', '2024-01-20'),
(7, 7, 7, '2024-01-21', 22.50, 18.00, 'Paid', '2024-02-15', NULL, 'Standard claim processing', '2024-01-21'),
(8, 8, 8, '2024-01-22', 135.00, 108.00, 'Paid', '2024-02-26', NULL, 'Longer processing time', '2024-01-22'),
(9, 9, 9, '2024-01-23', 56.25, 45.00, 'Paid', '2024-02-20', NULL, 'Standard claim processing', '2024-01-23'),
(10, 10, 10, '2024-01-24', 67.50, 54.00, 'Pending', NULL, NULL, 'Awaiting processing', '2024-01-24'),
(11, 11, 1, '2024-01-25', 26.97, 21.58, 'Paid', '2024-02-08', NULL, 'Standard claim processing', '2024-01-25'),
(12, 12, 2, '2024-01-26', 375.00, 300.00, 'Paid', '2024-02-16', NULL, 'High value claim', '2024-01-26'),
(13, 13, 3, '2024-01-27', 86.25, 69.00, 'Pending', NULL, NULL, 'Awaiting processing', '2024-01-27'),
(14, 14, 4, '2024-01-28', 42.75, 34.20, 'Paid', '2024-02-07', NULL, 'Fast processing', '2024-01-28'),
(15, 15, 5, '2024-01-29', 255.00, 204.00, 'Paid', '2024-02-16', NULL, 'High value claim', '2024-01-29'),
(16, 16, 6, '2024-01-30', 106.50, 85.20, 'Pending', NULL, NULL, 'Awaiting processing', '2024-01-30'),
(17, 17, 7, '2024-01-31', 41.25, 33.00, 'Paid', '2024-02-14', NULL, 'Standard claim processing', '2024-01-31'),
(18, 18, 8, '2024-02-01', 1950.00, 1560.00, 'Pending', NULL, NULL, 'Special review required', '2024-02-01'),
(19, 19, 9, '2024-02-02', 97.50, 78.00, 'Pending', NULL, NULL, 'Awaiting processing', '2024-02-02'),
(20, 20, 10, '2024-02-03', 15.75, 12.60, 'Paid', '2024-02-10', NULL, 'Fast processing', '2024-02-03');

-- Retrieve all records from Insurance_Claims
SELECT * FROM Insurance_Claims;

-- Clear all data from Insurance_Claims table
TRUNCATE TABLE Insurance_Claims;

-- Drop Insurance_Claims table if it exists
DROP TABLE IF EXISTS Insurance_Claims;


-- TABLE 22: PATIENT_MEDICAL_HISTORY
CREATE TABLE Patient_Medical_History (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    condition_name VARCHAR(100),
    diagnosis_date DATE,
    severity VARCHAR(20),
    current_status VARCHAR(20),
    treatment_description TEXT,
    doctor_name VARCHAR(100),
    doctor_contact VARCHAR(50),
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert sample records
INSERT INTO Patient_Medical_History VALUES
(1, 1, 'Hypertension', '2020-05-10', 'Moderate', 'Controlled', 'Lisinopril 10mg daily', 'Dr. Sarah Johnson', '+1-555-5001', 'Regular monitoring needed', '2024-01-01'),
(2, 2, 'Type 2 Diabetes', '2019-08-15', 'Mild', 'Controlled', 'Metformin 500mg twice daily', 'Dr. Michael Chen', '+1-555-5002', 'Monitor blood sugar levels', '2024-01-02'),
(3, 3, 'High Cholesterol', '2021-03-22', 'Moderate', 'Controlled', 'Atorvastatin 20mg daily', 'Dr. Emily Davis', '+1-555-5003', 'Annual lipid panel required', '2024-01-03'),
(4, 4, 'Asthma', '2018-11-05', 'Moderate', 'Active', 'Albuterol inhaler as needed', 'Dr. David Wilson', '+1-555-5004', 'Seasonal exacerbations', '2024-01-04'),
(5, 5, 'Hypothyroidism', '2017-06-18', 'Mild', 'Controlled', 'Levothyroxine 50mcg daily', 'Dr. Lisa Anderson', '+1-555-5005', 'Annual TSH testing', '2024-01-05'),
(6, 6, 'Migraine', '2020-09-30', 'Severe', 'Active', 'Sumatriptan as needed', 'Dr. James Taylor', '+1-555-5006', 'Trigger: stress, weather changes', '2024-01-06'),
(7, 7, 'GERD', '2019-04-12', 'Moderate', 'Controlled', 'Omeprazole 20mg daily', 'Dr. Anna Garcia', '+1-555-5007', 'Avoid spicy foods', '2024-01-07'),
(8, 8, 'Allergic Rhinitis', '2021-07-25', 'Mild', 'Seasonal', 'Loratadine as needed', 'Dr. Robert Miller', '+1-555-5008', 'Worse in spring and fall', '2024-01-08'),
(9, 9, 'Anxiety Disorder', '2020-02-14', 'Moderate', 'Controlled', 'Sertraline 50mg daily', 'Dr. Jennifer Lee', '+1-555-5009', 'Regular therapy sessions', '2024-01-09'),
(10, 10, 'Osteoarthritis', '2018-12-03', 'Moderate', 'Active', 'Celecoxib 200mg as needed', 'Dr. Christopher White', '+1-555-5010', 'Knee joints affected', '2024-01-10'),
(11, 11, 'Psoriasis', '2019-10-08', 'Mild', 'Active', 'Topical corticosteroids', 'Dr. Michelle Clark', '+1-555-5011', 'Localized to elbows', '2024-01-11'),
(12, 12, 'Breast Cancer', '2021-01-15', 'Severe', 'In Treatment', 'Tamoxifen 20mg daily', 'Dr. Kevin Rodriguez', '+1-555-5012', 'Post-surgery, in remission', '2024-01-12'),
(13, 13, 'Depression', '2020-07-22', 'Moderate', 'Controlled', 'Sertraline 50mg daily', 'Dr. Amanda Martinez', '+1-555-5013', 'Improved with medication', '2024-01-13'),
(14, 14, 'Glaucoma', '2019-05-19', 'Moderate', 'Controlled', 'Latanoprost eye drops nightly', 'Dr. Steven Thomas', '+1-555-5014', 'Regular eye pressure checks', '2024-01-14'),
(15, 15, 'Peanut Allergy', '2018-08-11', 'Severe', 'Active', 'Epinephrine auto-injector', 'Dr. Rachel Harris', '+1-555-5015', 'Carry EpiPen at all times', '2024-01-15'),
(16, 16, 'Chronic Back Pain', '2020-04-27', 'Moderate', 'Active', 'Gabapentin 300mg as needed', 'Dr. Daniel Lewis', '+1-555-5016', 'Physical therapy recommended', '2024-01-16'),
(17, 17, 'Seasonal Allergies', '2021-03-15', 'Mild', 'Seasonal', 'Cetirizine as needed', 'Dr. Laura Young', '+1-555-5017', 'Spring and fall symptoms', '2024-01-17'),
(18, 18, 'Eczema', '2019-11-20', 'Moderate', 'Active', 'Hydrocortisone cream', 'Dr. Brian Walker', '+1-555-5018', 'Avoid harsh soaps', '2024-01-18'),
(19, 19, 'Gout', '2020-06-08', 'Moderate', 'Controlled', 'Allopurinol 100mg daily', 'Dr. Nicole Green', '+1-555-5019', 'Avoid high-purine foods', '2024-01-19'),
(20, 20, 'Vitamin D Deficiency', '2021-02-12', 'Mild', 'Controlled', 'Vitamin D3 1000IU daily', 'Dr. Patricia Hall', '+1-555-5020', 'Annual vitamin D test', '2024-01-20');

-- Retrieve all records from Patient_Medical_History
SELECT * FROM Patient_Medical_History;

-- Clear all data from Patient_Medical_History table
TRUNCATE TABLE Patient_Medical_History;

-- Drop Patient_Medical_History table if it exists
DROP TABLE IF EXISTS Patient_Medical_History;

-- TABLE 23: DRUG_INTERACTIONS
CREATE TABLE Drug_Interactions (
    interaction_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id1 INT,
    product_id2 INT,
    interaction_type VARCHAR(50),
    severity VARCHAR(20),
    description TEXT,
    management_guidance TEXT,
    reference_source VARCHAR(0100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id1) REFERENCES Products(product_id),
    FOREIGN KEY (product_id2) REFERENCES Products(product_id)
);

-- Insert sample records
INSERT INTO Drug_Interactions VALUES
(1, 1, 2, 'Pharmacokinetic', 'Moderate', 'Amoxicillin may decrease the effectiveness of ibuprofen', 'Monitor for reduced pain relief; consider alternative pain reliever', 'Micromedex', '2024-01-01'),
(2, 3, 4, 'Pharmacodynamic', 'Major', 'Lisinopril and metformin may increase risk of lactic acidosis', 'Monitor renal function and electrolytes regularly', 'Lexicomp', '2024-01-02'),
(3, 5, 6, 'Pharmacokinetic', 'Minor', 'Vitamin D may increase absorption of acetaminophen', 'No action needed, but be aware of potential increased effect', 'Clinical Pharmacology', '2024-01-03'),
(4, 7, 8, 'Pharmacodynamic', 'Moderate', 'Hydrocortisone cream may reduce effectiveness of albuterol', 'Space applications by at least 2 hours', 'Drugs.com', '2024-01-04'),
(5, 9, 10, 'Pharmacokinetic', 'Major', 'Omeprazole may decrease gabapentin absorption', 'Administer gabapentin at least 2 hours before omeprazole', 'Micromedex', '2024-01-05'),
(6, 11, 12, 'Pharmacodynamic', 'Moderate', 'Children Tylenol may increase bleeding risk with tamoxifen', 'Monitor for bruising or bleeding', 'Lexicomp', '2024-01-06'),
(7, 13, 14, 'Pharmacokinetic', 'Major', 'Sertraline may increase prednisone levels', 'Reduce prednisone dose if signs of toxicity appear', 'Clinical Pharmacology', '2024-01-07'),
(8, 15, 16, 'Pharmacodynamic', 'Moderate', 'Latanoprost may increase effects of celecoxib on blood pressure', 'Monitor blood pressure regularly', 'Drugs.com', '2024-01-08'),
(9, 17, 18, 'Pharmacokinetic', 'Major', 'Levothyroxine absorption reduced by epinephrine', 'Administer levothyroxine 4 hours apart from epinephrine', 'Micromedex', '2024-01-09'),
(10, 19, 20, 'Pharmacodynamic', 'Minor', 'Azithromycin may slightly increase aspirin levels', 'Monitor for aspirin side effects', 'Lexicomp', '2024-01-10'),
(11, 1, 3, 'Pharmacokinetic', 'Moderate', 'Amoxicillin may increase lisinopril effects', 'Monitor blood pressure closely', 'Clinical Pharmacology', '2024-01-11'),
(12, 2, 4, 'Pharmacodynamic', 'Major', 'Ibuprofen may decrease metformin effectiveness', 'Consider alternative pain reliever', 'Drugs.com', '2024-01-12'),
(13, 5, 7, 'Pharmacokinetic', 'Minor', 'Vitamin D may increase hydrocortisone absorption', 'Monitor for increased steroid effects', 'Micromedex', '2024-01-13'),
(14, 6, 8, 'Pharmacodynamic', 'Moderate', 'Tylenol Cold may increase heart rate with albuterol', 'Monitor for tachycardia', 'Lexicomp', '2024-01-14'),
(15, 9, 11, 'Pharmacokinetic', 'Major', 'Omeprazole may increase acetaminophen levels in children', 'Use lower pediatric dose of acetaminophen', 'Clinical Pharmacology', '2024-01-15'),
(16, 10, 12, 'Pharmacodynamic', 'Moderate', 'Gabapentin may increase tamoxifen side effects', 'Monitor for increased CNS depression', 'Drugs.com', '2024-01-16'),
(17, 13, 15, 'Pharmacokinetic', 'Major', 'Sertraline may increase latanoprost effects', 'Monitor eye pressure closely', 'Micromedex', '2024-01-17'),
(18, 14, 16, 'Pharmacodynamic', 'Moderate', 'Prednisone may decrease celecoxib effectiveness', 'Consider higher NSAID dose if needed', 'Lexicomp', '2024-01-18'),
(19, 17, 19, 'Pharmacokinetic', 'Minor', 'Levothyroxine may decrease azithromycin absorption', 'Space doses by 4 hours', 'Clinical Pharmacology', '2024-01-19'),
(20, 18, 20, 'Pharmacodynamic', 'Moderate', 'Epinephrine may increase aspirin bleeding risk', 'Monitor for signs of bleeding', 'Drugs.com', '2024-01-20');

-- Retrieve all records from Drug_Interactions
SELECT * FROM Drug_Interactions;

-- Clear all data from Drug_Interactions table
TRUNCATE TABLE Drug_Interactions;

-- Drop Drug_Interactions table if it exists
DROP TABLE IF EXISTS Drug_Interactions;

-- TABLE 24: INVENTORY_ADJUSTMENTS
CREATE TABLE Inventory_Adjustments (
    adjustment_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    adjustment_date DATE,
    quantity_adjusted INT,
    reason VARCHAR(100),
    adjusted_by INT,
    adjustment_type VARCHAR(20),
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (adjusted_by) REFERENCES Employees(employee_id)
);

-- Insert sample records
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
(10, 10, '2024-07-10', 5, 'Return processed', 101, 'Gain', 'Customer return', '2024-07-10'),
(11, 11, '2024-07-11', -3, 'Expired batch', 102, 'Loss', 'Disposed per regulation', '2024-07-11'),
(12, 12, '2024-07-12', 4, 'Found stock', 103, 'Gain', 'Backroom discovery', '2024-07-12'),
(13, 13, '2024-07-13', -2, 'Lost in transit', 101, 'Loss', 'Supplier notified', '2024-07-13'),
(14, 14, '2024-07-14', 9, 'Donation received', 102, 'Gain', 'Charity donation', '2024-07-14'),
(15, 15, '2024-07-15', -6, 'Contaminated', 103, 'Loss', 'Quarantined', '2024-07-15'),
(16, 16, '2024-07-16', 3, 'Error correction', 101, 'Gain', 'System glitch fixed', '2024-07-16'),
(17, 17, '2024-07-17', -4, 'Theft suspected', 102, 'Loss', 'Under investigation', '2024-07-17'),
(18, 18, '2024-07-18', 7, 'Supplier bonus', 103, 'Gain', 'Promotional stock', '2024-07-18'),
(19, 19, '2024-07-19', -5, 'Expired', 101, 'Loss', 'Removed from stock', '2024-07-19'),
(20, 20, '2024-07-20', 2, 'Return accepted', 102, 'Gain', 'Customer return', '2024-07-20');

-- Retrieve all records from Inventory_Adjustments
SELECT * FROM Inventory_Adjustments;

-- Clear all data from Inventory_Adjustments table
TRUNCATE TABLE Inventory_Adjustments;

-- Drop Inventory_Adjustments table if it exists
DROP TABLE IF EXISTS Inventory_Adjustments;

-- TABLE 25: NOTIFICATIONS
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    notification_type VARCHAR(50) NOT NULL,
    related_id INT,
    message TEXT,
    priority VARCHAR(20),
    status VARCHAR(20),
    created_for INT,
    created_by INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_date TIMESTAMP NULL,
    FOREIGN KEY (created_for) REFERENCES Employees(employee_id),
    FOREIGN KEY (created_by) REFERENCES Employees(employee_id)
);

-- Insert sample records
INSERT INTO Notifications VALUES
(1, 'Low Stock', 1, 'Amoxicillin 500mg is below reorder level (50 remaining)', 'High', 'Pending', 104, 106, '2024-01-15', NULL),
(2, 'Expiry Alert', 8, 'Albuterol Inhaler batch BATCH008 expires in 4 months', 'Medium', 'Pending', 104, 106, '2024-01-16', NULL),
(3, 'Order Received', 1, 'Purchase order #1 has been delivered', 'Low', 'Resolved', 107, 106, '2024-01-16', '2024-01-17'),
(4, 'Prescription Ready', 1, 'Prescription #1 is ready for pickup', 'Medium', 'Resolved', 101, 103, '2024-01-15', '2024-01-15'),
(5, 'Insurance Claim', 1, 'Insurance claim for prescription #1 has been processed', 'Low', 'Resolved', 101, 106, '2024-01-29', '2024-01-30'),
(6, 'Inventory Discrepancy', 12, 'Tamoxifen count differs by 2 units in physical count', 'High', 'Pending', 104, 104, '2024-01-26', NULL),
(7, 'Scheduled Maintenance', NULL, 'System maintenance scheduled for tonight at 2 AM', 'Medium', 'Resolved', 112, 112, '2024-01-10', '2024-01-11'),
(8, 'New Employee', 120, 'New pharmacist Jason Clark has been added to system', 'Low', 'Resolved', 117, 106, '2024-01-20', '2024-01-21'),
(9, 'Vendor Contract', 5, 'Cleaning services contract expires in 30 days', 'Medium', 'Pending', 107, 106, '2024-12-01', NULL),
(10, 'Security Alert', NULL, 'Unauthorized access attempt detected', 'High', 'Resolved', 116, 112, '2024-01-18', '2024-01-18'),
(11, 'Training Required', NULL, 'Annual compliance training due by end of month', 'Medium', 'Pending', 117, 106, '2024-01-25', NULL),
(12, 'Equipment Failure', NULL, 'Barcode scanner in pharmacy not working', 'High', 'Resolved', 118, 104, '2024-01-22', '2024-01-23'),
(13, 'Patient Allergy', 1, 'Patient John Doe has penicillin allergy', 'High', 'Resolved', 101, 101, '2024-01-15', '2024-01-15'),
(14, 'Drug Interaction', 1, 'Potential interaction between prescribed medications', 'High', 'Resolved', 101, 101, '2024-01-15', '2024-01-15'),
(15, 'Delivery Scheduled', 18, 'Emergency medication delivery scheduled for tomorrow', 'Medium', 'Resolved', 114, 107, '2024-01-31', '2024-02-01'),
(16, 'Payment Received', 1, 'Payment received for sale #1', 'Low', 'Resolved', 106, 105, '2024-01-15', '2024-01-16'),
(17, 'System Update', NULL, 'Pharmacy software update available', 'Medium', 'Pending', 112, 112, '2024-02-03', NULL),
(18, 'Staff Meeting', NULL, 'Monthly staff meeting tomorrow at 9 AM', 'Medium', 'Resolved', 106, 106, '2024-01-14', '2024-01-15'),
(19, 'Temperature Alert', NULL, 'Refrigerator temperature out of range', 'High', 'Resolved', 104, 104, '2024-01-28', '2024-01-28'),
(20, 'Customer Complaint', 5, 'Customer complaint regarding service', 'High', 'Resolved', 113, 106, '2024-01-19', '2024-01-20');

-- Retrieve all records from Notifications
SELECT * FROM Notifications;

-- Clear all data from Notifications table
TRUNCATE TABLE Notifications;

-- Drop Notifications table if it exists
DROP TABLE IF EXISTS Notifications;

