-- =====================================================================
-- ✅ MySQL Stored Procedures for Real Banking Operations (Complex)
-- =====================================================================

-- 🚀 IMPORTANT: Use InnoDB for transaction guarantees
SET autocommit = 0;


-- ✅ SP1: Money Transfer between two accounts (with rollback if failed)
DELIMITER $$

CREATE PROCEDURE transfer_money(
    IN p_from BIGINT,
    IN p_to BIGINT,
    IN p_amount DECIMAL(15,2)
)
BEGIN
    DECLARE current_balance DECIMAL(15,2);

    START TRANSACTION;

    -- Check sender balance
    SELECT balance INTO current_balance
    FROM accounts WHERE account_number = p_from
    FOR UPDATE;

    IF current_balance < p_amount THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Insufficient funds for transfer!';
    END IF;

    -- Deduct from sender
    UPDATE accounts 
    SET balance = balance - p_amount
    WHERE account_number = p_from;

    -- Add to receiver
    UPDATE accounts 
    SET balance = balance + p_amount
    WHERE account_number = p_to;

    COMMIT;
END $$

DELIMITER ;


-- ✅ SP2: Auto-pay EMI for a loan (deduct from linked account)
DELIMITER $$

CREATE PROCEDURE pay_emi(IN p_loan_id BIGINT)
BEGIN
    DECLARE acc_id BIGINT;
    DECLARE emi_amount DECIMAL(15,2);
    DECLARE cur_balance DECIMAL(15,2);

    SELECT account_id INTO acc_id
    FROM loans WHERE loan_id = p_loan_id;

    SELECT amount INTO emi_amount
    FROM loan_payments
    WHERE loan_id = p_loan_id AND status = 'due'
    ORDER BY due_date ASC
    LIMIT 1;

    IF acc_id IS NULL OR emi_amount IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No EMI due or no linked account';
    END IF;

    SELECT balance INTO cur_balance
    FROM accounts WHERE account_id = acc_id FOR UPDATE;

    IF cur_balance < emi_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance for EMI';
    END IF;

    UPDATE accounts SET balance = balance - emi_amount WHERE account_id = acc_id;

    UPDATE loan_payments 
    SET status = 'paid', payment_date = CURDATE()
    WHERE loan_id = p_loan_id AND status = 'due'
    ORDER BY due_date ASC
    LIMIT 1;
END $$

DELIMITER ;


-- ✅ SP3: Close inactive accounts with 0 balance for > 2 years
DELIMITER $$

CREATE PROCEDURE close_inactive_accounts()
BEGIN
    UPDATE accounts
    SET status = 'closed'
    WHERE status = 'active'
      AND balance = 0
      AND opened_at < DATE_SUB(CURDATE(), INTERVAL 2 YEAR);
END $$

DELIMITER ;


-- ✅ SP4: Block card if >3 suspicious debit transactions in 1 day
DELIMITER $$

CREATE PROCEDURE detect_fraud_and_block()
BEGIN
    UPDATE cards c
    JOIN accounts a ON c.account_id = a.account_id
    SET c.status = 'blocked'
    WHERE c.account_id IN (
        SELECT account_id FROM transactions
        WHERE txn_type = 'debit'
        AND amount > 40000
        GROUP BY account_id, DATE(txn_time)
        HAVING COUNT(*) > 3
    );
END $$

DELIMITER ;


-- ✅ SP5: Apply yearly interest to savings/fixed accounts
DELIMITER $$

CREATE PROCEDURE apply_yearly_interest()
BEGIN
    UPDATE accounts
    SET balance = balance + (balance * interest_rate / 100)
    WHERE account_type IN ('savings', 'fixed_deposit');
END $$

DELIMITER ;


-- ✅ SP6: Add a transaction record when balance changes (log system)
DELIMITER $$

CREATE PROCEDURE log_transaction(
    IN p_acc BIGINT,
    IN p_type ENUM('credit','debit'),
    IN p_amt DECIMAL(15,2),
    IN p_desc VARCHAR(200)
)
BEGIN
    DECLARE new_balance DECIMAL(15,2);

    SELECT balance INTO new_balance
    FROM accounts WHERE account_id = p_acc;

    INSERT INTO transactions(account_id, txn_time, txn_type, amount, description, balance_after)
    VALUES (p_acc, NOW(), p_type, p_amt, p_desc, new_balance);
END $$

DELIMITER ;
