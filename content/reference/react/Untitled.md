# Build a Full-Stack app using these React libraries and cloud backend.

[#react](https://dev.to/t/react)[#opensource](https://dev.to/t/opensource)[#programming](https://dev.to/t/programming)[#webdev](https://dev.to/t/webdev)

Today, we're going to learn how to build a full-stack app with Wing as a backend.

[![react + vite + wing](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fvb7jf7dk9b08x042p0vl.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fvb7jf7dk9b08x042p0vl.png)

We will use React with Vite for the frontend.  
I know there are other frameworks like Vue, Angular, and Next but React is still the most common, and a huge number of trusted startups use it to date.

If you don't know, [React](https://github.com/facebook/react) is an open source library created by Facebook to build web and native user interfaces. As you can see from the repository, it is used by 20.4M+ developers. So, it's worth the effort.

Let's see how we can use Wing as a backend.

GIF

![Thumbs-up](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fpskz2tyzodt4wnxbqa8y.gif)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#wing-a-programming-language-for-the-cloud)[Wing](https://git.new/wing-repo) - A programming language for the cloud.

[![wing](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fn97bowkrexjk46n94bcc.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fn97bowkrexjk46n94bcc.png)

Winglang is a new open-source programming language designed for the cloud (aka "cloud-oriented"). It lets you build apps in the cloud and has a fairly easy syntax.

Wing programs can be executed locally (yes, no internet required) using a fully functional simulator, or deployed to any cloud provider.

[![wing infrastructure](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Feun3zd1gkp870rj57eeu.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Feun3zd1gkp870rj57eeu.png)

You would need Node `v20 or higher` for Wing.

Make a parent directory (we are using `shared-counter`) and set up the frontend with a new React app using Vite. You can use this npm command.  

```
npm create -y vite frontend -- --template react-ts

// once installed, you can check if it's running properly.
cd frontend

npm install

npm run dev
```

You can install Wing using this npm command.  

```
npm install -g winglang
```

You can verify the installation using `wing -V`.

Wing also provides official [VSCode extension](https://marketplace.visualstudio.com/items?itemName=Monada.vscode-wing) & [IntelliJ](https://plugins.jetbrains.com/plugin/22353-wing) which provides syntax highlighting, completions, go-to-definition, and embedded Wing Console support. You can install it before building an app!

Create a backend directory.  

```sh
mkdir ~/shared-counter/backend
cd ~/shared-counter/backend
```

To create a new empty Wing project.  

```
wing new empty
// This will generate three files: package.json, package-lock.json and main.w file with a simple "hello world" program

wing it // to run it in the Wing simulator
// The Wing Simulator will be opened in your browser and will show a map of your app with a single function.
//You can invoke the function from the interaction panel and check out the result.
```

The structure would be as follows after using the command `wing new empty`.  

```js
bring cloud;

// define a queue, a bucket, and a counter
let bucket = new cloud.Bucket();
let counter = new cloud.Counter(initial: 1);
let queue = new cloud.Queue();

// When a message is received in the queue -> it should be consumed
// by the following closure
queue.setConsumer(inflight (message: str) => {
  // Increment the distributed counter, the index variable will 
  // store the value before the increment
  let index = counter.inc();
  // Once two messages are pushed to the queue, e.g. "Wing" and "Queue".
  // Two files will be created:
  // - wing-1.txt with "Hello Wing"
  // - wing-2.txt with "Hello Queue"
  bucket.put("wing-{index}.txt", "Hello, {message}");
  log("file wing-{index}.txt created");
});
```

You can install `@winglibs/vite` to start the dev server rather than using the `npm run dev` to start the local web server.  

```sh
// in the backend directory
npm i @winglibs/vite
```

You can send data to your frontend using publicEnv available at `backend/main.w`.  
Let's see a minor example.  

```
// backend/main.w
bring vite;

new vite.Vite(
  root: "../frontend",
  publicEnv: {
    TITLE: "Wing + Vite + React"
  }
);

// import it in frontend
// frontend/src/App.tsx
import "../.winglibs/wing-env.d.ts"

//You can access that value like this.
<h1>{window.wing.env.TITLE}</h1>
```

You can do more:

- read/update API routes & check it using Wing Simulator.
- Fetching the values by using the backend.
- Synchronize browsers using `@winglibs/websockets` which deploys a WebSocket server on the backend and you can connect this WebSocket to receive real-time notifications.

You can read the complete step-by-step guide on [how to build a simple web application with React for our frontend and Wing for our backend](https://www.winglang.io/docs/guides/react-vite-websockets). Testing is done using Wing Simulator and it's deployed to AWS using Terraform.

The AWS architecture after the deployment would be like this.

[![architecture](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F27awil840ktgh3jvklij.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F27awil840ktgh3jvklij.png)

To give developers options and a better experience, Wing has rolled out full support for additional languages such as [TypeScript (Wing)](https://www.winglang.io/docs/typescript/). The only mandatory thing is you will have to install the Wing SDK.

This will also make the console fully accessible for local debugging and testing without learning the Wing language.

Wing even has other [guides](https://www.winglang.io/docs/category/guides) so it's easier to follow along.

[![guides](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F31czxehkg10ezmlpf7ac.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F31czxehkg10ezmlpf7ac.png)

You can read the [docs](https://www.winglang.io/docs) and see the [examples](https://www.winglang.io/docs/category/examples).

You can also use Wing in the [playground](https://www.winglang.io/play/?code=LwAvACAAVABoAGkAcwAgAGkAcwAgAHQAaABlACAAaQBtAHAAbwByAHQAIABzAHQAYQB0AGUAbQBlAG4AdAAgAGkAbgAgAFcAaQBuAGcALgAKAC8ALwAgAEgAZQByAGUAIAB3AGUAIABiAHIAaQBuAGcAIAB0AGgAZQAgAFcAaQBuAGcAIABzAHQAYQBuAGQAYQByAGQAIABsAGkAYgByAGEAcgB5ACAAdABoAGEAdAAgAAoALwAvACAAYwBvAG4AdABhAGkAbgBzACAAYQBiAHMAdAByAGEAYwB0AGkAbwBuAHMAIABvAGYAIABwAG8AcAB1AGwAYQByACAAYwBsAG8AdQBkACAAcwBlAHIAdgBpAGMAZQBzAC4ACgBiAHIAaQBuAGcAIABjAGwAbwB1AGQAOwAKAAoALwAvACAAVABoAGkAcwAgAGMAbwBkAGUAIABkAGUAZgBpAG4AZQBzACAAYQAgAGIAdQBjAGsAZQB0ACAAYQBzACAAcABhAHIAdAAgAG8AZgAgAHkAbwB1AHIAIABhAHAAcAAuAAoALwAvACAAVwBoAGUAbgAgAGMAbwBtAHAAaQBsAGkAbgBnACAAdABvACAAYQAgAHMAcABlAGMAaQBmAGkAYwAgAGMAbABvAHUAZAAgAHAAcgBvAHYAaQBkAGUAcgAKAC8ALwAgAGkAdAAgAHcAaQBsAGwAIABiAGUAIABzAHUAYgBzAHQAaQB0AHUAdABlAGQAIABiAHkAIABhAG4AIABpAG0AcABsAGUAbQBlAG4AdABhAHQAaQBvAG4AIABmAG8AcgAKAC8ALwAgAHQAaABhAHQAIABjAGwAbwB1AGQALgAgAEkALgBlACwAIABmAG8AcgAgAEEAVwBTACAAaQB0ACAAdwBpAGwAbAAgAGIAZQAgAGEAbgAgAFMAMwAgAEIAdQBjAGsAZQB0AC4ACgBsAGUAdAAgAGIAdQBjAGsAZQB0ACAAPQAgAG4AZQB3ACAAYwBsAG8AdQBkAC4AQgB1AGMAawBlAHQAKAApADsACgAKAC8ALwAgACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAKAC8ALwAgAFkAbwB1ACAAYwBhAG4AIABpAG4AdABlAHIAYQBjAHQAIAB3AGkAdABoACAAdABoAGUAIABhAHAAcAAgAGkAbgAgAHQAaABlACAAYwBvAG4AcwBvAGwAZQAgAC0ALQA%2BAAoALwAvACAACgAvAC8AIABDAGwAaQBjAGsAIABvAG4AIAB0AGgAZQAgAEYAdQBuAGMAdABpAG8AbgAsACAAYQBuAGQAIAB0AGgAZQBuACAAaQBuAHYAbwBrAGUAIABpAHQAIABpAG4AIAB0AGgAZQAKAC8ALwAgAGwAbwB3AGUAcgAgAHIAaQBnAGgAdAAgAHAAYQBuAGUAbAAsACAAbwByACAAYwBsAGkAYwBrACAAbwBuACAAdABoAGUAIABCAHUAYwBrAGUAdAAKAC8ALwAgAHQAbwAgAHMAZQBlACAAaQB0AHMAIABjAG8AbgB0AGUAbgB0AHMAIABpAG4AIAB0AGgAZQAgAHAAYQBuAGUAbAAsACAAZQB0AGMALgAKAC8ALwAgACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAhACEAIQAKAAoALwAvACAAYABpAG4AZgBsAGkAZwBoAHQAcwBgACAAcgBlAHAAcgBlAHMAZQBuAHQAIABjAG8AZABlACAAdABoAGEAdAAgAHIAdQBuAHMAIABsAGEAdABlAHIALAAgAG8AbgAKAC8ALwAgAG8AdABoAGUAcgAgAG0AYQBjAGgAaQBuAGUAcwAsACAAaQBuAHQAZQByAGEAYwB0AGkAbgBnACAAdwBpAHQAaAAgAGMAYQBwAHQAdQByAGUAZAAgAGQAYQB0AGEAIABhAG4AZAAKAC8ALwAgAHIAZQBzAG8AdQByAGMAZQBzACAAZgByAG8AbQAgAHQAaABlACAAcAByAGUALQBmAGwAaQBnAGgAdAAgAHAAaABhAHMAZQAuAAoAbABlAHQAIABoAGUAbABsAG8AXwB3AG8AcgBsAGQAIAA9ACAAaQBuAGYAbABpAGcAaAB0ACAAKAApACAAPQA%2BACAAewAKACAAIABiAHUAYwBrAGUAdAAuAHAAdQB0ACgAIgBoAGUAbABsAG8ALgB0AHgAdAAiACwAIAAiAEgAZQBsAGwAbwAsACAAVwBvAHIAbABkACEAIgApADsACgB9ADsACgAKAC8ALwAgAEkAbgBmAGwAaQBnAGgAdABzACAAYwBhAG4AIABiAGUAIABkAGUAcABsAG8AeQBlAGQAIABhAHMAIABzAGUAcgB2AGUAcgBsAGUAcwBzACAAZgB1AG4AYwB0AGkAbwBuAHMACgBuAGUAdwAgAGMAbABvAHUAZAAuAEYAdQBuAGMAdABpAG8AbgAoAGgAZQBsAGwAbwBfAHcAbwByAGwAZAApADsACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAACgAvAC8AIACRISAAUwB3AGkAdABjAGgAIABmAGkAbABlAHMAIABhAG4AZAAgAHMAZQBlACAAbwB0AGgAZQByACAAZQB4AGEAbQBwAGwAZQBzACAAdwBpAHQAaAAgAG0AbwByAGUACgAvAC8AIABlAHgAcABsAGUAbgBhAHQAaQBvAG4AcwAgAGEAYgBvAHYAZQAuAA%3D%3D) to check out the structure and examples.

If you're more of a tutorial person. Watch this!

Wing has 3.5k+ Stars on GitHub, 1500+ Releases, and is still not on the v1 release which means a huge deal.  
Go try it out and make something cool!

[Star Wing ⭐️](https://git.new/wing-repo)

---

The developer ecosystem has grown and many developers have built something unique around React.

I'm not covering how you can use React because it's such a wide topic and I've pasted a couple of resources at the end that will help you learn React.

But to help you make an awesome React project, we are covering 25 open source projects that you can use to make your work easier.  
This will have plenty of resources, ideas, and concepts.

I will even give you some learning resources, and project examples of a few products to learn React.  
Everything would be free & only React.

Let's cover it all!

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#1-mantine-hooks-react-hooks-for-state-and-ui-management)1. [Mantine Hooks](https://www.npmjs.com/package/@mantine/hooks) - react hooks for state and UI management.

[![mantine hooks](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fg9gxhpt4zpmxgg2cfbqi.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fg9gxhpt4zpmxgg2cfbqi.png)

This may not be especially for React, but you can use these hooks to make your work easier. The hooks are ready to use with each having a good number of options.

If I have to rate, this would be the most useful project that everyone can use rather than writing code from scratch.

Trust me, getting 60+ hooks is a big deal considering they have a simple way for you to see the demo of each of the hooks with easy docs to follow.

Get started with the following npm command.  

```sh
npm install @mantine/hooks
```

This is how you can use `useScrollIntoView` as part of mantine hooks.  

```tsx
import { useScrollIntoView } from '@mantine/hooks';
import { Button, Text, Group, Box } from '@mantine/core';

function Demo() {
  const { scrollIntoView, targetRef } = useScrollIntoView<HTMLDivElement>({
    offset: 60,
  });

  return (
    <Group justify="center">
      <Button
        onClick={() =>
          scrollIntoView({
            alignment: 'center',
          })
        }
      >
        Scroll to target
      </Button>
      <Box
        style={{
          width: '100%',
          height: '50vh',
          backgroundColor: 'var(--mantine-color-blue-light)',
        }}
      />
      <Text ref={targetRef}>Hello there</Text>
    </Group>
  );
}
```

They almost have everything from local storage to pagination, to scroll view, intersection, and even some very cool utilities like eye dropper and text selection. This is damn too helpful!

[![eye dropper](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fpighzv57fvyp5uxvw8dz.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fpighzv57fvyp5uxvw8dz.png)

You can read the [docs](https://mantine.dev/hooks/use-click-outside/).

You can also use an [alternative library](https://antonioru.github.io/beautiful-react-hooks/) if you're looking for more options.

They have more than 23k stars on GitHub but it's not only for the hooks because they are a component library for React.

It has weekly downloads of 380k+ along with the `v7` release that shows they are constantly improving and trustworthy.

[Star Mantine Hooks ⭐️](https://github.com/mantinedev/mantine)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#2-react-grid-layout-draggable-and-resizable-grid-layout-with-responsive-breakpoints)2. [React Grid Layout](https://github.com/react-grid-layout/react-grid-layout) - draggable and resizable grid layout with responsive breakpoints.

[![react grid layout](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fpyg7g1bm1d3hvkexrnh3.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fpyg7g1bm1d3hvkexrnh3.png)

React-Grid-Layout is a responsive grid layout system built exclusively for React applications.

With support for draggable, resizable, and static widgets, it offers an easy solution for using a grid.

Unlike similar systems like Packery or Gridster, React-Grid-Layout is jQuery-free, ensuring a lightweight and efficient implementation.

Its seamless integration with server-rendered apps and the ability to serialize and restore layouts make it a valuable tool for developers to use grid layouts in their React projects.

Get started with the following npm command.  

```sh
npm install react-grid-layout
```

This is how you can use a responsive grid layout.  

```tsx
import { Responsive as ResponsiveGridLayout } from "react-grid-layout";

class MyResponsiveGrid extends React.Component {
  render() {
    // {lg: layout1, md: layout2, ...}
    const layouts = getLayoutsFromSomewhere();
    return (
      <ResponsiveGridLayout
        className="layout"
        layouts={layouts}
        breakpoints={{ lg: 1200, md: 996, sm: 768, xs: 480, xxs: 0 }}
        cols={{ lg: 12, md: 10, sm: 6, xs: 4, xxs: 2 }}
      >
        <div key="1">1</div>
        <div key="2">2</div>
        <div key="3">3</div>
      </ResponsiveGridLayout>
    );
  }
}
```

You can read the [docs](https://github.com/react-grid-layout/react-grid-layout?tab=readme-ov-file#installation) and see the [demo](https://react-grid-layout.github.io/react-grid-layout/examples/0-showcase.html). There is a [series of demos](https://github.com/react-grid-layout/react-grid-layout?tab=readme-ov-file#demos) and it's even available by clicking on "view the next example".

You can also try the things on [codesandbox](https://codesandbox.io/p/devbox/github/gilbarbara/react-joyride-demo/tree/main/?embed=1).

The project has 19k+ Stars on GitHub, is used by 16k+ Developers, and has massive weekly downloads of 600k+ on the [npm package](https://www.npmjs.com/package/react-grid-layout).

[Star React Grid Layout ⭐️](https://github.com/react-grid-layout/react-grid-layout)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#3-react-spectrum-a-collection-of-libraries-and-tools-for-great-ux)3. [React Spectrum](https://github.com/adobe/react-spectrum) - A collection of libraries and tools for great UX.

[![react spectrum](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fb4wkgbdpd1gve36vgjne.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fb4wkgbdpd1gve36vgjne.png)

React Spectrum is a collection of libraries and tools that help you build adaptive, accessible, and robust user experiences.

They provide so many things that it's hard to cover everything in just a single post.

Overall, they provide these four libraries.

[![react spectrum](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fm97vdq3x7nllmhyjy7p9.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fm97vdq3x7nllmhyjy7p9.png)

- [React Spectrum](https://react-spectrum.adobe.com/react-spectrum/index.html)
- [React Stately](https://react-spectrum.adobe.com/react-stately/index.html) - A huge set of React Hooks that provides cross-platform state management for your design system.
- [React Aria](https://react-spectrum.adobe.com/react-aria/index.html)
- [internationalized](https://react-spectrum.adobe.com/internationalized/index.html)

We will see a bit about React Aria which is a library of unstyled React components and hooks that helps you build accessible, high-quality UI components for your app.  
It has been meticulously tested across a wide variety of devices, interaction modalities, and assistive technologies to ensure the best experience possible for all users.

Get started with the following npm command.  

```sh
npm i react-aria-components
```

This is how you can build a custom `select`.  

```tsx
import {Button, Label, ListBox, ListBoxItem, Popover, Select, SelectValue} from 'react-aria-components';

<Select>
  <Label>Favorite Animal</Label>
  <Button>
    <SelectValue />
    <span aria-hidden="true">▼</span>
  </Button>
  <Popover>
    <ListBox>
      <ListBoxItem>Cat</ListBoxItem>
      <ListBoxItem>Dog</ListBoxItem>
      <ListBoxItem>Kangaroo</ListBoxItem>
    </ListBox>
  </Popover>
</Select>
```

Trust me, for study purposes, this is a goldmine.

[![design structure for select](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fndy61o8vtjjbq78e8vl8.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fndy61o8vtjjbq78e8vl8.png)

They use their own robust [40+ styling components](https://opensource.adobe.com/spectrum-css/) which is way more than what is generally provided. They also have their own set of [design systems](https://spectrum.adobe.com/) such as font, UI, typography, motion, and more.

[![styling components](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fa047jcb2ou7h057yf2d4.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fa047jcb2ou7h057yf2d4.png)

[![styling components](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fy1w5jq1vfbhd6o9c9ehm.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fy1w5jq1vfbhd6o9c9ehm.png)

You can read about [Spectrum](https://react-spectrum.adobe.com/index.html) and their [architecture](https://react-spectrum.adobe.com/architecture.html) in detail.

They have over 11k stars on GitHub, indicating their quality despite not being widely known. Studying them can provide valuable insights into setting up your library.

[Star React Spectrum ⭐️](https://github.com/adobe/react-spectrum)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#4-keep-react-ui-component-library-for-tailwind-css-amp-reactjs)4. [Keep React](https://github.com/StaticMania/keep-react) - UI component library for Tailwind CSS & React.js.

[![keep react](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F5s2z1xig75on0j2gjt1g.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F5s2z1xig75on0j2gjt1g.png)

Keep React is an open source component library built on Tailwind CSS and React.js. It provides a versatile set of pre-designed UI components that enable developers to streamline the creation of modern, responsive, and visually appealing web applications.

Get started with the following npm command.  

```sh
npm i keep-react
```

This is how you can use Timeline.  

```tsx

"use client";
import { Timeline } from "keep-react";
import { CalendarBlank } from "phosphor-react";

export const TimelineComponent = () => {
  return (
    <Timeline horizontal={true}>
      <Timeline.Item>
        <Timeline.Point icon={<CalendarBlank size={16}  />} />
        <Timeline.Content>
          <Timeline.Title>Keep Library v1.0.0</Timeline.Title>
          <Timeline.Time>Released on December 2, 2021</Timeline.Time>
          <Timeline.Body>
            Get started with dozens of web components and interactive elements.
          </Timeline.Body>
        </Timeline.Content>
      </Timeline.Item>
      <Timeline.Item>
        <Timeline.Point icon={<CalendarBlank size={16}  />} />
        <Timeline.Content>
          <Timeline.Title>Keep Library v1.1.0</Timeline.Title>
          <Timeline.Time>Released on December 23, 2021</Timeline.Time>
          <Timeline.Body>
            Get started with dozens of web components and interactive elements.
          </Timeline.Body>
        </Timeline.Content>
      </Timeline.Item>
      <Timeline.Item>
        <Timeline.Point icon={<CalendarBlank size={16}  />} />
        <Timeline.Content>
          <Timeline.Title>Keep Library v1.3.0</Timeline.Title>
          <Timeline.Time>Released on January 5, 2022</Timeline.Time>
          <Timeline.Body>
            Get started with dozens of web components and interactive elements.
          </Timeline.Body>
        </Timeline.Content>
      </Timeline.Item>
    </Timeline>
  );
}
```

The output would be as below.

[![Timeline component](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fv22pagugp45z68jap3en.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fv22pagugp45z68jap3en.png)

The little smooth animations make it all worth it, and you can use it if you want to quickly build a UI without any hassle.

[![upload](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fgfy9f9w0nc6ipn6wigil.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fgfy9f9w0nc6ipn6wigil.png)

[![notification](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F5zpwcnozi5ye3wpnev1g.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F5zpwcnozi5ye3wpnev1g.png)

You can read the [docs](https://react.keepdesign.io/docs/getting-started/Introduction) and check the [storybook](https://react-storybook.keepdesign.io/?path=/docs/components-accordion--docs) for detailed usage testing.

The project has over 1k stars on GitHub, and some of its components are incredibly handy to use.

[Star Keep React ⭐️](https://github.com/StaticMania/keep-react)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#5-react-content-loader-svgpowered-component-to-easily-create-skeleton-loadings)5. [React Content Loader](https://github.com/danilowoz/react-content-loader) - SVG-powered component to easily create skeleton loadings.

[![react content loader](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fg8g2yc0zush5vfgwo6hv.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fg8g2yc0zush5vfgwo6hv.png)

This project provides you with an SVG-powered component to easily create placeholder loadings (like Facebook's cards loading).

Skeletons are used during the loading state to indicate to users that content is still loading.  
Overall, it's a very handy project for enhancing the overall user experience.

Get started with the following npm command.  

```sh
npm i react-content-loader --save
```

This is how you can use it.  

```tsx
import React from "react"
import ContentLoader from "react-content-loader"

const MyLoader = (props) => (
  <ContentLoader 
    speed={2}
    width={400}
    height={160}
    viewBox="0 0 400 160"
    backgroundColor="#f3f3f3"
    foregroundColor="#ecebeb"
    {...props}
  >
    <rect x="48" y="8" rx="3" ry="3" width="88" height="6" /> 
    <rect x="48" y="26" rx="3" ry="3" width="52" height="6" /> 
    <rect x="0" y="56" rx="3" ry="3" width="410" height="6" /> 
    <rect x="0" y="72" rx="3" ry="3" width="380" height="6" /> 
    <rect x="0" y="88" rx="3" ry="3" width="178" height="6" /> 
    <circle cx="20" cy="20" r="20" />
  </ContentLoader>
)

export default MyLoader
```

[![output](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fxnvqlf6fmg2fayd29ojr.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fxnvqlf6fmg2fayd29ojr.png)

You can even drag the individual skeleton or use pre-defined made for different socials like Facebook, and Instagram.

You can read the [docs](https://github.com/danilowoz/react-content-loader?tab=readme-ov-file#gettingstarted) and see the [demo](https://skeletonreact.com/).

The project has 13k+ Stars on GitHub and is used by 45k+ developers on GitHub.

[Star React Content Loader ⭐️](https://github.com/danilowoz/react-content-loader)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#6-react-pdf-create-pdf-files-using-react)6. [React PDF](https://github.com/diegomura/react-pdf) - Create PDF files using React.

[![react pdf](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F6jd7sz8eqda09rgjpf13.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F6jd7sz8eqda09rgjpf13.png)

This package is used to create PDFs using React.

Get started with the following npm command.  

```sh
npm install @react-pdf/renderer --save
```

This is how you can use this.  

```tsx
import React from 'react';
import { Document, Page, Text, View, StyleSheet } from '@react-pdf/renderer';

// Create styles
const styles = StyleSheet.create({
  page: {
    flexDirection: 'row',
    backgroundColor: '#E4E4E4',
  },
  section: {
    margin: 10,
    padding: 10,
    flexGrow: 1,
  },
});

// Create Document Component
const MyDocument = () => (
  <Document>
    <Page size="A4" style={styles.page}>
      <View style={styles.section}>
        <Text>Section #1</Text>
      </View>
      <View style={styles.section}>
        <Text>Section #2</Text>
      </View>
    </Page>
  </Document>
);
```

[![output](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fcb5fpfzijv3g5fi5utmw.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fcb5fpfzijv3g5fi5utmw.png)

[![output pdf pagination](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Ff46t80n0redm14icia1r.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Ff46t80n0redm14icia1r.png)

You can read the [docs](https://react-pdf.org/) and see the [demo](https://react-pdf.org/repl).

React-pdf now ships a hook called `usePDF` that enables accessing all PDF creation capabilities via a React hook API. This is great if you need more control over how the document gets rendered or how often it's updated.  

```
const [instance, update] = usePDF({ document });
```

The project has 13k+ Stars on GitHub and has more than 270 releases with [400k+ weekly downloads](https://www.npmjs.com/package/@react-pdf/renderer) which is a good sign.

[Star React PDF ⭐️](https://github.com/diegomura/react-pdf)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#7-recharts-redefined-chart-library-built-with-react-and-d3)7. [Recharts](https://github.com/recharts/recharts) - redefined chart library built with React and D3.

[![recharts](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fi6817tmlix6n7wtgp1yq.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fi6817tmlix6n7wtgp1yq.png)

The main purpose of this library is to help you write charts in React applications without any pain.

The Main principles of Recharts are.

1. Simply deploy with React components.
2. Native SVG support, lightweight depending only on some D3 submodules.
3. Declarative components, components of charts are purely presentational.

Get started with the following npm command.  

```sh
npm install recharts
```

This is how you can use this.  

```tsx
<LineChart width={500} height={300} data={data} accessibilityLayer>
    <XAxis dataKey="name"/>
    <YAxis/>
    <CartesianGrid stroke="#eee" strokeDasharray="5 5"/>
    <Line type="monotone" dataKey="uv" stroke="#8884d8" />
    <Line type="monotone" dataKey="pv" stroke="#82ca9d" />
    <Tooltip/>
  </LineChart>
```

[![output](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fuqtp999q1ahq8ajmvuwf.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fuqtp999q1ahq8ajmvuwf.png)

You can read the [docs](https://recharts.org/en-US/guide) and see more on [Storybook](https://recharts.org/en-US/storybook).

They provide an insane amount of options to customize it, which is why developers love it. They also provide a [wiki](https://github.com/recharts/recharts/wiki) page for general FAQs.

You can also try it on codesandbox here.

The project has 22k+ Stars on GitHub and is used by 200k+ developers.

[Star Recharts ⭐️](https://github.com/recharts/recharts)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#8-react-joyride-create-guided-tours-in-your-apps)8. [React Joyride](https://github.com/gilbarbara/react-joyride) - create guided tours in your apps.

[![react joyride](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fph7rt2bxqbxi67r47on8.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fph7rt2bxqbxi67r47on8.png)

[![react joyride](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fov4wzohwszgv5v06cin4.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fov4wzohwszgv5v06cin4.png)

Tours can be an excellent way to showcase your app to new users or explain the functionality of new features. It improves the user experience and can create a personalized touch.

Get started with the following npm command.  

```sh
npm i react-joyride
```

This is how you can use it.  

```tsx
import React, { useState } from 'react';
import Joyride from 'react-joyride';

/*
 * If your steps are not dynamic you can use a simple array.
 * Otherwise you can set it as a state inside your component.
 */
const steps = [
  {
    target: '.my-first-step',
    content: 'This is my awesome feature!',
  },
  {
    target: '.my-other-step',
    content: 'This another awesome feature!',
  },
];

export default function App() {
  // If you want to delay the tour initialization you can use the `run` prop
  return (
    <div>
      <Joyride steps={steps} />
      ...
    </div>
  );
}
```

They also provide a [list of components](https://docs.react-joyride.com/custom-components) and an easy way to customize the default user interface.

You can read the [docs](https://docs.react-joyride.com/) and see the [demo](https://react-joyride.com/).

You can also try the things on [codesandbox](https://codesandbox.io/p/devbox/github/gilbarbara/react-joyride-demo/tree/main/?embed=1).

They have 6k+ Stars on GitHub and have more than 250k weekly downloads on the npm package.

[Star React Joyride ⭐️](https://github.com/gilbarbara/react-joyride)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#9-svgr-transform-svgs-into-react-components)9. [SVGR](https://github.com/gregberge/svgr) - Transform SVGs into React components.

[![svgr](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F94hpre3yl3ttu5zdexsv.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F94hpre3yl3ttu5zdexsv.png)

SVGR is a universal tool to transform SVG into React components.  
It takes a raw SVG and transforms it into a ready-to-use React component.

Get started with the following npm command.  

```sh
npm install @svgr/core
```

For instance, you take this SVG.  

```tsx
<?xml version="1.0" encoding="UTF-8"?>
<svg
  width="48px"
  height="1px"
  viewBox="0 0 48 1"
  version="1.1"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
>
  <!-- Generator: Sketch 46.2 (44496) - http://www.bohemiancoding.com/sketch -->
  <title>Rectangle 5</title>
  <desc>Created with Sketch.</desc>
  <defs></defs>
  <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
    <g
      id="19-Separator"
      transform="translate(-129.000000, -156.000000)"
      fill="#063855"
    >
      <g id="Controls/Settings" transform="translate(80.000000, 0.000000)">
        <g id="Content" transform="translate(0.000000, 64.000000)">
          <g id="Group" transform="translate(24.000000, 56.000000)">
            <g id="Group-2">
              <rect id="Rectangle-5" x="25" y="36" width="48" height="1"></rect>
            </g>
          </g>
        </g>
      </g>
    </g>
  </g>
</svg>
```

After running SVGR, it will be converted to.  

```tsx
import * as React from 'react'

const SvgComponent = (props) => (
  <svg width="1em" height="1em" viewBox="0 0 48 1" {...props}>
    <path d="M0 0h48v1H0z" fill="currentColor" fillRule="evenodd" />
  </svg>
)

export default SvgComponent
```

It optimized SVG using [SVGO](https://github.com/svg/svgo) and uses Prettier for formatting code.

Transforming HTML into JSX takes place in several steps:

1. Converting SVG into HAST (HTML AST)
2. Converting HAST into Babel AST (JSX AST)
3. Transforming AST using Babel (renaming attributes, changing attribute values, ...)

You can read the [docs](https://react-svgr.com/docs/getting-started) and check things at [playground](https://react-svgr.com/playground/).

The project has 10k+ Stars on GitHub and is used by 8M+ developers with weekly downloads of 800k+ on npm.

[Star SVGR ⭐️](https://github.com/gregberge/svgr)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#10-react-sortable-tree-draganddrop-sortable-component-for-nested-data-and-hierarchies)10. [React Sortable Tree](https://github.com/frontend-collective/react-sortable-tree) - Drag-and-drop sortable component for nested data and hierarchies.

[![react sortable tree](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F907c4rnmev2wx1abq0r7.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F907c4rnmev2wx1abq0r7.png)

A React component that enables the drag-and-drop sorting of hierarchical data.

[![react sortable tree](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fz4tm32vuteqaw5m7crag.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fz4tm32vuteqaw5m7crag.png)

Get started with the following npm command.  

```sh
npm install react-sortable-tree --save
```

This is how you can use this.  

```tsx
import React, { Component } from 'react';
import SortableTree from 'react-sortable-tree';
import 'react-sortable-tree/style.css'; // This only needs to be imported once in your app

export default class Tree extends Component {
  constructor(props) {
    super(props);

    this.state = {
      treeData: [
        { title: 'Chicken', children: [{ title: 'Egg' }] },
        { title: 'Fish', children: [{ title: 'fingerline' }] },
      ],
    };
  }

  render() {
    return (
      <div style={{ height: 400 }}>
        <SortableTree
          treeData={this.state.treeData}
          onChange={treeData => this.setState({ treeData })}
        />
      </div>
    );
  }
}
```

Check the various [props options](https://github.com/frontend-collective/react-sortable-tree?tab=readme-ov-file#props) and [themes](https://github.com/frontend-collective/react-sortable-tree?tab=readme-ov-file#featured-themes) that you get with this.

You can read the [docs](https://github.com/frontend-collective/react-sortable-tree?tab=readme-ov-file#getting-started) and check out the [Storybook](https://frontend-collective.github.io/react-sortable-tree/?path=/story/basics--minimal-implementation) for a demonstration of some basic and advanced features.

It may not be actively maintained (still not archived), so you can also use a [maintained fork version](https://github.com/nosferatu500/react-sortable-tree).

The project has 4.5k+ Stars on GitHub and is used by 5k+ developers.

[Star React Sortable Tree ⭐️](https://github.com/frontend-collective/react-sortable-tree)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#11-react-hot-toast-smoking-hot-react-notifications)11. [React Hot Toast](https://github.com/timolins/react-hot-toast) - Smoking Hot React Notifications.

[![React Hot Toast](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Flw4veo990lspkchhwz64.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Flw4veo990lspkchhwz64.png)

React Hot Toast offers a blazing 🔥 default experience with easy customization options. It leverages a Promise API for automatic loaders, ensuring smooth transitions.  
Lightweight at under 5kb, it remains accessible while empowering developers with headless hooks like `useToaster()`.

Add the Toaster to your app first. It will take care of rendering all notifications emitted. Now you can trigger toast() from anywhere!

Get started with the following npm command.  

```
npm install react-hot-toast
```

This is how easy it is to use.  

```
import toast, { Toaster } from 'react-hot-toast';

const notify = () => toast('Here is your toast.');

const App = () => {
  return (
    <div>
      <button onClick={notify}>Make me a toast</button>
      <Toaster />
    </div>
  );
};
```

[![theme option](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Ftl8ezjabacdllw8qnd41.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Ftl8ezjabacdllw8qnd41.png)

[![theme option](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fzksldf8goqbytcuumhac.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fzksldf8goqbytcuumhac.png)

They have lots of options to customize it but the `useToaster()` hook provides you a headless system that will manage the notification state for you. This makes building your notification system much easier.

You can read the [docs](https://react-hot-toast.com/docs), the [styling guide](https://react-hot-toast.com/docs/styling) and see the [demo](https://react-hot-toast.com/).

The project has 8k+ Stars on GitHub and is used by 230k+ developers.

[Star React Hot Toast ⭐️](https://github.com/timolins/react-hot-toast)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#12-payload-the-best-way-to-build-a-modern-backend-admin-ui)12. [Payload](https://github.com/payloadcms/payload) - the best way to build a modern backend + admin UI.

[![payload](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fxev60f07ilzqlfdwni0p.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fxev60f07ilzqlfdwni0p.png)

Payload is a headless CMS and application framework. It's meant to boost your development process, but importantly, stay out of your way as your apps get more complex.

No black magic and fully open source, Payload is both an app framework and a headless CMS. It is truly the Rails for TypeScript—and you get an admin panel. You can understand more about Payload using this [YouTube Video](https://www.youtube.com/watch?v=In_lFhzmbME).

You can learn about the [concepts involved](https://payloadcms.com/docs/getting-started/concepts) by using Payload.

[![features](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fnqn1uqupsdkexoq913mm.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fnqn1uqupsdkexoq913mm.png)

Payload interacts with your database via the database adapter that you choose. Right now, Payload officially supports two database adapters:

1. MongoDB w/ Mongoose
2. Postgres w/ Drizzle

Get started with the following command.  

```
npx create-payload-app@latest
```

You will have to generate a Payload secret key and update your `server.ts` to initialize Payload.  

```
import express from 'express'
import payload from 'payload'

require('dotenv').config()
const app = express()

const start = async () => {
  await payload.init({
    secret: process.env.PAYLOAD_SECRET,
    express: app,
  })

  app.listen(3000, async () => {
    console.log(
      "Express is now listening for incoming connections on port 3000."
    )
  })
}

start()
```

[![payload with nextjs](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fghnnf34k70hpb0zjsf5f.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fghnnf34k70hpb0zjsf5f.png)

You can read the [docs](https://payloadcms.com/docs/getting-started/what-is-payload) and see the [demo](https://demo.payloadcms.com/?_gl=1*9x0za3*_ga*NzEzMzkwNzIuMTcxMDE2NDk1MA..*_ga_FLQ5THRMZQ*MTcxMDE2NDk1MC4xLjEuMTcxMDE2NDk1MS4wLjAuMA..).

They also offer an [e-commerce template](https://github.com/payloadcms/payload/tree/main/templates/ecommerce) that integrates seamlessly with Payload + Stripe. This template features a stunning, fully functional front end, including components for shopping carts, checkout processes, order management, and more.

Payload has 18k+ Stars on GitHub and has more than 290 releases so they're constantly improving especially in DB support.

[Star Payload ⭐️](https://github.com/payloadcms/payload)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#13-react-player-a-react-component-for-playing-a-variety-of-urls)13. [React Player](https://github.com/cookpete/react-player) - A React component for playing a variety of URLs.

[![react player](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fimmw7vlgrdfbfxgts0a0.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fimmw7vlgrdfbfxgts0a0.png)

A React component for playing a variety of URLs, including file paths, YouTube, Facebook, Twitch, SoundCloud, Streamable, Vimeo, Wistia, Mixcloud, DailyMotion, and Kaltura. You can see the list of [supported media](https://github.com/cookpete/react-player?tab=readme-ov-file#supported-media).

The maintenance of ReactPlayer is being taken over by Mux which makes them a good choice.

Get started with the following npm command.  

```
npm install react-player
```

This is how you can use this.  

```
import React from 'react'
import ReactPlayer from 'react-player'

// Render a YouTube video player
<ReactPlayer url='https://www.youtube.com/watch?v=LXb3EKWsInQ' />

// If you only ever use one type, use imports such as react-player/youtube to reduce your bundle size.

// like this: import ReactPlayer from 'react-player/youtube'
```

You can also use `react-player/lazy` to lazy load the appropriate player for the URL you pass in. This adds several reactPlayer chunks to your output but reduces your main bundle size.  

```
import React from 'react'
import ReactPlayer from 'react-player/lazy'

// Lazy load the YouTube player
<ReactPlayer url='https://www.youtube.com/watch?v=ysz5S6PUM-U' />
```

You can read the [docs](https://github.com/cookpete/react-player?tab=readme-ov-file#props) and see the [demo](https://cookpete.github.io/react-player/). They provide plenty of options including adding subtitles and making it responsive in an easy way.

They have 8k+ stars on GitHub, are used by 135k+ developers, and have a massive [800k+ weekly downloads](https://www.npmjs.com/package/react-player) on the npm package.

[Star React Player ⭐️](https://github.com/cookpete/react-player)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#14-victory-react-components-for-building-interactive-data-visualizations)14. [Victory](https://github.com/FormidableLabs/victory) - React components for building interactive data visualizations.

[![victory](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fdbayfgbrutvffkk2slja.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fdbayfgbrutvffkk2slja.png)

Victory is an ecosystem of composable React components for building interactive data visualizations.

[![types of components](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F0ua3jegboex4n21aid20.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F0ua3jegboex4n21aid20.png)

Get started with the following npm command.  

```
npm i --save victory
```

This is how you can use this.  

```
<VictoryChart
  domainPadding={{ x: 20 }}
>
  <VictoryHistogram
    style={{
      data: { fill: "#c43a31" }
    }}
    data={sampleHistogramDateData}
    bins={[
      new Date(2020, 1, 1),
      new Date(2020, 4, 1),
      new Date(2020, 8, 1),
      new Date(2020, 11, 1)
    ]}
  />
</VictoryChart>
```

This is how it's rendered. They also offer animations and theme options, which are generally useful.

[![victory chart](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fwdxztxui9zjtue0fz1jo.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fwdxztxui9zjtue0fz1jo.png)

You can read the [docs](https://commerce.nearform.com/open-source/victory/docs) and follow the [tutorial](https://commerce.nearform.com/open-source/victory/docs/native) to get started. They provide around 15 different chart options.

It's also available for [React Native (docs)](https://commerce.nearform.com/open-source/victory/docs/native), so that's a plus point. I would also recommend checking out their [FAQs](https://commerce.nearform.com/open-source/victory/docs/faq#frequently-asked-questions-faq) where they describe solutions of common problems with code and explanation such as styling, annotation (labels), handling axes.

The project has 10k+ Stars on GitHub and is used by 23k+ developers on GitHub.

[Star Victory ⭐️](https://github.com/FormidableLabs/victory)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#15-react-slick-react-carousel-component)15. [React Slick](https://github.com/akiran/react-slick) - React carousel component.

[![react slick](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F4fn2aafcxs281yliyyv0.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F4fn2aafcxs281yliyyv0.png)

React Slick is a carousel component built with React. It is a react port of a slick carousel

Get started with the following npm command.  

```
npm install react-slick --save
```

This is how you can use custom pagination.  

```
import React, { Component } from "react";
import Slider from "react-slick";
import { baseUrl } from "./config";

function CustomPaging() {
  const settings = {
    customPaging: function(i) {
      return (
        <a>
          <img src={`${baseUrl}/abstract0${i + 1}.jpg`} />
        </a>
      );
    },
    dots: true,
    dotsClass: "slick-dots slick-thumb",
    infinite: true,
    speed: 500,
    slidesToShow: 1,
    slidesToScroll: 1
  };
  return (
    <div className="slider-container">
      <Slider {...settings}>
        <div>
          <img src={baseUrl + "/abstract01.jpg"} />
        </div>
        <div>
          <img src={baseUrl + "/abstract02.jpg"} />
        </div>
        <div>
          <img src={baseUrl + "/abstract03.jpg"} />
        </div>
        <div>
          <img src={baseUrl + "/abstract04.jpg"} />
        </div>
      </Slider>
    </div>
  );
}

export default CustomPaging;

```

[![custom pagination](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fhh3qtgnftoapsrdx8w4y.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fhh3qtgnftoapsrdx8w4y.png)

You can read about the [prop options](https://react-slick.neostack.com/docs/api) and [methods](https://react-slick.neostack.com/docs/api#methods) that are available.

You can read the [docs](https://react-slick.neostack.com/docs/get-started) and all [sets of examples](https://react-slick.neostack.com/docs/example/) with code & output.

They have 11k+ Stars on GitHub and 360k+ developers use it on GitHub.

[Star React Slick ⭐️](https://github.com/akiran/react-slick)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#16-medusa-building-blocks-for-digital-commerce)16. [Medusa](https://github.com/medusajs/medusa) - Building blocks for digital commerce.

[![medusa](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fh7vd1qsx7l1jdsz2cnq0.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fh7vd1qsx7l1jdsz2cnq0.png)

Medusa is a set of commerce modules and tools that allow you to build rich, reliable, and performant commerce applications without reinventing core commerce logic.

The modules can be customized and used to build advanced e-commerce stores, marketplaces, or any product that needs foundational commerce primitives. All modules are open source and freely available on npm.

Get started with the following npm command.  

```
npm install medusa-react @tanstack/react-query@4.22 @medusajs/medusa
```

Include this in `app.ts`.  
Only children of MedusaProvider can benefit from its hooks. So, the Storefront component and its child components can now use hooks exposed by Medusa React.  

```
import { MedusaProvider } from "medusa-react"
import Storefront from "./Storefront"
import { QueryClient } from "@tanstack/react-query"
import React from "react"

const queryClient = new QueryClient()

const App = () => {
  return (
    <MedusaProvider
      queryClientProviderProps={{ client: queryClient }}
      baseUrl="http://localhost:9000"
    >
      <Storefront />
    </MedusaProvider>
  )
}

export default App
```

For instance, this is how you can create a cart by using mutations.  

```
import { useCreateCart } from "medusa-react"

const Cart = () => {
  const createCart = useCreateCart()
  const handleClick = () => {
    createCart.mutate({}) // create an empty cart
  }

  return (
    <div>
      {createCart.isLoading && <div>Loading...</div>}
      {!createCart.data?.cart && (
        <button onClick={handleClick}>
          Create cart
        </button>
      )}
      {createCart.data?.cart?.id && (
        <div>Cart ID: {createCart.data?.cart.id}</div>
      )}
    </div>
  )
}

export default Cart
```

They have provided a set of e-commerce modules (vast options) like discounts, price lists, gift cards, and more.

[![e-commerce modules](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fx00lbkpny66esa1yep4u.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fx00lbkpny66esa1yep4u.png)

They also provide an easy way for admin & customer authentication which you can read in the [docs](https://docs.medusajs.com/).

They provide a [nextjs starter template](https://docs.medusajs.com/starters/nextjs-medusa-starter) and [Medusa React](https://docs.medusajs.com/medusa-react/overview) as an SDK.

The project has 22k+ Stars on GitHub and is used by 4k+ developers.

[Star Medusa ⭐️](https://github.com/medusajs/medusa)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#17-react-markdown-markdown-component-for-react)17. [React Markdown](https://github.com/remarkjs/react-markdown) - Markdown component for React.

[![react markdown](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fhcl4bq3m0r415mknvv5h.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fhcl4bq3m0r415mknvv5h.png)

Markdown is crucial, and rendering it with React is highly useful for various scenarios.

It offers a React component capable of safely rendering a string of markdowns into React elements. You can customize the transformation of markdown by passing plugins and specifying components to be used instead of standard HTML elements.

Get started with the following npm command.  

```
npm i react-markdown
```

This is how you can use this.  

```
import React from 'react'
import {createRoot} from 'react-dom/client'
import Markdown from 'react-markdown'
import remarkGfm from 'remark-gfm'

const markdown = `Just a link: www.nasa.gov.`

createRoot(document.body).render(
  <Markdown remarkPlugins={[remarkGfm]}>{markdown}</Markdown>
)
```

Equivalent JSX would be.  

```
<p>
  Just a link: <a href="http://www.nasa.gov">www.nasa.gov</a>.
</p>
```

They have also provided a [cheatsheet](https://commonmark.org/help/) and a ten-minute step-by-step [tutorial](https://commonmark.org/help/tutorial/).

[![tutorial](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F2oboj1ooemoo2j9uh2d7.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F2oboj1ooemoo2j9uh2d7.png)

You can read the [docs](https://github.com/remarkjs/react-markdown?tab=readme-ov-file#install) and check the [demo](https://remarkjs.github.io/react-markdown/).

The project has 12k+ Stars on GitHub, has [2700k+ weekly downloads](https://www.npmjs.com/package/react-markdown), and is used by 200k+ developers which proves how useful it really is.

[Star React Markdown ⭐️](https://github.com/remarkjs/react-markdown)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#18-react-jsonschema-form-for-building-web-forms-from-json-schema)18. [React JSONSchema Form](https://github.com/rjsf-team/react-jsonschema-form) - for building Web forms from JSON Schema.

[![react jsonform schema](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F36bma59hylme02fg5mmi.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F36bma59hylme02fg5mmi.png)

`react-jsonschema-form` automatically generates React forms from JSON Schema, making it ideal for generating forms for any data with just a JSON schema. It offers customization options like uiSchema to tailor the form's appearance beyond default themes.

Get started with the following npm command.  

```
npm install @rjsf/core @rjsf/utils @rjsf/validator-ajv8 --save
```

This is how you can use this.  

```
import { RJSFSchema } from '@rjsf/utils';
import validator from '@rjsf/validator-ajv8';

const schema: RJSFSchema = {
  title: 'Todo',
  type: 'object',
  required: ['title'],
  properties: {
    title: { type: 'string', title: 'Title', default: 'A new task' },
    done: { type: 'boolean', title: 'Done?', default: false },
  },
};

const log = (type) => console.log.bind(console, type);

render(
  <Form
    schema={schema}
    validator={validator}
    onChange={log('changed')}
    onSubmit={log('submitted')}
    onError={log('errors')}
  />,
  document.getElementById('app')
);
```

They provide [advanced customization](https://rjsf-team.github.io/react-jsonschema-form/docs/advanced-customization/) options including custom widgets.

You can read the [docs](https://rjsf-team.github.io/react-jsonschema-form/docs/) and check the [live playground](https://rjsf-team.github.io/react-jsonschema-form/).

It has 13k+ Stars on GitHub and is used by 5k+ developers. They are on the `v5` with 190+ releases so they're constantly improving.

[Star React JSONSchema Form ⭐️](https://github.com/rjsf-team/react-jsonschema-form)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#19-craftjs-build-extensible-drag-and-drop-page-editors)19. [Craft.js](https://github.com/prevwong/craft.js) - build extensible drag and drop page editors.

[![craft.js](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fydxmz82mswa2tlk5onbs.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fydxmz82mswa2tlk5onbs.png)

Page editors enhance user experience but building one from scratch can be daunting. Existing libraries offer pre-built editors with editable components, but customization often requires modifying the library itself.

Craft.js addresses this by modularizing page editor components, simplifying customization with drag-and-drop functionality, and rendering management. Design your editor in React without complex plugin systems, focusing on your specific needs and specifications.

Get started with the following npm command.  

```
npm install --save @craftjs/core
```

They have also provided a [short tutorial](https://craft.js.org/docs/guides/basic-tutorial) on how you can get started. I'm not covering it since it's very easy and detailed.

You can read the [docs](https://craft.js.org/docs/overview) and check the [live demo](https://craft.js.org/) along with one other [live example](https://craft.js.org/examples/basic).

It has around 6k+ Stars on GitHub but still useful considering they are improving.

[Star Craft.js ⭐️](https://github.com/prevwong/craft.js)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#20-gatsby-best-reactbased-framework-with-performance-scalability-and-security-builtin)20. [Gatsby](https://github.com/gatsbyjs/gatsby) - best React-based framework with performance, scalability, and security built-in.

[![gatsby](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fybxi9gplvm2kr8abbtzy.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fybxi9gplvm2kr8abbtzy.png)

Gatsby is a React-based framework that empowers developers to build lightning-fast websites and apps, merging the flexibility of dynamic rendering with the speed of static site generation.

With features like customizable UIs and support for various data sources, Gatsby offers unparalleled control and scalability. Plus, it automates performance optimizations, making it a top choice for static websites.

Get started with the following npm command.  

```
npm init gatsby
```

This is how you can use `Link` in Gatsby (react component).  

```
import React from "react"
import { Link } from "gatsby"

const Page = () => (
  <div>
    <p>
      Check out my <Link to="/blog">blog</Link>!
    </p>
    <p>
      {/* Note that external links still use `a` tags. */}
      Follow me on <a href="https://twitter.com/gatsbyjs">Twitter</a>!
    </p>
  </div>
)
```

They have provided a set of [starter templates](https://www.gatsbyjs.com/starters/) with how to use it, the dependencies involved, and a demo of each of the templates.

[![templates](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F8l35rwb1is60d5q506qu.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F8l35rwb1is60d5q506qu.png)

You can read about some of the [common concepts](https://www.gatsbyjs.com/docs/conceptual/gatsby-concepts/) involved with Gatsby such as React Hydration, the Gatsby build process, and more.

You can read the [docs](https://www.gatsbyjs.com/docs/) and check [tutorials](https://www.gatsbyjs.com/docs/tutorial/) for getting started.

Gatsby has 55k+ Stars on GitHub and is used by 240k+ developers

[Star Gatsby ⭐️](https://github.com/gatsbyjs/gatsby)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#21-chat-ui-kit-react-build-your-chat-ui-with-react-in-minutes)21. [Chat UI Kit React](https://github.com/chatscope/chat-ui-kit-react) - Build your chat UI with React in minutes.

[![chatscope chat ui kit react](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F0ynb25x1se0riwbvq5uv.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F0ynb25x1se0riwbvq5uv.png)

The Chat UI Kit by Chatscope is an open source UI toolkit for developing web chat applications.  
Even though the project is not widely used, the features are useful for beginners just checking out the project.

[![features](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fm1y87b1clbi00tojxgzi.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fm1y87b1clbi00tojxgzi.png)

Get started with the following npm command.  

```
npm install @chatscope/chat-ui-kit-react
```

This is how you can create a GUI.  

```
import styles from '@chatscope/chat-ui-kit-styles/dist/default/styles.min.css';
import { MainContainer, ChatContainer, MessageList, Message, MessageInput } from '@chatscope/chat-ui-kit-react';

<div style={{ position:"relative", height: "500px" }}>
  <MainContainer>
    <ChatContainer>       
      <MessageList>
        <Message model={{
                 message: "Hello my friend",
                 sentTime: "just now",
                 sender: "Joe"
                 }} />
        </MessageList>
      <MessageInput placeholder="Type message here" />        
    </ChatContainer>
  </MainContainer>
</div>
```

You can read the [docs](https://chatscope.io/docs/).  
More [detailed documentation](https://chatscope.io/storybook/react/?path=/docs/documentation-introduction--docs) is present in the storybook.

It provides some handy components like [`TypingIndicator`](https://chatscope.io/storybook/react/?path=/docs/components-typingindicator--docs), [`Multiline Incoming`](https://chatscope.io/storybook/react/?path=/story/components-message--multiline-incoming), and many more.

I know some of you prefer a blog to understand the whole structure, so you can read [How to Integrate ChatGPT with React](https://rollbar.com/blog/how-to-integrate-chatgpt-with-react/) by Rollbar that uses Chat UI Kit React.

Some of the demos that you can see:

- [Chatbot UI](https://mars.chatscope.io/)
- [Chat Friends](https://chatscope.io/demo/chat-friends/) - Check this out!

[![chat friends demo snapshot](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F0hyhqti9yl02rludkocy.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F0hyhqti9yl02rludkocy.png)

[Star Chat UI Kit React ⭐️](https://github.com/chatscope/chat-ui-kit-react)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#22-botonic-react-framework-to-build-conversational-apps)22. [Botonic](https://github.com/hubtype/botonic) - React Framework to Build Conversational Apps.

[![botonic](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fyxeslrg9cjbkej0hcth4.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fyxeslrg9cjbkej0hcth4.png)

Botonic is a full-stack Javascript framework to create chatbots and modern conversational apps that work on multiple platforms: web, mobile, and messaging apps (Messenger, WhatsApp, Telegram, etc). It's built on top of ⚛️ React, Serverless, and Tensorflow.js.

If you're not aware of the concept of conversational apps, you can read them on the [official blog](https://www.hubtype.com/blog/what-are-conversational-apps).

With Botonic you can create conversational applications that incorporate the best out-of-text interfaces (simplicity, natural language interaction) and graphical interfaces (multimedia, visual context, rich interaction).  
It's a powerful combination to provide a better user experience than traditional chatbots, which rely only on text and NLP.

This is how you can simple Botonic is.  

```
export default class extends React.Component {
  static async botonicInit({ input, session, params, lastRoutePath }) {
    await humanHandOff(session))
  }

  render() {
    return (
      <Text>
        Thanks for contacting us! One of our agents
        will attend you as soon as possible.
      </Text>
    )
  }
}
```

They support TypeScript as well so it's a plus point.

You can see some of the [examples](https://botonic.io/examples/) built using Botonic along with their source code.

You can read the [docs](https://botonic.io/docs/welcome) and how to [Create a Conversational App from Scratch](https://botonic.io/docs/create-convapp).

[Star Botonic ⭐️](https://github.com/hubtype/botonic)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#23-react-flowbite-react-components-built-for-flowbite-and-tailwind-css)23. [React Flowbite](https://github.com/themesberg/flowbite-react) - React components built for Flowbite and Tailwind CSS.

[![react flowbite](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F8vt1coti9k3ppmv0y28u.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2F8vt1coti9k3ppmv0y28u.png)

Everyone has a different preference for the UI they want to build their website with.

Flowbite React is an open source collection of UI components, built in React, with utility classes from Tailwind CSS that you can use as a starting point for user interfaces and websites.

Get started with the following npm command.  

```
npm i flowbite-react
```

This is how you can use table and keyboard components together.  

```

'use client';

import { Kbd, Table } from 'flowbite-react';
import { MdKeyboardArrowDown, MdKeyboardArrowLeft, MdKeyboardArrowRight, MdKeyboardArrowUp } from 'react-icons/md';

function Component() {
  return (
    <Table>
      <Table.Head>
        <Table.HeadCell>Key</Table.HeadCell>
        <Table.HeadCell>Description</Table.HeadCell>
      </Table.Head>
      <Table.Body className="divide-y">
        <Table.Row className="bg-white dark:border-gray-700 dark:bg-gray-800">
          <Table.Cell className="whitespace-nowrap font-medium text-gray-900 dark:text-white">
            <Kbd>Shift</Kbd> <span>or</span> <Kbd>Tab</Kbd>
          </Table.Cell>
          <Table.Cell>Navigate to interactive elements</Table.Cell>
        </Table.Row>
        <Table.Row className="bg-white dark:border-gray-700 dark:bg-gray-800">
          <Table.Cell className="whitespace-nowrap font-medium text-gray-900 dark:text-white">
            <Kbd>Enter</Kbd> or <Kbd>Spacebar</Kbd>
          </Table.Cell>
          <Table.Cell>Ensure elements with ARIA role="button" can be activated with both key commands.</Table.Cell>
        </Table.Row>
        <Table.Row className="bg-white dark:border-gray-700 dark:bg-gray-800">
          <Table.Cell className="whitespace-nowrap font-medium text-gray-900 dark:text-white">
            <span className="inline-flex gap-1">
              <Kbd icon={MdKeyboardArrowUp} />
              <Kbd icon={MdKeyboardArrowDown} />
            </span>
            <span> or </span>
            <span className="inline-flex gap-1">
              <Kbd icon={MdKeyboardArrowLeft} />
              <Kbd icon={MdKeyboardArrowRight} />
            </span>
          </Table.Cell>
          <Table.Cell>Choose and activate previous/next tab.</Table.Cell>
        </Table.Row>
      </Table.Body>
    </Table>
  );
}
```

[![kbd & table](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fmnu5xqlqob72t9oxkb4k.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fmnu5xqlqob72t9oxkb4k.png)

You can read the [docs](https://www.flowbite-react.com/docs/getting-started/introduction) and see features in [Storybook](https://storybook.flowbite-react.com/?path=/story/components-accordion--always-open). You can also see the list of [components](https://www.flowbite-react.com/docs/components/accordion).

In my opinion, this is good if you quickly want to set up a UI, but don't want to end up using pre-defined library components for a high-quality open source project.

With over 1.5k stars on GitHub and a user base of 37k+ developers, this project is widely recognized and trusted by the community, making it a solid option.

[Star React Flowbite ⭐️](https://github.com/themesberg/flowbite-react)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#24-dnd-kit-lightweight-performant-accessible-and-extensible-drag-amp-drop)24. [DND Kit](https://github.com/clauderic/dnd-kit) - lightweight, performant, accessible, and extensible drag & drop.

[![DND kit](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Foz5m8hf4t4u4v2jzusl1.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Foz5m8hf4t4u4v2jzusl1.png)

This is a robust drag & drop toolkit for React, boasting features like customizable collision detection, multiple activators, and auto-scrolling.

Designed with React in mind, it offers hooks for easy integration without requiring major architectural changes. Supporting diverse use cases, from lists to grids and virtualized lists, it's both dynamic and lightweight, with no external dependencies.

Get started with the following npm command.  

```
npm install @dnd-kit/core
```

This is how you can build a draggable & droppable component.

`Example.jsx`  

```

import React, {useState} from 'react';
import {DndContext} from '@dnd-kit/core';
import {Draggable} from './Draggable';
import {Droppable} from './Droppable';

function Example() {
  const [parent, setParent] = useState(null);
  const draggable = (
    <Draggable id="draggable">
      Go ahead, drag me.
    </Draggable>
  );

  return (
    <DndContext onDragEnd={handleDragEnd}>
      {!parent ? draggable : null}
      <Droppable id="droppable">
        {parent === "droppable" ? draggable : 'Drop here'}
      </Droppable>
    </DndContext>
  );

  function handleDragEnd({over}) {
    setParent(over ? over.id : null);
  }
}
```

`Droppable.jsx`  

```

import React from 'react';
import {useDroppable} from '@dnd-kit/core';

export function Droppable(props) {
  const {isOver, setNodeRef} = useDroppable({
    id: props.id,
  });
  const style = {
    opacity: isOver ? 1 : 0.5,
  };

  return (
    <div ref={setNodeRef} style={style}>
      {props.children}
    </div>
  );
} 
```

`Draggable.jsx`  

```

import React from 'react';
import {useDraggable} from '@dnd-kit/core';
import {CSS} from '@dnd-kit/utilities';

function Draggable(props) {
  const {attributes, listeners, setNodeRef, transform} = useDraggable({
    id: props.id,
  });
  const style = {
    // Outputs `translate3d(x, y, 0)`
    transform: CSS.Translate.toString(transform),
  };

  return (
    <button ref={setNodeRef} style={style} {...listeners} {...attributes}>
      {props.children}
    </button>
  );
}
```

I'm holding the draggable component on the droppable one.

[![custom component](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fcf98be5hq9am3f2s1dwv.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fcf98be5hq9am3f2s1dwv.png)

You can read the [docs](https://docs.dndkit.com/) and the [options of sensors](https://docs.dndkit.com/introduction/installation#core-library) such as Mouse, and Pointer.

It has 10k+ Stars on GitHub and is used by 47k+ Developers on GitHub.

[Star DND Kit ⭐️](https://github.com/clauderic/dnd-kit)

---

## [](https://dev.to/winglang/build-a-full-stack-app-using-these-react-libraries-and-cloud-backend-2o4b?context=digest#25-expo-develop-review-amp-deploy-native-apps-from-a-single-react-codebase-for-android-ios-amp-web)25. [Expo](https://github.com/expo/expo) - Develop, review, & deploy native apps from a single React codebase for Android, iOS, & web.

[![expo](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fdbvox6srxdh409h51gnf.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fdbvox6srxdh409h51gnf.png)

Expo is an open source platform for making universal native apps that run on Android, iOS, and the web. It includes a universal runtime and libraries that let you build native apps by writing React and JavaScript. You can read about the [core concepts](https://docs.expo.dev/core-concepts/) involved with the Expo.

[![comparison](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fnhutcjp5eqmfbxcfj8b0.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Fnhutcjp5eqmfbxcfj8b0.png)

When Expo was first created, React Native had yet to be publicly released. This means there were no third-party packages.

To make React Native easier to use, they made a bunch of tools themselves to handle common tasks. Some of these tools have been changed and improved over time to fit different needs.

The [Expo SDK](https://docs.expo.dev/versions/latest/) is thoroughly tested, written in TypeScript, and made for Android, iOS, and the web. Every part of the Expo SDK works together smoothly, so you won't have any trouble upgrading. All Expo tools and services work great in any React Native app.

Get started using the following commands.  

```
# create a project named first-app
npx create-expo-app first-app

# navigate to directory
cd first-app

# to start
npx expo start
```

Ultimately, you have to make several components to design any screen. Such as the image can be attached to the screen with the below code.  

```
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, View, Image } from 'react-native';

const PlaceholderImage = require('./assets/images/background-image.png');

export default function App() {
  return (
    <View style={styles.container}>
      <View style={styles.imageContainer}>
        <Image source={PlaceholderImage} style={styles.image} />
      </View>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#25292e',
    alignItems: 'center',
  },
  imageContainer: {
    flex: 1,
    paddingTop: 58,
  },
  image: {
    width: 320,
    height: 440,
    borderRadius: 18,
  },
});

```

[![screen](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Ff2j1foy6nwbkptpc6q55.png)](https://media.dev.to/cdn-cgi/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Ff2j1foy6nwbkptpc6q55.png)

You can also use the SDK for [Camera](https://docs.expo.dev/versions/latest/sdk/camera/) that renders a preview for the device's front or back camera & [Notifications](https://docs.expo.dev/versions/latest/sdk/notifications/) that provides an API to fetch push notification tokens and to present, schedule, receive and respond to notifications.

They also provide a [step-by-step tutorial](https://docs.expo.dev/tutorial/introduction/) that you can follow to get started.

You can read the [docs](https://docs.expo.dev/) and see the [live demo of Hello World](https://snack.expo.dev/?platform=android) on Snack.

It has 28k+ Stars on GitHub and is used by a massive amount of 850k+ developers.

[Star Expo ⭐️](https://github.com/expo/expo)

---

Here are some resources that can help you with React.

- [React Bits](https://github.com/vasanthk/react-bits) - React patterns, techniques, tips, and tricks.
- [30 Days of React](https://github.com/Asabeneh/30-Days-Of-React) - Step-by-step guide to learn React in 30 days.
- [React Interview Questions](https://github.com/sudheerj/reactjs-interview-questions) - Top 500 ReactJS Interview Questions & Answers (35k+ Stars).

If you're looking for React-like alternative libraries, you can check out Inferno & Preact.