USE finwisely;

-- Application login accounts
CREATE TABLE IF NOT EXISTS app_users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(60) NOT NULL,
    role ENUM('ADMIN', 'TELLER', 'AUDITOR') NOT NULL,
    status ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Fictional demonstration teller
INSERT INTO app_users (username, password_hash, role, status)
VALUES (
    'demo_teller',
    '$2a$12$hsTiEnP/O5EHiqHQmIekguSAg//tOsTXsS8hM0w/GgFaUegInvosK',
    'TELLER',
    'ACTIVE'
)
ON DUPLICATE KEY UPDATE
    password_hash = VALUES(password_hash),
    role = VALUES(role),
    status = VALUES(status);

-- Verify application users
SELECT user_id, username, role, status FROM app_users;
