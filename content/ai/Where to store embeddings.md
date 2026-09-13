---
title: Where to store embeddings
---
A vector store does three things:

1. Keeps a list of floats next to an id.
2. Measures the **distance** between a query vector and the stored ones.
3. Returns the nearest rows, ideally fast, ideally with a filter applied.

> If your data already lives in a database, start there. A separate vector database is a second system to deploy, sync, back up, and keep consistent. That cost is real and it is paid every day.

Everything else — the embedding call, the dimension count, the similarity cutoff — is unchanged no matter what you store the vectors in.

## Inside a database you already have
| Store | How | Notes |
| --- | --- | --- |
| Postgres | [`pgvector`](https://github.com/pgvector/pgvector) | `vector` type, `<=>` operator, HNSW/IVFFlat indexes. The default answer. |
| SQLite | [`sqlite-vec`](https://github.com/asg017/sqlite-vec) | single file, runs anywhere, great for local and edge apps |
| MySQL 9 / MariaDB 11.7 | native `VECTOR` type | newer, fewer index knobs than pgvector |
| MongoDB Atlas | Atlas Vector Search | only on Atlas, not on self-hosted Mongo |
| Redis | Redis Query Engine | in-memory, very fast, you must think about persistence |
| Elasticsearch / OpenSearch | `dense_vector` / k-NN | worth it if you are already running it for keyword search — hybrid search comes free |
| ClickHouse / DuckDB | vector distance functions | analytics-shaped workloads, brute force over columns |

The win is boring and large: one connection string, one backup, and your `where user_id = ...` filter is a normal SQL filter over the same table.

## Dedicated vector databases
| Store | Hosting | Notes |
| --- | --- | --- |
| Qdrant | self-host or cloud | Rust, strong filtering, easy Docker start |
| Weaviate | self-host or cloud | built-in embedding modules, hybrid search |
| Milvus | self-host or Zilliz cloud | built for billions of vectors, heavy to operate |
| Chroma | local / embedded | prototyping favourite, `pip install` and go |
| Pinecone | managed only | zero ops, serverless pricing, no self-host escape hatch |
| LanceDB | embedded files | columnar on-disk format, nice for local AI apps |
| Vespa | self-host or cloud | ranking-heavy search, steepest learning curve |
| pgvector-backed platforms | Supabase, Neon, Timescale | still Postgres, just someone else's problem |

These earn their keep at scale: tens of millions of vectors, heavy write throughput, or when you need index tuning that a general database will not give you.

## Choosing
- **Already on Postgres?** `pgvector`. Stop shopping.
- **Local, offline, or single-file app?** `sqlite-vec` or LanceDB.
- **Already running Elasticsearch/OpenSearch?** Use it — you get keyword and vector in one query.
- **Tens of millions of vectors, or vector search *is* the product?** Qdrant, Milvus, or Pinecone.
- **Do not want to run anything?** Pinecone, or a hosted Postgres with pgvector.

> A good rule of thumb: under ~1M vectors, a general-purpose database is almost never the bottleneck. Your embedding API call is slower than the query.

## Gotchas
- **An index is not free accuracy.** HNSW and IVFFlat are *approximate*. You trade recall for speed, and the knobs (`m`, `ef_search`, `lists`, `probes`) must be tuned per dataset.
- **Filtered vector search is the hard part.** "Nearest 20 todos *belonging to me*" can return fewer than 20 rows, because the index finds global neighbours first and the filter throws them away afterwards. Every store solves this differently — check before you commit.
- **Dimensions are schema.** `vector(1536)` is a decision. Changing models means a migration plus re-embedding every row.
- **Two systems means two sources of truth.** If vectors live outside your main database, deletes and updates now need to happen in both. This is where most bugs come from.
- **Normalise once, decide the metric once.** Cosine, inner product, and L2 give different rankings. Pick one and keep it consistent between write and query.

## Links
- https://github.com/pgvector/pgvector
- https://github.com/asg017/sqlite-vec
- https://qdrant.tech/documentation/
- https://weaviate.io/developers/weaviate
- https://docs.pinecone.io/
- https://milvus.io/docs
- https://lancedb.github.io/lancedb/
