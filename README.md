# FinWisely

## Secure Digital Banking Transaction Management System

FinWisely is a Java-based banking transaction management system developed using MySQL and JDBC. The project focuses on demonstrating defense-in-depth security within a relational database, implementing secure database access, transaction integrity, authentication, role-based access control (RBAC), and automatic audit logging.

Developed as a group project for **BIT3360 Advanced Databases**.

## 👥 Team Members
*   Tafadzwa Mungandaire — 2420974
*   Limpo Mwenya Musonda — 2420990
*   Tatenda Mungandaire — 2420986
*   Madalitso Lungu — 2420952

## 🛠️ Technology Stack
*   **Database:** MySQL 8.0.45 (InnoDB)
*   **Language:** Java 21
*   **Build Tool:** Maven 3.9.16
*   **Database Connectivity:** JDBC + MySQL Connector/J 9.5.0
*   **Testing:** JUnit 5.13.4
*   **Security:** BCrypt password hashing, JDBC PreparedStatements
*   **Version Control:** Git & GitHub

## 🔒 Key Security Features
*   **Role-Based Access Control (RBAC):** Distinct database users (`app_service`, `teller`, `auditor`, `administrator`) with least-privilege permissions.
*   **SQL Injection Prevention:** All database interactions in Java use parameterized `PreparedStatement` queries.
*   **Authentication:** Application login verifies credentials against hashed passwords (BCrypt).
*   **Transactional Integrity (ACID):** Deposits and withdrawals use atomic transactions (`commit`/`rollback`) and row-level locking.
*   **Automatic Audit Logging:** MySQL triggers automatically log successful transactions and account updates into an `audit_logs` table.
*   **Database Constraints:** Strict `CHECK`, `UNIQUE`, and `FOREIGN KEY` constraints prevent invalid data from entering the database.

## 📂 Project Structure
*   `src/main/java` — Application source code (DAOs, Services, Security Utils)
*   `src/test/java` — JUnit 5 automated tests
*   `database/` — MySQL scripts
    *   `01_create_tables.sql` — Table definitions and constraints
    *   `02_sample_data.sql` — Initial test data
    *   `03_users_permissions.sql` — Database user creation and privilege grants
    *   `04_security_tests.sql` — Tests for constraints and privilege enforcement
    *   `05_app_users.sql` — Application login credentials (BCrypt hashes)

## 🚀 Setup & Installation

### 1. Database Setup
1. Start your MySQL server (e.g., via XAMPP or MySQL Workbench).
2. Open a SQL client connected as `root`.
3. Execute the SQL scripts in the `database/` folder in **numerical order**:
   *   `01_create_tables.sql`
   *   `02_sample_data.sql`
   *   `03_users_permissions.sql`
   *   `04_security_tests.sql`
   *   `05_app_users.sql`
   *   *(If an audit trigger file exists, run it last to enable automatic logging).*

### 2. Application Setup
1. Ensure JDK 21 and Maven are installed.
2. Clone this repository:
   ```bash
   git clone https://github.com/tafa2004/FinWisely.git
   cd FinWisely