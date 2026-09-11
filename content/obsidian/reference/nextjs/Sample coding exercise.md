# Todo List Coding Exercise

## Introduction

Welcome to the Todo List coding exercise! This exercise is designed to help you get hands-on experience with React, TypeScript, and APIs. By the end of this exercise, you will have created a simple Todo application that allows you to perform CRUD operations on in-memory data in NodeJS.

## Objectives

Your task is to create a Todo application with the following features:

1. **Display Todos**: Render a list of todos.
2. **Add Todo**: Allow the user to add new todos.
3. **Update Todo**: Allow the user to mark todos as complete or update their text.
4. **Delete Todo**: Allow the user to delete todos.
5. **Summary**: Display a summary of active and completed todos.
6. **Styling**: Use CSS Flexbox to layout your Todo components.

## Requirements
- Use TypeScript to define the data structure for your todos.
- Use React functional components and hooks (`useState`, `useEffect`) for state management.
- Perform CRUD operations on the client-side data.
- Use array operations like `map`, `reduce`, `filter`, and `forEach` to manipulate the todo list.
- Use Next.js API routes to simulate fetching and updating data in memory.
- Ensure that the application is styled and responsive using CSS Flexbox.

## Setup
- Refer to NextJS docs

## Data Structure

Define a TypeScript `interface` for your Todo model. Each todo should have an `id`, `title`, `isComplete`, `label` and any other fields you deem necessary.

## Functionalities

### Display Todos
Create a component that displays a list of todos. Use the `useEffect` hook to simulate fetching data from an API endpoint when the component mounts.

### Add Todo
Implement a form that allows users to add new todos. Use the `useState` hook to manage form state.

### Update Todo
Allow users to toggle the `isComplete` status of a todo and to update the title of a todo. You can create an inline form or a separate component for this functionality.

### Delete Todo
Implement a button or icon that, when clicked, will delete a todo from the list.

### Summary
Create a component that displays the total number of active and completed todos.

## Styling

Use CSS Flexbox to layout your todo items and ensure that the application is responsive. You should use traditional CSS files.

## Component Composition
To practice composing components in React, you will need to create separate components for different parts of the application. Do not put all of your code in one file. Here are the components you will need to create:

1. **TodoList Component**: This component will be responsible for rendering the list of Todo items.
2. **TodoItem Component**: This component represents a single Todo item in the list, displaying the title and status (complete/incomplete). It should also include functionality to toggle the completion status and to delete the Todo.
3. **AddTodo Form Component**: A component that contains a form for adding a new Todo. It should update the TodoList component upon submission
4. **Layout Component**: A generic layout component that can be reused across the application, containing the header and the main content area where other components will be rendered.

## API Routes

Set up API routes in Next.js to handle fetching (`GET`), creating (`POST`), updating (`PUT`), and deleting (`DELETE`) todos. Since there is no database, you can store your todos in an array in memory.

Example:
```typescript
// app/api/todos/route.ts

// This array will act as in-memory storage for your todos.
let todos: Todo[] = [];

// Define your API handlers here...
```

## Evaluation Criteria

Your submission will be evaluated based on the following criteria:

- Functionality: All CRUD operations should work as expected.
- Code Quality: Your code should be clean, well-organized, and easy to read.
- TypeScript Usage: Proper use of TypeScript for type checking and defining data structures.
- React Best Practices: Proper use of React hooks and component structure.
- Styling: The layout should be responsive and utilize CSS Flexbox effectively.