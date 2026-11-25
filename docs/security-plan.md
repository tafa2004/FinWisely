# FinWisely – Database Security Plan

## 1. Introduction

This security plan describes the controls implemented in FinWisely to protect customer information, account balances and transaction records.

The prototype applies database security principles including confidentiality, integrity, accountability, authentication and least privilege.

## 2. Role-Based Access Control (RBAC)

FinWisely uses MySQL roles to assign permissions according to user responsibilities.

### Administrator role

MySQL role: `administrator_role`

- Has full privileges on the `finwisely` database.
- Intended for database administration and configuration.

### Teller role

MySQL role: `teller_role`

- Can SELECT customer records.
- Can SELECT account records.
- Can UPDATE only the `balance` column in accounts.
- Can SELECT and INSERT transaction records.
- Does not receive general DELETE privileges.
- Cannot update account status or other account columns through the granted role.

### Auditor role

MySQL role: `auditor_role`

- Has SELECT privileges on all database tables.
- Can inspect records for auditing.
- Cannot modify or delete financial records through this role.

The roles are assigned to separate MySQL users, and default roles are configured so that the assigned permissions are active at login.

## 3. Principle of Least Privilege

Each database user receives only the permissions needed for their responsibilities.

For example, a teller does not receive administrator privileges. The teller role can update account balances but does not receive permission to update account status or delete customer records.

The Java application also connects using a dedicated account named `app_service`, rather than using the MySQL root account.

The `app_service_role` has these permissions:
- SELECT on `app_users`.
- SELECT on `customers`.
- SELECT on `accounts`.
- UPDATE on the `balance` column of `accounts`.
- SELECT and INSERT on `transactions`.

It is not granted direct SELECT access to `audit_logs`. The transaction trigger records audit entries as part of the transaction.

## 4. Authentication and Password Security

The application uses an authentication service to verify login credentials.

- Application usernames are stored in `app_users`.
- Passwords are stored as BCrypt hashes.
- The application verifies entered passwords against the stored hashes.
- Application users have a role and account status.
- Disabled application accounts should not be permitted to log in.

BCrypt is used to avoid storing plain-text application passwords in the database.

## 5. SQL Injection Prevention

The Java application uses JDBC prepared statements for database operations.

Parameterized queries separate SQL instructions from user-supplied values. This reduces the risk of SQL injection through input fields.

Application input validation also checks transaction amounts and other required values before processing.

## 6. Transaction Integrity

Deposits and withdrawals are processed through the BankingService.

The service:
1. Disables automatic commit.
2. Retrieves and locks the relevant account row using `SELECT ... FOR UPDATE`.
3. Checks that the account exists and is ACTIVE.
4. Validates the transaction amount.
5. Checks available funds for withdrawals.
6. Updates the account balance.
7. Inserts the transaction record.
8. Commits the changes together.

If an operation fails, the service rolls back the database transaction. This prevents a balance update from being committed without its corresponding transaction record.

The row lock helps prevent concurrent transactions from modifying the same account balance in an unsafe manner.

## 7. Database Integrity Controls

The database uses:
- Primary keys to identify records.
- Foreign keys to enforce relationships.
- Unique constraints for customer email addresses and national IDs.
- CHECK constraints to reject invalid balances and transaction values.
- DECIMAL(12,2) for financial amounts.
- InnoDB for transaction support and rollback.

## 8. Audit Logging and Accountability

The trigger `trg_transactions_insert` automatically inserts an audit record after a transaction record is inserted.

The audit record includes the application-level username, action, affected table, transaction ID, account ID, transaction type and amount.

This supports accountability and provides information for reviewing transaction activity.

The audit record is created within the same transaction as the transaction record. Therefore, a rolled-back transaction does not leave a corresponding audit entry.

## 9. Credential and Deployment Considerations

The Java application obtains its database connection details from environment variables rather than requiring database credentials to be embedded in source code.

The project includes demonstration credentials for local academic testing. These credentials are not suitable for production and must be replaced before any real deployment.

Production deployment would additionally require secure secret management, encrypted database connections, stronger operational monitoring, backup and recovery procedures, and independent security testing.

## 10. Security Limitations

FinWisely is an academic prototype, not a production banking platform.

The current console application provides teller functionality only. The database roles for administrators and auditors are configured separately, but their application interfaces are not implemented.

The prototype does not provide a complete production-grade audit administration interface, multi-factor authentication, or a secure masked console password-entry interface.