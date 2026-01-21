CREATE DATABASE school_auth
    DEFAULT CHARACTER SET = 'utf8mb4';

    
USE school_auth;

CREATE TABLE users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL,
      role ENUM('student', 'teacher') NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

INSERT INTO users (name, email, password, role)
VALUES ('Ravi Kumar', 'ravi@student.com', 'hashed_password', 'student');

INSERT INTO users (name, email, password, role)
    VALUES ('Anita Sharma', 'anita@teacher.com', 'hashed_password', 'teacher');

SELECT id, name, email, role FROM users;  

-- delete from users where name = "jaswanth";