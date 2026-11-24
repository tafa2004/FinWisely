-- ============================================================
-- FINWISELY: DATABASE USERS, ROLES AND ACCESS CONTROL
-- Security model: Role-Based Access Control (RBAC)
-- Principle: Least Privilege
-- Requires MySQL 8.0 or later.
-- ============================================================

USE finwisely;

-- ------------------------------------------------------------
-- 1. REMOVE OLD DEMONSTRATION USERS AND ROLES
-- Classroom setup only. Re-running this resets these accounts.
-- ------------------------------------------------------------

DROP USER IF EXISTS
    'administrator'@'localhost',
    'teller'@'localhost',
    'auditor'@'localhost';

DROP ROLE IF EXISTS
    'administrator_role',
    'teller_role',
    'auditor_role';


-- ------------------------------------------------------------
-- 2. CREATE SECURITY ROLES
-- ------------------------------------------------------------

CREATE ROLE 'administrator_role';
CREATE ROLE 'teller_role';
CREATE ROLE 'auditor_role';


-- ------------------------------------------------------------
-- 3. ADMINISTRATOR ROLE
-- Full control for database administration.
-- ------------------------------------------------------------

GRANT ALL PRIVILEGES
ON finwisely.*
TO 'administrator_role';


-- ------------------------------------------------------------
-- 4. TELLER ROLE
-- Can read customer and account information.
-- Can update ONLY the balance column in accounts.
-- Can read and insert transaction records.
-- Cannot delete records or change account ownership/status.
-- ------------------------------------------------------------

GRANT SELECT
ON finwisely.customers
TO 'teller_role';

GRANT SELECT
ON finwisely.accounts
TO 'teller_role';

GRANT UPDATE (balance)
ON finwisely.accounts
TO 'teller_role';

GRANT SELECT, INSERT
ON finwisely.transactions
TO 'teller_role';


-- ------------------------------------------------------------
-- 5. AUDITOR ROLE
-- Read-only access to all database records.
-- Cannot modify or delete financial information.
-- ------------------------------------------------------------

GRANT SELECT
ON finwisely.*
TO 'auditor_role';


-- ------------------------------------------------------------
-- 6. CREATE DATABASE USERS
-- These credentials are for classroom demonstrations only.
-- Never reuse these passwords in a real banking environment.
-- ------------------------------------------------------------

CREATE USER 'administrator'@'localhost'
IDENTIFIED BY 'Admin@123';

CREATE USER 'teller'@'localhost'
IDENTIFIED BY 'Teller@123';

CREATE USER 'auditor'@'localhost'
IDENTIFIED BY 'Auditor@123';


-- ------------------------------------------------------------
-- 7. ASSIGN ROLES TO USERS
-- ------------------------------------------------------------

GRANT 'administrator_role'
TO 'administrator'@'localhost';

GRANT 'teller_role'
TO 'teller'@'localhost';

GRANT 'auditor_role'
TO 'auditor'@'localhost';


-- ------------------------------------------------------------
-- 8. SET DEFAULT ROLES
-- Ensures assigned roles are active at login.
-- ------------------------------------------------------------

SET DEFAULT ROLE 'administrator_role'
TO 'administrator'@'localhost';

SET DEFAULT ROLE 'teller_role'
TO 'teller'@'localhost';

SET DEFAULT ROLE 'auditor_role'
TO 'auditor'@'localhost';


-- ------------------------------------------------------------
-- 9. VERIFY ROLE ASSIGNMENTS AND PRIVILEGES
-- ------------------------------------------------------------

SHOW GRANTS FOR 'administrator_role';
SHOW GRANTS FOR 'teller_role';
SHOW GRANTS FOR 'auditor_role';

SHOW GRANTS FOR 'administrator'@'localhost';
SHOW GRANTS FOR 'teller'@'localhost';
SHOW GRANTS FOR 'auditor'@'localhost';

