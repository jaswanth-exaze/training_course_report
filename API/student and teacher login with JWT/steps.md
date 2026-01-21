---

# STEP 1: DATABASE & TABLE SETUP (STUDENT–TEACHER LOGIN PROJECT)

---

## 1. Create Database

First, create a new database for the project.

    ```sql
    CREATE DATABASE school_auth;
    ```

Use the database:

    ```sql
    USE school_auth;
    ```

---

## 2. Create Users Table

We will use **one single table** for both students and teachers.
Role will decide access.

Table name: users

    ```sql
    CREATE TABLE users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL,
      role ENUM('student', 'teacher') NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    ```

---

## 3. Why This Table Design?

- Single table → simple design
- role column → role-based authentication
- password stored as hash (bcrypt later)
- email unique → prevents duplicate accounts

---

## 4. Insert Sample Data (For Testing)

Student record:

    ```sql
    INSERT INTO users (name, email, password, role)
    VALUES ('Ravi Kumar', 'ravi@student.com', 'hashed_password', 'student');
    ```

Teacher record:

    ```sql
    INSERT INTO users (name, email, password, role)
    VALUES ('Anita Sharma', 'anita@teacher.com', 'hashed_password', 'teacher');
    ```

(Note: Password will be hashed later using bcrypt in API)

---

## 5. Verify Data

Check all users:

    ```sql
    SELECT id, name, email, role FROM users;
    ```

Expected output:
- One student
- One teacher

---

## 6. What You Have Completed in STEP 1

- Database created
- Users table created
- Role-based structure ready
- Backend authentication foundation prepared

---

END OF STEP 1
---

# STEP 2: NODE.JS + EXPRESS SETUP (STUDENT–TEACHER LOGIN PROJECT)

---

## 1. Initialize Node Project

Open your project folder in terminal and run:

    ```bash
    npm init -y
    ```

This creates:
- package.json

---

## 2. Install Required Packages

Install core dependencies:

    ```bash
    npm install express mysql2 cors jsonwebtoken bcrypt
    ```

Optional (for auto-restart):

    ```bash
    npm install nodemon --save-dev
    ```

---

## 3. Project Folder Structure (After Setup)

    project/
    ├── app.js
    ├── db.js
    ├── routes/
    ├── middleware/
    └── package.json

---

## 4. Create MySQL Connection (db.js)

Create a file named **db.js**

    ```javascript
    const mysql = require("mysql2");

    const db = mysql.createConnection({
      host: "localhost",
      user: "root",
      password: "your_mysql_password",
      database: "school_auth"
    });

    db.connect((err) => {
      if (err) {
        console.log("Database connection failed:", err);
      } else {
        console.log("MySQL connected successfully");
      }
    });

    module.exports = db;
    ```

Purpose of db.js:
- Central database connection
- Reusable in all routes

---

## 5. Create Express Server (app.js)

Create a file named **app.js**

    ```javascript
    const express = require("express");
    const cors = require("cors");

    const app = express();

    app.use(cors());
    app.use(express.json());

    const PORT = 3000;

    app.get("/", (req, res) => {
      res.send("Student–Teacher Auth API Running");
    });

    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
    ```

What this does:
- Starts Express server
- Enables JSON body parsing
- Enables CORS
- Creates test route

---

## 6. Run the Server

Using node:

    ```bash
    node app.js
    ```

Or using nodemon (recommended):

    ```bash
    npx nodemon app.js
    ```

---

## 7. Test Server

Open browser or Thunder Client:

URL:
http://localhost:3000/

Expected output:
Student–Teacher Auth API Running

---

## 8. What You Completed in STEP 2

- Node project initialized
- Express server running
- MySQL connected
- JSON body handling enabled
- Backend foundation ready

---

END OF STEP 2
---

# STEP 3: REGISTER API (STUDENT / TEACHER)

---

## Goal of This Step

Create an API that:
- Registers student or teacher
- Hashes password using bcrypt
- Stores user in MySQL
- Prevents duplicate email registration

Endpoint:
POST /register

---

## 1. Create Routes Folder & File

Create folder:
routes/

Create file:
routes/authRoutes.js

---

## 2. Register API Logic (authRoutes.js)

    ```javascript
    const express = require("express");
    const bcrypt = require("bcrypt");
    const db = require("../db");

    const router = express.Router();

    router.post("/register", async (req, res) => {
      const { name, email, password, role } = req.body;

      // Basic validation
      if (!name || !email || !password || !role) {
        return res.status(400).json({
          message: "All fields are required"
        });
      }

      // Allow only student or teacher
      if (role !== "student" && role !== "teacher") {
        return res.status(400).json({
          message: "Invalid role"
        });
      }

      // Check if user already exists
      const checkQuery = "SELECT * FROM users WHERE email = ?";

      db.query(checkQuery, [email], async (err, result) => {
        if (err) {
          return res.status(500).json({ message: "Database error" });
        }

        if (result.length > 0) {
          return res.status(400).json({
            message: "User already exists"
          });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Insert user
        const insertQuery =
          "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";

        db.query(
          insertQuery,
          [name, email, hashedPassword, role],
          (err) => {
            if (err) {
              return res.status(500).json({
                message: "Failed to register user"
              });
            }

            res.status(201).json({
              message: "User registered successfully"
            });
          }
        );
      });
    });

    module.exports = router;
    ```

---

## 3. Connect Auth Routes to app.js

Open app.js and add:

    ```javascript
    const authRoutes = require("./routes/authRoutes");

    app.use("/", authRoutes);
    ```

Now `/register` API is active.

---

## 4. Test Register API (Thunder Client)

Method:
POST

URL:
http://localhost:3000/register

Request Body:

    ```json
    {
      "name": "Ravi Kumar",
      "email": "ravi@student.com",
      "password": "123456",
      "role": "student"
    }
    ```

---

## 5. Expected Response

    ```json
    {
      "message": "User registered successfully"
    }
    ```

---

## 6. Verify Database Entry

Run SQL:

    ```sql
    SELECT id, name, email, role FROM users;
    ```

You should see the newly registered user.

---

## 7. What You Learned in STEP 3

- Password hashing using bcrypt
- Register API creation
- Role validation
- Duplicate user prevention
- MySQL insert via API

---

END OF STEP 3
---

# STEP 4: LOGIN API + JWT TOKEN (STUDENT / TEACHER)

---

## Goal of This Step

Create a Login API that:
- Verifies user email
- Compares hashed password using bcrypt
- Generates JWT token on successful login
- Returns token to client

Endpoint:
POST /login

---

## 1. Login Flow (Very Important)

1. User sends email and password
2. Backend finds user by email
3. bcrypt compares plain password with hashed password
4. If valid → JWT token is generated
5. Token is sent in response

---

## 2. Update authRoutes.js (Add Login API)

Open:
routes/authRoutes.js

Add this **below the register API**:

    ```javascript
    const jwt = require("jsonwebtoken");

    router.post("/login", (req, res) => {
      const { email, password } = req.body;

      // Basic validation
      if (!email || !password) {
        return res.status(400).json({
          message: "Email and password are required"
        });
      }

      // Check if user exists
      const sql = "SELECT * FROM users WHERE email = ?";

      db.query(sql, [email], async (err, result) => {
        if (err) {
          return res.status(500).json({
            message: "Database error"
          });
        }

        if (result.length === 0) {
          return res.status(401).json({
            message: "Invalid email or password"
          });
        }

        const user = result[0];

        // Compare password
        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
          return res.status(401).json({
            message: "Invalid email or password"
          });
        }

        // Generate JWT token
        const token = jwt.sign(
          {
            id: user.id,
            role: user.role
          },
          "secretKey",
          { expiresIn: "1h" }
        );

        res.json({
          message: "Login successful",
          token: token
        });
      });
    });
    ```

---

## 3. Test Login API (Thunder Client)

Method:
POST

URL:
http://localhost:3000/login

Request Body:

    ```json
    {
      "email": "ravi@student.com",
      "password": "123456"
    }
    ```

---

## 4. Expected Response

    ```json
    {
      "message": "Login successful",
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
    ```

Copy this token — it will be used in next steps.

---

## 5. JWT Token Meaning (Simple)

The token contains:
- user id
- user role
- expiry time

Token is **proof that user is logged in**.

---

## 6. Common Errors & Fixes

❌ Invalid email or password  
✔️ Check email exists  
✔️ Check correct password  

❌ Token not generated  
✔️ Check `jsonwebtoken` installed  
✔️ Check secret key string  

---

## 7. What You Learned in STEP 4

- How login works internally
- Password comparison using bcrypt
- JWT token creation
- Authentication foundation completed

---

END OF STEP 4
---

# STEP 5: JWT AUTH MIDDLEWARE (PROTECT APIs)

---

## Goal of This Step

Create JWT middleware that:
- Reads token from request headers
- Verifies JWT token
- Attaches logged-in user data to request
- Blocks unauthorized access

This middleware will be reused across protected routes.

---

## 1. JWT Middleware Flow

Request
→ Authorization Header
→ JWT Middleware
→ Token Verification
→ Route Access (if valid)
→ Response

If token is invalid:
→ 401 Unauthorized

---

## 2. Create Middleware Folder & File

Create folder:
middleware/

Create file:
middleware/authMiddleware.js

---

## 3. JWT Middleware Code (authMiddleware.js)

    ```javascript
    const jwt = require("jsonwebtoken");

    const authMiddleware = (req, res, next) => {
      const authHeader = req.headers.authorization;

      // Check if header exists
      if (!authHeader) {
        return res.status(401).json({
          message: "Authorization header missing"
        });
      }

      // Format: Bearer token
      const token = authHeader.split(" ")[1];

      if (!token) {
        return res.status(401).json({
          message: "Token missing"
        });
      }

      try {
        const decoded = jwt.verify(token, "secretKey");

        // Attach user info to request
        req.user = decoded;

        next(); // IMPORTANT: move to route
      } catch (error) {
        return res.status(401).json({
          message: "Invalid or expired token"
        });
      }
    };

    module.exports = authMiddleware;
    ```

---

## 4. Protect a Route Using JWT Middleware

Add a test protected route in app.js or routes file.

Example in app.js:

    ```javascript
    const authMiddleware = require("./middleware/authMiddleware");

    app.get("/protected", authMiddleware, (req, res) => {
      res.json({
        message: "Protected route accessed",
        user: req.user
      });
    });
    ```

---

## 5. Test Protected Route (Thunder Client)

Method:
GET

URL:
http://localhost:3000/protected

Headers:

    ```json
    {
      "Authorization": "Bearer YOUR_JWT_TOKEN_HERE"
    }
    ```

---

## 6. Expected Responses

### ✅ With Valid Token

    ```json
    {
      "message": "Protected route accessed",
      "user": {
        "id": 1,
        "role": "student",
        "iat": 1700000000,
        "exp": 1700003600
      }
    }
    ```

### ❌ Without Token

    ```json
    {
      "message": "Authorization header missing"
    }
    ```

---

## 7. Why `next()` Is CRITICAL

- `next()` allows request to continue to route
- Without `next()` → request hangs forever
- Middleware chain stops

---

## 8. What You Learned in STEP 5

- How JWT middleware works internally
- How tokens are verified
- How to protect routes
- How user info is attached to req.user
- Real authentication security pattern

---

END OF STEP 5
---

# STEP 6: ROLE-BASED AUTHORIZATION (STUDENT / TEACHER)

---

## Goal of This Step

Allow access based on user role:
- Students → student APIs only
- Teachers → teacher APIs only
- Wrong role → access denied (403)

This is **authorization**, not authentication.

---

## 1. Authorization vs Authentication

Authentication:
- Who you are
- Done using JWT

Authorization:
- What you are allowed to access
- Done using role checks

---

## 2. Role Authorization Middleware

Create a middleware that checks user role.

Create file:
middleware/roleMiddleware.js

---

## 3. Role Middleware Code

    ```javascript
    const roleMiddleware = (allowedRole) => {
      return (req, res, next) => {
        if (!req.user || req.user.role !== allowedRole) {
          return res.status(403).json({
            message: "Access denied"
          });
        }
        next();
      };
    };

    module.exports = roleMiddleware;
    ```

---

## 4. Student Route (Student Only)

Create file:
routes/studentRoutes.js

    ```javascript
    const express = require("express");
    const authMiddleware = require("../middleware/authMiddleware");
    const roleMiddleware = require("../middleware/roleMiddleware");

    const router = express.Router();

    router.get(
      "/student/dashboard",
      authMiddleware,
      roleMiddleware("student"),
      (req, res) => {
        res.json({
          message: "Welcome Student",
          userId: req.user.id
        });
      }
    );

    module.exports = router;
    ```

---

## 5. Teacher Route (Teacher Only)

Create file:
routes/teacherRoutes.js

    ```javascript
    const express = require("express");
    const authMiddleware = require("../middleware/authMiddleware");
    const roleMiddleware = require("../middleware/roleMiddleware");

    const router = express.Router();

    router.get(
      "/teacher/dashboard",
      authMiddleware,
      roleMiddleware("teacher"),
      (req, res) => {
        res.json({
          message: "Welcome Teacher",
          userId: req.user.id
        });
      }
    );

    module.exports = router;
    ```

---

## 6. Connect Routes in app.js

Open app.js and add:

    ```javascript
    const studentRoutes = require("./routes/studentRoutes");
    const teacherRoutes = require("./routes/teacherRoutes");

    app.use("/", studentRoutes);
    app.use("/", teacherRoutes);
    ```

---

## 7. Test Role-Based Access

### Student Token

GET:
http://localhost:3000/student/dashboard

Header:

    ```json
    {
      "Authorization": "Bearer STUDENT_TOKEN"
    }
    ```

✅ Works

---

### Student Accessing Teacher API

GET:
http://localhost:3000/teacher/dashboard

Response:

    ```json
    {
      "message": "Access denied"
    }
    ```

---

### Teacher Token

GET:
http://localhost:3000/teacher/dashboard

Header:

    ```json
    {
      "Authorization": "Bearer TEACHER_TOKEN"
    }
    ```

✅ Works

---

## 8. HTTP Status Codes Used

401 → Not authenticated  
403 → Authenticated but not authorized  

---

## 9. What You Have Achieved in STEP 6

- Role-based authorization
- Separate student & teacher access
- Secure API design
- Real-world backend pattern

---

END OF STEP 6

frontend/
├── index.html        (Login)
├── register.html     (Register)
├── dashboard.html
├── css/
│   └── style.css
├── js/
│   ├── login.js
│   ├── register.js
│   └── dashboard.js
