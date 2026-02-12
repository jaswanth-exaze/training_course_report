# Refresh Token Flow (Basic Version)

This document explains refresh token flow in very simple language based on your current code.

---

## 1. Simple Idea

Your login session uses 2 tokens:

1. Access token (short life, 1 hour)
- Stored in `localStorage`
- Sent in `Authorization: Bearer <token>`

2. Refresh token (long life, 7 days)
- Stored in cookie (`refreshToken`)
- Cookie is `HttpOnly` so JavaScript cannot read it
- Used only for `/auth/refresh`

When access token expires, frontend tries refresh once.

---

## 2. Files Involved

Backend:
- `backend/src/utils/jwt.util.js`
- `backend/src/services/auth.service.js`
- `backend/src/controllers/auth.controller.js`
- `backend/src/routes/auth.routes.js`
- `backend/src/app.js`

Frontend:
- `frontend/js/login.js`
- `frontend/js/auth.js`

Database:
- `refresh_tokens` table

---

## 3. Backend (Basic Code Explanation)

## 3.1 Token and Cookie Setup

File: `backend/src/utils/jwt.util.js`

```js
exports.generateAccessToken = (payload) => {
  return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: "1h" });
};

exports.generateRefreshToken = (payload) => {
  return jwt.sign(payload, process.env.REFRESH_TOKEN_SECRET, { expiresIn: "7d" });
};

exports.getRefreshCookieOptions = () => {
  const isProduction = process.env.NODE_ENV === "production";

  return {
    httpOnly: true,
    secure: isProduction,
    sameSite: isProduction ? "none" : "lax",
    maxAge: 7 * 24 * 60 * 60 * 1000,
    path: "/auth",
  };
};
```

Meaning:
- Access token: 1 hour
- Refresh token: 7 days
- Refresh token cookie sent only for `/auth/*`

---

## 3.2 Login Flow (Backend)

File: `backend/src/services/auth.service.js` -> `exports.login`

Basic steps:
1. Check username/password
2. Find user in DB
3. Compare password hash
4. Create access token
5. Create refresh token
6. Hash refresh token with SHA-256
7. Save hashed token in `refresh_tokens` table
8. Return access token + role + refresh token

Important code:

```js
const refreshToken = generateRefreshToken({ user_id: user.user_id });
const hashedRefreshToken = hashRefreshToken(refreshToken);

await db.promise().query(
  `
  INSERT INTO refresh_tokens (user_id, token, expires_at, is_revoked, created_at)
  VALUES (?, ?, ?, false, NOW())
  `,
  [user.user_id, hashedRefreshToken, refreshExpiryDate()],
);
```

Why hash refresh token in DB?
- Safer if DB leaks.

---

## 3.3 Login Controller

File: `backend/src/controllers/auth.controller.js` -> `exports.login`

```js
const result = await authService.login(req.body);

res.cookie(
  REFRESH_COOKIE_NAME,
  result.refreshToken,
  getRefreshCookieOptions(),
);

res.json({
  message: result.message,
  token: result.token,
  role: result.role,
});
```

Meaning:
- Refresh token goes to cookie
- Access token goes in JSON response

---

## 3.4 Refresh Flow (Backend)

Route:

```js
// backend/src/routes/auth.routes.js
router.post("/refresh", authController.refreshToken);
```

Controller:

```js
const refreshToken = req.cookies?.[REFRESH_COOKIE_NAME];
if (!refreshToken) {
  return res.status(401).json({ message: "Refresh token missing" });
}

const result = await authService.refreshAccessToken(refreshToken);

res.cookie(REFRESH_COOKIE_NAME, result.refreshToken, getRefreshCookieOptions());
return res.json({ message: result.message, token: result.token, role: result.role });
```

Service (`exports.refreshAccessToken`) basic steps:
1. Verify refresh token JWT
2. Hash incoming token
3. Start DB transaction
4. Find active token row in DB
5. Validate not expired
6. Create new access token
7. Create new refresh token
8. Revoke old row
9. Insert new row
10. Commit and return new token pair

Important code:

```js
await connection.beginTransaction();

const [tokenRows] = await connection.query(
  `
  SELECT id, expires_at
  FROM refresh_tokens
  WHERE token = ? AND user_id = ? AND is_revoked = false
  LIMIT 1
  FOR UPDATE
  `,
  [hashedIncomingToken, decoded.user_id],
);

await connection.query(`UPDATE refresh_tokens SET is_revoked = true WHERE id = ?`, [tokenRecord.id]);

await connection.query(
  `
  INSERT INTO refresh_tokens (user_id, token, expires_at, is_revoked, created_at)
  VALUES (?, ?, ?, false, NOW())
  `,
  [user.user_id, hashedNextRefreshToken, refreshExpiryDate()],
);

await connection.commit();
```

---

## 3.5 Logout Flow (Backend)

Route:

```js
router.post("/logout", authController.logout);
```

Controller:

```js
const refreshToken = req.cookies?.[REFRESH_COOKIE_NAME];
if (refreshToken) {
  await authService.revokeRefreshToken(refreshToken);
}

const clearOptions = { ...getRefreshCookieOptions() };
delete clearOptions.maxAge;
res.clearCookie(REFRESH_COOKIE_NAME, clearOptions);
```

Service revokes DB token:

```js
await db.promise().query(
  `UPDATE refresh_tokens SET is_revoked = true WHERE token = ?`,
  [hashedRefreshToken],
);
```

---

## 4. Frontend (Basic Code Explanation)

## 4.1 Login Request

File: `frontend/js/login.js`

```js
const res = await fetch(getApiUrl("auth/login"), {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  credentials: "include",
  body: JSON.stringify({ username, password })
});
```

Meaning:
- `credentials: "include"` is required so browser accepts cookie.

After success:

```js
localStorage.setItem("token", data.token);
localStorage.setItem("role", data.role);
```

---

## 4.2 Simple Global Fetch Wrapper

File: `frontend/js/auth.js`

This file does 4 simple things:
1. Adds bearer token to API calls (except `/auth/*`)
2. Adds `credentials: "include"`
3. If response is `401`, calls `/auth/refresh` once
4. If refresh works, retries original request; else redirects to login

Key code:

```js
if (!apiCall || response.status !== 401 || authCall) {
  return response;
}

const refreshRes = await originalFetch(getApiUrl("auth/refresh"), {
  method: "POST",
  credentials: "include",
}).catch(() => null);

if (refreshRes && refreshRes.ok) {
  const refreshData = await refreshRes.json().catch(() => null);
  if (refreshData && refreshData.token) {
    localStorage.setItem("token", refreshData.token);
    if (refreshData.role) localStorage.setItem("role", refreshData.role);

    const retryOptions = buildRequestOptions(init, true);
    response = await originalFetch(input, retryOptions);
    return response;
  }
}

redirectToLogin(message);
```

This is intentionally basic and easy to follow.

---

## 5. Full Runtime Flow (Simple)

## Login
1. User sends username/password
2. Backend validates user
3. Backend sends access token in JSON
4. Backend sets refresh token cookie
5. Frontend saves access token

## Normal API Call
1. Frontend sends bearer access token
2. Backend checks access token
3. Success response

## Access Token Expired
1. Backend returns `401`
2. Frontend calls `/auth/refresh` using cookie
3. Backend verifies refresh token and DB row
4. Backend rotates refresh token
5. Backend returns new access token
6. Frontend retries original request

## Refresh Fails
1. `/auth/refresh` returns `401`
2. Frontend clears local token/role
3. Frontend redirects to `/login.html`

## Logout
1. Frontend calls `/auth/logout`
2. Backend revokes refresh token in DB
3. Backend clears cookie
4. Frontend clears local auth state

---

## 6. Basic Troubleshooting

If refresh is not working, check these first:

1. `credentials: "include"` in frontend requests
2. `credentials: true` in backend CORS
3. `app.use(cookieParser())` in backend app
4. `REFRESH_TOKEN_SECRET` is set in `.env`
5. Browser actually stores `refreshToken` cookie

---

## 7. Final Note

Current implementation is now intentionally basic:
- simple backend service flow,
- simple frontend refresh handling,
- no advanced helper layers in frontend.
