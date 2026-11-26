# FinWisely Project Requirements

## 1. Project overview

**Project title:** Design and Implementation of a Secure Digital Banking Transaction Management System Using MySQL

FinWisely is an academic prototype for demonstrating database security concepts in a digital banking transaction scenario. It uses MySQL for data storage and a Java console application connected through JDBC. All records are fictional and intended only for demonstration.

## 2. Problem statement

Banking systems store sensitive customer and account information and must protect it from unauthorised access, invalid transactions and inconsistent updates. Poorly controlled database permissions or incomplete transaction handling can expose data or leave account balances and transaction records inconsistent.

FinWisely demonstrates selected database controls that help address these risks in a small, controlled environment.

## 3. Project objectives

The project aims to:

- Design a relational database for customers, accounts and banking transactions.
- Apply primary keys, foreign keys, constraints and indexes.
- Demonstrate database users, roles and permissions.
- Restrict database access according to user responsibilities.
- Implement deposits and withdrawals with transaction integrity.
- Use parameterised SQL statements in the Java application.
- Demonstrate password hashing for application login.
- Record inserted transactions through a database audit trigger.
- Test both permitted and denied database operations.

## 4. Functional requirements

The prototype is expected to:

1. Store fictional customer records.
2. Store accounts associated with customers.
3. Record deposits and withdrawals.
4. Display an account balance to an authenticated teller user.
5. Reject invalid transaction amounts.
6. Reject withdrawals when the available balance is insufficient.
7. Update the account balance and insert the transaction record consistently.
8. Provide database roles for administrator, teller and auditor responsibilities.
9. Provide an application login using stored password hashes.
10. Generate an audit entry when a transaction record is inserted.

## 5. Security and integrity requirements

- Database access must be granted according to the principle of least privilege.
- The application must use a restricted database service account rather than an unrestricted administrator account.
- Application SQL statements that include user-supplied values must use `PreparedStatement` or equivalent parameterised execution.
- Application passwords must be stored as hashes rather than plaintext passwords.
- Account balances must not become negative.
- Transaction amounts must be greater than zero.
- Deposits/withdrawals must update the balance and insert the corresponding transaction record as one database transaction.
- Failed operations must be rolled back to avoid partial updates.
- Audit records must be generated for inserted transaction records.

## 6. Tools and technologies

| Tool / technology | Use |
|---|---|
| MySQL 8 | Relational database, constraints, roles, permissions and trigger. |
| Java | Console application and banking service logic. |
| JDBC / MySQL Connector/J | Java-to-MySQL connectivity. |
| Maven | Dependency and build management. |
| JUnit 5 | Automated tests. |
| BCrypt | Password hashing for application login. |
| Git and GitHub | Version control and project collaboration. |

## 7. Scope

The prototype focuses on database security, access control and transaction integrity. It demonstrates a teller-oriented console workflow for login, balance enquiry, deposit and withdrawal. Separate administrator and auditor database permissions are demonstrated through MySQL.

## 8. Limitations

The prototype is not a real banking service. It uses fictional demonstration data and a local MySQL database. It does not provide a customer-facing mobile/web interface, production deployment, multi-factor authentication, a complete customer-ownership authorisation workflow, TLS configuration evidence, or encryption-at-rest configuration evidence. The console password-entry experience is also a known usability limitation.

These limitations are stated to distinguish implemented features from controls that would be required in a production system.
