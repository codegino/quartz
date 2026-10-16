---
title: Get an OpenRouter API key for embeddings
---
## Why OpenRouter
- One key, many providers. OpenAI, Google, Mistral, Qwen, etc. embedding models sit behind one **OpenAI-compatible** endpoint.
- Switching provider = changing the model string, not signing up somewhere new.
- Model ids are namespaced by provider: `openai/text-embedding-3-small`, not `text-embedding-3-small`.

## Create the account
1. Go to https://openrouter.ai and sign in (Google/GitHub/email).
2. No ChatGPT/OpenAI account needed. OpenRouter bills you itself.

## Add credit
1. **Settings → Credits → Add credits**.
2. It is **prepaid**. Add a few dollars; $5 lasts a very long time for embeddings.
3. Model prices are passed through from the provider; OpenRouter charges a small fee when you buy credits.

> Without credit, requests come back `402`. It is not a rate limit, it is an empty balance.

## Create the key
1. **Settings → API Keys → Create key**.
2. Name it after the project (`todo-ai-search`) so you can revoke it in isolation.
3. Recommended: set a **credit limit** on the key so a runaway loop cannot drain the whole balance.
4. Copy it now. `sk-or-v1-...` is shown exactly once.

```sh
# .env — never commit this
OPENROUTER_API_KEY="sk-or-v1-..."
```

Make sure `.env*` is in `.gitignore`. If a key leaks, delete it in the dashboard; it dies instantly.

## Pick an embedding model
Browse https://openrouter.ai/models?output_modalities=embeddings

| Model | Dimensions | Relative cost | Use when |
| --- | --- | --- | --- |
| `openai/text-embedding-3-small` | 1536 | cheapest | default, good enough for most search |
| `openai/text-embedding-3-large` | 3072 | ~6.5x | you have measured that `small` is not good enough |

- The dimension count becomes part of your DB schema (`vector(1536)`).
- Other providers' models have different dimensions. Check before you write the migration.
- Vectors from different models are **not comparable**. Switching model means re-embedding everything.

## Smoke test the key
```sh
curl https://openrouter.ai/api/v1/embeddings \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"openai/text-embedding-3-small","input":"buy ice"}' \
  | head -c 300
```

You should get `{"object":"list","data":[{"object":"embedding","index":0,"embedding":[0.02...`.

Batch form, one round trip, many inputs:

```sh
-d '{"model":"openai/text-embedding-3-small","input":["buy ice","order the cake"]}'
```

Each result carries its `index`. Sort by it rather than trusting response order.

## Notes / gotchas
- **No SDK needed.** Embeddings are one `POST`; `fetch` is enough. The `openai` SDK also works if you set `baseURL: "https://openrouter.ai/api/v1"`.
- Forgetting the `openai/` prefix on the model id is the most common first error.
- Errors worth recognising:
	- `401` — bad or deleted key.
	- `402` — out of credits (account or the key's credit limit).
	- `429` — rate limited, back off and retry.
	- `502`/`503` — upstream provider is down or no provider is available for that model.
- Always set a timeout (`AbortSignal.timeout(10_000)`), a hung provider should not pin a request open.
- Embeddings are **deterministic-ish and cacheable**. Same text + same model = same vector. Do not re-embed unchanged text.
- Cost scale: embedding a few thousand short strings with `3-small` is cents, not dollars.
- Usage per key is visible under **Activity**.

## Links
- https://openrouter.ai/settings/keys
- https://openrouter.ai/settings/credits
- https://openrouter.ai/docs/api/reference/embeddings
- https://openrouter.ai/models?output_modalities=embeddings
- [[Get an OpenAI API key for embeddings]] — calling OpenAI directly instead
