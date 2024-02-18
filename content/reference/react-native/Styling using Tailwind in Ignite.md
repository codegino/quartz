# Ignite

## Link
https://www.nativewind.dev/quick-starts/ignite

## 1. Add NativeWind[​](https://www.nativewind.dev/quick-starts/ignite#1-add-nativewind "Direct link to 1. Add NativeWind")

You will need to install `nativewind` and it's peer dependency `tailwindcss`.

```
yarn add nativewindyarn add --dev tailwindcss
```

## 2. Setup Tailwind CSS[​](https://www.nativewind.dev/quick-starts/ignite#2-setup-tailwind-css "Direct link to 2. Setup Tailwind CSS")

Run `npx tailwindcss init` to create a `tailwind.config.js` file

Add the paths to all of your component files in your tailwind.config.js file.

```
// tailwind.config.js

module.exports = {
- content: [],
+ content: ["./app/components.{js,jsx,ts,tsx}", "./ignite/**/*.{js,jsx,ts,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

## 3. Add the Babel plugin[​](https://www.nativewind.dev/quick-starts/ignite#3-add-the-babel-plugin "Direct link to 3. Add the Babel plugin")

Modify your `babel.config.js`

```
// babel.config.js  
module.exports = {  
- plugins: [],  
+ plugins: ["nativewind/babel"],  
};
```