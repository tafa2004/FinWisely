-- ============================================================
-- FINWISELY: FICTIONAL DEMONSTRATION DATA
-- For academic testing only. No real customer or banking data.
-- Run after 01_create_tables.sql.
-- INSERT IGNORE prevents duplicate demo records on reruns.
-- ============================================================

USE finwisely;

START TRANSACTION;

-- ------------------------------------------------------------
-- 1. FICTIONAL CUSTOMERS
-- ------------------------------------------------------------

INSERT IGNORE INTO customers
(customer_id, first_name, last_name, email, phone, national_id)
VALUES
(1001, 'John', 'Banda', 'john.banda@example.test', '+260970000001', 'DEMO-ID-1001'),
(1002, 'Mary', 'Phiri', 'mary.phiri@example.test', '+260970000002', 'DEMO-ID-1002'),
(1003, 'Peter', 'Zulu', 'peter.zulu@example.test', '+260970000003', 'DEMO-ID-1003'),
(1004, 'Grace', 'Moyo', 'grace.moyo@example.test', '+260970000004', 'DEMO-ID-1004'),
(1005, 'David', 'Tembo', 'david.tembo@example.test', '+260970000005', 'DEMO-ID-1005');


-- ------------------------------------------------------------
-- 2. FICTIONAL BANK ACCOUNTS
-- Balances represent the result of the transactions below.
-- ------------------------------------------------------------

INSERT IGNORE INTO accounts
(account_id, customer_id, account_type, balance, status)
VALUES
(2001, 1001, 'Savings',  4500.00, 'ACTIVE'),
(2002, 1002, 'Current', 10000.00, 'ACTIVE'),
(2003, 1003, 'Savings',  4500.00, 'ACTIVE'),
(2004, 1004, 'Current', 22000.00, 'ACTIVE'),
(2005, 1005, 'Savings',  7000.00, 'ACTIVE');


-- ------------------------------------------------------------
-- 3. FICTIONAL TRANSACTION HISTORY
-- The audit trigger automatically records each new transaction.
-- ------------------------------------------------------------

INSERT IGNORE INTO transactions
(transaction_id, account_id, transaction_type, amount, performed_by)
VALUES
(3001, 2001, 'DEPOSIT',    5000.00, 'demo_teller'),
(3002, 2001, 'WITHDRAWAL',  500.00, 'demo_teller'),

(3003, 2002, 'DEPOSIT',   12000.00, 'demo_teller'),
(3004, 2002, 'WITHDRAWAL', 2000.00, 'demo_teller'),

(3005, 2003, 'DEPOSIT',    3000.00, 'demo_teller'),
(3006, 2003, 'DEPOSIT',    1500.00, 'demo_teller'),

(3007, 2004, 'DEPOSIT',   25000.00, 'demo_teller'),
(3008, 2004, 'WITHDRAWAL', 3000.00, 'demo_teller'),

(3009, 2005, 'DEPOSIT',    8000.00, 'demo_teller'),
(3010, 2005, 'WITHDRAWAL', 1000.00, 'demo_teller');

COMMIT;


-- ------------------------------------------------------------
-- 4. VERIFICATION QUERIES
-- ------------------------------------------------------------

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.account_id,
    a.account_type,
    a.balance,
    a.status
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE c.customer_id BETWEEN 1001 AND 1005
ORDER BY a.account_id;


SELECT
    transaction_id,
    account_id,
    transaction_type,
    amount,
    performed_by,
    transaction_date
FROM transactions
WHERE transaction_id BETWEEN 3001 AND 3010
ORDER BY transaction_id;


SELECT
    log_id,
    username,
    action,
    table_name,
    record_id,
    account_id,
    transaction_type,
    amount,
    action_time
FROM audit_logs
WHERE record_id BETWEEN 3001 AND 3010
ORDER BY log_id;


-- ------------------------------------------------------------
-- 5. BALANCE RECONCILIATION
-- Compares stored account balances with transaction totals.
-- A zero difference indicates consistency for this demo data.
-- ------------------------------------------------------------

SELECT
    a.account_id,
    a.balance AS stored_balance,
    COALESCE(
        SUM(
            CASE
                WHEN t.transaction_type = 'DEPOSIT' THEN t.amount
                WHEN t.transaction_type = 'WITHDRAWAL' THEN -t.amount
                ELSE 0
            END
        ), 0
    ) AS calculated_balance,
    a.balance - COALESCE(
        SUM(
            CASE
                WHEN t.transaction_type = 'DEPOSIT' THEN t.amount
                WHEN t.transaction_type = 'WITHDRAWAL' THEN -t.amount
                ELSE 0
            END
        ), 0
    ) AS difference
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id
WHERE a.account_id BETWEEN 2001 AND 2005
GROUP BY a.account_id, a.balance
ORDER BY a.account_id;

