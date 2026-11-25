# FinWisely – System Requirements

## 1. Project Overview

**Project title:** Design and Implementation of a Secure Digital Banking Transaction Management System Using MySQL

FinWisely is an academic prototype of a digital banking transaction management system. It demonstrates how database security principles can be applied to protect customer records, account information and financial transactions.

The system uses MySQL for data storage and Java with JDBC for application access. It uses fictional demonstration data and is not connected to a real bank or payment network.

## 2. Project Objectives

- Design a relational database for customers, accounts and transactions.
- Apply role-based access control to restrict database operations.
- Demonstrate the principle of least privilege.
- Implement secure database access through JDBC and parameterized queries.
- Support deposits and withdrawals while preserving transaction integrity.
- Automatically record transaction activity using an audit trigger.
- Test permitted and denied database operations.

## 3. Functional Requirements

| ID | Requirement |
|---|---|
| FR-01 | The system shall store customer information. |
| FR-02 | The system shall store customer bank accounts and their balances. |
| FR-03 | The system shall authenticate application users using their usernames and passwords. |
| FR-04 | The system shall check the user's account status and role during authentication. |
| FR-05 | The teller application shall retrieve account balances. |
| FR-06 | The teller application shall process deposits. |
| FR-07 | The teller application shall process withdrawals. |
| FR-08 | The system shall reject zero or negative transaction amounts. |
| FR-09 | The system shall reject withdrawals that exceed the available balance. |
| FR-10 | The system shall reject transactions on accounts that are not active. |
| FR-11 | The system shall update the account balance and insert the transaction record as one database transaction. |
| FR-12 | The system shall roll back changes when a transaction fails. |
| FR-13 | The database shall automatically create an audit record after a transaction record is inserted. |
| FR-14 | Database users shall have permissions according to their assigned roles. |

## 4. Non-Functional Requirements

### Security
- Passwords shall be stored as BCrypt hashes rather than plain text.
- SQL statements shall use parameterized queries where applicable.
- Database privileges shall follow the principle of least privilege.
- Application database credentials shall be supplied through environment variables.
- Database constraints shall protect important financial data.

### Reliability and Integrity
- Financial amounts shall use the DECIMAL(12,2) data type.
- Related financial updates shall use database transactions.
- InnoDB shall provide transaction support and foreign-key enforcement.
- Failed transactions shall be rolled back.

### Usability
- The console application shall provide a simple menu for teller operations.
- The application shall display transaction results and useful error messages.

### Maintainability
- The application shall separate model, DAO and service responsibilities.
- Database creation, sample data and security configuration shall be provided as SQL scripts.

## 5. User Roles

- **Administrator:** Has full database privileges for administration.
- **Teller:** Can view customer and account information, update account balances and read or insert transactions within the granted permissions.
- **Auditor:** Has read-only access to database records.
- **Application service account:** Uses a dedicated restricted MySQL account to connect the Java application to the database.

The current Java console interface implements teller login and teller operations. Administrator and auditor privileges are configured at the database level.

## 6. Project Constraints and Limitations

- The prototype uses fictional demonstration data only.
- It is designed for academic demonstration and not production banking.
- The console interface currently supports teller operations only.
- Password input in the console is visible while typing.
- The application does not connect to real banking systems or process real money.
- Production deployment would require additional controls, infrastructure and security testing.