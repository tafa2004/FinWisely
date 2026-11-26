# FinWisely Testing and Verification

## 1. Purpose

This document summarises the testing approach and recorded results for the FinWisely prototype. The system uses fictional data in a local MySQL database and is intended for academic demonstration only.

## 2. Testing approach

Testing covers:

- Java unit and integration tests.
- Database connection and authentication behaviour.
- Banking transaction behaviour.
- Database constraints and permissions.
- Manual demonstrations using MySQL accounts with different roles.
- Review of transaction audit entries.

## 3. Automated Java tests

JUnit 5 tests cover database connectivity, DAO behaviour, security utilities, authentication and banking-service integration.

The recorded Maven test run completed with:

| Result | Recorded value |
|---|---:|
| Tests run | 15 |
| Failures | 0 |
| Errors | 0 |
| Skipped | 0 |
| Build result | BUILD SUCCESS |

These figures describe the recorded successful test run. Re-run `mvn test` from the project root to verify the current checkout before a new release or submission.

## 4. Banking transaction integration tests

The banking-service integration tests cover the following scenarios:

| Test scenario | Expected behaviour |
|---|---|
| Deposit | Account balance increases and a transaction record is inserted. |
| Withdrawal | Account balance decreases and a transaction record is inserted. |
| Insufficient funds | Withdrawal is rejected and no partial balance/transaction change remains. |
| Blank acting username | Request is rejected before a transaction is completed. |
| Transaction insert failure | The operation rolls back so the balance update is not left committed without its transaction record. |

The service uses JDBC commit/rollback handling so the balance update and transaction insert succeed or fail together.

## 5. Manual database security demonstrations

The following outcomes were recorded during manual MySQL testing:

| Account / role | Operation | Recorded outcome |
|---|---|---|
| Teller | Read account/customer information and perform permitted transaction operations | Allowed. |
| Auditor | Read database records | Allowed. |
| Auditor | Attempt UPDATE and INSERT operations | Denied by MySQL permissions. |
| Application service account | Update account status | Denied by MySQL permissions. |
| Application service account | Read `audit_logs` | Denied by MySQL permissions. |
| Administrator | Attempt to set a negative account balance | Rejected by the balance CHECK constraint. |
| Administrator | Attempt to insert a zero-value transaction | Rejected by the transaction amount CHECK constraint. |

The recorded permission-denied outcomes included MySQL errors 1142 and 1143. Constraint violations included error 3819.

## 6. Console application demonstration

The Java console application was manually exercised using the demo teller account. The demonstrated workflow included:

1. Successful login.
2. Display of the teller menu.
3. Account balance enquiry.
4. Deposit operation.
5. Withdrawal operation.
6. Updated balance display.
7. Application exit.

The console demonstration used fictional account data. Demo credentials are for the academic environment only and must not be reused as real credentials.

## 7. Audit-log verification

After a transaction insert, the corresponding audit entry was checked in `audit_logs`. The audit trigger recorded the acting username and transaction details. A failed/rolled-back transaction does not leave its trigger-generated audit row committed because the trigger runs within the same database transaction.

## 8. Evidence

Screenshots captured during the demonstrations provide supporting evidence for:

- Teller login and console operations.
- Database role grants.
- Auditor read access and denied write attempts.
- Administrator constraint violations.
- Application service account permission denials.
- Transaction and audit-log records.
- Automated test results.

The screenshots should be stored in the repository's evidence folder or supplied as a separate evidence attachment, according to the group's submission instructions. Avoid including real personal or banking information.

## 9. Known limitations

Testing was performed in a local academic environment with fictional data. It does not establish production readiness, performance under banking-scale load, resilience to all attack types, TLS configuration, encryption-at-rest configuration, or regulatory compliance. The console app is teller-focused and does not provide a full customer-facing interface or complete customer-ownership authorisation workflow.

## 10. Conclusion

The recorded tests demonstrate the main project objectives: role-based database access, rejection of unauthorised operations, enforcement of integrity constraints, parameterised application queries, and atomic deposit/withdrawal processing with audit entries. Further security and operational testing would be required for any production system.
