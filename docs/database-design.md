# FinWisely – Database Design

## 1. Overview

The FinWisely database is named `finwisely` and is implemented in MySQL. It uses the InnoDB storage engine, which supports transactions, rollback and foreign-key constraints.

The database stores customer details, bank accounts, transaction history, application users and audit records.

## 2. Database Tables

### 2.1 customers

Stores customer information.

| Column | Data type | Description |
|---|---|---|
| customer_id | INT | Primary key; automatically generated |
| first_name | VARCHAR(50) | Customer first name |
| last_name | VARCHAR(50) | Customer last name |
| email | VARCHAR(100) | Unique email address |
| phone | VARCHAR(20) | Customer phone number |
| national_id | VARCHAR(20) | Unique demonstration identity number |
| date_created | TIMESTAMP | Record creation time |

Constraints and indexes:
- `customer_id` is the primary key.
- `email` and `national_id` are unique.
- An index on last name and first name supports customer-name searches.

### 2.2 accounts

Stores customer bank account information and balances.

| Column | Data type | Description |
|---|---|---|
| account_id | INT | Primary key; automatically generated |
| customer_id | INT | Foreign key referencing customers |
| account_type | VARCHAR(20) | Savings or Current |
| balance | DECIMAL(12,2) | Current account balance |
| status | VARCHAR(20) | ACTIVE, FROZEN or CLOSED |

Constraints and indexes:
- `customer_id` references `customers(customer_id)`.
- Customer deletion is restricted when an account references that customer.
- Account balance must be greater than or equal to zero.
- Account type is restricted to Savings or Current.
- Account status is restricted to ACTIVE, FROZEN or CLOSED.
- Indexes support customer and status searches.

### 2.3 transactions

Stores deposit and withdrawal records.

| Column | Data type | Description |
|---|---|---|
| transaction_id | INT | Primary key; automatically generated |
| account_id | INT | Foreign key referencing accounts |
| transaction_type | VARCHAR(20) | DEPOSIT or WITHDRAWAL |
| amount | DECIMAL(12,2) | Transaction amount |
| transaction_date | TIMESTAMP | Transaction creation time |
| performed_by | VARCHAR(50) | Application-level user responsible |

Constraints and indexes:
- `account_id` references `accounts(account_id)`.
- Amount must be greater than zero.
- Transaction type is restricted to DEPOSIT or WITHDRAWAL.
- Indexes support searches by account, transaction date and user.

### 2.4 audit_logs

Stores audit information for successfully inserted transaction records.

| Column | Data type | Description |
|---|---|---|
| log_id | INT | Primary key; automatically generated |
| username | VARCHAR(50) | User associated with the transaction |
| action | VARCHAR(50) | Recorded database action |
| table_name | VARCHAR(50) | Name of the affected table |
| record_id | INT | ID of the affected transaction |
| account_id | INT | Related account |
| transaction_type | VARCHAR(20) | Deposit or withdrawal |
| amount | DECIMAL(12,2) | Transaction amount |
| action_time | TIMESTAMP | Time the audit record was created |

Indexes support searches by username, action time and account.

### 2.5 app_users

Stores application login information.

| Column | Data type | Description |
|---|---|---|
| user_id | INT | Primary key; automatically generated |
| username | VARCHAR(50) | Unique application username |
| password_hash | VARCHAR(60) | BCrypt password hash |
| role | ENUM | ADMIN, TELLER or AUDITOR |
| status | ENUM | ACTIVE or DISABLED |
| created_at | TIMESTAMP | Account creation time |

The table supports application authentication and role identification.

## 3. Relationships

The database uses the following relationships:

- One customer can have multiple accounts.
- Each account belongs to one customer.
- One account can have multiple transactions.
- Each transaction belongs to one account.
- Audit records reference the transaction ID and account ID as recorded values.

The main foreign-key relationships are:

- `accounts.customer_id` → `customers.customer_id`
- `transactions.account_id` → `accounts.account_id`

## 4. Database Trigger

The database contains an AFTER INSERT trigger named `trg_transactions_insert`.

When a transaction is successfully inserted into the `transactions` table, the trigger automatically inserts a corresponding record into `audit_logs`.

The trigger records:
- The application-level username (`performed_by`).
- The action (`INSERT`).
- The affected table.
- The transaction ID.
- The account ID.
- The transaction type and amount.

Because the trigger runs as part of the same database transaction, its audit insert is rolled back if the parent transaction is rolled back.

## 5. Data Integrity Measures

- Primary keys uniquely identify records.
- Foreign keys maintain relationships between tables.
- Unique constraints prevent duplicate customer email addresses and national IDs.
- CHECK constraints restrict invalid balances, account types, account statuses, transaction amounts and transaction types.
- DECIMAL(12,2) stores financial amounts accurately to two decimal places.
- InnoDB supports atomic transactions and rollback.

## 6. Demonstration Data

The project uses fictional customers, accounts and transaction records. Example email addresses use the reserved `.test` domain, and demonstration identity numbers are clearly labelled as demo IDs.

## 7. Database Setup

The database scripts are located in the `database` directory:

1. `01_create_tables.sql` – creates the database, tables and audit trigger.
2. `02_sample_data.sql` – inserts fictional demonstration records.
3. `03_users_permissions.sql` – configures database roles and users.
4. `04_security_tests.sql` – contains examples for testing database permissions.
5. `05_app_users.sql` – creates application users and the restricted application service account.