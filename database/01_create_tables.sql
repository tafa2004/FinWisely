-- ============================================================
-- FINWISELY: SECURE DIGITAL BANKING TRANSACTION SYSTEM
-- Database: finwisely
-- Purpose: Secure storage and management of banking records
-- Security principles: Confidentiality, Integrity, Accountability
-- Storage engine: InnoDB
-- ============================================================

CREATE DATABASE IF NOT EXISTS finwisely
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE finwisely;

-- ============================================================
-- 1. CUSTOMERS
-- Stores customer information.
-- Unique constraints prevent duplicate email addresses and IDs.
-- ============================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    national_id VARCHAR(20) NOT NULL UNIQUE,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_customer_name (last_name, first_name)
) ENGINE=InnoDB;


-- ============================================================
-- 2. ACCOUNTS
-- Stores customer bank accounts and their balances.
-- CHECK constraints protect financial data integrity.
-- ============================================================

CREATE TABLE IF NOT EXISTS accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_balance
        CHECK (balance >= 0.00),

    CONSTRAINT chk_account_type
        CHECK (account_type IN ('Savings', 'Current')),

    CONSTRAINT chk_account_status
        CHECK (status IN ('ACTIVE', 'FROZEN', 'CLOSED')),

    INDEX idx_account_customer (customer_id),
    INDEX idx_account_status (status)
) ENGINE=InnoDB;


-- ============================================================
-- 3. TRANSACTIONS
-- Records deposits and withdrawals.
-- Positive amounts only; the transaction type is restricted.
-- ============================================================

CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    performed_by VARCHAR(50) NOT NULL,

    CONSTRAINT fk_transactions_account
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_transaction_amount
        CHECK (amount > 0.00),

    CONSTRAINT chk_transaction_type
        CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAWAL')),

    INDEX idx_transaction_account (account_id),
    INDEX idx_transaction_date (transaction_date),
    INDEX idx_transaction_actor (performed_by)
) ENGINE=InnoDB;


-- ============================================================
-- 4. AUDIT LOGS
-- Maintains a record of every successfully inserted transaction.
-- Captures the application-level actor and transaction details.
-- Audit records support accountability and investigation.
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    action VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    account_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    action_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_audit_username (username),
    INDEX idx_audit_time (action_time),
    INDEX idx_audit_account (account_id)
) ENGINE=InnoDB;


-- ============================================================
-- 5. AUTOMATED TRANSACTION AUDIT TRIGGER
-- Automatically records a transaction after it is inserted.
-- NEW.performed_by identifies the application-level actor.
-- The trigger executes as part of the transaction, so its audit
-- insert is rolled back if the parent transaction is rolled back.
-- ============================================================

DROP TRIGGER IF EXISTS trg_transactions_insert;

DELIMITER //

CREATE TRIGGER trg_transactions_insert
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (
        username,
        action,
        table_name,
        record_id,
        account_id,
        transaction_type,
        amount
    )
    VALUES (
        NEW.performed_by,
        'INSERT',
        'transactions',
        NEW.transaction_id,
        NEW.account_id,
        NEW.transaction_type,
        NEW.amount
    );
END//

DELIMITER ;


-- ============================================================
-- 6. VERIFICATION
-- Displays the database tables and confirms trigger creation.
-- ============================================================

SHOW TABLES;

SHOW TRIGGERS;
