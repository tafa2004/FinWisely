# FinWisely – Testing and Results

## 1. Testing Objectives

Testing was conducted to verify that FinWisely:
- Connects to MySQL using the restricted application database account.
- Authenticates application users.
- Processes valid deposits and withdrawals.
- Rejects invalid transaction requests.
- Preserves account balances when a transaction fails.
- Enforces database permissions.
- Automatically creates audit records for inserted transactions.

## 2. Testing Environment

| Component | Environment |
|---|---|
| Operating system | Microsoft Windows |
| Programming language | Java |
| Build tool | Apache Maven |
| Database | MySQL 8.0.45 |
| Database connectivity | JDBC / MySQL Connector/J |
| Storage engine | InnoDB |
| Testing framework | JUnit Jupiter |
| Application interface | Java console |

Testing used fictional demonstration records and a local MySQL database named `finwisely`.

## 3. Automated Application Tests

The Maven test suite completed successfully on 25 November 2026.

| Test class | Tests passed |
|---|---:|
| DatabaseConnectionTest | 1 |
| CustomerDAOTest | 1 |
| SecurityUtilsTest | 5 |
| AuthenticationServiceTest | 3 |
| BankingServiceIntegrationTest | 5 |
| **Total** | **15** |

**Overall result:** 15 tests passed, 0 failures, 0 errors and 0 skipped. Maven reported BUILD SUCCESS.

### 3.1 Banking Transaction Integration Tests

The banking integration tests used the actual MySQL database and the restricted `app_service` database account.

| Test | Expected result | Result |
|---|---|---|
| Deposit | Balance increases and transaction is recorded | Passed |
| Withdrawal | Balance decreases and transaction is recorded | Passed |
| Insufficient funds | Operation is rejected and no changes are committed | Passed |
| Blank username | Invalid request is rejected | Passed |
| Transaction insert failure | Balance update is rolled back | Passed |

The integration tests verified that the balance and transaction record are handled together.

## 4. Manual Database Permission Tests

Database permissions were tested using the configured MySQL users and roles.

| Role | Operation | Expected outcome |
|---|---|---|
| Teller | Read customer records | Allowed |
| Teller | Read account records | Allowed |
| Teller | Update account balance | Allowed |
| Teller | Insert transaction | Allowed |
| Teller | Update account status | Denied |
| Teller | Delete customer record | Denied |
| Teller | Read audit_logs directly | Denied |
| Auditor | Read database records | Allowed |
| Auditor | Update account balance | Denied |
| Auditor | Insert transaction | Denied |
| Administrator | Perform administrative database operations | Allowed |

The denied operations were checked through MySQL permission errors. These tests demonstrate that database access is restricted by role.

## 5. Database Constraint Tests

The database constraints were checked using invalid test values.

| Test | Expected outcome |
|---|---|
| Insert a negative account balance | Rejected |
| Insert a zero transaction amount | Rejected |
| Insert an unsupported transaction type | Rejected |
| Insert an account with a nonexistent customer ID | Rejected by the foreign key |
| Insert a duplicate customer email or national ID | Rejected by the unique constraint |

## 6. Console Application Demonstration

The Java console application was launched using the configured database environment variables.

The application was tested with the demonstration teller account.

The following operations were completed for account `9001`:

| Operation | Amount |
|---|---:|
| Initial balance before console demonstration | K1,060.00 |
| Deposit | K10.00 |
| Withdrawal | K20.00 |
| Final balance | K1,050.00 |

Both operations were successful, and the final account balance was displayed by the application.

## 7. Audit Trigger Verification

The `trg_transactions_insert` trigger was verified by querying the `transactions` and `audit_logs` tables.

The following four records were confirmed for account `9001`:

| Transaction ID | User | Type | Amount |
|---|---|---|---:|
| 3017 | demo_teller | WITHDRAWAL | 20.00 |
| 3016 | demo_teller | DEPOSIT | 10.00 |
| 3015 | integration_teller | WITHDRAWAL | 40.00 |
| 3014 | integration_teller | DEPOSIT | 100.00 |

The corresponding audit records were present with matching transaction IDs, usernames, transaction types and amounts.

This confirms that successful transaction inserts generated audit records. The integration test that deliberately caused an insert failure also verified that the failed operation did not leave a committed balance change or transaction record.

## 8. Testing Conclusion

The completed tests demonstrate that the FinWisely prototype can connect to MySQL, authenticate application users, process deposits and withdrawals, enforce database permissions, protect transaction integrity and record transaction activity through an audit trigger.

The automated test suite passed all 15 tests. Manual database checks also demonstrated both permitted and denied operations.

These results apply to the academic prototype and its local test environment. They do not constitute production banking certification or a complete independent security audit.