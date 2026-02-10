API PARAMETERS (FROM ABSOLUTE ZERO)

This document explains the types of API parameters using ONE SINGLE EXAMPLE
throughout: a Bank Account Details API.

==================================================
BASE EXAMPLE API
==================================================

GET /accounts/5001?include=transactions&limit=10

This API fetches account details for a specific bank account.

==================================================
1. PATH PARAMETERS
==================================================

Question it answers:
Which exact resource?

Example:
/accounts/5001

5001 is the PATH PARAMETER.
It identifies a specific account.

Backend usage (Express):
req.params.accountId

Use cases:
- Get one account
- Get one customer
- Get one transaction

==================================================
2. QUERY PARAMETERS
==================================================

Question it answers:
How do you want the data?

Example:
?include=transactions&limit=10

include=transactions  → include transaction history
limit=10              → return only 10 records

Backend usage:
req.query.include
req.query.limit

Use cases:
- Filtering
- Pagination
- Sorting
- Searching

==================================================
3. BODY PARAMETERS
==================================================

Question it answers:
What data should the server process?

Example:
POST /transactions/transfer

Request body:
{
  fromAccount: 5001,
  toAccount: 7002,
  amount: 2500
}

Backend usage:
req.body.fromAccount
req.body.toAccount
req.body.amount

Use cases:
- Create data
- Update data
- Login / Register
- Money transfer

==================================================
4. HEADER PARAMETERS
==================================================

Question it answers:
Who is making the request and how?

Example:
Authorization: Bearer JWT_TOKEN_HERE

Backend usage:
req.headers.authorization

Use cases:
- Authentication (JWT)
- API keys
- Content type
- Security metadata

==================================================
5. COOKIE PARAMETERS
==================================================

Question it answers:
What should the server remember?

Example:
Cookie: sessionId=abc123

Backend usage:
req.cookies.sessionId

Use cases:
- Session-based authentication
- Browser login persistence

==================================================
ALL PARAMETERS USED TOGETHER
==================================================

Request:

GET /accounts/5001?include=transactions&limit=10
Authorization: Bearer JWT_TOKEN_HERE

Explanation:
- 5001                  → Path parameter (which account)
- include, limit        → Query parameters (how much data)
- Authorization header  → Header parameter (who is requesting)
- Body                  → Not required for GET
- Cookies               → Optional (session-based auth)

==================================================
HOW BACKEND ACCESSES PARAMETERS
==================================================

req.params    → Path parameters
req.query     → Query parameters
req.body      → Body parameters
req.headers   → Header parameters
req.cookies   → Cookie parameters

==================================================
IMPORTANT RULES (MUST FOLLOW)
==================================================

- IDs           → Path parameters
- Filters       → Query parameters
- Sensitive data→ Body parameters
- Tokens        → Header parameters
- Sessions      → Cookie parameters

==================================================
ONE-LINE SUMMARY
==================================================

Path parameters identify resources, query parameters filter data, body
parameters send data, headers carry metadata like tokens, and cookies
maintain session state.
