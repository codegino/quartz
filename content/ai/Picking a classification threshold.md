---
title: Picking a classification threshold
---
A classifier like [Jev](https://openrouter.ai/typesafe/jev-1.14) gives you a probability per label. Your code turns that into a yes or no with a threshold:

```ts
const tags = Object.keys(TAGS).filter(tag => answers[tag].noul >= 0.7);
```

`0.7` looks reasonable. It is still a guess until you check it against your data.

## The trade-off
- **Higher threshold**: fewer wrong tags, more missed ones. (Higher _precision_, lower _recall_.)
- **Lower threshold**: fewer missed tags, more wrong ones.

There is no right answer, only the right one for your app. A wrong `work` tag on a grocery item is mildly annoying. A missed "urgent" flag on a support ticket is not.

## Checking it in 20 minutes
1. **Label 30–50 real items by hand.** Write down which tags each should have. Include the awkward ones (_"Buy dish soap"_).
2. **Run the classifier once** and save the **raw probabilities**, not the tags.
3. **Try several thresholds**: `0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9`. For each one and each tag, count:
   - **wrong**: tagged, but you said no
   - **missed**: not tagged, but you said yes
4. **Pick per tag.** The lowest threshold where "wrong" is acceptable if you care about catching everything; the highest where "missed" is acceptable if you care about being right.

Because you saved the probabilities in step 2, step 3 costs nothing. No extra API calls.

## Gotchas
- **Items near the threshold flip.** A score of `0.70` today might be `0.69` tomorrow. If many items sit right on the line, the label's "choose when" description is probably too vague. Fix the wording before moving the number.
- **One threshold per tag is fine.** Nothing says groceries and work need the same cutoff.
- **Thresholds belong to a model version.** Pin the model (`typesafe/jev-1.14`, not `jev-latest`). After an upgrade, re-run step 2 and step 3.
- **Store the probabilities if you will re-tune.** If you only store the final tags, every re-tune means classifying every row again.

## Links
- https://docs.typesafe.ai/confidence
- https://openrouter.ai/docs/cookbook/evaluate-and-optimize/jev-classification
- [Choice vs Noul vs Score in Jev](https://note.carlogino.com/ai/choice-vs-noul-vs-score-in-jev)
