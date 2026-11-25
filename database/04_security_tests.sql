-- ============================================================
-- FINWISELY: DATABASE SECURITY TEST PLAN
-- Purpose: Verify access control, integrity and audit logging.
-- IMPORTANT: Run each test using the specified MySQL account.
-- Requires the schema and sample data to be installed first.
-- ============================================================


-- ============================================================
-- TEST GROUP A: ADMINISTRATOR
-- Log in as administrator before running these checks.
-- ============================================================

USE finwisely;

-- A1. Administrator should be able to view all customers.
SELECT * FROM customers;

-- A2. Administrator should be able to inspect all accounts.
SELECT * FROM accounts;

-- A3. Administrator should be able to inspect audit records.
SELECT * FROM audit_logs;


-- ============================================================
-- TEST GROUP B: TELLER - PERMITTED OPERATIONS
-- Log in as teller before running these checks.
-- ============================================================

USE finwisely;

-- B1. EXPECTED: SUCCESS
-- Teller can view customer records.
SELECT * FROM customers;

-- B2. EXPECTED: SUCCESS
-- Teller can view account records.
SELECT * FROM accounts;

-- B3. EXPECTED: SUCCESS
-- Teller can view transaction history.
SELECT * FROM transactions;

-- B4. EXPECTED: SUCCESS
-- Teller can update the balance column only.
-- This test uses a transaction and rolls it back.
-- No permanent balance or audit record change remains.

START TRANSACTION;

UPDATE accounts
SET balance = balance + 1.00
WHERE account_id = 2001;

INSERT INTO transactions
(account_id, transaction_type, amount, performed_by)
VALUES
(2001, 'DEPOSIT', 1.00, 'teller_security_test');

-- Check that the trigger generated an audit record
-- inside this transaction.
SELECT *
FROM audit_logs
WHERE username = 'teller_security_test'
ORDER BY log_id DESC
LIMIT 1;

ROLLBACK;

-- EXPECTED: The test transaction and its audit record
-- are both rolled back.


-- ============================================================
-- TEST GROUP C: TELLER - DENIED OPERATIONS
-- Continue logged in as teller.
-- Run each statement separately.
-- Each statement below is EXPECTED TO FAIL.
-- ============================================================

-- C1. Teller must not change account status.
-- EXPECTED: Permission denied.
UPDATE accounts
SET status = 'FROZEN'
WHERE account_id = 2001;

-- C2. Teller must not change account ownership.
-- EXPECTED: Permission denied.
UPDATE accounts
SET customer_id = 1002
WHERE account_id = 2001;

-- C3. Teller must not delete customer records.
-- EXPECTED: Permission denied.
DELETE FROM customers
WHERE customer_id = 1001;

-- C4. Teller must not delete transaction history.
-- EXPECTED: Permission denied.
DELETE FROM transactions
WHERE transaction_id = 3001;

-- C5. Teller must not modify audit records directly.
-- EXPECTED: Permission denied.
INSERT INTO audit_logs
(username, action, table_name, record_id,
 account_id, transaction_type, amount)
VALUES
('unauthorized_test', 'INSERT', 'transactions',
 9999, 2001, 'DEPOSIT', 100.00);


-- ============================================================
-- TEST GROUP D: AUDITOR
-- Log out and reconnect as auditor before these checks.
-- ============================================================

USE finwisely;

-- D1. EXPECTED: SUCCESS
-- Auditor can inspect customer information.
SELECT * FROM customers;

-- D2. EXPECTED: SUCCESS
-- Auditor can inspect account balances.
SELECT * FROM accounts;

-- D3. EXPECTED: SUCCESS
-- Auditor can inspect transaction history.
SELECT * FROM transactions;

-- D4. EXPECTED: SUCCESS
-- Auditor can inspect audit logs.
SELECT * FROM audit_logs;

-- D5. EXPECTED: FAILURE
-- Auditor cannot update account balances.
UPDATE accounts
SET balance = balance + 100.00
WHERE account_id = 2001;

-- D6. EXPECTED: FAILURE
-- Auditor cannot insert transactions.
INSERT INTO transactions
(account_id, transaction_type, amount, performed_by)
VALUES
(2001, 'DEPOSIT', 100.00, 'auditor_test');

-- D7. EXPECTED: FAILURE
-- Auditor cannot delete customer records.
DELETE FROM customers
WHERE customer_id = 1001;


-- ============================================================
-- TEST GROUP E: DATA INTEGRITY
-- Log in as administrator before running these tests.
-- Each invalid statement is EXPECTED TO FAIL.
-- Run statements individually.
-- ============================================================

USE finwisely;

-- E1. EXPECTED: CHECK constraint violation.
-- Transaction amount cannot be zero.
INSERT INTO transactions
(account_id, transaction_type, amount, performed_by)
VALUES
(2001, 'DEPOSIT', 0.00, 'integrity_test');

-- E2. EXPECTED: CHECK constraint violation.
-- Transaction amount cannot be negative.
INSERT INTO transactions
(account_id, transaction_type, amount, performed_by)
VALUES
(2001, 'DEPOSIT', -50.00, 'integrity_test');

-- E3. EXPECTED: CHECK constraint violation.
-- Account balance cannot be negative.
UPDATE accounts
SET balance = -100.00
WHERE account_id = 2001;

-- E4. EXPECTED: CHECK constraint violation.
-- Unsupported transaction types are rejected.
INSERT INTO transactions
(account_id, transaction_type, amount, performed_by)
VALUES
(2001, 'INVALID_TYPE', 100.00, 'integrity_test');

-- E5. EXPECTED: Foreign key violation.
-- An account cannot reference a customer that does not exist.
INSERT INTO accounts
(customer_id, account_type, balance, status)
VALUES
(999999, 'Savings', 100.00, 'ACTIVE');


-- ============================================================
-- TEST GROUP F: AUDIT VERIFICATION
-- Log in as administrator after the tests.
-- ============================================================

USE finwisely;

-- Inspect the most recent audit events.
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
ORDER BY action_time DESC
LIMIT 20;

-- Compare transaction and audit record counts.
SELECT
    (SELECT COUNT(*) FROM transactions) AS transaction_count,
    (SELECT COUNT(*) FROM audit_logs) AS audit_count;

-- Inspect the permissions assigned to each role.
SHOW GRANTS FOR 'administrator_role';
SHOW GRANTS FOR 'teller_role';
SHOW GRANTS FOR 'auditor_role';


-- ============================================================
-- END OF SECURITY TEST PLAN
-- Record each result as PASS or FAIL in the project report.
-- ============================================================
