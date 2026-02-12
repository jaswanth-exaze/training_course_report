# Production Deployment Report – Banking Application

## Complete Detailed End-to-End Deployment Documentation (Final Version)

---

## 1. Objective of Deployment

The objective of this deployment was to convert a locally running banking application into a real-world, production-grade cloud application using industry-standard deployment practices.

The deployment focused on:

- Separating frontend and backend services
- Selecting appropriate cloud platforms for each layer
- Using a managed MySQL database
- Securing credentials using environment variables
- Implementing JWT-based authentication
- Enabling CI/CD using GitHub integration
- Hosting the application publicly over HTTPS
- Establishing a reliable frontend-to-backend communication mechanism

This document captures every architectural decision, configuration, and file-level change made during deployment.

---

## 2. Platform Selection and Justification

### 2.1 Backend Deployment – Railway

Railway was selected for backend deployment because:

- Backend is built using Node.js
- Project requires MySQL, which Railway provides as a managed service
- Railway supports private internal service networking
- Secure environment variable management
- Built-in GitHub-based CI/CD
- HTTPS enabled automatically
- Easy scalability and monitoring

---

### 2.2 Frontend Deployment – Vercel

Vercel was selected for frontend deployment because:

- Frontend uses HTML, CSS, and JavaScript
- Application is a static website
- Automatic detection of index.html
- Global CDN support
- Zero build configuration
- Automatic redeployment on GitHub push

---

## 3. GitHub Repository Restructuring

### 3.1 Before Deployment (Local Setup)

Initial local project structure:

    banking-app/
    ├── frontend/
    ├── backend/
    └── database/

Limitations:

- Not cloud-ready
- Frontend and backend tightly coupled
- No independent CI/CD pipelines
- Hard to scale and maintain

---

### 3.2 After Deployment (Production Setup)

Two separate repositories were created.

Frontend repository:

    banking-frontend/
    ├── index.html
    ├── css/
    └── js/
        └── apiConfig.js

Backend repository:

    banking-backend/
    ├── src/
    ├── app.js
    ├── server.js
    └── package.json

Benefits:

- Independent deployment
- Clear separation of concerns
- Industry-standard architecture
- Easier debugging and scaling

---

## 4. Backend Code-Level Changes for Production

### 4.1 Dynamic Port Binding

Before deployment, the backend used a hardcoded port.

Previous implementation:

    app.listen(3000);

Updated implementation:

    const PORT = process.env.PORT || 3000;
    app.listen(PORT);

Reason:

- Railway assigns dynamic ports at runtime
- Required for cloud environments

---

### 4.2 Database Configuration Refactor

Hardcoded database credentials were removed.

Previous implementation:

    host: localhost
    user: root
    password: root

Updated implementation:

    host: process.env.DB_HOST
    user: process.env.DB_USER
    password: process.env.DB_PASSWORD
    database: process.env.DB_NAME

Reason:

- No secrets in source code
- Same code works across environments
- Improved security

---

### 4.3 Database Connection Pooling

Single database connection was replaced with connection pooling.

Reason:

- Supports concurrent users
- Prevents connection exhaustion
- Production-grade reliability

---

## 5. Railway Backend Deployment and Environment Configuration

### 5.1 Backend Repository Connection

Steps:

1. Railway account created
2. GitHub connected
3. Backend repository selected
4. Node.js runtime detected automatically
5. Auto deployment enabled

---

### 5.2 MySQL Database Provisioning

Steps:

1. MySQL plugin added in Railway
2. Database instance created
3. Tables and stored procedures cloned
4. Private internal networking enabled

---

### 5.3 Backend Environment Variables (Railway)

Railway MySQL variables mapped to backend:

    DB_HOST
    DB_USER
    DB_PASSWORD
    DB_NAME

Additional backend environment variables added:

    API_BASE_URL = ${{RAILWAY_PUBLIC_DOMAIN}}
    FRONTEND_URL = https://banking-frontend.vercel.app
    JWT_SECRET = banking_app_secure_key_2026

---

## 6. Frontend to Backend URL Integration (Key Production Enhancement)

### 6.1 Problem With Hardcoded URLs

In local development, frontend API calls used:

    http://localhost:3000

After deployment, this failed because:

- Frontend runs on Vercel
- Backend runs on Railway
- Localhost is not accessible in production
- Hardcoding production URLs reduces flexibility

---

### 6.2 Centralized API Configuration in Frontend

To solve this, a centralized API configuration file was created in the frontend.

This file:

- Defines API_BASE_URL once
- Attaches it to the global window object
- Automatically works for both local and production environments
- Prevents API URL duplication across files

Frontend API configuration logic:

- Checks if window.API_BASE_URL already exists
- Detects hostname (localhost vs production)
- Assigns Railway backend URL accordingly
- Exposes a helper function to build API endpoints safely

---

### 6.3 Helper Function for API Endpoints

A helper function was introduced to:

- Remove leading slashes
- Avoid malformed URLs
- Ensure consistency across API calls

Result:

- Clean and reliable API requests
- No repeated URL strings
- Easy maintenance

---

### 6.4 Frontend API Usage Pattern

Instead of writing:

    fetch("https://bankingapplication-production.up.railway.app/api/login")

Frontend now uses:

    fetch(getApiUrl("api/login"))

Benefits:

- Cleaner code
- Environment-independent
- Enterprise-grade pattern

---

## 7. Backend Support for Frontend Integration

### 7.1 FRONTEND_URL Environment Variable

The backend defines:

    FRONTEND_URL = https://banking-frontend.vercel.app

This value is used to:

- Configure CORS allowed origins
- Restrict API access to trusted frontend
- Improve security

---

### 7.2 CORS Configuration Logic

Backend CORS middleware:

- Allows requests only from FRONTEND_URL
- Supports local development origin
- Prevents unauthorized cross-origin requests

Result:

- Secure frontend-backend communication
- No browser CORS errors

---

## 8. JWT Authentication Flow

Steps:

1. User submits login credentials from frontend
2. Frontend sends request using getApiUrl
3. Backend validates credentials
4. JWT token generated using JWT_SECRET
5. Token returned to frontend
6. Token stored in localStorage
7. Token attached to Authorization header for protected APIs

Security:

- Tokens verified on every request
- Role-based access enforced
- Unauthorized requests blocked

Refresh-token session renewal (basic implementation):

1. Backend sets `refreshToken` cookie on login (HttpOnly)
2. Frontend keeps access token in localStorage
3. On protected API `401`, frontend calls `POST /auth/refresh`
4. If refresh succeeds, frontend saves new access token and retries original request once
5. If refresh fails, frontend clears auth state and redirects to login

---

## 9. CI/CD Pipeline Implementation

Backend pipeline:

    GitHub Push
        ↓
    Railway Build
        ↓
    Backend Deployment

Frontend pipeline:

    GitHub Push
        ↓
    Vercel Deployment

Benefits:

- Zero manual deployment
- Faster iteration
- Reliable production updates

---

## 10. Final Outcome

The final system includes:

- Frontend hosted on Vercel
- Backend hosted on Railway
- MySQL database hosted on Railway
- Secure JWT authentication
- Centralized API configuration
- Reliable frontend-backend communication
- HTTPS enabled across all layers
- Fully automated CI/CD pipelines

---

## 11. Conclusion

This deployment represents a complete real-world production setup.  
The addition of centralized API configuration and environment-based URL handling elevates the project to enterprise standards.

The system is scalable, secure, maintainable, and interview-ready.

---

## End of Report
