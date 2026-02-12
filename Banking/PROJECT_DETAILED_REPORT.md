# SecureBank Banking System

## Comprehensive Project Report

Version: 1.1  
Date: 2026-02-11  
Repository Root: `c:\Users\Exaze\OneDrive - EXAZEIT\Desktop\Banking`

---

## 1. Executive Summary

This project is a role-based digital banking platform with a static frontend and a Node.js/Express backend connected to MySQL. It supports three operational roles:

- Customer
- Employee
- Manager

Core capabilities already implemented:

- JWT-based authentication and role-based access control
- Cookie-based refresh-token rotation with logout revocation
- Customer self-service account viewing, transfer, transaction history, profile, and loan request
- Employee branch operations for onboarding, account creation, cash desk, transaction review, and first-stage loan decisions
- Manager branch oversight for employees/customers/transactions and final loan decision with automatic disbursal
- Database-level transaction procedures for transfer/deposit/withdraw and trigger-based loan workflow guardrails

The codebase is functional and modular, with clear separation of frontend scripts, backend routes/controllers/services, and SQL schema/procedures. This report documents current state, user stories, flows, requirements, technical architecture, risks, and next-phase recommendations.

---

## 2. Project Context and Vision

### 2.1 Problem Being Solved

Bank branches need separate role-driven workflows:

- Customers need secure self-service banking
- Employees need efficient branch operations tools
- Managers need branch-level controls and approvals

Traditional systems split these functions across disconnected applications. This project provides a unified system with centralized backend APIs and role-specific dashboards.

### 2.2 Product Vision

Deliver a secure, practical, branch-ready banking platform where each role can perform its daily responsibilities through a focused dashboard while sharing one consistent data model and access-control framework.

### 2.3 Business Outcomes

- Faster customer servicing
- Better operational auditability
- Controlled multi-step approvals for loans
- Reduced manual branch process friction

---

## 3. Scope

### 3.1 In Scope (Implemented)

- Login and JWT session management
- Refresh-token lifecycle with HttpOnly cookie storage, token rotation, and logout revocation
- Customer dashboard:
  - Account list
  - Transfer money
  - Transactions
  - Loan apply + status tracking
  - Profile
- Employee dashboard:
  - Branch summary
  - Branch customers
  - Branch transactions (filter + pagination)
  - Cash desk deposit/withdraw
  - Onboard customer with optional account
  - Employee loan queue (approve/reject)
  - Profile
- Manager dashboard:
  - Branch summary
  - Branch employees/customers
  - Branch transactions (filter + pagination)
  - Manager loan queue (approve/reject)
  - All branch loans list
- MySQL schema with seed data
- Stored procedures:
  - `add_money`
  - `remove_money`
  - `transfer_money`
- Loan status triggers and loan history table

### 3.2 Out of Scope (Not Yet Implemented)

- Automated test suite
- Fine-grained audit event service beyond transaction/loan history
- Notifications (email/SMS/in-app)
- Multi-factor authentication
- CI/CD pipeline and quality gates
- Full admin role

---

## 4. Stakeholders and Actor Model

### 4.1 Primary Actors

- Customer: uses personal banking features
- Employee: performs branch operations
- Manager: oversees branch and final approvals

### 4.2 Supporting Stakeholders

- Branch operations leadership
- IT/DevOps for deployment and environment
- Security/compliance reviewers

---

## 5. Technical Architecture

### 5.1 High-Level Architecture

```text
[Browser: Static HTML/CSS/JS]
        |
        | HTTPS fetch (Bearer JWT + refresh cookie)
        v
[Node.js + Express API]
  - Routes
  - Controllers
  - Services
  - JWT/Auth middlewares
        |
        | mysql2 queries/procedures
        v
[MySQL: Tables + Procedures + Triggers]
```

### 5.2 Backend Stack

- Node.js
- Express `^5.2.1`
- mysql2 `^3.16.1`
- jsonwebtoken `^9.0.3`
- bcrypt `^6.0.0`
- cors `^2.8.5`
- cookie-parser `^1.4.7`
- dotenv `^17.2.3`

### 5.3 Frontend Stack

- Static HTML/CSS/Vanilla JavaScript
- Role-specific dashboards:
  - `frontend/dashboards/customer.html`
  - `frontend/dashboards/employee.html`
  - `frontend/dashboards/manager.html`
- Shared auth/API utilities:
  - `frontend/js/auth.js`
  - `frontend/js/config.js`

### 5.4 Backend Layering

- `routes/`: HTTP route definitions and middleware chain
- `controllers/`: request validation, service orchestration, response handling
- `services/`: SQL and business logic
- `middlewares/`: token verification and role authorization
- `utils/`: JWT signing and password comparison

---

## 6. Codebase Structure Snapshot

### 6.1 Backend

- `backend/src/app.js`: app setup and route mounting
- `backend/src/server.js`: server bootstrap
- `backend/src/config/db.js`: mysql pool + startup connection check
- `backend/src/middlewares/`:
  - `auth.middleware.js`
  - `role.middleware.js`
- `backend/src/routes/`:
  - `auth.routes.js`
  - `customer.routes.js`
  - `employee.routes.js`
  - `manager.routes.js`
  - `protected.routes.js`
- `backend/src/controllers/`:
  - `auth.controller.js`
  - `customer.controller.js`
  - `employee.controller.js`
  - `manager.controller.js`
- `backend/src/services/`:
  - `auth.service.js`
  - `customer.service.js`
  - `employee.service.js`
  - `loan.service.js`
  - `manager.service.js`

### 6.2 Frontend

- Public pages:
  - `frontend/index.html`
  - `frontend/login.html`
- Dashboards:
  - `frontend/dashboards/customer.html`
  - `frontend/dashboards/employee.html`
  - `frontend/dashboards/manager.html`
- JavaScript:
  - `frontend/js/config.js`
  - `frontend/js/auth.js`
  - `frontend/js/login.js`
  - `frontend/js/customer.js`
  - `frontend/js/employee.js`
  - `frontend/js/manager.js`

### 6.3 Database

- `databse bank.sql` (schema, seeds, procedures, triggers)

---

## 7. Security and Access Model

### 7.1 Authentication

- Login endpoint validates credentials against hashed password
- JWT payload contains:
  - `user_id`
  - `role`
  - `branch_id`
- Token expiration is `1h`
- Refresh token is stored server-side as a SHA-256 hash and sent only via HttpOnly cookie

### 7.2 Authorization

- `verifyToken` middleware validates JWT, handles expiry/invalid token
- `checkRole` middleware restricts endpoint access by role
- Role guard is used across customer/employee/manager routes

### 7.3 Frontend Session Handling

- Token and role stored in `localStorage`
- `protectPage(role)` enforces page-level role check
- Global fetch interceptor attempts `/auth/refresh` on `401`, retries once with new access token, then redirects on failure

### 7.4 Current Security Strengths

- Password hashing with bcrypt
- Signed JWT with expiration
- Refresh-token rotation with hashed server-side storage
- Role-based route protection
- Branch scoping on core operations
- SQL-level transactional safety for money movement

### 7.5 Security Limitations

- No account lockout/rate-limiting on login
- No MFA
- Broad CORS values are static, not environment-driven
- Browser third-party cookie policies may still affect cross-site refresh flow in strict environments

---

## 8. Role Capability Matrix

| Capability                     | Customer | Employee | Manager                                                               |
| ------------------------------ | -------- | -------- | --------------------------------------------------------------------- |
| Login                          | Yes      | Yes      | Yes                                                                   |
| View own accounts              | Yes      | No       | No                                                                    |
| Transfer funds                 | Yes      | No       | No                                                                    |
| View own transactions          | Yes      | No       | No                                                                    |
| View branch customers          | No       | Yes      | Yes                                                                   |
| Create account for customer    | No       | Yes      | Indirect (route allows manager in employee routes for some endpoints) |
| Onboard customer               | No       | Yes      | No                                                                    |
| Branch transaction audit       | No       | Yes      | Yes                                                                   |
| Deposit/withdraw via cash desk | No       | Yes      | No                                                                    |
| Submit loan request            | Yes      | No       | No                                                                    |
| Employee loan decision         | No       | Yes      | No                                                                    |
| Manager loan decision          | No       | No       | Yes                                                                   |
| Branch dashboard summary       | No       | Yes      | Yes                                                                   |

---

## 9. Functional Workflows

### 9.1 Authentication Flow

1. User submits username/password from login page.
2. Backend validates credentials, returns access token + role, and sets refresh token in HttpOnly cookie.
3. Frontend stores access token/role and redirects to role dashboard.
4. Dashboard loads protected APIs with `Authorization: Bearer <token>`.

### 9.2 Session Expiry Flow

1. Token expires or becomes invalid.
2. Any protected API responds with `401`.
3. Frontend fetch interceptor calls `POST /auth/refresh` (cookie-based) and rotates refresh token on success.
4. Original API request is retried once with the new access token.
5. If refresh fails, frontend clears session, redirects to login, and shows one-time message.

### 9.3 Customer Transfer Flow

1. Customer selects source account and enters target account id + amount.
2. Frontend performs basic validations.
3. Backend calls stored procedure `transfer_money`.
4. Procedure inserts debit and credit transaction entries and updates both balances atomically.

### 9.4 Employee Cash Desk Flow

1. Employee enters account id and amount.
2. Deposit uses `add_money`; withdrawal uses `remove_money`.
3. Procedure inserts transaction and updates account balance in one transaction.

### 9.5 Employee Onboarding Flow

1. Employee submits customer identity, credentials, and optional account details.
2. Backend starts DB transaction:
   - create `users` record (role customer)
   - create `customers` record
   - optional `accounts` record
3. Commit if all succeed, rollback on any failure.

### 9.6 Loan Approval Pipeline

1. Customer creates loan request (`REQUESTED`).
2. Employee reviews pending requests and decides:
   - `EMPLOYEE_APPROVED` or `EMPLOYEE_REJECTED`
3. Manager reviews employee-approved requests and decides:
   - `MANAGER_APPROVED` or `MANAGER_REJECTED`
4. On manager approval:
   - loan amount credited to customer active account
   - transaction entry recorded
5. Triggers enforce valid status transitions and populate `loan_status_history`.

---

## 10. API Catalogue

Base URL prefixes are mounted in `backend/src/app.js`.

### 10.1 Auth Routes

- `GET /auth/test`  
  Purpose: auth module health check
- `POST /auth/login`  
  Purpose: login, returns access token and role while setting refresh cookie
- `POST /auth/refresh`  
  Purpose: rotate refresh token and issue a new access token
- `POST /auth/logout`  
  Purpose: revoke refresh token and clear refresh cookie

### 10.2 Customer Routes (Role: CUSTOMER)

- `GET /customer/accounts`
- `GET /customer/transactions`
- `GET /customer/profile`
- `POST /customer/transfer`
- `POST /customer/applyLoan`
- `GET /customer/getLoans`

### 10.3 Employee Routes (Role: EMPLOYEE unless noted)

- `GET /employee/customers` (EMPLOYEE, MANAGER accepted by route)
- `POST /employee/accounts` (EMPLOYEE, MANAGER accepted by route)
- `POST /employee/onboard-customer`
- `GET /employee/dashboard-summary`
- `GET /employee/profile`
- `GET /employee/transactions`
- `POST /employee/withdrawal`
- `POST /employee/deposit`
- `GET /employee/pendingLoans`
- `POST /employee/:loanId/decision`

Naming correction decision:

- Correct endpoint names are `deposit` and `withdrawal`.
- All modules and documentation now use these standardized names consistently.

### 10.4 Manager Routes (Role: MANAGER)

- `GET /manager/dashboard-summary`
- `GET /manager/employees`
- `GET /manager/customers`
- `GET /manager/transactions`
- `GET /manager/pendingLoans`
- `POST /manager/:loanId/decision`
- `GET /manager/loans`

### 10.5 Protected Demo Routes

- `GET /protected/profile`
- `GET /protected/manager-only`

---

## 11. Data Model and Database Design

### 11.1 Core Tables

- `users`
- `roles`
- `branches`
- `customers`
- `employees`
- `accounts`
- `transactions`
- `loan_requests`
- `loan_status_history`
- `refresh_tokens` (active table used for refresh-token rotation and revocation)

### 11.2 Key Relationships

- `users.role_id -> roles.role_id`
- `users.branch_id -> branches.branch_id`
- `customers.user_id -> users.user_id`
- `employees.user_id -> users.user_id`
- `employees.manager_id -> employees.employee_id` (self-reference)
- `accounts.customer_id -> customers.customer_id`
- `transactions.from_account_id -> accounts.account_id` (to_account not explicitly FK-enforced in script)
- `loan_requests.customer_id -> customers.customer_id`
- `loan_requests.branch_id -> branches.branch_id`
- `loan_requests.employee_id -> employees.employee_id`
- `loan_requests.manager_id -> employees.employee_id`
- `loan_status_history.loan_id -> loan_requests.loan_id`
- `loan_status_history.changed_by_user_id -> users.user_id`

### 11.3 Financial Procedures

- `add_money(account_id, amount, description)`
- `remove_money(account_id, amount, description)`
- `transfer_money(from_account_id, to_account_id, amount, description)`

These procedures encapsulate transaction logging and balance updates in DB transactions.

### 11.4 Loan Governance Triggers

- `loan_requests_status_guard` (valid transition enforcement)
- `loan_requests_after_insert_history`
- `loan_requests_after_update_history`

### 11.5 Seeded Dataset Highlights

- 7 branches (`BR001` to `BR007`)
- Role master values: CUSTOMER, EMPLOYEE, MANAGER
- Large seeded population of users/customers/accounts for branch coverage
- Manager and employee records per branch

---

## 12. Frontend Feature Map

### 12.1 Shared Frontend Utilities

- `config.js`: API URL resolver (`getApiUrl`)
- `auth.js`:
  - basic global fetch wrapper for auth
  - single refresh attempt on `401`
  - session-expired redirect flow
  - page protection
  - logout

### 12.2 Login Module

- `login.js` handles:
  - credential submit
  - session storage
  - role redirect
  - one-time session-expired message display

### 12.3 Customer Dashboard Module

- Section switching and nav highlighting
- Profile bootstrap and greeting
- Accounts rendering
- Transfer validation + submit
- Transactions view with running balance context
- Loan apply + loan status table
- Profile read-only panel

### 12.4 Employee Dashboard Module

- Branch summary and profile load
- Branch customer table
- Branch transactions with filters + pagination
- Cash desk deposit/withdraw forms
- Customer onboarding flow
- Loan queue with approve/reject actions

### 12.5 Manager Dashboard Module

- Branch summary cards
- Employee and customer listings
- Branch transactions with filters + pagination
- Pending loan queue decisions
- Full branch loan list with statuses/comments

---

## 13. User Stories and Acceptance Criteria

### 13.1 Epic A: Authentication and Access

US-A1  
As a system user, I want to log in with username and password so that I can access my dashboard.

Acceptance criteria:

- Valid credentials return token and role.
- Invalid credentials return a clear error.
- User is redirected to correct dashboard by role.

US-A2  
As a user, I want my session to expire automatically so that inactive sessions are not indefinitely valid.

Acceptance criteria:

- Token expires at configured TTL (1 hour).
- Expired token causes protected API to return 401.
- Frontend redirects to login with session-expired message.

US-A3  
As the system, I want role checks on every protected endpoint so that users cannot access unauthorized modules.

Acceptance criteria:

- Customer cannot access employee/manager APIs.
- Employee cannot access manager-only APIs.
- Unauthorized role returns 403.

### 13.2 Epic B: Customer Banking

US-B1  
As a customer, I want to view all my accounts so that I can track balances.

Acceptance criteria:

- Accounts API returns only authenticated customer accounts.
- Dashboard renders account cards with type, number, and balance.

US-B2  
As a customer, I want to transfer money so that I can send funds.

Acceptance criteria:

- Form validates required inputs and positive amount.
- Same-account transfer is blocked.
- Insufficient balance is rejected.
- Successful transfer updates backend balances and transaction records.

US-B3  
As a customer, I want to view transaction history so that I can audit my activity.

Acceptance criteria:

- Transactions include date/time, direction, amount, and parties.
- Empty-state message appears if no data.

US-B4  
As a customer, I want to view my profile so that I can verify personal/branch data.

Acceptance criteria:

- Profile shows name, username, email, phone, branch, and branch address.

US-B5  
As a customer, I want to request a loan so that I can initiate credit processing.

Acceptance criteria:

- Amount and tenure are mandatory.
- Request is recorded as `REQUESTED`.
- User can track status changes in loan list.

### 13.3 Epic C: Employee Branch Operations

US-C1  
As an employee, I want branch summary stats so that I can monitor current branch health.

Acceptance criteria:

- Summary shows total customers and branch balance.

US-C2  
As an employee, I want to view branch customers so that I can assist them at the desk.

Acceptance criteria:

- Table lists customer id, name, email, phone for my branch.

US-C3  
As an employee, I want to onboard customers so that new customers can start using banking services.

Acceptance criteria:

- Mandatory fields are validated.
- User + customer created in a transaction.
- Optional account creation supported.

US-C4  
As an employee, I want to create accounts for existing customers so that branch can open additional account types.

Acceptance criteria:

- Customer must belong to employee branch.
- Account number is generated uniquely.
- Opening balance cannot be negative.

US-C5  
As an employee, I want to perform cash deposits and withdrawals so that branch counter operations are supported.

Acceptance criteria:

- Deposit and withdraw endpoints call DB procedures.
- Invalid amounts are blocked.
- Balance update and transaction log occur atomically.

US-C6  
As an employee, I want branch-wide transaction search so that I can investigate activity.

Acceptance criteria:

- Supports pagination.
- Optional filter by customer id and/or user id.

US-C7  
As an employee, I want to make initial loan decisions so that manager reviews only vetted requests.

Acceptance criteria:

- Pending queue shows `REQUESTED` loans.
- Decision updates status to approved/rejected employee states.
- Optional comment is saved.

### 13.4 Epic D: Manager Oversight

US-D1  
As a manager, I want branch dashboard metrics so that I can monitor branch operations.

Acceptance criteria:

- Summary shows employees/customers/accounts/balance and branch identity.

US-D2  
As a manager, I want to view employees and customers so that I can manage branch resources.

Acceptance criteria:

- Employee and customer tables return branch-scoped lists.

US-D3  
As a manager, I want branch transaction visibility with filters so that I can perform operational and compliance checks.

Acceptance criteria:

- Pagination and filters are supported.

US-D4  
As a manager, I want final loan decision control so that high-impact approvals are governed.

Acceptance criteria:

- Only employee-approved loans are in manager pending queue.
- Manager decision sets final state.
- On manager approval, loan amount is credited to customer active account.

US-D5  
As a manager, I want full loan history view so that I can track status and comments across lifecycle.

Acceptance criteria:

- All branch loans listed with status, updated time, and latest comments.

### 13.5 Epic E: Data Integrity and Auditability

US-E1  
As the system, I want transaction procedures for money movement so that balance updates and logs stay consistent.

Acceptance criteria:

- Deposit/withdraw/transfer use DB transactions.

US-E2  
As the system, I want loan status transition guards so that invalid state changes are blocked.

Acceptance criteria:

- Trigger denies illegal transition paths.

US-E3  
As auditor, I want loan status history so that every transition is traceable.

Acceptance criteria:

- Insert/update triggers write history rows with role, from/to status, and comment.

---

## 14. Functional Requirements (FR)

FR-01: System must authenticate users with username/password.  
FR-02: System must issue JWT token with role and branch scope.  
FR-03: All protected APIs must validate JWT and role.  
FR-04: Customer must view own accounts.  
FR-05: Customer must transfer funds to target account.  
FR-06: Customer must view transaction history.  
FR-07: Customer must submit and track loan requests.  
FR-08: Employee must view branch summary and profile.  
FR-09: Employee must list branch customers.  
FR-10: Employee must onboard customers with optional account creation.  
FR-11: Employee must create additional customer accounts.  
FR-12: Employee must execute deposit and withdrawal operations.  
FR-13: Employee must review and decide first-stage loans.  
FR-14: Manager must view branch employees/customers/transactions.  
FR-15: Manager must approve/reject final loan stage.  
FR-16: Approved manager loans must trigger account credit transaction.  
FR-17: Loan history must be stored on creation and transitions.  
FR-18: System must support refresh-token rotation via HttpOnly cookie and logout-time revocation.

---

## 15. Non-Functional Requirements (NFR)

NFR-01 Security: Password hashing and signed short-lived JWT required.  
NFR-02 Data integrity: Monetary updates must be transaction-safe.  
NFR-03 Availability: Backend health endpoint for liveness checks.  
NFR-04 Performance: Paginated transaction endpoints for large datasets.  
NFR-05 Maintainability: Layered route/controller/service architecture.  
NFR-06 Usability: Role-specific dashboards with focused navigation.  
NFR-07 Auditability: Loan status history and transaction records retained.

---

## 16. Operations, Configuration, and Deployment

### 16.1 Runtime Environment Variables (Backend)

- `NODE_ENV`
- `PORT`
- `DB_HOST`
- `DB_USER`
- `DB_PASSWORD`
- `DB_NAME`
- `DB_PORT`
- `JWT_SECRET`
- `REFRESH_TOKEN_SECRET`

### 16.2 Current CORS Configuration

Configured allowed origins include:

- `http://localhost:5500`
- `http://127.0.0.1:5500`
- `https://bankingapplicationfrontend.vercel.app`

### 16.3 Deployment Assets

- `render.yaml`
- `deployment report.md` (final and only authoritative deployment document)
- Other deployment markdown files are superseded and not considered final.

---

## 17. Current Quality Status

### 17.1 Strengths

- Practical end-to-end flow is implemented for all major roles.
- Clear separation of concerns in backend.
- Stored procedures and DB triggers increase integrity for critical workflows.
- Frontend has clear role-specific modules and sectioned UX.

### 17.2 Limitations

- No automated tests in backend (`npm test` placeholder only).
- No frontend automated tests.
- No linting/type-check gate.

---

## 18. Risk Register and Mitigations

### R1: DB/Deployment mismatch risk

Observation:

- Backend uses MySQL (`mysql2`) and MySQL SQL script.
- `render.yaml` declares `pspg` (PostgreSQL service type).

Impact:

- Deployment failure or runtime DB incompatibility.

Mitigation:

- Use MySQL-compatible managed service or migrate backend and SQL to PostgreSQL.

### R2: Cross-site cookie compatibility risk

Observation:

- Refresh flow depends on browser acceptance of cross-site cookies (`SameSite=None; Secure`) between frontend and API domains.

Impact:

- Silent refresh can fail for users with strict third-party cookie blocking.

Mitigation:

- Keep access-token fallback handling in frontend and consider same-site domain strategy or token binding alternatives.

### R3: API naming drift risk (v1 naming policy finalized)

Observation:

- Current production API uses `POST /employee/deposit` and `POST /employee/withdrawal`.
- Naming policy for v1 is now explicitly frozen in this report to prevent integration ambiguity.

Impact:

- Future unplanned renaming can break existing client integrations.

Mitigation:

- Keep current v1 endpoints stable.
- If naming changes are introduced later, do it via explicit API versioning and compatibility support.

### R4: Account type mismatch

Observation:

- Service allows `SALARY` in one account creation path.
- DB `accounts.account_type` enum is `SAVINGS|CURRENT` in schema.

Impact:

- Runtime SQL failure on unsupported value.

Mitigation:

- Align service validation with DB enum or extend DB enum consistently.

### R5: Limited security hardening

Observation:

- No login throttling, no MFA, no IP/device anomaly checks.

Impact:

- Elevated brute-force or session abuse risk.

Mitigation:

- Add rate limiting, optional MFA, and enhanced auth telemetry.

---

## 19. Recommended Improvement Backlog

### 19.1 High Priority

1. Resolve deployment DB mismatch (MySQL vs PostgreSQL declaration).
2. Add automated tests for critical money and loan flows.
3. Add API contract regression checks to enforce the v1 naming policy.
4. Align account type validation with schema.

### 19.2 Medium Priority

1. Add centralized request/response validation layer.
2. Add structured logging and request correlation ids.
3. Add audit trail endpoint set for manager/compliance views.
4. Add role-based UI guards for all edge cases and route fallback handling.

### 19.3 Lower Priority

1. Improve dashboard analytics visuals.
2. Add notification hooks (email/SMS).
3. Add export features for transaction/loan reporting.

---

## 20. Suggested Testing Strategy

### 20.1 Unit Tests

- Services:
  - auth credential checks
  - loan decision status mapping
  - onboarding transaction rollback behavior

### 20.2 Integration Tests

- Auth + protected endpoints
- Transfer/deposit/withdraw against test DB
- Loan status transitions and trigger outcomes

### 20.3 End-to-End Tests

- Customer login -> account view -> transfer -> transaction visible
- Employee onboarding -> customer appears -> account exists
- Employee decision -> manager decision -> disbursal visible

### 20.4 Regression Checklist

- Role authorization matrix
- Session expiration redirect flow
- Pagination/filtering on transaction endpoints

---

## 21. Observability Recommendations

- API request logs with method/path/status/latency
- Error logs with stack and request context
- DB operation timing for heavy queries
- Health endpoint monitoring and alerting

---

## 22. Compliance and Audit Considerations

Already present:

- Loan status history trail
- Transaction record creation for money operations
- Role-scoped access controls

To strengthen:

- Immutable audit event stream
- Privileged action logs with actor metadata
- Data retention and archival policy

---

## 23. API and Data Governance Notes

- v1 naming policy is fixed and documented in this report:
  - `POST /employee/deposit`
  - `POST /employee/withdrawal`
- Treat the above as stable production contract for v1 clients.
- Apply strict versioning before any future endpoint renaming.
- Version public APIs before breaking changes.
- Maintain migration scripts alongside schema changes.
- Formalize seed data policy for non-production vs production.

---

## 24. Project Metrics Snapshot (Current Implementation)

- Roles supported: 3
- Backend route groups: 5
- Total endpoints exposed: 29
- Service modules: 5
- Controller modules: 4
- Frontend role dashboards: 3
- Database tables: 10
- Financial procedures: 3
- Loan triggers: 3

---

## 25. Detailed API Contract Summary

### 25.1 Authentication

- Request:
  - `POST /auth/login`
  - Body: `{ username, password }`
- Success response:
  - `{ message, token, role }`
  - Sets HttpOnly refresh cookie (`refreshToken`)
- Refresh request:
  - `POST /auth/refresh`
  - Cookie: `refreshToken` (HttpOnly)
  - Success: `{ message, token, role }` + rotated refresh cookie
- Logout request:
  - `POST /auth/logout`
  - Cookie: `refreshToken` (HttpOnly)
  - Success: `{ message }` + cookie cleared
- Error response:
  - `401` with `{ message }`

### 25.2 Customer Transfer

- Request:
  - `POST /customer/transfer`
  - Body: `{ fromId, toId, amount, desc }`
- Success:
  - `201` and success message
- Backend processing:
  - Calls `transfer_money` procedure

### 25.3 Employee Cash Desk

- Deposit:
  - `POST /employee/deposit`
  - Body: `{ toId, amount, desc }`
  - Procedure: `add_money`
- Withdraw:
  - `POST /employee/withdrawal`
  - Body: `{ fromId, amount, desc }`
  - Procedure: `remove_money`

### 25.4 Loan Decision Contracts

- Employee decision:
  - `POST /employee/:loanId/decision`
  - Body: `{ action: "APPROVE"|"REJECT", comment }`
- Manager decision:
  - `POST /manager/:loanId/decision`
  - Body: `{ action: "APPROVE"|"REJECT", comment }`
- Manager approval includes automated account credit transaction.

---

## 26. UX Journey Summary by Role

### 26.1 Customer Journey

Login -> Accounts -> Transfer/Transactions/Loans/Profile -> Logout

### 26.2 Employee Journey

Login -> Branch Summary -> Customer servicing (customers/cash desk/onboard) -> Loan queue -> Profile -> Logout

### 26.3 Manager Journey

Login -> Branch Summary -> Team/customer visibility -> Transaction oversight -> Loan approvals -> Logout

---

## 27. Project Readiness Assessment

### 27.1 Prototype/MVP Readiness

Status: Strong MVP with meaningful end-to-end workflows.

### 27.2 Production Readiness

Status: Partial. Requires:

- Deployment alignment (DB engine)
- Automated testing
- Stronger auth/session hardening
- Operational monitoring baseline

---

## 28. Appendix A: Main Files Referenced

- Backend:
  - `backend/src/app.js`
  - `backend/src/routes/*.js`
  - `backend/src/controllers/*.js`
  - `backend/src/services/*.js`
  - `backend/src/middlewares/*.js`
  - `backend/src/utils/*.js`
  - `backend/package.json`
- Frontend:
  - `frontend/index.html`
  - `frontend/login.html`
  - `frontend/dashboards/*.html`
  - `frontend/js/*.js`
- Database and deploy:
  - `databse bank.sql`
  - `render.yaml`
  - `deployment report.md` (final deployment document)

---

## 29. Appendix B: Glossary

- JWT: JSON Web Token
- RBAC: Role-Based Access Control
- TTL: Time To Live (token expiry)
- API: Application Programming Interface
- MVP: Minimum Viable Product
- DB: Database

---

## 30. Closing Note

This implementation already demonstrates a complete role-driven banking workflow with branch-aware logic, monetary transaction safety, and multi-stage loan governance. With targeted improvements in deployment consistency, testing, and security hardening, it can progress from robust MVP to production-grade platform.
