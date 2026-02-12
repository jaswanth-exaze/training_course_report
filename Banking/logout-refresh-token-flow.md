# Logout and Refresh Token Flow (Detailed)

This document explains exactly how logout is connected to refresh token handling in this project, using the current backend/frontend implementation.

## 1. Goal

Explain the full session lifecycle:

1. Login creates access + refresh tokens.
2. Refresh rotates refresh tokens when access token expires.
3. Logout revokes the refresh token and clears cookie/client auth state.
4. Why refresh fails after logout.

---

## 2. Key Artifacts in This System

### Access token
- Type: JWT
- Lifetime: `1h`
- Storage: `localStorage` key `token`
- Used in: `Authorization: Bearer <token>` header for protected APIs
- Source: `backend/src/utils/jwt.util.js` (`generateAccessToken`)

### Refresh token
- Type: JWT
- Lifetime: `7d`
- Storage (browser): HttpOnly cookie named `refreshToken`
- Storage (DB): SHA-256 hash in `refresh_tokens.token`
- Source: `backend/src/utils/jwt.util.js` (`generateRefreshToken`)

### Refresh cookie options
- Defined in `backend/src/utils/jwt.util.js` (`getRefreshCookieOptions`)
- Important attributes:
  - `httpOnly: true`
  - `path: "/auth"` (cookie is sent only to `/auth/*` routes)
  - `secure: true` only in production
  - `sameSite: "none"` in production, `"lax"` otherwise
  - `maxAge: 7 days`

### DB table (used by auth service)
- Table: `refresh_tokens`
- Fields used in code:
  - `id`
  - `user_id`
  - `token` (hashed refresh token)
  - `expires_at`
  - `is_revoked`
  - `created_at`

---

## 3. Route Wiring

Auth routes are mounted at `/auth` in `backend/src/app.js`.

Defined in `backend/src/routes/auth.routes.js`:
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`

---

## 4. Login Flow (How Refresh Token Is Created)

### Frontend request
`frontend/js/login.js` sends:
- `POST /auth/login`
- `credentials: "include"` (required so browser accepts/sends auth cookies)

### Backend flow
`backend/src/controllers/auth.controller.js` -> `login`:
1. Calls `authService.login(req.body)`.
2. Receives `{ token, refreshToken, role }`.
3. Sets refresh cookie: `res.cookie(REFRESH_COOKIE_NAME, result.refreshToken, getRefreshCookieOptions())`.
4. Returns JSON with access token + role (refresh token is **not** returned in JSON).

`backend/src/services/auth.service.js` -> `login`:
1. Validates credentials.
2. Creates access token and refresh token.
3. Hashes refresh token with SHA-256.
4. Inserts hashed token row into `refresh_tokens` with `is_revoked = false`, `expires_at = now + 7d`.

Result after login:
- Browser has HttpOnly refresh cookie.
- Frontend has access token in `localStorage`.
- DB has active hashed refresh token row.

---

## 5. Refresh Flow (How Rotation Works)

When access token expires, protected APIs return `401`.

### Frontend auto-refresh behavior
`frontend/js/auth.js` installs a global fetch wrapper:
1. Adds bearer token + `credentials: "include"` for backend API calls.
2. If non-auth API returns `401`, calls `POST /auth/refresh` with cookie.
3. On refresh success:
   - updates `localStorage` token/role
   - retries original API request once
4. On refresh failure:
   - clears local auth state
   - redirects to login

### Backend refresh endpoint
`backend/src/controllers/auth.controller.js` -> `refreshToken`:
1. Reads cookie `req.cookies.refreshToken`.
2. Calls `authService.refreshAccessToken(refreshToken)`.
3. Sets **new** refresh cookie returned by service.
4. Responds with new access token + role.

### Refresh service internals (rotation)
`backend/src/services/auth.service.js` -> `refreshAccessToken`:
1. Verifies refresh JWT signature/expiry.
2. Hashes incoming refresh token.
3. Starts DB transaction.
4. Selects active matching token row:
   - same hashed token
   - same user
   - `is_revoked = false`
   - `FOR UPDATE`
5. Rejects if not found or expired.
6. Generates new access token + new refresh token.
7. Revokes old row (`is_revoked = true`).
8. Inserts new active hashed refresh token row.
9. Commits transaction.

This is refresh-token rotation: each successful refresh invalidates the previous refresh token.

---

## 6. Logout Flow (How It Is Connected to Refresh Token)

### Frontend logout call
`frontend/js/auth.js` -> `logout()`:
1. Calls `POST /auth/logout` with `credentials: "include"`.
2. Regardless of backend success/failure:
   - clears `localStorage` auth keys
   - redirects to login

### Backend logout endpoint
`backend/src/controllers/auth.controller.js` -> `logout`:
1. Reads refresh token from cookie.
2. If present, calls `authService.revokeRefreshToken(refreshToken)`.
3. Clears refresh cookie with matching cookie options.
4. Returns `"Logged out successfully"`.

### Service revocation behavior
`backend/src/services/auth.service.js` -> `revokeRefreshToken`:
1. Hashes cookie refresh token.
2. Updates matching row in `refresh_tokens`:
   - `SET is_revoked = true`

---

## 7. Exact Connection: Logout vs Refresh

Logout and refresh are connected by the **same token identity**:

1. Refresh uses cookie refresh token -> hashes it -> requires DB row with `is_revoked = false`.
2. Logout uses cookie refresh token -> hashes it -> marks that DB row `is_revoked = true` and clears cookie.

So after logout:
- Browser no longer sends refresh cookie.
- Even if token is somehow reused, DB row is revoked.
- `/auth/refresh` fails (missing token or not recognized/revoked).

That is why refresh cannot succeed after logout for that session token.

---

## 8. Important Security Caveat

Logout revokes refresh token, but does **not** instantly invalidate already-issued access tokens.

In current code:
- Access tokens are stateless JWTs verified by signature+expiry (`backend/src/middlewares/auth.middleware.js`).
- There is no access-token denylist/blacklist check.
- Therefore an already issued access token can still work until its `1h` expiry.

If immediate logout invalidation is required, add one of:
- access token blacklist (jti/store),
- token versioning on user record,
- shorter access expiry + strict rotation policy.

---

## 9. State Transition Model (Refresh Token)

`ACTIVE` -> `REVOKED` on:
- successful refresh rotation (old token revoked),
- explicit logout.

`ACTIVE` -> `EXPIRED` when `expires_at` passes (or JWT expiry check fails).

Refresh endpoint accepts only `ACTIVE` + unexpired + valid signature tokens.

---

## 10. Edge Cases

### Logout without cookie
- Backend just clears cookie response and returns success.
- Frontend still clears local state.

### Multiple devices/sessions
- Each login creates a separate refresh row.
- Logout revokes only the refresh token from that browser cookie.
- Other device sessions remain active unless you implement global logout.

### Replay of old refresh token
- Old rotated token is revoked in DB, so replay fails.

### Missing `credentials: "include"`
- Refresh/logout cookie will not be sent.
- Refresh and logout behavior breaks.

---

## 11. Debug Checklist

1. Login in browser, verify:
   - `localStorage.token` exists
   - cookie `refreshToken` exists (HttpOnly, path `/auth`)
2. Check DB `refresh_tokens`:
   - one row for user with `is_revoked = false`
3. Force access token expiry and call protected API:
   - observe `POST /auth/refresh`
   - verify old DB row revoked + new row inserted
4. Click logout:
   - observe `POST /auth/logout`
   - verify cookie cleared
   - verify matching DB row becomes `is_revoked = true`
5. Try refresh after logout:
   - should return `401`

---

## 12. File Map for This Flow

- `backend/src/app.js`
- `backend/src/routes/auth.routes.js`
- `backend/src/controllers/auth.controller.js`
- `backend/src/services/auth.service.js`
- `backend/src/utils/jwt.util.js`
- `backend/src/middlewares/auth.middleware.js`
- `frontend/js/login.js`
- `frontend/js/auth.js`

---

## 13. Direct Code References (Current Snapshot)

### Login creates and stores refresh token
- `backend/src/services/auth.service.js:62` generate refresh token
- `backend/src/services/auth.service.js:66` hash refresh token
- `backend/src/services/auth.service.js:70` insert into `refresh_tokens`

### Refresh uses cookie token + active DB record + rotation
- `backend/src/controllers/auth.controller.js:41` read refresh cookie
- `backend/src/services/auth.service.js:108` select token row
- `backend/src/services/auth.service.js:112` require `is_revoked = false`
- `backend/src/services/auth.service.js:156` revoke old token row
- `backend/src/services/auth.service.js:165` insert new rotated token row

### Logout revokes same refresh token and clears cookie
- `backend/src/controllers/auth.controller.js:68` read refresh cookie
- `backend/src/controllers/auth.controller.js:71` call revoke service
- `backend/src/services/auth.service.js:190` revoke method start
- `backend/src/services/auth.service.js:198` update `is_revoked = true`
- `backend/src/controllers/auth.controller.js:76` clear cookie

### Frontend call sites
- `frontend/js/auth.js:152` call `/auth/logout`
- `frontend/js/auth.js:154` send `credentials: "include"`
- `frontend/js/auth.js:111` call `/auth/refresh`
- `frontend/js/auth.js:113` send `credentials: "include"` for refresh
