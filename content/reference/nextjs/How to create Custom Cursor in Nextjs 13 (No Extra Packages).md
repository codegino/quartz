Originally From: https://blog.stackademic.com/how-to-create-custom-cursor-in-nextjs-13-no-extra-packages-060369a736c9

# Introduction

In this blog, we’ll explore the exciting world of custom cursors in Next.js 13. I’ll walk you through the steps to create and implement your own custom cursor, enabling you to take full control of the visual and interactive aspects of this essential user interface element. Whether you’re building an artistic portfolio, an e-commerce site, or an immersive gaming experience, custom cursors can be a fun and effective way to make your project truly stand out. Let’s dive in and discover how to bring a new level of creativity and interactivity to your Next.js 13 application by designing and implementing a custom cursor.

# Set up

Run the following command to set up a latest Nextjs app

npx create-next-app@latest custom-cursor  
cd custom-cursor  
yarn dev

# Create Flare Component

Create a flare component in **src/components/FlareCursor.tsx**

Paste the Following Code

```tsx
"use client";  
  
import React, { useState, useEffect } from "react";  
  
const FlareCursor = () => {  
  const [position, setPosition] = useState({ x: 0, y: 0 });  
  
  const [isPointer, setIsPointer] = useState(false);  
  
  const handleMouseMove = (e: any) => {  
    setPosition({ x: e.clientX, y: e.clientY });  
  
    const target = e.target;  
  
    setIsPointer(  
      window.getComputedStyle(target).getPropertyValue("cursor") === "pointer"  
    );  
  };  
  
  useEffect(() => {  
    window.addEventListener("mousemove", handleMouseMove);  
  
    return () => window.removeEventListener("mousemove", handleMouseMove);  
  }, []);  
  
  const flareSize = isPointer ? 0 : 30;  
  
  const cursorStyle = isPointer ? { left: "-100px", top: "-100px" } : {};  
  
  return (  
    <div  
      className={`flare ${isPointer ? "pointer" : ""}`}  
      style={{  
        ...cursorStyle,  
        left: `${position.x}px`,  
        top: `${position.y}px`,  
        width: `${flareSize}px`,  
        height: `${flareSize}px`,  
      }}  
    ></div>  
  );  
};  
  
export default FlareCursor;
```

## What does this code mean?

When you move your mouse, the code keeps an eye on it. If your mouse is over something that should change the cursor, it makes the cursor do cool stuff. If not, it hides the custom cursor.

This code does all this by listening to your mouse movements and checking the style of the thing your mouse is over. If it’s something special, like a link, the cursor gets bigger and changes. If it’s not, the cursor disappears.

# Styling the Cursor

Paste the following code in **src/app/globals.css**

```css
/* FLARE CURSOR  */  
html,  
body {  
  scroll-behavior: smooth;  
}  
  
body,  
* {  
  cursor: none;  
}  
  
.flare {  
  position: fixed;  
  top: 0;  
  left: 0;  
  border: 2px solid #ffffff2b;  
  border-radius: 50%;  
  mix-blend-mode: difference;  
  pointer-events: none;  
  transform: translate(-50%, -50%);  
  z-index: 999999 !important;  
  backdrop-filter: blur(1px);  
  background-color: white;  
  transition: width 0.2s ease-in-out, height 0.2s ease-in-out;  
  padding: 10px;  
  display: flex;  
  justify-content: center;  
  align-items: center;  
}  
  
@media screen and (max-width: 768px) {  
  .flare {  
    display: none;  
    width: 0;  
    height: 0;  
    transition: width 0.2s ease-in-out, height 0.2s ease-in-out,  
      opacity 0.2s ease-in-out;  
  }  
}  
  
.flare.pointer {  
  display: none;  
  opacity: 0 !important;  
  transition: width 0.2s ease-in-out, height 0.2s ease-in-out,  
    opacity 0.2s ease-in-out;  
}
```

I just disabled cursor as none and added custom styling for the cursor

# Adding Cursor to Layout

Add the Flare cursor component in **src/app/layout.tsx**

```tsx
// app/layout.tsx  
import FlareCursor from "@/components/Flarecursor";  
  
export const metadata = {  
  title: "Create Next App",  
  description: "Generated by create next app",  
};  
  
export default function RootLayout({  
  children,  
}: {  
  children: React.ReactNode;  
}) {  
  return (  
    <html lang="en">  
      <body>  
  <FlareCursor />  
  {children}  
    </body>  
    </html>  
  );  
}
```

This will add the cursor to the whole nextjs app

# Wrapping up

In this blog, we’ve explored the fascinating realm of custom cursors within the context of Next.js 13.

By delving into the `FlareCursor` React component, we've uncovered a simple yet powerful way to breathe life into your web project. This custom cursor not only adds a touch of style but also enhances user interaction. As users navigate your site, their cursor becomes more than just a tool; it transforms into an element that responds to their actions, creating a sense of immersion and uniqueness.

By leveraging the React magic of hooks like `useState` and `useEffect`, this code adapts your cursor's behavior dynamically. It pays attention to where your mouse goes and adapts itself to the content you interact with. Whether you're building an art portfolio, an e-commerce platform, or an engaging game, a custom cursor can be the extra flair that sets your project apart.