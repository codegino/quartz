---
title: Counting tokens and cost for embeddings
---

## Links
- https://platform.openai.com/docs/guides/embeddings
- https://platform.openai.com/tokenizer
- https://github.com/openai/tiktoken
- https://github.com/dqbd/tiktoken
- https://openai.com/api/pricing/

## What you are actually billed for
Embedding APIs bill **input tokens only**. There is no output token cost, because the output is a vector, not text.

So the whole bill is:

```txt
total tokens = tokens(every row you embed) + tokens(every search query)
cost         = total tokens / 1_000_000 * price per 1M tokens
```

That is it. No per-request fee, no per-vector storage fee on the API side. Storage cost is your database's problem.

## A token is not a word
Rough rules for English:

- 1 token is about 4 characters
- 1 token is about 0.75 words
- 100 tokens is about 75 words

Short strings round badly. `"Laundry day"` is 3 tokens, not 2, because the tokenizer splits on pieces, not words.

Things that blow up the count:
- Non-English text, often 2 to 3 times more tokens for the same meaning
- Code, JSON, and UUIDs, which fragment into many tokens
- Emoji, which can be several tokens each

> Never estimate cost from `text.length / 4` on non-English or structured text. Count it.

## Counting exactly
The API response tells you after the fact:

```ts
const payload = await res.json();
payload.usage.prompt_tokens; // exact, per request
```

To count before sending, use the same tokenizer the model uses. OpenAI's `text-embedding-3-*` models use `cl100k_base`:

```ts
import {encoding_for_model} from 'tiktoken';

const enc = encoding_for_model('text-embedding-3-small');
const tokens = enc.encode('Purchase some apples').length; // 3
enc.free();
```

For a quick one-off, paste the text into the [tokenizer playground](https://platform.openai.com/tokenizer).

## Prices worth memorising
Per 1M input tokens, at the time of writing:

| Model | Dimensions | Price per 1M tokens |
| --- | --- | --- |
| `text-embedding-3-small` | 1536 | $0.02 |
| `text-embedding-3-large` | 3072 | $0.13 |
| `text-embedding-ada-002` | 1536 | $0.10 |

Check the pricing page before quoting these. The ratio is the useful part: `large` is roughly 6 times the price of `small` for a single digit percentage gain on most benchmarks.

## Worked examples
**A todo app.** 10,000 todos, average 8 tokens each.

```txt
10_000 * 8 = 80_000 tokens
80_000 / 1_000_000 * $0.02 = $0.0016
```

Backfilling the entire table costs less than a fifth of a cent. Searches are the same order: 10,000 searches at 3 tokens each is $0.0006.

**A docs site.** 5,000 articles, chunked into 4 pieces of 500 tokens each.

```txt
5_000 * 4 * 500 = 10_000_000 tokens
10 * $0.02 = $0.20
```

**The point:** for most apps, embedding is a rounding error. The cost only becomes real at millions of documents, or when something re-embeds in a loop by accident.

## What actually bites you
Cost is rarely the problem. These are:

- **Max input length.** `text-embedding-3-*` caps at 8191 tokens per input. Longer text is rejected, not truncated. Chunk before you send.
- **Rate limits.** Measured in both requests per minute and tokens per minute. A backfill loop hits these long before it hits your budget.
- **Accidental re-embedding.** Embedding on every update instead of only when the text changed, or a cron job with no `where embedding is null`. This is how a $0.002 bill becomes a $200 one.
- **Embedding per keystroke.** Search-as-you-type turns one search into fifteen API calls, and adds latency to every one of them.

## Cheap wins
**Batch.** The endpoint accepts an array, up to 2048 inputs per request. Same token cost, far fewer round trips, and much friendlier to rate limits.

```ts
await fetch(ENDPOINT, {
  method: 'POST',
  body: JSON.stringify({model, input: titles}), // array, not string
});
```

**Skip unchanged text.** Store a hash of the embedded text next to the vector, and only re-embed when the hash changes.

**Use the batch API for backfills.** Half price if you can wait up to 24 hours, which you usually can for a one-off migration.

**Shorten the vector, not the input.** `dimensions: 512` on `text-embedding-3-*` costs the same in tokens but shrinks your table and speeds up search. Truncating the *input* to save money is false economy, since you lose meaning to save fractions of a cent.

## Gotchas
- `usage.prompt_tokens` is per request. Sum it if you want a real number for a backfill.
- Token counts differ per provider. A Cohere or Voyage estimate does not transfer to OpenAI.
- Free tiers are capped by tokens per minute, not just per month, so a bulk import can fail without ever hitting the monthly cap.
- The cost of a mistake is the whole table, since every model change means re-embedding everything. Keep the table size in tokens written down somewhere.
