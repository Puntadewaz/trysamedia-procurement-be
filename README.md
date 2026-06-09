# CPIP Backend

CPIP (Corporate Project Intelligence Platform) backend scaffold.

## Stack

- Golang 1.24+
- Fiber v3
- PostgreSQL
- pgx
- sqlc
- Goose

## Run

```bash
go run ./cmd/server
```

## Docker

```bash
docker compose up --build
```

## Supabase configuration

Set these environment variables (local or Vercel):

- `SUPABASE_DB_URL` (preferred Postgres DSN from Supabase)
- `SUPABASE_URL` (project URL, e.g. `https://xxx.supabase.co`)
- `SUPABASE_ANON_KEY` (optional for client-side auth passthrough use cases)
- `SUPABASE_SERVICE_ROLE_KEY` (server-side privileged operations; keep secret)

If `SUPABASE_DB_URL` is set, it is used instead of `DATABASE_URL`.

Integration status endpoint:

- `GET /api/v1/integrations/supabase/status`

## Deploy to Vercel

This repository includes `vercel.json` and a serverless handler at `api/index.go`.

Vercel cannot import Go `internal/` packages from `api/`. Bootstrap lives in `pkg/app` for that reason.
The handler uses `adaptor.FiberApp` to bridge Fiber v3 (fasthttp) to `net/http`.

Important:
- Do **not** set a custom Start Command to `cmd/server` on Vercel.
- Do **not** set `HTTP_ADDR` in Vercel env (it overrides the platform `PORT` for server mode).
- Vercel should deploy `api/index.go` as a serverless function (see `vercel.json`).

Required Vercel environment variables:

- `SUPABASE_DB_URL` (or `DATABASE_URL`)
- `JWT_ISSUER`
- `JWT_AUDIENCE`
- `JWT_ACCESS_SECRET`
- `JWT_REFRESH_SECRET`
- Optional: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`

## API Base

`/api/v1`

## Health

- `GET /healthz`
- `GET /readyz`

If you see `Cannot GET /healthz`, the CPIP server is usually **not** the process on that port.
Check for a stale `server.exe` or another app (for example NVIDIA Broadcast) using `:8080`.

```powershell
# Windows: find and stop process on 8080
Get-NetTCPConnection -LocalPort 8080 | Select-Object OwningProcess
Stop-Process -Id <PID> -Force

# Or run on another port
$env:HTTP_ADDR=":8081"
go run ./cmd/server
```

## OpenAPI

`docs/openapi.yaml`

## Migrations

`migrations/00001_init.sql`
