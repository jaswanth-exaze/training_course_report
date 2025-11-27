## JavaScript Learning Syllabus

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

---

---

---

---

# Part 1 – Introduction to JavaScript

## 1. What is JavaScript?

JavaScript is a high-level, dynamic programming language used mainly to make web pages interactive.
It runs in browsers and on servers using Node.js.

### Why JavaScript?

- Runs everywhere (browser + backend)
- Beginner-friendly
- Huge community and libraries
- Foundation of modern web development

---

## 2. Where Does JavaScript Run?

JavaScript can run in two main environments:

1. Browser (Client-Side)
2. Node.js (Server-Side)

### Execution Flow Diagram

```
           ┌───────────────────────────────┐
           │       JavaScript Code         │
           └───────────────────────────────┘
                        │
             ┌──────────┴──────────┐
             │                     │
        ┌──────────────┐    ┌────────────────┐
        │   Browser    │    │    Node.js     │
        │ (Frontend)   │    │   (Backend)    │
        └──────────────┘    └────────────────┘
```

### Browser Responsibilities

- DOM manipulation
- Event handling (click, submit)
- Animations
- Input validation

### Node.js Responsibilities

- APIs
- Databases
- Authentication
- File operations

---

## 3. JavaScript Engines (V8)

Each browser uses a JavaScript engine to execute JS code:

| Browser | Engine         |
| ------- | -------------- |
| Chrome  | V8             |
| Firefox | SpiderMonkey   |
| Safari  | JavaScriptCore |
| Edge    | V8             |

### Engine Internal Workflow

```
       JavaScript Code
            │
            ▼
[1] Parsing (checks syntax)
            │
            ▼
[2] Compilation (JIT compiler)
            │
            ▼
[3] Execution (runs the code)
```

---

## 4. Linking JavaScript to HTML

### a) Internal Script

```
   <script>
       console.log("Hello JS");
   </script>
```

### b) External Script (Recommended)

```
<script src="app.js"></script>
```

### Notes

- External JS improves structure.
- Script tag should be placed before </body> for faster load.

---

## 5. Using the Browser Console

You can open the console using:

- Windows: Ctrl + Shift + I
- Mac: Cmd + Option + I

### Common Console Methods

- console.log("message")
- console.warn("warning")
- console.error("error")
- console.table(data)

Purpose:

- Debugging
- Testing code quickly

---

## 6. JavaScript Syntax Basics

- JavaScript is case sensitive.
  Example: `name` ≠ `Name`
- Statements usually end with `;`
- Code blocks are written using `{ }`

---

## 7. Comments in JavaScript

### Single-Line Comment

```
// This is a comment
```

### Multi-Line Comment

```
/*
   This is a
   multi-line comment
*/
```

---

## 8. Simple Example

```
   <script>
       let user = "Jaswanth";
       console.log("Welcome " + user);
   </script>
```

Output:
Welcome Jaswanth

---

## 9. Key Notes

- JavaScript is single-threaded.
- Managed using an event loop.
- Can handle asynchronous tasks using:
  - callbacks
  - promises
  - async/await

---

## 10. Practice Tasks

1. Print "JavaScript Started" using console.log().
2. Create an HTML file and link an external JS file.
3. Print your name in the console.
4. Try console.log(), console.warn(), console.error().
5. Write both single-line and multi-line comments in JS.
---
# Brief History of JavaScript

JavaScript was created in **1995** by **Brendan Eich** while working at Netscape.  
It was developed in just **10 days** to make web pages interactive.

------------------------------------------------------------

## Key Milestones

### 1995 – Creation
- JavaScript was originally called **Mocha**, then **LiveScript**, and finally renamed **JavaScript** for marketing reasons.

### 1996 – Standardization Begins
- Microsoft created **JScript** for Internet Explorer.
- To avoid browser conflicts, JavaScript was standardized and became **ECMAScript**.

### 1997 – ECMAScript 1 (ES1)
- The first official version of the JavaScript standard.

### 2009 – ECMAScript 5 (ES5)
- Major improvements: JSON support, strict mode, array methods like map, filter, reduce.

### 2015 – ECMAScript 6 (ES6)
- Biggest update in history.
- Introduced let, const, arrow functions, classes, promises, modules, template literals, and more.

### 2016–Present – Yearly Updates
- JavaScript now receives an update **every year**.
- Features added gradually: async/await, optional chaining, BigInt, etc.

------------------------------------------------------------

## Why JavaScript Grew So Fast?

- Only language that runs natively in browsers.
- Became the foundation of frontend development.
- Later expanded to backend via **Node.js** (2009).
- Massive ecosystem: frameworks, tools, libraries.

------------------------------------------------------------

## Current Status

JavaScript is one of the most widely used programming languages in the world.  
It powers:
- Web applications  
- Mobile apps  
- Desktop apps  
- Backend servers  
- IoT devices  

It continues to evolve with new features added every year.

---

# Part 2 – JavaScript Basics

# 1. Variables (var, let, const)

Variables store values in JavaScript.  
They allow your program to read, update, and manipulate data dynamically.

JavaScript provides three keywords to declare variables:

- var
- let
- const

Each behaves differently in terms of scope, updating, and re-declaration.

---

# let (Modern Variable Declaration)

### Key Points

- Block-scoped
- Can be updated
- Cannot be re-declared in the same block
- Introduced in ES6

### When to use let

Use when the value needs to change (loop counters, temporary values).

### Example

```javascript
<script>let score = 10; score = 20; console.log(score);</script>
```

Output:  
20

---

# const (Immutable Binding)

### Key Points

- Block-scoped
- Cannot be reassigned
- Cannot be re-declared
- Must be initialized at declaration

### Important Clarification

const prevents reassignment, but does not make objects or arrays immutable.

### Example (object mutation allowed)

```javascript
<script>
const user = { name: "Jaswanth" };
user.name = "Kumar";
console.log(user);
</script>
```

Output:  
{ name: "Kumar" }

### Example (reassignment not allowed)

```javascript
<script>const x = 5; x = 10; // Error</script>
```

---

# var (Legacy Declaration — avoid in modern code)

### Key Points

- Function-scoped
- Can be updated and re-declared
- Hoisted (initialized as undefined)
- Can cause unexpected behavior

### Example (hoisting)

```javascript
<script>console.log(a); var a = 10;</script>
```

Output:  
undefined

### Example (block leakage)

```javascript
<script>
if (true) {
  var leaked = "I'm outside now";
}
console.log(leaked);
</script>
```

Output:  
I'm outside now

---
```javascript
if (true) {
     let b = 200; 
     var c = 100; 
} 
console.log(b);   // ReferenceError: b is not defined
console.log(c);   // 100
```
What happens?

let b → block-scoped → exists only inside { }

var c → function-scoped → ignores the block and becomes global (since not inside a function)

Reason:

b is block-scoped → not available outside the if block.

c ignores block scope → becomes global → accessible outside the if block.

```javascript
function test() { 
    let b = 200; 
    var c = 100; 
} 
console.log(b);  // ReferenceError: b is not defined
console.log(c);  // ReferenceError: c is not defined
```

b → declared with let inside a function → function-scoped, accessible only inside the function
    
c → declared with var inside a function → also function-scoped, accessible only inside the function.

REASON:
Variables inside a function (whether let or var) never leak outside the function.

So both b and c are NOT available outside test().
# Summary Table (Quick Reference)

| Feature            | var             | let          | const               |
| ------------------ | --------------- | ------------ | ------------------- |
| Scope              | Function-scoped | Block-scoped | Block-scoped        |
| Can be updated     | Yes             | Yes          | No                  |
| Can be re-declared | Yes             | No           | No                  |
| Must initialize    | No              | No           | Yes                 |
| Hoisting behavior  | Yes (undefined) | Yes (TDZ)    | Yes (TDZ)           |
| Use in modern JS   | Avoid           | Good         | Best default choice |

---

# 2. Data Types (Primitive & Non-Primitive)

JavaScript has two major categories of data types.

---

# Primitive Data Types

Primitive values are stored directly in memory and are immutable.

### Types

- String
- Number
- Boolean
- Null
- Undefined
- BigInt
- Symbol

---

# String

Represents a sequence of characters.  
Used for text.

### Example

```javascript
<script>
  let firstName = "Jaswanth"; let msg = 'Welcome'; let text = `Template literal
  example`; console.log(firstName, msg, text);
</script>
```

---

# Number

JavaScript uses floating-point numbers for both decimals and integers.

### Example

```javascript
<script>let age = 23; let price = 99.5; console.log(age, price);</script>
```

---

# Boolean

Represents true or false.

### Example

```javascript
<script>
  let isLoggedIn = true; let isVerified = false; console.log(isLoggedIn,
  isVerified);
</script>
```

---

# Null

Intentional empty value.

### Example

```javascript
<script>let data = null; console.log(data);</script>
```

---

# Undefined

A variable declared but not assigned.

### Example

```javascript
<script>let value; console.log(value);</script>
```

---

# BigInt

Used for very large integers.

### Example

```javascript
<script>let big = 123456789123456789n; console.log(big);</script>
```

---

# Symbol

Used to create unique identifiers.

### Example

```javascript
<script>
  let s1 = Symbol("id"); let s2 = Symbol("id"); console.log(s1 === s2);
</script>
```

Output:  
false

---

# Non-Primitive Types

Stored by reference.

### Types

- Object
- Array
- Function

---

### Example (Object, Array, Function)

```javascript
<script>
let user = { name: "Jaswanth", age: 22 };
let numbers = [10, 20, 30];
function greet() { console.log("Hello"); }
</script>
```

---

# 3. Operators (Arithmetic, Logical, Comparison)

Operators allow mathematical and logical operations.

---

# Arithmetic Operators

```
-  Addition +
-  Subtraction   -
-  Multiplication  *
-  Division /
-  Modulus  %
- Exponent  **
```

### Example

```javascript
<script>
  let x = 10; let y = 3; console.log(x + y); console.log(x - y); console.log(x *
  y); console.log(x % y);
</script>
```

---

# Comparison Operators

Used to compare values.

```
- >
- <
- >=
- <=
- ==
- ===
- !=
- !==
```

### Example

```javascript
<script>
  console.log(10 > 5); console.log(10 === "10"); console.log(10 === 10);
</script>
```

---

# Logical Operators

```
- &&
- ||
- !
```

### Example

```javascript
<script>
  console.log(true && false); console.log(true || false); console.log(!false);
</script>
```

---

# 4. Template Literals

Allows variable embedding and multi-line strings using backticks.

### Example

```javascript
<script>
  let name = "Jaswanth"; let msg = `Hello ${name}, welcome.`; console.log(msg);
</script>
```

---

# 5. Comments in JavaScript

Used to document code.

### Single-line

```javascript
// this is a comment
```

### Multi-line

```javascript
/*
  multi-line comment
*/
```

---

# 6. Type Conversion (Explicit & Implicit)

---

# Explicit Conversion

### Example

```javascript
<script>
  console.log(Number("20")); 
  console.log(String(100)); 
  console.log(Boolean(1));
</script>
```

---

# Implicit Conversion

### Example

```javascript
<script>
  console.log("5" + 2); // concatenation 
  console.log("5" - 2); // numeric subtraction
</script>
```

Output:  
52  
3

---

# Practice Tasks

1. Declare one example of each primitive data type.
2. Create an object with keys name, age, and city.
3. Perform arithmetic operations on two numbers.
4. Use template literals to print an introduction.
5. Convert string "50" to number and verify the type.

# Part 3 – Control Flow in JavaScript

---

## 1. Introduction to Control Flow

Control flow determines **how JavaScript executes your code**.  
It allows your program to:

- Make decisions
- Execute code conditionally
- Repeat actions
- Skip certain steps

Main control flow structures:

- if / else
- switch
- for loop
- while loop
- do-while loop
- break and continue

---

# if, else if, else

Used to make decisions based on conditions.

### Example

```javascript
<script>
let marks = 85;

if (marks >= 90) {
    console.log("Grade A");
} else if (marks >= 75) {
    console.log("Grade B");
} else {
    console.log("Grade C");
}
</script>
```

Output:  
Grade B

---

# Comparison Operators

Used in conditions to compare values.

Operators:

```
>
<
>=
<=
== (loose equality)
=== (strict equality, recommended)
!=
!==
```

### Example

```javascript
<script>
  console.log(10 > 5); 
  console.log(10 === "10"); 
  console.log(10 === 10);
</script>
```

Output:  
true  
false  
true

---
# Ternary Operator (Short Explanation)

The ternary operator provides a **shorter way** to write simple if–else statements.  
It is often used when you need to choose between two values based on a condition.

### Syntax
condition ? value_if_true : value_if_false

### Example
```javascript
<script>
let age = 20;
let result = (age >= 18) ? "Adult" : "Minor";
console.log(result);
</script>
```

Output:  
Adult

### When to use
- When you need a quick inline decision  
- When the condition is simple  
- When returning or assigning one of two values  

### Example in print
```javascript
<script>
console.log( (5 > 3) ? "Yes" : "No" );
</script>
```

Output:  
Yes


# switch Statement

Used when matching one value with multiple possible cases.

### Example

```javascript
<script>
let day = 3;
let dayName = "";

switch (day) {
    case 1:
        dayName = "Monday";
        break;
    case 2:
        dayName = "Tuesday";
        break;
    case 3:
        dayName = "Wednesday";
        break;
    default:
        dayName = "Unknown";
}

console.log(dayName);
</script>
```

Output:  
Wednesday

---

# for Loop

Used when the number of iterations is known.

### Syntax

for (initialization; condition; increment) {  
 statements  
}

### Example

```javascript
<script>
for (let i = 1; i <= 5; i++) {
    console.log(i);
}
</script>
```

Output:  
1  
2  
3  
4  
5

---

# while Loop

Runs as long as the condition is true.

### Example

```javascript
<script>
let n = 1;

while (n <= 3) {
    console.log(n);
    n++;
}
</script>
```

Output:  
1  
2  
3

---

# do-while Loop

Runs the code at least once before checking the condition.

### Example

```javascript
<script>
let count = 1;

do {
    console.log(count);
    count++;
} while (count <= 3);
</script>
```

Output:  
1  
2  
3

---

# break and continue

### break

Stops the loop immediately.

### continue

Skips the current iteration and continues the loop.

### Example

```javascript
<script>
for (let i = 1; i <= 5; i++) {
    if (i === 3) {
        continue; // skip 3
    }
    if (i === 5) {
        break; // stop loop
    }
    console.log(i);
}
</script>
```

Output:  
1  
2  
4

---

# Summary Table

| Feature   | for loop                 | while loop         | do-while loop               |
| --------- | ------------------------ | ------------------ | --------------------------- |
| Runs when | Condition true           | Condition true     | At least once               |
| Condition | Checked before each loop | Checked before     | Checked after first run     |
| Use case  | Known iterations         | Unknown iterations | Must run once even if false |

---

## Practice Tasks

1. Write an if–else program to check if a number is even or odd.
2. Use switch to print the name of a month based on its number.
3. Print numbers from 1 to 20 using a for loop.
4. Print numbers from 10 to 1 using a while loop.
5. Skip printing the number 7 using continue.
6. Use break to stop the loop when the number reaches 15.
---
# Strict Mode in JavaScript

Strict Mode is a special mode in JavaScript that makes the language **more secure, cleaner, and less error-prone**.  
It changes the way JavaScript runs, helping you catch mistakes early.

You enable strict mode by adding this line at the top of a script or function:

```javascript
"use strict";
```

------------------------------------------------------------

## Why Strict Mode Exists

Strict mode helps by:
- Preventing the use of undeclared variables  
- Throwing more meaningful errors  
- Blocking dangerous or outdated features  
- Making JavaScript behave more predictably  
- Improving performance in some cases  

------------------------------------------------------------

## Example: Without Strict Mode

```javascript
<script>
x = 10;        // No error, JS creates a global variable automatically
console.log(x);
</script>
```

Output:  
10

This is risky because mistakes become hidden global variables.

------------------------------------------------------------

## Example: With Strict Mode

```javascript
<script>
"use strict";

x = 10;        // Error: x is not defined
console.log(x);
</script>
```

Output:  
ReferenceError: x is not defined

Strict mode forces you to **declare variables properly** using let, const, or var.

------------------------------------------------------------

## Where to Place Strict Mode

### At the top of a script file:
```javascript
"use strict";
```

### Inside a function only:
```javascript
function test() {
    "use strict";
    // strict mode only inside this function
}
```

------------------------------------------------------------
---
# Part 4 – Functions in JavaScript  


## 1. Introduction to Functions

A function is a reusable block of code designed to perform a specific task.  
Functions help avoid repeating the same code and make programs structured and maintainable.

A function contains:
- Function name  
- Parameters (optional)  
- Function body  
- Return value (optional)  

### Example
```javascript
<script>
function greet() {
    console.log("Hello from a function");
}
greet();
</script>
```

Output:  
Hello from a function

------------------------------------------------------------

## 2. Function Declaration, Expression, and Arrow Functions

### Function Declaration
Declared with the function keyword. Hoisted (can be called before declaration).

```javascript
<script>
function add(a, b) {
    return a + b;
}
console.log(add(5, 3));
</script>
```

Output:  
8

------------------------------------------------------------

### Function Expression
Function assigned to a variable. Not hoisted.

```javascript
<script>
const multiply = function (x, y) {
    return x * y;
};
console.log(multiply(4, 2));
</script>
```

Output:  
8

------------------------------------------------------------

### Arrow Function
Shorter syntax introduced in ES6.  
Does not have its own this or arguments.
General syntax:

```javascript
const functionName = (parameters) => {
    return expression;
};
```

```javascript
<script>
const subtract = (a, b) => {
    return a - b;
};
console.log(subtract(10, 4));
</script>
```

Output:  
6

### Arrow Function Short Form
If only one expression, return is automatic.

```javascript
<script>
const square = n => n * n;
console.log(square(5));
</script>
```

Output:  
25

------------------------------------------------------------

## 3. Parameters, Arguments, Default Values, Rest Parameters

### Parameters and Arguments
Parameters: placeholders  
Arguments: actual values passed

```javascript
<script>
function welcome(name) {
    console.log("Welcome " + name);
}
welcome("Jaswanth");
</script>
```

Output:  
Welcome Jaswanth

------------------------------------------------------------

### Default Parameters
Used when no argument is passed.

```javascript
<script>
function greet(name = "Guest") {
    console.log("Hello " + name);
}
greet();
</script>
```

Output:  
Hello Guest

------------------------------------------------------------

### Rest Parameters
Used when the number of arguments is unknown.

```javascript
<script>
function sum(...nums) {
    let total = 0;
    for (let n of nums) {
        total += n;
    }
    console.log(total);
}
sum(10, 20, 30);
</script>
```

Output:  
60

------------------------------------------------------------

## 4. Return Statement and Execution Flow

The return statement sends a value back to the caller and stops further execution inside the function.

```javascript
<script>
function getTotal(a, b) {
    return a + b;
    console.log("This will not run");
}
console.log(getTotal(10, 5));
</script>
```

Output:  
15

------------------------------------------------------------

## 5. Scope and Lexical Scope (Core Concept)

### Local and Global Scope
Variables declared inside a function are local.  
Variables declared outside are global.

```javascript
<script>
let x = 10; // global

function show() {
    let y = 20; // local
    console.log(x, y);
}
show();
</script>
```

Output:  
10 20

------------------------------------------------------------

### Lexical Scope (Important for Closures)
Inner functions can access variables from the outer function.

```javascript
<script>
function outer() {
    let message = "Inside Outer";

    function inner() {
        console.log(message);
    }
    inner();
}
outer();
</script>
```

Output:  
Inside Outer

------------------------------------------------------------

# Practice Tasks

1. Write a function that returns the square of a number.  
2. Create an arrow function that prints your name.  
3. Write a function with default parameters for greeting.  
4. Write a function using rest parameters to sum numbers.  
5. Create a function inside another function and print an outer variable.  

# Part 5 – Arrays in JavaScript  

------------------------------------------------------------

## 1. Creating Arrays

<p style=color:pink; >Arrays store multiple values in a single variable.  </p>
They maintain an ordered list of elements.

### Example
```javascript
<script>
let numbers = [10, 20, 30];
let mixed = [1, "hello", true];
let empty = [];
console.log(numbers, mixed, empty);
</script>
```

Output:  
[10, 20, 30] ["hello", true] []

### Using new Array()
```javascript
<script>
let values = new Array(5, 10, 15);
console.log(values);
</script>
```

------------------------------------------------------------

# 2. Core Methods (push, pop, shift, unshift)

### push() – Add at end
```javascript
<script>
let nums = [1, 2];
nums.push(3);
console.log(nums);
</script>
```
Output: [1, 2, 3]

------------------------------------------------------------

### pop() – Remove last element
```javascript
<script>
let nums = [1, 2, 3];
nums.pop();
console.log(nums);
</script>
```
Output: [1, 2]

------------------------------------------------------------

### shift() – Remove first element
```javascript
<script>
let nums = [10, 20, 30];
nums.shift();
console.log(nums);
</script>
```
Output: [20, 30]

------------------------------------------------------------

### unshift() – Add at beginning
```javascript
<script>
let nums = [20, 30];
nums.unshift(10);
console.log(nums);
</script>
```
Output: [10, 20, 30]

------------------------------------------------------------

# 3. Higher-Order Methods: map, filter, reduce

## map() – transforms each element and returns new array
```javascript
<script>
let nums = [1, 2, 3];
let squares = nums.map(function(n) {
    return n * 2;
});
console.log(squares);
</script>
```
Output: [2, 4, 6]

------------------------------------------------------------

## filter() – keeps elements that match a condition
```javascript
<script>
let nums = [10, 5, 20, 3];
let result = nums.filter(function(n) {
    return n > 8;
});
console.log(result);
</script>
```
Output: [10, 20]

------------------------------------------------------------

## reduce() – reduces array to a single value
```javascript
<script>
let nums = [1, 2, 3, 4];
let total = nums.reduce(function(acc, n) {
    return acc + n;
}, 0);
console.log(total);
</script>
```
Output: 10

------------------------------------------------------------

# 4. Other Utility Methods (find, some, every, forEach)

## find() – returns first matched element
```javascript
<script>
let nums = [5, 12, 8];
let result = nums.find(n => n > 10);
console.log(result);
</script>
```
Output: 12

------------------------------------------------------------

## some() – returns true if at least one matches
```javascript
<script>
let nums = [2, 4, 6];
console.log(nums.some(n => n > 5));
</script>
```
Output: true

------------------------------------------------------------

## every() – returns true only if all match
```javascript
<script>
let nums = [2, 4, 6];
console.log(nums.every(n => n % 2 === 0));
</script>
```
Output: true

------------------------------------------------------------

## forEach() – runs a function on each element (no return)
```javascript
<script>
let nums = [1, 2, 3];
nums.forEach(n => console.log(n));
</script>
```
Output:  
1  
2  
3

------------------------------------------------------------

# 5. sort() and reverse()

## sort()
Sorts values alphabetically by default.

```javascript
<script>
let nums = [20, 100, 3];
nums.sort();
console.log(nums);
</script>
```
Output: [100, 20, 3]

To sort numerically:
```javascript
<script>
let nums = [20, 100, 3];
nums.sort((a, b) => a - b);
console.log(nums);
</script>
```
Output: [3, 20, 100]

------------------------------------------------------------

## reverse()
```javascript
<script>
let nums = [1, 2, 3];
nums.reverse();
console.log(nums);
</script>
```
Output: [3, 2, 1]

------------------------------------------------------------

# 6. Spread & Rest Operators

## Spread (...) – expands array elements
```javascript
<script>
let nums = [1, 2, 3];
let extended = [...nums, 4, 5];
console.log(extended);
</script>
```
Output: [1, 2, 3, 4, 5]

------------------------------------------------------------

## Rest (...) – collects multiple values into an array
```javascript
<script>
function sum(...values) {
    let total = 0;
    for (let v of values) total += v;
    console.log(total);
}
sum(10, 20, 30);
</script>
```
Output: 60

------------------------------------------------------------

# Practice Tasks

1. Create an array of 5 numbers and use push, pop, shift, unshift.  
2. Use map() to convert all numbers to their squares.  
3. Use filter() to keep numbers greater than 50.  
4. Use reduce() to find the sum of an array.  
5. Use find() to get the first even number.  
6. Sort an array numerically.  
7. Use spread operator to merge two arrays.  
8. Create a function that uses rest operator to multiply all inputs.  
---
# Part 6 – Objects in JavaScript (Detailed & Enhanced)  

------------------------------------------------------------

## 1. What Are Objects?

Objects are used to store **multiple related values** together in a structured way.  
Instead of storing separate variables (name, age, city), you group them inside an object.

Objects represent real-world entities:
- A user  
- A product  
- A laptop  
- A bank account  

Objects use **key–value pairs**, also called **properties**.

### Example
```javascript
<script>
let user = {
    name: "Jaswanth",  
    age: 22,
    city: "Hyderabad"
};
console.log(user);
</script>
```

Key points:
- Keys are strings (name, age, city)
- Values can be any data type
- Order does not matter in objects

------------------------------------------------------------

## 2. Creating Objects

### 2.1 Object Literal (Most Common)
```javascript
<script>
let person = {
    name: "Arun",
    age: 25
};
</script>
```
This is the most frequently used way in modern JavaScript.

------------------------------------------------------------

### 2.2 Using new Object()
This is older and rarely used but still valid.

```javascript
<script>
let obj = new Object();
obj.title = "Developer";
obj.level = 1;
</script>
```

------------------------------------------------------------

### 2.3 Constructor Function
Used to create multiple similar objects.

```javascript
<script>
function User(name, age) {
    this.name = name;
    this.age = age;
}
let u = new User("Kiran", 30);
console.log(u);
</script>
```

This pattern is used for more structured and repetitive object creation.

------------------------------------------------------------

## 3. Accessing & Updating Properties

Objects can be accessed in two ways:  
- Dot notation  
- Bracket notation  

### Dot Notation (clean & preferred)
```javascript
<script>
let user = { name: "Jaswanth", age: 22 };
console.log(user.name);
user.age = 23;
</script>
```

------------------------------------------------------------

### Bracket Notation (when key has space/special chars)
```javascript
<script>
let person = { "home city": "Hyderabad" };
console.log(person["home city"]);
person["home city"] = "Delhi";
</script>
```

Bracket notation is useful when:
- Key contains spaces  
- Key is dynamic (e.g., stored in variable)

------------------------------------------------------------

## 4. Adding and Deleting Properties

### Add New Property
```javascript
<script>
let user = { name: "Ram" };
user.city = "Hyderabad";
console.log(user);
</script>
```

------------------------------------------------------------

### Delete a Property
```javascript
<script>
let user = { name: "Ram", city: "Hyd" };
delete user.city;
console.log(user);
</script>
```

------------------------------------------------------------

## 5. Nested Objects

Objects can contain other objects for better organization.

```javascript
<script>
let student = {
    name: "Akhil",
    marks: {
        math: 90,
        science: 85
    }
};
console.log(student.marks.math);
</script>
```

This is common in real applications (APIs, database results).

------------------------------------------------------------

## 6. Object Methods (Functions inside Objects)

A method is simply a function stored as a value inside an object.

```javascript
<script>
let user = {
    name: "Jaswanth",
    greet: function() {
        return "Hello " + this.name;
    }
};
console.log(user.greet());
</script>
```

Key point:
- Methods often use **this** to access properties inside the same object.

------------------------------------------------------------

## 7. The this Keyword

The value of **this** inside a method refers to the **object that calls it**.

```javascript
<script>
let car = {
    brand: "BMW",
    getBrand: function() {
        return this.brand;
    }
};
console.log(car.getBrand());
</script>
```

If this was inside a regular function (not a method), **this** would refer to window (in non-strict mode).

------------------------------------------------------------

## 8. Looping Through Objects (for…in)

Used to loop through all keys in an object.

```javascript
<script>
let user = { name: "Ram", age: 22 };

for (let key in user) {
    console.log(key, user[key]);
}
</script>
```

Useful when you want to list all details of an object.

------------------------------------------------------------

## 9. freeze() and seal()

### Object.freeze()
Prevents:
- Adding new properties  
- Deleting properties  
- Changing existing values  

```javascript
<script>
let obj = { a: 10 };
Object.freeze(obj);
obj.a = 50; // ignored
console.log(obj);
</script>
```

------------------------------------------------------------

### Object.seal()
Prevents:
- Adding new properties  
- Deleting properties  

But **allows modifying existing values**.

```javascript
<script>
let obj = { x: 1 };
Object.seal(obj);
obj.x = 5;  
delete obj.x; 
console.log(obj);
</script>
```

------------------------------------------------------------

## 10. Object Destructuring

Destructuring allows quick extraction of values from objects into variables.

```javascript
<script>
let user = { name: "Jaswanth", age: 22 };
let { name, age } = user;
console.log(name, age);
</script>
```

Makes code cleaner when working with large objects.

------------------------------------------------------------

## 11. Spread Operator with Objects

### Copying an object
```javascript
<script>
let user = { a: 1, b: 2 };
let newUser = { ...user, c: 3 };
console.log(newUser);
</script>
```

Spread operator helps avoid modifying the original object.

------------------------------------------------------------

# Practice Tasks

1. Create an object for a mobile phone with brand, model, price.  
2. Add a method that returns full details using this.  
3. Create a nested object for marks and print science marks.  
4. Loop through any object using for…in.  
5. Freeze an object and attempt modifications.  
6. Use destructuring to extract any two properties.  
7. Merge two objects using spread operator.  

# Part 7 – Strings in JavaScript  

------------------------------------------------------------

## 1. What Are Strings?

A string is a sequence of characters used to represent text.  
Strings can contain words, numbers, symbols, spaces, and entire sentences.

JavaScript strings are immutable, meaning their content cannot be changed directly.

### Ways to create strings:
- Double quotes: "Hello"  
- Single quotes: 'Hello'  
- Template literals: `Hello`

------------------------------------------------------------

## 2. Creating Strings

```javascript
<script>
let s1 = "Hello";
let s2 = 'JavaScript';
let s3 = `Template Literal Example`;   // ES6
console.log(s1, s2, s3);
</script>
```

Output:  
Hello JavaScript Template Literal Example

------------------------------------------------------------

## 3. String Length

```javascript
<script>
let text = "Jaswanth";
console.log(text.length);
</script>
```

Output:  
8

------------------------------------------------------------

## 4. Common String Methods

### toUpperCase() and toLowerCase()
```javascript
<script>
let name = "Jaswanth";
console.log(name.toUpperCase());
console.log(name.toLowerCase());
</script>
```

Output:  
JASWANTH  
jaswanth

------------------------------------------------------------

### trim() – removes spaces from both ends
```javascript
<script>
let text = "   hello   ";
console.log(text.trim());
</script>
```

Output:  
hello

------------------------------------------------------------

### slice() – cuts part of a string
```javascript
<script>
let s = "JavaScript";
console.log(s.slice(0, 4));   // from index 0 to 3
</script>
```

Output:  
Java

------------------------------------------------------------

### substring() – similar to slice (cannot use negative values)
```javascript
<script>
let s = "JavaScript";
console.log(s.substring(4, 10));
</script>
```

Output:  
Script

------------------------------------------------------------

### replace() – replaces part of a string
```javascript
<script>
let text = "I love JS";
console.log(text.replace("JS", "JavaScript"));
</script>
```

Output:  
I love JavaScript

------------------------------------------------------------

### includes() – checks if text contains a substring
```javascript
<script>
let text = "welcome to coding";
console.log(text.includes("coding"));
</script>
```

Output:  
true

------------------------------------------------------------

### indexOf() – returns position of the first occurrence
```javascript
<script>
let text = "JavaScript";
console.log(text.indexOf("S"));
</script>
```

Output:  
4

------------------------------------------------------------

## 5. Template Literals (Deep Explanation)

Template literals allow:
- Multi-line strings  
- Embedding variables easily  
- Cleaner formatting  

```javascript
<script>
let name = "Jaswanth";
let age = 22;
let message = `My name is ${name} and I am ${age} years old.`;
console.log(message);
</script>
```

Output:  
My name is Jaswanth and I am 22 years old.

------------------------------------------------------------

## 6. Escape Characters

Used to insert characters that are hard to type directly.

| Escape | Meaning         |
|--------|------------------|
| \n     | New line         |
| \t     | Tab space        |
| \'     | Single quote     |
| \"     | Double quote     |
| \\     | Backslash        |

### Example:
```javascript
<script>
let msg = "Hello\nWorld";
console.log(msg);
</script>
```

Output:
Hello  
World

------------------------------------------------------------

## 7. Converting Other Values to Strings

### Using String()
```javascript
<script>
console.log(String(100));
console.log(String(true));
</script>
```

Output:  
100  
true

### Using toString()
```javascript
<script>
let n = 50;
console.log(n.toString());
</script>
```

------------------------------------------------------------

## 8. Looping Through a String

```javascript
<script>
let text = "JS";

for (let char of text) {
    console.log(char);
}
</script>
```

Output:  
J  
S

------------------------------------------------------------

# Practice Tasks

1. Write a string and print its length.  
2. Convert a given string to uppercase and lowercase.  
3. Extract the word "Script" from "JavaScript" using slice().  
4. Replace a word inside a sentence.  
5. Use template literals to print a multi-line introduction.  
6. Check if a string contains "JS" using includes().  
7. Loop through the characters of any string and print each one.


# Part 8 – Math and Date in JavaScript  

------------------------------------------------------------

## 1. Math Object (Built-in JavaScript Object)

The Math object contains properties and methods for mathematical operations.  
Math is not a constructor, so you cannot create Math objects.  
You call its methods directly using **Math.methodName**.

------------------------------------------------------------

## 2. Math Properties

### Common properties:
- Math.PI  
- Math.E  
- Math.SQRT2  

### Example
```javascript
<script>
console.log(Math.PI);
console.log(Math.E);
</script>
```

Output:  
3.141592653589793  
2.718281828459045

------------------------------------------------------------

## 3. Math Methods

### Math.round() – rounds to nearest integer
```javascript
<script>
console.log(Math.round(4.6));
</script>
```
Output:  
5

### Math.ceil() – rounds up
```javascript
<script>
console.log(Math.ceil(4.1));
</script>
```
Output:  
5

### Math.floor() – rounds down
```javascript
<script>
console.log(Math.floor(4.9));
</script>
```
Output:  
4

### Math.random() – random value between 0 and 1
```javascript
<script>
console.log(Math.random());
</script>
```

### Random number between 1 and 10
```javascript
<script>
console.log(Math.floor(Math.random() * 10) + 1);
</script>
```

### Math.max() and Math.min()
```javascript
<script>
console.log(Math.max(10, 30, 5));
console.log(Math.min(10, 30, 5));
</script>
```

Output:  
30  
5

### Math.sqrt() – square root
```javascript
<script>
console.log(Math.sqrt(81));
</script>
```

Output:  
9

------------------------------------------------------------

## 4. Date Object

The Date object stores date and time information.  
Unlike Math, Date **is** a constructor and requires new Date().

------------------------------------------------------------

## 5. Creating Date Values

### Current date and time
```javascript
<script>
let now = new Date();
console.log(now);
</script>
```

### Specific date
```javascript
<script>
let d = new Date("2023-10-15");
console.log(d);
</script>
```

### Year, month, day format
```javascript
<script>
let d = new Date(2023, 9, 15);  // month index starts at 0
console.log(d);
</script>
```

------------------------------------------------------------

## 6. Getting Date Components

```javascript
<script>
let d = new Date();

console.log(d.getFullYear());
console.log(d.getMonth());     // 0 = Jan, 11 = Dec
console.log(d.getDate());
console.log(d.getHours());
console.log(d.getMinutes());
console.log(d.getSeconds());
</script>
```

------------------------------------------------------------

## 7. Setting Date Components

```javascript
<script>
let d = new Date();
d.setFullYear(2030);
d.setMonth(5);        // June
d.setDate(10);
console.log(d);
</script>
```

------------------------------------------------------------

## 8. Date to String Conversions

```javascript
<script>
let d = new Date();
console.log(d.toDateString());
console.log(d.toTimeString());
console.log(d.toISOString());
</script>
```

------------------------------------------------------------

## 9. Calculating Time Difference (Important for real use)

```javascript
<script>
let start = new Date("2025-01-01");
let end = new Date("2025-01-10");

let difference = end - start; // in milliseconds
let days = difference / (1000 * 60 * 60 * 24);

console.log(days);
</script>
```

Output:  
9

------------------------------------------------------------

# Practice Tasks

1. Print the current year, month, and date using Date object.  
2. Generate a random number between 100 and 200.  
3. Use Math.max() to find the largest number in an array.  
4. Create a date for your birthday and print the day of the week.  
5. Calculate how many days are left until next New Year.  
6. Use Math.floor(Math.random()) to simulate a dice roll (1–6).  

# Part 9 – DOM (Document Object Model) – Detailed Explanation

------------------------------------------------------------

## 1. What Is the DOM?

The DOM (Document Object Model) is a **programming interface** that the browser creates from your HTML.

When you load a webpage:

1. Browser reads HTML  
2. Converts it into a **tree-like structure**  
3. Creates JavaScript-accessible objects for each element  

This allows JavaScript to:

- Access HTML elements  
- Modify text, attributes, and CSS  
- Create new elements  
- Remove existing ones  
- Respond to user actions (click, input, etc.)

### Visual Representation of DOM Tree

```
Document
 └── html
      ├── head
      └── body
           ├── h1
           ├── p
           ├── img
           └── button
```

JavaScript interacts with this tree through the **document** object.

------------------------------------------------------------

## 2. Selecting Elements

To work with DOM, you first need to select elements.

### 2.1 getElementById()
Selects a single element using its id.

```javascript
<script>
let heading = document.getElementById("main-title");
console.log(heading);
</script>
```

### 2.2 getElementsByClassName()
Returns all elements that have the given class (HTMLCollection).

```javascript
<script>
let items = document.getElementsByClassName("item");
console.log(items);
</script>
```

### 2.3 getElementsByTagName()
Select elements by tag.

```javascript
<script>
let paragraphs = document.getElementsByTagName("p");
</script>
```

### 2.4 querySelector() – most modern and recommended
Selects the **first matching element**.

```javascript
<script>
let btn = document.querySelector(".btn");
</script>
```

### 2.5 querySelectorAll()
Selects **all matching elements**.

```javascript
<script>
let buttons = document.querySelectorAll("button");
</script>
```

> querySelector() and querySelectorAll() are preferred in modern JavaScript.

------------------------------------------------------------

## 3. Changing Text, HTML, Attributes, and CSS

Once you select an element, you can modify it.

### 3.1 Changing Text
textContent → only text  
innerHTML → allows adding HTML structure  

```javascript
<script>
let title = document.getElementById("main-title");
title.textContent = "New Title Added";
</script>
```

### 3.2 Changing HTML
```javascript
<script>
let box = document.querySelector(".box");
box.innerHTML = "<h2>Updated Heading</h2>";
</script>
```

### 3.3 Changing Attributes
```javascript
<script>
let img = document.querySelector("img");
img.setAttribute("src", "new-photo.jpg");
</script>
```

### 3.4 Changing CSS
```javascript
<script>
let box = document.querySelector(".box");
box.style.backgroundColor = "skyblue";
box.style.padding = "20px";
</script>
```

------------------------------------------------------------

## 4. Creating New Elements Dynamically

You can add elements to the page without touching HTML.

### 4.1 Create Element
```javascript
<script>
let p = document.createElement("p");
p.textContent = "This is a new paragraph.";
</script>
```

### 4.2 Append to Parent (adds at bottom)
```javascript
<script>
let container = document.querySelector(".container");
container.appendChild(p);
</script>
```

### 4.3 Prepend (adds at top)
```javascript
<script>
container.prepend(p);
</script>
```

### 4.4 Insert Before an Element
```javascript
<script>
container.insertBefore(p, container.firstChild);
</script>
```

------------------------------------------------------------

## 5. Removing Elements

Remove an element directly:
```javascript
<script>
let item = document.querySelector(".item");
item.remove();
</script>
```

Or remove from parent:
```javascript
<script>
parent.removeChild(child);
</script>
```

------------------------------------------------------------

## 6. DOM Traversing (Moving Between Elements)

DOM nodes have relationships like a family tree.

### 6.1 Parent Element
```javascript
<script>
let btn = document.querySelector("button");
console.log(btn.parentElement);
</script>
```

### 6.2 Children (HTMLCollection)
```javascript
<script>
let list = document.querySelector("ul");
console.log(list.children);
</script>
```

### 6.3 Siblings
```javascript
<script>
let item = document.querySelector("li");
console.log(item.nextElementSibling);
console.log(item.previousElementSibling);
</script>
```

Traversing is useful when building dynamic UI like menus, tables, lists.

------------------------------------------------------------

## 7. Events and Event Listeners

Events allow JavaScript to respond to user actions like clicking, typing, scrolling, or submitting a form.

### 7.1 Click Event
```javascript
<script>
let btn = document.querySelector("#save");

btn.addEventListener("click", function() {
    console.log("Button was clicked");
});
</script>
```

### 7.2 Input Event (captures typing)
```javascript
<script>
let input = document.querySelector("#name");

input.addEventListener("input", function(e) {
    console.log("Typed:", e.target.value);
});
</script>
```

### 7.3 Change Event (select dropdown)
```javascript
<script>
let select = document.querySelector("select");

select.addEventListener("change", function(e) {
    console.log("Selected:", e.target.value);
});
</script>
```

### 7.4 Mouse Events
- mouseover  
- mouseout  
- mousedown  
- mouseup  

------------------------------------------------------------

## 8. Example: Simple DOM Mini Project

HTML:
```html
<div id="box" style="width:100px; height:100px; background:lightgray;"></div>
<button id="change">Change Color</button>
```

JavaScript:
```javascript
<script>
let box = document.getElementById("box");
let btn = document.getElementById("change");

btn.addEventListener("click", function() {
    box.style.backgroundColor = "orange";
});
</script>
```

This demonstrates:
- Selecting elements  
- Adding event listeners  
- Changing CSS dynamically  

------------------------------------------------------------

# Practice Tasks

1. Select a paragraph using querySelector and change its text.  
2. Create a new list item (li) and append it to a ul.  
3. Remove any element when a delete button is clicked.  
4. Build a color-change button that changes background randomly.  
5. Create a simple counter app using two buttons (+ and –).  
6. Create an input box and live display whatever the user types.  

# Part 10 – Events & Event Handling in JavaScript

------------------------------------------------------------

## 1. What Are Events?

Events are **actions** or **occurrences** that happen in the browser.  
Examples:
- Clicking a button  
- Typing in an input box  
- Submitting a form  
- Hovering over an image  
- Page loading  
- Scrolling  

JavaScript detects these events and allows you to **respond** using event handlers.

------------------------------------------------------------

## 2. Ways to Handle Events

There are three main ways to attach events in JavaScript.

------------------------------------------------------------

### 2.1 Inline Events (Not Recommended)

HTML:
```html
<button onclick="alert('Clicked')">Click Me</button>
```

This mixes HTML and JavaScript—avoid in modern code.

------------------------------------------------------------

### 2.2 Property Event Handlers

```javascript
<script>
let btn = document.getElementById("save");
btn.onclick = function() {
    console.log("Button clicked");
};
</script>
```

Limitation:
- Only **one** event function can be assigned (overwrites previous ones).

------------------------------------------------------------

### 2.3 addEventListener() – Recommended Modern Method

```javascript
<script>
let btn = document.querySelector("#save");

btn.addEventListener("click", function() {
    console.log("Button clicked");
});
</script>
```

Advantages:
- Multiple listeners supported  
- Works with all event types  
- Cleaner separation of HTML and JS  

------------------------------------------------------------

## 3. Common Event Types

### Mouse Events
- click  
- dblclick  
- contextmenu  
- mouseover  
- mouseout  
- mousedown  
- mouseup  

### Keyboard Events
- keydown  
- keyup  
- keypress  

### Form Events
- submit  
- input  
- change  
- focus  
- blur  

### Window Events
- load  
- scroll  
- resize  

------------------------------------------------------------

## 4. Event Object

Every event gives an **event object** containing information about the event.

```javascript
<script>
document.addEventListener("click", function(event) {
    console.log(event.target);    // element clicked
    console.log(event.type);       // type of event
});
</script>
```

------------------------------------------------------------

## 5. Preventing Default Behavior

Some HTML elements have default actions:
- Links open pages  
- Forms submit  
- Right-click opens context menu  

Use **preventDefault()** to stop this.

```javascript
<script>
let link = document.querySelector("a");

link.addEventListener("click", function(event) {
    event.preventDefault();
    console.log("Default prevented");
});
</script>
```

------------------------------------------------------------

## 6. Event Bubbling (Very Important)

Bubbling means events **start from the target element and move upward** through parents.

### Example:
HTML:
```html
<div id="parent">
    <button id="child">Click Me</button>
</div>
```

JavaScript:
```javascript
<script>
document.getElementById("child").addEventListener("click", function() {
    console.log("Child clicked");
});

document.getElementById("parent").addEventListener("click", function() {
    console.log("Parent clicked");
});
</script>
```

Clicking the button prints:
```
Child clicked
Parent clicked
```

Because:
```
button → div → body → document
```

------------------------------------------------------------

## 7. Event Capturing (Rare but Useful)

Capturing is the opposite of bubbling.  
Events flow **from top to bottom**.

Enable capturing by using third argument `true`.

```javascript
<script>
document.addEventListener("click", function() {
    console.log("capturing: document");
}, true);
</script>
```

------------------------------------------------------------

## 8. Event Delegation (Very Important for Dynamic Elements)

Event delegation means:
- Attach event to **parent**
- Handle events of **child elements** using event.target

Useful when adding elements dynamically.

Example:
```javascript
<script>
let list = document.querySelector("#items");

list.addEventListener("click", function(e) {
    if (e.target.tagName === "LI") {
        console.log("Clicked:", e.target.textContent);
    }
});
</script>
```

Works even if new <li> elements are added later.

------------------------------------------------------------

## 9. Form Handling

HTML:
```html
<form id="userForm">
  <input type="text" id="name">
  <button type="submit">Submit</button>
</form>
```

JavaScript:
```javascript
<script>
let form = document.getElementById("userForm");

form.addEventListener("submit", function(e) {
    e.preventDefault();
    let value = document.getElementById("name").value;
    console.log("Form submitted:", value);
});
</script>
```

------------------------------------------------------------

## 10. Input and Change Events

### input – runs every time user types
```javascript
<script>
let input = document.querySelector("#username");

input.addEventListener("input", function(e) {
    console.log(e.target.value);
});
</script>
```

### change – runs when input loses focus or selection changes
```javascript
<script>
let city = document.querySelector("#city");

city.addEventListener("change", function(e) {
    console.log("Selected:", e.target.value);
});
</script>
```

------------------------------------------------------------

## 11. Example Project: Counter App

HTML:
```html
<button id="plus">+</button>
<span id="count">0</span>
<button id="minus">-</button>
```

JavaScript:
```javascript
<script>
let count = 0;

document.querySelector("#plus").addEventListener("click", function() {
    count++;
    document.querySelector("#count").textContent = count;
});

document.querySelector("#minus").addEventListener("click", function() {
    count--;
    document.querySelector("#count").textContent = count;
});
</script>
```

------------------------------------------------------------

# Practice Tasks

1. Add a click event to change background color.  
2. Create an input field that shows live typing below it.  
3. Build a simple form and prevent its default submission.  
4. Create a list using event delegation and log clicked item.  
5. Implement a light/dark mode toggle button.  




