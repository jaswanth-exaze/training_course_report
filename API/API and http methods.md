# API & HTTP METHODS – COMPLETE BEGINNER GUIDE (NODE.JS CONTEXT)

---


## 1. What is an API?

API stands for Application Programming Interface.

In web development, an API allows communication between the frontend and backend.

Flow:
Frontend (HTML / JavaScript)
→ API Request
→ Backend (Node.js + Express)
→ Database (MySQL)
→ API Response
→ Frontend

---

## 2. Real-Life Example

Example: Zomato App

When you open the app:
- Frontend sends an API request to fetch restaurants
- Backend processes the request
- Backend fetches data from database
- Backend sends JSON response to frontend

This communication process is called an API.

---

## 3. What is a REST API?

REST stands for Representational State Transfer.

REST API:
- Uses HTTP protocol
- Uses URLs (endpoints)
- Uses standard HTTP methods
- Uses JSON for data exchange

Example endpoints:
GET    /users  
POST   /users  
PUT    /users/5  
DELETE /users/5  

---

## 4. Core Components of an API

### 1. Endpoint (URL)

Example:
http://localhost:3000/users

---

### 2. HTTP Method

GET  
POST  
PUT  
PATCH  
DELETE  

---

### 3. Headers

Headers carry extra information about the request.

Common headers:

Content-Type: application/json  
Authorization: Bearer token  

---

### 4. Body (with Example)

Body is used in POST and PUT requests to send data from client to server.

Example body (JSON format):

    ```json
    {
      "name": "Ravi",
      "email": "ravi@gmail.com"
    }
    ```

---

### 5. Response

Response is sent by the server back to the client.

Example response:

    ```json
    {
      "message": "User created successfully"
    }
    ```

---

## 5. HTTP METHODS (MOST IMPORTANT)

---

### GET – Fetch Data

Used to read or fetch data from the server.

Example:
GET /users

Express example:

    ```javascript
    app.get("/users", (req, res) => {
      res.send("User list");
    });
    ```

---

### POST – Create Data

Used to send data from client to server.

Example:
POST /users

Express example:

    ```javascript
    app.post("/users", (req, res) => {
      const data = req.body;
      res.json(data);
    });
    ```

---

### PUT – Update Entire Data

Used to update all fields of an existing record.

Example:
PUT /users/5

Express example:

    ```javascript
    app.put("/users/:id", (req, res) => {
      const id = req.params.id;
      res.send("Updated user " + id);
    });
    ```

---

### PATCH – Update Partial Data

Used to update only specific fields of a resource.

Example:
PATCH /users/5

---

### DELETE – Remove Data

Used to delete a record from database.

Example:
DELETE /users/5

Express example:

    ```javascript
    app.delete("/users/:id", (req, res) => {
      res.send("User deleted");
    });
    ```

---

## 6. HTTP Status Codes (INTERVIEW IMPORTANT)

200 – OK (Success)  
201 – Created (After POST)  
400 – Bad Request  
401 – Unauthorized  
404 – Not Found  
500 – Internal Server Error  

Example:

    ```javascript
    res.status(201).json({ message: "Created" });
    ```

---

## 7. Where Request Data Comes From

### req.params

Used for URL parameters.

URL:
users/5

Code:
req.params.id

---

### req.query

Used for query strings.

URL:
users?name=raj

Code:
req.query.name

---

### req.body

Used for POST and PUT data.

Code:
req.body.name

---

---

## 8. API Testing Tools

API testing tools are used to test backend APIs without a frontend.

Common API testing tools:

- Thunder Client (VS Code extension)
- Postman
- Browser (only supports GET requests)

Why API testing tools are used:
- To send GET, POST, PUT, DELETE requests
- To check request body, headers, and response
- To debug backend APIs easily

Example: Sending POST request body in Thunder Client

    ```json
    {
      "id": 5,
      "name": "Ravi"
    }
    ```

---

## 9. API Flow with Your Project Stack

Your typical full-stack project flow:

HTML + CSS + JavaScript  
→ Fetch API  
→ Node.js + Express API  
→ MySQL Database  

Explanation:
- Frontend sends request using fetch
- Backend receives request in Express route
- Backend queries MySQL database
- Backend sends response as JSON
- Frontend displays data

Frontend example (Fetch API):

    ```javascript
    fetch("http://localhost:3000/users")
      .then(response => response.json())
      .then(data => console.log(data));
    ```

Backend example (Express + MySQL):

    ```javascript
    app.get("/users", (req, res) => {
      db.query("SELECT * FROM users", (err, result) => {
        if (err) {
          res.status(500).json({ error: "Database error" });
        } else {
          res.json(result);
        }
      });
    });
    ```

---

## 10. REST API Naming Best Practices

REST APIs should follow clear and meaningful naming conventions.

Best practices:
- Use nouns instead of verbs
- Use plural resource names
- Use HTTP methods to define action
- Keep URLs simple and readable

Good API naming examples:

GET    /users  
POST   /users  
GET    /users/5  
PUT    /users/5  
DELETE /users/5  

Bad API naming examples:

/getUsers  
/addUser  
/deleteUser  
/updateUserById  

Reason:
- HTTP method already defines the action
- Endpoint should represent the resource

---

---

# BACKEND API CORE CONCEPTS (NODE + EXPRESS)

---

## 1. Express Routing

Routing defines how an application responds to client requests for specific URLs and HTTP methods.

In Express:
- Each route = one API endpoint
- Routes decide which function runs for a request

Basic route example:

    ```javascript
    app.get("/users", (req, res) => {
      res.send("All users");
    });
    ```

Route with parameter:

    ```javascript
    app.get("/users/:id", (req, res) => {
      res.send("User ID: " + req.params.id);
    });
    ```

Why routing is important:
- Separates logic for different APIs
- Makes backend structured and readable

---

## 2. Middleware

Middleware is a function that runs **between request and response**.

Flow:
Request → Middleware → Route → Response

Middleware can:
- Modify request
- Validate data
- Block request
- Log information

Example middleware:

    ```javascript
    app.use((req, res, next) => {
      console.log("Request received");
      next();
    });
    ```

Without `next()`:
- Request will stop
- Response will never reach route

---

## 3. Body Parser

Body Parser is used to read data sent in request body.

Without body parser:
- req.body is undefined

Used for:
- POST
- PUT
- PATCH

Example:

    ```javascript
    const express = require("express");
    const app = express();

    app.use(express.json());

    app.post("/users", (req, res) => {
      res.json(req.body);
    });
    ```

Now JSON body is accessible using:
req.body

---

## 4. CORS (Cross-Origin Resource Sharing)

CORS allows frontend and backend to communicate when they are on different ports.

Example:
Frontend: http://localhost:5500  
Backend: http://localhost:3000  

Without CORS:
- Browser blocks the request

Enable CORS:

    ```javascript
    const cors = require("cors");
    app.use(cors());
    ```

Why CORS is needed:
- Frontend and backend usually run on different origins
- Required for real-world applications

---

## 5. JWT Authentication

JWT stands for JSON Web Token.

Used for:
- Authentication
- Authorization

Flow:
1. User logs in
2. Server creates token
3. Token sent to client
4. Client sends token in headers
5. Server verifies token

Token generation example:

    ```javascript
    const jwt = require("jsonwebtoken");

    const token = jwt.sign(
      { userId: 1 },
      "secretKey",
      { expiresIn: "1h" }
    );
    ```

Token sent in header:

    ```json
    {
      "Authorization": "Bearer token_here"
    }
    ```

---

## 6. API Validation

API validation ensures correct and safe data is received.

Used to:
- Prevent empty values
- Prevent wrong data types
- Improve security

Example validation logic:

    ```javascript
    app.post("/users", (req, res) => {
      const { name, email } = req.body;

      if (!name || !email) {
        return res.status(400).json({ message: "All fields required" });
      }

      res.json({ message: "Valid data" });
    });
    ```

---

## 7. Pagination

Pagination is used to limit large data results.

Why pagination:
- Improves performance
- Reduces load on database
- Used in real applications

Example URL:
users?page=1&limit=5

Backend logic:

    ```javascript
    app.get("/users", (req, res) => {
      const page = parseInt(req.query.page) || 1;
      const limit = parseInt(req.query.limit) || 5;
      const offset = (page - 1) * limit;

      const sql = "SELECT * FROM users LIMIT ? OFFSET ?";
      db.query(sql, [limit, offset], (err, result) => {
        res.json(result);
      });
    });
    ```

---

## 8. Complete CRUD Project (Final Goal)

CRUD = Create, Read, Update, Delete

APIs in CRUD project:

Create:
POST /users

Read:
GET /users  
GET /users/:id  

Update:
PUT /users/:id  
PATCH /users/:id  

Delete:
DELETE /users/:id  

CRUD project includes:
- Express routing
- Middleware
- Body parser
- CORS
- JWT authentication
- Validation
- Pagination
- MySQL integration

This project represents **real industry-level backend work**.

---
