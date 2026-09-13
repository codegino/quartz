---
title: Alternatives to OpenAI embeddings
---
An embedding model is a function `text -> number[]`. Swapping providers changes three things and nothing else:

1. The **HTTP call** (or the lack of one).
2. The **dimension count**, which is baked into your schema (`vector(1536)`).
3. The **vectors already in your database**, which are now stale.

> Vectors from different models are not comparable. Changing model = re-embedding every row. Have a backfill/re-embed endpoint before you start shopping.

Everything else — cosine distance, `order by`, the cutoff — is unchanged.

## Hosted APIs (drop-in replacements)
| Provider | Model | Dimensions | Notes |
| --- | --- | --- | --- |
| OpenAI | `text-embedding-3-small` | 1536 | the default baseline |
| Google | `gemini-embedding-001` | 3072 (truncatable) | generous free tier |
| Voyage AI | `voyage-3.5-lite` | 1024 | strong retrieval scores, code/legal variants |
| Cohere | `embed-v4.0` | 1536 | has `input_type` for query vs document |
| Mistral | `mistral-embed` | 1024 | EU hosted |
| Jina | `jina-embeddings-v3` | 1024 | long input, multilingual |

All of them are a single `POST` with a JSON body. Only the URL, the header, and the response path change:

```ts
// Google
const res = await fetch(
  `https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=${process.env.GEMINI_API_KEY}`,
  {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
      content: {parts: [{text}]},
      outputDimensionality: 1536,
    }),
  },
);
const {embedding} = await res.json();
return embedding.values;
```

> Some providers (Cohere, Voyage, Jina) distinguish **query** embeddings from **document** embeddings via an `input_type` field. If you use it, you must use it consistently — a query embedded as a document will quietly rank worse.

## Free / self-hosted
### Ollama (local server, zero cost)
```sh
ollama pull nomic-embed-text     # 768 dims
```
```ts
const res = await fetch('http://localhost:11434/api/embed', {
  method: 'POST',
  body: JSON.stringify({model: 'nomic-embed-text', input: text}),
});
const {embeddings} = await res.json();
return embeddings[0];
```
Good models: `nomic-embed-text` (768), `mxbai-embed-large` (1024), `bge-m3` (1024, multilingual).

### Transformers.js (in-process, no server)
```ts
import {pipeline} from '@huggingface/transformers';

const extractor = await pipeline(
  'feature-extraction',
  'Xenova/all-MiniLM-L6-v2', // 384 dims, ~90MB
);

const output = await extractor(text, {pooling: 'mean', normalize: true});
return Array.from(output.data);
```
Runs in Node **and** in the browser. No API key, no network, no per-request cost. First call downloads and caches the model. Cold starts make this a poor fit for serverless.

### Supabase Edge Functions
`gte-small` (384 dims) runs inside the edge runtime with `Supabase.ai.Session` — embeddings without leaving your existing stack.

## Choosing
- **Just shipping?** OpenAI `text-embedding-3-small`. Cheapest path to working.
- **Want zero cost / no vendor?** Ollama locally, Transformers.js if you want it in-process.
- **Privacy or offline requirement?** Self-hosted is the only option — text leaves your machine with every hosted API.
- **Quality matters and you can measure it?** Check the MTEB leaderboard for your language and task, then A/B it on *your* data.
- **Non-English content?** `bge-m3`, `jina-v3`, or `gemini-embedding-001`. Do not assume the English default transfers.

## Gotchas
- Smaller dimensions = smaller table and faster search. 384-dim local models are often good enough for short text like todo titles.
- Local models cost latency instead of money: expect tens of ms per embedding on CPU, versus a network round trip.
- Your similarity cutoff (`0.6` or whatever you tuned) is **per model**. Re-tune it after a swap.
- Benchmark scores are about long documents. Short strings behave differently — trust your own spot checks over a leaderboard.


## Links
- https://huggingface.co/spaces/mteb/leaderboard
- https://sbert.net/
- https://github.com/xenova/transformers.js
- https://ollama.com/search?c=embedding
- https://docs.voyageai.com/docs/embeddings
- https://docs.cohere.com/docs/embeddings
- https://ai.google.dev/gemini-api/docs/embeddings