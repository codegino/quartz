---
title: Get an OpenAI API key for embeddings
---

## Links
- https://platform.openai.com/api-keys
- https://platform.openai.com/docs/guides/embeddings
- https://platform.openai.com/docs/api-reference/embeddings
- https://openai.com/api/pricing/

## Create the account
1. Go to https://platform.openai.com and sign up (Google/GitHub/email).
2. **The API platform is billed separately from ChatGPT Plus.** A Plus subscription gives you zero API credits.
3. Verify your phone number — required before a key can be created.

## Add credit
1. **Settings → Billing → Add payment method**.
2. Add credits (minimum is a few dollars; $5 lasts a very long time for embeddings).
3. Optional but recommended: **Usage limits** → set a hard monthly cap so a runaway loop cannot drain the card.

> Without credit, every request comes back `429 insufficient_quota`. It is not a rate limit, it is an empty balance.

## Create the key
1. **Settings → API keys → Create new secret key**.
2. Name it after the project (`todo-ai-search`) so you can revoke it in isolation.
3. Optional: restrict permissions to **Model capabilities** only.
4. Copy it now — `sk-...` is shown exactly once.

```sh
# .env.local — never commit this
OPENAI_API_KEY="sk-proj-..."
```

Make sure `.env*.local` is in `.gitignore`. If a key leaks, revoke it in the dashboard; it dies instantly.

## Pick an embedding model
| Model | Dimensions | Relative cost | Use when |
| --- | --- | --- | --- |
| `text-embedding-3-small` | 1536 | cheapest | default, good enough for most search |
| `text-embedding-3-large` | 3072 | ~6.5x | you have measured that `small` is not good enough |

- The dimension count becomes part of your DB schema (`vector(1536)`).
- `dimensions` in the request body can shorten the output (e.g. 512) — but shortened vectors are only comparable to other shortened vectors.

## Smoke test the key
```sh
curl https://api.openai.com/v1/embeddings \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"text-embedding-3-small","input":"buy ice"}' \
  | head -c 300
```

You should get `{"object":"list","data":[{"object":"embedding","index":0,"embedding":[0.02...`.

Batch form — one round trip, many inputs:

```sh
-d '{"model":"text-embedding-3-small","input":["buy ice","order the cake"]}'
```

Results come back in the same order as `input`, each with its `index`.

## Notes / gotchas
- **No SDK needed.** Embeddings are one `POST`; `fetch` is enough.
- Errors worth recognising:
	- `401` — bad or revoked key, or key from the wrong org/project.
	- `429 insufficient_quota` — no credit.
	- `429 rate_limit_exceeded` — actual rate limit, back off and retry.
- Always set a timeout (`AbortSignal.timeout(10_000)`), a hung provider should not pin a request open.
- Embeddings are **deterministic-ish and cacheable** — same text + same model = same vector. Do not re-embed unchanged text.
- Cost scale: embedding a few thousand short strings with `3-small` is cents, not dollars.
