In the code snippet below, what do `a` and `b` evaluate to?

```js
let sum = 0;
const squares = [1, 2, 3, 4, 5].map((x) => (
  (sum += x), x * x
));

console.log(sum) // 15
console.log(squares) // [1, 4, 9, 16, 25]
```

This is a fun one. The weirdest part is probably the comma `,` operator.

If you’re not familiar, `,` evaluates each of its operands (from left to right) and returns the value of the last operand. This allows us to, in a single line, increase `sum` by `x` **and** return the square of `x`. When finished, we get the `sum` of the array as well as a new array of `squares`.