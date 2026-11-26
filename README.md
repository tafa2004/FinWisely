FINWISELY

Secure Digital Banking Transaction Management System

A Database Security Implementation Project

FinWisely is a Java-based digital banking transaction management prototype developed using MySQL and JDBC. The system demonstrates how database security principles can be applied to protect banking records, control access to sensitive information, prevent unauthorised operations, maintain transaction integrity and support accountability through automated audit logging.

The project was developed as a group assignment for BIT3360 – Advanced Databases.

«Project focus: Database Security — demonstrating defence in depth through authentication, role-based access control, least-privilege permissions, parameterised SQL queries, database constraints, transaction management and audit logging.»

---

1. Project Objectives

The main objective is to design and implement a secure relational database system for managing basic digital banking operations.

The project aims to:

- Protect banking information against unauthorised access.
- Implement database users and role-based permissions.
- Apply the principle of least privilege.
- Prevent SQL injection through parameterised queries.
- Protect account balances and transaction records.
- Maintain transaction consistency using database transactions.
- Record successful transactions automatically for accountability.
- Demonstrate both permitted and denied database operations.

2. System Features

Banking Operations

- Application login and user authentication.
- Account balance enquiry.
- Deposits and withdrawals.
- Validation of transaction amounts.
- Insufficient-funds protection.
- Transaction record creation.

Database Security

- Role-Based Access Control (RBAC).
- Separate administrator, teller and auditor database roles.
- Restricted application database account.
- BCrypt password hashing.
- JDBC PreparedStatement queries.
- Database CHECK, UNIQUE and FOREIGN KEY constraints.
- Automatic transaction audit logging.
- Transaction rollback when an operation fails.

3. Security Implementation

Security mechanism| Implementation
Authentication| Application login with BCrypt password verification
Access control| MySQL roles and GRANT privileges
Least privilege| Restricted permissions for application and teller accounts
SQL injection prevention| JDBC PreparedStatement
Data integrity| CHECK, UNIQUE and FOREIGN KEY constraints
Transaction integrity| JDBC transactions, COMMIT and ROLLBACK
Concurrency protection| Row-level locking using SELECT FOR UPDATE
Accountability| MySQL trigger and audit_logs table

Database Roles

- Administrator: Database administration and authorised database management.
- Teller: Restricted access for customer enquiries and banking transactions.
- Auditor: Read-only access for reviewing database records.
- app_service: Restricted database account used by the Java application.

The application prototype currently exposes teller banking operations. The administrator and auditor permissions are demonstrated separately through MySQL.

Audit Logging

A MySQL trigger named "trg_transactions_insert" automatically creates an audit record whenever a transaction is successfully inserted into the transactions table.

The audit record captures the user, action, affected table, transaction record, account, transaction type and amount.

Because the trigger executes within the transaction, its audit entry is also rolled back if the parent transaction is rolled back.

4. Technologies Used

Technology| Purpose
Java 21| Application development
MySQL 8.0| Relational database management
JDBC| Java-to-MySQL connectivity
MySQL Connector/J| JDBC database driver
Maven 3.9| Dependency and build management
JUnit 5| Automated testing
BCrypt| Password hashing
Git and GitHub| Version control and collaboration

5. Database Design

The "finwisely" database contains the following main tables:

- "customers" — stores fictional customer information.
- "accounts" — stores account details, balances and account status.
- "transactions" — records deposits and withdrawals.
- "audit_logs" — stores automatically generated transaction audit records.
- "app_users" — stores application usernames, password hashes and roles.

Primary keys, foreign keys, unique constraints, check constraints and indexes support data integrity and efficient data retrieval.

The database uses the InnoDB storage engine.

6. Project Structure

FinWisely/
│
├── database/
│   ├── 01_create_tables.sql
│   ├── 02_sample_data.sql
│   ├── 03_users_permissions.sql
│   ├── 04_security_tests.sql
│   ├── 05_app_users.sql
│   └── finwisely_database.sql
│
├── docs/
│
├── src/
│   ├── main/
│   │   └── java/com/finwisely/
│   │       ├── config/
│   │       ├── dao/
│   │       ├── model/
│   │       ├── security/
│   │       ├── service/
│   │       ├── ui/
│   │       └── Main.java
│   │
│   └── test/
│       └── java/com/finwisely/
│           ├── config/
│           ├── dao/
│           ├── security/
│           └── service/
│
├── pom.xml
└── README.md

The "evidence/" folder is intended to contain the SQL demonstration screenshots and supporting evidence when added to the repository.

7. Requirements

To run the prototype, install:

- JDK 21 or later compatible with the project configuration.
- MySQL Server 8.0 or later.
- Apache Maven 3.9 or later.
- Git.

A MySQL client such as MySQL Workbench can be used to execute and inspect the database scripts.

8. Database Setup

1. Start the MySQL server.
2. Connect to MySQL using an authorised database administrator account.
3. Execute the following scripts from the "database/" folder in the indicated setup order:

01_create_tables.sql
02_sample_data.sql
03_users_permissions.sql
05_app_users.sql

The audit trigger is already defined in "01_create_tables.sql"; no separate trigger script is required.

Security testing: "04_security_tests.sql" contains demonstration queries for checking database permissions and constraints. Execute its tests individually where appropriate because some statements are intentionally expected to be rejected by MySQL.

The additional "finwisely_database.sql" file should be treated as an alternative consolidated SQL script, not executed alongside the numbered setup scripts without checking its contents.

9. Application Setup

Clone the repository:

git clone https://github.com/tafa2004/FinWisely.git
cd FinWisely

Configure the database connection using environment variables.

For Windows PowerShell:

$env:FINWISELY_DB_URL = "jdbc:mysql://localhost:3306/finwisely"
$env:FINWISELY_DB_USER = "app_service"
$env:FINWISELY_DB_PASSWORD = "YOUR_DATABASE_PASSWORD"

Use the database password configured for the application service account. Do not commit database passwords or other secrets to GitHub.

Run the automated tests:

mvn clean test

Compile the application and build its dependency classpath:

mvn -q dependency:build-classpath "-Dmdep.outputFile=target/classpath.txt"

$classpath = "target\classes;" + (Get-Content .\target\classpath.txt -Raw)

java -cp $classpath com.finwisely.Main

The application connects to the configured MySQL database, authenticates the application user and provides the supported teller banking operations.

10. Testing and Demonstration

The project includes automated tests and manual database security demonstrations.

Testing covers:

- Database connectivity.
- DAO operations.
- Password and authentication functionality.
- Deposit and withdrawal processing.
- Insufficient-funds rejection.
- Invalid transaction amount rejection.
- Transaction rollback after database errors.
- Database role permissions.
- Denied unauthorised database operations.
- Audit log generation.

The manual demonstrations show how different database users receive different privileges and how MySQL rejects operations outside those privileges.

11. Limitations and Future Improvements

FinWisely is an academic prototype and is not a production banking platform.

Potential improvements include:

- Multi-factor authentication.
- Secure password entry and stronger session management.
- Encrypted database connections and encryption at rest.
- Expanded administrator and auditor application interfaces.
- More extensive security testing and monitoring.
- Production-grade credential and secrets management.

12. Project Evidence

The "evidence/" folder is intended to contain screenshots and supporting records of the database demonstrations.

These materials provide evidence of:

- Application login and banking operations.
- Database user permissions.
- Successful and denied SQL operations.
- Transaction records and audit logs.
- Database constraint enforcement.

13. Group Members

Name| Student Number
Tafadzwa Mungandaire| 2420974
Limpo Mwenya Musonda| 2420990
Tatenda Mungandaire| 2420986
Madalitso Lungu| 2420952

Course: BIT3360 – Advanced Databases
Project Topic: Database Security
Project Title: Design and Implementation of a Secure Digital Banking Transaction Management System Using MySQL

---

FinWisely demonstrates how database security principles can be translated into practical controls within a relational banking transaction system.