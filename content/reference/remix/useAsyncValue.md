---
title: Remix useAsyncValue
link: https://remix.run/docs/en/main/hooks/use-async-value
---


Returns the resolved data from the closest [`<Await>`](https://remix.run/docs/en/main/components/await) ancestor component.

```tsx
function SomeDescendant() {
  const value = useAsyncValue();
  // ...
}
```

```tsx
<Await resolve={somePromise}>
  <SomeDescendant />
</Await>
```

Copy code to clipboard

## [](https://remix.run/docs/en/main/hooks/use-async-value#additional-resources)Additional Resources

**Guides**

- [Streaming](https://remix.run/docs/en/main/guides/streaming)

**API**

- [`<Await/>`](https://remix.run/docs/en/main/components/await)
- [`useAsyncError`](https://remix.run/docs/en/main/hooks/use-async-error)