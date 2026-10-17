---
title: Choice vs Noul vs Score in Jev
---
[Jev](https://openrouter.ai/typesafe/jev-1.14) is a decision model. You send it some **state** (the thing to judge) and a set of **questions**, and every question comes back as a typed answer, not text.

There are three question types for text. Picking the right one is most of the design work.

## The three types
| Type | Asks | Returns |
| --- | --- | --- |
| `choice` | Which **one** of these options? | the picked option, a probability per option, a confidence |
| `noul` | Is this **true**? | one probability of "yes", from 0 to 1 |
| `score` | Where on this **ordered scale**? | a position between levels, a probability per level, a confidence |

## When to use which
- **`choice`**: the options never overlap and exactly one is right. Ticket → billing / technical / sales. A `choice` always picks something, so add an `other` option if your list might not cover every input.
- **`noul`**: a yes/no question where the probability itself is useful. One per label when an item can have **zero, one, or many** labels.
- **`score`**: the answer is a level on a spectrum you can describe. Severity, frustration, skill level.

## Tags are nouls, not a choice
Tagging a todo as groceries, chores, or work looks like a `choice`, but it is not:

- _"Buy dish soap"_ is groceries **and** chores.
- _"Renew passport"_ is **none** of them.

A `choice` cannot say either of those. One `noul` per tag can:

```json
{
  "model": "typesafe/jev-1.14",
  "state": "Buy dish soap",
  "questions": {
    "groceries": {"type": "noul", "instructions": "Is this about buying food, drinks, or household supplies?"},
    "chores": {"type": "noul", "instructions": "Is this a task done in or around the home?"},
    "work": {"type": "noul", "instructions": "Is this related to a job or career?"}
  }
}
```

```json
{"groceries": {"noul": 0.96}, "chores": {"noul": 0.92}, "work": {"noul": 0.09}}
```

Each tag is judged on its own, so adding a fourth tag does not change the scores of the other three. Then your code keeps every tag above a [threshold](https://note.carlogino.com/ai/picking-a-classification-threshold).

## Gotchas
- **Ask in one request.** All questions about the same state go in one call. They run in parallel, so extra questions barely change the latency.
- **One snap judgment per question.** "Is this about work?" is good. "Analyse this todo and decide what to do" is not; split it into several questions and combine the answers in code.
- **Question ids are not sent to the model.** Put the full question in `instructions`, even if the id looks self-explanatory.
- **`noul` has no `confidence`.** The probability already is the confidence. `0.5` means "no idea", not "half true".

## Links
- https://docs.typesafe.ai/primitives
- https://openrouter.ai/docs/guides/community/jev
- [Picking a classification threshold](https://note.carlogino.com/ai/picking-a-classification-threshold)
