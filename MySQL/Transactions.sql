-- ACID properties
-- COMMIT / ROLLBACK
-- SAVEPOINT
-- Error safety using SIGNAL
-- Fraud recovery
-- Bulk salary processing
-- EMI failures
-- Multi-table updates
-- Transaction logging

-- ============================================================
-- ✅ MySQL Transactions – Real Banking Scenarios (10 Examples)
-- ============================================================


-- Q1: Money transfer between 2 accounts → Ensure ACID guarantees
START TRANSACTION;
UPDATE accounts SET balance = balance - 5000 WHERE account_number = 400000000001;
UPDATE accounts SET balance = balance + 5000 WHERE account_number = 400000000002;
COMMIT;


-- Q2: Rollback transfer if sender does not have enough balance
START TRANSACTION;
UPDATE accounts SET balance = balance - 1000000 WHERE account_number = 400000000003;
IF (SELECT balance FROM accounts WHERE account_number = 400000000003) < 0 THEN
    ROLLBACK;
END IF;
COMMIT;


-- Q3: Salary credit to employees – rollback everything if any update fails
START TRANSACTION;
UPDATE accounts SET balance = balance + 50000 WHERE account_id = 10;
UPDATE accounts SET balance = balance + 48000 WHERE account_id = 11;
UPDATE accounts SET balance = balance + 55000 WHERE account_id = 99999;  -- wrong account → FAIL
ROLLBACK;


-- Q4: EMI deduction with SAVEPOINT to reverse last step only
START TRANSACTION;
SAVEPOINT before_emi;
UPDATE accounts SET balance = balance - 8000 WHERE account_id = 20;
UPDATE loan_payments SET status='paid' WHERE loan_id = 7 AND status='due' LIMIT 1;

-- revert the EMI update only:
ROLLBACK TO before_emi;
COMMIT;


-- Q5: Fraud case: Reverse last 2 transactions (double debit)
START TRANSACTION;
DELETE FROM transactions WHERE account_id = 25
ORDER BY txn_time DESC
LIMIT 2;
UPDATE accounts SET balance = balance + 30000 WHERE account_id = 25;
COMMIT;


-- Q6: If loan closed accidentally → restore status using ROLLBACK
START TRANSACTION;
UPDATE loans SET status='closed' WHERE loan_id = 17;
ROLLBACK;


-- Q7: Bulk bonus credit across ALL active accounts
START TRANSACTION;
UPDATE accounts
SET balance = balance + 100
WHERE status = 'active';
COMMIT;


-- Q8: Card chargeback – reverse a transaction with accuracy
START TRANSACTION;
UPDATE accounts SET balance = balance + 5000 WHERE account_id = 50;
INSERT INTO transactions(account_id, txn_time, txn_type, amount, description, balance_after)
VALUES(50, NOW(), 'credit', 5000, 'CHARGEBACK REVERSAL',
      (SELECT balance FROM accounts WHERE account_id = 50));
COMMIT;


-- Q9: Freeze account & undo any debit after freeze timestamp
START TRANSACTION;
UPDATE accounts SET status='suspended' WHERE account_id = 40;
DELETE FROM transactions 
WHERE account_id = 40
AND txn_type = 'debit'
AND txn_time > '2025-01-01';
COMMIT;


-- Q10: Loan restructure – adjust interest but rollback if payment history missing
START TRANSACTION;
UPDATE loans SET interest_rate = 12.5 WHERE loan_id = 14;

IF NOT EXISTS(SELECT 1 FROM loan_payments WHERE loan_id = 14) THEN
    ROLLBACK;
ELSE
    COMMIT;
END IF;


