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
  console.log(true && false); 
  console.log(true || false); 
  console.log(!false);
</script>
```

---

# 4. Template Literals

Allows variable embedding and multi-line strings using backticks.

### Example

```javascript
<script>
  let name = "Jaswanth"; 
  let msg = `Hello ${name}, welcome.`; 
  console.log(msg);
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

## 6. Spread & Rest Operators ( ... )

The **spread** and **rest** operators use the same syntax (`...`)  
but they perform **opposite** actions:

- **Spread** = expands values  
- **Rest**   = collects values  

Both are extremely important in modern JavaScript for arrays, objects, and functions.

------------------------------------------------------------

## 1. Spread Operator – Expands Values

Spread **expands an array or object into individual elements**.

### 1.1 Spread with Arrays
```javascript
<script>
let nums = [1, 2, 3];
let extended = [...nums, 4, 5];

console.log(extended);
</script>
```
Output:
```
[1, 2, 3, 4, 5]
```

### 1.2 Merging Arrays
```javascript
<script>
let a = [1, 2];
let b = [3, 4];

let merged = [...a, ...b];
console.log(merged);  // [1, 2, 3, 4]
</script>
```

### 1.3 Copying Arrays (Shallow Copy)
```javascript
<script>
let original = [1, 2, 3];
let copy = [...original];

copy[0] = 99;

console.log(original); // [1, 2, 3]
console.log(copy);     // [99, 2, 3]
</script>
```

### 1.4 Spread with Objects
```javascript
<script>
let user = { name: "Jaswanth", age: 22 };
let cloned = { ...user };

console.log(cloned);  // { name: "Jaswanth", age: 22 }
</script>
```

### 1.5 Merging Objects
```javascript
<script>
let a = { x: 1 };
let b = { y: 2 };

let c = { ...a, ...b };
console.log(c);  // { x: 1, y: 2 }
</script>
```

------------------------------------------------------------

## 2. Rest Operator – Collects Values

Rest **collects remaining values into an array**.

### 2.1 Rest in Function Parameters
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
Output:
```
60
```

### 2.2 Rest to Capture Remaining Array Elements
```javascript
<script>
let [first, second, ...others] = [10, 20, 30, 40, 50];

console.log(first);   // 10
console.log(second);  // 20
console.log(others);  // [30, 40, 50]
</script>
```

### 2.3 Rest in Object Destructuring
```javascript
<script>
let user = { name: "A", age: 22, city: "Hyderabad", country: "India" };

let { name, ...details } = user;

console.log(name);     // "A"
console.log(details);  // { age: 22, city:"Hyderabad", country:"India" }
</script>
```

------------------------------------------------------------

## 3. Key Difference Between Spread vs Rest

| Feature | Spread | Rest |
|--------|--------|------|
| Purpose | Expands values | Collects values |
| Output | Individual elements | Array or object |
| Used In | Arrays, objects, function calls | Function parameters, array/object destructuring |
| Example | `[...arr]` | `(...args)` |

**Spread = expand**  
**Rest = gather**

------------------------------------------------------------

## 4. Important Details and Rules

### 4.1 Spread cannot be used alone in function parameters
Correct:
```javascript
function print(a, b, ...rest) {}
```
Incorrect:
```javascript
function print(...rest, a, b) {} // ❌ rest must be last
```

### 4.2 Spread creates shallow copies (not deep copies)
```javascript
<script>
let obj = { nested: { x: 1 } };
let copy = { ...obj };

copy.nested.x = 100;

console.log(obj.nested.x); // 100 (same reference)
</script>
```

### 4.3 Spread works only with iterable values (arrays, strings, etc.)
```javascript
[...123] // ❌ error
```

### 4.4 Rest always returns an array (for arrays) or an object (for objects)

------------------------------------------------------------

## 5. Real-World Use Cases

### 5.1 Passing array values into functions
```javascript
<script>
function maxValue(a, b, c) {
    console.log(Math.max(a, b, c));
}

let arr = [5, 10, 3];

maxValue(...arr);
</script>
```

### 5.2 Combining configuration objects
```javascript
<script>
let defaultOptions = { theme: "light", sidebar: true };
let userOptions = { theme: "dark" };

let finalConfig = { ...defaultOptions, ...userOptions };

console.log(finalConfig);
</script>
```

### 5.3 Building flexible functions
```javascript
<script>
function logAll(...items) {
    for (let item of items) console.log(item);
}

logAll("A", "B", "C", 10, true);
</script>
```

------------------------------------------------------------

## Summary

- **Spread (`...`) expands**: arrays, objects, arguments  
- **Rest (`...`) collects**: function parameters, remaining values  
- They use the same syntax but perform **opposite actions**  
- Essential in modern JavaScript for:  
  - Merging  
  - Copying  
  - Destructuring  
  - Flexible function arguments  
  - Handling large objects/arrays cleanly  


------------------------------------------------------------

## Practice Tasks

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

The **this** keyword is one of the most important and misunderstood concepts in JavaScript.  
Its value **depends on how a function is called**, not where it is written.

this is determined at **runtime**, based on the **calling context**.

------------------------------------------------------------

### 1. this Inside an Object Method

When a function is called **as a method on an object**,  
`this` refers to **the object that calls the method**.

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

Output:
```
BMW
```

Reason:  
`car.getBrand()` → the object before the dot (`car`) becomes **this**.

------------------------------------------------------------

### 2. this Inside a Regular Function

In a **regular function** (not inside an object):

### Non-strict mode:
`this` → refers to the **window object** (browser global object)

### Strict mode:
`this` → becomes **undefined**

```javascript
<script>
function show() {
    console.log(this);
}

show(); 
</script>
```

- Non-strict mode → prints `window`  
- Strict mode → prints `undefined`

------------------------------------------------------------

### 3. this Inside Event Listeners

In event listeners, `this` refers to **the DOM element that received the event**.

```javascript
<script>
document.querySelector("button").addEventListener("click", function() {
    console.log(this); // the button
});
</script>
```

------------------------------------------------------------

### 4. this Inside Arrow Functions (Very Important)

Arrow functions **do NOT have their own this**.  
They inherit this from the **surrounding (parent) scope**.

```javascript
<script>
let user = {
    name: "Jaswanth",
    show: function() {
        let inner = () => {
            console.log(this.name);
        };
        inner();
    }
};

user.show();
</script>
```

Output:
```
Jaswanth
```

Reason:  
Arrow function takes `this` from `show` → which belongs to `user`.

### Key Rule:
**Arrow functions are perfect when you want to keep the outer this.**

------------------------------------------------------------

### 5. this in Constructor Functions (or Classes)

When using `new`, JavaScript creates an empty object and assigns it to `this`.

```javascript
<script>
function Person(name) {
    this.name = name;
}

let p = new Person("Kumar");
console.log(p.name);
</script>
```

Output:
```
Kumar
```

------------------------------------------------------------
### 6. Explicit this Binding (call, apply, bind)

You can **manually set** the value of this.

### 6.1 call()
```javascript
<script>
function show() {
    console.log(this.value);
}

let obj = { value: 100 };

show.call(obj); // this = obj
</script>
```

### 6.2 apply()
Same as call, but arguments are passed as an array.

### 6.3 bind()
Returns a new function with permanently bound this.

```javascript
<script>
let car = { brand: "Audi" };

function getBrand() {
    return this.brand;
}

let bound = getBrand.bind(car);
console.log(bound());
</script>
```

------------------------------------------------------------

### 7. this Inside Nested Functions

Regular nested functions lose the outer this.

```javascript
<script>
let team = {
    name: "Developers",
    show: function() {
        function inner() {
            console.log(this.name);
        }
        inner();
    }
};

team.show();
</script>
```

Output:
```
undefined
```

Reason:  
inner() is a regular function → this = window (or undefined in strict mode)

### Solution: Use arrow functions

```javascript
<script>
let team = {
    name: "Developers",
    show: function() {
        const inner = () => console.log(this.name);
        inner();
    }
};

team.show();
</script>
```

------------------------------------------------------------

### 8. this Behavior Summary Table

| Where Used | Value of this |
|------------|----------------|
| Method inside object | Object that calls the method |
| Regular function (non-strict) | window |
| Regular function (strict) | undefined |
| Arrow function | Inherited from parent scope |
| Event listener | DOM element |
| Constructor function | Newly created object |
| call/apply/bind | Manually assigned object |

------------------------------------------------------------

### 9. Why Understanding this Is Important

- Essential in object methods  
- Crucial for working with classes and constructors  
- Critical in event handling  
- Helps avoid bugs in nested callbacks  
- Widely used in frameworks (React, Node.js, Express, Vue)

------------------------------------------------------------

### 10. Practical Example Comparing All

```javascript
<script>
let person = {
    name: "Jaswanth",
    
    regular: function() {
        console.log("regular:", this.name);
    },

    arrow: () => {
        console.log("arrow:", this.name);
    }
};

person.regular();  // "Jaswanth"
person.arrow();    // undefined (or window.name)
</script>
```

Why?

- regular() → this = person  
- arrow() → this = inherited from global (not person)

------------------------------------------------------------

### Summary

- this depends on **HOW** a function is called, not where it is written.
- Object methods → this = object  
- Regular functions → this = window/undefined  
- Arrow functions → inherit outer this  
- Event listeners → this = element  
- call/apply/bind allow manual this binding  
- new keyword sets this to a new object  



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



Object destructuring allows you to **extract values from objects directly into variables** using a concise syntax.  
It replaces long repetitive code and makes working with objects easier, especially when dealing with complex or nested structures.

------------------------------------------------------------

### 10.1. Basic Destructuring

Without destructuring:
```javascript
<script>
let user = { name: "Jaswanth", age: 22 };

let name = user.name;
let age = user.age;

console.log(name, age);
</script>
```

With destructuring:
```javascript
<script>
let user = { name: "Jaswanth", age: 22 };
let { name, age } = user;

console.log(name, age); 
</script>
```

Destructuring extracts properties directly into variables with the **same name as the keys**.

------------------------------------------------------------

### 10.2. Renaming Variables During Destructuring

Sometimes you want different variable names.

```javascript
<script>
let user = { name: "Jaswanth", age: 22 };

let { name: userName, age: userAge } = user;

console.log(userName, userAge);
</script>
```

Left side = new variable  
Right side = original property name

------------------------------------------------------------

### 10.3. Default Values

If a property does not exist, you can assign a default.

```javascript
<script>
let user = { name: "Jaswanth" };

let { age = 18, name } = user;

console.log(name, age);
</script>
```

If age is missing, it becomes 18.

------------------------------------------------------------

### 10.4. Destructuring Nested Objects

You can extract deep nested properties easily.

```javascript
<script>
let user = {
    name: "Jaswanth",
    address: {
        city: "Hyderabad",
        pin: 500001
    }
};

let { address: { city, pin } } = user;

console.log(city, pin);
</script>
```

Important:  
The outer key (`address`) is not created as a variable unless you explicitly assign it.

------------------------------------------------------------

### 10.5. Destructuring With Renaming + Default + Nested

All features together:

```javascript
<script>
let user = {
    name: "Kumar",
    info: {
        city: "Hyderabad"
    }
};

let {
    name: fullName,
    info: {
        city: userCity,
        pin = "No PIN"  
    }
} = user;

console.log(fullName, userCity, pin);
</script>
```

------------------------------------------------------------

### 10.6. Destructuring in Function Parameters (Very Important)

Useful when functions receive object arguments.

Without destructuring:
```javascript
<script>
function showUser(user) {
    console.log(user.name, user.age);
}
showUser({name: "A", age: 20});
</script>
```

With destructuring:
```javascript
<script>
function showUser({ name, age }) {
    console.log(name, age);
}
showUser({name: "A", age: 20});
</script>
```

Cleaner and avoids repetitive `user.name`, `user.age`.

------------------------------------------------------------

### 10.7. Destructuring With Rest (...) Operator

Extract some properties and collect the rest.

```javascript
<script>
let user = {
    name: "Jaswanth",
    age: 22,
    city: "Hyderabad",
    country: "India"
};

let { name, age, ...others } = user;

console.log(name, age); 
console.log(others);    
</script>
```

others becomes:
```
{ city: "Hyderabad", country: "India" }
```

------------------------------------------------------------

### 10.8. Useful Everywhere: API Responses, Configs, Options Objects

Real example:

```javascript
<script>
let response = {
    status: 200,
    data: {
        user: { id: 1, name: "Jaswanth" },
        token: "abc123"
    }
};

let {
    data: {
        user: { name },
        token
    }
} = response;

console.log(name, token);
</script>
```

This avoids deeply nested property chains like:
```
response.data.user.name
response.data.token
```

------------------------------------------------------------

### 10.9. Why Use Object Destructuring?

- Reduces repetitive code  
- Cleaner syntax for large objects  
- Essential for modern JS frameworks (React, Node.js, Express)  
- Useful for extracting nested values  
- Cleaner function arguments  
- Helps when working with options/config objects  


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

## Practice Tasks

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

## Practice Tasks

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

## Practice Tasks

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

## Practice Tasks

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

## Practice Tasks

1. Add a click event to change background color.  
2. Create an input field that shows live typing below it.  
3. Build a simple form and prevent its default submission.  
4. Create a list using event delegation and log clicked item.  
5. Implement a light/dark mode toggle button.  

















# Advanced JavaScript – Behind the Scenes (Topics 93–105)

------------------------------------------------------------

## 93. High-Level Overview of JavaScript

JavaScript is:

- High-level: you do not manage memory directly (no malloc/free).  
- Interpreted/Just-In-Time compiled: engine compiles to machine code at runtime.  
- Single-threaded: one main call stack, executes one thing at a time.  
- Non-blocking: uses event loop + callbacks + promises for asynchronous behavior.  
- Dynamic: types are determined at runtime (no explicit type declarations).  
- Prototype-based: objects inherit from other objects via prototypes.  
- Multi-paradigm: supports imperative, object-oriented, and functional styles.

Main areas of JavaScript:

1. **Language core**  
   - Variables, types, functions, objects, arrays, operators, control flow.

2. **Browser APIs (Web APIs)**  
   - DOM, fetch, localStorage, timers, etc. (not part of core JS).

3. **Runtime (environment)**  
   - Engine + APIs + event loop + queues.

Understanding JavaScript at a high level means knowing:
- How the engine executes code  
- How scope and closures work  
- How async code is handled  
- How memory is managed (primitives vs objects, garbage collection)

------------------------------------------------------------

## 94. The JavaScript Engine and Runtime

### JavaScript Engine

A JS engine (like V8) is responsible for **parsing** and **executing** JS code.

Rough steps:

1. **Parsing**  
   - Source code is tokenized and converted into an AST (Abstract Syntax Tree).

2. **Compilation (JIT)**  
   - Engine compiles frequently used parts into optimized machine code.

3. **Execution**  
   - Compiled code is executed on the CPU.

The engine also manages:
- Call stack  
- Heap (memory for objects, arrays, functions)  
- Garbage collection  

### JavaScript Runtime Environment

The runtime is larger than the engine. It consists of:

- Engine (V8, SpiderMonkey, etc.)  
- Web APIs (timers, DOM, fetch) – provided by browser  
- Event loop  
- Callback queue / Task queue  
- Microtask queue (promises, mutation observers)

When you write:

```javascript
<script>
setTimeout(() => console.log("Timeout"), 1000);
console.log("End");
</script>
```

Execution overview:

1. console.log("End") is executed first (synchronous).  
2. setTimeout callback is delegated to Web API.  
3. After the delay, callback is placed into the callback queue.  
4. Event loop pushes it to the call stack when the stack is empty.  
5. "Timeout" is logged.

This is how JavaScript achieves asynchronous behavior **despite being single-threaded**.

------------------------------------------------------------

## 95. Execution Contexts and The Call Stack

An **Execution Context** is a container that stores information about the environment in which current code is executed.

Types:
- Global execution context  
- Function execution context  
- Eval execution context (rarely used)

Each execution context has:
- Variable environment (variables, functions)  
- Lexical environment (scope chain)  
- this binding  

### Global Execution Context

Created when the script starts.  
Contains:
- Global variables  
- Global functions  
- this (window in browsers, global object in Node)

### Function Execution Context

Created whenever a function is called.

Contains:
- Function arguments / parameters  
- Local variables  
- Inner function declarations  
- Reference to outer lexical environment  

### Call Stack

The call stack manages execution contexts.

Example:

```javascript
<script>
function one() {
    console.log("One");
    two();
}

function two() {
    console.log("Two");
}

one();
</script>
```

Call stack steps:

1. Global context created.  
2. one() pushed → "One" logged.  
3. two() pushed → "Two" logged.  
4. two() finished → popped.  
5. one() finished → popped.  
6. Global context remains until program ends.

Understanding the call stack is essential for:
- Debugging  
- Understanding recursion  
- Understanding stack overflow errors  
- Tracing async callbacks execution order

------------------------------------------------------------

## 96. Scope and The Scope Chain

**Scope** defines **where a variable is accessible**.

Types of scope in JavaScript:

1. Global scope  
2. Function scope  
3. Block scope (with let and const)

### Lexical Scoping

JavaScript uses **lexical (static) scoping**:  
- Scope is determined by where functions and blocks are written in the code, not by where they are called.

Example:

```javascript
<script>
let globalVar = "global";

function outer() {
    let outerVar = "outer";

    function inner() {
        let innerVar = "inner";
        console.log(globalVar, outerVar, innerVar);
    }

    inner();
}
outer();
</script>
```

The inner function can access:
- innerVar (its own scope)  
- outerVar (outer function scope)  
- globalVar (global scope)

### Scope Chain

When JavaScript tries to resolve a variable name:

1. Looks in the current (local) scope.  
2. If not found, looks in the outer lexical environment.  
3. Continues until global scope.  
4. If not found → ReferenceError.

The **scope chain** is this linked list of lexical environments.

------------------------------------------------------------

## 97. Scoping in Practice (var, let, const)

### var – function scoped

```javascript
<script>
if (true) {
    var x = 10;
}
console.log(x); // 10
</script>
```

x is visible outside the block because var is **not block-scoped**, only function-scoped.

### let and const – block scoped

```javascript
<script>
if (true) {
    let y = 20;
    const z = 30;
}
// console.log(y); // ReferenceError
// console.log(z); // ReferenceError
</script>
```

y and z exist only inside the curly braces.

### Function Scope Example

```javascript
<script>
function demo() {
    var a = 1;
    let b = 2;
    const c = 3;
    console.log(a, b, c);
}
demo();
// console.log(a); // ReferenceError
</script>
```

Variables are accessible only inside demo.

### Shadowing

Inner variable with same name hides outer variable.

```javascript
<script>
let value = 10;

function show() {
    let value = 20;
    console.log(value); // 20 (inner)
}
show();
console.log(value); // 10 (outer)
</script>
```

------------------------------------------------------------

## 98. Variable Environment: Hoisting and The TDZ

### Hoisting

Before executing code, JavaScript **scans** the scope and:

- Hoists variable declarations (var) with default value undefined  
- Hoists function declarations (entire function body)  
- Hoists let and const declarations but **keeps them in the TDZ** (Temporal Dead Zone) until the actual line is executed.

### var Hoisting

```javascript
<script>
console.log(a); // undefined (not ReferenceError)
var a = 10;
</script>
```

Internally interpreted like:

```javascript
var a;
console.log(a);
a = 10;
```

### let and const Hoisting with TDZ

```javascript
<script>
// console.log(b); // ReferenceError (TDZ)
let b = 20;
</script>
```

They are hoisted but **not initialized**, so accessing them before line of declaration causes a ReferenceError.

### Function Declaration Hoisting

```javascript
<script>
greet(); // works

function greet() {
    console.log("Hello");
}
</script>
```

Because entire function is hoisted.

------------------------------------------------------------

## 99. Hoisting and TDZ in Practice

### Example 1: var vs let

```javascript
<script>
console.log(x); // undefined
var x = 5;

// console.log(y); // ReferenceError
let y = 10;
</script>
```

Explanation:
- x is hoisted and initialized to undefined.  
- y is hoisted but in TDZ until its declaration; accessing it early throws error.

------------------------------------------------------------

### Example 2: Function vs Function Expression

```javascript
<script>
sayHello(); // works

function sayHello() {
    console.log("Hello");
}

// sayHi(); // TypeError: sayHi is not a function
var sayHi = function() {
    console.log("Hi");
};
</script>
```

Reason:
- sayHello is a function declaration (fully hoisted).  
- sayHi is a variable hoisted with undefined; at call time it is still undefined, not a function.

------------------------------------------------------------

### Example 3: TDZ with const

```javascript
<script>
// console.log(rate); // ReferenceError
const rate = 0.1;
</script>
```

Accessing rate before initialization is illegal, even though it is hoisted.

------------------------------------------------------------

## 100. The this Keyword

this refers to the **execution context** in which the function is called, not where it is defined.

Its value **depends on how** the function is called.

### 1. Global context (non-strict mode)

```javascript
<script>
console.log(this); // window (in browser)
</script>
```

### 2. Method call

```javascript
<script>
let user = {
    name: "Jaswanth",
    show: function() {
        console.log(this.name);
    }
};
user.show(); // "Jaswanth"
</script>
```

Here, this refers to the object before dot → user.

### 3. Simple function call

```javascript
<script>
function demo() {
    console.log(this);
}
demo(); // window (non-strict), undefined (strict mode)
</script>
```

### 4. Constructor call with new

```javascript
<script>
function Person(name) {
    this.name = name;
}

let p = new Person("Max");
console.log(p.name);
</script>
```

When using new:
- A new empty object is created  
- this points to that object  
- The function returns this by default  

### 5. Explicit binding: call, apply, bind

```javascript
<script>
function show() {
    console.log(this.value);
}
let obj = { value: 100 };

show.call(obj);  // this = obj
</script>
```

------------------------------------------------------------

## 101. The this Keyword in Practice

### Method Borrowing

```javascript
<script>
let user = {
    name: "Jaswanth",
    greet() {
        console.log("Hello " + this.name);
    }
};

let other = { name: "Kiran" };

user.greet.call(other); // this = other
</script>
```

Output:  
Hello Kiran

------------------------------------------------------------

### this in Event Handlers

```javascript
<script>
let btn = document.querySelector("button");
btn.addEventListener("click", function() {
    console.log(this); // button element
});
</script>
```

In normal function inside addEventListener, this refers to the element.

### Arrow Functions and this

Arrow functions **do not have their own this**.  
They inherit this from the surrounding lexical scope.

```javascript
<script>
let user = {
    name: "Jaswanth",
    show: function() {
        let inner = () => {
            console.log(this.name);
        };
        inner();
    }
};
user.show(); // "Jaswanth"
</script>
```

Here, inner uses the same this as show (user).

------------------------------------------------------------

## 102. Regular Functions vs Arrow Functions

### Syntax Difference

Regular:
```javascript
function add(a, b) {
    return a + b;
}
```

Arrow:
```javascript
const add = (a, b) => a + b;
```

### this Behavior

- Regular functions: this changes based on how function is called.  
- Arrow functions: this is **lexically bound** (inherited from surrounding context).

### arguments Object

Regular functions have arguments object:

```javascript
function demo() {
    console.log(arguments);
}
```

Arrow functions do not have their own arguments.

### Constructors

Arrow functions **cannot** be used as constructors.

```javascript
const Person = (name) => {
    this.name = name;
};
// new Person("Max"); // TypeError
```

Use regular functions or classes instead.

### When to Use Which

- Use arrow functions for:
  - Callbacks  
  - Short functions  
  - Methods needing lexical this  

- Use regular functions for:
  - Constructors  
  - Object methods where dynamic this is needed  
  - Functions using arguments object  

------------------------------------------------------------

## 103. Memory Management: Primitives vs Objects

JavaScript memory is conceptualized as:

- Stack → stores primitive values and references  
- Heap  → stores objects, arrays, functions  

### Primitives (Number, String, Boolean, Null, Undefined, Symbol, BigInt)

Assigned and copied **by value**.

```javascript
<script>
let a = 10;
let b = a;
b = 20;
console.log(a, b); // 10 20
</script>
```

Changing b does not affect a.

### Objects (arrays, functions, plain objects)

Assigned and copied by **reference** (the reference itself is a primitive stored on stack, but it points to heap).

```javascript
<script>
let obj1 = { x: 1 };
let obj2 = obj1;
obj2.x = 5;
console.log(obj1.x, obj2.x); // 5 5
</script>
```

Both variables refer to the same object in heap.

Understanding this is crucial for:
- Avoiding accidental mutations  
- Correctly copying objects and arrays  
- Managing state in applications  

------------------------------------------------------------

## 104. Object References in Practice (Shallow vs Deep Copies) – Full Detailed Explanation

------------------------------------------------------------

### 1. Why Object Copying Matters

In JavaScript:
- **Primitive values** (number, string, boolean, etc.) are copied **by value**.  
- **Objects, arrays, functions** are copied **by reference**.

This means:
When you assign an object to another variable, both variables point to the **same memory location**.

Understanding shallow and deep copying helps avoid bugs like:
- Accidental mutations  
- Unexpected data changes  
- State corruption in applications  
- Issues in React, Node.js, or any modern JS framework  

------------------------------------------------------------

### 2. JavaScript Memory Model (Simple View)

JavaScript stores data in two places:

### Stack  
Stores:
- Primitive values  
- References (pointers) to objects in heap  

### Heap  
Stores:
- Actual objects  
- Arrays  
- Functions  
- Complex data structures  

**Important**
A variable storing an object DOES NOT store the object itself.  
It stores the **reference** to the object in heap.

------------------------------------------------------------

### 3. Copying Objects — By Reference (The Core Problem)

```javascript
<script>
let obj1 = { name: "Jaswanth", age: 22 };
let obj2 = obj1; // Not a copy, just another reference

obj2.age = 30;

console.log(obj1.age); // 30
</script>
```

### Why?
Both obj1 and obj2 point to the **same memory location**.

Diagram:

```
obj1 ---> { name: "Jaswanth", age: 22 } <--- obj2
```

Changing obj2 **changes the same object**, so obj1 also changes.

This is why you need **copying** instead of referencing.

------------------------------------------------------------

### 4. Shallow Copy – What It Means

A **shallow copy** copies:
- Top-level properties  
- But nested objects/arrays are still copied by reference  

Shallow copy creates a **new object**, but nested levels still reference old memory.

------------------------------------------------------------

### 5. Ways to Create a Shallow Copy

### 5.1 Using Spread Operator (...)
```javascript
<script>
let original = { a: 1, nested: { b: 2 } };
let copy = { ...original };

copy.a = 10;
copy.nested.b = 50;

console.log(original.a);        // 1 (independent)
console.log(original.nested.b); // 50 (shared nested reference)
</script>
```

### 5.2 Using Object.assign()
```javascript
<script>
let original = { x: 10, inner: { y: 20 } };
let copy = Object.assign({}, original);

copy.inner.y = 100;

console.log(original.inner.y); // 100
</script>
```

### 5.3 Array Shallow Copy
```javascript
<script>
let arr = [1, 2, { value: 3 }];
let copy = [...arr];

copy[2].value = 999;
console.log(arr[2].value); // 999
</script>
```

------------------------------------------------------------

### 6. Why Shallow Copy Is Not Enough

Shallow copies do not copy nested objects.  
Only the **first level** is copied.

Whenever you modify a nested object, both original and copied objects change because they share the same reference.

Example:
```
copy.nested === original.nested  // true
```

If your object has more than one level, shallow copy is **not safe**.

------------------------------------------------------------

### 7. Deep Copy – What It Means

A **deep copy** creates:
- A completely new object  
- All nested objects and arrays are also fully copied  
- No shared references  

Diagram:

```
original ---> { a:1, nested:{ b:2 } }

deepCopy ---> { a:1, nested:{ b:2 } }

original.nested !== deepCopy.nested // true
```

Deep copy ensures:
- Modifying nested objects inside copy does NOT affect original.

------------------------------------------------------------

### 8. Ways to Create Deep Copies

### 8.1 JSON Method (Simple Deep Copy)

```javascript
<script>
let original = { a: 1, nested: { b: 2 } };
let deep = JSON.parse(JSON.stringify(original));

deep.nested.b = 500;

console.log(original.nested.b); // 2
</script>
```

### Pros:
- Simple  
- Fast  
- Works for simple objects  

### Cons:
- Loses functions  
- Loses undefined values  
- Loses symbols  
- Converts Dates to strings  
- Cannot handle recursive structures  

------------------------------------------------------------

### 8.2 Manual Deep Copy (Recursive Approach)

A recursive function walks through every property and copies it.

```javascript
<script>
function deepCopy(obj) {
    if (obj === null || typeof obj !== "object") return obj;

    let copy = Array.isArray(obj) ? [] : {};

    for (let key in obj) {
        copy[key] = deepCopy(obj[key]);
    }

    return copy;
}

let original = { name: "A", nested: { value: 10 } };
let deep = deepCopy(original);

deep.nested.value = 50;

console.log(original.nested.value); // 10
</script>
```

This method fully clones all nested levels.

------------------------------------------------------------

### 8.3 structuredClone() – Modern Native Deep Copy

If supported in your environment:

```javascript
<script>
let original = { x: 1, nested: { y: 2 } };
let deep = structuredClone(original);

deep.nested.y = 200;

console.log(original.nested.y); // 2
</script>
```

###V Pros:
- Handles deep clone natively  
- Supports cyclic references  
- Fast and reliable  

#### Cons:
- Not supported in older browsers  
- Cannot handle functions  

------------------------------------------------------------

### 9. Comparison Table

| Feature | Shallow Copy | Deep Copy |
|--------|--------------|-----------|
| Copies top level | Yes | Yes |
| Copies nested objects | No | Yes |
| Same nested references | Yes | No |
| Risk of accidental mutation | High | None |
| Use cases | Simple objects | Complex structured objects |
| Methods | spread, Object.assign | JSON, recursive, structuredClone |

------------------------------------------------------------

## Memory Management: Garbage Collection in JavaScript (In Depth)

------------------------------------------------------------

### 1. Why Memory Management Matters

Every program needs memory to:

- Store variables  
- Create objects and arrays  
- Hold functions and closures  
- Cache data temporarily  

When memory is no longer needed but not released, it leads to:
- Memory leaks  
- Slower performance  
- Possible crashes in long-running apps (SPAs, Node servers)

JavaScript is a **high-level language**, so you do not manually manage memory with functions like malloc/free.  
Instead, the **JavaScript engine automatically allocates and frees memory** using **garbage collection (GC)**.

Understanding how GC works helps you:
- Avoid memory leaks  
- Recognize harmful patterns  
- Write efficient long-running code  

------------------------------------------------------------

### 2. Allocation and Lifetime of Values

When you create data:

```javascript
<script>
let num = 10;                     // primitive
let user = { name: "Jaswanth" };  // object
</script>
```

The engine:
- Allocates memory for num on the stack (value directly).  
- Allocates memory for user on the heap and stores a **reference** on the stack.

Lifetime:
- A value lives as long as it is **reachable** from somewhere in the program.

------------------------------------------------------------

### 3. Core Concept: Reachability

Modern JS engines (like V8) use the concept of **reachability** for garbage collection.

A value is considered **reachable** if it can be accessed in some way from the "roots".

### Common Roots:

1. Global object (window in browsers, global in Node)  
2. Currently executing function’s local variables  
3. Variables in the call stack  
4. Values captured in closures  
5. Objects referenced from other reachable objects  

If a value is **not reachable from any root**, it is considered **garbage** and can be collected.

------------------------------------------------------------

### 4. Simple Reachability Example

```javascript
<script>
let user = { name: "Jaswanth" };  // user points to object

// later
user = null;
</script>
```

Explanation:

- Initially, user references the object → object is reachable.  
- After setting user = null; nothing references the object.  
- The object becomes unreachable → GC will eventually free the memory.

Diagram:

Before:
user → { name: "Jaswanth" }

After:
user → null  
{ name: "Jaswanth" } → unreachable → eligible for GC  

------------------------------------------------------------

### 5. Reference Graph and Garbage Collection

Think of your program as a **graph of objects**:

- Nodes = objects / values  
- Edges = references  

Garbage collection marks all **reachable** nodes starting from roots.  
Anything not marked is **unreachable** and freed.

This is usually done by a **mark-and-sweep** algorithm.

### Mark-and-Sweep (Conceptual Steps):

1. Start from roots (global, stack, closures).  
2. Traverse all referenced objects and mark them as reachable.  
3. After traversal, all **unmarked** objects are unreachable.  
4. The GC sweeps over memory and frees unmarked objects.

You do not control **when** GC runs; the engine decides based on:
- Memory pressure  
- Performance heuristics  
- Internal thresholds  

------------------------------------------------------------

### 6. Cycles and Garbage Collection

Old naive garbage collectors had problems with cycles:

```javascript
<script>
function createCycle() {
    let a = {};
    let b = {};

    a.ref = b;
    b.ref = a;
}
createCycle();
</script>
```

Here:
- a references b  
- b references a  

Even though they reference each other, once createCycle finishes, there is **no reference from outside** to a or b.

Modern GC using reachability:

- Checks from roots; if neither a nor b is reachable from any root,  
  the cycle is considered garbage and collected safely.

So, cyclic references **by themselves** are not a problem.

------------------------------------------------------------

### 7. Common Memory Leak Patterns

Even with automatic GC, you can **accidentally** keep objects reachable.

### 7.1 Global Variables

Anything stored in global scope remains reachable for the lifetime of the page.

```javascript
<script>
let bigData = []; // never cleared
</script>
```

If bigData grows and is never reset or released, it leads to memory leaks.

------------------------------------------------------------

### 7.2 Unremoved Event Listeners

```javascript
<script>
let button = document.getElementById("click");
let user = { name: "Jaswanth" };

function handler() {
    console.log(user.name);
}

button.addEventListener("click", handler);
// but later the button is removed, listener is not cleaned properly
</script>
```

If the DOM node or the handler reference remains somewhere, both can stay in memory.

Best practice:
- Remove listeners when elements are removed or no longer needed.

```javascript
button.removeEventListener("click", handler);
```

------------------------------------------------------------

### 7.3 Closures Holding References

Closures can keep data alive longer than needed.

```javascript
<script>
function createLogger() {
    let data = new Array(1000000).fill("large");
    return function() {
        console.log("Logging");
    };
}

let log = createLogger();
// data is still in memory because the inner function closes over it
</script>
```

Even though you no longer use `data`, it stays reachable through the closure scope.

If data is not needed, design your closure differently or explicitly drop references.

------------------------------------------------------------

### 7.4 Caches and Maps

Storing data in caches without invalidation leads to leaks.

```javascript
<script>
let cache = {};

function store(key, value) {
    cache[key] = value;
}
</script>
```

If you never delete keys or reset cache, memory usage grows endlessly.

------------------------------------------------------------

### 8. WeakMap and WeakSet (GC-Friendly References)

WeakMap and WeakSet hold **weak references** to keys.  
That means: if there are no other strong references to a key object, it can be garbage collected.

### WeakMap Example

```javascript
<script>
let wm = new WeakMap();

let obj = { id: 1 };
wm.set(obj, "Some data");

// later
obj = null; // object becomes unreachable, entry in WeakMap can be cleaned
</script>
```

Use cases:
- Storing metadata about objects  
- Avoiding memory leaks when using objects as keys  

WeakMap does not prevent garbage collection of its keys.

------------------------------------------------------------

### 9. You Cannot Manually Force Garbage Collection

JavaScript does not provide a standard API to force GC (like gc()).

Reasons:
- Engine must decide optimal time based on heuristics.  
- Forcing GC might hurt performance.  
- Different platforms implement GC differently.

In some debugging tools (like Chrome DevTools), there are manual **“Collect Garbage”** buttons, but this is only for debugging.

------------------------------------------------------------

### 10. Best Practices to Avoid Memory Issues

1. Avoid unnecessary global variables.  
2. Clear references when done:
   - Set large structures to null if no longer needed.  
3. Remove event listeners when elements or components die.  
4. Be careful with long-lived closures capturing large data.  
5. Use local variables where possible (allow auto cleanup when function ends).  
6. Monitor memory usage in browser dev tools or Node profilers for large apps.  
7. Design cache strategies with limits and eviction (LRU, time-based expiration).  

------------------------------------------------------------

### 11. Example: Good vs Bad Patterns

### Bad: forgetting to clear timer

```javascript
<script>
let bigObject = { data: new Array(1000000).fill("value") };

setInterval(function() {
    console.log("Still running");
}, 1000);
</script>
```

Even if you stop using bigObject, the program runs forever, global references remain, and GC may not reclaim as expected.

### Better:

```javascript
<script>
let bigObject = { data: new Array(1000000).fill("value") };

let id = setInterval(function() {
    console.log("Running");
}, 1000);

// later when not needed
clearInterval(id);
bigObject = null;
</script>
```

------------------------------------------------------------

### 12. Summary of Garbage Collection in JavaScript

1. Memory management is automatic, but you still influence **reachability**.  
2. GC is based on **reachability**, not reference count.  
3. Mark-and-sweep is the core algorithm used.  
4. Cycles are safe if nothing outside references them.  
5. Memory leaks happen when you unintentionally keep references alive.  
6. Use best practices to let GC do its job effectively.  
7. You do not control when GC runs; you only control how you create and drop references.



### <h1>Summary of Advanced Topics</h1>

- JavaScript runs in an engine with a runtime that includes Web APIs and an event loop.  
- Execution contexts and the call stack explain how code is run step by step.  
- Scope and the scope chain control variable visibility.  
- Hoisting and TDZ explain strange behaviors around variable access.  
- this depends on how functions are called, not where defined; arrow functions capture lexical this.  
- Primitives are copied by value, objects by reference.  
- Shallow vs deep copy is essential when working with complex objects.  
- Garbage collection automatically frees memory for unreachable objects.
---
| Primitive Type | Indexed | Ordered | Iterable | forEach | Mutable |
|----------------|---------|---------|----------|---------|---------|
| Number         | No      | No      | No       | No      | No      |
| String         | Yes     | Yes     | Yes      | No      | No      |
| Boolean        | No      | No      | No       | No      | No      |
| Null           | No      | No      | No       | No      | No      |
| Undefined      | No      | No      | No       | No      | No      |
| Symbol         | No      | No      | No       | No      | No      |
| BigInt         | No      | No      | No       | No      | No      |
---
---
| Object Type    | Indexed | Ordered | Iterable | forEach | Mutable |
|----------------|---------|---------|----------|---------|---------|
| Object         | No      | Partial | No       | No      | Yes     |
| Array          | Yes     | Yes     | Yes      | Yes     | Yes     |
| Function       | No      | No      | No       | No      | Yes     |
| Map            | No      | Yes     | Yes      | Yes     | Yes     |
| Set            | No      | Yes     | Yes      | Yes     | Yes     |
| WeakMap        | No      | No      | No       | No      | Yes     |
| WeakSet        | No      | No      | No       | No      | Yes     |
| Date           | No      | No      | No       | No      | Yes     |
| RegExp         | No      | No      | No       | No      | Yes     |
| Typed Arrays   | Yes     | Yes     | Yes      | Yes     | Yes     |
| Promise        | No      | No      | No       | No      | Yes     |
| Error          | No      | No      | No       | No      | Yes     |
---