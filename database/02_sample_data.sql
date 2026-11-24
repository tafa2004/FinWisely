USE finwisely;

-- Customers
INSERT INTO customers
(first_name, last_name, email, phone, national_id)
VALUES
('John', 'Banda', 'johnbanda@email.com', '+260967788948', '789011/24/1'),
('Mary', 'Phiri', 'maryphiri@email.com', '+260971674589', '346712/29/1'),
('Brian', 'Tembo', 'briantembo@email.com', '+260954906754', '345690/23/1'),
('Grace', 'Mwansa', 'gracemwansa@email.com', '+260578452345', '265783/45/1'),
('Peter', 'Zulu', 'peterzulu@email.com', '+260960137469', '107449/29/1');

-- Accounts (balances = opening deposit +/- the later transactions)
INSERT INTO accounts
(customer_id, account_type, balance, status)
VALUES
(1, 'Savings',  4500.00, 'ACTIVE'),   -- 5000 - 500
(2, 'Current', 10000.00, 'ACTIVE'),   -- 12000 - 2000
(3, 'Savings',  4500.00, 'ACTIVE'),   -- 3000 + 1500
(4, 'Current', 22000.00, 'ACTIVE'),   -- 25000 - 3000
(5, 'Savings',  7000.00, 'ACTIVE');   -- 8000 - 1000

-- Transactions: opening deposits first, then later activity
INSERT INTO transactions
(account_id, transaction_type, amount, performed_by)
VALUES
(1, 'DEPOSIT',     5000.00, 'teller'),
(2, 'DEPOSIT',    12000.00, 'teller'),
(3, 'DEPOSIT',     3000.00, 'teller'),
(4, 'DEPOSIT',    25000.00, 'teller'),
(5, 'DEPOSIT',     8000.00, 'teller'),
(1, 'WITHDRAWAL',   500.00, 'teller'),
(2, 'WITHDRAWAL',  2000.00, 'teller'),
(3, 'DEPOSIT',     1500.00, 'teller'),
(4, 'TRANSFER',    3000.00, 'teller'),
(5, 'WITHDRAWAL',  1000.00, 'teller');