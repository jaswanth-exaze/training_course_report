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



# STUDENT–TEACHER LOGIN PROJECT  
## File-by-File Purpose & Explanation

---

# BACKEND FILES

---

## app.js

Purpose:  
This is the main entry point of the backend application.

Explanation:  
- It creates and configures the Express server.  
- It applies global middleware like JSON parsing and CORS.  
- It connects all route files and starts listening for requests.

---

## db.js

Purpose:  
Handles the MySQL database connection.

Explanation:  
- It creates a single reusable database connection.  
- All route files use this connection to interact with the database.  
- Centralizing DB logic avoids duplication and connection issues.

---

## routes/authRoutes.js

Purpose:  
Manages authentication-related APIs.

Explanation:  
- It contains Register and Login APIs.  
- It hashes passwords and verifies credentials.  
- It generates JWT tokens after successful login.

---

## routes/studentRoutes.js

Purpose:  
Handles APIs meant only for students.

Explanation:  
- It defines student-specific endpoints like student dashboard.  
- It ensures the user is authenticated using auth middleware.  
- It restricts access only to users with student role.

---

## routes/teacherRoutes.js

Purpose:  
Handles APIs meant only for teachers.

Explanation:  
- It defines teacher-specific endpoints like teacher dashboard.  
- It verifies the user’s identity using JWT middleware.  
- It blocks access for users without teacher role.

---

## middleware/authMiddleware.js

Purpose:  
Handles authentication using JWT.

Explanation:  
- It checks for the presence of JWT token in request headers.  
- It verifies the token’s validity and expiry.  
- It attaches decoded user data to req.user.

---

## middleware/roleMiddleware.js

Purpose:  
Handles authorization based on user role.

Explanation:  
- It checks whether the authenticated user has required role.  
- It compares req.user.role with allowed role for the route.  
- It blocks unauthorized access with HTTP 403 error.

---

## package.json

Purpose:  
Manages project dependencies and metadata.

Explanation:  
- It lists required packages like express, bcrypt, jsonwebtoken.  
- It ensures consistent dependency installation.  
- It defines scripts to run the project.

---

# FRONTEND FILES

---

## index.html (Login Page)

Purpose:  
Provides login interface for users.

Explanation:  
- It collects user email and password.  
- It connects with login.js for authentication.  
- It serves as the entry point for the application.

---

## register.html (Register Page)

Purpose:  
Allows users to create a new account.

Explanation:  
- It collects name, email, password, and role.  
- It sends data to backend register API.  
- It redirects users to login page after successful registration.

---

## dashboard.html

Purpose:  
Acts as a common dashboard for both roles.

Explanation:  
- It displays content based on user role.  
- It does not control security logic.  
- Backend middleware decides actual access rights.

---

## js/login.js

Purpose:  
Handles frontend login logic.

Explanation:  
- It sends login credentials to backend.  
- It stores JWT token in localStorage.  
- It redirects users based on role.

---

## js/register.js

Purpose:  
Handles frontend registration logic.

Explanation:  
- It validates user input.  
- It calls backend register API.  
- It shows success or error messages to user.

---

## js/dashboard.js

Purpose:  
Handles protected frontend behavior.

Explanation:  
- It retrieves JWT token from localStorage.  
- It sends token to backend in Authorization header.  
- It fetches role-based data and handles logout.

---

## css/style.css

Purpose:  
Defines the visual styling of the frontend.

Explanation:  
- It provides consistent and clean UI design.  
- It separates presentation from logic.  
- It improves user experience without affecting backend.

---

# FINAL INTERVIEW SUMMARY

Routes organize backend logic by responsibility.  
Middleware enforces authentication and authorization.  
Frontend files handle user interaction and API communication.  
Each file follows single responsibility principle, making the system secure, maintainable, and scalable.

---

END OF NOTES




# STUDENT–TEACHER LOGIN PROJECT  
## COMPLETE FLOW: CLICKS, REDIRECTIONS & INTERNAL WORKING

---

## OVERALL FLOW OVERVIEW

Frontend (HTML / JS)
→ Backend API (Express)
→ Middleware (JWT + Role)
→ Database (MySQL)
→ Response
→ Frontend UI Update or Redirection

This flow repeats for every user action.

---

# 1️⃣ USER OPENS APPLICATION

### Action
User opens:
index.html

### What happens
- Browser loads login page UI
- No backend call happens yet
- No authentication check here

### State
- User is NOT logged in
- No token in localStorage

---

# 2️⃣ USER CLICKS "REGISTER HERE"

### Action
User clicks:
Register here (link)

### What happens
- Browser navigates to:
register.html
- This is a frontend navigation
- Backend is NOT involved

### Why
- HTML anchor tag redirects user
- Used only for UI navigation

---

# 3️⃣ USER CLICKS "REGISTER" BUTTON

### Action
User fills:
- Name
- Email
- Password
- Role

Then clicks:
Register button

---

### Frontend (register.js)

- Button click triggers register() function
- JavaScript collects form data
- Validation happens:
  - Empty fields → error shown
- If valid:
  - POST request sent to backend

Request:
POST /register

---

### Backend (authRoutes.js)

Flow:
- Request reaches Express
- express.json() parses body
- Register route executes
- Password is hashed using bcrypt
- Email uniqueness is checked
- User is inserted into database

---

### Possible Outcomes

#### ✅ Success
- Backend returns:
  "User registered successfully"
- Frontend shows success message
- After 1–2 seconds:
  Redirect to index.html (login page)

#### ❌ Failure
- Email already exists OR invalid data
- Error message shown
- No redirection

---

# 4️⃣ USER CLICKS "LOGIN" BUTTON

### Action
User enters:
- Email
- Password

Clicks:
Login button

---

### Frontend (login.js)

- login() function is triggered
- POST request sent to backend

Request:
POST /login

---

### Backend (authRoutes.js)

Flow:
- Email is checked in database
- Password is compared using bcrypt
- If valid:
  - JWT token is generated
  - Token includes:
    - user id
    - role
    - expiry time

Response:
- Token is sent to frontend

---

### Frontend After Login

- Token is stored in localStorage
- JWT payload is decoded (frontend only)
- Role is extracted from token

---

### Redirection Logic

If role == student:
dashboard.html?role=student

If role == teacher:
dashboard.html?role=teacher

This is ONLY frontend navigation.

---

# 5️⃣ USER LANDS ON DASHBOARD PAGE

### Action
Browser opens:
dashboard.html?role=student OR teacher

---

### Frontend (dashboard.js)

Flow:
- Token is read from localStorage
- Query parameter role is read from URL
- Based on role:
  - API URL is chosen

Student:
GET /student/dashboard

Teacher:
GET /teacher/dashboard

---

# 6️⃣ PROTECTED API CALL FLOW

### Backend Request Flow

Request
→ authMiddleware
→ roleMiddleware
→ route handler
→ response

---

### authMiddleware.js

What happens:
- Reads Authorization header
- Extracts JWT token
- Verifies token signature & expiry
- Decodes user info
- Attaches data to req.user

If token invalid:
- Request stops
- 401 Unauthorized returned

---

### roleMiddleware.js

What happens:
- Reads req.user.role
- Compares with required role

If role mismatch:
- Request stops
- 403 Access denied returned

---

### Route Handler

If both middlewares pass:
- Route logic executes
- Success message is returned

---

# 7️⃣ DASHBOARD RESPONSE HANDLING

### Frontend

- Response message is displayed
- User sees:
  - "Welcome Student" OR
  - "Welcome Teacher"

---

# 8️⃣ USER REFRESHES DASHBOARD PAGE

### What happens
- Browser reloads dashboard.html
- Token still exists in localStorage
- dashboard.js runs again
- Protected API is called again
- Middleware verifies token again

### Result
- User remains logged in
- No need to login again

---

# 9️⃣ USER TRIES WRONG ACCESS (SECURITY TEST)

### Scenario
Student tries:
dashboard.html?role=teacher

---

### What happens
- Frontend tries teacher API
- Token is still student token

Backend:
- authMiddleware passes
- roleMiddleware fails

Response:
403 Access denied

---

### Result
- UI shows error
- Backend security remains intact

---

# 🔟 USER CLICKS "LOGOUT"

### Action
User clicks:
Logout button

---

### Frontend (dashboard.js)

- Token is removed from localStorage
- Browser redirects to:
index.html

---

### State After Logout

- No token stored
- User is logged out
- Protected APIs will fail

---

# 1️⃣1️⃣ USER TRIES TO ACCESS DASHBOARD WITHOUT LOGIN

### Scenario
User directly opens:
dashboard.html

---

### What happens
- dashboard.js checks token
- Token is missing
- User is redirected to login page

---

# 1️⃣2️⃣ WHY THIS FLOW IS CORRECT

- Frontend controls UI & navigation
- Backend controls security
- JWT ensures stateless authentication
- Middleware enforces rules
- Routes separate responsibilities

---

# INTERVIEW-READY SUMMARY

User actions trigger frontend events.  
Frontend sends API requests.  
Backend validates requests using middleware.  
Routes execute business logic.  
Responses control redirection and UI updates.  

Security decisions are always made on backend.

---

END OF COMPLETE FLOW NOTES
