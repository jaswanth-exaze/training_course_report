

  


use bank_management_system


  -- ========================================
-- ✅ MySQL SELECT Practice (Banking System)
-- ========================================

-- 🔹 BASIC SELECT (5 Questions)

-- Q1: Show all customers
SELECT * FROM customers;

-- Q2: Show first_name, last_name of all customers
SELECT first_name, last_name FROM customers;

-- Q3: Show all employees with their role
SELECT first_name, last_name, role FROM employees;

-- Q4: Show all account numbers and balances
SELECT account_number, balance FROM accounts;

-- Q5: Show all distinct cities of customers
SELECT DISTINCT city FROM customers;


-- 🔹 WHERE Conditions (10 Questions)

-- Q6: Customers from Bengaluru
SELECT * FROM customers
WHERE city = 'Bengaluru';

-- Q7: Show accounts with balance greater than ₹100000
SELECT * FROM accounts
WHERE balance > 100000;

-- Q8: Show customers born after 1995
SELECT * FROM customers
WHERE dob > '1995-01-01';

-- Q9: Fetch only active accounts
SELECT * FROM accounts
WHERE status = 'active';

-- Q10: Employees who are managers
SELECT * FROM employees
WHERE role = 'manager';

-- Q11: Loans with interest_rate above 10%
SELECT * FROM loans
WHERE interest_rate > 10;

-- Q12: Customers from Chennai or Delhi
SELECT * FROM customers
WHERE city IN ('Chennai', 'Delhi');

-- Q13: Accounts opened in last 3 years
SELECT * FROM accounts
WHERE opened_at >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR);

-- Q14: Employees hired between 2020 and 2023
SELECT * FROM employees
WHERE hired_at BETWEEN '2020-01-01' AND '2023-12-31';

-- Q15: Customers whose phone starts with '98'
SELECT * FROM customers
WHERE phone LIKE '98%';


-- 🔹 ORDER BY and LIMIT (5 Questions)

-- Q16: Show customers ordered by first_name ascending
SELECT * FROM customers ORDER BY first_name ASC;

-- Q17: Show top 5 highest balance accounts
SELECT account_number, balance FROM accounts
ORDER BY balance DESC
LIMIT 5;

-- Q18: Show first 10 employees sorted by hired date (newest first)
SELECT * FROM employees
ORDER BY hired_at DESC
LIMIT 10;

-- Q19: Show lowest 5 loan amounts
SELECT customer_id, principal FROM loans
ORDER BY principal ASC
LIMIT 5;

-- Q20: Show 10 recent transactions
SELECT * FROM transactions
ORDER BY txn_time DESC
LIMIT 10;


-- 🔹 DISTINCT (3 Questions)

-- Q21: Unique employee roles
SELECT DISTINCT role FROM employees;

-- Q22: Unique account status values
SELECT DISTINCT status FROM accounts;

-- Q23: Unique loan types in bank
SELECT DISTINCT loan_type FROM loans;


-- ===================================================================
-- ✅ MySQL JOIN Queries with Real Banking Scenarios
-- ===================================================================


-- ✅ INNER JOIN (5)

-- Q1: A customer service officer wants a report of each customer's account plus the branch they belong to.
SELECT a.account_number, c.first_name, c.last_name, b.branch_name
FROM accounts a
INNER JOIN customers c ON a.customer_id = c.customer_id
INNER JOIN branches b ON a.branch_id = b.branch_id;

-- Q2: Bank card department needs a list of all customers who have been issued a card along with branch city to plan courier routes.
SELECT c.first_name, c.last_name, ca.card_number, b.city
FROM cards ca
INNER JOIN accounts a ON ca.account_id = a.account_id
INNER JOIN customers c ON a.customer_id = c.customer_id
INNER JOIN branches b ON a.branch_id = b.branch_id;

-- Q3: Loan officer wants a list of customers who have loans linked with their operating account.
SELECT l.loan_id, cu.first_name, cu.last_name, a.account_number
FROM loans l
INNER JOIN customers cu ON l.customer_id = cu.customer_id
INNER JOIN accounts a ON l.account_id = a.account_id;

-- Q4: Bank manager asked employee to print the last 10 recent transactions with account & customer details for security review.
SELECT t.transaction_id, a.account_number, c.first_name, t.amount, t.txn_time
FROM transactions t
INNER JOIN accounts a ON t.account_id = a.account_id
INNER JOIN customers c ON a.customer_id = c.customer_id
ORDER BY t.txn_time DESC LIMIT 10;

-- Q5: Regional manager wants a list of loans and which loan officer processed them at their branch.
SELECT l.loan_id, e.first_name AS loan_officer, b.branch_name
FROM loans l
INNER JOIN employees e ON e.branch_id = l.branch_id AND e.role = 'loan_officer'
INNER JOIN branches b ON b.branch_id = l.branch_id;




-- ✅ LEFT JOIN (5)

-- Q6: A relationship manager wants all customers including those who never applied for a loan.
SELECT cu.customer_id, cu.first_name, l.loan_id, l.status
FROM customers cu
LEFT JOIN loans l ON cu.customer_id = l.customer_id;

-- Q7: Card team wants to review accounts that do not yet have a card issued.
SELECT a.account_number, ca.card_number, ca.status
FROM accounts a
LEFT JOIN cards ca ON a.account_id = ca.account_id;

-- Q8: HR wants a list showing every employee and their reporting manager.
SELECT e.first_name AS employee, m.first_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- Q9: Admin team wants to find if any branch has zero employees.
SELECT b.branch_name, COUNT(e.employee_id) AS employee_count
FROM branches b
LEFT JOIN employees e ON b.branch_id = e.branch_id
GROUP BY b.branch_id, b.branch_name;

-- Q10: Compliance team wants to identify accounts with no transactions (possible dormant accounts).
SELECT a.account_number
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL;




-- ✅ RIGHT JOIN (5)

-- Q11: Finance team wants to list all loans even if some payments are missing.
SELECT l.loan_id, lp.payment_id, lp.amount
FROM loan_payments lp
RIGHT JOIN loans l ON lp.loan_id = l.loan_id;

-- Q12: Branch head wants a report of all branches and their accounts (if any).
SELECT a.account_number, b.branch_name
FROM accounts a
RIGHT JOIN branches b ON a.branch_id = b.branch_id;

-- Q13: HR wants to identify managers and employees reporting to them.
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
RIGHT JOIN employees m ON e.manager_id = m.employee_id;

-- Q14: Card audit team wants to ensure all cards have valid customers linked.
SELECT ca.card_number, c.customer_id, c.first_name
FROM cards ca
RIGHT JOIN accounts a ON ca.account_id = a.account_id
RIGHT JOIN customers c ON a.customer_id = c.customer_id;

-- Q15: Risk department wants to ensure loans are assigned to branches with employees.
SELECT l.loan_id, e.employee_id
FROM loans l
RIGHT JOIN employees e ON l.branch_id = e.branch_id;




-- ✅ FULL OUTER JOIN (Simulated using UNION) (5)

-- Q16: Auditor needs a full reconciliation of accounts and transactions — even unmatched records.
SELECT a.account_number, t.transaction_id, t.amount
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id
UNION
SELECT a.account_number, t.transaction_id, t.amount
FROM accounts a
RIGHT JOIN transactions t ON a.account_id = t.account_id;

-- Q17: City-wise comparison of customers and employees (include all unique cities involved).
SELECT city FROM customers
UNION
SELECT city FROM employees;

-- Q18: Compliance requires a list of card-account mappings including missing links both sides.
SELECT ca.card_number, a.account_number
FROM cards ca
LEFT JOIN accounts a ON ca.account_id = a.account_id
UNION
SELECT ca.card_number, a.account_number
FROM cards ca
RIGHT JOIN accounts a ON ca.account_id = a.account_id;

-- Q19: Loan audit: include loans with no payments and extra payments without proper loan link.
SELECT l.loan_id, lp.payment_id
FROM loans l
LEFT JOIN loan_payments lp ON l.loan_id = lp.loan_id
UNION
SELECT l.loan_id, lp.payment_id
FROM loans l
RIGHT JOIN loan_payments lp ON l.loan_id = lp.loan_id;

-- Q20: Customer-account mismatches detection report for fraud check.
SELECT c.customer_id, a.account_number
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
UNION
SELECT c.customer_id, a.account_number
FROM customers c
RIGHT JOIN accounts a ON c.customer_id = a.customer_id;




-- ✅ SELF JOIN (3)

-- Q21: HR wants a list of managers and their team members.
SELECT m.first_name AS manager, e.first_name AS employee
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id;

-- Q22: Branch leadership structure: show manager per branch.
SELECT b.branch_name, m.first_name AS manager
FROM employees m
JOIN employees e ON e.manager_id = m.employee_id
JOIN branches b ON m.branch_id = b.branch_id
GROUP BY b.branch_name, m.first_name;

-- Q23: Identify employees who do not manage anyone (individual contributors).
SELECT e.first_name AS employee
FROM employees e
LEFT JOIN employees x ON x.manager_id = e.employee_id
WHERE x.employee_id IS NULL;




-- ✅ CROSS JOIN (2)

-- Q24: Strategy team wants to explore all possible loan & account type combinations for new offers.
SELECT DISTINCT l.loan_type, a.account_type
FROM loans l
CROSS JOIN accounts a;

-- Q25: Marketing team wants to evaluate branch coverage for all loan products.
SELECT b.branch_name, l.loan_type
FROM branches b
CROSS JOIN (SELECT DISTINCT loan_type FROM loans) l;

-- =================================================================
-- ✅ MySQL GROUP BY + HAVING
-- ✅ Real Banking Business Scenarios (Q + A)
-- =================================================================


-- Q1: Bank regional head wants to know how many customers belong to each city.
SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city;


-- Q2: Finance department wants the total account balance per branch to analyze branch performance.
SELECT b.branch_name, SUM(a.balance) AS total_balance
FROM branches b
JOIN accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name
ORDER BY total_balance DESC;


-- Q3: Audit team needs a list of customers having 2 or more accounts.
SELECT c.customer_id, c.first_name, COUNT(a.account_id) AS account_count
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name
HAVING COUNT(a.account_id) >= 2;


-- Q4: Risk monitoring team wants all high-value customers with account balances over ₹5,00,000 combined.
SELECT c.first_name, c.last_name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id
HAVING SUM(a.balance) > 500000;


-- Q5: Loan department wants the number of active loans per branch.
SELECT b.branch_name, COUNT(l.loan_id) AS total_loans
FROM branches b
JOIN loans l ON b.branch_id = l.branch_id
WHERE l.status = 'active'
GROUP BY b.branch_name;


-- Q6: Business analytics team wants to compare the count of each loan type.
SELECT loan_type, COUNT(*) AS total_loans
FROM loans
GROUP BY loan_type
ORDER BY total_loans DESC;


-- Q7: Card department needs to know how many cards are issued per card type.
SELECT card_type, COUNT(*) AS cards_issued
FROM cards
GROUP BY card_type;


-- Q8: Operations team suspects some accounts are too inactive — find accounts with fewer than 2 transactions.
SELECT a.account_number, COUNT(t.transaction_id) AS txn_count
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id
GROUP BY a.account_number
HAVING COUNT(t.transaction_id) < 2;


-- Q9: Corporate banking wants to identify branches receiving very low total payments towards loans (< ₹50,000).
SELECT b.branch_name, SUM(lp.amount) AS total_paid
FROM loan_payments lp
JOIN loans l ON lp.loan_id = l.loan_id
JOIN branches b ON l.branch_id = b.branch_id
GROUP BY b.branch_name
HAVING SUM(lp.amount) < 50000;


-- Q10: Anti-fraud team wants to detect customers who made more than 3 transactions in a single day.
SELECT a.customer_id, DATE(t.txn_time) AS txn_date, COUNT(*) AS txn_count
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
GROUP BY a.customer_id, DATE(t.txn_time)
HAVING COUNT(*) > 3;


-- Q11: Management wants to know the average interest rate per loan type.
SELECT loan_type, AVG(interest_rate) AS avg_interest_rate
FROM loans
GROUP BY loan_type;


-- Q12: Finance wants to find branches where the number of employees is below 3.
SELECT b.branch_name, COUNT(e.employee_id) AS total_employees
FROM branches b
LEFT JOIN employees e ON b.branch_id = e.branch_id
GROUP BY b.branch_name
HAVING COUNT(e.employee_id) < 3;


-- =====================================================================
-- ✅ MySQL Subqueries + CTE
-- ✅ Real Banking Work Scenarios (Q + A)
-- =====================================================================


-- ✅ SUBQUERIES (10)


-- Q1: Management wants customers who have balance higher than the average balance of all accounts.
SELECT c.customer_id, c.first_name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id
HAVING total_balance > (SELECT AVG(balance) FROM accounts);


-- Q2: Risk team wants to identify highest balance account in each branch.
SELECT branch_id, account_number, balance
FROM accounts a
WHERE balance = (SELECT MAX(balance) 
                 FROM accounts 
                 WHERE branch_id = a.branch_id);


-- Q3: Find customers who **don’t** have an account (registered but inactive clients).
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM accounts);


-- Q4: Card department wants customers who have at least one card issued.
SELECT first_name, last_name
FROM customers
WHERE customer_id IN (SELECT customer_id FROM accounts WHERE account_id IN (SELECT account_id FROM cards));


-- Q5: Show loans that have **no payments made yet**.
SELECT loan_id, principal
FROM loans
WHERE loan_id NOT IN (SELECT loan_id FROM loan_payments);


-- Q6: Identify customers with transactions over **₹50,000** (flag unusual spenders).
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
WHERE a.account_id IN (
    SELECT account_id FROM transactions WHERE amount > 50000
);


-- Q7: Find customers whose loan principal is **above the average principal**.
SELECT c.customer_id, c.first_name, l.principal
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
WHERE l.principal > (SELECT AVG(principal) FROM loans);


-- Q8: List accounts which have more balance than **all** accounts of branch_id = 1.
SELECT account_number, balance
FROM accounts
WHERE balance > ALL (
    SELECT balance FROM accounts WHERE branch_id = 1
);


-- Q9: Credit analysts want to find loan EMI payments **higher than average EMI**.
SELECT payment_id, loan_id, amount
FROM loan_payments
WHERE amount > (SELECT AVG(amount) FROM loan_payments);


-- Q10: Identify employees earning **more salary than their own manager**.
SELECT e.first_name AS employee, e.salary,
       m.first_name AS manager, m.salary AS manager_salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;




-- ✅ CTE (Common Table Expressions) (10)


-- Q11: Monthly transaction count per account to detect high-activity accounts.
WITH txn_month AS (
    SELECT account_id, EXTRACT(MONTH FROM txn_time) AS txn_month,
           COUNT(*) AS monthly_txn_count
    FROM transactions
    GROUP BY account_id, EXTRACT(MONTH FROM txn_time)
)
SELECT * FROM txn_month WHERE monthly_txn_count > 3;


-- Q12: Find top 5 customers by total balance across all accounts.
WITH cust_bal AS (
    SELECT c.customer_id, c.first_name, SUM(a.balance) AS total_balance
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    GROUP BY c.customer_id
)
SELECT * FROM cust_bal ORDER BY total_balance DESC LIMIT 5;


-- Q13: Branch performance: sum of balances grouped by branch name.
WITH branch_bal AS (
    SELECT b.branch_name, SUM(a.balance) AS branch_total
    FROM branches b
    JOIN accounts a ON b.branch_id = a.branch_id
    GROUP BY b.branch_name
)
SELECT * FROM branch_bal ORDER BY branch_total DESC;


-- Q14: List overdue loan payments (payment_date > due_date).
WITH overdue AS (
    SELECT lp.payment_id, l.loan_id, lp.payment_date, lp.due_date
    FROM loan_payments lp
    JOIN loans l ON lp.loan_id = l.loan_id
    WHERE lp.payment_date > lp.due_date
)
SELECT * FROM overdue;


-- Q15: Customers with more than 2 active accounts.
WITH active_acc AS (
    SELECT customer_id, COUNT(*) AS acc_count
    FROM accounts
    WHERE status = 'active'
    GROUP BY customer_id
)
SELECT * FROM active_acc WHERE acc_count > 2;


-- Q16: Rank branches by total loan disbursed.
WITH loan_branch AS (
    SELECT b.branch_name, SUM(l.principal) AS total_disbursed
    FROM branches b
    JOIN loans l ON b.branch_id = l.branch_id
    GROUP BY b.branch_name
)
SELECT * FROM loan_branch ORDER BY total_disbursed DESC;


-- Q17: Detect customers making **frequent large withdrawals** (fraud risk).
WITH high_txn AS (
    SELECT account_id, COUNT(*) AS risky_cnt
    FROM transactions
    WHERE txn_type = 'debit' AND amount > 40000
    GROUP BY account_id
)
SELECT * FROM high_txn WHERE risky_cnt >= 2;


-- Q18: Card expiry alert — cards expiring in next 60 days.
WITH card_alert AS (
    SELECT card_number, expiry
    FROM cards
    WHERE expiry BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 60 DAY)
)
SELECT * FROM card_alert;


-- Q19: Identify loans with **less than 20% payments cleared** (NPA early alert).
WITH loan_paid AS (
    SELECT loan_id, SUM(amount) AS paid_amt
    FROM loan_payments GROUP BY loan_id
)
SELECT l.loan_id, l.principal, IFNULL(lp.paid_amt, 0) AS paid_amount
FROM loans l
LEFT JOIN loan_paid lp ON l.loan_id = lp.loan_id
WHERE IFNULL(lp.paid_amt,0) < (l.principal * 0.20);


-- Q20: Branch head wants **employee count per branch** including branch names.
WITH emp_branch AS (
    SELECT branch_id, COUNT(employee_id) AS emp_count
    FROM employees
    GROUP BY branch_id
)
SELECT b.branch_name, e.emp_count
FROM emp_branch e
JOIN branches b ON e.branch_id = b.branch_id;
-- =================================================================
-- ✅ MySQL VIEWS - Real Banking Business Scenarios (8 Views)
-- =================================================================


-- Q1: A secure view for customer support showing customer info but MASK phone number & email.
CREATE VIEW v_masked_customers AS
SELECT 
    customer_id, 
    first_name, 
    last_name,
    CONCAT('XXXXX', SUBSTRING(phone, -3)) AS masked_phone,
    CONCAT(LEFT(email,3), '*****@hidden.com') AS masked_email,
    city, state
FROM customers;


-- Q2: High-value customers for wealth team (total balance > ₹5 Lakhs)
CREATE VIEW v_high_value_customers AS
SELECT c.customer_id, c.first_name, c.last_name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id
HAVING SUM(a.balance) > 500000;


-- Q3: Branch performance dashboard (total balance per branch)
CREATE VIEW v_branch_performance AS
SELECT b.branch_name, SUM(a.balance) AS total_balance
FROM branches b
JOIN accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_name
ORDER BY total_balance DESC;


-- Q4: Cards nearing expiry in next 90 days (for card renewal team)
CREATE VIEW v_expiring_cards AS
SELECT 
    ca.card_number, 
    ca.card_type, 
    ca.expiry,
    c.first_name, 
    c.last_name
FROM cards ca
JOIN accounts a ON ca.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE ca.expiry BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 90 DAY);


-- Q5: Loans with late payments (NPA monitoring)
CREATE VIEW v_late_loans AS
SELECT 
    l.loan_id,
    c.first_name,
    c.last_name,
    COUNT(lp.payment_id) AS late_count
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
JOIN loan_payments lp ON l.loan_id = lp.loan_id
WHERE lp.status = 'late'
GROUP BY l.loan_id, c.first_name, c.last_name;


-- Q6: Employee → Manager reporting structure
CREATE VIEW v_employee_hierarchy AS
SELECT 
    e.employee_id,
    e.first_name AS employee_name,
    m.first_name AS manager_name,
    b.branch_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
JOIN branches b ON e.branch_id = b.branch_id;


-- Q7: Active loan summary with EMI progress percentage
CREATE VIEW v_loan_progress AS
SELECT 
    l.loan_id,
    c.first_name,
    l.principal,
    IFNULL(SUM(lp.amount),0) AS paid_amount,
    ROUND(IFNULL(SUM(lp.amount)/l.principal,0) * 100,2) AS progress_percent
FROM loans l
LEFT JOIN loan_payments lp ON l.loan_id = lp.loan_id
JOIN customers c ON l.customer_id = c.customer_id
WHERE l.status = 'active'
GROUP BY l.loan_id, c.first_name, l.principal;


-- Q8: Accounts with zero transactions (dormant accounts list)
CREATE VIEW v_dormant_accounts AS
SELECT 
    a.account_number,
    c.first_name,
    c.last_name,
    a.balance,
    a.status
FROM accounts a
LEFT JOIN transactions t ON a.account_id = t.account_id
JOIN customers c ON a.customer_id = c.customer_id
WHERE t.transaction_id IS NULL;


-- =========================================================================
-- ✅ MySQL Stored Procedures - Basic + Intermediate (10 Banking Scenarios)
-- =========================================================================


-- ✅ SP1: Get full details of a customer by customer ID
DELIMITER $$
CREATE PROCEDURE get_customer_details(IN p_cust_id INT)
BEGIN
    SELECT * FROM customers WHERE customer_id = p_cust_id;
END $$
DELIMITER ;


-- ✅ SP2: Display all accounts of a given customer
DELIMITER $$
CREATE PROCEDURE get_customer_accounts(IN p_customer_id INT)
BEGIN
    SELECT account_number, account_type, balance, status
    FROM accounts
    WHERE customer_id = p_customer_id;
END $$
DELIMITER ;


-- ✅ SP3: Update customer phone number
DELIMITER $$
CREATE PROCEDURE update_customer_phone(
    IN p_customer_id INT,
    IN p_new_phone VARCHAR(15)
)
BEGIN
    UPDATE customers
    SET phone = p_new_phone
    WHERE customer_id = p_customer_id;
END $$
DELIMITER ;


-- ✅ SP4: List all active cards for a specific account
DELIMITER $$
CREATE PROCEDURE get_active_cards(IN p_account_id BIGINT)
BEGIN
    SELECT * FROM cards
    WHERE account_id = p_account_id AND status = 'active';
END $$
DELIMITER ;


-- ✅ SP5: Get transaction history of an account (recent first)
DELIMITER $$
CREATE PROCEDURE get_account_transactions(IN p_account_id BIGINT)
BEGIN
    SELECT *
    FROM transactions
    WHERE account_id = p_account_id
    ORDER BY txn_time DESC;
END $$
DELIMITER ;


-- ✅ SP6: Add new loan for customer (simple loan entry)
DELIMITER $$
CREATE PROCEDURE add_loan(
    IN p_customer_id INT,
    IN p_branch_id INT,
    IN p_account_id BIGINT,
    IN p_loan_type VARCHAR(50),
    IN p_amount DECIMAL(15,2),
    IN p_rate DECIMAL(5,2),
    IN p_term INT
)
BEGIN
    INSERT INTO loans(customer_id, branch_id, account_id, loan_type, principal,
                      interest_rate, term_months, start_date, status)
    VALUES(p_customer_id, p_branch_id, p_account_id, p_loan_type,
           p_amount, p_rate, p_term, CURDATE(), 'approved');
END $$
DELIMITER ;


-- ✅ SP7: Count number of accounts in each branch
DELIMITER $$
CREATE PROCEDURE branch_account_summary()
BEGIN
    SELECT b.branch_name, COUNT(a.account_id) AS total_accounts
    FROM branches b
    LEFT JOIN accounts a ON b.branch_id = a.branch_id
    GROUP BY b.branch_name;
END $$
DELIMITER ;


-- ✅ SP8: Block a card manually
DELIMITER $$
CREATE PROCEDURE block_card(IN p_card_num BIGINT)
BEGIN
    UPDATE cards
    SET status = 'blocked'
    WHERE card_number = p_card_num;
END $$
DELIMITER ;


-- ✅ SP9: Close loan manually (only if fully paid)
DELIMITER $$
CREATE PROCEDURE close_loan(IN p_loan_id BIGINT)
BEGIN
    UPDATE loans
    SET status = 'closed'
    WHERE loan_id = p_loan_id
      AND loan_id IN (
            SELECT loan_id 
            FROM loan_payments 
            GROUP BY loan_id 
            HAVING SUM(amount) >= (SELECT principal FROM loans WHERE loan_id = p_loan_id)
      );
END $$
DELIMITER ;


-- ✅ SP10: Calculate total balance of a customer across all their accounts
DELIMITER $$
CREATE PROCEDURE get_total_customer_balance(IN p_customer_id INT)
BEGIN
    SELECT c.customer_id, c.first_name, c.last_name,
           SUM(a.balance) AS total_balance
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    WHERE c.customer_id = p_customer_id
    GROUP BY c.customer_id;
END $$
DELIMITER ;
-- Execution Example:
-- CALL get_customer_details(10);
-- CALL get_account_transactions(15);
-- CALL block_card(5100000000000123);
-- CALL branch_account_summary();
-- CALL get_total_customer_balance(25);



-- =========================================================================
-- ✅ MySQL TRIGGERS – Real Banking Automation (10 Scenarios)
-- =========================================================================



CREATE TABLE salary_audit (
  emp_id INT,
  old_salary DECIMAL(10,2),
  new_salary DECIMAL(10,2),
  changed_on DATETIME
);



-- Q1: Prevent account balance from going below 0 (NO overdraft)
DELIMITER $$
CREATE TRIGGER trg_no_negative_balance
BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF NEW.balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient Balance - Overdraft Blocked!';
    END IF;
END $$
DELIMITER ;


-- Q2: Audit balance changes in accounts (log entry for every update)
DELIMITER $$
CREATE TRIGGER trg_log_balance_changes
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF OLD.balance <> NEW.balance THEN
        INSERT INTO transactions(account_id, txn_time, txn_type, amount, description, balance_after)
        VALUES(NEW.account_id, NOW(),
               CASE WHEN NEW.balance > OLD.balance THEN 'credit' ELSE 'debit' END,
               ABS(NEW.balance - OLD.balance),
               'Auto-log Balance Update',
               NEW.balance);
    END IF;
END $$
DELIMITER ;


-- Q3: Auto-block card if linked account is closed
DELIMITER $$
CREATE TRIGGER trg_block_card_on_account_close
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF NEW.status = 'closed' THEN
        UPDATE cards SET status = 'blocked'
        WHERE account_id = NEW.account_id;
    END IF;
END $$
DELIMITER ;


-- Q4: Prevent updating loan principal once approved
DELIMITER $$
CREATE TRIGGER trg_no_loan_principal_change
BEFORE UPDATE ON loans
FOR EACH ROW
BEGIN
    IF OLD.principal <> NEW.principal THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Loan principal cannot be modified!';
    END IF;
END $$
DELIMITER ;


-- Q5: When new loan is approved → set first EMI due next month
DELIMITER $$
CREATE TRIGGER trg_insert_first_emi
AFTER INSERT ON loans
FOR EACH ROW
BEGIN
    INSERT INTO loan_payments(loan_id, due_date, amount, principal_component,
                              interest_component, status)
    VALUES (
        NEW.loan_id,
        DATE_ADD(NEW.start_date, INTERVAL 1 MONTH),
        ROUND(NEW.principal / NEW.term_months + (NEW.principal * NEW.interest_rate/100/12),2),
        ROUND(NEW.principal/NEW.term_months,2),
        ROUND(NEW.principal * (NEW.interest_rate/100/12),2),
        'due'
    );
END $$
DELIMITER ;


-- Q6: When an employee resigns, set employees reporting to them → manager NULL
DELIMITER $$
CREATE TRIGGER trg_update_manager_on_employee_leave
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    UPDATE employees
    SET manager_id = NULL
    WHERE manager_id = OLD.employee_id;
END $$
DELIMITER ;


-- Q7: Auto set status='expired' when card expiry passed
DELIMITER $$
CREATE TRIGGER trg_auto_expire_card
BEFORE UPDATE ON cards
FOR EACH ROW
BEGIN
    IF NEW.expiry < CURDATE() THEN
        SET NEW.status = 'expired';
    END IF;
END $$
DELIMITER ;


-- Q8: Prevent DELETE of customers having accounts or loans
DELIMITER $$
CREATE TRIGGER trg_prevent_customer_delete
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN
    IF EXISTS(SELECT 1 FROM accounts WHERE customer_id = OLD.customer_id) OR
       EXISTS(SELECT 1 FROM loans WHERE customer_id = OLD.customer_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Customer cannot be deleted - linked accounts or loans exist!';
    END IF;
END $$
DELIMITER ;


-- Q9: Track changes in employee salary into an audit table
-- (Assumes salary_audit table exists)
-- CREATE TABLE salary_audit(emp_id INT, old_salary DECIMAL(10,2),
--                           new_salary DECIMAL(10,2), changed_on DATETIME);
DELIMITER $$
CREATE TRIGGER trg_salary_audit
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_audit(emp_id, old_salary, new_salary, changed_on)
        VALUES(OLD.employee_id, OLD.salary, NEW.salary, NOW());
    END IF;
END $$
DELIMITER ;


-- Q10: Auto-update account status to 'closed' when balance becomes 0 AND account is inactive for 3 years
DELIMITER $$
CREATE TRIGGER trg_auto_close_inactive_account
BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF NEW.balance = 0 AND NEW.opened_at < DATE_SUB(CURDATE(), INTERVAL 3 YEAR) THEN
        SET NEW.status = 'closed';
    END IF;
END $$
DELIMITER ;

-- ===========================================================
-- ✅ FULL CLEANUP SCRIPT for MySQL
-- Database: bank_management_system
-- ===========================================================

-- Switch to correct database
USE bank_management_system;

-- ✅ 1️⃣ Drop Triggers (avoid dependency errors)
DROP TRIGGER IF EXISTS trg_no_negative_balance;
DROP TRIGGER IF EXISTS trg_log_balance_changes;
DROP TRIGGER IF EXISTS trg_block_card_on_account_close;
DROP TRIGGER IF EXISTS trg_no_loan_principal_change;
DROP TRIGGER IF EXISTS trg_insert_first_emi;
DROP TRIGGER IF EXISTS trg_update_manager_on_employee_leave;
DROP TRIGGER IF EXISTS trg_auto_expire_card;
DROP TRIGGER IF EXISTS trg_prevent_customer_delete;
DROP TRIGGER IF EXISTS trg_salary_audit;
DROP TRIGGER IF EXISTS trg_auto_close_inactive_account;


-- ✅ 2️⃣ Drop Stored Procedures
DROP PROCEDURE IF EXISTS transfer_money;
DROP PROCEDURE IF EXISTS pay_emi;
DROP PROCEDURE IF EXISTS close_inactive_accounts;
DROP PROCEDURE IF EXISTS detect_fraud_and_block;
DROP PROCEDURE IF EXISTS apply_yearly_interest;
DROP PROCEDURE IF EXISTS log_transaction;

DROP PROCEDURE IF EXISTS get_customer_details;
DROP PROCEDURE IF EXISTS get_customer_accounts;
DROP PROCEDURE IF EXISTS update_customer_phone;
DROP PROCEDURE IF EXISTS get_active_cards;
DROP PROCEDURE IF EXISTS get_account_transactions;
DROP PROCEDURE IF EXISTS add_loan;
DROP PROCEDURE IF EXISTS branch_account_summary;
DROP PROCEDURE IF EXISTS block_card;
DROP PROCEDURE IF EXISTS close_loan;
DROP PROCEDURE IF EXISTS get_total_customer_balance;


-- ✅ 3️⃣ Drop Views
DROP VIEW IF EXISTS v_masked_customers;
DROP VIEW IF EXISTS v_high_value_customers;
DROP VIEW IF EXISTS v_branch_performance;
DROP VIEW IF EXISTS v_expiring_cards;
DROP VIEW IF EXISTS v_late_loans;
DROP VIEW IF EXISTS v_employee_hierarchy;
DROP VIEW IF EXISTS v_loan_progress;
DROP VIEW IF EXISTS v_dormant_accounts;


-- ✅ 4️⃣ Drop Tables (disable foreign key checks first)
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS salary_audit;
DROP TABLE IF EXISTS loan_payments;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS cards;
DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;

SET FOREIGN_KEY_CHECKS = 1;


-- ✅ 5️⃣ Finally Remove the Database
DROP DATABASE IF EXISTS bank_management_system;
