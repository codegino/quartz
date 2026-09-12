---
title: Create a Supabase project and enable pgvector
---

## Links
- https://supabase.com/dashboard
- https://supabase.com/docs/guides/database/extensions/pgvector
- https://github.com/pgvector/pgvector

## Why Supabase
- Managed Postgres with `pgvector` already shipped — you only need to enable it.
- Free tier is enough for demos and side projects.
- If you self-host instead, use the `pgvector/pgvector:pg17` image. Stock `postgres:17` does **not** have the extension.

## Create the account
1. Go to https://supabase.com and click **Start your project**.
2. Sign in with GitHub (fastest) or email.
3. Create an organisation when prompted — name it anything, plan **Free**.

## Create the project
1. **New project** inside the organisation.
2. Fill in:
	- **Name** — e.g. `todo-ai-search`
	- **Database password** — generate one and save it in a password manager. It is part of the connection string and it is not shown again.
	- **Region** — pick the one closest to where the app runs, not where you live.
3. **Create new project** and wait ~2 minutes for provisioning.

## Get the connection string
1. Project → **Connect** (top bar).
2. Choose the tab that matches your setup:
	- **Transaction pooler** (port `6543`) — serverless / edge / Vercel.
	- **Session pooler** (port `5432`) — long-lived Node processes, migrations.
	- **Direct connection** — IPv6 only, usually not what you want.
3. Replace `[YOUR-PASSWORD]` with the database password from above.

```sh
# .env.local
DATABASE_URL="postgresql://postgres.xxxx:PASSWORD@aws-0-region.pooler.supabase.com:6543/postgres"
```

> Watch the port. Copying the string from the wrong tab is the most common "it works locally, not in prod" bug.

## Enable pgvector
Two ways, pick either.

**SQL editor** (project → SQL Editor → New query):

```sql
create extension if not exists vector;
```

**Dashboard**: Database → Extensions → search `vector` → toggle on.

Verify:

```sql
select extname, extversion from pg_extension where extname = 'vector';
```

## Add a vector column
```sql
-- 1536 = output width of OpenAI text-embedding-3-small.
-- The number must match your embedding model exactly.
alter table todos add column if not exists embedding vector(1536);
```

- Keep it **nullable**. Existing rows have no vector, and new rows are usually embedded just after insert.
- Add an index only when you have tens of thousands of rows:
  ```sql
  create index on todos using hnsw (embedding vector_cosine_ops);
  ```
  HNSW is approximate — it trades recall for speed.

## Notes / gotchas
- Free projects **pause after ~1 week of inactivity**. Restore them from the dashboard.
- The `service_role` key bypasses row level security. Server-side only, never in the browser.
- Changing embedding model = changing the column width = re-embedding every row. Plan a backfill endpoint from day one.
