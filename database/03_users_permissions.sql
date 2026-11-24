-- Rerunnable: remove old users first
DROP USER IF EXISTS 'administrator'@'localhost';
DROP USER IF EXISTS 'teller'@'localhost';
DROP USER IF EXISTS 'auditor'@'localhost';

CREATE USER 'administrator'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER 'teller'@'localhost'        IDENTIFIED BY 'Teller@123';
CREATE USER 'auditor'@'localhost'       IDENTIFIED BY 'Auditor@123';

-- Administrator: full control of the finwisely database
GRANT ALL PRIVILEGES ON finwisely.* TO 'administrator'@'localhost';

-- Teller: read customers/accounts, read and add transactions only
GRANT SELECT ON finwisely.customers TO 'teller'@'localhost';
GRANT SELECT ON finwisely.accounts  TO 'teller'@'localhost';
GRANT SELECT, INSERT ON finwisely.transactions TO 'teller'@'localhost';

-- Auditor: read-only on everything, including audit_logs
GRANT SELECT ON finwisely.* TO 'auditor'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'administrator'@'localhost';
SHOW GRANTS FOR 'teller'@'localhost';
SHOW GRANTS FOR 'auditor'@'localhost';