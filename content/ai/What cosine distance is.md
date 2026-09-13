---
title: What cosine distance is
---
An embedding is a list of numbers. You can think of that list as an **arrow** pointing somewhere.

Cosine distance compares two arrows and answers one question: **do they point the same way?**

It ignores how long the arrows are. Only the direction matters.

## The scale
| Distance | Meaning |
| --- | --- |
| `0` | same direction, same meaning |
| `1` | unrelated, at right angles |
| `2` | opposite direction |

Smaller is closer. That is the whole idea.

## In Postgres
`<=>` is the pgvector operator for it:

```sql
select id, title
from todos
order by embedding <=> $1::vector
limit 20;
```

`order by ... <=>` means "closest first". Nothing is called, nothing is generated — it is arithmetic over a column.

## Turning it into a similarity
Distance goes up as things get *less* alike, which reads backwards in a UI. Flip it:

```sql
1 - (embedding <=> $1::vector) as similarity
```

Now `1` is a perfect match and `0` is unrelated.

## Why cosine and not plain distance
Two texts about the same thing can produce arrows of different lengths — often just because one text is longer. Length is not meaning. Cosine throws length away and keeps the part you care about.

> Most embedding models return normalised vectors (all arrows the same length). When that is true, cosine and inner product rank results identically. Pick one and stay consistent between writing and querying.

## Gotchas
- **Distance is not a percentage.** `0.35` is not "65% similar". It is only useful compared to other distances on the same data, from the same model.
- **Cutoffs are per model.** A `0.6` threshold tuned on one model means nothing on another.
- **There is no "no results".** Ask for 20 rows and you get 20 rows, however unrelated. You need a maximum distance to filter the junk out.
- **Only compare vectors from the same model.** Different models point in different spaces; the numbers are meaningless across them.

## Links
- https://github.com/pgvector/pgvector
- https://platform.openai.com/docs/guides/embeddings
- [Where to store embeddings](https://note.carlogino.com/ai/where-to-store-embeddings)
