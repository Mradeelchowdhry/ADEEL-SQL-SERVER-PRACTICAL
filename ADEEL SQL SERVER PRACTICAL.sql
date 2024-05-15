-- Create Medicines table
CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100),
    manufacturer VARCHAR(100),
    price DECIMAL(10, 2),
    quantity_in_stock INT
);

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- Create Orders table
CREATE TABLE CustomerOrders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create Order_Details table
CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    medicine_id INT,
    quantity INT,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES CustomerOrders(order_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);
-- Insert into Medicines table
INSERT INTO Medicines (medicine_id, name, manufacturer, price, quantity_in_stock)
VALUES
    (1, 'Medicine 1', 'Manufacturer A', 10.50, 20),
    (2, 'Medicine 2', 'Manufacturer B', 15.75, 30);
    -- Add more values here, up to a maximum of 50

-- Insert into Customers table
INSERT INTO Customers (customer_id, name, email, phone)
VALUES
    (1, 'Customer 1', 'customer1@example.com', '1234567890'),
    (2, 'Customer 2', 'customer2@example.com', '9876543210');
    -- Add more values here, up to a maximum of 50

-- Insert into Orders table
INSERT INTO CustomerOrders (order_id, customer_id, order_date)
VALUES
    (1, 1, '2024-01-05'),
    (2, 2, '2024-02-10');
    -- Add more values here, up to a maximum of 50

-- Insert into Order_Details table
INSERT INTO Order_Details (order_detail_id, order_id, medicine_id, quantity, total_price)
VALUES
    (1, 1, 1, 2, 21.00),
    (2, 2, 2, 3, 47.25);
    -- Add more values here, up to a maximum of 50

-- Create a view to display the names and prices of medicines in stock
CREATE VIEW MedicinesInStock AS
SELECT name, price
FROM Medicines
WHERE quantity_in_stock > 0;

-- Retrieve the names of customers along with their email addresses who have placed an order after January 1, 2024
SELECT c.name, c.email
FROM Customers c
JOIN CustomerOrders o ON c.customer_id = o.customer_id
WHERE o.order_date > '2024-01-01';

-- List all orders with the total price of each order
SELECT o.order_id, SUM(od.total_price) AS total_price
FROM CustomerOrders o
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY o.order_id;

-- Find the total number of orders placed by each customer
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN CustomerOrders o ON c.customer_id = o.customer_id
GROUP BY c.name;


-- Trigger to update the quantity of medicines in stock after an order is placed
CREATE TRIGGER UpdateStockAfterOrder
ON Order_Details
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Medicines
    SET quantity_in_stock = quantity_in_stock - (SELECT quantity FROM INSERTED)
    WHERE medicine_id IN (SELECT medicine_id FROM INSERTED);
END;


-- Retrieve the total number of customers who have ordered more than 5 times
SELECT COUNT(customer_id) AS num_customers
FROM (
    SELECT customer_id
    FROM CustomerOrders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 5
) AS subquery;

SELECT * FROM customers;
