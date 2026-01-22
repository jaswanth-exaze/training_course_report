# FRONTEND → BACKEND → MIDDLEWARE → RESPONSE  
## COMPLETE LOGIN & STUDENT DASHBOARD FLOW (STEP-BY-STEP)

---

## STEP 1: USER LOGS IN (FRONTEND)

Location:
frontend/index.html

Action:
- User enters email and password
- User clicks the Login button

What happens:
- Clicking the button triggers the `login()` function
- This function is defined in:
  frontend/js/login.js

---

## STEP 2: LOGIN FUNCTION EXECUTION

File:
frontend/js/login.js

Process:
- The `login()` function reads email and password from input fields
- A POST request is sent using `fetch`

Request:
POST http://localhost:3000/login  
Body contains:
- email
- password

---

## STEP 3: REQUEST REACHES BACKEND LOGIN ROUTE

File:
routes/authRoutes.js

Route:
router.post("/login", ...)

What happens here:
- Express receives the request
- `express.json()` middleware parses the request body
- Email and password validation is performed
- User is searched in the database
- Password is compared using bcrypt

If validation fails:
- Error response is sent back

If validation succeeds:
- JWT token is generated
- Token contains:
  - user id
  - user role
  - expiry time
- Token is sent back to frontend in response

---

## STEP 4: FRONTEND RECEIVES TOKEN

File:
frontend/js/login.js

What happens:
- Response from backend is received
- JWT token is extracted from response
- Token is stored in browser using:
  localStorage.setItem("token", token)

Next:
- Token payload is decoded on frontend
- User role is extracted from payload

---

## STEP 5: ROLE-BASED REDIRECTION (FRONTEND)

Decision logic:
- If role is "student":
  Redirect to:
  dashboard.html?role=student

- If role is "teacher":
  Redirect to:
  dashboard.html?role=teacher

This is a frontend-only navigation.

---

## STEP 6: DASHBOARD PAGE LOADS

File:
frontend/dashboard.html

What happens:
- Page loads in browser
- JavaScript file `js/dashboard.js` runs automatically

---

## STEP 7: DASHBOARD LOGIC EXECUTION

File:
frontend/js/dashboard.js

Process:
- JWT token is read from localStorage
- Role is read from URL query parameter
- Based on role, correct API is selected

For student:
GET http://localhost:3000/student/dashboard

Authorization header is added:
Authorization: Bearer <JWT_TOKEN>

---

## STEP 8: REQUEST REACHES STUDENT ROUTE (BACKEND)

File:
routes/studentRoutes.js

Route:
router.get(
  "/student/dashboard",
  authMiddleware,
  roleMiddleware("student"),
  ...
)

---

## STEP 9: AUTH MIDDLEWARE EXECUTION

File:
middleware/authMiddleware.js

What happens:
- Authorization header is checked
- JWT token is extracted
- Token is verified using secret key
- Token expiry is checked
- Decoded user data is attached to `req.user`

If token is invalid:
- Request stops
- 401 Unauthorized is returned

---

## STEP 10: ROLE MIDDLEWARE EXECUTION

File:
middleware/roleMiddleware.js

What happens:
- `req.user.role` is checked
- Role is compared with required role ("student")

If role does not match:
- Request stops
- 403 Access Denied is returned

---

## STEP 11: ROUTE HANDLER EXECUTES

File:
routes/studentRoutes.js

What happens:
- All middleware checks passed
- Route handler executes
- Response is sent:

Response:
{
  "message": "Welcome Student"
}

---

## STEP 12: FRONTEND DISPLAYS RESPONSE

File:
frontend/js/dashboard.js

What happens:
- Response message is received
- Message is displayed on dashboard UI
- Student successfully accesses dashboard

---

## FINAL SUMMARY (INTERVIEW READY)

- Frontend handles UI and navigation
- Backend handles authentication and authorization
- JWT token maintains login state
- Middleware enforces security rules
- Routes execute business logic
- Role-based access is strictly controlled on backend

---

END OF FLOW EXPLANATION

┌──────────────────────────────────────────────┐
│              FRONTEND (BROWSER)               │
└──────────────────────────────────────────────┘

        User opens index.html
                 │
                 ▼
┌──────────────────────────────────────────────┐
│ frontend/index.html                           │
│ - User enters email & password               │
│ - Clicks LOGIN button                        │
└──────────────────────────────────────────────┘
                 │
                 │ onclick="login()"
                 ▼
┌──────────────────────────────────────────────┐
│ frontend/js/login.js                          │
│ login() function executes                    │
│ - Reads email & password                     │
│ - Sends POST request                         │
└──────────────────────────────────────────────┘
                 │
                 │ POST /login
                 │ Body: { email, password }
                 ▼
┌──────────────────────────────────────────────┐
│              BACKEND (EXPRESS)                │
└──────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────┐
│ routes/authRoutes.js                          │
│ router.post("/login")                         │
│ - Validates email & password                 │
│ - Finds user in DB                           │
│ - bcrypt.compare()                           │
│ - jwt.sign() generates token                 │
└──────────────────────────────────────────────┘
                 │
                 │ Response:
                 │ { message, token }
                 ▼
┌──────────────────────────────────────────────┐
│ frontend/js/login.js                          │
│ - Receives response                          │
│ - Saves token in localStorage                │
│ - Decodes token payload                      │
│ - Extracts role                              │
└──────────────────────────────────────────────┘
                 │
                 │ Role-based redirect
                 ▼
┌──────────────────────────────────────────────┐
│ Browser navigation                            │
│ dashboard.html?role=student                  │
└──────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────┐
│ frontend/dashboard.html                       │
│ - Page loads                                 │
│ - dashboard.js executes automatically        │
└──────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────┐
│ frontend/js/dashboard.js                      │
│ - Reads token from localStorage              │
│ - Reads role from URL                        │
│ - Chooses API based on role                  │
└──────────────────────────────────────────────┘
                 │
                 │ GET /student/dashboard
                 │ Header: Authorization: Bearer TOKEN
                 ▼
┌──────────────────────────────────────────────┐
│ routes/studentRoutes.js                      │
│ router.get("/student/dashboard")             │
└──────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────┐
│ middleware/authMiddleware.js                 │
│ - Reads Authorization header                 │
│ - Extracts token                             │
│ - jwt.verify(token, secretKey)               │
│ - Attaches decoded data to req.user          │
└──────────────────────────────────────────────┘
                 │
                 │ if token valid
                 ▼
┌──────────────────────────────────────────────┐
│ middleware/roleMiddleware.js                 │
│ - Checks req.user.role === "student"         │
└──────────────────────────────────────────────┘
                 │
                 │ if role matches
                 ▼
┌──────────────────────────────────────────────┐
│ Student Route Handler                        │
│ - Sends response                             │
│   { "message": "Welcome Student" }           │
└──────────────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────┐
│ frontend/js/dashboard.js                     │
│ - Receives response                          │
│ - Displays "Welcome Student" on UI           │
└──────────────────────────────────────────────┘
