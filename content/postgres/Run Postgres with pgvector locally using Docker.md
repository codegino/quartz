---
title: Run Postgres with pgvector locally using Docker
---

## Links
- https://hub.docker.com/r/pgvector/pgvector
- https://github.com/pgvector/pgvector
- https://hub.docker.com/_/postgres

## The trap
```sh
docker run postgres:17   # ❌ no vector extension
```
Stock `postgres` images do not ship `pgvector`. `create extension vector` fails with:

```txt
ERROR: could not open extension control file ".../vector.control": No such file or directory
```

Use the image that has it compiled in. The tag encodes the Postgres major version:

```sh
docker run pgvector/pgvector:pg17   # ✅
```

## One-liner
```sh
docker run --name pgvector \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=todos \
  -p 5432:5432 \
  -v pgvector-data:/var/lib/postgresql/data \
  -d pgvector/pgvector:pg17
```

```sh
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/todos"
```

The named volume is what keeps your data across `docker rm`. Without it, every container recreate is a fresh empty database.

## Compose (preferred)
```yaml
# compose.yml
services:
  db:
    image: pgvector/pgvector:pg17
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: todos
    ports:
      - '5432:5432'
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init:/docker-entrypoint-initdb.d
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U postgres -d todos']
      interval: 5s
      retries: 10

volumes:
  pgdata:
```

```sql
-- init/001-vector.sql — runs automatically on FIRST boot only
create extension if not exists vector;
```

```sh
docker compose up -d
```

> `/docker-entrypoint-initdb.d` scripts only run when the data directory is empty. Changed them? `docker compose down -v` and start again.

## Enable and verify manually
```sh
docker exec -it pgvector psql -U postgres -d todos
```
```sql
create extension if not exists vector;
select extname, extversion from pg_extension where extname = 'vector';
```

## Sanity check it works
```sql
create table items (id serial primary key, embedding vector(3));
insert into items (embedding) values ('[1,2,3]'), ('[4,5,6]');

select id, embedding <=> '[3,1,2]' as distance
from items
order by distance;
```

If that returns two rows with distances, your local setup is equivalent to Supabase for everything the app needs.

## Notes / gotchas
- `pgvector` is an **extension, not a database**. Enable it per database — a second DB in the same container needs its own `create extension`.
- Port `5432` clashes with a native Postgres install. Map `-p 5433:5432` and use `5433` in the URL if so.
- From another container use the service name (`db`), not `localhost`.
- Arm Macs are fine; the image is multi-arch.
- Migrations should contain `create extension if not exists vector;` so prod and local stay identical.
- Add the index only when the row count justifies it:
  ```sql
  create index on items using hnsw (embedding vector_cosine_ops);
  ```
- Alpine variant exists (`pgvector/pgvector:pg17-alpine`) if image size matters.
- Backups: `docker exec pgvector pg_dump -U postgres todos > dump.sql`. Vector columns dump as plain text, nothing special needed.
