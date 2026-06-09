# CPIP API Reference

Corporate Project Intelligence Platform (CPIP) REST API documentation.

## Quick links

| Resource | URL |
|----------|-----|
| Swagger UI | `GET /docs` |
| OpenAPI spec | `GET /docs/openapi.yaml` |
| Source spec | `docs/openapi.yaml` |

## Base URL

| Environment | Base |
|-------------|------|
| Local | `http://localhost:8080` |
| Production | `https://<your-host>` |

All business endpoints are prefixed with `/api/v1`.

## Authentication

### Public endpoints

No token required:

- `GET /healthz` — liveness
- `GET /readyz` — readiness (DB ping)
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`
- `POST /api/v1/auth/mfa/verify`

### Secured endpoints

Every secured request requires:

```http
Authorization: Bearer <access_token>
X-Tenant-ID: <tenant_uuid>
```

The access token is a JWT issued at login. The tenant header scopes all data to a single tenant.

### Login

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "admin@acme.com",
  "password": "your-password",
  "tenant_code": "acme"
}
```

Response envelope:

```json
{
  "success": true,
  "data": {
    "access_token": "...",
    "refresh_token": "...",
    "expires_in": 900
  }
}
```

## Response format

### Success

```json
{
  "success": true,
  "data": {},
  "meta": {
    "next_cursor": "optional-cursor-for-pagination"
  }
}
```

### Error

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Human-readable message"
  },
  "request_id": "uuid"
}
```

Common HTTP status codes: `400` validation, `401` unauthorized, `403` forbidden, `404` not found, `503` service unavailable.

## Pagination

List endpoints accept cursor-based pagination:

| Query | Type | Default | Max |
|-------|------|---------|-----|
| `cursor` | string | — | opaque cursor from previous response |
| `limit` | integer | 20 | 100 |

When more results exist, `meta.next_cursor` is returned. Pass it as `cursor` on the next request.

## Endpoints

### Health

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/healthz` | No | Liveness probe |
| GET | `/readyz` | No | Readiness probe (DB) |

### Auth

| Method | Path | Permission | Description |
|--------|------|------------|-------------|
| POST | `/api/v1/auth/login` | — | Login |
| POST | `/api/v1/auth/refresh` | — | Rotate refresh token |
| POST | `/api/v1/auth/logout` | — | Logout |
| POST | `/api/v1/auth/mfa/verify` | — | Verify TOTP |

### Users

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/users` | `iam.user.read` |
| POST | `/api/v1/users` | `iam.user.create` |
| GET | `/api/v1/users/{id}` | `iam.user.read` |
| PUT | `/api/v1/users/{id}` | `iam.user.update` |
| DELETE | `/api/v1/users/{id}` | `iam.user.delete` |

### Portfolios

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/portfolios` | `portfolio.read` |
| POST | `/api/v1/portfolios` | `portfolio.create` |
| GET | `/api/v1/portfolios/{id}` | `portfolio.read` |
| PUT | `/api/v1/portfolios/{id}` | `portfolio.update` |

### Projects

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/projects` | `project.read` |
| POST | `/api/v1/projects` | `project.create` |
| GET | `/api/v1/projects/{id}` | `project.read` |
| PUT | `/api/v1/projects/{id}` | `project.update` |
| DELETE | `/api/v1/projects/{id}` | `project.archive` |

### Financials

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/projects/{id}/financials` | `financial.read` |
| POST | `/api/v1/projects/{id}/financials` | `financial.create` |

### Resources

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/resources` | `resource.read` |
| POST | `/api/v1/resources` | `resource.create` |
| GET | `/api/v1/resources/allocations` | `resource.read` |

### Vendors

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/vendors` | `vendor.read` |
| POST | `/api/v1/vendors` | `vendor.create` |
| GET | `/api/v1/vendors/{id}` | `vendor.read` |

### Risks

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/risks` | `risk.read` |
| POST | `/api/v1/risks` | `risk.create` |
| PUT | `/api/v1/risks/{id}` | `risk.update` |

### Issues

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/issues` | `issue.read` |
| POST | `/api/v1/issues` | `issue.create` |

### Change requests

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/change-requests` | `change.read` |
| POST | `/api/v1/change-requests` | `change.create` |

### Governance

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/governance-reviews` | `governance.read` |
| POST | `/api/v1/governance-reviews` | `governance.create` |

### Imports

| Method | Path | Permission |
|--------|------|------------|
| POST | `/api/v1/imports` | `import.create` |
| GET | `/api/v1/imports/jobs` | `import.read` |
| GET | `/api/v1/imports/errors` | `import.read` |

### Analytics

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/analytics/executive-summary` | `analytics.read.executive` |
| GET | `/api/v1/analytics/portfolio-health` | `analytics.read.portfolio` |
| GET | `/api/v1/analytics/financial-performance` | `analytics.read.financial` |
| GET | `/api/v1/analytics/resource-utilization` | `analytics.read.resource` |
| GET | `/api/v1/analytics/risk-exposure` | `analytics.read.risk` |

### Reports

| Method | Path | Permission |
|--------|------|------------|
| POST | `/api/v1/reports/generate` | `report.generate` |
| GET | `/api/v1/reports` | `report.read` |
| GET | `/api/v1/reports/{id}` | `report.read` |

### Audit

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/audit-logs` | `audit.read` |

### Integrations

| Method | Path | Permission |
|--------|------|------------|
| GET | `/api/v1/integrations/supabase/status` | `integration.read` |

## Mock data (development)

After running seed migration `00002_seed_mock_data.sql`:

| Field | Value |
|-------|-------|
| Tenant ID | `11111111-1111-1111-1111-111111111111` |
| Tenant code | `acme` |
| Admin email | `admin@acme.com` |
| Portfolio code | `PORT-2026` |
| Project code | `PRJ-ALPHA` |

Use the tenant ID in the `X-Tenant-ID` header for secured calls.

## Example: list projects

```http
GET /api/v1/projects?limit=20
Authorization: Bearer eyJhbG...
X-Tenant-ID: 11111111-1111-1111-1111-111111111111
```

```json
{
  "success": true,
  "data": {
    "items": []
  },
  "meta": {
    "next_cursor": ""
  }
}
```
