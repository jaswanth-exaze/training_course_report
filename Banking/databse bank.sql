-- drop database banking_system;
CREATE DATABASE banking_system
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE banking_system;
CREATE TABLE `accounts` ( 
  `account_id` INT AUTO_INCREMENT NOT NULL,
  `customer_id` INT NOT NULL,
  `account_number` VARCHAR(20) NOT NULL,
  `account_type` ENUM('SAVINGS','CURRENT') NOT NULL,
  `balance` DECIMAL(12,2) NULL DEFAULT 0.00 ,
  `status` ENUM('ACTIVE','BLOCKED','CLOSED') NULL DEFAULT 'ACTIVE' ,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ,
   PRIMARY KEY (`account_id`),
  CONSTRAINT `account_number` UNIQUE (`account_number`),
  CONSTRAINT `account_number_2` UNIQUE (`account_number`)
)
ENGINE = InnoDB;
CREATE TABLE `branches` ( 
  `branch_id` INT AUTO_INCREMENT NOT NULL,
  `branch_code` VARCHAR(10) NOT NULL,
  `branch_name` VARCHAR(100) NOT NULL,
  `city` VARCHAR(50) NULL,
  `state` VARCHAR(50) NULL,
   PRIMARY KEY (`branch_id`),
  CONSTRAINT `branch_code` UNIQUE (`branch_code`)
)
ENGINE = InnoDB;
CREATE TABLE `customers` ( 
  `customer_id` INT AUTO_INCREMENT NOT NULL,
  `user_id` INT NOT NULL,
  `first_name` VARCHAR(50) NULL,
  `last_name` VARCHAR(50) NULL,
  `email` VARCHAR(100) NULL,
  `phone` VARCHAR(15) NULL,
   PRIMARY KEY (`customer_id`),
  CONSTRAINT `user_id` UNIQUE (`user_id`)
)
ENGINE = InnoDB;
CREATE TABLE `employees` ( 
  `employee_id` INT AUTO_INCREMENT NOT NULL,
  `user_id` INT NOT NULL,
  `designation` VARCHAR(50) NULL,
  `joined_date` DATE NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NULL,
  `phone` VARCHAR(15) NULL,
  `gender` ENUM('MALE','FEMALE','OTHER') NULL,
  `address` TEXT NULL,
  `salary` DECIMAL(10,2) NULL,
  `manager_id` INT NULL,
   PRIMARY KEY (`employee_id`),
  CONSTRAINT `user_id` UNIQUE (`user_id`),
  CONSTRAINT `email` UNIQUE (`email`)
)
ENGINE = InnoDB;
CREATE TABLE `roles` ( 
  `role_id` INT AUTO_INCREMENT NOT NULL,
  `role_name` ENUM('CUSTOMER','EMPLOYEE','MANAGER') NOT NULL,
   PRIMARY KEY (`role_id`),
  CONSTRAINT `role_name` UNIQUE (`role_name`)
)
ENGINE = InnoDB;
CREATE TABLE `transactions` ( 
  `transaction_id` INT AUTO_INCREMENT NOT NULL,
  `from_account_id` INT NULL,
  `transaction_type` ENUM('CREDIT','DEBIT','DEPOSIT','WITHDRAWAL','TRANSFER') NOT NULL DEFAULT 'CREDIT' ,
  `amount` DECIMAL(12,2) NULL,
  `description` VARCHAR(100) NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ,
  `to_account_id` INT NULL,
  `reference_number` VARCHAR(50) NULL,
  `status` ENUM('PENDING','SUCCESS','FAILED') NULL DEFAULT 'PENDING' ,
   PRIMARY KEY (`transaction_id`),
  CONSTRAINT `reference_number` UNIQUE (`reference_number`)
)
ENGINE = InnoDB;
CREATE TABLE `users` ( 
  `user_id` INT AUTO_INCREMENT NOT NULL,
  `username` VARCHAR(100) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `role_id` INT NOT NULL,
  `branch_id` INT NOT NULL,
  `is_active` TINYINT NULL DEFAULT 1 ,
   PRIMARY KEY (`user_id`),
  CONSTRAINT `username` UNIQUE (`username`)
)

CREATE TABLE refresh_tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  token VARCHAR(255) NOT NULL,
  expires_at DATETIME NOT NULL,
  is_revoked BOOLEAN DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);


ENGINE = InnoDB;
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (1, 1, 'ACC1000000002', 'SAVINGS', '27000.00', 'ACTIVE', '2026-01-29 16:21:01');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (2, 1, 'ACC1000000003', 'CURRENT', '51000.00', 'ACTIVE', '2026-01-29 16:21:01');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (3, 2, 'ACC1000000004', 'SAVINGS', '35000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (4, 2, 'ACC1000000005', 'CURRENT', '75000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (5, 3, 'ACC1000000006', 'SAVINGS', '42000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (6, 3, 'ACC1000000007', 'CURRENT', '65000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (7, 4, 'ACC1000000008', 'SAVINGS', '28000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (8, 4, 'ACC1000000009', 'CURRENT', '82000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (9, 5, 'ACC1000000010', 'SAVINGS', '31000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (10, 5, 'ACC1000000011', 'CURRENT', '55000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (11, 6, 'ACC1000000012', 'SAVINGS', '19000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (12, 6, 'ACC1000000013', 'CURRENT', '45000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (13, 7, 'ACC1000000014', 'SAVINGS', '52000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (14, 7, 'ACC1000000015', 'CURRENT', '92000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (15, 8, 'ACC1000000016', 'SAVINGS', '23000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (16, 8, 'ACC1000000017', 'CURRENT', '48000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (17, 9, 'ACC1000000018', 'SAVINGS', '37000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (18, 9, 'ACC1000000019', 'CURRENT', '68000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (19, 10, 'ACC1000000020', 'SAVINGS', '41000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (20, 10, 'ACC1000000021', 'CURRENT', '79000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (21, 11, 'ACC1000000022', 'SAVINGS', '26000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (22, 11, 'ACC1000000023', 'CURRENT', '51000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (23, 12, 'ACC1000000024', 'SAVINGS', '33000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (24, 12, 'ACC1000000025', 'CURRENT', '72000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (25, 13, 'ACC1000000026', 'SAVINGS', '29000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (26, 13, 'ACC1000000027', 'CURRENT', '63000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (27, 14, 'ACC1000000028', 'SAVINGS', '24000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (28, 14, 'ACC1000000029', 'CURRENT', '57000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (29, 15, 'ACC1000000030', 'SAVINGS', '38000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (30, 15, 'ACC1000000031', 'CURRENT', '81000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (31, 16, 'ACC1000000032', 'SAVINGS', '22000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (32, 16, 'ACC1000000033', 'CURRENT', '49000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (33, 17, 'ACC1000000034', 'SAVINGS', '43000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (34, 17, 'ACC1000000035', 'CURRENT', '88000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (35, 18, 'ACC1000000036', 'SAVINGS', '27000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (36, 18, 'ACC1000000037', 'CURRENT', '54000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (37, 19, 'ACC1000000038', 'SAVINGS', '36000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (38, 19, 'ACC1000000039', 'CURRENT', '76000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (39, 20, 'ACC1000000040', 'SAVINGS', '32000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (40, 20, 'ACC1000000041', 'CURRENT', '71000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (41, 21, 'ACC1000000042', 'SAVINGS', '25500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (42, 21, 'ACC1000000043', 'CURRENT', '50500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (43, 22, 'ACC1000000044', 'SAVINGS', '35500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (44, 22, 'ACC1000000045', 'CURRENT', '75500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (45, 23, 'ACC1000000046', 'SAVINGS', '42500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (46, 23, 'ACC1000000047', 'CURRENT', '65500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (47, 24, 'ACC1000000048', 'SAVINGS', '28500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (48, 24, 'ACC1000000049', 'CURRENT', '82500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (49, 25, 'ACC1000000050', 'SAVINGS', '31500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (50, 25, 'ACC1000000051', 'CURRENT', '55500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (51, 26, 'ACC1000000052', 'SAVINGS', '19500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (52, 26, 'ACC1000000053', 'CURRENT', '45500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (53, 27, 'ACC1000000054', 'SAVINGS', '52500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (54, 27, 'ACC1000000055', 'CURRENT', '92500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (55, 28, 'ACC1000000056', 'SAVINGS', '23500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (56, 28, 'ACC1000000057', 'CURRENT', '48500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (57, 29, 'ACC1000000058', 'SAVINGS', '37500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (58, 29, 'ACC1000000059', 'CURRENT', '68500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (59, 30, 'ACC1000000060', 'SAVINGS', '41500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (60, 30, 'ACC1000000061', 'CURRENT', '79500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (61, 31, 'ACC1000000062', 'SAVINGS', '26500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (62, 31, 'ACC1000000063', 'CURRENT', '51500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (63, 32, 'ACC1000000064', 'SAVINGS', '33500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (64, 32, 'ACC1000000065', 'CURRENT', '72500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (65, 33, 'ACC1000000066', 'SAVINGS', '29500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (66, 33, 'ACC1000000067', 'CURRENT', '63500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (67, 34, 'ACC1000000068', 'SAVINGS', '24500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (68, 34, 'ACC1000000069', 'CURRENT', '57500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (69, 35, 'ACC1000000070', 'SAVINGS', '38500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (70, 35, 'ACC1000000071', 'CURRENT', '81500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (71, 36, 'ACC1000000072', 'SAVINGS', '22500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (72, 36, 'ACC1000000073', 'CURRENT', '49500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (73, 37, 'ACC1000000074', 'SAVINGS', '43500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (74, 37, 'ACC1000000075', 'CURRENT', '88500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (75, 38, 'ACC1000000076', 'SAVINGS', '27500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (76, 38, 'ACC1000000077', 'CURRENT', '54500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (77, 39, 'ACC1000000078', 'SAVINGS', '36500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (78, 39, 'ACC1000000079', 'CURRENT', '76500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (79, 40, 'ACC1000000080', 'SAVINGS', '32500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (80, 40, 'ACC1000000081', 'CURRENT', '71500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (81, 41, 'ACC1000000082', 'SAVINGS', '26000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (82, 41, 'ACC1000000083', 'CURRENT', '51000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (83, 42, 'ACC1000000084', 'SAVINGS', '36000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (84, 42, 'ACC1000000085', 'CURRENT', '76000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (85, 43, 'ACC1000000086', 'SAVINGS', '43000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (86, 43, 'ACC1000000087', 'CURRENT', '66000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (87, 44, 'ACC1000000088', 'SAVINGS', '29000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (88, 44, 'ACC1000000089', 'CURRENT', '83000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (89, 45, 'ACC1000000090', 'SAVINGS', '32000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (90, 45, 'ACC1000000091', 'CURRENT', '56000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (91, 46, 'ACC1000000092', 'SAVINGS', '20000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (92, 46, 'ACC1000000093', 'CURRENT', '46000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (93, 47, 'ACC1000000094', 'SAVINGS', '53000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (94, 47, 'ACC1000000095', 'CURRENT', '93000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (95, 48, 'ACC1000000096', 'SAVINGS', '24000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (96, 48, 'ACC1000000097', 'CURRENT', '49000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (97, 49, 'ACC1000000098', 'SAVINGS', '38000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (98, 49, 'ACC1000000099', 'CURRENT', '69000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (99, 50, 'ACC1000000100', 'SAVINGS', '42000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (100, 50, 'ACC1000000101', 'CURRENT', '80000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (101, 51, 'ACC1000000102', 'SAVINGS', '27000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (102, 51, 'ACC1000000103', 'CURRENT', '52000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (103, 52, 'ACC1000000104', 'SAVINGS', '34000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (104, 52, 'ACC1000000105', 'CURRENT', '73000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (105, 53, 'ACC1000000106', 'SAVINGS', '30000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (106, 53, 'ACC1000000107', 'CURRENT', '64000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (107, 54, 'ACC1000000108', 'SAVINGS', '25000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (108, 54, 'ACC1000000109', 'CURRENT', '58000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (109, 55, 'ACC1000000110', 'SAVINGS', '39000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (110, 55, 'ACC1000000111', 'CURRENT', '82000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (111, 56, 'ACC1000000112', 'SAVINGS', '23000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (112, 56, 'ACC1000000113', 'CURRENT', '50000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (113, 57, 'ACC1000000114', 'SAVINGS', '44000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (114, 57, 'ACC1000000115', 'CURRENT', '89000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (115, 58, 'ACC1000000116', 'SAVINGS', '28000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (116, 58, 'ACC1000000117', 'CURRENT', '55000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (117, 59, 'ACC1000000118', 'SAVINGS', '37000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (118, 59, 'ACC1000000119', 'CURRENT', '77000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (119, 60, 'ACC1000000120', 'SAVINGS', '33000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (120, 60, 'ACC1000000121', 'CURRENT', '72000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (121, 61, 'ACC1000000122', 'SAVINGS', '26500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (122, 61, 'ACC1000000123', 'CURRENT', '51500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (123, 62, 'ACC1000000124', 'SAVINGS', '36500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (124, 62, 'ACC1000000125', 'CURRENT', '76500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (125, 63, 'ACC1000000126', 'SAVINGS', '43500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (126, 63, 'ACC1000000127', 'CURRENT', '66500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (127, 64, 'ACC1000000128', 'SAVINGS', '29500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (128, 64, 'ACC1000000129', 'CURRENT', '83500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (129, 65, 'ACC1000000130', 'SAVINGS', '32500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (130, 65, 'ACC1000000131', 'CURRENT', '56500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (131, 66, 'ACC1000000132', 'SAVINGS', '20500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (132, 66, 'ACC1000000133', 'CURRENT', '46500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (133, 67, 'ACC1000000134', 'SAVINGS', '53500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (134, 67, 'ACC1000000135', 'CURRENT', '93500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (135, 68, 'ACC1000000136', 'SAVINGS', '24500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (136, 68, 'ACC1000000137', 'CURRENT', '49500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (137, 69, 'ACC1000000138', 'SAVINGS', '38500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (138, 69, 'ACC1000000139', 'CURRENT', '69500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (139, 70, 'ACC1000000140', 'SAVINGS', '42500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (140, 70, 'ACC1000000141', 'CURRENT', '80500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (141, 71, 'ACC1000000142', 'SAVINGS', '27500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (142, 71, 'ACC1000000143', 'CURRENT', '52500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (143, 72, 'ACC1000000144', 'SAVINGS', '34500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (144, 72, 'ACC1000000145', 'CURRENT', '73500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (145, 73, 'ACC1000000146', 'SAVINGS', '30500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (146, 73, 'ACC1000000147', 'CURRENT', '64500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (147, 74, 'ACC1000000148', 'SAVINGS', '25500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (148, 74, 'ACC1000000149', 'CURRENT', '58500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (149, 75, 'ACC1000000150', 'SAVINGS', '39500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (150, 75, 'ACC1000000151', 'CURRENT', '82500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (151, 76, 'ACC1000000152', 'SAVINGS', '23500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (152, 76, 'ACC1000000153', 'CURRENT', '50500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (153, 77, 'ACC1000000154', 'SAVINGS', '44500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (154, 77, 'ACC1000000155', 'CURRENT', '89500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (155, 78, 'ACC1000000156', 'SAVINGS', '28500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (156, 78, 'ACC1000000157', 'CURRENT', '55500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (157, 79, 'ACC1000000158', 'SAVINGS', '37500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (158, 79, 'ACC1000000159', 'CURRENT', '77500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (159, 80, 'ACC1000000160', 'SAVINGS', '33500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (160, 80, 'ACC1000000161', 'CURRENT', '72500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (161, 81, 'ACC1000000162', 'SAVINGS', '27000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (162, 81, 'ACC1000000163', 'CURRENT', '52000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (163, 82, 'ACC1000000164', 'SAVINGS', '37000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (164, 82, 'ACC1000000165', 'CURRENT', '77000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (165, 83, 'ACC1000000166', 'SAVINGS', '44000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (166, 83, 'ACC1000000167', 'CURRENT', '67000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (167, 84, 'ACC1000000168', 'SAVINGS', '30000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (168, 84, 'ACC1000000169', 'CURRENT', '84000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (169, 85, 'ACC1000000170', 'SAVINGS', '33000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (170, 85, 'ACC1000000171', 'CURRENT', '57000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (171, 86, 'ACC1000000172', 'SAVINGS', '21000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (172, 86, 'ACC1000000173', 'CURRENT', '47000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (173, 87, 'ACC1000000174', 'SAVINGS', '54000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (174, 87, 'ACC1000000175', 'CURRENT', '94000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (175, 88, 'ACC1000000176', 'SAVINGS', '25000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (176, 88, 'ACC1000000177', 'CURRENT', '50000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (177, 89, 'ACC1000000178', 'SAVINGS', '39000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (178, 89, 'ACC1000000179', 'CURRENT', '70000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (179, 90, 'ACC1000000180', 'SAVINGS', '43000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (180, 90, 'ACC1000000181', 'CURRENT', '81000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (181, 91, 'ACC1000000182', 'SAVINGS', '28000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (182, 91, 'ACC1000000183', 'CURRENT', '53000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (183, 92, 'ACC1000000184', 'SAVINGS', '35000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (184, 92, 'ACC1000000185', 'CURRENT', '74000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (185, 93, 'ACC1000000186', 'SAVINGS', '31000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (186, 93, 'ACC1000000187', 'CURRENT', '65000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (187, 94, 'ACC1000000188', 'SAVINGS', '26000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (188, 94, 'ACC1000000189', 'CURRENT', '59000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (189, 95, 'ACC1000000190', 'SAVINGS', '40000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (190, 95, 'ACC1000000191', 'CURRENT', '83000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (191, 96, 'ACC1000000192', 'SAVINGS', '24000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (192, 96, 'ACC1000000193', 'CURRENT', '51000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (193, 97, 'ACC1000000194', 'SAVINGS', '45000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (194, 97, 'ACC1000000195', 'CURRENT', '90000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (195, 98, 'ACC1000000196', 'SAVINGS', '29000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (196, 98, 'ACC1000000197', 'CURRENT', '56000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (197, 99, 'ACC1000000198', 'SAVINGS', '38000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (198, 99, 'ACC1000000199', 'CURRENT', '78000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (199, 100, 'ACC1000000200', 'SAVINGS', '34000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (200, 100, 'ACC1000000201', 'CURRENT', '73000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (201, 101, 'ACC1000000202', 'SAVINGS', '27500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (202, 101, 'ACC1000000203', 'CURRENT', '52500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (203, 102, 'ACC1000000204', 'SAVINGS', '37500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (204, 102, 'ACC1000000205', 'CURRENT', '77500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (205, 103, 'ACC1000000206', 'SAVINGS', '44500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (206, 103, 'ACC1000000207', 'CURRENT', '67500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (207, 104, 'ACC1000000208', 'SAVINGS', '30500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (208, 104, 'ACC1000000209', 'CURRENT', '84500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (209, 105, 'ACC1000000210', 'SAVINGS', '33500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (210, 105, 'ACC1000000211', 'CURRENT', '57500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (211, 106, 'ACC1000000212', 'SAVINGS', '21500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (212, 106, 'ACC1000000213', 'CURRENT', '47500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (213, 107, 'ACC1000000214', 'SAVINGS', '54500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (214, 107, 'ACC1000000215', 'CURRENT', '94500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (215, 108, 'ACC1000000216', 'SAVINGS', '25500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (216, 108, 'ACC1000000217', 'CURRENT', '50500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (217, 109, 'ACC1000000218', 'SAVINGS', '39500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (218, 109, 'ACC1000000219', 'CURRENT', '70500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (219, 110, 'ACC1000000220', 'SAVINGS', '43500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (220, 110, 'ACC1000000221', 'CURRENT', '81500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (221, 111, 'ACC1000000222', 'SAVINGS', '28500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (222, 111, 'ACC1000000223', 'CURRENT', '53500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (223, 112, 'ACC1000000224', 'SAVINGS', '35500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (224, 112, 'ACC1000000225', 'CURRENT', '74500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (225, 113, 'ACC1000000226', 'SAVINGS', '31500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (226, 113, 'ACC1000000227', 'CURRENT', '65500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (227, 114, 'ACC1000000228', 'SAVINGS', '26500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (228, 114, 'ACC1000000229', 'CURRENT', '59500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (229, 115, 'ACC1000000230', 'SAVINGS', '40500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (230, 115, 'ACC1000000231', 'CURRENT', '83500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (231, 116, 'ACC1000000232', 'SAVINGS', '24500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (232, 116, 'ACC1000000233', 'CURRENT', '51500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (233, 117, 'ACC1000000234', 'SAVINGS', '45500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (234, 117, 'ACC1000000235', 'CURRENT', '90500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (235, 118, 'ACC1000000236', 'SAVINGS', '29500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (236, 118, 'ACC1000000237', 'CURRENT', '56500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (237, 119, 'ACC1000000238', 'SAVINGS', '38500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (238, 119, 'ACC1000000239', 'CURRENT', '78500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (239, 120, 'ACC1000000240', 'SAVINGS', '34500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (240, 120, 'ACC1000000241', 'CURRENT', '73500.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (241, 121, 'ACC1000000242', 'SAVINGS', '28000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (242, 121, 'ACC1000000243', 'CURRENT', '53000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (243, 122, 'ACC1000000244', 'SAVINGS', '38000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (244, 122, 'ACC1000000245', 'CURRENT', '78000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (245, 123, 'ACC1000000246', 'SAVINGS', '45000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (246, 123, 'ACC1000000247', 'CURRENT', '68000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (247, 124, 'ACC1000000248', 'SAVINGS', '31000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (248, 124, 'ACC1000000249', 'CURRENT', '85000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (249, 125, 'ACC1000000250', 'SAVINGS', '34000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (250, 125, 'ACC1000000251', 'CURRENT', '58000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (251, 126, 'ACC1000000252', 'SAVINGS', '22000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (252, 126, 'ACC1000000253', 'CURRENT', '48000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (253, 127, 'ACC1000000254', 'SAVINGS', '55000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (254, 127, 'ACC1000000255', 'CURRENT', '95000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (255, 128, 'ACC1000000256', 'SAVINGS', '26000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (256, 128, 'ACC1000000257', 'CURRENT', '51000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (257, 129, 'ACC1000000258', 'SAVINGS', '40000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (258, 129, 'ACC1000000259', 'CURRENT', '71000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (259, 130, 'ACC1000000260', 'SAVINGS', '44000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (260, 130, 'ACC1000000261', 'CURRENT', '82000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (261, 131, 'ACC1000000262', 'SAVINGS', '29000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (262, 131, 'ACC1000000263', 'CURRENT', '54000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (263, 132, 'ACC1000000264', 'SAVINGS', '36000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (264, 132, 'ACC1000000265', 'CURRENT', '75000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (265, 133, 'ACC1000000266', 'SAVINGS', '32000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (266, 133, 'ACC1000000267', 'CURRENT', '66000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (267, 134, 'ACC1000000268', 'SAVINGS', '27000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (268, 134, 'ACC1000000269', 'CURRENT', '60000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (269, 135, 'ACC1000000270', 'SAVINGS', '41000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (270, 135, 'ACC1000000271', 'CURRENT', '84000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (271, 136, 'ACC1000000272', 'SAVINGS', '25000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (272, 136, 'ACC1000000273', 'CURRENT', '52000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (273, 137, 'ACC1000000274', 'SAVINGS', '46000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (274, 137, 'ACC1000000275', 'CURRENT', '91000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (275, 138, 'ACC1000000276', 'SAVINGS', '30000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (276, 138, 'ACC1000000277', 'CURRENT', '57000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (277, 139, 'ACC1000000278', 'SAVINGS', '39000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (278, 139, 'ACC1000000279', 'CURRENT', '79000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (279, 140, 'ACC1000000280', 'SAVINGS', '35000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (280, 140, 'ACC1000000281', 'CURRENT', '74000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (282, 141, 'ACC1000000283', 'SAVINGS', '15000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (283, 142, 'ACC1000000284', 'SAVINGS', '20000.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `accounts` (`account_id`, `customer_id`, `account_number`, `account_type`, `balance`, `status`, `updated_at`) VALUES (284, 143, 'ACC1000000285', 'CURRENT', '9876.00', 'ACTIVE', '2026-01-29 15:52:38');
INSERT INTO `branches` (`branch_id`, `branch_code`, `branch_name`, `city`, `state`) VALUES (1, 'BR001', 'Hyderabad – Madhapur', 'Hyderabad', 'Telangana');
INSERT INTO `branches` (`branch_id`, `branch_code`, `branch_name`, `city`, `state`) VALUES (2, 'BR002', 'Bangalore – Whitefield', 'Bangalore', 'Karnataka');
INSERT INTO `branches` (`branch_id`, `branch_code`, `branch_name`, `city`, `state`) VALUES (3, 'BR003', 'Chennai – T Nagar', 'Chennai', 'Tamil Nadu');
INSERT INTO `branches` (`branch_id`, `branch_code`, `branch_name`, `city`, `state`) VALUES (4, 'BR004', 'Mumbai – Andheri East', 'Mumbai', 'Maharashtra');
INSERT INTO `branches` (`branch_id`, `branch_code`, `branch_name`, `city`, `state`) VALUES (5, 'BR005', 'Delhi – Connaught Place', 'New Delhi', 'Delhi');
INSERT INTO `branches` (`branch_id`, `branch_code`, `branch_name`, `city`, `state`) VALUES (6, 'BR006', 'Pune – Hinjewadi', 'Pune', 'Maharashtra');
INSERT INTO `branches` (`branch_id`, `branch_code`, `branch_name`, `city`, `state`) VALUES (7, 'BR007', 'Kolkata – Salt Lake', 'Kolkata', 'West Bengal');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (1, 7, 'Suresh', 'Goud', 'suresh.goud@example.com', '9876543210');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (2, 8, 'Lakshmi', 'Reddy', 'lakshmi.reddy@example.com', '9876543211');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (3, 9, 'Kiran', 'Kumar', 'kiran.kumar@example.com', '9876543212');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (4, 10, 'Swathi', 'Naidu', 'swathi.naidu@example.com', '9876543213');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (5, 11, 'Venkat', 'Rao', 'venkat.rao@example.com', '9876543214');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (6, 12, 'Geeta', 'Sharma', 'geeta.sharma@example.com', '9876543215');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (7, 13, 'Rajesh', 'Yadav', 'rajesh.yadav@example.com', '9876543216');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (8, 14, 'Padmini', 'Nair', 'padmini.nair@example.com', '9876543217');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (9, 15, 'Mohan', 'Das', 'mohan.das@example.com', '9876543218');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (10, 16, 'Anuradha', 'Singh', 'anuradha.singh@example.com', '9876543219');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (11, 17, 'Sai', 'Ram', 'sai.ram@example.com', '9876543220');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (12, 18, 'Chitra', 'Iyer', 'chitra.iyer@example.com', '9876543221');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (13, 19, 'Praveen', 'Menon', 'praveen.menon@example.com', '9876543222');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (14, 20, 'Radhika', 'Gupta', 'radhika.gupta@example.com', '9876543223');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (15, 21, 'Harish', 'Chandra', 'harish.chandra@example.com', '9876543224');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (16, 22, 'Vasantha', 'Kumari', 'vasantha.kumari@example.com', '9876543225');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (17, 23, 'Nitin', 'Agarwal', 'nitin.agarwal@example.com', '9876543226');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (18, 24, 'Malini', 'Sen', 'malini.sen@example.com', '9876543227');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (19, 25, 'Deepak', 'Jain', 'deepak.jain@example.com', '9876543228');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (20, 26, 'Shobha', 'Verma', 'shobha.verma@example.com', '9876543229');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (21, 33, 'Aravind', 'Krishnan', 'aravind.krishnan@example.com', '9876543230');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (22, 34, 'Meenakshi', 'Sundaram', 'meenakshi.sundaram@example.com', '9876543231');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (23, 35, 'Ganesh', 'Kumar', 'ganesh.kumar@example.com', '9876543232');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (24, 36, 'Shalini', 'Ramesh', 'shalini.ramesh@example.com', '9876543233');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (25, 37, 'Prakash', 'Chandran', 'prakash.chandran@example.com', '9876543234');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (26, 38, 'Vidya', 'Venkat', 'vidya.venkat@example.com', '9876543235');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (27, 39, 'Ramesh', 'Babu', 'ramesh.babu@example.com', '9876543236');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (28, 40, 'Lavanya', 'Raghavan', 'lavanya.raghavan@example.com', '9876543237');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (29, 41, 'Sundar', 'Raman', 'sundar.raman@example.com', '9876543238');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (30, 42, 'Preeti', 'Shah', 'preeti.shah@example.com', '9876543239');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (31, 43, 'Manoj', 'Shetty', 'manoj.shetty@example.com', '9876543240');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (32, 44, 'Rekha', 'Pai', 'rekha.pai@example.com', '9876543241');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (33, 45, 'Srinivas', 'Murthy', 'srinivas.murthy@example.com', '9876543242');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (34, 46, 'Anitha', 'Deshmukh', 'anitha.deshmukh@example.com', '9876543243');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (35, 47, 'Vijay', 'Kulkarni', 'vijay.kulkarni@example.com', '9876543244');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (36, 48, 'Sunita', 'Bose', 'sunita.bose@example.com', '9876543245');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (37, 49, 'Ashwin', 'Narayan', 'ashwin.narayan@example.com', '9876543246');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (38, 50, 'Pooja', 'Mehta', 'pooja.mehta@example.com', '9876543247');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (39, 51, 'Girish', 'Joshi', 'girish.joshi@example.com', '9876543248');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (40, 52, 'Bhavana', 'Reddy', 'bhavana.reddy@example.com', '9876543249');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (41, 59, 'Rameshwar', 'Iyengar', 'rameshwar.iyengar@example.com', '9876543250');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (42, 60, 'Sarala', 'Srinivasan', 'sarala.srinivasan@example.com', '9876543251');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (43, 61, 'Balu', 'Naidu', 'balu.naidu@example.com', '9876543252');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (44, 62, 'Chandrika', 'Rao', 'chandrika.rao@example.com', '9876543253');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (45, 63, 'Murali', 'Venkatesh', 'murali.venkatesh@example.com', '9876543254');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (46, 64, 'Sita', 'Raman', 'sita.raman@example.com', '9876543255');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (47, 65, 'Nagarajan', 'Pillai', 'nagarajan.pillai@example.com', '9876543256');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (48, 66, 'Indira', 'Menon', 'indira.menon@example.com', '9876543257');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (49, 67, 'Subramanian', 'Gopal', 'subramanian.gopal@example.com', '9876543258');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (50, 68, 'Vasanthi', 'Kumar', 'vasanthi.kumar@example.com', '9876543259');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (51, 69, 'Rajendran', 'Chettiar', 'rajendran.chettiar@example.com', '9876543260');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (52, 70, 'Padma', 'Balan', 'padma.balan@example.com', '9876543261');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (53, 71, 'Ganapathy', 'Sundaram', 'ganapathy.sundaram@example.com', '9876543262');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (54, 72, 'Jaya', 'Lakshmi', 'jaya.lakshmi@example.com', '9876543263');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (55, 73, 'Krishnamurthy', 'Reddy', 'krishnamurthy.reddy@example.com', '9876543264');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (56, 74, 'Ambika', 'Viswanathan', 'ambika.viswanathan@example.com', '9876543265');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (57, 75, 'Thyagarajan', 'Nair', 'thyagarajan.nair@example.com', '9876543266');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (58, 76, 'Rekha', 'Chandrasekhar', 'rekha.chandrasekhar@example.com', '9876543267');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (59, 77, 'Shankar', 'Mohan', 'shankar.mohan@example.com', '9876543268');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (60, 78, 'Geetha', 'Raghu', 'geetha.raghu@example.com', '9876543269');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (61, 85, 'Amit', 'Verma', 'amit.verma@example.com', '9876543270');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (62, 86, 'Neeta', 'Shroff', 'neeta.shroff@example.com', '9876543271');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (63, 87, 'Vikas', 'Jain', 'vikas.jain@example.com', '9876543272');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (64, 88, 'Sanjana', 'Bhatia', 'sanjana.bhatia@example.com', '9876543273');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (65, 89, 'Rahul', 'Agarwal', 'rahul.agarwal@example.com', '9876543274');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (66, 90, 'Pooja', 'Malhotra', 'pooja.malhotra@example.com', '9876543275');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (67, 91, 'Manish', 'Tiwari', 'manish.tiwari@example.com', '9876543276');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (68, 92, 'Anushka', 'Saxena', 'anushka.saxena@example.com', '9876543277');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (69, 93, 'Siddharth', 'Oberoi', 'siddharth.oberoi@example.com', '9876543278');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (70, 94, 'Ritu', 'Bansal', 'ritu.bansal@example.com', '9876543279');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (71, 95, 'Harsh', 'Parmar', 'harsh.parmar@example.com', '9876543280');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (72, 96, 'Shreya', 'Khanna', 'shreya.khanna@example.com', '9876543281');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (73, 97, 'Akash', 'Thakkar', 'akash.thakkar@example.com', '9876543282');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (74, 98, 'Divya', 'Doshi', 'divya.doshi@example.com', '9876543283');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (75, 99, 'Varun', 'Naik', 'varun.naik@example.com', '9876543284');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (76, 100, 'Kavita', 'Reddy', 'kavita.reddy@example.com', '9876543285');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (77, 101, 'Sameer', 'Bhosale', 'sameer.bhosale@example.com', '9876543286');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (78, 102, 'Anita', 'Pawar', 'anita.pawar@example.com', '9876543287');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (79, 103, 'Rohan', 'Kamble', 'rohan.kamble@example.com', '9876543288');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (80, 104, 'Tanya', 'Mistry', 'tanya.mistry@example.com', '9876543289');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (81, 111, 'Nitin', 'Chauhan', 'nitin.chauhan@example.com', '9876543290');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (82, 112, 'Monika', 'Sharma', 'monika.sharma@example.com', '9876543291');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (83, 113, 'Pankaj', 'Singh', 'pankaj.singh@example.com', '9876543292');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (84, 114, 'Swati', 'Goel', 'swati.goel@example.com', '9876543293');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (85, 115, 'Alok', 'Bhardwaj', 'alok.bhardwaj@example.com', '9876543294');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (86, 116, 'Ritu', 'Bhargava', 'ritu.bhargava@example.com', '9876543295');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (87, 117, 'Sumit', 'Tomar', 'sumit.tomar@example.com', '9876543296');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (88, 118, 'Nidhi', 'Rastogi', 'nidhi.rastogi@example.com', '9876543297');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (89, 119, 'Ankit', 'Mittal', 'ankit.mittal@example.com', '9876543298');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (90, 120, 'Preeti', 'Dua', 'preeti.dua@example.com', '9876543299');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (91, 121, 'Ravi', 'Yadav', 'ravi.yadav@example.com', '9876543300');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (92, 122, 'Sonali', 'Sarin', 'sonali.sarin@example.com', '9876543301');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (93, 123, 'Deepak', 'Rawat', 'deepak.rawat@example.com', '9876543302');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (94, 124, 'Anamika', 'Verma', 'anamika.verma@example.com', '9876543303');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (95, 125, 'Sanjeev', 'Kumar', 'sanjeev.kumar@example.com', '9876543304');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (96, 126, 'Kiran', 'Bedi', 'kiran.bedi@example.com', '9876543305');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (97, 127, 'Vishal', 'Agarwal', 'vishal.agarwal@example.com', '9876543306');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (98, 128, 'Pallavi', 'Singhal', 'pallavi.singhal@example.com', '9876543307');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (99, 129, 'Gaurav', 'Nagpal', 'gaurav.nagpal@example.com', '9876543308');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (100, 130, 'Shweta', 'Sethi', 'shweta.sethi@example.com', '9876543309');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (101, 137, 'Abhijit', 'Bhide', 'abhijit.bhide@example.com', '9876543310');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (102, 138, 'Varsha', 'Thalte', 'varsha.thalte@example.com', '9876543311');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (103, 139, 'Prasad', 'Chavan', 'prasad.chavan@example.com', '9876543312');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (104, 140, 'Ashwini', 'Sawant', 'ashwini.sawant@example.com', '9876543313');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (105, 141, 'Rajendra', 'Salunkhe', 'rajendra.salunkhe@example.com', '9876543314');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (106, 142, 'Smita', 'Kadam', 'smita.kadam@example.com', '9876543315');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (107, 143, 'Vikram', 'Mhatre', 'vikram.mhatre@example.com', '9876543316');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (108, 144, 'Anagha', 'Paranjape', 'anagha.paranjape@example.com', '9876543317');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (109, 145, 'Sachin', 'Bhosale', 'sachin.bhosale@example.com', '9876543318');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (110, 146, 'Pooja', 'Rane', 'pooja.rane@example.com', '9876543319');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (111, 147, 'Nitin', 'Wagh', 'nitin.wagh@example.com', '9876543320');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (112, 148, 'Meera', 'Kale', 'meera.kale@example.com', '9876543321');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (113, 149, 'Dinesh', 'Jadhav', 'dinesh.jadhav@example.com', '9876543322');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (114, 150, 'Shubhangi', 'Moghe', 'shubhangi.moghe@example.com', '9876543323');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (115, 151, 'Pradeep', 'Nalawade', 'pradeep.nalawade@example.com', '9876543324');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (116, 152, 'Ananya', 'Pendse', 'ananya.pendse@example.com', '9876543325');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (117, 153, 'Rakesh', 'Thorat', 'rakesh.thorat@example.com', '9876543326');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (118, 154, 'Tejashree', 'Barve', 'tejashree.barve@example.com', '9876543327');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (119, 155, 'Sandeep', 'Ghatge', 'sandeep.ghatge@example.com', '9876543328');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (120, 156, 'Deepali', 'Kirtane', 'deepali.kirtane@example.com', '9876543329');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (121, 163, 'Arnab', 'Chatterjee', 'arnab.chatterjee@example.com', '9876543330');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (122, 164, 'Mousumi', 'Banerjee', 'mousumi.banerjee@example.com', '9876543331');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (123, 165, 'Pranab', 'Roy', 'pranab.roy@example.com', '9876543332');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (124, 166, 'Sharmistha', 'Mitra', 'sharmistha.mitra@example.com', '9876543333');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (125, 167, 'Santanu', 'Sen', 'santanu.sen@example.com', '9876543334');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (126, 168, 'Bhaswati', 'Dutta', 'bhaswati.dutta@example.com', '9876543335');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (127, 169, 'Subir', 'Sarkar', 'subir.sarkar@example.com', '9876543336');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (128, 170, 'Tumpa', 'Majumdar', 'tumpa.majumdar@example.com', '9876543337');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (129, 171, 'Amitava', 'Chakraborty', 'amitava.chakraborty@example.com', '9876543338');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (130, 172, 'Mou', 'Das', 'mou.das@example.com', '9876543339');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (131, 173, 'Sudipto', 'Bhattacharya', 'sudipto.bhattacharya@example.com', '9876543340');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (132, 174, 'Poulomi', 'Bose', 'poulomi.bose@example.com', '9876543341');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (133, 175, 'Ranjan', 'Kundu', 'ranjan.kundu@example.com', '9876543342');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (134, 176, 'Shraboni', 'Halder', 'shraboni.halder@example.com', '9876543343');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (135, 177, 'Abhirup', 'Pal', 'abhirup.pal@example.com', '9876543344');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (136, 178, 'Jayashree', 'Mallick', 'jayashree.mallick@example.com', '9876543345');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (137, 179, 'Somnath', 'Mondal', 'somnath.mondal@example.com', '9876543346');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (138, 180, 'Paromita', 'Bhowmick', 'paromita.bhowmick@example.com', '9876543347');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (139, 181, 'Bikash', 'Debnath', 'bikash.debnath@example.com', '9876543348');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (140, 182, 'Sreeparna', 'Guha', 'sreeparna.guha@example.com', '9876543349');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (141, 183, 'Ravi', 'Kumar', 'ravi.kumar@gmail.com', '9876543210');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (142, 185, 'jaswanth', 'kumar', 'jaswanth@demo.com', '08434036840');
INSERT INTO `customers` (`customer_id`, `user_id`, `first_name`, `last_name`, `email`, `phone`) VALUES (143, 186, 'manoj', 'kumar', 'manoj@demo.com', '9393244482');
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (1, 1, 'Branch Manager', '2018-04-10', 'Arjun', 'Reddy', 'arjun.reddy@bank.com', '9876543201', 'MALE', 'Plot No. 123, Madhapur, Hyderabad', '85000.00', NULL);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (2, 2, 'Senior Teller', '2020-07-15', 'Priya', 'Sharma', 'priya.sharma@bank.com', '9876543202', 'FEMALE', 'H.No. 456, Jubilee Hills, Hyderabad', '45000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (3, 3, 'Loan Officer', '2019-12-01', 'Vikram', 'Singh', 'vikram.singh@bank.com', '9876543203', 'MALE', 'Flat 301, Banjara Hills, Hyderabad', '55000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (4, 4, 'Customer Service Rep', '2021-03-10', 'Ananya', 'Patel', 'ananya.patel@bank.com', '9876543204', 'FEMALE', 'Sector 5, Hitech City, Hyderabad', '40000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (5, 5, 'Financial Advisor', '2020-09-22', 'Rakesh', 'Kumar', 'rakesh.kumar@bank.com', '9876543205', 'MALE', 'Road No. 12, Banjara Hills, Hyderabad', '60000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (6, 6, 'Operations Specialist', '2022-01-20', 'Meera', 'Desai', 'meera.desai@bank.com', '9876543206', 'FEMALE', 'Kondapur, Hyderabad', '42000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (7, 27, 'Branch Manager', '2019-02-18', 'Rajesh', 'Nair', 'rajesh_nair_mgr@bank.com', '9876543213', 'MALE', 'Whitefield, Bangalore - Employee ID: 7', '88000.00', NULL);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (8, 28, 'Senior Teller', '2021-05-12', 'Anjali', 'Menon', 'anjali_menon@bank.com', '9876543214', 'FEMALE', 'Whitefield, Bangalore - Employee ID: 8', '46000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (9, 29, 'Loan Officer', '2020-10-08', 'Sandeep', 'Iyer', 'sandeep_iyer@bank.com', '9876543215', 'MALE', 'Whitefield, Bangalore - Employee ID: 9', '56000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (10, 30, 'Customer Service Rep', '2022-01-25', 'Divya', 'Rao', 'divya_rao@bank.com', '9876543216', 'FEMALE', 'Whitefield, Bangalore - Employee ID: 10', '41000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (11, 31, 'Financial Advisor', '2021-07-14', 'Karthik', 'Pillai', 'karthik_pillai@bank.com', '9876543217', 'MALE', 'Whitefield, Bangalore - Employee ID: 11', '62000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (12, 32, 'Operations Specialist', '2023-03-03', 'Neha', 'Bhat', 'neha_bhat@bank.com', '9876543218', 'FEMALE', 'Whitefield, Bangalore - Employee ID: 12', '43000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (13, 53, 'Branch Manager', '2017-11-05', 'Sundar', 'Iyer', 'sundar_iyer_mgr@bank.com', '9876543225', 'MALE', 'T Nagar, Chennai - Employee ID: 13', '82000.00', NULL);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (14, 54, 'Senior Teller', '2020-03-22', 'Lakshmi', 'Rajan', 'lakshmi_rajan@bank.com', '9876543226', 'FEMALE', 'T Nagar, Chennai - Employee ID: 14', '44000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (15, 55, 'Loan Officer', '2019-08-17', 'Venkatesh', 'Pillai', 'venkatesh_pillai@bank.com', '9876543227', 'MALE', 'T Nagar, Chennai - Employee ID: 15', '54000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (16, 56, 'Customer Service Rep', '2021-11-30', 'Malini', 'Subramanian', 'malini_subramanian@bank.com', '9876543228', 'FEMALE', 'T Nagar, Chennai - Employee ID: 16', '39000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (17, 57, 'Financial Advisor', '2020-12-05', 'Gopal', 'Raman', 'gopal_raman@bank.com', '9876543229', 'MALE', 'T Nagar, Chennai - Employee ID: 17', '59000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (18, 58, 'Operations Specialist', '2022-06-18', 'Usha', 'Krishnan', 'usha_krishnan@bank.com', '9876543230', 'FEMALE', 'T Nagar, Chennai - Employee ID: 18', '41000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (19, 79, 'Branch Manager', '2018-09-22', 'Rohit', 'Shah', 'rohit_shah_mgr@bank.com', '9876543237', 'MALE', 'Andheri East, Mumbai - Employee ID: 19', '92000.00', NULL);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (20, 80, 'Senior Teller', '2020-11-08', 'Aisha', 'Kapoor', 'aisha_kapoor@bank.com', '9876543238', 'FEMALE', 'Andheri East, Mumbai - Employee ID: 20', '48000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (21, 81, 'Loan Officer', '2021-04-15', 'Samir', 'Desai', 'samir_desai@bank.com', '9876543239', 'MALE', 'Andheri East, Mumbai - Employee ID: 21', '58000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (22, 82, 'Customer Service Rep', '2022-02-28', 'Tanvi', 'Mehta', 'tanvi_mehta@bank.com', '9876543240', 'FEMALE', 'Andheri East, Mumbai - Employee ID: 22', '43000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (23, 83, 'Financial Advisor', '2020-08-03', 'Rajiv', 'Chopra', 'rajiv_chopra@bank.com', '9876543241', 'MALE', 'Andheri East, Mumbai - Employee ID: 23', '65000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (24, 84, 'Operations Specialist', '2023-01-12', 'Priyanka', 'Singhania', 'priyanka_singhania@bank.com', '9876543242', 'FEMALE', 'Andheri East, Mumbai - Employee ID: 24', '45000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (25, 105, 'Branch Manager', '2019-06-14', 'Vivek', 'Saxena', 'vivek_saxena_mgr@bank.com', '9876543249', 'MALE', 'Connaught Place, Delhi - Employee ID: 25', '90000.00', NULL);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (26, 106, 'Senior Teller', '2021-08-25', 'Anisha', 'Gupta', 'anisha_gupta@bank.com', '9876543250', 'FEMALE', 'Connaught Place, Delhi - Employee ID: 26', '47000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (27, 107, 'Loan Officer', '2020-12-10', 'Arun', 'Malik', 'arun_malik@bank.com', '9876543251', 'MALE', 'Connaught Place, Delhi - Employee ID: 27', '57000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (28, 108, 'Customer Service Rep', '2022-04-05', 'Shikha', 'Arora', 'shikha_arora@bank.com', '9876543252', 'FEMALE', 'Connaught Place, Delhi - Employee ID: 28', '42000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (29, 109, 'Financial Advisor', '2021-02-18', 'Rohit', 'Kapoor', 'rohit_kapoor@bank.com', '9876543253', 'MALE', 'Connaught Place, Delhi - Employee ID: 29', '63000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (30, 110, 'Operations Specialist', '2023-03-22', 'Megha', 'Tyagi', 'megha_tyagi@bank.com', '9876543254', 'FEMALE', 'Connaught Place, Delhi - Employee ID: 30', '44000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (31, 131, 'Branch Manager', '2020-01-20', 'Sanjay', 'Patil', 'sanjay_patil_mgr@bank.com', '9876543261', 'MALE', 'Hinjewadi, Pune - Employee ID: 31', '83000.00', NULL);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (32, 132, 'Senior Teller', '2022-03-11', 'Snehal', 'Joshi', 'snehal_joshi@bank.com', '9876543262', 'FEMALE', 'Hinjewadi, Pune - Employee ID: 32', '43000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (33, 133, 'Loan Officer', '2021-07-29', 'Amol', 'Kulkarni', 'amol_kulkarni@bank.com', '9876543263', 'MALE', 'Hinjewadi, Pune - Employee ID: 33', '53000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (34, 134, 'Customer Service Rep', '2023-01-15', 'Rashmi', 'Deshpande', 'rashmi_deshpande@bank.com', '9876543264', 'FEMALE', 'Hinjewadi, Pune - Employee ID: 34', '38000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (35, 135, 'Financial Advisor', '2021-11-03', 'Prasad', 'More', 'prasad_more@bank.com', '9876543265', 'MALE', 'Hinjewadi, Pune - Employee ID: 35', '58000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (36, 136, 'Operations Specialist', '2023-05-08', 'Supriya', 'Gaikwad', 'supriya_gaikwad@bank.com', '9876543266', 'FEMALE', 'Hinjewadi, Pune - Employee ID: 36', '40000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (37, 157, 'Branch Manager', '2018-12-08', 'Soumitra', 'Bose', 'soumitra_bose_mgr@bank.com', '9876543273', 'MALE', 'Salt Lake, Kolkata - Employee ID: 37', '82000.00', NULL);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (38, 158, 'Senior Teller', '2021-04-25', 'Indrani', 'Ganguly', 'indrani_ganguly@bank.com', '9876543274', 'FEMALE', 'Salt Lake, Kolkata - Employee ID: 38', '42000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (39, 159, 'Loan Officer', '2020-09-12', 'Debashis', 'Mukherjee', 'debashis_mukherjee@bank.com', '9876543275', 'MALE', 'Salt Lake, Kolkata - Employee ID: 39', '52000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (40, 160, 'Customer Service Rep', '2022-07-18', 'Moumita', 'Ghosh', 'moumita_ghosh@bank.com', '9876543276', 'FEMALE', 'Salt Lake, Kolkata - Employee ID: 40', '37000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (41, 161, 'Financial Advisor', '2021-01-30', 'Subhro', 'Dasgupta', 'subhro_dasgupta@bank.com', '9876543277', 'MALE', 'Salt Lake, Kolkata - Employee ID: 41', '57000.00', 1);
INSERT INTO `employees` (`employee_id`, `user_id`, `designation`, `joined_date`, `first_name`, `last_name`, `email`, `phone`, `gender`, `address`, `salary`, `manager_id`) VALUES (42, 162, 'Operations Specialist', '2023-02-14', 'Rinku', 'Saha', 'rinku_saha@bank.com', '9876543278', 'FEMALE', 'Salt Lake, Kolkata - Employee ID: 42', '39000.00', 1);
INSERT INTO `roles` (`role_id`, `role_name`) VALUES (1, 'CUSTOMER');
INSERT INTO `roles` (`role_id`, `role_name`) VALUES (2, 'EMPLOYEE');
INSERT INTO `roles` (`role_id`, `role_name`) VALUES (3, 'MANAGER');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (1, 1, 'CREDIT', '50000.00', 'Salary Deposit', '2024-01-15 09:30:00', NULL, 'TXN000001', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (2, 1, 'DEBIT', '15000.00', 'Home Loan EMI', '2024-01-18 14:20:00', NULL, 'TXN000002', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (3, 1, 'DEBIT', '5000.00', 'Online Shopping - Amazon', '2024-01-20 19:45:00', NULL, 'TXN000003', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (4, 1, 'CREDIT', '2500.00', 'Interest Credit', '2024-01-31 23:59:59', NULL, 'TXN000004', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (5, 2, 'CREDIT', '200000.00', 'Business Receipts', '2024-01-05 11:15:00', NULL, 'TXN000005', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (6, 2, 'DEBIT', '75000.00', 'Supplier Payment', '2024-01-10 10:30:00', NULL, 'TXN000006', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (7, 2, 'DEBIT', '25000.00', 'Office Rent', '2024-01-25 12:00:00', NULL, 'TXN000007', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (8, 2, 'CREDIT', '50000.00', 'Client Advance', '2024-01-28 15:45:00', NULL, 'TXN000008', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (9, 3, 'CREDIT', '45000.00', 'Salary Credit', '2024-01-25 09:00:00', NULL, 'TXN000009', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (10, 3, 'DEBIT', '10000.00', 'Mutual Fund SIP', '2024-01-26 10:00:00', NULL, 'TXN000010', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (11, 3, 'DEBIT', '8000.00', 'Credit Card Payment', '2024-01-27 11:30:00', NULL, 'TXN000011', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (12, 5, 'CREDIT', '42000.00', 'Monthly Salary', '2024-01-28 08:45:00', NULL, 'TXN000012', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (13, 5, 'DEBIT', '12000.00', 'School Fees', '2024-01-29 09:30:00', NULL, 'TXN000013', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (14, 5, 'DEBIT', '5000.00', 'Electricity Bill', '2024-01-30 14:20:00', NULL, 'TXN000014', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (15, 7, 'CREDIT', '28000.00', 'Freelance Payment', '2024-01-20 16:30:00', NULL, 'TXN000015', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (16, 7, 'DEBIT', '7000.00', 'Insurance Premium', '2024-01-22 11:15:00', NULL, 'TXN000016', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (17, 9, 'CREDIT', '31000.00', 'Consulting Fee', '2024-01-18 13:45:00', NULL, 'TXN000017', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (18, 9, 'DEBIT', '11000.00', 'Car Loan EMI', '2024-01-19 09:30:00', NULL, 'TXN000018', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (19, 11, 'CREDIT', '19000.00', 'Pension Credit', '2024-01-05 10:00:00', NULL, 'TXN000019', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (20, 11, 'DEBIT', '4000.00', 'Medical Expense', '2024-01-10 14:30:00', NULL, 'TXN000020', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (21, 13, 'CREDIT', '52000.00', 'Salary Deposit', '2024-01-27 09:15:00', NULL, 'TXN000021', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (22, 13, 'DEBIT', '15000.00', 'Home Renovation', '2024-01-29 16:45:00', NULL, 'TXN000022', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (23, 15, 'CREDIT', '23000.00', 'Business Income', '2024-01-15 12:30:00', NULL, 'TXN000023', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (24, 15, 'DEBIT', '8000.00', 'Property Tax', '2024-01-18 10:15:00', NULL, 'TXN000024', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (25, 17, 'CREDIT', '37000.00', 'Contract Payment', '2024-01-22 15:20:00', NULL, 'TXN000025', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (26, 17, 'DEBIT', '12000.00', 'Personal Loan EMI', '2024-01-25 11:30:00', NULL, 'TXN000026', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (27, 41, 'CREDIT', '55000.00', 'Salary Deposit', '2024-01-26 09:00:00', NULL, 'TXN000027', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (28, 41, 'DEBIT', '20000.00', 'Home Loan EMI', '2024-01-28 10:30:00', NULL, 'TXN000028', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (29, 41, 'DEBIT', '8000.00', 'Online Courses', '2024-01-30 19:15:00', NULL, 'TXN000029', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (30, 43, 'CREDIT', '48000.00', 'Monthly Salary', '2024-01-25 08:45:00', NULL, 'TXN000030', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (31, 43, 'DEBIT', '15000.00', 'Mutual Fund Investment', '2024-01-27 10:00:00', NULL, 'TXN000031', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (32, 45, 'CREDIT', '42500.00', 'Project Payment', '2024-01-20 14:30:00', NULL, 'TXN000032', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (33, 45, 'DEBIT', '12500.00', 'Car Maintenance', '2024-01-22 16:45:00', NULL, 'TXN000033', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (34, 47, 'CREDIT', '38500.00', 'Freelance Work', '2024-01-18 13:20:00', NULL, 'TXN000034', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (35, 47, 'DEBIT', '8500.00', 'Shopping', '2024-01-20 18:30:00', NULL, 'TXN000035', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (36, 49, 'CREDIT', '31500.00', 'Consulting Fee', '2024-01-15 11:45:00', NULL, 'TXN000036', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (37, 49, 'DEBIT', '11500.00', 'Travel Expense', '2024-01-17 09:30:00', NULL, 'TXN000037', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (38, 81, 'CREDIT', '56000.00', 'Salary Credit', '2024-01-27 09:15:00', NULL, 'TXN000038', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (39, 81, 'DEBIT', '21000.00', 'Home Loan EMI', '2024-01-29 10:45:00', NULL, 'TXN000039', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (40, 83, 'CREDIT', '46000.00', 'Monthly Income', '2024-01-24 08:30:00', NULL, 'TXN000040', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (41, 83, 'DEBIT', '16000.00', 'Insurance Payment', '2024-01-26 11:20:00', NULL, 'TXN000041', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (42, 85, 'CREDIT', '43000.00', 'Contract Payment', '2024-01-21 14:15:00', NULL, 'TXN000042', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (43, 85, 'DEBIT', '13000.00', 'Education Fee', '2024-01-23 15:30:00', NULL, 'TXN000043', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (44, 87, 'CREDIT', '49000.00', 'Business Receipt', '2024-01-19 12:45:00', NULL, 'TXN000044', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (45, 87, 'DEBIT', '9000.00', 'Utility Bills', '2024-01-21 17:20:00', NULL, 'TXN000045', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (46, 89, 'CREDIT', '52000.00', 'Salary Deposit', '2024-01-16 10:30:00', NULL, 'TXN000046', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (47, 89, 'DEBIT', '12000.00', 'Car EMI', '2024-01-18 09:45:00', NULL, 'TXN000047', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (48, 121, 'CREDIT', '56500.00', 'Salary Credit', '2024-01-28 09:00:00', NULL, 'TXN000048', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (49, 121, 'DEBIT', '21500.00', 'Home Loan', '2024-01-30 10:30:00', NULL, 'TXN000049', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (50, 123, 'CREDIT', '46500.00', 'Monthly Salary', '2024-01-25 08:45:00', NULL, 'TXN000050', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (51, 123, 'DEBIT', '16500.00', 'Investment', '2024-01-27 11:15:00', NULL, 'TXN000051', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (52, 125, 'CREDIT', '43500.00', 'Project Fee', '2024-01-22 14:30:00', NULL, 'TXN000052', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (53, 125, 'DEBIT', '13500.00', 'Medical Bill', '2024-01-24 16:45:00', NULL, 'TXN000053', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (54, 127, 'CREDIT', '49500.00', 'Business Income', '2024-01-20 12:15:00', NULL, 'TXN000054', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (55, 127, 'DEBIT', '9500.00', 'Shopping', '2024-01-22 18:30:00', NULL, 'TXN000055', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (56, 129, 'CREDIT', '52500.00', 'Salary', '2024-01-17 10:45:00', NULL, 'TXN000056', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (57, 129, 'DEBIT', '12500.00', 'Loan EMI', '2024-01-19 09:30:00', NULL, 'TXN000057', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (58, 161, 'CREDIT', '57000.00', 'Salary Deposit', '2024-01-29 09:15:00', NULL, 'TXN000058', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (59, 161, 'DEBIT', '22000.00', 'Home EMI', '2024-01-31 10:45:00', NULL, 'TXN000059', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (60, 163, 'CREDIT', '47000.00', 'Monthly Income', '2024-01-26 08:30:00', NULL, 'TXN000060', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (61, 163, 'DEBIT', '17000.00', 'Insurance Premium', '2024-01-28 11:20:00', NULL, 'TXN000061', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (62, 165, 'CREDIT', '44000.00', 'Contract Payment', '2024-01-23 14:15:00', NULL, 'TXN000062', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (63, 165, 'DEBIT', '14000.00', 'Education Fee', '2024-01-25 15:30:00', NULL, 'TXN000063', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (64, 167, 'CREDIT', '50000.00', 'Business Receipt', '2024-01-21 12:45:00', NULL, 'TXN000064', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (65, 167, 'DEBIT', '10000.00', 'Utility Payment', '2024-01-23 17:20:00', NULL, 'TXN000065', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (66, 169, 'CREDIT', '53000.00', 'Salary Credit', '2024-01-18 10:30:00', NULL, 'TXN000066', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (67, 169, 'DEBIT', '13000.00', 'Car Loan EMI', '2024-01-20 09:45:00', NULL, 'TXN000067', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (68, 201, 'CREDIT', '57500.00', 'Salary', '2024-01-30 09:00:00', NULL, 'TXN000068', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (69, 201, 'DEBIT', '22500.00', 'Home Loan', '2024-02-01 10:30:00', NULL, 'TXN000069', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (70, 203, 'CREDIT', '47500.00', 'Monthly Salary', '2024-01-27 08:45:00', NULL, 'TXN000070', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (71, 203, 'DEBIT', '17500.00', 'Investment', '2024-01-29 11:15:00', NULL, 'TXN000071', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (72, 205, 'CREDIT', '44500.00', 'Project Payment', '2024-01-24 14:30:00', NULL, 'TXN000072', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (73, 205, 'DEBIT', '14500.00', 'Medical Expense', '2024-01-26 16:45:00', NULL, 'TXN000073', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (74, 207, 'CREDIT', '50500.00', 'Business Income', '2024-01-22 12:15:00', NULL, 'TXN000074', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (75, 207, 'DEBIT', '10500.00', 'Shopping', '2024-01-24 18:30:00', NULL, 'TXN000075', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (76, 209, 'CREDIT', '53500.00', 'Salary Deposit', '2024-01-19 10:45:00', NULL, 'TXN000076', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (77, 209, 'DEBIT', '13500.00', 'Loan EMI', '2024-01-21 09:30:00', NULL, 'TXN000077', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (78, 241, 'CREDIT', '58000.00', 'Salary Credit', '2024-01-31 09:15:00', NULL, 'TXN000078', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (79, 241, 'DEBIT', '23000.00', 'Home EMI', '2024-02-02 10:45:00', NULL, 'TXN000079', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (80, 243, 'CREDIT', '48000.00', 'Monthly Income', '2024-01-28 08:30:00', NULL, 'TXN000080', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (81, 243, 'DEBIT', '18000.00', 'Insurance Payment', '2024-01-30 11:20:00', NULL, 'TXN000081', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (82, 245, 'CREDIT', '45000.00', 'Contract Fee', '2024-01-25 14:15:00', NULL, 'TXN000082', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (83, 245, 'DEBIT', '15000.00', 'Education', '2024-01-27 15:30:00', NULL, 'TXN000083', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (84, 247, 'CREDIT', '51000.00', 'Business Receipt', '2024-01-23 12:45:00', NULL, 'TXN000084', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (85, 247, 'DEBIT', '11000.00', 'Bills Payment', '2024-01-25 17:20:00', NULL, 'TXN000085', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (86, 249, 'CREDIT', '54000.00', 'Salary', '2024-01-20 10:30:00', NULL, 'TXN000086', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (87, 249, 'DEBIT', '14000.00', 'Car EMI', '2024-01-22 09:45:00', NULL, 'TXN000087', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (88, 1, 'DEBIT', '10000.00', 'NEFT to Aravind Krishnan', '2024-01-22 11:30:00', 41, 'TXN000088', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (89, 41, 'CREDIT', '10000.00', 'NEFT from Suresh Goud', '2024-01-22 11:35:00', 41, 'TXN000089', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (90, 81, 'DEBIT', '5000.00', 'IMPS to Amit Verma', '2024-01-19 14:45:00', 121, 'TXN000090', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (91, 121, 'CREDIT', '5000.00', 'IMPS from Rameshwar Iyengar', '2024-01-19 14:48:00', 121, 'TXN000091', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (92, 161, 'DEBIT', '25000.00', 'RTGS to Abhijit Bhide', '2024-01-25 10:15:00', 201, 'TXN000092', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (93, 201, 'CREDIT', '25000.00', 'RTGS from Nitin Chauhan', '2024-01-25 10:18:00', 201, 'TXN000093', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (94, 241, 'DEBIT', '8000.00', 'UPI to Lakshmi Reddy', '2024-01-28 16:20:00', 3, 'TXN000094', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (95, 3, 'CREDIT', '8000.00', 'UPI from Arnab Chatterjee', '2024-01-28 16:22:00', 3, 'TXN000095', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (96, 5, 'DEBIT', '3000.00', 'Transfer to Swathi Naidu', '2024-01-21 13:15:00', 7, 'TXN000096', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (97, 7, 'CREDIT', '3000.00', 'Transfer from Kiran Kumar', '2024-01-21 13:16:00', 7, 'TXN000097', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (98, 1, 'DEBIT', '649.00', 'Netflix Monthly Subscription', '2024-01-05 02:00:00', NULL, 'TXN000098', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (99, 41, 'DEBIT', '649.00', 'Netflix Monthly Subscription', '2024-01-05 02:00:00', NULL, 'TXN000099', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (100, 81, 'DEBIT', '649.00', 'Netflix Monthly Subscription', '2024-01-05 02:00:00', NULL, 'TXN000100', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (101, 3, 'DEBIT', '299.00', 'Amazon Prime Monthly', '2024-01-10 03:00:00', NULL, 'TXN000101', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (102, 43, 'DEBIT', '299.00', 'Amazon Prime Monthly', '2024-01-10 03:00:00', NULL, 'TXN000102', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (103, 83, 'DEBIT', '299.00', 'Amazon Prime Monthly', '2024-01-10 03:00:00', NULL, 'TXN000103', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (104, 5, 'DEBIT', '119.00', 'Spotify Premium', '2024-01-15 04:00:00', NULL, 'TXN000104', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (105, 45, 'DEBIT', '119.00', 'Spotify Premium', '2024-01-15 04:00:00', NULL, 'TXN000105', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (106, 85, 'DEBIT', '119.00', 'Spotify Premium', '2024-01-15 04:00:00', NULL, 'TXN000106', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (107, 7, 'DEBIT', '1500.00', 'Gym Monthly Fee', '2024-01-20 09:00:00', NULL, 'TXN000107', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (108, 47, 'DEBIT', '1500.00', 'Gym Monthly Fee', '2024-01-20 09:00:00', NULL, 'TXN000108', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (109, 87, 'DEBIT', '1500.00', 'Gym Monthly Fee', '2024-01-20 09:00:00', NULL, 'TXN000109', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (110, 9, 'DEBIT', '300.00', 'Newspaper Monthly', '2024-01-25 06:00:00', NULL, 'TXN000110', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (111, 49, 'DEBIT', '300.00', 'Newspaper Monthly', '2024-01-25 06:00:00', NULL, 'TXN000111', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (112, 89, 'DEBIT', '300.00', 'Newspaper Monthly', '2024-01-25 06:00:00', NULL, 'TXN000112', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (113, NULL, 'CREDIT', '5000.00', 'Test deposit', '2026-01-29 16:20:54', 1, 'CR1769683854673', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (114, 1, 'DEBIT', '2000.00', 'Test withdrawal', '2026-01-29 16:20:58', NULL, 'DB1769683858845', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (115, 1, 'DEBIT', '1000.00', 'Transfer: Test transfer', '2026-01-29 16:21:01', NULL, 'TF1769683861207-D', 'SUCCESS');
INSERT INTO `transactions` (`transaction_id`, `from_account_id`, `transaction_type`, `amount`, `description`, `created_at`, `to_account_id`, `reference_number`, `status`) VALUES (116, NULL, 'CREDIT', '1000.00', 'Received: Test transfer', '2026-01-29 16:21:01', 2, 'TF1769683861207-C', 'SUCCESS');
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (1, 'arjun.reddy.mgr.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 3, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (2, 'priya.sharma.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (3, 'vikram.singh.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (4, 'ananya.patel.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (5, 'rakesh.kumar.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (6, 'meera.desai.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (7, 'suresh.goud.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (8, 'lakshmi.reddy.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (9, 'kiran.kumar.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (10, 'swathi.naidu.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (11, 'venkat.rao.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (12, 'geeta.sharma.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (13, 'rajesh.yadav.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (14, 'padmini.nair.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (15, 'mohan.das.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (16, 'anuradha.singh.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (17, 'sai.ram.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (18, 'chitra.iyer.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (19, 'praveen.menon.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (20, 'radhika.gupta.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (21, 'harish.chandra.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (22, 'vasantha.kumari.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (23, 'nitin.agarwal.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (24, 'malini.sen.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (25, 'deepak.jain.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (26, 'shobha.verma.b1', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (27, 'rajesh.nair.mgr.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 3, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (28, 'anjali.menon.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (29, 'sandeep.iyer.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (30, 'divya.rao.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (31, 'karthik.pillai.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (32, 'neha.bhat.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (33, 'aravind.krishnan.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (34, 'meenakshi.sundaram.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (35, 'ganesh.kumar.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (36, 'shalini.ramesh.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (37, 'prakash.chandran.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (38, 'vidya.venkat.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (39, 'ramesh.babu.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (40, 'lavanya.raghavan.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (41, 'sundar.raman.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (42, 'preeti.shah.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (43, 'manoj.shetty.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (44, 'rekha.pai.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (45, 'srinivas.murthy.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (46, 'anitha.deshmukh.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (47, 'vijay.kulkarni.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (48, 'sunita.bose.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (49, 'ashwin.narayan.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (50, 'pooja.mehta.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (51, 'girish.joshi.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (52, 'bhavana.reddy.b2', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 2, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (53, 'sundar.iyer.mgr.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 3, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (54, 'lakshmi.rajan.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (55, 'venkatesh.pillai.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (56, 'malini.subramanian.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (57, 'gopal.raman.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (58, 'usha.krishnan.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (59, 'rameshwar.iyengar.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (60, 'sarala.srinivasan.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (61, 'balu.naidu.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (62, 'chandrika.rao.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (63, 'murali.venkatesh.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (64, 'sita.raman.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (65, 'nagarajan.pillai.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (66, 'indira.menon.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (67, 'subramanian.gopal.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (68, 'vasanthi.kumar.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (69, 'rajendran.chettiar.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (70, 'padma.balan.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (71, 'ganapathy.sundaram.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (72, 'jaya.lakshmi.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (73, 'krishnamurthy.reddy.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (74, 'ambika.viswanathan.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (75, 'thyagarajan.nair.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (76, 'rekha.chandrasekhar.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (77, 'shankar.mohan.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (78, 'geetha.raghu.b3', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 3, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (79, 'rohit.shah.mgr.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 3, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (80, 'aisha.kapoor.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (81, 'samir.desai.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (82, 'tanvi.mehta.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (83, 'rajiv.chopra.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (84, 'priyanka.singhania.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (85, 'amit.verma.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (86, 'neeta.shroff.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (87, 'vikas.jain.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (88, 'sanjana.bhatia.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (89, 'rahul.agarwal.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (90, 'pooja.malhotra.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (91, 'manish.tiwari.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (92, 'anushka.saxena.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (93, 'siddharth.oberoi.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (94, 'ritu.bansal.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (95, 'harsh.parmar.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (96, 'shreya.khanna.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (97, 'akash.thakkar.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (98, 'divya.doshi.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (99, 'varun.naik.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (100, 'kavita.reddy.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (101, 'sameer.bhosale.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (102, 'anita.pawar.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (103, 'rohan.kamble.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (104, 'tanya.mistry.b4', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 4, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (105, 'vivek.saxena.mgr.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 3, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (106, 'anisha.gupta.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (107, 'arun.malik.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (108, 'shikha.arora.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (109, 'rohit.kapoor.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (110, 'megha.tyagi.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (111, 'nitin.chauhan.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (112, 'monika.sharma.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (113, 'pankaj.singh.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (114, 'swati.goel.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (115, 'alok.bhardwaj.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (116, 'ritu.bhargava.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (117, 'sumit.tomar.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (118, 'nidhi.rastogi.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (119, 'ankit.mittal.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (120, 'preeti.dua.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (121, 'ravi.yadav.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (122, 'sonali.sarin.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (123, 'deepak.rawat.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (124, 'anamika.verma.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (125, 'sanjeev.kumar.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (126, 'kiran.bedi.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (127, 'vishal.agarwal.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (128, 'pallavi.singhal.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (129, 'gaurav.nagpal.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (130, 'shweta.sethi.b5', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 5, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (131, 'sanjay.patil.mgr.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 3, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (132, 'snehal.joshi.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (133, 'amol.kulkarni.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (134, 'rashmi.deshpande.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (135, 'prasad.more.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (136, 'supriya.gaikwad.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (137, 'abhijit.bhide.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (138, 'varsha.thalte.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (139, 'prasad.chavan.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (140, 'ashwini.sawant.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (141, 'rajendra.salunkhe.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (142, 'smita.kadam.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (143, 'vikram.mhatre.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (144, 'anagha.paranjape.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (145, 'sachin.bhosale.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (146, 'pooja.rane.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (147, 'nitin.wagh.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (148, 'meera.kale.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (149, 'dinesh.jadhav.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (150, 'shubhangi.moghe.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (151, 'pradeep.nalawade.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (152, 'ananya.pendse.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (153, 'rakesh.thorat.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (154, 'tejashree.barve.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (155, 'sandeep.ghatge.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (156, 'deepali.kirtane.b6', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 6, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (157, 'soumitra.bose.mgr.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 3, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (158, 'indrani.ganguly.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (159, 'debashis.mukherjee.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (160, 'moumita.ghosh.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (161, 'subhro.dasgupta.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (162, 'rinku.saha.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 2, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (163, 'arnab.chatterjee.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (164, 'mousumi.banerjee.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (165, 'pranab.roy.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (166, 'sharmistha.mitra.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (167, 'santanu.sen.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (168, 'bhaswati.dutta.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (169, 'subir.sarkar.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (170, 'tumpa.majumdar.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (171, 'amitava.chakraborty.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (172, 'mou.das.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (173, 'sudipto.bhattacharya.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (174, 'poulomi.bose.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (175, 'ranjan.kundu.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (176, 'shraboni.halder.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (177, 'abhirup.pal.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (178, 'jayashree.mallick.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (179, 'somnath.mondal.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (180, 'paromita.bhowmick.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (181, 'bikash.debnath.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (182, 'sreeparna.guha.b7', '$2a$10$fq20XAlWJjomR3u0tc06LuvjHWG7AiElEs7rugIUfpquGtszxXzeK', 1, 7, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (183, 'ravi.kumar', '$2b$10$HWAipsKdvPBjE82HhJnqu.x6IPAOxKDoomaFVFQ4/mnb7gLnDBPhu', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (185, 'jaswanth.uppu', '$2b$10$hhnXAJ0TuzsTIEyRbV92.u/TeMJJ61rD0hLradcxhOfnsDfv/QXLG', 1, 1, 1);
INSERT INTO `users` (`user_id`, `username`, `password_hash`, `role_id`, `branch_id`, `is_active`) VALUES (186, 'manoj', '$2b$10$NbJbgdYsTdgSZorYZFTZZu8V/gLv8N1pCGw/1Qo5aj3NXGgSilj26', 1, 1, 1);
ALTER TABLE `accounts` ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `customers` ADD CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `employees` ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `employees` ADD CONSTRAINT `fk_employee_manager` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`employee_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `transactions` ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`from_account_id`) REFERENCES `accounts` (`account_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `users` ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `users` ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;-- ============================================
-- SIMPLE STORED PROCEDURES (USING YOUR EXISTING CREDIT/DEBIT)
-- ============================================

DELIMITER $$

-- Procedure: ADD MONEY (CREDIT)
CREATE PROCEDURE add_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(12,2),
    IN p_description VARCHAR(100)
)
BEGIN
    DECLARE v_ref VARCHAR(50);
    
    SET v_ref = CONCAT('CR', UNIX_TIMESTAMP(), FLOOR(RAND() * 1000));
    
    START TRANSACTION;
    
    INSERT INTO transactions (
        from_account_id,
        to_account_id,
        amount,
        transaction_type,
        description,
        reference_number,
        status,
        created_at
    ) VALUES (
        NULL,
        p_account_id,
        p_amount,
        'CREDIT',
        p_description,
        v_ref,
        'SUCCESS',
        CURRENT_TIMESTAMP
    );
    
    UPDATE accounts
    SET balance = balance + p_amount,
        updated_at = CURRENT_TIMESTAMP
    WHERE account_id = p_account_id;
    
    COMMIT;
    
    SELECT 'SUCCESS' as status, v_ref as reference_number;
END$$

-- Procedure: REMOVE MONEY (DEBIT)
CREATE PROCEDURE remove_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(12,2),
    IN p_description VARCHAR(100)
)
BEGIN
    DECLARE v_balance DECIMAL(12,2);
    DECLARE v_ref VARCHAR(50);
    
    -- Check balance
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = p_account_id
    FOR UPDATE;
    
    IF v_balance < p_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance';
    END IF;
    
    SET v_ref = CONCAT('DB', UNIX_TIMESTAMP(), FLOOR(RAND() * 1000));
    
    START TRANSACTION;
    
    INSERT INTO transactions (
        from_account_id,
        to_account_id,
        amount,
        transaction_type,
        description,
        reference_number,
        status,
        created_at
    ) VALUES (
        p_account_id,
        NULL,
        p_amount,
        'DEBIT',
        p_description,
        v_ref,
        'SUCCESS',
        CURRENT_TIMESTAMP
    );
    
    UPDATE accounts
    SET balance = balance - p_amount,
        updated_at = CURRENT_TIMESTAMP
    WHERE account_id = p_account_id;
    
    COMMIT;
    
    SELECT 'SUCCESS' as status, v_ref as reference_number;
END$$

-- Procedure: TRANSFER MONEY
CREATE PROCEDURE transfer_money(
    IN p_from_account_id INT,
    IN p_to_account_id INT,
    IN p_amount DECIMAL(12,2),
    IN p_description VARCHAR(100)
)
BEGIN
    DECLARE v_balance DECIMAL(12,2);
    DECLARE v_ref VARCHAR(50);
    
    -- Check sender balance
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = p_from_account_id
    FOR UPDATE;
    
    IF v_balance < p_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance';
    END IF;
    
    IF p_from_account_id = p_to_account_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot transfer to same account';
    END IF;
    
    SET v_ref = CONCAT('TF', UNIX_TIMESTAMP(), FLOOR(RAND() * 1000));
    
    START TRANSACTION;
    
    -- Debit from sender
    INSERT INTO transactions (
        from_account_id,
        to_account_id,
        amount,
        transaction_type,
        description,
        reference_number,
        status,
        created_at
    ) VALUES (
        p_from_account_id,
        NULL,
        p_amount,
        'DEBIT',
        CONCAT('Transfer: ', p_description),
        CONCAT(v_ref, '-D'),
        'SUCCESS',
        CURRENT_TIMESTAMP
    );
    
    -- Credit to receiver
    INSERT INTO transactions (
        from_account_id,
        to_account_id,
        amount,
        transaction_type,
        description,
        reference_number,
        status,
        created_at
    ) VALUES (
        NULL,
        p_to_account_id,
        p_amount,
        'CREDIT',
        CONCAT('Received: ', p_description),
        CONCAT(v_ref, '-C'),
        'SUCCESS',
        CURRENT_TIMESTAMP
    );
    
    -- Update balances
    UPDATE accounts
    SET balance = balance - p_amount,
        updated_at = CURRENT_TIMESTAMP
    WHERE account_id = p_from_account_id;
    
    UPDATE accounts
    SET balance = balance + p_amount,
        updated_at = CURRENT_TIMESTAMP
    WHERE account_id = p_to_account_id;
    
    COMMIT;
    
    SELECT 'SUCCESS' as status, v_ref as reference_number;
END$$

DELIMITER ;





CREATE TABLE `loan_requests` ( 
  `loan_id` INT AUTO_INCREMENT NOT NULL,
  `customer_id` INT NOT NULL,
  `branch_id` INT NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `tenure_months` INT NOT NULL,
  `purpose` VARCHAR(255) NULL,
  `status` ENUM('REQUESTED','EMPLOYEE_APPROVED','EMPLOYEE_REJECTED','MANAGER_APPROVED','MANAGER_REJECTED') NOT NULL DEFAULT 'REQUESTED' ,
  `employee_id` INT NULL,
  `manager_id` INT NULL,
  `employee_comment` TEXT NULL,
  `manager_comment` TEXT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
   PRIMARY KEY (`loan_id`),
   KEY `idx_loan_customer_branch` (`customer_id`,`branch_id`),
   KEY `idx_loan_status` (`status`),
   KEY `idx_loan_employee` (`employee_id`),
   KEY `idx_loan_manager` (`manager_id`),
   CONSTRAINT `fk_loan_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`),
   CONSTRAINT `fk_loan_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`branch_id`),
   CONSTRAINT `fk_loan_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`),
   CONSTRAINT `fk_loan_manager` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`employee_id`)
)
ENGINE = InnoDB;

CREATE TABLE `loan_status_history` ( 
  `history_id` BIGINT AUTO_INCREMENT NOT NULL,
  `loan_id` INT NOT NULL,
  `changed_by_user_id` INT NULL,
  `changed_by_role` ENUM('CUSTOMER','EMPLOYEE','MANAGER','SYSTEM') NOT NULL DEFAULT 'SYSTEM' ,
  `from_status` ENUM('REQUESTED','EMPLOYEE_APPROVED','EMPLOYEE_REJECTED','MANAGER_APPROVED','MANAGER_REJECTED') NULL,
  `to_status` ENUM('REQUESTED','EMPLOYEE_APPROVED','EMPLOYEE_REJECTED','MANAGER_APPROVED','MANAGER_REJECTED') NOT NULL,
  `comment` TEXT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ,
   PRIMARY KEY (`history_id`),
   KEY `idx_history_loan` (`loan_id`),
   CONSTRAINT `fk_history_loan` FOREIGN KEY (`loan_id`) REFERENCES `loan_requests` (`loan_id`) ON DELETE CASCADE,
   CONSTRAINT `fk_history_user` FOREIGN KEY (`changed_by_user_id`) REFERENCES `users` (`user_id`)
)
ENGINE = InnoDB;

DELIMITER $$

CREATE TRIGGER `loan_requests_status_guard`
BEFORE UPDATE ON `loan_requests`
FOR EACH ROW
BEGIN
  IF NEW.status <> OLD.status THEN
    IF OLD.status = 'REQUESTED' THEN
      IF NEW.status NOT IN ('EMPLOYEE_APPROVED','EMPLOYEE_REJECTED') THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Invalid transition from REQUESTED';
      END IF;
    ELSEIF OLD.status = 'EMPLOYEE_APPROVED' THEN
      IF NEW.status NOT IN ('MANAGER_APPROVED','MANAGER_REJECTED') THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Invalid transition from EMPLOYEE_APPROVED';
      END IF;
    ELSE
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loan request is already finalized';
    END IF;

    IF NEW.status IN ('EMPLOYEE_APPROVED','EMPLOYEE_REJECTED') AND NEW.employee_id IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'employee_id is required when an employee acts on a loan';
    END IF;

    IF NEW.status IN ('MANAGER_APPROVED','MANAGER_REJECTED') AND NEW.manager_id IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'manager_id is required when a manager acts on a loan';
    END IF;
  END IF;
END$$

CREATE TRIGGER `loan_requests_after_insert_history`
AFTER INSERT ON `loan_requests`
FOR EACH ROW
BEGIN
  DECLARE v_user_id INT;
  SET v_user_id = (SELECT c.user_id FROM customers c WHERE c.customer_id = NEW.customer_id);

  INSERT INTO loan_status_history (
    loan_id, changed_by_user_id, changed_by_role, from_status, to_status, comment, created_at
  ) VALUES (
    NEW.loan_id, v_user_id, 'CUSTOMER', NULL, NEW.status, NULL, CURRENT_TIMESTAMP
  );
END$$

CREATE TRIGGER `loan_requests_after_update_history`
AFTER UPDATE ON `loan_requests`
FOR EACH ROW
BEGIN
  DECLARE v_user_id INT;
  DECLARE v_role VARCHAR(10);
  DECLARE v_comment TEXT;

  IF NEW.status <> OLD.status THEN
    IF NEW.status IN ('EMPLOYEE_APPROVED','EMPLOYEE_REJECTED') THEN
      SET v_user_id = (SELECT e.user_id FROM employees e WHERE e.employee_id = NEW.employee_id);
      SET v_role = 'EMPLOYEE';
      SET v_comment = NEW.employee_comment;
    ELSEIF NEW.status IN ('MANAGER_APPROVED','MANAGER_REJECTED') THEN
      SET v_user_id = (SELECT e.user_id FROM employees e WHERE e.employee_id = NEW.manager_id);
      SET v_role = 'MANAGER';
      SET v_comment = NEW.manager_comment;
    ELSE
      SET v_user_id = (SELECT c.user_id FROM customers c WHERE c.customer_id = NEW.customer_id);
      SET v_role = 'CUSTOMER';
      SET v_comment = NULL;
    END IF;

    INSERT INTO loan_status_history (
      loan_id, changed_by_user_id, changed_by_role, from_status, to_status, comment, created_at
    ) VALUES (
      NEW.loan_id, v_user_id, v_role, OLD.status, NEW.status, v_comment, CURRENT_TIMESTAMP
    );
  END IF;
END$$

DELIMITER ;
