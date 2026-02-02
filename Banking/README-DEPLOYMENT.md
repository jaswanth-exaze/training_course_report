# Deployment Guide: Banking App to Render

This guide will walk you through deploying your full-stack banking application to Render.

## Prerequisites

1. A GitHub account
2. A Render account (sign up at [render.com](https://render.com))
3. Your code pushed to a GitHub repository

## Architecture Overview

The application consists of three services on Render:

1. **Backend Web Service** - Node.js/Express API
2. **Frontend Static Site** - HTML/CSS/JS files
3. **MySQL Database** - Managed PostgreSQL/MySQL database

## Step-by-Step Deployment

### Step 1: Prepare Your Repository

1. Ensure all your code is committed and pushed to GitHub
2. Make sure `render.yaml` is in the root of your repository
3. Verify that `backend/.gitignore` includes `.env` to prevent committing secrets

### Step 2: Create Database on Render

**Important**: Your application uses MySQL (`mysql2` package). Render's free tier typically offers PostgreSQL. You have two options:

#### Option A: Use MySQL-Compatible Service (Recommended)
1. Use a free MySQL service like [PlanetScale](https://planetscale.com) (free tier available)
2. Or use Render's MySQL service if available (may require paid plan)
3. Configure connection details and update environment variables accordingly

#### Option B: Use Render PostgreSQL (Requires Code Changes)
1. Log in to [Render Dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"PostgreSQL"**
3. Configure the database:
   - **Name**: `banking-database`
   - **Database**: `banking_system`
   - **User**: `banking_user`
   - **Plan**: Free (or your preferred plan)
4. Click **"Create Database"**
5. Wait for the database to be provisioned
6. **Note**: You'll need to update `backend/src/config/db.js` to use `pg` (PostgreSQL) instead of `mysql2`
7. Once ready, note down the connection details (you'll need these)

### Step 3: Initialize Database Schema

1. In the Render dashboard, go to your database service
2. Click on **"Connect"** or **"Info"** tab
3. Copy the **"External Connection String"** or connection details
4. Use a MySQL client (like MySQL Workbench, DBeaver, or command line) to connect
5. Run the SQL script from `databse bank.sql` to create all tables and initial data

**Alternative: Using Render Shell**

1. Go to your database service in Render
2. Click **"Shell"** tab
3. Connect using: `mysql -h <host> -u <user> -p<password> <database>`
4. Copy and paste the contents of `databse bank.sql`

### Step 4: Deploy Backend Service

1. In Render Dashboard, click **"New +"** → **"Web Service"**
2. Connect your GitHub repository
3. Configure the service:
   - **Name**: `banking-backend`
   - **Environment**: `Node`
   - **Root Directory**: `backend`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: Free (or your preferred plan)
4. Go to **"Environment"** tab and add these variables:
   ```
   NODE_ENV=production
   DB_HOST=<from database service>
   DB_USER=<from database service>
   DB_PASSWORD=<from database service>
   DB_NAME=banking_system
   DB_PORT=<from database service>
   JWT_SECRET=<generate a strong random string>
   FRONTEND_URL=<will set after frontend deployment>
   ```
5. Click **"Create Web Service"**
6. Wait for deployment to complete
7. Copy the service URL (e.g., `https://banking-backend.onrender.com`)

### Step 5: Deploy Frontend Static Site

1. In Render Dashboard, click **"New +"** → **"Static Site"**
2. Connect your GitHub repository
3. Configure the service:
   - **Name**: `banking-frontend`
   - **Root Directory**: `frontend`
   - **Build Command**: (leave empty)
   - **Publish Directory**: `frontend`
   - **Plan**: Free (or your preferred plan)
4. Click **"Create Static Site"**
5. Wait for deployment to complete
6. Copy the frontend URL (e.g., `https://banking-frontend.onrender.com`)

### Step 6: Configure Frontend API URL

Since the frontend is a static site, you need to configure the API URL. The `config.js` file will automatically detect the environment:

- **Local development**: Uses `http://localhost:3000`
- **Production**: Uses relative URLs (same origin) by default

For production deployment, you have two options:

#### Option A: Use Relative URLs (Simplest - Recommended)

If your frontend and backend are on the same domain (or you set up a proxy), the current `config.js` will work automatically using relative URLs.

#### Option B: Set API URL Manually

1. Edit `frontend/js/config.js`
2. Update the `API_BASE_URL` constant with your backend URL:
   ```javascript
   const API_BASE_URL = 'https://banking-backend.onrender.com';
   ```
3. Commit and push the change
4. Render will automatically redeploy

**Note**: If your frontend and backend are on different domains, you'll need to use Option B and ensure CORS is properly configured in the backend.

### Step 7: Update CORS in Backend

1. Go to your backend service in Render
2. Navigate to **"Environment"** tab
3. Update `FRONTEND_URL` to your frontend URL:
   ```
   FRONTEND_URL=https://banking-frontend.onrender.com
   ```
4. Save changes (this will trigger a redeploy)

### Step 8: Test Your Deployment

1. Visit your frontend URL: `https://banking-frontend.onrender.com`
2. Try logging in with test credentials
3. Verify all features work:
   - Customer dashboard
   - Employee dashboard
   - Manager dashboard
   - API calls are working

## Troubleshooting

### Backend Issues

- **Database Connection Failed**: 
  - Verify database credentials in environment variables
  - Check that database is running and accessible
  - Ensure database schema is initialized

- **Port Issues**:
  - Backend should use `process.env.PORT` (already configured)
  - Render automatically sets this

- **CORS Errors**:
  - Verify `FRONTEND_URL` environment variable matches your frontend URL
  - Check browser console for specific CORS error messages

### Frontend Issues

- **API Calls Failing**:
  - Check browser console for errors
  - Verify `config.js` has correct API URL
  - Ensure backend service is running and accessible
  - Check CORS configuration in backend

- **404 Errors**:
  - Verify file paths are correct
  - Check that `config.js` is loaded before other scripts

### Database Issues

- **Schema Not Found**:
  - Re-run `databse bank.sql` script
  - Verify database name matches `DB_NAME` environment variable

- **Connection Timeout**:
  - Check database service status in Render
  - Verify network connectivity
  - Check firewall rules if using external connection

## Environment Variables Reference

### Backend Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `production` |
| `PORT` | Server port (auto-set by Render) | `10000` |
| `DB_HOST` | Database host | `dpg-xxxxx-a.oregon-postgres.render.com` |
| `DB_USER` | Database username | `banking_user` |
| `DB_PASSWORD` | Database password | `xxxxx` |
| `DB_NAME` | Database name | `banking_system` |
| `DB_PORT` | Database port | `5432` or `3306` |
| `JWT_SECRET` | Secret for JWT tokens | `your-secret-key` |
| `FRONTEND_URL` | Frontend URL for CORS | `https://banking-frontend.onrender.com` |

## Using render.yaml (Alternative Method)

If you prefer automated deployment:

1. Ensure `render.yaml` is in your repository root
2. In Render Dashboard, click **"New +"** → **"Blueprint"**
3. Connect your GitHub repository
4. Render will automatically detect `render.yaml` and create all services
5. You'll still need to:
   - Initialize the database schema manually
   - Set `FRONTEND_URL` environment variable after frontend is deployed
   - Configure frontend API URL

## Notes

- Free tier services on Render may spin down after inactivity (15 minutes)
- First request after spin-down may be slow (cold start)
- Consider upgrading to a paid plan for production use
- Database backups are recommended for production
- Monitor logs in Render dashboard for debugging

## Support

For Render-specific issues, check:
- [Render Documentation](https://render.com/docs)
- [Render Community](https://community.render.com)

For application-specific issues, check:
- Backend logs in Render dashboard
- Browser console for frontend errors
- Database connection status

