# SYSTEM ARCHITECTURE DOCUMENTATION
## Student-Teacher Authentication System with JWT

---

## TABLE OF CONTENTS
1. [System Overview](#system-overview)
2. [Architecture Layers](#architecture-layers)
3. [Technology Stack](#technology-stack)
4. [Data Flow Architecture](#data-flow-architecture)
5. [Security Architecture](#security-architecture)
6. [Database Schema](#database-schema)
7. [API Endpoints](#api-endpoints)
8. [Middleware Pipeline](#middleware-pipeline)
9. [Component Interactions](#component-interactions)
10. [Deployment Architecture](#deployment-architecture)

---

## SYSTEM OVERVIEW

### Purpose
This system provides role-based authentication and authorization for students and teachers using JWT (JSON Web Tokens). Users can register, log in, and access role-specific dashboards.

### Key Features
- User Registration: Create accounts with email, password, and role selection
- JWT Authentication: Secure token-based authentication
- Role-Based Access Control (RBAC): Different access levels for students and teachers
- Password Security: Bcrypt hashing for password protection
- Token Expiration: 1-hour token validity period
- Stateless Authentication: Server doesn't maintain session state

### Architecture Type
Three-Tier Architecture
- Presentation Layer (Frontend)
- Application Layer (Backend/API)
- Data Layer (MySQL Database)

---

## ARCHITECTURE LAYERS

### 1. PRESENTATION LAYER (Frontend)
Location: frontend/

Components:
- index.html: Login page
- register.html: Registration page
- dashboard.html: Role-specific dashboard
- Student_demo.html: Student demo page
- Teacher_demo.html: Teacher demo page
- css/: Stylesheets
- js/: JavaScript logic (login.js, register.js, dashboard.js, etc)

Responsibilities:
- User interface for authentication
- Client-side form validation
- HTTP request handling via Fetch API
- Token storage in localStorage
- Role-based UI rendering
- Redirect logic based on user role

Technologies:
- HTML5
- CSS3
- Vanilla JavaScript
- Fetch API for HTTP requests

---

### 2. APPLICATION LAYER (Backend/Express Server)
Location: Root directory with app.js

#### A. Main Application (app.js)
Responsibilities:
- Server initialization
- Middleware configuration (CORS, JSON parsing)
- Route mounting
- Port listening (3000)

#### B. Routes Directory (routes/)
Files:
- authRoutes.js: /register, /login
- studentRoutes.js: /student/dashboard
- teacherRoutes.js: /teacher/dashboard

authRoutes.js Endpoints:
- POST /register: User registration
- POST /login: User login with JWT generation

studentRoutes.js Endpoints:
- GET /student/dashboard: Student dashboard (protected)

teacherRoutes.js Endpoints:
- GET /teacher/dashboard: Teacher dashboard (protected)

#### C. Middleware Directory (middleware/)
Files:
- authMiddleware.js: JWT verification
- roleMiddleware.js: Role authorization

Middleware Pipeline:
Request → CORS → JSON Parser → Routes → Auth Middleware → Role Middleware → Handler → Response

#### D. Database Connection (db.js)
- MySQL connection configuration
- Connection pooling
- Error handling

---

### 3. DATA LAYER (MySQL Database)

#### Database Configuration
- Database Name: school_auth
- Connection Host: localhost
- Port: 3306
- Driver: mysql2

#### Database Schema

Users Table:
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL (bcrypt hashed),
  role ENUM('student', 'teacher') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

Indexes:
- Primary Key: id
- Unique Index: email

Data Storage:
- Passwords: Hashed using bcrypt (10 salt rounds)
- Roles: Enum restricted to 'student' or 'teacher'
- Timestamps: Automatic creation and update tracking

---

## TECHNOLOGY STACK

### Frontend
Layer: Structure, Technology: HTML5, Purpose: Page markup
Layer: Styling, Technology: CSS3, Purpose: Visual design
Layer: Scripting, Technology: JavaScript (Vanilla), Purpose: Client-side logic
Layer: HTTP, Technology: Fetch API, Purpose: API communication
Layer: Storage, Technology: LocalStorage, Purpose: Token persistence

### Backend
Layer: Runtime, Technology: Node.js, Purpose: JavaScript runtime
Layer: Framework, Technology: Express.js, Purpose: Web framework
Layer: Authentication, Technology: JWT, Purpose: Token generation & verification
Layer: Password Security, Technology: bcrypt, Purpose: Password hashing
Layer: CORS, Technology: cors package, Purpose: Cross-origin requests
Layer: Environment, Technology: Port 3000, Purpose: Server port

### Database
Layer: Database, Technology: MySQL, Purpose: Relational database
Layer: Driver, Technology: mysql2, Purpose: Node.js MySQL driver
Layer: Connection, Technology: Direct connection, Purpose: No ORM/query builder

### Dependencies
- express: ^4.x.x
- bcrypt: ^5.x.x
- jsonwebtoken: ^9.x.x
- cors: ^2.x.x
- mysql2: ^3.x.x

---

## DATA FLOW ARCHITECTURE

### Complete Request/Response Flow

#### 1. Registration Flow
User Input (Frontend) → Form Validation (Frontend) → POST /register → Express Middleware (JSON Parser, CORS) → authRoutes.js - POST /register handler → Validate input (all fields required) → Validate role (student/teacher only) → Check email uniqueness in DB → Hash password with bcrypt → Insert user into database → Return success/error response → Frontend receives response → Display success/error message

#### 2. Authentication Flow
User Input: Email + Password (Frontend) → POST /login → Express Middleware processing → authRoutes.js - POST /login handler → Validate input → Query database for user by email → Compare password with bcrypt → Generate JWT token (if valid) → Payload: { id, role, name } → Secret: "secretKey" → Expiry: "1h" → Return token → Frontend receives token → Store in localStorage → Decode token (extract role) → Redirect to dashboard → User redirected

#### 3. Protected Resource Access Flow
Dashboard Load (Frontend) → frontend/js/dashboard.js executes → Read token from localStorage → Read role from URL query parameter → Prepare API request → GET /student/dashboard or /teacher/dashboard → Express processes request → authMiddleware.js executes → Extract Authorization header → Extract token from "Bearer token" → Verify JWT with secret key → Check token expiration → Attach decoded user to req.user → Pass to next middleware (if valid) → roleMiddleware.js executes → Check if req.user exists → Compare req.user.role with required role → Pass to handler (if matched) → Route Handler executes → Return user-specific data → Frontend receives response → Display dashboard content

---

## SECURITY ARCHITECTURE

### Authentication Security

#### JWT Structure
Header.Payload.Signature

Header: { alg: "HS256", typ: "JWT" }
Payload: { id, role, name, iat, exp }
Signature: HMAC-SHA256(header.payload, "secretKey")

#### Token Generation
- Algorithm: HS256 (HMAC with SHA-256)
- Secret Key: "secretKey"
- Expiration: 1 hour from generation
- Claims: id, role, name

#### Token Verification
- Token extracted from Authorization header
- Format validated: "Bearer <token>"
- Signature verified with secret key
- Expiration checked
- Payload decoded and attached to request

### Authorization Security

#### Role-Based Access Control (RBAC)
Request → Auth Middleware → Role Middleware → if (req.user.role === required_role) → Handler executes OR 403 Forbidden

Roles:
- student: Can access /student/dashboard
- teacher: Can access /teacher/dashboard

### Password Security

#### Hashing Algorithm
- Method: bcrypt
- Salt Rounds: 10
- Output: Irreversible one-way hash

#### Verification Process
User Input Password → bcrypt.compare(inputPassword, hashedPassword) → Returns boolean (true/false)

### HTTP Security

#### CORS Configuration
- Enabled via cors() middleware
- Allows frontend to communicate with backend
- Prevents unauthorized cross-origin requests

#### Input Validation
- Required fields check (name, email, password, role)
- Role validation (only 'student' or 'teacher')
- Email format (by database unique constraint)

### Secrets Management
SECURITY NOTE:
- Secret key "secretKey" is hardcoded (NOT RECOMMENDED FOR PRODUCTION)
- Should use: Environment variables (.env file)
- Should use: Strong, random secret keys (minimum 32 characters)
- Should use: Different secrets for different environments

---

## DATABASE SCHEMA

### Users Table Structure
Table: users
- id (INT, PRIMARY KEY, AUTO_INCREMENT)
- name (VARCHAR(100), NOT NULL)
- email (VARCHAR(100), UNIQUE, NOT NULL)
- password (VARCHAR(255), NOT NULL)
- role (ENUM('student', 'teacher'), NOT NULL)
- created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- updated_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE)

### Constraints
- Primary Key: id (unique identifier)
- Unique: email (one email per account)
- Enum Check: role must be 'student' or 'teacher'
- NOT NULL: All fields except timestamps

### Indexing Strategy
- Primary Index: id (automatic by PRIMARY KEY)
- Unique Index: email (automatic by UNIQUE constraint)
- Suggested: Index on role for RBAC queries

### Query Patterns
Register - Check email uniqueness: SELECT * FROM users WHERE email = ?
Register - Insert new user: INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)
Login - Find user by email: SELECT * FROM users WHERE email = ?
Dashboard - Already have user data from JWT token - No additional query needed (stateless)

---

## API ENDPOINTS

### Authentication Endpoints

#### 1. POST /register
Purpose: Create new user account
```
Request:
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123",
  "role": "student"
}

Response (Success - 201):
{
  "message": "User registered successfully"
}
```
Response (Error):
```json
{
  "message": "All fields are required" // 400
  "message": "Invalid role" // 400
  "message": "User already exists" // 400
  "message": "Database error" // 500
  "message": "Failed to register user" // 500
}
```
Validation Rules:
- name: Required, non-empty string
- email: Required, must be unique
- password: Required, non-empty string
- role: Required, must be "student" or "teacher"

---

#### 2. POST /login
Purpose: Authenticate user and issue JWT token

```
Request:
{
  "email": "john@example.com",
  "password": "securePassword123"
}

Response (Success - 200):
{
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InN0dWRlbnQiLCJuYW1lIjoiSm9obiBEb2UiLCJpYXQiOjE2NzM1MDAwMDAsImV4cCI6MTY3MzUwMzYwMH0.signature"
}

Response (Error):
{
  "message": "Email and password are required" // 400
  "message": "Invalid email or password" // 401
  "message": "Database error" // 500
}

Token Composition:
Decoded payload:
{
  "id": 1,
  "role": "student",
  "name": "John Doe",
  "iat": 1673500000,
  "exp": 1673503600
}
```
---

### Protected Endpoints

#### 3. GET /student/dashboard
Purpose: Retrieve student dashboard data

Requirements:
- Authentication: Required (JWT token in Authorization header)
- Authorization: Required (role must be 'student')

Request Header:
Authorization: Bearer <JWT_TOKEN>

Response (Success - 200):
{
  "message": "Welcome JOHN DOE",
  "userId": 1,
  "role": "student"
}

Response (Error):
{
  "message": "Authorization header missing" // 401
  "message": "Token missing" // 401
  "message": "Invalid or expired token" // 401
  "message": "Access denied" // 403
}

---

#### 4. GET /teacher/dashboard
Purpose: Retrieve teacher dashboard data

Requirements:
- Authentication: Required (JWT token)
- Authorization: Required (role must be 'teacher')

Request Header:
Authorization: Bearer <JWT_TOKEN>

Response (Success - 200):
{
  "message": "Welcome TEACHER NAME",
  "userId": 1,
  "role": "teacher"
}

Response (Error): Same as /student/dashboard

---

### Public Endpoints

#### 5. GET /
Purpose: Health check / API verification

Response (200):
Student-Teacher Auth API running

---

#### 6. GET /protected
Purpose: Test protected route with auth middleware

Requirements: Authentication (JWT token)

Response (Success - 200):
{
  "message": "Protected route accessed",
  "user": {
    "id": 1,
    "role": "student",
    "name": "John Doe"
  }
}

---

## MIDDLEWARE PIPELINE

### Express Middleware Chain

#### 1. Global Middleware (in app.js)
app.use(cors()) // Enable CORS
app.use(express.json()) // Parse JSON request bodies

#### 2. Route-Specific Middleware

Public Routes (authRoutes):
POST /register - No custom middleware
POST /login - No custom middleware

Protected Routes (studentRoutes, teacherRoutes):
GET /student/dashboard
- authMiddleware
  - Check Authorization header
  - Extract token
  - Verify JWT
  - Check expiration
  - Attach user to req
- roleMiddleware("student")
  - Check req.user exists
  - Verify role === "student"

GET /teacher/dashboard
- authMiddleware
- roleMiddleware("teacher")

---

### authMiddleware.js Details

Execution Steps:
1. Extract Authorization header from request
   - If missing → 401 response, stop

2. Parse header format "Bearer <token>"
   - Expected format: "Bearer xyz..."
   - If invalid → 401 response, stop

3. Verify JWT signature
   - Use secret key: "secretKey"
   - If signature invalid → 401 response, stop

4. Check token expiration
   - If exp < current_time → 401 response, stop

5. Decode token payload
   - Extract claims (id, role, name, iat, exp)
   - Attach to req.user = decoded

6. Pass to next middleware
   - Call next() → continue request chain

Code Structure:
```javascript
const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;
  
  // Step 1: Header check
  if (!authHeader) return 401;
  
  // Step 2: Token extraction
  const token = authHeader.split(" ")[1];
  if (!token) return 401;
  
  try {
    // Step 3-5: Verify and decode
    const decoded = jwt.verify(token, "secretKey");
    req.user = decoded;
    
    // Step 6: Continue
    next();
  } catch (error) {
    return 401;
  }
};
```
---

### roleMiddleware.js Details

Execution Steps:
1. Factory function creates specific role middleware
   roleMiddleware("student") → returns middleware function

2. Middleware function checks request
   - Verify req.user exists (set by authMiddleware)
   - Check req.user.role === required role

3. Decision
   - If role matches → call next() → continue
   - If role mismatch → 403 response → stop
   - If req.user missing → 403 response → stop

Code Structure:
```javascript
const roleMiddleware = (allowedRole) => {
  return (req, res, next) => {
    // Step 1-2: Check user and role
    if (!req.user || req.user.role !== allowedRole) {
      return 403;  // Step 3: Deny
    }
    next();        // Step 3: Allow
  };
};
```
---

## COMPONENT INTERACTIONS

### Sequence Diagram: Complete Login Flow

User → Fill form → Frontend
User → Click Login → Frontend
Frontend → POST /login {email, password} → Backend
Backend → Query user SELECT * WHERE... → Database
Database → User record → Backend
Backend → bcrypt.compare() → Backend
Backend → jwt.sign() Generate token → Backend
Backend → Response token → Frontend
Frontend → localStorage.setItem() → Frontend
Frontend → Decode token Extract role → Frontend
Frontend → Redirect dashboard → Frontend
User → Navigate → User
User → Open dashboard → Frontend
Frontend → GET /dashboard Header: Bearer token → Backend
Backend → (authMiddleware) → Backend
Backend → (roleMiddleware) → Backend
Backend → (route handler) → Backend
Backend → Dashboard data → Frontend
Frontend → Display → User (Welcome message)

---

### Component Dependency Graph

app.js (Entry Point)
- cors middleware
- express.json middleware
- authRoutes.js
  - db.js (database queries)
  - bcrypt (password hashing)
  - jsonwebtoken (token generation)
- studentRoutes.js
  - authMiddleware.js
    - jsonwebtoken (token verification)
  - roleMiddleware.js
- teacherRoutes.js
  - authMiddleware.js
  - roleMiddleware.js

db.js (Database Connection)
- mysql2 (MySQL driver)

Frontend files (Independent)
- index.html (login form)
- register.html (registration form)
- dashboard.html (dashboard template)
- JavaScript files
  - login.js (fetch POST /login)
  - register.js (fetch POST /register)
  - dashboard.js (fetch /student|teacher/dashboard)

---

## DEPLOYMENT ARCHITECTURE

### Development Environment

#### Local Setup
Frontend:
- Runs in browser (HTTP/HTTPS)
- Hosted from file system or local server

Backend:
- Node.js server
- Port: 3000
- URL: http://localhost:3000
- Auto-restart on file changes (nodemon recommended)

Database:
- MySQL Server (local instance)
- Host: localhost
- Port: 3306
- Database: school_auth
- Credentials: root/root

#### File Structure
project-root/
- app.js (Express server)
- db.js (Database connection)
- package.json (Dependencies)
- routes/
  - authRoutes.js
  - studentRoutes.js
  - teacherRoutes.js
- middleware/
  - authMiddleware.js
  - roleMiddleware.js
- frontend/
  - index.html
  - register.html
  - dashboard.html
  - css/
  - js/
    - login.js
    - register.js
    - dashboard.js

### Production Deployment Considerations

#### Environment Variables
.env file (never commit to git)
DB_HOST=your-host
DB_USER=your-user
DB_PASSWORD=your-password
DB_NAME=school_auth
JWT_SECRET=strong-random-secret-key
NODE_ENV=production
PORT=3000
FRONTEND_URL=https://yourdomain.com

#### Required Changes for Production
1. Move secrets to environment variables
2. Use HTTPS instead of HTTP
3. Enable CSRF protection
4. Add rate limiting
5. Implement logging and monitoring
6. Use prepared statements (prevent SQL injection)
7. Add input sanitization
8. Implement refresh tokens
9. Add HTTPS-only cookie flags
10. Use strong password requirements

#### Deployment Platforms
Backend: Heroku, AWS EC2, DigitalOcean, Render
Database: AWS RDS, DigitalOcean Managed DB, Heroku PostgreSQL
Frontend: Netlify, Vercel, AWS S3 + CloudFront

---

## SECURITY CHECKLIST

- Move secret keys to environment variables
- Use HTTPS in production
- Implement refresh token rotation
- Add request rate limiting
- Validate and sanitize all inputs
- Add CORS whitelist for specific origins
- Implement token blacklisting
- Add logging and monitoring
- Use parameterized queries (already implemented)
- Add password strength requirements
- Implement account lockout on failed attempts
- Add email verification
- Use httpOnly cookies instead of localStorage
- Implement CSRF protection
- Add API versioning

---

## PERFORMANCE CONSIDERATIONS

### Database Optimization
- Index on email column (for faster lookups)
- Index on role column (for role-based queries)
- Use connection pooling

### API Response Optimization
- Minimize payload size
- Implement pagination for future user lists
- Use caching for frequently accessed data

### Frontend Optimization
- Minify JavaScript and CSS
- Implement lazy loading
- Use async/await for better readability

---

## ERROR HANDLING

### HTTP Status Codes Used
Code 200: OK - Successful login, dashboard access
Code 201: Created - Successful registration
Code 400: Bad Request - Validation errors, missing fields
Code 401: Unauthorized - Invalid credentials, missing/expired token
Code 403: Forbidden - Insufficient role permissions
Code 500: Internal Server Error - Database errors, server errors

---

## CONCLUSION

This three-tier architecture provides:
- Security: JWT-based authentication, bcrypt password hashing, role-based access control
- Scalability: Stateless design, easy to scale horizontally
- Maintainability: Clear separation of concerns, modular structure
- Flexibility: Support for multiple roles, extensible design

The system is interview-ready and demonstrates understanding of:
- Web application architecture
- Authentication and authorization
- Middleware patterns
- RESTful API design
- Database design
- Security best practices