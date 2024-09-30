CREATE DATABASE loan_management_system;

USE loan_management_system;

CREATE TABLE customers (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    account_no BIGINT NOT NULL UNIQUE,
    balance DECIMAL(10,2) NOT NULL,
    loan_no INT,
    credit_score INT NOT NULL,
    eligible_for_loan BOOLEAN NOT NULL
);

CREATE TABLE loans (
    loan_no INT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    total_loan_amount DECIMAL(10,2) NOT NULL,
    loan_repaid DECIMAL(10,2) DEFAULT 0,
    loan_remaining DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    loan_granted_date DATE NOT NULL
);

INSERT INTO customers (user_name, account_no, balance, loan_no, credit_score, eligible_for_loan) VALUES
('Ravi Sharma', 12345678901, 50000.00, NULL, 750, TRUE),
('Sneha Gupta', 12345678902, 10000.00, 1, 600, TRUE),
('Vikram Singh', 12345678903, 25000.00, 2, 580, TRUE),
('Pooja Patel', 12345678904, 5000.00, NULL, 800, TRUE),
('Amit Kumar', 12345678905, 70000.00, 3, 670, FALSE),
('Arjun Rao', 12345678906, 120000.00, 4, 820, TRUE),
('Isha Mehta', 12345678907, 35000.00, NULL, 710, TRUE),
('Rahul Desai', 12345678908, 2000.00, NULL, 450, FALSE),
('Nisha Jain', 12345678909, 15000.00, NULL, 650, TRUE),
('Rajesh Verma', 12345678910, 45000.00, 5, 720, TRUE);

INSERT INTO loans (loan_no, user_name, total_loan_amount, loan_repaid, loan_remaining, due_date, loan_granted_date) VALUES
(1, 'Sneha Gupta', 20000.00, 5000.00, 15000.00, '2025-01-01', '2023-01-01'),
(2, 'Vikram Singh', 15000.00, 7000.00, 8000.00, '2024-06-01', '2023-03-01'),
(3, 'Amit Kumar', 50000.00, 10000.00, 40000.00, '2025-12-01', '2023-06-01'),
(4, 'Arjun Rao', 100000.00, 50000.00, 50000.00, '2026-12-31', '2023-08-01'),
(5, 'Rajesh Verma', 30000.00, 10000.00, 20000.00, '2024-12-01', '2023-09-01');

SELECT customers.user_name, customers.account_no, loans.total_loan_amount, loans.loan_remaining 
FROM customers 
JOIN loans ON customers.loan_no = loans.loan_no 
WHERE loans.loan_remaining > 0;

