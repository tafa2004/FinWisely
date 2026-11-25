USE finwisely;

-- FinWisely application login accounts
CREATE TABLE IF NOT EXISTS app_users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(60) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT chk_app_users_role
        CHECK (role IN ('ADMINISTRATOR', 'TELLER', 'AUDITOR')),

    CONSTRAINT chk_app_users_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
) ENGINE=InnoDB;

-- Verify table creation
DESCRIBE app_users;