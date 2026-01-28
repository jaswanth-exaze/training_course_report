-- drop database banking_system;
CREATE DATABASE banking_system
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE banking_system;

select * from transactions where account_id=281;
SELECT * from users;
select * from customers;

delete from accounts where account_id=281;

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

-- Set common password for all users
SET @common_password = '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK';

-- Insert roles
INSERT IGNORE INTO roles (role_name) VALUES 
('CUSTOMER'), 
('EMPLOYEE'), 
('MANAGER');

-- Insert branches
INSERT INTO branches (branch_code, branch_name, city, state) VALUES
('BR001','Hyderabad – Madhapur','Hyderabad','Telangana'),
('BR002','Bangalore – Whitefield','Bangalore','Karnataka'),
('BR003','Chennai – T Nagar','Chennai','Tamil Nadu'),
('BR004','Mumbai – Andheri East','Mumbai','Maharashtra'),
('BR005','Delhi – Connaught Place','New Delhi','Delhi'),
('BR006','Pune – Hinjewadi','Pune','Maharashtra'),
('BR007','Kolkata – Salt Lake','Kolkata','West Bengal');

-- ==================== BRANCH 1: Hyderabad – Madhapur ====================
-- Create all users for branch 1
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
-- Manager
('arjun.reddy.mgr.b1', @common_password, 3, 1),
-- Employees
('priya.sharma.b1', @common_password, 2, 1),
('vikram.singh.b1', @common_password, 2, 1),
('ananya.patel.b1', @common_password, 2, 1),
('rakesh.kumar.b1', @common_password, 2, 1),
('meera.desai.b1', @common_password, 2, 1),
-- Customers
('suresh.goud.b1', @common_password, 1, 1),
('lakshmi.reddy.b1', @common_password, 1, 1),
('kiran.kumar.b1', @common_password, 1, 1),
('swathi.naidu.b1', @common_password, 1, 1),
('venkat.rao.b1', @common_password, 1, 1),
('geeta.sharma.b1', @common_password, 1, 1),
('rajesh.yadav.b1', @common_password, 1, 1),
('padmini.nair.b1', @common_password, 1, 1),
('mohan.das.b1', @common_password, 1, 1),
('anuradha.singh.b1', @common_password, 1, 1),
('sai.ram.b1', @common_password, 1, 1),
('chitra.iyer.b1', @common_password, 1, 1),
('praveen.menon.b1', @common_password, 1, 1),
('radhika.gupta.b1', @common_password, 1, 1),
('harish.chandra.b1', @common_password, 1, 1),
('vasantha.kumari.b1', @common_password, 1, 1),
('nitin.agarwal.b1', @common_password, 1, 1),
('malini.sen.b1', @common_password, 1, 1),
('deepak.jain.b1', @common_password, 1, 1),
('shobha.verma.b1', @common_password, 1, 1);

-- Link manager
INSERT INTO employees (user_id, designation, joined_date)
SELECT user_id, 'Branch Manager', '2018-04-10'
FROM users WHERE username = 'arjun.reddy.mgr.b1';

-- Link employees
INSERT INTO employees (user_id, designation, joined_date) VALUES
((SELECT user_id FROM users WHERE username = 'priya.sharma.b1'), 'Senior Teller', '2020-07-15'),
((SELECT user_id FROM users WHERE username = 'vikram.singh.b1'), 'Loan Officer', '2019-12-01'),
((SELECT user_id FROM users WHERE username = 'ananya.patel.b1'), 'Customer Service Rep', '2021-03-10'),
((SELECT user_id FROM users WHERE username = 'rakesh.kumar.b1'), 'Financial Advisor', '2020-09-22'),
((SELECT user_id FROM users WHERE username = 'meera.desai.b1'), 'Operations Specialist', '2022-01-20');

-- Link customers
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
((SELECT user_id FROM users WHERE username = 'suresh.goud.b1'), 'Suresh', 'Goud', 'suresh.goud@example.com', '9876543210'),
((SELECT user_id FROM users WHERE username = 'lakshmi.reddy.b1'), 'Lakshmi', 'Reddy', 'lakshmi.reddy@example.com', '9876543211'),
((SELECT user_id FROM users WHERE username = 'kiran.kumar.b1'), 'Kiran', 'Kumar', 'kiran.kumar@example.com', '9876543212'),
((SELECT user_id FROM users WHERE username = 'swathi.naidu.b1'), 'Swathi', 'Naidu', 'swathi.naidu@example.com', '9876543213'),
((SELECT user_id FROM users WHERE username = 'venkat.rao.b1'), 'Venkat', 'Rao', 'venkat.rao@example.com', '9876543214'),
((SELECT user_id FROM users WHERE username = 'geeta.sharma.b1'), 'Geeta', 'Sharma', 'geeta.sharma@example.com', '9876543215'),
((SELECT user_id FROM users WHERE username = 'rajesh.yadav.b1'), 'Rajesh', 'Yadav', 'rajesh.yadav@example.com', '9876543216'),
((SELECT user_id FROM users WHERE username = 'padmini.nair.b1'), 'Padmini', 'Nair', 'padmini.nair@example.com', '9876543217'),
((SELECT user_id FROM users WHERE username = 'mohan.das.b1'), 'Mohan', 'Das', 'mohan.das@example.com', '9876543218'),
((SELECT user_id FROM users WHERE username = 'anuradha.singh.b1'), 'Anuradha', 'Singh', 'anuradha.singh@example.com', '9876543219'),
((SELECT user_id FROM users WHERE username = 'sai.ram.b1'), 'Sai', 'Ram', 'sai.ram@example.com', '9876543220'),
((SELECT user_id FROM users WHERE username = 'chitra.iyer.b1'), 'Chitra', 'Iyer', 'chitra.iyer@example.com', '9876543221'),
((SELECT user_id FROM users WHERE username = 'praveen.menon.b1'), 'Praveen', 'Menon', 'praveen.menon@example.com', '9876543222'),
((SELECT user_id FROM users WHERE username = 'radhika.gupta.b1'), 'Radhika', 'Gupta', 'radhika.gupta@example.com', '9876543223'),
((SELECT user_id FROM users WHERE username = 'harish.chandra.b1'), 'Harish', 'Chandra', 'harish.chandra@example.com', '9876543224'),
((SELECT user_id FROM users WHERE username = 'vasantha.kumari.b1'), 'Vasantha', 'Kumari', 'vasantha.kumari@example.com', '9876543225'),
((SELECT user_id FROM users WHERE username = 'nitin.agarwal.b1'), 'Nitin', 'Agarwal', 'nitin.agarwal@example.com', '9876543226'),
((SELECT user_id FROM users WHERE username = 'malini.sen.b1'), 'Malini', 'Sen', 'malini.sen@example.com', '9876543227'),
((SELECT user_id FROM users WHERE username = 'deepak.jain.b1'), 'Deepak', 'Jain', 'deepak.jain@example.com', '9876543228'),
((SELECT user_id FROM users WHERE username = 'shobha.verma.b1'), 'Shobha', 'Verma', 'shobha.verma@example.com', '9876543229');

-- ==================== BRANCH 2: Bangalore – Whitefield ====================
-- Create all users for branch 2
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
-- Manager
('rajesh.nair.mgr.b2', @common_password, 3, 2),
-- Employees
('anjali.menon.b2', @common_password, 2, 2),
('sandeep.iyer.b2', @common_password, 2, 2),
('divya.rao.b2', @common_password, 2, 2),
('karthik.pillai.b2', @common_password, 2, 2),
('neha.bhat.b2', @common_password, 2, 2),
-- Customers
('aravind.krishnan.b2', @common_password, 1, 2),
('meenakshi.sundaram.b2', @common_password, 1, 2),
('ganesh.kumar.b2', @common_password, 1, 2),
('shalini.ramesh.b2', @common_password, 1, 2),
('prakash.chandran.b2', @common_password, 1, 2),
('vidya.venkat.b2', @common_password, 1, 2),
('ramesh.babu.b2', @common_password, 1, 2),
('lavanya.raghavan.b2', @common_password, 1, 2),
('sundar.raman.b2', @common_password, 1, 2),
('preeti.shah.b2', @common_password, 1, 2),
('manoj.shetty.b2', @common_password, 1, 2),
('rekha.pai.b2', @common_password, 1, 2),
('srinivas.murthy.b2', @common_password, 1, 2),
('anitha.deshmukh.b2', @common_password, 1, 2),
('vijay.kulkarni.b2', @common_password, 1, 2),
('sunita.bose.b2', @common_password, 1, 2),
('ashwin.narayan.b2', @common_password, 1, 2),
('pooja.mehta.b2', @common_password, 1, 2),
('girish.joshi.b2', @common_password, 1, 2),
('bhavana.reddy.b2', @common_password, 1, 2);

-- Link manager
INSERT INTO employees (user_id, designation, joined_date)
SELECT user_id, 'Branch Manager', '2019-02-18'
FROM users WHERE username = 'rajesh.nair.mgr.b2';

-- Link employees
INSERT INTO employees (user_id, designation, joined_date) VALUES
((SELECT user_id FROM users WHERE username = 'anjali.menon.b2'), 'Senior Teller', '2021-05-12'),
((SELECT user_id FROM users WHERE username = 'sandeep.iyer.b2'), 'Loan Officer', '2020-10-08'),
((SELECT user_id FROM users WHERE username = 'divya.rao.b2'), 'Customer Service Rep', '2022-01-25'),
((SELECT user_id FROM users WHERE username = 'karthik.pillai.b2'), 'Financial Advisor', '2021-07-14'),
((SELECT user_id FROM users WHERE username = 'neha.bhat.b2'), 'Operations Specialist', '2023-03-03');

-- Link customers
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
((SELECT user_id FROM users WHERE username = 'aravind.krishnan.b2'), 'Aravind', 'Krishnan', 'aravind.krishnan@example.com', '9876543230'),
((SELECT user_id FROM users WHERE username = 'meenakshi.sundaram.b2'), 'Meenakshi', 'Sundaram', 'meenakshi.sundaram@example.com', '9876543231'),
((SELECT user_id FROM users WHERE username = 'ganesh.kumar.b2'), 'Ganesh', 'Kumar', 'ganesh.kumar@example.com', '9876543232'),
((SELECT user_id FROM users WHERE username = 'shalini.ramesh.b2'), 'Shalini', 'Ramesh', 'shalini.ramesh@example.com', '9876543233'),
((SELECT user_id FROM users WHERE username = 'prakash.chandran.b2'), 'Prakash', 'Chandran', 'prakash.chandran@example.com', '9876543234'),
((SELECT user_id FROM users WHERE username = 'vidya.venkat.b2'), 'Vidya', 'Venkat', 'vidya.venkat@example.com', '9876543235'),
((SELECT user_id FROM users WHERE username = 'ramesh.babu.b2'), 'Ramesh', 'Babu', 'ramesh.babu@example.com', '9876543236'),
((SELECT user_id FROM users WHERE username = 'lavanya.raghavan.b2'), 'Lavanya', 'Raghavan', 'lavanya.raghavan@example.com', '9876543237'),
((SELECT user_id FROM users WHERE username = 'sundar.raman.b2'), 'Sundar', 'Raman', 'sundar.raman@example.com', '9876543238'),
((SELECT user_id FROM users WHERE username = 'preeti.shah.b2'), 'Preeti', 'Shah', 'preeti.shah@example.com', '9876543239'),
((SELECT user_id FROM users WHERE username = 'manoj.shetty.b2'), 'Manoj', 'Shetty', 'manoj.shetty@example.com', '9876543240'),
((SELECT user_id FROM users WHERE username = 'rekha.pai.b2'), 'Rekha', 'Pai', 'rekha.pai@example.com', '9876543241'),
((SELECT user_id FROM users WHERE username = 'srinivas.murthy.b2'), 'Srinivas', 'Murthy', 'srinivas.murthy@example.com', '9876543242'),
((SELECT user_id FROM users WHERE username = 'anitha.deshmukh.b2'), 'Anitha', 'Deshmukh', 'anitha.deshmukh@example.com', '9876543243'),
((SELECT user_id FROM users WHERE username = 'vijay.kulkarni.b2'), 'Vijay', 'Kulkarni', 'vijay.kulkarni@example.com', '9876543244'),
((SELECT user_id FROM users WHERE username = 'sunita.bose.b2'), 'Sunita', 'Bose', 'sunita.bose@example.com', '9876543245'),
((SELECT user_id FROM users WHERE username = 'ashwin.narayan.b2'), 'Ashwin', 'Narayan', 'ashwin.narayan@example.com', '9876543246'),
((SELECT user_id FROM users WHERE username = 'pooja.mehta.b2'), 'Pooja', 'Mehta', 'pooja.mehta@example.com', '9876543247'),
((SELECT user_id FROM users WHERE username = 'girish.joshi.b2'), 'Girish', 'Joshi', 'girish.joshi@example.com', '9876543248'),
((SELECT user_id FROM users WHERE username = 'bhavana.reddy.b2'), 'Bhavana', 'Reddy', 'bhavana.reddy@example.com', '9876543249');

-- ==================== BRANCH 3: Chennai – T Nagar ====================
-- Create all users for branch 3
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
-- Manager
('sundar.iyer.mgr.b3', @common_password, 3, 3),
-- Employees
('lakshmi.rajan.b3', @common_password, 2, 3),
('venkatesh.pillai.b3', @common_password, 2, 3),
('malini.subramanian.b3', @common_password, 2, 3),
('gopal.raman.b3', @common_password, 2, 3),
('usha.krishnan.b3', @common_password, 2, 3),
-- Customers
('rameshwar.iyengar.b3', @common_password, 1, 3),
('sarala.srinivasan.b3', @common_password, 1, 3),
('balu.naidu.b3', @common_password, 1, 3),
('chandrika.rao.b3', @common_password, 1, 3),
('murali.venkatesh.b3', @common_password, 1, 3),
('sita.raman.b3', @common_password, 1, 3),
('nagarajan.pillai.b3', @common_password, 1, 3),
('indira.menon.b3', @common_password, 1, 3),
('subramanian.gopal.b3', @common_password, 1, 3),
('vasanthi.kumar.b3', @common_password, 1, 3),
('rajendran.chettiar.b3', @common_password, 1, 3),
('padma.balan.b3', @common_password, 1, 3),
('ganapathy.sundaram.b3', @common_password, 1, 3),
('jaya.lakshmi.b3', @common_password, 1, 3),
('krishnamurthy.reddy.b3', @common_password, 1, 3),
('ambika.viswanathan.b3', @common_password, 1, 3),
('thyagarajan.nair.b3', @common_password, 1, 3),
('rekha.chandrasekhar.b3', @common_password, 1, 3),
('shankar.mohan.b3', @common_password, 1, 3),
('geetha.raghu.b3', @common_password, 1, 3);

-- Link manager
INSERT INTO employees (user_id, designation, joined_date)
SELECT user_id, 'Branch Manager', '2017-11-05'
FROM users WHERE username = 'sundar.iyer.mgr.b3';

-- Link employees
INSERT INTO employees (user_id, designation, joined_date) VALUES
((SELECT user_id FROM users WHERE username = 'lakshmi.rajan.b3'), 'Senior Teller', '2020-03-22'),
((SELECT user_id FROM users WHERE username = 'venkatesh.pillai.b3'), 'Loan Officer', '2019-08-17'),
((SELECT user_id FROM users WHERE username = 'malini.subramanian.b3'), 'Customer Service Rep', '2021-11-30'),
((SELECT user_id FROM users WHERE username = 'gopal.raman.b3'), 'Financial Advisor', '2020-12-05'),
((SELECT user_id FROM users WHERE username = 'usha.krishnan.b3'), 'Operations Specialist', '2022-06-18');

-- Link customers
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
((SELECT user_id FROM users WHERE username = 'rameshwar.iyengar.b3'), 'Rameshwar', 'Iyengar', 'rameshwar.iyengar@example.com', '9876543250'),
((SELECT user_id FROM users WHERE username = 'sarala.srinivasan.b3'), 'Sarala', 'Srinivasan', 'sarala.srinivasan@example.com', '9876543251'),
((SELECT user_id FROM users WHERE username = 'balu.naidu.b3'), 'Balu', 'Naidu', 'balu.naidu@example.com', '9876543252'),
((SELECT user_id FROM users WHERE username = 'chandrika.rao.b3'), 'Chandrika', 'Rao', 'chandrika.rao@example.com', '9876543253'),
((SELECT user_id FROM users WHERE username = 'murali.venkatesh.b3'), 'Murali', 'Venkatesh', 'murali.venkatesh@example.com', '9876543254'),
((SELECT user_id FROM users WHERE username = 'sita.raman.b3'), 'Sita', 'Raman', 'sita.raman@example.com', '9876543255'),
((SELECT user_id FROM users WHERE username = 'nagarajan.pillai.b3'), 'Nagarajan', 'Pillai', 'nagarajan.pillai@example.com', '9876543256'),
((SELECT user_id FROM users WHERE username = 'indira.menon.b3'), 'Indira', 'Menon', 'indira.menon@example.com', '9876543257'),
((SELECT user_id FROM users WHERE username = 'subramanian.gopal.b3'), 'Subramanian', 'Gopal', 'subramanian.gopal@example.com', '9876543258'),
((SELECT user_id FROM users WHERE username = 'vasanthi.kumar.b3'), 'Vasanthi', 'Kumar', 'vasanthi.kumar@example.com', '9876543259'),
((SELECT user_id FROM users WHERE username = 'rajendran.chettiar.b3'), 'Rajendran', 'Chettiar', 'rajendran.chettiar@example.com', '9876543260'),
((SELECT user_id FROM users WHERE username = 'padma.balan.b3'), 'Padma', 'Balan', 'padma.balan@example.com', '9876543261'),
((SELECT user_id FROM users WHERE username = 'ganapathy.sundaram.b3'), 'Ganapathy', 'Sundaram', 'ganapathy.sundaram@example.com', '9876543262'),
((SELECT user_id FROM users WHERE username = 'jaya.lakshmi.b3'), 'Jaya', 'Lakshmi', 'jaya.lakshmi@example.com', '9876543263'),
((SELECT user_id FROM users WHERE username = 'krishnamurthy.reddy.b3'), 'Krishnamurthy', 'Reddy', 'krishnamurthy.reddy@example.com', '9876543264'),
((SELECT user_id FROM users WHERE username = 'ambika.viswanathan.b3'), 'Ambika', 'Viswanathan', 'ambika.viswanathan@example.com', '9876543265'),
((SELECT user_id FROM users WHERE username = 'thyagarajan.nair.b3'), 'Thyagarajan', 'Nair', 'thyagarajan.nair@example.com', '9876543266'),
((SELECT user_id FROM users WHERE username = 'rekha.chandrasekhar.b3'), 'Rekha', 'Chandrasekhar', 'rekha.chandrasekhar@example.com', '9876543267'),
((SELECT user_id FROM users WHERE username = 'shankar.mohan.b3'), 'Shankar', 'Mohan', 'shankar.mohan@example.com', '9876543268'),
((SELECT user_id FROM users WHERE username = 'geetha.raghu.b3'), 'Geetha', 'Raghu', 'geetha.raghu@example.com', '9876543269');

-- ==================== BRANCH 4: Mumbai – Andheri East ====================
-- Create all users for branch 4
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
-- Manager
('rohit.shah.mgr.b4', @common_password, 3, 4),
-- Employees
('aisha.kapoor.b4', @common_password, 2, 4),
('samir.desai.b4', @common_password, 2, 4),
('tanvi.mehta.b4', @common_password, 2, 4),
('rajiv.chopra.b4', @common_password, 2, 4),
('priyanka.singhania.b4', @common_password, 2, 4),
-- Customers
('amit.verma.b4', @common_password, 1, 4),
('neeta.shroff.b4', @common_password, 1, 4),
('vikas.jain.b4', @common_password, 1, 4),
('sanjana.bhatia.b4', @common_password, 1, 4),
('rahul.agarwal.b4', @common_password, 1, 4),
('pooja.malhotra.b4', @common_password, 1, 4),
('manish.tiwari.b4', @common_password, 1, 4),
('anushka.saxena.b4', @common_password, 1, 4),
('siddharth.oberoi.b4', @common_password, 1, 4),
('ritu.bansal.b4', @common_password, 1, 4),
('harsh.parmar.b4', @common_password, 1, 4),
('shreya.khanna.b4', @common_password, 1, 4),
('akash.thakkar.b4', @common_password, 1, 4),
('divya.doshi.b4', @common_password, 1, 4),
('varun.naik.b4', @common_password, 1, 4),
('kavita.reddy.b4', @common_password, 1, 4),
('sameer.bhosale.b4', @common_password, 1, 4),
('anita.pawar.b4', @common_password, 1, 4),
('rohan.kamble.b4', @common_password, 1, 4),
('tanya.mistry.b4', @common_password, 1, 4);

-- Link manager
INSERT INTO employees (user_id, designation, joined_date)
SELECT user_id, 'Branch Manager', '2018-09-22'
FROM users WHERE username = 'rohit.shah.mgr.b4';

-- Link employees
INSERT INTO employees (user_id, designation, joined_date) VALUES
((SELECT user_id FROM users WHERE username = 'aisha.kapoor.b4'), 'Senior Teller', '2020-11-08'),
((SELECT user_id FROM users WHERE username = 'samir.desai.b4'), 'Loan Officer', '2021-04-15'),
((SELECT user_id FROM users WHERE username = 'tanvi.mehta.b4'), 'Customer Service Rep', '2022-02-28'),
((SELECT user_id FROM users WHERE username = 'rajiv.chopra.b4'), 'Financial Advisor', '2020-08-03'),
((SELECT user_id FROM users WHERE username = 'priyanka.singhania.b4'), 'Operations Specialist', '2023-01-12');

-- Link customers
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
((SELECT user_id FROM users WHERE username = 'amit.verma.b4'), 'Amit', 'Verma', 'amit.verma@example.com', '9876543270'),
((SELECT user_id FROM users WHERE username = 'neeta.shroff.b4'), 'Neeta', 'Shroff', 'neeta.shroff@example.com', '9876543271'),
((SELECT user_id FROM users WHERE username = 'vikas.jain.b4'), 'Vikas', 'Jain', 'vikas.jain@example.com', '9876543272'),
((SELECT user_id FROM users WHERE username = 'sanjana.bhatia.b4'), 'Sanjana', 'Bhatia', 'sanjana.bhatia@example.com', '9876543273'),
((SELECT user_id FROM users WHERE username = 'rahul.agarwal.b4'), 'Rahul', 'Agarwal', 'rahul.agarwal@example.com', '9876543274'),
((SELECT user_id FROM users WHERE username = 'pooja.malhotra.b4'), 'Pooja', 'Malhotra', 'pooja.malhotra@example.com', '9876543275'),
((SELECT user_id FROM users WHERE username = 'manish.tiwari.b4'), 'Manish', 'Tiwari', 'manish.tiwari@example.com', '9876543276'),
((SELECT user_id FROM users WHERE username = 'anushka.saxena.b4'), 'Anushka', 'Saxena', 'anushka.saxena@example.com', '9876543277'),
((SELECT user_id FROM users WHERE username = 'siddharth.oberoi.b4'), 'Siddharth', 'Oberoi', 'siddharth.oberoi@example.com', '9876543278'),
((SELECT user_id FROM users WHERE username = 'ritu.bansal.b4'), 'Ritu', 'Bansal', 'ritu.bansal@example.com', '9876543279'),
((SELECT user_id FROM users WHERE username = 'harsh.parmar.b4'), 'Harsh', 'Parmar', 'harsh.parmar@example.com', '9876543280'),
((SELECT user_id FROM users WHERE username = 'shreya.khanna.b4'), 'Shreya', 'Khanna', 'shreya.khanna@example.com', '9876543281'),
((SELECT user_id FROM users WHERE username = 'akash.thakkar.b4'), 'Akash', 'Thakkar', 'akash.thakkar@example.com', '9876543282'),
((SELECT user_id FROM users WHERE username = 'divya.doshi.b4'), 'Divya', 'Doshi', 'divya.doshi@example.com', '9876543283'),
((SELECT user_id FROM users WHERE username = 'varun.naik.b4'), 'Varun', 'Naik', 'varun.naik@example.com', '9876543284'),
((SELECT user_id FROM users WHERE username = 'kavita.reddy.b4'), 'Kavita', 'Reddy', 'kavita.reddy@example.com', '9876543285'),
((SELECT user_id FROM users WHERE username = 'sameer.bhosale.b4'), 'Sameer', 'Bhosale', 'sameer.bhosale@example.com', '9876543286'),
((SELECT user_id FROM users WHERE username = 'anita.pawar.b4'), 'Anita', 'Pawar', 'anita.pawar@example.com', '9876543287'),
((SELECT user_id FROM users WHERE username = 'rohan.kamble.b4'), 'Rohan', 'Kamble', 'rohan.kamble@example.com', '9876543288'),
((SELECT user_id FROM users WHERE username = 'tanya.mistry.b4'), 'Tanya', 'Mistry', 'tanya.mistry@example.com', '9876543289');

-- ==================== BRANCH 5: Delhi – Connaught Place ====================
-- Create all users for branch 5
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
-- Manager
('vivek.saxena.mgr.b5', @common_password, 3, 5),
-- Employees
('anisha.gupta.b5', @common_password, 2, 5),
('arun.malik.b5', @common_password, 2, 5),
('shikha.arora.b5', @common_password, 2, 5),
('rohit.kapoor.b5', @common_password, 2, 5),
('megha.tyagi.b5', @common_password, 2, 5),
-- Customers
('nitin.chauhan.b5', @common_password, 1, 5),
('monika.sharma.b5', @common_password, 1, 5),
('pankaj.singh.b5', @common_password, 1, 5),
('swati.goel.b5', @common_password, 1, 5),
('alok.bhardwaj.b5', @common_password, 1, 5),
('ritu.bhargava.b5', @common_password, 1, 5),
('sumit.tomar.b5', @common_password, 1, 5),
('nidhi.rastogi.b5', @common_password, 1, 5),
('ankit.mittal.b5', @common_password, 1, 5),
('preeti.dua.b5', @common_password, 1, 5),
('ravi.yadav.b5', @common_password, 1, 5),
('sonali.sarin.b5', @common_password, 1, 5),
('deepak.rawat.b5', @common_password, 1, 5),
('anamika.verma.b5', @common_password, 1, 5),
('sanjeev.kumar.b5', @common_password, 1, 5),
('kiran.bedi.b5', @common_password, 1, 5),
('vishal.agarwal.b5', @common_password, 1, 5),
('pallavi.singhal.b5', @common_password, 1, 5),
('gaurav.nagpal.b5', @common_password, 1, 5),
('shweta.sethi.b5', @common_password, 1, 5);

-- Link manager
INSERT INTO employees (user_id, designation, joined_date)
SELECT user_id, 'Branch Manager', '2019-06-14'
FROM users WHERE username = 'vivek.saxena.mgr.b5';

-- Link employees
INSERT INTO employees (user_id, designation, joined_date) VALUES
((SELECT user_id FROM users WHERE username = 'anisha.gupta.b5'), 'Senior Teller', '2021-08-25'),
((SELECT user_id FROM users WHERE username = 'arun.malik.b5'), 'Loan Officer', '2020-12-10'),
((SELECT user_id FROM users WHERE username = 'shikha.arora.b5'), 'Customer Service Rep', '2022-04-05'),
((SELECT user_id FROM users WHERE username = 'rohit.kapoor.b5'), 'Financial Advisor', '2021-02-18'),
((SELECT user_id FROM users WHERE username = 'megha.tyagi.b5'), 'Operations Specialist', '2023-03-22');

-- Link customers
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
((SELECT user_id FROM users WHERE username = 'nitin.chauhan.b5'), 'Nitin', 'Chauhan', 'nitin.chauhan@example.com', '9876543290'),
((SELECT user_id FROM users WHERE username = 'monika.sharma.b5'), 'Monika', 'Sharma', 'monika.sharma@example.com', '9876543291'),
((SELECT user_id FROM users WHERE username = 'pankaj.singh.b5'), 'Pankaj', 'Singh', 'pankaj.singh@example.com', '9876543292'),
((SELECT user_id FROM users WHERE username = 'swati.goel.b5'), 'Swati', 'Goel', 'swati.goel@example.com', '9876543293'),
((SELECT user_id FROM users WHERE username = 'alok.bhardwaj.b5'), 'Alok', 'Bhardwaj', 'alok.bhardwaj@example.com', '9876543294'),
((SELECT user_id FROM users WHERE username = 'ritu.bhargava.b5'), 'Ritu', 'Bhargava', 'ritu.bhargava@example.com', '9876543295'),
((SELECT user_id FROM users WHERE username = 'sumit.tomar.b5'), 'Sumit', 'Tomar', 'sumit.tomar@example.com', '9876543296'),
((SELECT user_id FROM users WHERE username = 'nidhi.rastogi.b5'), 'Nidhi', 'Rastogi', 'nidhi.rastogi@example.com', '9876543297'),
((SELECT user_id FROM users WHERE username = 'ankit.mittal.b5'), 'Ankit', 'Mittal', 'ankit.mittal@example.com', '9876543298'),
((SELECT user_id FROM users WHERE username = 'preeti.dua.b5'), 'Preeti', 'Dua', 'preeti.dua@example.com', '9876543299'),
((SELECT user_id FROM users WHERE username = 'ravi.yadav.b5'), 'Ravi', 'Yadav', 'ravi.yadav@example.com', '9876543300'),
((SELECT user_id FROM users WHERE username = 'sonali.sarin.b5'), 'Sonali', 'Sarin', 'sonali.sarin@example.com', '9876543301'),
((SELECT user_id FROM users WHERE username = 'deepak.rawat.b5'), 'Deepak', 'Rawat', 'deepak.rawat@example.com', '9876543302'),
((SELECT user_id FROM users WHERE username = 'anamika.verma.b5'), 'Anamika', 'Verma', 'anamika.verma@example.com', '9876543303'),
((SELECT user_id FROM users WHERE username = 'sanjeev.kumar.b5'), 'Sanjeev', 'Kumar', 'sanjeev.kumar@example.com', '9876543304'),
((SELECT user_id FROM users WHERE username = 'kiran.bedi.b5'), 'Kiran', 'Bedi', 'kiran.bedi@example.com', '9876543305'),
((SELECT user_id FROM users WHERE username = 'vishal.agarwal.b5'), 'Vishal', 'Agarwal', 'vishal.agarwal@example.com', '9876543306'),
((SELECT user_id FROM users WHERE username = 'pallavi.singhal.b5'), 'Pallavi', 'Singhal', 'pallavi.singhal@example.com', '9876543307'),
((SELECT user_id FROM users WHERE username = 'gaurav.nagpal.b5'), 'Gaurav', 'Nagpal', 'gaurav.nagpal@example.com', '9876543308'),
((SELECT user_id FROM users WHERE username = 'shweta.sethi.b5'), 'Shweta', 'Sethi', 'shweta.sethi@example.com', '9876543309');

-- ==================== BRANCH 6: Pune – Hinjewadi ====================
-- Create all users for branch 6
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
-- Manager
('sanjay.patil.mgr.b6', @common_password, 3, 6),
-- Employees
('snehal.joshi.b6', @common_password, 2, 6),
('amol.kulkarni.b6', @common_password, 2, 6),
('rashmi.deshpande.b6', @common_password, 2, 6),
('prasad.more.b6', @common_password, 2, 6),
('supriya.gaikwad.b6', @common_password, 2, 6),
-- Customers
('abhijit.bhide.b6', @common_password, 1, 6),
('varsha.thalte.b6', @common_password, 1, 6),
('prasad.chavan.b6', @common_password, 1, 6),
('ashwini.sawant.b6', @common_password, 1, 6),
('rajendra.salunkhe.b6', @common_password, 1, 6),
('smita.kadam.b6', @common_password, 1, 6),
('vikram.mhatre.b6', @common_password, 1, 6),
('anagha.paranjape.b6', @common_password, 1, 6),
('sachin.bhosale.b6', @common_password, 1, 6),
('pooja.rane.b6', @common_password, 1, 6),
('nitin.wagh.b6', @common_password, 1, 6),
('meera.kale.b6', @common_password, 1, 6),
('dinesh.jadhav.b6', @common_password, 1, 6),
('shubhangi.moghe.b6', @common_password, 1, 6),
('pradeep.nalawade.b6', @common_password, 1, 6),
('ananya.pendse.b6', @common_password, 1, 6),
('rakesh.thorat.b6', @common_password, 1, 6),
('tejashree.barve.b6', @common_password, 1, 6),
('sandeep.ghatge.b6', @common_password, 1, 6),
('deepali.kirtane.b6', @common_password, 1, 6);

-- Link manager
INSERT INTO employees (user_id, designation, joined_date)
SELECT user_id, 'Branch Manager', '2020-01-20'
FROM users WHERE username = 'sanjay.patil.mgr.b6';

-- Link employees
INSERT INTO employees (user_id, designation, joined_date) VALUES
((SELECT user_id FROM users WHERE username = 'snehal.joshi.b6'), 'Senior Teller', '2022-03-11'),
((SELECT user_id FROM users WHERE username = 'amol.kulkarni.b6'), 'Loan Officer', '2021-07-29'),
((SELECT user_id FROM users WHERE username = 'rashmi.deshpande.b6'), 'Customer Service Rep', '2023-01-15'),
((SELECT user_id FROM users WHERE username = 'prasad.more.b6'), 'Financial Advisor', '2021-11-03'),
((SELECT user_id FROM users WHERE username = 'supriya.gaikwad.b6'), 'Operations Specialist', '2023-05-08');

-- Link customers
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
((SELECT user_id FROM users WHERE username = 'abhijit.bhide.b6'), 'Abhijit', 'Bhide', 'abhijit.bhide@example.com', '9876543310'),
((SELECT user_id FROM users WHERE username = 'varsha.thalte.b6'), 'Varsha', 'Thalte', 'varsha.thalte@example.com', '9876543311'),
((SELECT user_id FROM users WHERE username = 'prasad.chavan.b6'), 'Prasad', 'Chavan', 'prasad.chavan@example.com', '9876543312'),
((SELECT user_id FROM users WHERE username = 'ashwini.sawant.b6'), 'Ashwini', 'Sawant', 'ashwini.sawant@example.com', '9876543313'),
((SELECT user_id FROM users WHERE username = 'rajendra.salunkhe.b6'), 'Rajendra', 'Salunkhe', 'rajendra.salunkhe@example.com', '9876543314'),
((SELECT user_id FROM users WHERE username = 'smita.kadam.b6'), 'Smita', 'Kadam', 'smita.kadam@example.com', '9876543315'),
((SELECT user_id FROM users WHERE username = 'vikram.mhatre.b6'), 'Vikram', 'Mhatre', 'vikram.mhatre@example.com', '9876543316'),
((SELECT user_id FROM users WHERE username = 'anagha.paranjape.b6'), 'Anagha', 'Paranjape', 'anagha.paranjape@example.com', '9876543317'),
((SELECT user_id FROM users WHERE username = 'sachin.bhosale.b6'), 'Sachin', 'Bhosale', 'sachin.bhosale@example.com', '9876543318'),
((SELECT user_id FROM users WHERE username = 'pooja.rane.b6'), 'Pooja', 'Rane', 'pooja.rane@example.com', '9876543319'),
((SELECT user_id FROM users WHERE username = 'nitin.wagh.b6'), 'Nitin', 'Wagh', 'nitin.wagh@example.com', '9876543320'),
((SELECT user_id FROM users WHERE username = 'meera.kale.b6'), 'Meera', 'Kale', 'meera.kale@example.com', '9876543321'),
((SELECT user_id FROM users WHERE username = 'dinesh.jadhav.b6'), 'Dinesh', 'Jadhav', 'dinesh.jadhav@example.com', '9876543322'),
((SELECT user_id FROM users WHERE username = 'shubhangi.moghe.b6'), 'Shubhangi', 'Moghe', 'shubhangi.moghe@example.com', '9876543323'),
((SELECT user_id FROM users WHERE username = 'pradeep.nalawade.b6'), 'Pradeep', 'Nalawade', 'pradeep.nalawade@example.com', '9876543324'),
((SELECT user_id FROM users WHERE username = 'ananya.pendse.b6'), 'Ananya', 'Pendse', 'ananya.pendse@example.com', '9876543325'),
((SELECT user_id FROM users WHERE username = 'rakesh.thorat.b6'), 'Rakesh', 'Thorat', 'rakesh.thorat@example.com', '9876543326'),
((SELECT user_id FROM users WHERE username = 'tejashree.barve.b6'), 'Tejashree', 'Barve', 'tejashree.barve@example.com', '9876543327'),
((SELECT user_id FROM users WHERE username = 'sandeep.ghatge.b6'), 'Sandeep', 'Ghatge', 'sandeep.ghatge@example.com', '9876543328'),
((SELECT user_id FROM users WHERE username = 'deepali.kirtane.b6'), 'Deepali', 'Kirtane', 'deepali.kirtane@example.com', '9876543329');

-- ==================== BRANCH 7: Kolkata – Salt Lake ====================
-- Create all users for branch 7
INSERT INTO users (username, password_hash, role_id, branch_id) VALUES
-- Manager
('soumitra.bose.mgr.b7', @common_password, 3, 7),
-- Employees
('indrani.ganguly.b7', @common_password, 2, 7),
('debashis.mukherjee.b7', @common_password, 2, 7),
('moumita.ghosh.b7', @common_password, 2, 7),
('subhro.dasgupta.b7', @common_password, 2, 7),
('rinku.saha.b7', @common_password, 2, 7),
-- Customers
('arnab.chatterjee.b7', @common_password, 1, 7),
('mousumi.banerjee.b7', @common_password, 1, 7),
('pranab.roy.b7', @common_password, 1, 7),
('sharmistha.mitra.b7', @common_password, 1, 7),
('santanu.sen.b7', @common_password, 1, 7),
('bhaswati.dutta.b7', @common_password, 1, 7),
('subir.sarkar.b7', @common_password, 1, 7),
('tumpa.majumdar.b7', @common_password, 1, 7),
('amitava.chakraborty.b7', @common_password, 1, 7),
('mou.das.b7', @common_password, 1, 7),
('sudipto.bhattacharya.b7', @common_password, 1, 7),
('poulomi.bose.b7', @common_password, 1, 7),
('ranjan.kundu.b7', @common_password, 1, 7),
('shraboni.halder.b7', @common_password, 1, 7),
('abhirup.pal.b7', @common_password, 1, 7),
('jayashree.mallick.b7', @common_password, 1, 7),
('somnath.mondal.b7', @common_password, 1, 7),
('paromita.bhowmick.b7', @common_password, 1, 7),
('bikash.debnath.b7', @common_password, 1, 7),
('sreeparna.guha.b7', @common_password, 1, 7);

-- Link manager
INSERT INTO employees (user_id, designation, joined_date)
SELECT user_id, 'Branch Manager', '2018-12-08'
FROM users WHERE username = 'soumitra.bose.mgr.b7';

-- Link employees
INSERT INTO employees (user_id, designation, joined_date) VALUES
((SELECT user_id FROM users WHERE username = 'indrani.ganguly.b7'), 'Senior Teller', '2021-04-25'),
((SELECT user_id FROM users WHERE username = 'debashis.mukherjee.b7'), 'Loan Officer', '2020-09-12'),
((SELECT user_id FROM users WHERE username = 'moumita.ghosh.b7'), 'Customer Service Rep', '2022-07-18'),
((SELECT user_id FROM users WHERE username = 'subhro.dasgupta.b7'), 'Financial Advisor', '2021-01-30'),
((SELECT user_id FROM users WHERE username = 'rinku.saha.b7'), 'Operations Specialist', '2023-02-14');

-- Link customers
INSERT INTO customers (user_id, first_name, last_name, email, phone) VALUES
((SELECT user_id FROM users WHERE username = 'arnab.chatterjee.b7'), 'Arnab', 'Chatterjee', 'arnab.chatterjee@example.com', '9876543330'),
((SELECT user_id FROM users WHERE username = 'mousumi.banerjee.b7'), 'Mousumi', 'Banerjee', 'mousumi.banerjee@example.com', '9876543331'),
((SELECT user_id FROM users WHERE username = 'pranab.roy.b7'), 'Pranab', 'Roy', 'pranab.roy@example.com', '9876543332'),
((SELECT user_id FROM users WHERE username = 'sharmistha.mitra.b7'), 'Sharmistha', 'Mitra', 'sharmistha.mitra@example.com', '9876543333'),
((SELECT user_id FROM users WHERE username = 'santanu.sen.b7'), 'Santanu', 'Sen', 'santanu.sen@example.com', '9876543334'),
((SELECT user_id FROM users WHERE username = 'bhaswati.dutta.b7'), 'Bhaswati', 'Dutta', 'bhaswati.dutta@example.com', '9876543335'),
((SELECT user_id FROM users WHERE username = 'subir.sarkar.b7'), 'Subir', 'Sarkar', 'subir.sarkar@example.com', '9876543336'),
((SELECT user_id FROM users WHERE username = 'tumpa.majumdar.b7'), 'Tumpa', 'Majumdar', 'tumpa.majumdar@example.com', '9876543337'),
((SELECT user_id FROM users WHERE username = 'amitava.chakraborty.b7'), 'Amitava', 'Chakraborty', 'amitava.chakraborty@example.com', '9876543338'),
((SELECT user_id FROM users WHERE username = 'mou.das.b7'), 'Mou', 'Das', 'mou.das@example.com', '9876543339'),
((SELECT user_id FROM users WHERE username = 'sudipto.bhattacharya.b7'), 'Sudipto', 'Bhattacharya', 'sudipto.bhattacharya@example.com', '9876543340'),
((SELECT user_id FROM users WHERE username = 'poulomi.bose.b7'), 'Poulomi', 'Bose', 'poulomi.bose@example.com', '9876543341'),
((SELECT user_id FROM users WHERE username = 'ranjan.kundu.b7'), 'Ranjan', 'Kundu', 'ranjan.kundu@example.com', '9876543342'),
((SELECT user_id FROM users WHERE username = 'shraboni.halder.b7'), 'Shraboni', 'Halder', 'shraboni.halder@example.com', '9876543343'),
((SELECT user_id FROM users WHERE username = 'abhirup.pal.b7'), 'Abhirup', 'Pal', 'abhirup.pal@example.com', '9876543344'),
((SELECT user_id FROM users WHERE username = 'jayashree.mallick.b7'), 'Jayashree', 'Mallick', 'jayashree.mallick@example.com', '9876543345'),
((SELECT user_id FROM users WHERE username = 'somnath.mondal.b7'), 'Somnath', 'Mondal', 'somnath.mondal@example.com', '9876543346'),
((SELECT user_id FROM users WHERE username = 'paromita.bhowmick.b7'), 'Paromita', 'Bhowmick', 'paromita.bhowmick@example.com', '9876543347'),
((SELECT user_id FROM users WHERE username = 'bikash.debnath.b7'), 'Bikash', 'Debnath', 'bikash.debnath@example.com', '9876543348'),
((SELECT user_id FROM users WHERE username = 'sreeparna.guha.b7'), 'Sreeparna', 'Guha', 'sreeparna.guha@example.com', '9876543349');



-- After creating all customers, now create accounts for them
-- We'll create 2 accounts for each customer (one SAVINGS, one CURRENT)

-- ==================== CREATE ACCOUNTS FOR ALL CUSTOMERS ====================

-- Function to generate random account numbers
SET @account_counter = 1000000001;

-- Branch 1: Hyderabad customers
INSERT INTO accounts (customer_id, account_number, account_type, balance, status) VALUES
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'suresh.goud.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 25000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'suresh.goud.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 50000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'lakshmi.reddy.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 35000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'lakshmi.reddy.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 75000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'kiran.kumar.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 42000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'kiran.kumar.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 65000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'swathi.naidu.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 28000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'swathi.naidu.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 82000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'venkat.rao.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 31000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'venkat.rao.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 55000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'geeta.sharma.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 19000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'geeta.sharma.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 45000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rajesh.yadav.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 52000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rajesh.yadav.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 92000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'padmini.nair.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 23000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'padmini.nair.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 48000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'mohan.das.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 37000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'mohan.das.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 68000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anuradha.singh.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 41000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anuradha.singh.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 79000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sai.ram.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 26000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sai.ram.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 51000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'chitra.iyer.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 33000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'chitra.iyer.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 72000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'praveen.menon.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 29000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'praveen.menon.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 63000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'radhika.gupta.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 24000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'radhika.gupta.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 57000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'harish.chandra.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 38000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'harish.chandra.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 81000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vasantha.kumari.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 22000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vasantha.kumari.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 49000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nitin.agarwal.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 43000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nitin.agarwal.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 88000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'malini.sen.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 27000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'malini.sen.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 54000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'deepak.jain.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 36000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'deepak.jain.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 76000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shobha.verma.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 32000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shobha.verma.b1'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 71000.00, 'ACTIVE');

-- Branch 2: Bangalore customers
INSERT INTO accounts (customer_id, account_number, account_type, balance, status) VALUES
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'aravind.krishnan.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 25500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'aravind.krishnan.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 50500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'meenakshi.sundaram.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 35500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'meenakshi.sundaram.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 75500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ganesh.kumar.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 42500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ganesh.kumar.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 65500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shalini.ramesh.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 28500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shalini.ramesh.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 82500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'prakash.chandran.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 31500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'prakash.chandran.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 55500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vidya.venkat.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 19500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vidya.venkat.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 45500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ramesh.babu.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 52500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ramesh.babu.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 92500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'lavanya.raghavan.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 23500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'lavanya.raghavan.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 48500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sundar.raman.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 37500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sundar.raman.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 68500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'preeti.shah.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 41500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'preeti.shah.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 79500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'manoj.shetty.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 26500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'manoj.shetty.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 51500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rekha.pai.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 33500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rekha.pai.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 72500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'srinivas.murthy.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 29500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'srinivas.murthy.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 63500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anitha.deshmukh.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 24500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anitha.deshmukh.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 57500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vijay.kulkarni.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 38500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vijay.kulkarni.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 81500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sunita.bose.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 22500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sunita.bose.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 49500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ashwin.narayan.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 43500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ashwin.narayan.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 88500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pooja.mehta.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 27500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pooja.mehta.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 54500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'girish.joshi.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 36500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'girish.joshi.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 76500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'bhavana.reddy.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 32500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'bhavana.reddy.b2'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 71500.00, 'ACTIVE');

-- Continue this pattern for remaining 5 branches (3-7)
-- For brevity, I'll show the pattern for Branch 3, and you can continue similarly for branches 4-7

-- Branch 3: Chennai customers
INSERT INTO accounts (customer_id, account_number, account_type, balance, status) VALUES
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rameshwar.iyengar.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 26000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rameshwar.iyengar.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 51000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sarala.srinivasan.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 36000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sarala.srinivasan.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 76000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'balu.naidu.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 43000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'balu.naidu.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 66000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'chandrika.rao.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 29000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'chandrika.rao.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 83000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'murali.venkatesh.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 32000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'murali.venkatesh.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 56000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sita.raman.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 20000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sita.raman.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 46000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nagarajan.pillai.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 53000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nagarajan.pillai.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 93000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'indira.menon.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 24000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'indira.menon.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 49000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'subramanian.gopal.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 38000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'subramanian.gopal.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 69000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vasanthi.kumar.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 42000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vasanthi.kumar.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 80000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rajendran.chettiar.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 27000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rajendran.chettiar.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 52000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'padma.balan.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 34000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'padma.balan.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 73000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ganapathy.sundaram.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 30000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ganapathy.sundaram.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 64000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'jaya.lakshmi.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 25000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'jaya.lakshmi.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 58000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'krishnamurthy.reddy.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 39000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'krishnamurthy.reddy.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 82000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ambika.viswanathan.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 23000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ambika.viswanathan.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 50000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'thyagarajan.nair.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 44000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'thyagarajan.nair.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 89000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rekha.chandrasekhar.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 28000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rekha.chandrasekhar.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 55000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shankar.mohan.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 37000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shankar.mohan.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 77000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'geetha.raghu.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 33000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'geetha.raghu.b3'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 72000.00, 'ACTIVE');

-- Note: Continue this same pattern for Branches 4-7 following the same structure
-- For each branch's 20 customers, create 2 accounts each (1 SAVINGS, 1 CURRENT)
-- Adjust the balance amounts slightly to make them realistic

-- ==================== ADD SOME TRANSACTIONS ====================
-- Let's add some sample transactions for a few accounts

-- INSERT INTO transactions (account_id, transaction_type, amount, description) VALUES
-- (1, 'CREDIT', 5000.00, 'Salary Credit'),
-- (1, 'DEBIT', 2000.00, 'ATM Withdrawal'),
-- (1, 'DEBIT', 1500.00, 'Online Shopping'),
-- (2, 'CREDIT', 10000.00, 'Business Payment'),
-- (2, 'DEBIT', 5000.00, 'Vendor Payment'),
-- (3, 'CREDIT', 7000.00, 'Interest Credit'),
-- (3, 'DEBIT', 3000.00, 'Electricity Bill'),
-- (4, 'CREDIT', 15000.00, 'Client Payment'),
-- (5, 'CREDIT', 8000.00, 'Freelance Payment'),
-- (5, 'DEBIT', 2500.00, 'Mobile Recharge'),
-- (6, 'CREDIT', 12000.00, 'Project Payment'),
-- (7, 'DEBIT', 1800.00, 'DTH Recharge'),
-- (8, 'CREDIT', 9000.00, 'Consulting Fee'),
-- (9, 'DEBIT', 3200.00, 'Insurance Premium'),
-- (10, 'CREDIT', 11000.00, 'Bonus Amount');

-- Continue from Branch 4: Mumbai customers
INSERT INTO accounts (customer_id, account_number, account_type, balance, status) VALUES
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'amit.verma.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 26500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'amit.verma.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 51500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'neeta.shroff.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 36500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'neeta.shroff.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 76500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vikas.jain.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 43500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vikas.jain.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 66500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sanjana.bhatia.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 29500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sanjana.bhatia.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 83500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rahul.agarwal.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 32500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rahul.agarwal.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 56500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pooja.malhotra.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 20500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pooja.malhotra.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 46500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'manish.tiwari.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 53500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'manish.tiwari.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 93500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anushka.saxena.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 24500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anushka.saxena.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 49500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'siddharth.oberoi.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 38500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'siddharth.oberoi.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 69500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ritu.bansal.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 42500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ritu.bansal.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 80500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'harsh.parmar.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 27500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'harsh.parmar.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 52500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shreya.khanna.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 34500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shreya.khanna.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 73500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'akash.thakkar.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 30500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'akash.thakkar.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 64500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'divya.doshi.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 25500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'divya.doshi.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 58500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'varun.naik.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 39500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'varun.naik.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 82500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'kavita.reddy.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 23500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'kavita.reddy.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 50500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sameer.bhosale.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 44500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sameer.bhosale.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 89500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anita.pawar.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 28500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anita.pawar.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 55500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rohan.kamble.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 37500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rohan.kamble.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 77500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'tanya.mistry.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 33500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'tanya.mistry.b4'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 72500.00, 'ACTIVE');

-- Branch 5: Delhi customers
INSERT INTO accounts (customer_id, account_number, account_type, balance, status) VALUES
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nitin.chauhan.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 27000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nitin.chauhan.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 52000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'monika.sharma.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 37000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'monika.sharma.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 77000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pankaj.singh.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 44000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pankaj.singh.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 67000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'swati.goel.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 30000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'swati.goel.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 84000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'alok.bhardwaj.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 33000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'alok.bhardwaj.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 57000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ritu.bhargava.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 21000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ritu.bhargava.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 47000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sumit.tomar.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 54000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sumit.tomar.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 94000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nidhi.rastogi.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 25000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nidhi.rastogi.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 50000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ankit.mittal.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 39000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ankit.mittal.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 70000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'preeti.dua.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 43000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'preeti.dua.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 81000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ravi.yadav.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 28000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ravi.yadav.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 53000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sonali.sarin.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 35000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sonali.sarin.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 74000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'deepak.rawat.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 31000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'deepak.rawat.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 65000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anamika.verma.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 26000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anamika.verma.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 59000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sanjeev.kumar.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 40000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sanjeev.kumar.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 83000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'kiran.bedi.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 24000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'kiran.bedi.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 51000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vishal.agarwal.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 45000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vishal.agarwal.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 90000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pallavi.singhal.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 29000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pallavi.singhal.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 56000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'gaurav.nagpal.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 38000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'gaurav.nagpal.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 78000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shweta.sethi.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 34000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shweta.sethi.b5'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 73000.00, 'ACTIVE');

-- Branch 6: Pune customers
INSERT INTO accounts (customer_id, account_number, account_type, balance, status) VALUES
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'abhijit.bhide.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 27500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'abhijit.bhide.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 52500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'varsha.thalte.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 37500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'varsha.thalte.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 77500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'prasad.chavan.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 44500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'prasad.chavan.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 67500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ashwini.sawant.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 30500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ashwini.sawant.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 84500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rajendra.salunkhe.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 33500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rajendra.salunkhe.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 57500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'smita.kadam.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 21500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'smita.kadam.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 47500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vikram.mhatre.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 54500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'vikram.mhatre.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 94500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anagha.paranjape.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 25500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'anagha.paranjape.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 50500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sachin.bhosale.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 39500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sachin.bhosale.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 70500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pooja.rane.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 43500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pooja.rane.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 81500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nitin.wagh.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 28500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'nitin.wagh.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 53500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'meera.kale.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 35500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'meera.kale.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 74500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'dinesh.jadhav.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 31500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'dinesh.jadhav.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 65500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shubhangi.moghe.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 26500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shubhangi.moghe.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 59500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pradeep.nalawade.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 40500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pradeep.nalawade.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 83500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ananya.pendse.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 24500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ananya.pendse.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 51500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rakesh.thorat.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 45500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'rakesh.thorat.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 90500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'tejashree.barve.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 29500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'tejashree.barve.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 56500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sandeep.ghatge.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 38500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sandeep.ghatge.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 78500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'deepali.kirtane.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 34500.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'deepali.kirtane.b6'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 73500.00, 'ACTIVE');

-- Branch 7: Kolkata customers
INSERT INTO accounts (customer_id, account_number, account_type, balance, status) VALUES
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'arnab.chatterjee.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 28000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'arnab.chatterjee.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 53000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'mousumi.banerjee.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 38000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'mousumi.banerjee.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 78000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pranab.roy.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 45000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'pranab.roy.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 68000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sharmistha.mitra.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 31000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sharmistha.mitra.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 85000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'santanu.sen.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 34000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'santanu.sen.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 58000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'bhaswati.dutta.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 22000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'bhaswati.dutta.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 48000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'subir.sarkar.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 55000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'subir.sarkar.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 95000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'tumpa.majumdar.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 26000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'tumpa.majumdar.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 51000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'amitava.chakraborty.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 40000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'amitava.chakraborty.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 71000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'mou.das.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 44000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'mou.das.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 82000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sudipto.bhattacharya.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 29000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sudipto.bhattacharya.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 54000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'poulomi.bose.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 36000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'poulomi.bose.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 75000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ranjan.kundu.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 32000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'ranjan.kundu.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 66000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shraboni.halder.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 27000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'shraboni.halder.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 60000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'abhirup.pal.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 41000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'abhirup.pal.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 84000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'jayashree.mallick.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 25000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'jayashree.mallick.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 52000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'somnath.mondal.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 46000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'somnath.mondal.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 91000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'paromita.bhowmick.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 30000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'paromita.bhowmick.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 57000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'bikash.debnath.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 39000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'bikash.debnath.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 79000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sreeparna.guha.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'SAVINGS', 35000.00, 'ACTIVE'),
((SELECT customer_id FROM customers c JOIN users u ON c.user_id = u.user_id WHERE u.username = 'sreeparna.guha.b7'), CONCAT('ACC', @account_counter:=@account_counter+1), 'CURRENT', 74000.00, 'ACTIVE');

-- Create sample transactions for various accounts
-- Using a mix of credit and debit transactions

-- ==================== SAMPLE TRANSACTIONS ====================

-- Transactions for Branch 1 accounts
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- Account 1 (Suresh Goud - Savings)
(1, 'CREDIT', 50000.00, 'Salary Deposit', '2024-01-15 09:30:00'),
(1, 'DEBIT', 15000.00, 'Home Loan EMI', '2024-01-18 14:20:00'),
(1, 'DEBIT', 5000.00, 'Online Shopping - Amazon', '2024-01-20 19:45:00'),
(1, 'CREDIT', 2500.00, 'Interest Credit', '2024-01-31 23:59:59'),
-- Account 2 (Suresh Goud - Current)
(2, 'CREDIT', 200000.00, 'Business Receipts', '2024-01-05 11:15:00'),
(2, 'DEBIT', 75000.00, 'Supplier Payment', '2024-01-10 10:30:00'),
(2, 'DEBIT', 25000.00, 'Office Rent', '2024-01-25 12:00:00'),
(2, 'CREDIT', 50000.00, 'Client Advance', '2024-01-28 15:45:00'),
-- Account 3 (Lakshmi Reddy - Savings)
(3, 'CREDIT', 45000.00, 'Salary Credit', '2024-01-25 09:00:00'),
(3, 'DEBIT', 10000.00, 'Mutual Fund SIP', '2024-01-26 10:00:00'),
(3, 'DEBIT', 8000.00, 'Credit Card Payment', '2024-01-27 11:30:00'),
-- Account 5 (Kiran Kumar - Savings)
(5, 'CREDIT', 42000.00, 'Monthly Salary', '2024-01-28 08:45:00'),
(5, 'DEBIT', 12000.00, 'School Fees', '2024-01-29 09:30:00'),
(5, 'DEBIT', 5000.00, 'Electricity Bill', '2024-01-30 14:20:00'),
-- Account 7 (Swathi Naidu - Savings)
(7, 'CREDIT', 28000.00, 'Freelance Payment', '2024-01-20 16:30:00'),
(7, 'DEBIT', 7000.00, 'Insurance Premium', '2024-01-22 11:15:00'),
-- Account 9 (Venkat Rao - Savings)
(9, 'CREDIT', 31000.00, 'Consulting Fee', '2024-01-18 13:45:00'),
(9, 'DEBIT', 11000.00, 'Car Loan EMI', '2024-01-19 09:30:00'),
-- Account 11 (Geeta Sharma - Savings)
(11, 'CREDIT', 19000.00, 'Pension Credit', '2024-01-05 10:00:00'),
(11, 'DEBIT', 4000.00, 'Medical Expense', '2024-01-10 14:30:00'),
-- Account 13 (Rajesh Yadav - Savings)
(13, 'CREDIT', 52000.00, 'Salary Deposit', '2024-01-27 09:15:00'),
(13, 'DEBIT', 15000.00, 'Home Renovation', '2024-01-29 16:45:00'),
-- Account 15 (Padmini Nair - Savings)
(15, 'CREDIT', 23000.00, 'Business Income', '2024-01-15 12:30:00'),
(15, 'DEBIT', 8000.00, 'Property Tax', '2024-01-18 10:15:00'),
-- Account 17 (Mohan Das - Savings)
(17, 'CREDIT', 37000.00, 'Contract Payment', '2024-01-22 15:20:00'),
(17, 'DEBIT', 12000.00, 'Personal Loan EMI', '2024-01-25 11:30:00');

-- Transactions for Branch 2 accounts
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- Account 41 (Aravind Krishnan - Savings)
(41, 'CREDIT', 55000.00, 'Salary Deposit', '2024-01-26 09:00:00'),
(41, 'DEBIT', 20000.00, 'Home Loan EMI', '2024-01-28 10:30:00'),
(41, 'DEBIT', 8000.00, 'Online Courses', '2024-01-30 19:15:00'),
-- Account 43 (Meenakshi Sundaram - Savings)
(43, 'CREDIT', 48000.00, 'Monthly Salary', '2024-01-25 08:45:00'),
(43, 'DEBIT', 15000.00, 'Mutual Fund Investment', '2024-01-27 10:00:00'),
-- Account 45 (Ganesh Kumar - Savings)
(45, 'CREDIT', 42500.00, 'Project Payment', '2024-01-20 14:30:00'),
(45, 'DEBIT', 12500.00, 'Car Maintenance', '2024-01-22 16:45:00'),
-- Account 47 (Shalini Ramesh - Savings)
(47, 'CREDIT', 38500.00, 'Freelance Work', '2024-01-18 13:20:00'),
(47, 'DEBIT', 8500.00, 'Shopping', '2024-01-20 18:30:00'),
-- Account 49 (Prakash Chandran - Savings)
(49, 'CREDIT', 31500.00, 'Consulting Fee', '2024-01-15 11:45:00'),
(49, 'DEBIT', 11500.00, 'Travel Expense', '2024-01-17 09:30:00');

-- Transactions for Branch 3 accounts
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- Account 81 (Rameshwar Iyengar - Savings)
(81, 'CREDIT', 56000.00, 'Salary Credit', '2024-01-27 09:15:00'),
(81, 'DEBIT', 21000.00, 'Home Loan EMI', '2024-01-29 10:45:00'),
-- Account 83 (Sarala Srinivasan - Savings)
(83, 'CREDIT', 46000.00, 'Monthly Income', '2024-01-24 08:30:00'),
(83, 'DEBIT', 16000.00, 'Insurance Payment', '2024-01-26 11:20:00'),
-- Account 85 (Balu Naidu - Savings)
(85, 'CREDIT', 43000.00, 'Contract Payment', '2024-01-21 14:15:00'),
(85, 'DEBIT', 13000.00, 'Education Fee', '2024-01-23 15:30:00'),
-- Account 87 (Chandrika Rao - Savings)
(87, 'CREDIT', 49000.00, 'Business Receipt', '2024-01-19 12:45:00'),
(87, 'DEBIT', 9000.00, 'Utility Bills', '2024-01-21 17:20:00'),
-- Account 89 (Murali Venkatesh - Savings)
(89, 'CREDIT', 52000.00, 'Salary Deposit', '2024-01-16 10:30:00'),
(89, 'DEBIT', 12000.00, 'Car EMI', '2024-01-18 09:45:00');

-- Transactions for Branch 4 accounts
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- Account 121 (Amit Verma - Savings)
(121, 'CREDIT', 56500.00, 'Salary Credit', '2024-01-28 09:00:00'),
(121, 'DEBIT', 21500.00, 'Home Loan', '2024-01-30 10:30:00'),
-- Account 123 (Neeta Shroff - Savings)
(123, 'CREDIT', 46500.00, 'Monthly Salary', '2024-01-25 08:45:00'),
(123, 'DEBIT', 16500.00, 'Investment', '2024-01-27 11:15:00'),
-- Account 125 (Vikas Jain - Savings)
(125, 'CREDIT', 43500.00, 'Project Fee', '2024-01-22 14:30:00'),
(125, 'DEBIT', 13500.00, 'Medical Bill', '2024-01-24 16:45:00'),
-- Account 127 (Sanjana Bhatia - Savings)
(127, 'CREDIT', 49500.00, 'Business Income', '2024-01-20 12:15:00'),
(127, 'DEBIT', 9500.00, 'Shopping', '2024-01-22 18:30:00'),
-- Account 129 (Rahul Agarwal - Savings)
(129, 'CREDIT', 52500.00, 'Salary', '2024-01-17 10:45:00'),
(129, 'DEBIT', 12500.00, 'Loan EMI', '2024-01-19 09:30:00');

-- Transactions for Branch 5 accounts
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- Account 161 (Nitin Chauhan - Savings)
(161, 'CREDIT', 57000.00, 'Salary Deposit', '2024-01-29 09:15:00'),
(161, 'DEBIT', 22000.00, 'Home EMI', '2024-01-31 10:45:00'),
-- Account 163 (Monika Sharma - Savings)
(163, 'CREDIT', 47000.00, 'Monthly Income', '2024-01-26 08:30:00'),
(163, 'DEBIT', 17000.00, 'Insurance Premium', '2024-01-28 11:20:00'),
-- Account 165 (Pankaj Singh - Savings)
(165, 'CREDIT', 44000.00, 'Contract Payment', '2024-01-23 14:15:00'),
(165, 'DEBIT', 14000.00, 'Education Fee', '2024-01-25 15:30:00'),
-- Account 167 (Swati Goel - Savings)
(167, 'CREDIT', 50000.00, 'Business Receipt', '2024-01-21 12:45:00'),
(167, 'DEBIT', 10000.00, 'Utility Payment', '2024-01-23 17:20:00'),
-- Account 169 (Alok Bhardwaj - Savings)
(169, 'CREDIT', 53000.00, 'Salary Credit', '2024-01-18 10:30:00'),
(169, 'DEBIT', 13000.00, 'Car Loan EMI', '2024-01-20 09:45:00');

-- Transactions for Branch 6 accounts
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- Account 201 (Abhijit Bhide - Savings)
(201, 'CREDIT', 57500.00, 'Salary', '2024-01-30 09:00:00'),
(201, 'DEBIT', 22500.00, 'Home Loan', '2024-02-01 10:30:00'),
-- Account 203 (Varsha Thalte - Savings)
(203, 'CREDIT', 47500.00, 'Monthly Salary', '2024-01-27 08:45:00'),
(203, 'DEBIT', 17500.00, 'Investment', '2024-01-29 11:15:00'),
-- Account 205 (Prasad Chavan - Savings)
(205, 'CREDIT', 44500.00, 'Project Payment', '2024-01-24 14:30:00'),
(205, 'DEBIT', 14500.00, 'Medical Expense', '2024-01-26 16:45:00'),
-- Account 207 (Ashwini Sawant - Savings)
(207, 'CREDIT', 50500.00, 'Business Income', '2024-01-22 12:15:00'),
(207, 'DEBIT', 10500.00, 'Shopping', '2024-01-24 18:30:00'),
-- Account 209 (Rajendra Salunkhe - Savings)
(209, 'CREDIT', 53500.00, 'Salary Deposit', '2024-01-19 10:45:00'),
(209, 'DEBIT', 13500.00, 'Loan EMI', '2024-01-21 09:30:00');

-- Transactions for Branch 7 accounts
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- Account 241 (Arnab Chatterjee - Savings)
(241, 'CREDIT', 58000.00, 'Salary Credit', '2024-01-31 09:15:00'),
(241, 'DEBIT', 23000.00, 'Home EMI', '2024-02-02 10:45:00'),
-- Account 243 (Mousumi Banerjee - Savings)
(243, 'CREDIT', 48000.00, 'Monthly Income', '2024-01-28 08:30:00'),
(243, 'DEBIT', 18000.00, 'Insurance Payment', '2024-01-30 11:20:00'),
-- Account 245 (Pranab Roy - Savings)
(245, 'CREDIT', 45000.00, 'Contract Fee', '2024-01-25 14:15:00'),
(245, 'DEBIT', 15000.00, 'Education', '2024-01-27 15:30:00'),
-- Account 247 (Sharmistha Mitra - Savings)
(247, 'CREDIT', 51000.00, 'Business Receipt', '2024-01-23 12:45:00'),
(247, 'DEBIT', 11000.00, 'Bills Payment', '2024-01-25 17:20:00'),
-- Account 249 (Santanu Sen - Savings)
(249, 'CREDIT', 54000.00, 'Salary', '2024-01-20 10:30:00'),
(249, 'DEBIT', 14000.00, 'Car EMI', '2024-01-22 09:45:00');

-- ==================== INTER-BRANCH TRANSACTIONS ====================
-- Some NEFT/RTGS/IMPS transactions between different branches
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- NEFT from Hyderabad to Bangalore
(1, 'DEBIT', 10000.00, 'NEFT to Aravind Krishnan', '2024-01-22 11:30:00'),
(41, 'CREDIT', 10000.00, 'NEFT from Suresh Goud', '2024-01-22 11:35:00'),
-- IMPS from Chennai to Mumbai
(81, 'DEBIT', 5000.00, 'IMPS to Amit Verma', '2024-01-19 14:45:00'),
(121, 'CREDIT', 5000.00, 'IMPS from Rameshwar Iyengar', '2024-01-19 14:48:00'),
-- RTGS from Delhi to Pune
(161, 'DEBIT', 25000.00, 'RTGS to Abhijit Bhide', '2024-01-25 10:15:00'),
(201, 'CREDIT', 25000.00, 'RTGS from Nitin Chauhan', '2024-01-25 10:18:00'),
-- UPI from Kolkata to Hyderabad
(241, 'DEBIT', 8000.00, 'UPI to Lakshmi Reddy', '2024-01-28 16:20:00'),
(3, 'CREDIT', 8000.00, 'UPI from Arnab Chatterjee', '2024-01-28 16:22:00'),
-- Fund Transfer within same branch (Hyderabad)
(5, 'DEBIT', 3000.00, 'Transfer to Swathi Naidu', '2024-01-21 13:15:00'),
(7, 'CREDIT', 3000.00, 'Transfer from Kiran Kumar', '2024-01-21 13:16:00');

-- ==================== RECURRING TRANSACTIONS ====================
-- Some monthly recurring payments
INSERT INTO transactions (account_id, transaction_type, amount, description, created_at) VALUES
-- Netflix Subscription
(1, 'DEBIT', 649.00, 'Netflix Monthly Subscription', '2024-01-05 02:00:00'),
(41, 'DEBIT', 649.00, 'Netflix Monthly Subscription', '2024-01-05 02:00:00'),
(81, 'DEBIT', 649.00, 'Netflix Monthly Subscription', '2024-01-05 02:00:00'),
-- Amazon Prime
(3, 'DEBIT', 299.00, 'Amazon Prime Monthly', '2024-01-10 03:00:00'),
(43, 'DEBIT', 299.00, 'Amazon Prime Monthly', '2024-01-10 03:00:00'),
(83, 'DEBIT', 299.00, 'Amazon Prime Monthly', '2024-01-10 03:00:00'),
-- Spotify Premium
(5, 'DEBIT', 119.00, 'Spotify Premium', '2024-01-15 04:00:00'),
(45, 'DEBIT', 119.00, 'Spotify Premium', '2024-01-15 04:00:00'),
(85, 'DEBIT', 119.00, 'Spotify Premium', '2024-01-15 04:00:00'),
-- Gym Membership
(7, 'DEBIT', 1500.00, 'Gym Monthly Fee', '2024-01-20 09:00:00'),
(47, 'DEBIT', 1500.00, 'Gym Monthly Fee', '2024-01-20 09:00:00'),
(87, 'DEBIT', 1500.00, 'Gym Monthly Fee', '2024-01-20 09:00:00'),
-- Newspaper Subscription
(9, 'DEBIT', 300.00, 'Newspaper Monthly', '2024-01-25 06:00:00'),
(49, 'DEBIT', 300.00, 'Newspaper Monthly', '2024-01-25 06:00:00'),
(89, 'DEBIT', 300.00, 'Newspaper Monthly', '2024-01-25 06:00:00');
-----------------------------------------------------------------------

SELECT
        (SELECT COUNT(*) 
         FROM users 
         WHERE branch_id = 1 AND role_id = 2) AS total_employees,

        (SELECT COUNT(*) 
         FROM customers c
         JOIN users u ON c.user_id = u.user_id
         WHERE u.branch_id = 1) AS total_customers,

        (SELECT COUNT(*) 
         FROM accounts a
         JOIN customers c ON a.customer_id = c.customer_id
         JOIN users u ON c.user_id = u.user_id
         WHERE u.branch_id = 1) AS total_accounts,

        (SELECT COALESCE(SUM(a.balance), 0)
         FROM accounts a
         JOIN customers c ON a.customer_id = c.customer_id
         JOIN users u ON c.user_id = u.user_id
         WHERE u.branch_id = 1 AND a.status = 'ACTIVE') AS branch_balance;

SELECT
  u.username,
  c.first_name,
  c.last_name,
  c.email,
  c.phone,
  b.branch_name,
  b.branch_code,
CONCAT(b.city,',',b.state) AS branch_address
FROM users u
JOIN customers c
  ON u.user_id = c.user_id
JOIN branches b
  ON u.branch_id = b.branch_id
WHERE u.user_id = 7;

select * from users where role_id=3 or role_id =2;
select * from employees

















--  ================================================================
-- First, add the new columns to employees table
ALTER TABLE employees
ADD COLUMN first_name VARCHAR(50) NOT NULL DEFAULT '',
ADD COLUMN last_name VARCHAR(50) NOT NULL DEFAULT '',
ADD COLUMN email VARCHAR(100) UNIQUE,
ADD COLUMN phone VARCHAR(15),
ADD COLUMN gender ENUM('MALE','FEMALE','OTHER'),
ADD COLUMN address TEXT,
ADD COLUMN salary DECIMAL(10,2),
ADD COLUMN manager_id INT NULL;

-- Add foreign key constraint for manager_id
ALTER TABLE employees
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

-- Create a temporary table to store manager mappings
CREATE TEMPORARY TABLE temp_manager_mapping (
    branch_prefix VARCHAR(10),
    manager_employee_id INT
);

-- Insert manager IDs for each branch
INSERT INTO temp_manager_mapping (branch_prefix, manager_employee_id)
VALUES 
    ('.b1', 1),  -- Hyderabad
    ('.b2', 7),  -- Bangalore
    ('.b3', 13), -- Chennai
    ('.b4', 19), -- Mumbai
    ('.b5', 25), -- Delhi
    ('.b6', 31), -- Pune
    ('.b7', 37); -- Kolkata

-- Now update all employees using JOIN with users table
-- We'll do it in separate UPDATE statements for each branch

-- BRANCH 1: Hyderabad (employees 1-6)
UPDATE employees e
INNER JOIN users u ON e.user_id = u.user_id
INNER JOIN temp_manager_mapping t ON u.username LIKE CONCAT('%.b1')
SET 
    e.first_name = CASE 
        WHEN u.username = 'arjun.reddy.mgr.b1' THEN 'Arjun'
        WHEN u.username = 'priya.sharma.b1' THEN 'Priya'
        WHEN u.username = 'vikram.singh.b1' THEN 'Vikram'
        WHEN u.username = 'ananya.patel.b1' THEN 'Ananya'
        WHEN u.username = 'rakesh.kumar.b1' THEN 'Rakesh'
        WHEN u.username = 'meera.desai.b1' THEN 'Meera'
        ELSE e.first_name
    END,
    e.last_name = CASE 
        WHEN u.username = 'arjun.reddy.mgr.b1' THEN 'Reddy'
        WHEN u.username = 'priya.sharma.b1' THEN 'Sharma'
        WHEN u.username = 'vikram.singh.b1' THEN 'Singh'
        WHEN u.username = 'ananya.patel.b1' THEN 'Patel'
        WHEN u.username = 'rakesh.kumar.b1' THEN 'Kumar'
        WHEN u.username = 'meera.desai.b1' THEN 'Desai'
        ELSE e.last_name
    END,
    e.email = CASE 
        WHEN u.username = 'arjun.reddy.mgr.b1' THEN 'arjun.reddy@bank.com'
        WHEN u.username = 'priya.sharma.b1' THEN 'priya.sharma@bank.com'
        WHEN u.username = 'vikram.singh.b1' THEN 'vikram.singh@bank.com'
        WHEN u.username = 'ananya.patel.b1' THEN 'ananya.patel@bank.com'
        WHEN u.username = 'rakesh.kumar.b1' THEN 'rakesh.kumar@bank.com'
        WHEN u.username = 'meera.desai.b1' THEN 'meera.desai@bank.com'
        ELSE e.email
    END,
    e.phone = CONCAT('98765', 43200 + e.employee_id),
    e.gender = CASE 
        WHEN u.username IN ('priya.sharma.b1', 'ananya.patel.b1', 'meera.desai.b1') THEN 'FEMALE'
        ELSE 'MALE'
    END,
    e.address = CASE u.username
        WHEN 'arjun.reddy.mgr.b1' THEN 'Plot No. 123, Madhapur, Hyderabad'
        WHEN 'priya.sharma.b1' THEN 'H.No. 456, Jubilee Hills, Hyderabad'
        WHEN 'vikram.singh.b1' THEN 'Flat 301, Banjara Hills, Hyderabad'
        WHEN 'ananya.patel.b1' THEN 'Sector 5, Hitech City, Hyderabad'
        WHEN 'rakesh.kumar.b1' THEN 'Road No. 12, Banjara Hills, Hyderabad'
        WHEN 'meera.desai.b1' THEN 'Kondapur, Hyderabad'
        ELSE 'Address not set'
    END,
    e.salary = CASE 
        WHEN e.designation = 'Branch Manager' THEN 85000.00
        WHEN e.designation = 'Senior Teller' THEN 45000.00
        WHEN e.designation = 'Loan Officer' THEN 55000.00
        WHEN e.designation = 'Financial Advisor' THEN 60000.00
        WHEN e.designation = 'Customer Service Rep' THEN 40000.00
        WHEN e.designation = 'Operations Specialist' THEN 42000.00
        ELSE 35000.00
    END,
    e.manager_id = CASE 
        WHEN e.designation = 'Branch Manager' THEN NULL
        ELSE t.manager_employee_id
    END
WHERE u.username LIKE '%.b1';

-- BRANCH 2: Bangalore (employees 7-12)
UPDATE employees e
INNER JOIN users u ON e.user_id = u.user_id
INNER JOIN temp_manager_mapping t ON u.username LIKE CONCAT('%.b2')
SET 
    e.first_name = CASE u.username
        WHEN 'rajesh.nair.mgr.b2' THEN 'Rajesh'
        WHEN 'anjali.menon.b2' THEN 'Anjali'
        WHEN 'sandeep.iyer.b2' THEN 'Sandeep'
        WHEN 'divya.rao.b2' THEN 'Divya'
        WHEN 'karthik.pillai.b2' THEN 'Karthik'
        WHEN 'neha.bhat.b2' THEN 'Neha'
        ELSE e.first_name
    END,
    e.last_name = CASE u.username
        WHEN 'rajesh.nair.mgr.b2' THEN 'Nair'
        WHEN 'anjali.menon.b2' THEN 'Menon'
        WHEN 'sandeep.iyer.b2' THEN 'Iyer'
        WHEN 'divya.rao.b2' THEN 'Rao'
        WHEN 'karthik.pillai.b2' THEN 'Pillai'
        WHEN 'neha.bhat.b2' THEN 'Bhat'
        ELSE e.last_name
    END,
    e.email = CONCAT(
        REPLACE(REPLACE(u.username, '.b2', ''), '.', '_'),
        '@bank.com'
    ),
    e.phone = CONCAT('98765', 43206 + e.employee_id),
    e.gender = CASE 
        WHEN u.username IN ('anjali.menon.b2', 'divya.rao.b2', 'neha.bhat.b2') THEN 'FEMALE'
        ELSE 'MALE'
    END,
    e.address = CONCAT('Whitefield, Bangalore - Employee ID: ', e.employee_id),
    e.salary = CASE 
        WHEN e.designation = 'Branch Manager' THEN 88000.00
        WHEN e.designation = 'Senior Teller' THEN 46000.00
        WHEN e.designation = 'Loan Officer' THEN 56000.00
        WHEN e.designation = 'Financial Advisor' THEN 62000.00
        WHEN e.designation = 'Customer Service Rep' THEN 41000.00
        WHEN e.designation = 'Operations Specialist' THEN 43000.00
        ELSE 36000.00
    END,
    e.manager_id = CASE 
        WHEN e.designation = 'Branch Manager' THEN NULL
        ELSE t.manager_employee_id
    END
WHERE u.username LIKE '%.b2';

-- BRANCH 3: Chennai (employees 13-18)
UPDATE employees e
INNER JOIN users u ON e.user_id = u.user_id
INNER JOIN temp_manager_mapping t ON u.username LIKE CONCAT('%.b3')
SET 
    e.first_name = CASE u.username
        WHEN 'sundar.iyer.mgr.b3' THEN 'Sundar'
        WHEN 'lakshmi.rajan.b3' THEN 'Lakshmi'
        WHEN 'venkatesh.pillai.b3' THEN 'Venkatesh'
        WHEN 'malini.subramanian.b3' THEN 'Malini'
        WHEN 'gopal.raman.b3' THEN 'Gopal'
        WHEN 'usha.krishnan.b3' THEN 'Usha'
        ELSE e.first_name
    END,
    e.last_name = CASE u.username
        WHEN 'sundar.iyer.mgr.b3' THEN 'Iyer'
        WHEN 'lakshmi.rajan.b3' THEN 'Rajan'
        WHEN 'venkatesh.pillai.b3' THEN 'Pillai'
        WHEN 'malini.subramanian.b3' THEN 'Subramanian'
        WHEN 'gopal.raman.b3' THEN 'Raman'
        WHEN 'usha.krishnan.b3' THEN 'Krishnan'
        ELSE e.last_name
    END,
    e.email = CONCAT(
        REPLACE(REPLACE(u.username, '.b3', ''), '.', '_'),
        '@bank.com'
    ),
    e.phone = CONCAT('98765', 43212 + e.employee_id),
    e.gender = CASE 
        WHEN u.username IN ('lakshmi.rajan.b3', 'malini.subramanian.b3', 'usha.krishnan.b3') THEN 'FEMALE'
        ELSE 'MALE'
    END,
    e.address = CONCAT('T Nagar, Chennai - Employee ID: ', e.employee_id),
    e.salary = CASE 
        WHEN e.designation = 'Branch Manager' THEN 82000.00
        WHEN e.designation = 'Senior Teller' THEN 44000.00
        WHEN e.designation = 'Loan Officer' THEN 54000.00
        WHEN e.designation = 'Financial Advisor' THEN 59000.00
        WHEN e.designation = 'Customer Service Rep' THEN 39000.00
        WHEN e.designation = 'Operations Specialist' THEN 41000.00
        ELSE 34000.00
    END,
    e.manager_id = CASE 
        WHEN e.designation = 'Branch Manager' THEN NULL
        ELSE t.manager_employee_id
    END
WHERE u.username LIKE '%.b3';

-- BRANCH 4: Mumbai (employees 19-24)
UPDATE employees e
INNER JOIN users u ON e.user_id = u.user_id
INNER JOIN temp_manager_mapping t ON u.username LIKE CONCAT('%.b4')
SET 
    e.first_name = CASE u.username
        WHEN 'rohit.shah.mgr.b4' THEN 'Rohit'
        WHEN 'aisha.kapoor.b4' THEN 'Aisha'
        WHEN 'samir.desai.b4' THEN 'Samir'
        WHEN 'tanvi.mehta.b4' THEN 'Tanvi'
        WHEN 'rajiv.chopra.b4' THEN 'Rajiv'
        WHEN 'priyanka.singhania.b4' THEN 'Priyanka'
        ELSE e.first_name
    END,
    e.last_name = CASE u.username
        WHEN 'rohit.shah.mgr.b4' THEN 'Shah'
        WHEN 'aisha.kapoor.b4' THEN 'Kapoor'
        WHEN 'samir.desai.b4' THEN 'Desai'
        WHEN 'tanvi.mehta.b4' THEN 'Mehta'
        WHEN 'rajiv.chopra.b4' THEN 'Chopra'
        WHEN 'priyanka.singhania.b4' THEN 'Singhania'
        ELSE e.last_name
    END,
    e.email = CONCAT(
        REPLACE(REPLACE(u.username, '.b4', ''), '.', '_'),
        '@bank.com'
    ),
    e.phone = CONCAT('98765', 43218 + e.employee_id),
    e.gender = CASE 
        WHEN u.username IN ('aisha.kapoor.b4', 'tanvi.mehta.b4', 'priyanka.singhania.b4') THEN 'FEMALE'
        ELSE 'MALE'
    END,
    e.address = CONCAT('Andheri East, Mumbai - Employee ID: ', e.employee_id),
    e.salary = CASE 
        WHEN e.designation = 'Branch Manager' THEN 92000.00
        WHEN e.designation = 'Senior Teller' THEN 48000.00
        WHEN e.designation = 'Loan Officer' THEN 58000.00
        WHEN e.designation = 'Financial Advisor' THEN 65000.00
        WHEN e.designation = 'Customer Service Rep' THEN 43000.00
        WHEN e.designation = 'Operations Specialist' THEN 45000.00
        ELSE 38000.00
    END,
    e.manager_id = CASE 
        WHEN e.designation = 'Branch Manager' THEN NULL
        ELSE t.manager_employee_id
    END
WHERE u.username LIKE '%.b4';

-- BRANCH 5: Delhi (employees 25-30)
UPDATE employees e
INNER JOIN users u ON e.user_id = u.user_id
INNER JOIN temp_manager_mapping t ON u.username LIKE CONCAT('%.b5')
SET 
    e.first_name = CASE u.username
        WHEN 'vivek.saxena.mgr.b5' THEN 'Vivek'
        WHEN 'anisha.gupta.b5' THEN 'Anisha'
        WHEN 'arun.malik.b5' THEN 'Arun'
        WHEN 'shikha.arora.b5' THEN 'Shikha'
        WHEN 'rohit.kapoor.b5' THEN 'Rohit'
        WHEN 'megha.tyagi.b5' THEN 'Megha'
        ELSE e.first_name
    END,
    e.last_name = CASE u.username
        WHEN 'vivek.saxena.mgr.b5' THEN 'Saxena'
        WHEN 'anisha.gupta.b5' THEN 'Gupta'
        WHEN 'arun.malik.b5' THEN 'Malik'
        WHEN 'shikha.arora.b5' THEN 'Arora'
        WHEN 'rohit.kapoor.b5' THEN 'Kapoor'
        WHEN 'megha.tyagi.b5' THEN 'Tyagi'
        ELSE e.last_name
    END,
    e.email = CONCAT(
        REPLACE(REPLACE(u.username, '.b5', ''), '.', '_'),
        '@bank.com'
    ),
    e.phone = CONCAT('98765', 43224 + e.employee_id),
    e.gender = CASE 
        WHEN u.username IN ('anisha.gupta.b5', 'shikha.arora.b5', 'megha.tyagi.b5') THEN 'FEMALE'
        ELSE 'MALE'
    END,
    e.address = CONCAT('Connaught Place, Delhi - Employee ID: ', e.employee_id),
    e.salary = CASE 
        WHEN e.designation = 'Branch Manager' THEN 90000.00
        WHEN e.designation = 'Senior Teller' THEN 47000.00
        WHEN e.designation = 'Loan Officer' THEN 57000.00
        WHEN e.designation = 'Financial Advisor' THEN 63000.00
        WHEN e.designation = 'Customer Service Rep' THEN 42000.00
        WHEN e.designation = 'Operations Specialist' THEN 44000.00
        ELSE 37000.00
    END,
    e.manager_id = CASE 
        WHEN e.designation = 'Branch Manager' THEN NULL
        ELSE t.manager_employee_id
    END
WHERE u.username LIKE '%.b5';

-- BRANCH 6: Pune (employees 31-36)
UPDATE employees e
INNER JOIN users u ON e.user_id = u.user_id
INNER JOIN temp_manager_mapping t ON u.username LIKE CONCAT('%.b6')
SET 
    e.first_name = CASE u.username
        WHEN 'sanjay.patil.mgr.b6' THEN 'Sanjay'
        WHEN 'snehal.joshi.b6' THEN 'Snehal'
        WHEN 'amol.kulkarni.b6' THEN 'Amol'
        WHEN 'rashmi.deshpande.b6' THEN 'Rashmi'
        WHEN 'prasad.more.b6' THEN 'Prasad'
        WHEN 'supriya.gaikwad.b6' THEN 'Supriya'
        ELSE e.first_name
    END,
    e.last_name = CASE u.username
        WHEN 'sanjay.patil.mgr.b6' THEN 'Patil'
        WHEN 'snehal.joshi.b6' THEN 'Joshi'
        WHEN 'amol.kulkarni.b6' THEN 'Kulkarni'
        WHEN 'rashmi.deshpande.b6' THEN 'Deshpande'
        WHEN 'prasad.more.b6' THEN 'More'
        WHEN 'supriya.gaikwad.b6' THEN 'Gaikwad'
        ELSE e.last_name
    END,
    e.email = CONCAT(
        REPLACE(REPLACE(u.username, '.b6', ''), '.', '_'),
        '@bank.com'
    ),
    e.phone = CONCAT('98765', 43230 + e.employee_id),
    e.gender = CASE 
        WHEN u.username IN ('snehal.joshi.b6', 'rashmi.deshpande.b6', 'supriya.gaikwad.b6') THEN 'FEMALE'
        ELSE 'MALE'
    END,
    e.address = CONCAT('Hinjewadi, Pune - Employee ID: ', e.employee_id),
    e.salary = CASE 
        WHEN e.designation = 'Branch Manager' THEN 83000.00
        WHEN e.designation = 'Senior Teller' THEN 43000.00
        WHEN e.designation = 'Loan Officer' THEN 53000.00
        WHEN e.designation = 'Financial Advisor' THEN 58000.00
        WHEN e.designation = 'Customer Service Rep' THEN 38000.00
        WHEN e.designation = 'Operations Specialist' THEN 40000.00
        ELSE 33000.00
    END,
    e.manager_id = CASE 
        WHEN e.designation = 'Branch Manager' THEN NULL
        ELSE t.manager_employee_id
    END
WHERE u.username LIKE '%.b6';

-- BRANCH 7: Kolkata (employees 37-42)
UPDATE employees e
INNER JOIN users u ON e.user_id = u.user_id
INNER JOIN temp_manager_mapping t ON u.username LIKE CONCAT('%.b7')
SET 
    e.first_name = CASE u.username
        WHEN 'soumitra.bose.mgr.b7' THEN 'Soumitra'
        WHEN 'indrani.ganguly.b7' THEN 'Indrani'
        WHEN 'debashis.mukherjee.b7' THEN 'Debashis'
        WHEN 'moumita.ghosh.b7' THEN 'Moumita'
        WHEN 'subhro.dasgupta.b7' THEN 'Subhro'
        WHEN 'rinku.saha.b7' THEN 'Rinku'
        ELSE e.first_name
    END,
    e.last_name = CASE u.username
        WHEN 'soumitra.bose.mgr.b7' THEN 'Bose'
        WHEN 'indrani.ganguly.b7' THEN 'Ganguly'
        WHEN 'debashis.mukherjee.b7' THEN 'Mukherjee'
        WHEN 'moumita.ghosh.b7' THEN 'Ghosh'
        WHEN 'subhro.dasgupta.b7' THEN 'Dasgupta'
        WHEN 'rinku.saha.b7' THEN 'Saha'
        ELSE e.last_name
    END,
    e.email = CONCAT(
        REPLACE(REPLACE(u.username, '.b7', ''), '.', '_'),
        '@bank.com'
    ),
    e.phone = CONCAT('98765', 43236 + e.employee_id),
    e.gender = CASE 
        WHEN u.username IN ('indrani.ganguly.b7', 'moumita.ghosh.b7', 'rinku.saha.b7') THEN 'FEMALE'
        ELSE 'MALE'
    END,
    e.address = CONCAT('Salt Lake, Kolkata - Employee ID: ', e.employee_id),
    e.salary = CASE 
        WHEN e.designation = 'Branch Manager' THEN 82000.00
        WHEN e.designation = 'Senior Teller' THEN 42000.00
        WHEN e.designation = 'Loan Officer' THEN 52000.00
        WHEN e.designation = 'Financial Advisor' THEN 57000.00
        WHEN e.designation = 'Customer Service Rep' THEN 37000.00
        WHEN e.designation = 'Operations Specialist' THEN 39000.00
        ELSE 32000.00
    END,
    e.manager_id = CASE 
        WHEN e.designation = 'Branch Manager' THEN NULL
        ELSE t.manager_employee_id
    END
WHERE u.username LIKE '%.b7';

-- Clean up temporary table
DROP TEMPORARY TABLE temp_manager_mapping;

-- Finally, remove the DEFAULT values from first_name and last_name columns
ALTER TABLE employees 
MODIFY COLUMN first_name VARCHAR(50) NOT NULL,
MODIFY COLUMN last_name VARCHAR(50) NOT NULL;

-- Verify the updates
SELECT e.employee_id, e.first_name, e.last_name, e.email, e.phone, e.gender, 
       e.designation, e.salary, e.manager_id, u.username
FROM employees e
JOIN users u ON e.user_id = u.user_id
ORDER BY e.employee_id;

select * from employees;