# Production Deployment Report – Banking Application

## Project Title
Cloud Deployment of Full-Stack Banking Application Using Railway, Vercel, MySQL, and JWT Authentication

---

## 1. Project Overview

The goal of this project was to deploy a production-ready full-stack banking application using modern cloud infrastructure and real-world deployment practices. The application consists of:

- A static frontend web application (HTML, CSS, JavaScript)
- A backend REST API built with Node.js
- A cloud-hosted MySQL database
- JWT-based authentication
- Secure cross-origin communication
- Automated deployment using CI/CD pipelines

The deployed application supports:

- Role-based login (Customer, Employee, Manager)
- Secure authentication with JWT
- Real-time backend API communication
- Cloud database persistence
- Production hosting with HTTPS

---

## 2. Technology Stack

### Frontend

- HTML
- CSS
- JavaScript
- Hosting Platform: Vercel

### Backend

- Node.js
- Express.js
- JWT Authentication
- Hosting Platform: Railway

### Database

- MySQL (Railway Managed Database)

### Deployment Infrastructure

- Railway Internal Service Networking
- Environment Variables Configuration
- GitHub-Based Continuous Deployment
- HTTPS Enabled Hosting

---

## 3. Initial System Architecture (Before Deployment)

Initially, the application was running locally.

Architecture:

Browser  
↓  
Local Frontend  
↓  
Node.js Backend (localhost)  
↓  
Local MySQL Database  

### Limitations of Local Setup

- Application not publicly accessible
- Database restricted to local machine
- No production security
- No cloud scalability
- No CI/CD workflow

---

## 4. Target Production Architecture

After deployment, the architecture was transformed into:

User Browser  
↓  
Vercel Frontend Hosting  
↓  
Railway Backend API  
↓  
JWT Authentication Layer  
↓  
Railway MySQL Cloud Database  

### Improvements Achieved

- Public access with HTTPS
- Secure authentication layer
- Cloud-hosted backend and database
- Real-world microservice communication
- Production-grade networking

---

## 5. Backend Deployment Process (Railway)

### Step 1: Production Preparation

Before deployment, the backend was modified for production compatibility.

### Dynamic Port Binding

Hardcoded ports were removed.

Old implementation:

app.listen(3000);

Updated implementation:

app.listen(process.env.PORT || 3000);

This allowed Railway to dynamically assign ports.

---

### Environment Variable Configuration

Local hardcoded values were replaced with environment-based configuration.

Old:

host: "localhost"

Updated:

host: process.env.DB_HOST

This ensured security and environment separation.

---

### Step 2: GitHub Integration

The backend repository was connected to Railway:

- Automatic build detection
- Continuous deployment pipeline
- Auto redeploy on every push

---

### Step 3: Railway Backend Service Creation

Railway automatically provisioned:

- Node.js runtime environment
- HTTPS public endpoint
- Logging and monitoring tools

Backend production URL:

https://bankingapplication-production.up.railway.app

---

## 6. Database Deployment Process (Railway MySQL)

### Step 1: MySQL Plugin Setup

Railway MySQL plugin created:

- Database server
- Secure credentials
- Internal networking
- Persistent storage

---

### Step 2: Backend–Database Integration

Environment variables were mapped:

DB_HOST  
DB_USER  
DB_PASSWORD  
DB_NAME  

These values were injected at runtime into the backend process.

---

### Step 3: Connection Pool Implementation

Initial implementation used a single database connection.

mysql.createConnection()

This was replaced with:

mysql.createPool()

### Benefits of Pooling

- Automatic reconnection
- Better concurrency handling
- Improved stability
- Production-grade reliability

---

## 7. Major Deployment Challenges and Solutions

---

### Challenge 1: Database Connection Refused (ECONNREFUSED)

#### Issue

Backend logs showed:

ECONNREFUSED :3306

This happened because:

- Backend started before MySQL service finished initializing
- Service networking was not fully linked

---

#### Solution

Actions taken:

- Linked Backend Service and MySQL Service inside Railway
- Used Railway internal DNS (*.railway.internal)
- Restarted backend after database initialization

#### Result

MySQL connected successfully

---

### Challenge 2: Environment Variable Conflicts

#### Issue

Multiple conflicting variables existed:

- Manual credentials
- Root passwords
- Public proxy URLs mixed with private network values

This caused authentication failures.

---

#### Solution

Standardized configuration.

Backend used only:

DB_HOST  
DB_USER  
DB_PASSWORD  
DB_NAME  

No secrets were hardcoded.

---

### Challenge 3: Frontend Assets Not Loading on Vercel

#### Issue

After frontend deployment:

- HTML loaded
- CSS and JS failed
- UI appeared unstyled

Cause:

- Files were located in subfolders (frontend/public)
- Vercel serves root directory by default

---

#### Solution

- Moved frontend public files to repository root
- Updated asset paths to absolute references

Example:

/css/style.css  
/js/main.js  

This ensured consistent loading in production.

---

### Challenge 4: CORS Errors Between Frontend and Backend

#### Issue

Browser blocked API requests due to cross-origin restrictions.

---

#### Solution

Configured backend CORS:

Allowed origins:

- http://localhost:5500
- https://bankingapplicationfrontend.vercel.app

This enabled secure frontend-backend communication.

---

### Challenge 5: Cannot GET /api/login Error

#### Issue

Direct browser access returned:

Cannot GET /api/login

---

#### Explanation

Login API uses POST method:

POST /api/login

Browser address bar sends GET requests.

---

#### Resolution

Login tested using:

- Frontend UI
- Browser network inspector
- POST-based API calls

Backend behavior confirmed correct.

---

## 8. JWT Authentication Integration

### Token Generation

On successful login:

- JWT token generated
- Signed using secret key
- Expiry configured
- Role data embedded

---

### Frontend Token Storage

Token stored in browser storage:

localStorage

Used in API calls:

Authorization: Bearer <token>

---

### Refresh Token Session Renewal (Basic)

To avoid forcing re-login after every access-token expiry:

- Backend sets a `refreshToken` cookie (HttpOnly) on login
- Frontend has a simple global `fetch` wrapper
- If any protected API returns `401`, frontend calls `POST /auth/refresh`
- On success, frontend stores new access token and retries original request once
- On failure, frontend clears auth state and redirects to login

This keeps the implementation beginner-friendly while still supporting session renewal.

---

### Route Protection

Backend middleware verified tokens:

- Prevented unauthorized access
- Enforced role-based permissions

---

## 9. Frontend Deployment Process (Vercel)

### Steps Followed

1. Connected GitHub repository
2. Selected "Other" framework preset
3. No build command required
4. Automatic deployment triggered

---

### Production Frontend URL

https://bankingapplicationfrontend.vercel.app

---

### Features Provided by Vercel

- HTTPS encryption
- CDN distribution
- Fast global delivery
- Automatic redeployment

---

## 10. Final Production Testing

### Backend Health Check

- API endpoints responding correctly
- Server uptime verified

---

### Authentication Flow Testing

- Login successful
- Token generated
- Protected routes accessible

---

### Database Operations

- Data insertion successful
- Queries executed correctly
- Pool connections stable

---

### Cross-Origin Requests

- Frontend requests allowed
- CORS headers validated
- No browser blocking

---

## 11. Security Measures Implemented

- Environment variable secrets
- HTTPS communication
- JWT authentication
- Restricted CORS origins
- Private database networking
- No public DB exposure

---

## 12. CI/CD Pipeline Implementation

### Backend Pipeline

GitHub Push  
↓  
Railway Auto Build  
↓  
Backend Redeployment  

---

### Frontend Pipeline

GitHub Push  
↓  
Vercel Auto Deployment  

---

### Benefits

- Automatic deployments
- Version tracking
- Faster iteration
- Zero manual deployment effort

---

## 13. Final Outcome

The deployment achieved:

- Fully functional production system
- Cloud-based architecture
- Secure authentication layer
- Stable database connectivity
- Public frontend hosting
- Enterprise-style deployment pipeline

---

## 14. Skills Demonstrated

This project demonstrates expertise in:

- Cloud deployment
- Backend production configuration
- Database service integration
- JWT-based authentication
- Environment variable management
- Frontend static hosting
- CI/CD automation
- Debugging distributed systems

---

## 15. Conclusion

This project successfully transformed a locally running application into a real-world production-grade deployment. Throughout the deployment process, multiple challenges related to networking, environment configuration, asset management, and security were identified and resolved.

The final system reflects professional deployment practices and provides a strong foundation for scalability, security improvements, and enterprise-level enhancements.

---

## End of Report
