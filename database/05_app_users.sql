USE finwisely;

CREATE TABLE IF NOT EXISTS app_users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(60) NOT NULL,
    role ENUM('ADMIN', 'TELLER', 'AUDITOR') NOT NULL,
    status ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO app_users (username, password_hash, role, status)
VALUES ('demo_teller', '$2a$12$hsTiEnP/O5EHiqHQmIekguSAg//tOsTXsS8hM0w/GgFaUegInvosK', 'TELLER', 'ACTIVE')
ON DUPLICATE KEY UPDATE
    password_hash = VALUES(password_hash),
    role = VALUES(role),
    status = VALUES(status);

CREATE ROLE IF NOT EXISTS 'app_service_role';

GRANT SELECT ON finwisely.app_users TO 'app_service_role';
GRANT SELECT ON finwisely.customers TO 'app_service_role';
GRANT SELECT ON finwisely.accounts TO 'app_service_role';
GRANT UPDATE (balance) ON finwisely.accounts TO 'app_service_role';
GRANT SELECT, INSERT ON finwisely.transactions TO 'app_service_role';

CREATE USER IF NOT EXISTS 'app_service'@'localhost'
IDENTIFIED BY 'AppService@123';

ALTER USER 'app_service'@'localhost'
IDENTIFIED BY 'AppService@123';

GRANT 'app_service_role' TO 'app_service'@'localhost';

SET DEFAULT ROLE 'app_service_role'
TO 'app_service'@'localhost';

SELECT user_id, username, role, status FROM app_users;
SHOW GRANTS FOR 'app_service'@'localhost';