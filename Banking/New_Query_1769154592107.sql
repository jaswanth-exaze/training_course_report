-- DROP DATABASE IF EXISTS banking_system;
-- SHOW DATABASES;
CREATE DATABASE banking_system
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE banking_system;

CREATE TABLE roles (
  role_id INT AUTO_INCREMENT PRIMARY KEY,
  role_name ENUM('CUSTOMER','EMPLOYEE','MANAGER') UNIQUE NOT NULL
);
CREATE TABLE branches (
  branch_id INT AUTO_INCREMENT PRIMARY KEY,
  branch_code VARCHAR(10) UNIQUE NOT NULL,
  branch_name VARCHAR(100) NOT NULL,
  city VARCHAR(50),
  state VARCHAR(50)
);
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role_id INT NOT NULL,
  branch_id INT NOT NULL,
  is_active BOOLEAN DEFAULT 1,

  FOREIGN KEY (role_id) REFERENCES roles(role_id),
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);
CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNIQUE NOT NULL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(15),

  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE employees (
  employee_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNIQUE NOT NULL,
  designation VARCHAR(50),
  joined_date DATE,

  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE accounts (
  account_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  account_number VARCHAR(20) UNIQUE NOT NULL,
  account_type ENUM('SAVINGS','CURRENT') NOT NULL,
  balance DECIMAL(12,2) DEFAULT 0,
  status ENUM('ACTIVE','BLOCKED','CLOSED') DEFAULT 'ACTIVE',

  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE transactions (
  transaction_id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT NOT NULL,
  transaction_type ENUM('CREDIT','DEBIT'),
  amount DECIMAL(12,2),
  description VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
-- Insert roles first (if not already inserted)
INSERT IGNORE INTO roles (role_name) VALUES 
('CUSTOMER'), 
('EMPLOYEE'), 
('MANAGER');

-- Insert branches with Indian locations
INSERT INTO branches (branch_code, branch_name, city, state) VALUES
('BR001','Hyderabad – Madhapur','Hyderabad','Telangana'),
('BR002','Bangalore – Whitefield','Bangalore','Karnataka'),
('BR003','Chennai – T Nagar','Chennai','Tamil Nadu'),
('BR004','Mumbai – Andheri East','Mumbai','Maharashtra'),
('BR005','Delhi – Connaught Place','New Delhi','Delhi'),
('BR006','Pune – Hinjewadi','Pune','Maharashtra'),
('BR007','Kolkata – Salt Lake','Kolkata','West Bengal');

-- Common password hash for all users
SET @common_password = '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK';

-- ==================== BRANCH 1: Hyderabad – Madhapur ====================
-- Manager
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('arjun.reddy.mgr', @common_password, 3, 1);
SET @manager_user_id = LAST_INSERT_ID();
INSERT INTO employees (user_id, designation, joined_date) VALUES
(@manager_user_id, 'Branch Manager', '2018-04-10');

-- Employees (5 employees)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('priya.sharma', @common_password, 2, 1),
('vikram.singh', @common_password, 2, 1),
('ananya.patel', @common_password, 2, 1),
('rakesh.kumar', @common_password, 2, 1),
('meera.desai', @common_password, 2, 1);

INSERT INTO employees (user_id, designation, joined_date) VALUES
(LAST_INSERT_ID()-4, 'Senior Teller', '2020-07-15'),
(LAST_INSERT_ID()-3, 'Loan Officer', '2019-12-01'),
(LAST_INSERT_ID()-2, 'Customer Service Rep', '2021-03-10'),
(LAST_INSERT_ID()-1, 'Financial Advisor', '2020-09-22'),
(LAST_INSERT_ID(), 'Operations Specialist', '2022-01-20');

-- Customers (20 customers)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('suresh.goud', @common_password, 1, 1),
('lakshmi.reddy', @common_password, 1, 1),
('kiran.kumar', @common_password, 1, 1),
('swathi.naidu', @common_password, 1, 1),
('venkat.rao', @common_password, 1, 1),
('geeta.sharma', @common_password, 1, 1),
('rajesh.yadav', @common_password, 1, 1),
('padmini.nair', @common_password, 1, 1),
('mohan.das', @common_password, 1, 1),
('anuradha.singh', @common_password, 1, 1),
('sai.ram', @common_password, 1, 1),
('chitra.iyer', @common_password, 1, 1),
('praveen.menon', @common_password, 1, 1),
('radhika.gupta', @common_password, 1, 1),
('harish.chandra', @common_password, 1, 1),
('vasantha.kumari', @common_password, 1, 1),
('nitin.agarwal', @common_password, 1, 1),
('malini.sen', @common_password, 1, 1),
('deepak.jain', @common_password, 1, 1),
('shobha.verma', @common_password, 1, 1);

-- Create customer profiles
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
(LAST_INSERT_ID()-19, 'Suresh', 'Goud', 'suresh.goud@example.com', '9876543210'),
(LAST_INSERT_ID()-18, 'Lakshmi', 'Reddy', 'lakshmi.reddy@example.com', '9876543211'),
(LAST_INSERT_ID()-17, 'Kiran', 'Kumar', 'kiran.kumar@example.com', '9876543212'),
(LAST_INSERT_ID()-16, 'Swathi', 'Naidu', 'swathi.naidu@example.com', '9876543213'),
(LAST_INSERT_ID()-15, 'Venkat', 'Rao', 'venkat.rao@example.com', '9876543214'),
(LAST_INSERT_ID()-14, 'Geeta', 'Sharma', 'geeta.sharma@example.com', '9876543215'),
(LAST_INSERT_ID()-13, 'Rajesh', 'Yadav', 'rajesh.yadav@example.com', '9876543216'),
(LAST_INSERT_ID()-12, 'Padmini', 'Nair', 'padmini.nair@example.com', '9876543217'),
(LAST_INSERT_ID()-11, 'Mohan', 'Das', 'mohan.das@example.com', '9876543218'),
(LAST_INSERT_ID()-10, 'Anuradha', 'Singh', 'anuradha.singh@example.com', '9876543219'),
(LAST_INSERT_ID()-9, 'Sai', 'Ram', 'sai.ram@example.com', '9876543220'),
(LAST_INSERT_ID()-8, 'Chitra', 'Iyer', 'chitra.iyer@example.com', '9876543221'),
(LAST_INSERT_ID()-7, 'Praveen', 'Menon', 'praveen.menon@example.com', '9876543222'),
(LAST_INSERT_ID()-6, 'Radhika', 'Gupta', 'radhika.gupta@example.com', '9876543223'),
(LAST_INSERT_ID()-5, 'Harish', 'Chandra', 'harish.chandra@example.com', '9876543224'),
(LAST_INSERT_ID()-4, 'Vasantha', 'Kumari', 'vasantha.kumari@example.com', '9876543225'),
(LAST_INSERT_ID()-3, 'Nitin', 'Agarwal', 'nitin.agarwal@example.com', '9876543226'),
(LAST_INSERT_ID()-2, 'Malini', 'Sen', 'malini.sen@example.com', '9876543227'),
(LAST_INSERT_ID()-1, 'Deepak', 'Jain', 'deepak.jain@example.com', '9876543228'),
(LAST_INSERT_ID(), 'Shobha', 'Verma', 'shobha.verma@example.com', '9876543229');

-- ==================== BRANCH 2: Bangalore – Whitefield ====================
-- Manager
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('rajesh.nair.mgr', @common_password, 3, 2);
SET @manager_user_id = LAST_INSERT_ID();
INSERT INTO employees (user_id, designation, joined_date) VALUES
(@manager_user_id, 'Branch Manager', '2019-02-18');

-- Employees (5 employees)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('anjali.menon', @common_password, 2, 2),
('sandeep.iyer', @common_password, 2, 2),
('divya.rao', @common_password, 2, 2),
('karthik.pillai', @common_password, 2, 2),
('neha.bhat', @common_password, 2, 2);

INSERT INTO employees (user_id, designation, joined_date) VALUES
(LAST_INSERT_ID()-4, 'Senior Teller', '2021-05-12'),
(LAST_INSERT_ID()-3, 'Loan Officer', '2020-10-08'),
(LAST_INSERT_ID()-2, 'Customer Service Rep', '2022-01-25'),
(LAST_INSERT_ID()-1, 'Financial Advisor', '2021-07-14'),
(LAST_INSERT_ID(), 'Operations Specialist', '2023-03-03');

-- Customers (20 customers)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('aravind.krishnan', @common_password, 1, 2),
('meenakshi.sundaram', @common_password, 1, 2),
('ganesh.kumar', @common_password, 1, 2),
('shalini.ramesh', @common_password, 1, 2),
('prakash.chandran', @common_password, 1, 2),
('vidya.venkat', @common_password, 1, 2),
('ramesh.babu', @common_password, 1, 2),
('lavanya.raghavan', @common_password, 1, 2),
('sundar.raman', @common_password, 1, 2),
('preeti.shah', @common_password, 1, 2),
('manoj.shetty', @common_password, 1, 2),
('rekha.pai', @common_password, 1, 2),
('srinivas.murthy', @common_password, 1, 2),
('anitha.deshmukh', @common_password, 1, 2),
('vijay.kulkarni', @common_password, 1, 2),
('sunita.bose', @common_password, 1, 2),
('ashwin.narayan', @common_password, 1, 2),
('pooja.mehta', @common_password, 1, 2),
('girish.joshi', @common_password, 1, 2),
('bhavana.reddy', @common_password, 1, 2);

-- Create customer profiles
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
(LAST_INSERT_ID()-19, 'Aravind', 'Krishnan', 'aravind.krishnan@example.com', '9876543230'),
(LAST_INSERT_ID()-18, 'Meenakshi', 'Sundaram', 'meenakshi.sundaram@example.com', '9876543231'),
(LAST_INSERT_ID()-17, 'Ganesh', 'Kumar', 'ganesh.kumar@example.com', '9876543232'),
(LAST_INSERT_ID()-16, 'Shalini', 'Ramesh', 'shalini.ramesh@example.com', '9876543233'),
(LAST_INSERT_ID()-15, 'Prakash', 'Chandran', 'prakash.chandran@example.com', '9876543234'),
(LAST_INSERT_ID()-14, 'Vidya', 'Venkat', 'vidya.venkat@example.com', '9876543235'),
(LAST_INSERT_ID()-13, 'Ramesh', 'Babu', 'ramesh.babu@example.com', '9876543236'),
(LAST_INSERT_ID()-12, 'Lavanya', 'Raghavan', 'lavanya.raghavan@example.com', '9876543237'),
(LAST_INSERT_ID()-11, 'Sundar', 'Raman', 'sundar.raman@example.com', '9876543238'),
(LAST_INSERT_ID()-10, 'Preeti', 'Shah', 'preeti.shah@example.com', '9876543239'),
(LAST_INSERT_ID()-9, 'Manoj', 'Shetty', 'manoj.shetty@example.com', '9876543240'),
(LAST_INSERT_ID()-8, 'Rekha', 'Pai', 'rekha.pai@example.com', '9876543241'),
(LAST_INSERT_ID()-7, 'Srinivas', 'Murthy', 'srinivas.murthy@example.com', '9876543242'),
(LAST_INSERT_ID()-6, 'Anitha', 'Deshmukh', 'anitha.deshmukh@example.com', '9876543243'),
(LAST_INSERT_ID()-5, 'Vijay', 'Kulkarni', 'vijay.kulkarni@example.com', '9876543244'),
(LAST_INSERT_ID()-4, 'Sunita', 'Bose', 'sunita.bose@example.com', '9876543245'),
(LAST_INSERT_ID()-3, 'Ashwin', 'Narayan', 'ashwin.narayan@example.com', '9876543246'),
(LAST_INSERT_ID()-2, 'Pooja', 'Mehta', 'pooja.mehta@example.com', '9876543247'),
(LAST_INSERT_ID()-1, 'Girish', 'Joshi', 'girish.joshi@example.com', '9876543248'),
(LAST_INSERT_ID(), 'Bhavana', 'Reddy', 'bhavana.reddy@example.com', '9876543249');

-- ==================== BRANCH 3: Chennai – T Nagar ====================
-- Manager
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('sundar.iyer.mgr', @common_password, 3, 3);
SET @manager_user_id = LAST_INSERT_ID();
INSERT INTO employees (user_id, designation, joined_date) VALUES
(@manager_user_id, 'Branch Manager', '2017-11-05');

-- Employees (5 employees)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('lakshmi.rajan', @common_password, 2, 3),
('venkatesh.pillai', @common_password, 2, 3),
('malini.subramanian', @common_password, 2, 3),
('gopal.raman', @common_password, 2, 3),
('usha.krishnan', @common_password, 2, 3);

INSERT INTO employees (user_id, designation, joined_date) VALUES
(LAST_INSERT_ID()-4, 'Senior Teller', '2020-03-22'),
(LAST_INSERT_ID()-3, 'Loan Officer', '2019-08-17'),
(LAST_INSERT_ID()-2, 'Customer Service Rep', '2021-11-30'),
(LAST_INSERT_ID()-1, 'Financial Advisor', '2020-12-05'),
(LAST_INSERT_ID(), 'Operations Specialist', '2022-06-18');

-- Customers (20 customers)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('rameshwar.iyengar', @common_password, 1, 3),
('sarala.srinivasan', @common_password, 1, 3),
('balu.naidu', @common_password, 1, 3),
('chandrika.rao', @common_password, 1, 3),
('murali.venkatesh', @common_password, 1, 3),
('sita.raman', @common_password, 1, 3),
('nagarajan.pillai', @common_password, 1, 3),
('indira.menon', @common_password, 1, 3),
('subramanian.gopal', @common_password, 1, 3),
('vasanthi.kumar', @common_password, 1, 3),
('rajendran.chettiar', @common_password, 1, 3),
('padma.balan', @common_password, 1, 3),
('ganapathy.sundaram', @common_password, 1, 3),
('jaya.lakshmi', @common_password, 1, 3),
('krishnamurthy.reddy', @common_password, 1, 3),
('ambika.viswanathan', @common_password, 1, 3),
('thyagarajan.nair', @common_password, 1, 3),
('rekha.chandrasekhar', @common_password, 1, 3),
('shankar.mohan', @common_password, 1, 3),
('geetha.raghu', @common_password, 1, 3);

-- Create customer profiles
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
(LAST_INSERT_ID()-19, 'Rameshwar', 'Iyengar', 'rameshwar.iyengar@example.com', '9876543250'),
(LAST_INSERT_ID()-18, 'Sarala', 'Srinivasan', 'sarala.srinivasan@example.com', '9876543251'),
(LAST_INSERT_ID()-17, 'Balu', 'Naidu', 'balu.naidu@example.com', '9876543252'),
(LAST_INSERT_ID()-16, 'Chandrika', 'Rao', 'chandrika.rao@example.com', '9876543253'),
(LAST_INSERT_ID()-15, 'Murali', 'Venkatesh', 'murali.venkatesh@example.com', '9876543254'),
(LAST_INSERT_ID()-14, 'Sita', 'Raman', 'sita.raman@example.com', '9876543255'),
(LAST_INSERT_ID()-13, 'Nagarajan', 'Pillai', 'nagarajan.pillai@example.com', '9876543256'),
(LAST_INSERT_ID()-12, 'Indira', 'Menon', 'indira.menon@example.com', '9876543257'),
(LAST_INSERT_ID()-11, 'Subramanian', 'Gopal', 'subramanian.gopal@example.com', '9876543258'),
(LAST_INSERT_ID()-10, 'Vasanthi', 'Kumar', 'vasanthi.kumar@example.com', '9876543259'),
(LAST_INSERT_ID()-9, 'Rajendran', 'Chettiar', 'rajendran.chettiar@example.com', '9876543260'),
(LAST_INSERT_ID()-8, 'Padma', 'Balan', 'padma.balan@example.com', '9876543261'),
(LAST_INSERT_ID()-7, 'Ganapathy', 'Sundaram', 'ganapathy.sundaram@example.com', '9876543262'),
(LAST_INSERT_ID()-6, 'Jaya', 'Lakshmi', 'jaya.lakshmi@example.com', '9876543263'),
(LAST_INSERT_ID()-5, 'Krishnamurthy', 'Reddy', 'krishnamurthy.reddy@example.com', '9876543264'),
(LAST_INSERT_ID()-4, 'Ambika', 'Viswanathan', 'ambika.viswanathan@example.com', '9876543265'),
(LAST_INSERT_ID()-3, 'Thyagarajan', 'Nair', 'thyagarajan.nair@example.com', '9876543266'),
(LAST_INSERT_ID()-2, 'Rekha', 'Chandrasekhar', 'rekha.chandrasekhar@example.com', '9876543267'),
(LAST_INSERT_ID()-1, 'Shankar', 'Mohan', 'shankar.mohan@example.com', '9876543268'),
(LAST_INSERT_ID(), 'Geetha', 'Raghu', 'geetha.raghu@example.com', '9876543269');

-- Note: Continue this pattern for branches 4-7 (Mumbai, Delhi, Pune, Kolkata)
-- Each branch would follow the same structure:
-- 1 Manager, 5 Employees, 20 Customers
-- Total across 7 branches: 7 Managers, 35 Employees, 140 Customers

-- You can continue the pattern for remaining 4 branches following the same structure

-- ==================== BRANCH 4: Mumbai – Andheri East ====================
-- Manager
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('rohit.shah.mgr', @common_password, 3, 4);
SET @manager_user_id = LAST_INSERT_ID();
INSERT INTO employees (user_id, designation, joined_date) VALUES
(@manager_user_id, 'Branch Manager', '2018-09-22');

-- Employees (5 employees)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('aisha.kapoor', @common_password, 2, 4),
('samir.desai', @common_password, 2, 4),
('tanvi.mehta', @common_password, 2, 4),
('rajiv.chopra', @common_password, 2, 4),
('priyanka.singhania', @common_password, 2, 4);

INSERT INTO employees (user_id, designation, joined_date) VALUES
(LAST_INSERT_ID()-4, 'Senior Teller', '2020-11-08'),
(LAST_INSERT_ID()-3, 'Loan Officer', '2021-04-15'),
(LAST_INSERT_ID()-2, 'Customer Service Rep', '2022-02-28'),
(LAST_INSERT_ID()-1, 'Financial Advisor', '2020-08-03'),
(LAST_INSERT_ID(), 'Operations Specialist', '2023-01-12');

-- Customers (20 customers)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('amit.verma', @common_password, 1, 4),
('neeta.shroff', @common_password, 1, 4),
('vikas.jain', @common_password, 1, 4),
('sanjana.bhatia', @common_password, 1, 4),
('rahul.agarwal', @common_password, 1, 4),
('pooja.malhotra', @common_password, 1, 4),
('manish.tiwari', @common_password, 1, 4),
('anushka.saxena', @common_password, 1, 4),
('siddharth.oberoi', @common_password, 1, 4),
('ritu.bansal', @common_password, 1, 4),
('harsh.parmar', @common_password, 1, 4),
('shreya.khanna', @common_password, 1, 4),
('akash.thakkar', @common_password, 1, 4),
('divya.doshi', @common_password, 1, 4),
('varun.naik', @common_password, 1, 4),
('kavita.reddy', @common_password, 1, 4),
('sameer.bhosale', @common_password, 1, 4),
('anita.pawar', @common_password, 1, 4),
('rohan.kamble', @common_password, 1, 4),
('tanya.mistry', @common_password, 1, 4);

-- Create customer profiles
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
(LAST_INSERT_ID()-19, 'Amit', 'Verma', 'amit.verma@example.com', '9876543270'),
(LAST_INSERT_ID()-18, 'Neeta', 'Shroff', 'neeta.shroff@example.com', '9876543271'),
(LAST_INSERT_ID()-17, 'Vikas', 'Jain', 'vikas.jain@example.com', '9876543272'),
(LAST_INSERT_ID()-16, 'Sanjana', 'Bhatia', 'sanjana.bhatia@example.com', '9876543273'),
(LAST_INSERT_ID()-15, 'Rahul', 'Agarwal', 'rahul.agarwal@example.com', '9876543274'),
(LAST_INSERT_ID()-14, 'Pooja', 'Malhotra', 'pooja.malhotra@example.com', '9876543275'),
(LAST_INSERT_ID()-13, 'Manish', 'Tiwari', 'manish.tiwari@example.com', '9876543276'),
(LAST_INSERT_ID()-12, 'Anushka', 'Saxena', 'anushka.saxena@example.com', '9876543277'),
(LAST_INSERT_ID()-11, 'Siddharth', 'Oberoi', 'siddharth.oberoi@example.com', '9876543278'),
(LAST_INSERT_ID()-10, 'Ritu', 'Bansal', 'ritu.bansal@example.com', '9876543279'),
(LAST_INSERT_ID()-9, 'Harsh', 'Parmar', 'harsh.parmar@example.com', '9876543280'),
(LAST_INSERT_ID()-8, 'Shreya', 'Khanna', 'shreya.khanna@example.com', '9876543281'),
(LAST_INSERT_ID()-7, 'Akash', 'Thakkar', 'akash.thakkar@example.com', '9876543282'),
(LAST_INSERT_ID()-6, 'Divya', 'Doshi', 'divya.doshi@example.com', '9876543283'),
(LAST_INSERT_ID()-5, 'Varun', 'Naik', 'varun.naik@example.com', '9876543284'),
(LAST_INSERT_ID()-4, 'Kavita', 'Reddy', 'kavita.reddy@example.com', '9876543285'),
(LAST_INSERT_ID()-3, 'Sameer', 'Bhosale', 'sameer.bhosale@example.com', '9876543286'),
(LAST_INSERT_ID()-2, 'Anita', 'Pawar', 'anita.pawar@example.com', '9876543287'),
(LAST_INSERT_ID()-1, 'Rohan', 'Kamble', 'rohan.kamble@example.com', '9876543288'),
(LAST_INSERT_ID(), 'Tanya', 'Mistry', 'tanya.mistry@example.com', '9876543289');

-- ==================== BRANCH 5: Delhi – Connaught Place ====================
-- Manager
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('vivek.saxena.mgr', @common_password, 3, 5);
SET @manager_user_id = LAST_INSERT_ID();
INSERT INTO employees (user_id, designation, joined_date) VALUES
(@manager_user_id, 'Branch Manager', '2019-06-14');

-- Employees (5 employees)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('anisha.gupta', @common_password, 2, 5),
('arun.malik', @common_password, 2, 5),
('shikha.arora', @common_password, 2, 5),
('rohit.kapoor', @common_password, 2, 5),
('megha.tyagi', @common_password, 2, 5);

INSERT INTO employees (user_id, designation, joined_date) VALUES
(LAST_INSERT_ID()-4, 'Senior Teller', '2021-08-25'),
(LAST_INSERT_ID()-3, 'Loan Officer', '2020-12-10'),
(LAST_INSERT_ID()-2, 'Customer Service Rep', '2022-04-05'),
(LAST_INSERT_ID()-1, 'Financial Advisor', '2021-02-18'),
(LAST_INSERT_ID(), 'Operations Specialist', '2023-03-22');

-- Customers (20 customers)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('nitin.chauhan', @common_password, 1, 5),
('monika.sharma', @common_password, 1, 5),
('pankaj.singh', @common_password, 1, 5),
('swati.goel', @common_password, 1, 5),
('alok.bhardwaj', @common_password, 1, 5),
('ritu.bhargava', @common_password, 1, 5),
('sumit.tomar', @common_password, 1, 5),
('nidhi.rastogi', @common_password, 1, 5),
('ankit.mittal', @common_password, 1, 5),
('preeti.dua', @common_password, 1, 5),
('ravi.yadav', @common_password, 1, 5),
('sonali.sarin', @common_password, 1, 5),
('deepak.rawat', @common_password, 1, 5),
('anamika.verma', @common_password, 1, 5),
('sanjeev.kumar', @common_password, 1, 5),
('kiran.bedi', @common_password, 1, 5),
('vishal.agarwal', @common_password, 1, 5),
('pallavi.singhal', @common_password, 1, 5),
('gaurav.nagpal', @common_password, 1, 5),
('shweta.sethi', @common_password, 1, 5);

-- Create customer profiles
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
(LAST_INSERT_ID()-19, 'Nitin', 'Chauhan', 'nitin.chauhan@example.com', '9876543290'),
(LAST_INSERT_ID()-18, 'Monika', 'Sharma', 'monika.sharma@example.com', '9876543291'),
(LAST_INSERT_ID()-17, 'Pankaj', 'Singh', 'pankaj.singh@example.com', '9876543292'),
(LAST_INSERT_ID()-16, 'Swati', 'Goel', 'swati.goel@example.com', '9876543293'),
(LAST_INSERT_ID()-15, 'Alok', 'Bhardwaj', 'alok.bhardwaj@example.com', '9876543294'),
(LAST_INSERT_ID()-14, 'Ritu', 'Bhargava', 'ritu.bhargava@example.com', '9876543295'),
(LAST_INSERT_ID()-13, 'Sumit', 'Tomar', 'sumit.tomar@example.com', '9876543296'),
(LAST_INSERT_ID()-12, 'Nidhi', 'Rastogi', 'nidhi.rastogi@example.com', '9876543297'),
(LAST_INSERT_ID()-11, 'Ankit', 'Mittal', 'ankit.mittal@example.com', '9876543298'),
(LAST_INSERT_ID()-10, 'Preeti', 'Dua', 'preeti.dua@example.com', '9876543299'),
(LAST_INSERT_ID()-9, 'Ravi', 'Yadav', 'ravi.yadav@example.com', '9876543300'),
(LAST_INSERT_ID()-8, 'Sonali', 'Sarin', 'sonali.sarin@example.com', '9876543301'),
(LAST_INSERT_ID()-7, 'Deepak', 'Rawat', 'deepak.rawat@example.com', '9876543302'),
(LAST_INSERT_ID()-6, 'Anamika', 'Verma', 'anamika.verma@example.com', '9876543303'),
(LAST_INSERT_ID()-5, 'Sanjeev', 'Kumar', 'sanjeev.kumar@example.com', '9876543304'),
(LAST_INSERT_ID()-4, 'Kiran', 'Bedi', 'kiran.bedi@example.com', '9876543305'),
(LAST_INSERT_ID()-3, 'Vishal', 'Agarwal', 'vishal.agarwal@example.com', '9876543306'),
(LAST_INSERT_ID()-2, 'Pallavi', 'Singhal', 'pallavi.singhal@example.com', '9876543307'),
(LAST_INSERT_ID()-1, 'Gaurav', 'Nagpal', 'gaurav.nagpal@example.com', '9876543308'),
(LAST_INSERT_ID(), 'Shweta', 'Sethi', 'shweta.sethi@example.com', '9876543309');

-- ==================== BRANCH 6: Pune – Hinjewadi ====================
-- Manager
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('sanjay.patil.mgr', @common_password, 3, 6);
SET @manager_user_id = LAST_INSERT_ID();
INSERT INTO employees (user_id, designation, joined_date) VALUES
(@manager_user_id, 'Branch Manager', '2020-01-20');

-- Employees (5 employees)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('snehal.joshi', @common_password, 2, 6),
('amol.kulkarni', @common_password, 2, 6),
('rashmi.deshpande', @common_password, 2, 6),
('prasad.more', @common_password, 2, 6),
('supriya.gaikwad', @common_password, 2, 6);

INSERT INTO employees (user_id, designation, joined_date) VALUES
(LAST_INSERT_ID()-4, 'Senior Teller', '2022-03-11'),
(LAST_INSERT_ID()-3, 'Loan Officer', '2021-07-29'),
(LAST_INSERT_ID()-2, 'Customer Service Rep', '2023-01-15'),
(LAST_INSERT_ID()-1, 'Financial Advisor', '2021-11-03'),
(LAST_INSERT_ID(), 'Operations Specialist', '2023-05-08');

-- Customers (20 customers)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('abhijit.bhide', @common_password, 1, 6),
('varsha.thalte', @common_password, 1, 6),
('prasad.chavan', @common_password, 1, 6),
('ashwini.sawant', @common_password, 1, 6),
('rajendra.salunkhe', @common_password, 1, 6),
('smita.kadam', @common_password, 1, 6),
('vikram.mhatre', @common_password, 1, 6),
('anagha.paranjape', @common_password, 1, 6),
('sachin.bhosale', @common_password, 1, 6),
('pooja.rane', @common_password, 1, 6),
('nitin.wagh', @common_password, 1, 6),
('meera.kale', @common_password, 1, 6),
('dinesh.jadhav', @common_password, 1, 6),
('shubhangi.moghe', @common_password, 1, 6),
('pradeep.nalawade', @common_password, 1, 6),
('ananya.pendse', @common_password, 1, 6),
('rakesh.thorat', @common_password, 1, 6),
('tejashree.barve', @common_password, 1, 6),
('sandeep.ghatge', @common_password, 1, 6),
('deepali.kirtane', @common_password, 1, 6);

-- Create customer profiles
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
(LAST_INSERT_ID()-19, 'Abhijit', 'Bhide', 'abhijit.bhide@example.com', '9876543310'),
(LAST_INSERT_ID()-18, 'Varsha', 'Thalte', 'varsha.thalte@example.com', '9876543311'),
(LAST_INSERT_ID()-17, 'Prasad', 'Chavan', 'prasad.chavan@example.com', '9876543312'),
(LAST_INSERT_ID()-16, 'Ashwini', 'Sawant', 'ashwini.sawant@example.com', '9876543313'),
(LAST_INSERT_ID()-15, 'Rajendra', 'Salunkhe', 'rajendra.salunkhe@example.com', '9876543314'),
(LAST_INSERT_ID()-14, 'Smita', 'Kadam', 'smita.kadam@example.com', '9876543315'),
(LAST_INSERT_ID()-13, 'Vikram', 'Mhatre', 'vikram.mhatre@example.com', '9876543316'),
(LAST_INSERT_ID()-12, 'Anagha', 'Paranjape', 'anagha.paranjape@example.com', '9876543317'),
(LAST_INSERT_ID()-11, 'Sachin', 'Bhosale', 'sachin.bhosale@example.com', '9876543318'),
(LAST_INSERT_ID()-10, 'Pooja', 'Rane', 'pooja.rane@example.com', '9876543319'),
(LAST_INSERT_ID()-9, 'Nitin', 'Wagh', 'nitin.wagh@example.com', '9876543320'),
(LAST_INSERT_ID()-8, 'Meera', 'Kale', 'meera.kale@example.com', '9876543321'),
(LAST_INSERT_ID()-7, 'Dinesh', 'Jadhav', 'dinesh.jadhav@example.com', '9876543322'),
(LAST_INSERT_ID()-6, 'Shubhangi', 'Moghe', 'shubhangi.moghe@example.com', '9876543323'),
(LAST_INSERT_ID()-5, 'Pradeep', 'Nalawade', 'pradeep.nalawade@example.com', '9876543324'),
(LAST_INSERT_ID()-4, 'Ananya', 'Pendse', 'ananya.pendse@example.com', '9876543325'),
(LAST_INSERT_ID()-3, 'Rakesh', 'Thorat', 'rakesh.thorat@example.com', '9876543326'),
(LAST_INSERT_ID()-2, 'Tejashree', 'Barve', 'tejashree.barve@example.com', '9876543327'),
(LAST_INSERT_ID()-1, 'Sandeep', 'Ghatge', 'sandeep.ghatge@example.com', '9876543328'),
(LAST_INSERT_ID(), 'Deepali', 'Kirtane', 'deepali.kirtane@example.com', '9876543329');

-- ==================== BRANCH 7: Kolkata – Salt Lake ====================
-- Manager
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('soumitra.bose.mgr', @common_password, 3, 7);
SET @manager_user_id = LAST_INSERT_ID();
INSERT INTO employees (user_id, designation, joined_date) VALUES
(@manager_user_id, 'Branch Manager', '2018-12-08');

-- Employees (5 employees)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('indrani.ganguly', @common_password, 2, 7),
('debashis.mukherjee', @common_password, 2, 7),
('moumita.ghosh', @common_password, 2, 7),
('subhro.dasgupta', @common_password, 2, 7),
('rinku.saha', @common_password, 2, 7);

INSERT INTO employees (user_id, designation, joined_date) VALUES
(LAST_INSERT_ID()-4, 'Senior Teller', '2021-04-25'),
(LAST_INSERT_ID()-3, 'Loan Officer', '2020-09-12'),
(LAST_INSERT_ID()-2, 'Customer Service Rep', '2022-07-18'),
(LAST_INSERT_ID()-1, 'Financial Advisor', '2021-01-30'),
(LAST_INSERT_ID(), 'Operations Specialist', '2023-02-14');

-- Customers (20 customers)
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
('arnab.chatterjee', @common_password, 1, 7),
('mousumi.banerjee', @common_password, 1, 7),
('pranab.roy', @common_password, 1, 7),
('sharmistha.mitra', @common_password, 1, 7),
('santanu.sen', @common_password, 1, 7),
('bhaswati.dutta', @common_password, 1, 7),
('subir.sarkar', @common_password, 1, 7),
('tumpa.majumdar', @common_password, 1, 7),
('amitava.chakraborty', @common_password, 1, 7),
('mou.das', @common_password, 1, 7),
('sudipto.bhattacharya', @common_password, 1, 7),
('poulomi.bose', @common_password, 1, 7),
('ranjan.kundu', @common_password, 1, 7),
('shraboni.halder', @common_password, 1, 7),
('abhirup.pal', @common_password, 1, 7),
('jayashree.mallick', @common_password, 1, 7),
('somnath.mondal', @common_password, 1, 7),
('paromita.bhowmick', @common_password, 1, 7),
('bikash.debnath', @common_password, 1, 7),
('sreeparna.guha', @common_password, 1, 7);

-- Create customer profiles
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
(LAST_INSERT_ID()-19, 'Arnab', 'Chatterjee', 'arnab.chatterjee@example.com', '9876543330'),
(LAST_INSERT_ID()-18, 'Mousumi', 'Banerjee', 'mousumi.banerjee@example.com', '9876543331'),
(LAST_INSERT_ID()-17, 'Pranab', 'Roy', 'pranab.roy@example.com', '9876543332'),
(LAST_INSERT_ID()-16, 'Sharmistha', 'Mitra', 'sharmistha.mitra@example.com', '9876543333'),
(LAST_INSERT_ID()-15, 'Santanu', 'Sen', 'santanu.sen@example.com', '9876543334'),
(LAST_INSERT_ID()-14, 'Bhaswati', 'Dutta', 'bhaswati.dutta@example.com', '9876543335'),
(LAST_INSERT_ID()-13, 'Subir', 'Sarkar', 'subir.sarkar@example.com', '9876543336'),
(LAST_INSERT_ID()-12, 'Tumpa', 'Majumdar', 'tumpa.majumdar@example.com', '9876543337'),
(LAST_INSERT_ID()-11, 'Amitava', 'Chakraborty', 'amitava.chakraborty@example.com', '9876543338'),
(LAST_INSERT_ID()-10, 'Mou', 'Das', 'mou.das@example.com', '9876543339'),
(LAST_INSERT_ID()-9, 'Sudipto', 'Bhattacharya', 'sudipto.bhattacharya@example.com', '9876543340'),
(LAST_INSERT_ID()-8, 'Poulomi', 'Bose', 'poulomi.bose@example.com', '9876543341'),
(LAST_INSERT_ID()-7, 'Ranjan', 'Kundu', 'ranjan.kundu@example.com', '9876543342'),
(LAST_INSERT_ID()-6, 'Shraboni', 'Halder', 'shraboni.halder@example.com', '9876543343'),
(LAST_INSERT_ID()-5, 'Abhirup', 'Pal', 'abhirup.pal@example.com', '9876543344'),
(LAST_INSERT_ID()-4, 'Jayashree', 'Mallick', 'jayashree.mallick@example.com', '9876543345'),
(LAST_INSERT_ID()-3, 'Somnath', 'Mondal', 'somnath.mondal@example.com', '9876543346'),
(LAST_INSERT_ID()-2, 'Paromita', 'Bhowmick', 'paromita.bhowmick@example.com', '9876543347'),
(LAST_INSERT_ID()-1, 'Bikash', 'Debnath', 'bikash.debnath@example.com', '9876543348'),
(LAST_INSERT_ID(), 'Sreeparna', 'Guha', 'sreeparna.guha@example.com', '9876543349');

-- ==================== SUMMARY ====================
-- Total across 7 branches:
-- 7 Branches
-- 7 Managers
-- 35 Employees (5 per branch)
-- 140 Customers (20 per branch)
-- Total Users: 182 (7 + 35 + 140)

-- All users have the same password hash: '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK'

select * from users