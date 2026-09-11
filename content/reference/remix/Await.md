---
title: Remix Await
link: https://remix.run/docs/en/main/components/await
---
To get started with streaming data, check out the [Streaming Guide](https://remix.run/docs/en/main/guides/streaming).

The `<Await>` component is responsible for resolving deferred loader promises accessed from [`useLoaderData`](https://remix.run/docs/en/main/hooks/use-loader-data).

```tsx
import { Await } from "@remix-run/react";

<Suspense fallback={<div>Loading...</div>}>
  <Await resolve={somePromise}>
    {(resolvedValue) => <p>{resolvedValue}</p>}
  </Await>
</Suspense>;
```

## [](https://remix.run/docs/en/main/components/await#props)Props

### [](https://remix.run/docs/en/main/components/await#resolve)`resolve`

The resolve prop takes a promise from [`useLoaderData`](https://remix.run/docs/en/main/hooks/use-loader-data) to resolve when the data has streamed in.

```tsx
<Await resolve={somePromise} />
```


When the promise is not resolved, a parent suspense boundary's fallback will be rendered.

```tsx
<Suspense fallback={<div>Loading...</div>}>
  <Await resolve={somePromise} />
</Suspense>
```


When the promise is resolved, the `children` will be rendered.

### [](https://remix.run/docs/en/main/components/await#children)`children`

The `children` can be a render callback or a React element.

```tsx
<Await resolve={somePromise}>
  {(resolvedValue) => <p>{resolvedValue}</p>}
</Await>
```

If the `children` props is a React element, the resolved value will be accessible through [`useAsyncValue`](https://remix.run/docs/en/main/hooks/use-async-value) in the subtree.

```tsx
<Await resolve={somePromise}>
  <SomeChild />
</Await>
```


```tsx
import { useAsyncValue } from "@remix-run/react";

function SomeChild() {
  const value = useAsyncValue();
  return <p>{value}</p>;
}
```

### [](https://remix.run/docs/en/main/components/await#errorelement)`errorElement`

The `errorElement` prop can be used to render an error boundary when the promise rejects.

```
<Await errorElement={<div>Oops!</div>} />
```


The error can be accessed in the subtree with [`useAsyncError`](https://remix.run/docs/en/main/hooks/use-async-error)

```tsx
<Await errorElement={<SomeChild />} />
```

```tsx
import { useAsyncError } from "@remix-run/react";

function SomeChild() {
  const error = useAsyncError();
  return <p>{error.message}</p>;
}
```


## Tip
Using `Await` with multiple promises

```tsx
<Await resolve={Promise.all([todosResult, labelsResult, projectsResult])}>
  {/* ... */}
</Await>
```