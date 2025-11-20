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

------------------------------------------------------------

# 1. Variables (var, let, const)

Variables store values in JavaScript.  
They allow your program to read, update, and manipulate data dynamically.

JavaScript provides three keywords to declare variables:
- var  
- let  
- const  

Each behaves differently in terms of scope, updating, and re-declaration.

------------------------------------------------------------

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
<script>
let score = 10;
score = 20;
console.log(score);
</script>
```
Output:  
20

------------------------------------------------------------

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
<script>
const x = 5;
x = 10; // Error
</script>
```

------------------------------------------------------------

# var (Legacy Declaration — avoid in modern code)

### Key Points
- Function-scoped  
- Can be updated and re-declared  
- Hoisted (initialized as undefined)  
- Can cause unexpected behavior  

### Example (hoisting)
```javascript
<script>
console.log(a); 
var a = 10;
</script>
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

------------------------------------------------------------

# Summary Table (Quick Reference)

| Feature            | var                    | let                   | const                    |
|--------------------|------------------------|------------------------|--------------------------|
| Scope              | Function-scoped        | Block-scoped           | Block-scoped             |
| Can be updated     | Yes                    | Yes                    | No                       |
| Can be re-declared | Yes                    | No                     | No                       |
| Must initialize    | No                     | No                     | Yes                      |
| Hoisting behavior  | Yes (undefined)        | Yes (TDZ)              | Yes (TDZ)                |
| Use in modern JS   | Avoid                  | Good                   | Best default choice      |

------------------------------------------------------------

# 2. Data Types (Primitive & Non-Primitive)

JavaScript has two major categories of data types.

------------------------------------------------------------

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

------------------------------------------------------------

# String  
Represents a sequence of characters.  
Used for text.

### Example
```javascript
<script>
let firstName = "Jaswanth";
let msg = 'Welcome';
let text = `Template literal example`;
console.log(firstName, msg, text);
</script>
```

------------------------------------------------------------

# Number  
JavaScript uses floating-point numbers for both decimals and integers.

### Example
```javascript
<script>
let age = 23;
let price = 99.5;
console.log(age, price);
</script>
```

------------------------------------------------------------

# Boolean  
Represents true or false.

### Example
```javascript
<script>
let isLoggedIn = true;
let isVerified = false;
console.log(isLoggedIn, isVerified);
</script>
```

------------------------------------------------------------

# Null  
Intentional empty value.

### Example
```javascript
<script>
let data = null;
console.log(data);
</script>
```

------------------------------------------------------------

# Undefined  
A variable declared but not assigned.

### Example
```javascript
<script>
let value;
console.log(value);
</script>
```

------------------------------------------------------------

# BigInt  
Used for very large integers.

### Example
```javascript
<script>
let big = 123456789123456789n;
console.log(big);
</script>
```

------------------------------------------------------------

# Symbol  
Used to create unique identifiers.

### Example
```javascript
<script>
let s1 = Symbol("id");
let s2 = Symbol("id");
console.log(s1 === s2);
</script>
```

Output:  
false

------------------------------------------------------------

# Non-Primitive Types  
Stored by reference.

### Types
- Object  
- Array  
- Function  

------------------------------------------------------------

### Example (Object, Array, Function)
```javascript
<script>
let user = { name: "Jaswanth", age: 22 };
let numbers = [10, 20, 30];
function greet() { console.log("Hello"); }
</script>
```

------------------------------------------------------------

# 3. Operators (Arithmetic, Logical, Comparison)

Operators allow mathematical and logical operations.

------------------------------------------------------------

# Arithmetic Operators
-  Addition + 
-  Subtraction   -
-  Multiplication  *
-  Division /
-  Modulus  %
- Exponent  **

### Example
```javascript
<script>
let x = 10;
let y = 3;
console.log(x + y);
console.log(x - y);
console.log(x * y);
console.log(x % y);
</script>
```

------------------------------------------------------------

# Comparison Operators
Used to compare values.

- >  
- <  
- >=  
- <=  
- ==  
- ===  
- !=  
- !==  

### Example
```javascript
<script>
console.log(10 > 5);
console.log(10 === "10");
console.log(10 === 10);
</script>
```

------------------------------------------------------------

# Logical Operators
- &&  
- ||  
- !  

### Example
```javascript
<script>
console.log(true && false);
console.log(true || false);
console.log(!false);
</script>
```

------------------------------------------------------------

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

------------------------------------------------------------

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

------------------------------------------------------------

# 6. Type Conversion (Explicit & Implicit)

------------------------------------------------------------

# Explicit Conversion

### Example
```javascript
<script>
console.log(Number("20"));
console.log(String(100));
console.log(Boolean(1));
</script>
```

------------------------------------------------------------

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

------------------------------------------------------------

# Practice Tasks

1. Declare one example of each primitive data type.  
2. Create an object with keys name, age, and city.  
3. Perform arithmetic operations on two numbers.  
4. Use template literals to print an introduction.  
5. Convert string "50" to number and verify the type.  

# Part 3 – Control Flow in JavaScript  

------------------------------------------------------------

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

------------------------------------------------------------

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

------------------------------------------------------------

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

------------------------------------------------------------

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

------------------------------------------------------------

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

------------------------------------------------------------

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

------------------------------------------------------------

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

------------------------------------------------------------

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

------------------------------------------------------------

# Summary Table

| Feature      | for loop                     | while loop                 | do-while loop                 |
|--------------|------------------------------|----------------------------|-------------------------------|
| Runs when    | Condition true               | Condition true             | At least once                 |
| Condition    | Checked before each loop     | Checked before             | Checked after first run       |
| Use case     | Known iterations             | Unknown iterations         | Must run once even if false   |

------------------------------------------------------------

# Practice Tasks

1. Write an if–else program to check if a number is even or odd.  
2. Use switch to print the name of a month based on its number.  
3. Print numbers from 1 to 20 using a for loop.  
4. Print numbers from 10 to 1 using a while loop.  
5. Skip printing the number 7 using continue.  
6. Use break to stop the loop when the number reaches 15.

