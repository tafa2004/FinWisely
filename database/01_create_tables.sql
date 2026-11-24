DROP DATABASE IF EXISTS finwisely;
CREATE DATABASE finwisely;
USE finwisely;

CREATE TABLE customers (
    customer_id  INT AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    phone        VARCHAR(20),
    national_id  VARCHAR(20)  NOT NULL UNIQUE,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    account_id   INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    balance      DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    status       VARCHAR(20)   NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT fk_accounts_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_balance CHECK (balance >= 0),
    CONSTRAINT chk_account_type CHECK (account_type IN ('Savings','Current')),
    CONSTRAINT chk_status CHECK (status IN ('ACTIVE','FROZEN','CLOSED'))
);

CREATE TABLE transactions (
    transaction_id   INT AUTO_INCREMENT PRIMARY KEY,
    account_id       INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount           DECIMAL(12,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    performed_by     VARCHAR(50) NOT NULL,
    CONSTRAINT fk_transactions_account
        FOREIGN KEY (account_id) REFERENCES accounts(account_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_amount CHECK (amount > 0),
    CONSTRAINT chk_txn_type CHECK (transaction_type IN ('DEPOSIT','WITHDRAWAL','TRANSFER'))
);

CREATE TABLE audit_logs (
    log_id      INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50),
    action      VARCHAR(50),
    table_name  VARCHAR(50),
    record_id   INT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit trigger: logs every new transaction automatically
DELIMITER //
CREATE TRIGGER trg_transactions_insert
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (username, action, table_name, record_id)
    VALUES (USER(), 'INSERT', 'transactions', NEW.transaction_id);
END//
DELIMITER ;