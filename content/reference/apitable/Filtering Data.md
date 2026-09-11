---
title: API Filtering Data
---
## Links
- [Formulas](https://help.aitable.ai/docs/guide/tutorial-getting-started-with-formulas/)

## Note
- When filtering a boolean using the [JS sdk](https://www.npmjs.com/package/apitable), to filter a boolean column we need to add `()` to the boolean. For example, `filterByFormula: '{completed} = false()'`