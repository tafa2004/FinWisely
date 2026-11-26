# FinWisely Security Plan

## 1. Purpose

This document describes the security controls implemented in the FinWisely academic prototype. The project demonstrates selected database-security practices using MySQL and a Java/JDBC console application. It uses fictional data and is not a production banking system.

## 2. Threats considered

| Threat | Potential impact | Project control / demonstration |
|---|---|---|
| Unauthorised database access | Exposure or modification of records | Separate MySQL users and roles with scoped privileges. |
| Excessive privileges | A compromised account could perform unnecessary actions | Least-privilege grants, including a restricted `app_service` account. |
| SQL injection | User input could alter the meaning of SQL statements | Parameterised JDBC queries using `PreparedStatement`. |
| Weak password storage | A database leak could expose users' original passwords | BCrypt password hashing for application login credentials. |
| Invalid transaction values | Incorrect or harmful balance changes | Positive-amount validation and database CHECK constraints. |
| Insufficient-funds withdrawal | Account balance could become negative | Balance check in the banking service and a database non-negative balance constraint. |
| Partial transaction processing | Balance and transaction history could disagree | JDBC transaction with commit/rollback and row locking during account retrieval. |
| Missing transaction audit evidence | Reduced ability to review transaction activity | Trigger inserts an audit-log entry when a transaction is inserted. |

## 3. Authentication

The Java application authenticates a user against the `app_users` table. Passwords are stored as BCrypt hashes and checked by the authentication service. The console application uses the authenticated username when recording the teller responsible for a transaction.

The current prototype demonstrates a teller login flow. It does not implement multi-factor authentication, and password input in the console is visible as a usability/security limitation.

## 4. Role-based access control

MySQL roles separate database responsibilities:

- **Administrator:** administrative access to the project database.
- **Teller:** can read required customer/account information, update account balances, and read/insert transaction records, but is restricted from unrelated administrative actions.
- **Auditor:** read-only access for reviewing records.
- **Application service account:** a limited account used by the Java application, with only the permissions needed for its implemented operations.

The SQL scripts define the grants. Demonstrations include successful permitted operations and expected permission-denied errors, such as the application service account being denied access to `audit_logs` and being denied permission to update account status.

## 5. SQL injection prevention

The Java application uses parameterised SQL statements through JDBC `PreparedStatement` for values supplied at runtime. Parameter binding keeps input values separate from SQL command structure and reduces the risk of SQL injection.

The application should continue to avoid building SQL statements by concatenating user input.

## 6. Transaction integrity

Deposits and withdrawals are processed as a single database transaction:

1. Validate the requested amount and acting username.
2. Disable auto-commit for the connection.
3. Retrieve and lock the target account row.
4. Confirm that the account exists and is active.
5. For withdrawals, confirm that sufficient funds are available.
6. Update the account balance.
7. Insert the corresponding transaction record.
8. Commit if all operations succeed.
9. Roll back if an SQL or runtime error occurs.
10. Restore the connection's original auto-commit setting.

The account row lock helps prevent concurrent operations from reading and changing the same account balance without coordination. Database constraints provide an additional integrity layer.

## 7. Audit logging

An `AFTER INSERT` trigger on `transactions` inserts a corresponding audit entry into `audit_logs`. This records the transaction action and related information. Because the trigger executes within the transaction, its audit insertion is rolled back if the transaction is rolled back.

The current trigger covers transaction inserts only. It does not provide a general audit trail for every table update or deletion.

## 8. Verification

The project verifies security controls through automated Java tests and manual MySQL demonstrations. Examples include:

- Teller operations that successfully deposit and withdraw.
- Auditor read access and denied write attempts.
- Application service account denied access to audit logs and denied permission to update account status.
- Administrator attempts rejected by database CHECK constraints when values are invalid.
- Integration tests confirming that failed transaction operations do not leave partial balance or transaction changes.

## 9. Controls not implemented or not verified

The project does not claim to have configured or verified TLS for database connections, encryption at rest, multi-factor authentication, centralised secrets management, intrusion detection, production monitoring, or a full disaster-recovery process. These would be important additions before any real-world deployment.

## 10. Security conclusion

FinWisely demonstrates how layered controls—authentication, role-based access control, least privilege, parameterised queries, constraints, transaction rollback and audit logging—can work together to protect a small relational banking prototype. The controls are educational demonstrations and should not be treated as certification that the system is suitable for real banking use.
