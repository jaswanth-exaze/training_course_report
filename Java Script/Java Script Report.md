JavaScript Learning Syllabus
-----------------------------

1. Introduction to JavaScript
   - What is JavaScript
   - How JS runs (Browser, Node.js)
   - JavaScript Engine (V8) basics
   - Linking JS to HTML
   - Console usage

2. JavaScript Basics
   - Variables: var, let, const
   - Data types: primitive & non-primitive
   - Operators: arithmetic, logical, comparison
   - Template literals
   - Comments
   - Type conversion

3. Control Flow
   - if, else if, else
   - switch
   - Loops: for, while, do-while
   - break & continue

4. Functions
   - Function declaration
   - Function expression
   - Arrow functions
   - Parameters & return values
   - Default parameters
   - Scope: local, global
   - Lexical scope

5. Arrays
   - Creating arrays
   - Core methods: push, pop, shift, unshift
   - Higher-order methods: map, filter, reduce
   - Other utilities: find, some, every, forEach
   - sort, reverse
   - Spread & rest operators

6. Objects
   - Object literals
   - Accessing properties
   - Adding/removing properties
   - this keyword
   - Object methods
   - Object destructuring

7. Strings
   - Core string methods (slice, substring, replace, etc.)
   - Template literals
   - Escape characters

8. DOM Manipulation
   - Selecting elements
   - Modifying text, HTML, and styles
   - Creating & removing elements
   - Event handling (click, input, submit, key events)
   - Event bubbling & capturing

9. BOM (Browser Object Model)
   - window object
   - location
   - history
   - localStorage & sessionStorage
   - Timers: setTimeout, setInterval

10. Error Handling
    - try, catch, finally
    - throw

11. ES6+ Features
    - let, const
    - Arrow functions
    - Classes
    - Modules (import/export)
    - Spread & rest
    - Destructuring
    - Promises
    - Async/await

12. Working with JSON
    - JSON.parse
    - JSON.stringify

13. Fetch API & HTTP Requests
    - GET, POST
    - async/await with fetch
    - Error handling
    - Working with public APIs

14. Advanced Arrays & Objects
    - Shallow copy vs deep copy
    - Immutable patterns
    - Higher-order functions (deep usage)

15. Object-Oriented JavaScript (OOP)
    - Constructor functions
    - Prototypes
    - Classes
    - Inheritance

16. Regular Expressions
    - Patterns & flags
    - Testing & matching strings

17. Modules
    - import / export
    - Default vs named exports

18. Asynchronous JavaScript (Deep Concepts)
    - Callback hell
    - Promises
    - Async/await
    - Event loop
    - Microtasks vs macrotasks

19. JavaScript Best Practices
    - Clean code principles
    - Naming conventions
    - Modular code design
    - Avoiding common mistakes

20. Mini Projects
    - Calculator
    - To-Do List
    - Quiz App
    - Weather app (API)
    - Form validation project
    - Counter app
    - Responsive menu toggle

21. Final Project
    - Complete project using DOM, events, localStorage, and API
# Part 2 – JavaScript Basics  
## 1. Variables (var, let, const)

Variables are containers used to store values in JavaScript.  
They allow your program to read, update, and manipulate data dynamically.

JavaScript provides **three keywords** to declare variables:
- `var`  
- `let`  
- `const`  

Each behaves differently in terms of **scope**, **updating**, and **re-declaration.

------------------------------------------------------------

# let (Modern Variable Declaration)

### Key Points
- **Block-scoped** (available only inside `{ … }`)  
- **Can be updated**  
- **Cannot be re-declared** in the same block  
- Introduced in **ES6**

### When to use `let`  
Use `let` when the value **needs to change**, e.g., loop counters, temporary values, intermediate calculations.

### Example
```javascript
<script>
let score = 10;
score = 20;
console.log(score);
</script>
```
**Output:**  
20

------------------------------------------------------------

# const (Immutable Binding)

### Key Points
- **Block-scoped**  
- **Cannot be reassigned** (no update to the binding)  
- **Cannot be re-declared**  
- **Must be initialized** at declaration  
- Recommended for values that **should not be reassigned**

### Important Clarification
`const` prevents **reassignment** of the binding, but **does NOT make objects/arrays immutable**. You can still change properties/elements.

### Example (object mutation allowed)
```javascript
<script>
const user = { name: "Jaswanth" };
user.name = "Kumar";   // allowed: modifying property
console.log(user);
</script>
```
**Output:**  
{ name: "Kumar" }

### Example (reassignment not allowed)
```javascript
<script>
const x = 5;
x = 10; // Uncaught TypeError: Assignment to constant variable.
</script>
```

------------------------------------------------------------

# var (Legacy Declaration — avoid in modern code)

### Key Points
- **Function-scoped** (NOT block-scoped)  
- **Can be updated** and **re-declared**  
- Subject to **hoisting** (declaration moved to top, value undefined until assignment)  
- Can lead to bugs due to unexpected scope leakage

### Why avoid `var`  
`var` can unintentionally leak variables outside blocks and behave unpredictably due to hoisting.

### Example (hoisting)
```javascript
<script>
console.log(a); // undefined (declaration hoisted, value not assigned yet)
var a = 10;
</script>
```
**Output:**  
undefined

### Example (block leakage)
```javascript
<script>
if (true) {
  var leaked = "I'm outside now";
}
console.log(leaked); // "I'm outside now"
</script>
```
**Output:**  
I'm outside now

------------------------------------------------------------

# Summary Table (Quick Reference)

| Feature            | var                    | let                   | const                    |
|--------------------|------------------------|------------------------|--------------------------|
| Scope              | Function-scoped        | Block-scoped           | Block-scoped             |
| Can be updated     | Yes                    | Yes                    | No (binding)             |
| Can be re-declared | Yes                    | No (in same scope)     | No                       |
| Must initialize    | No                     | No                     | Yes                      |
| Hoisting behavior  | Yes (declared, undefined) | Yes (declared, TDZ)  | Yes (declared, TDZ)      |
| Use in modern JS   | Avoid (legacy)         | Recommended for mutable values | Recommended for constants |

> TDZ = Temporal Dead Zone (accessing `let`/`const` before initialization throws ReferenceError)

------------------------------------------------------------

# Common Patterns & Gotchas

- Prefer `const` by default; use `let` when you must reassign.  
- Do **not** use `var` unless required for legacy compatibility.  
- `const` stops reassignment but not mutation — use patterns like `Object.freeze()` if you need immutability.  
- Be careful with loops and closures when using `var` (classic closure trap).

### Example: closure trap with var vs let
```javascript
<script>
for (var i = 0; i < 3; i++) {
  setTimeout(() => console.log("var:", i), 10); // var: 3, 3, 3
}

for (let j = 0; j < 3; j++) {
  setTimeout(() => console.log("let:", j), 10); // let: 0, 1, 2
}
</script>
```
**Output (order may vary):**  
var: 3  
var: 3  
var: 3  
let: 0  
let: 1  
let: 2

Explanation: `var` shares one `i`, `let` creates a fresh binding each iteration.

------------------------------------------------------------

# Full Example (Your Required Format)
```javascript
<script>
let name = "Jaswanth";
const age = 22;
var city = "Hyderabad";

console.log(name, age, city);
</script>
```
**Output:**  
Jaswanth 22 Hyderabad

------------------------------------------------------------

# Practice Tasks
1. Declare three variables (`name`, `age`, `city`) using `let`/`const` and print them.  
2. Create a `const` array and push a new item — observe behavior.  
3. Try reassigning a `const` value — observe the error.  
4. Create a `for` loop using `var` and `let`, then log values inside `setTimeout` to see the difference.  
5. Use `Object.freeze()` on an object declared with `const` and try to mutate it.

------------------------------------------------------------

# Short Checklist (What you should remember)
- Use `const` by default.  
- Use `let` when you need reassignment.  
- Avoid `var`.  
- `const` ≠ immutable (for objects/arrays).  
- Be aware of hoisting and TDZ.

