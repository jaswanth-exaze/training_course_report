# JavaScript Engine Internal Working

## Global Execution Context • Call Stack • Heap • TDZ • Full Flowchart

---

# 1. Global Execution Context (GEC)

When JavaScript starts running your file,  
the first thing it creates is the **Global Execution Context**.

The GEC has two parts:

### 1.1 Memory Component (Variable Environment)

Stores:

- Variables (var / let / const)
- Functions
- Objects

### 1.2 Code Component (Thread of Execution)

Executes code **line-by-line**.

### Diagram

```
Global Execution Context (GEC)
-----------------------------------------------
| Memory Component         | Code Component   |
| (Variables & Functions)  | (Execution Flow) |
-----------------------------------------------
```

Only **one** GEC exists for your whole script.

---

# 2. Call Stack

The **call stack** controls which function is currently running.

When a function is called → a new **Execution Context (EC)** is created and pushed onto the stack.

When a function returns → its EC is popped off.

### Diagram

```
Call Stack
-------------------------
| Function C EC          | ← currently running
-------------------------
| Function B EC          |
-------------------------
| Function A EC          |
-------------------------
| Global EC              |
-------------------------
```

When the stack becomes empty → program ends.

---

# 3. Heap

The heap is a memory area used to store **non-primitive objects**:

- Objects
- Arrays
- Functions
- Maps, Sets, etc.

Objects live in the heap; variables in memory store **references** to them.

### Diagram

```
Heap (unordered memory for objects)
----------------------------------------
| {name: "A"}                           |
| [1,2,3]                               |
| function() {...}                      |
| {x:10, y:20}                          |
----------------------------------------
```

The heap is dynamic, expandable, and managed by **Garbage Collection**.

---

# 4. TDZ (Temporal Dead Zone)

TDZ is the period between:

1. When a variable is **allocated** in memory
2. When it is **initialized**

Variables declared with `let` and `const` exist in memory but are **not usable** until the execution reaches their line.

### Example

```javascript
console.log(a); // ❌ Error (TDZ)
let a = 10;
```

### Memory Behavior

```
Memory:
a → uninitialized (TDZ)
```

Once execution reaches `let a = 10`, TDZ ends.

### Summary

| Keyword | Hoisted? | In TDZ? | Default value |
| ------- | -------- | ------- | ------------- |
| var     | Yes      | No      | undefined     |
| let     | Yes      | Yes     | uninitialized |
| const   | Yes      | Yes     | uninitialized |

---

# 5. How the JS Engine Runs a File (Flowchart)

Below is the **complete lifecycle**:

---

## PHASE 1 — Compilation (Parsing + Memory Allocation)

JavaScript **does NOT execute code yet**.  
It scans your file and allocates memory.

### What happens:

- Create Global Execution Context
- Allocate memory for:
  - var → undefined
  - let / const → TDZ
  - function declarations → full function stored

### Diagram

```
Compilation Phase
------------------------------------------------
Memory Allocation:
var x        → undefined
let y        → TDZ
const z      → TDZ
function abc → stored completely
------------------------------------------------
```

---

## PHASE 2 — Execution Phase (Line-by-line execution)

Now JavaScript runs the code.

- When encountering a function call → push new EC to call stack
- When returning from a function → pop EC
- Access variables:
  - var → ok
  - let/const before initialization → TDZ error

### Execution Flow Diagram

```
Start Program
       ↓
Create Global Execution Context
       ↓
Memory Phase (hoisting)
       ↓
Execution Phase (line-by-line)
       ↓
Function calls create new Execution Contexts
       ↓
Execution Contexts pushed to Call Stack
       ↓
Completed functions popped from Call Stack
       ↓
If no EC left → Program ends
```

---

# 6. Complete Engine Architecture Diagram

```
                 ┌────────────────────────┐
                 │   JS Runtime (Browser) │
                 ├────────────────────────┤
                 │  JS Engine (V8, etc.)  │
                 ├────────────────────────┤
                 │   • Call Stack         │
                 │   • Heap               │
                 │   • Execution Contexts │
                 └────────────────────────┘
                             │
                             ▼
                ┌─────────────────────────┐
                │   Web APIs (DOM, Timer) │
                └─────────────────────────┘
                             │
                             ▼
                ┌─────────────────────────┐
                │ Callback/Microtask Queue│
                └─────────────────────────┘
                             │
                             ▼
                ┌─────────────────────────┐
                │      Event Loop          │
                └─────────────────────────┘
```

---

# 7. Putting It All Together (Example)

Code:

```javascript
console.log(abc(5));
function abc(n) {
  return n * 2;
}
```

### MEMORY PHASE

```
abc → function(n){...}
console.log → built-in function
```

### EXECUTION PHASE

1. console.log(abc(5))
2. Call abc → push EC
3. Compute result → pop EC
4. Print output

Final call stack:

```
Call Stack
------------------
| Global EC       |
------------------
```

---

# Final Summary

- The **Global Execution Context** is the base environment for your script
- The **Call Stack** manages function execution order
- The **Heap** stores objects
- **TDZ** prevents use of variables before initialization
- JS engine always performs:
  - Compilation (memory allocation)
  - Execution (line-by-line)

This is the complete lifecycle of JavaScript execution.
# Full Execution + Memory Allocation + Flow (Step-by-Step)

We will analyze this code:

```javascript
const circle = {
    radius: 10,
    area: function () {
        return Math.PI * this.radius * this.radius;
    }
};
function add(x,y){
  console.log(x+y)
}

console.log(circle.area());             
add(12,5)
```

------------------------------------------------------------
# 1. MEMORY CREATION PHASE (Hoisting Phase)

Before any line runs, JavaScript scans the file and allocates memory.

### Memory Allocation Table

```
Memory (Global)
--------------------------------------------------------
circle        → TDZ (because const)
add           → function add(x,y){ console.log(x+y) }
console       → built-in object
Math          → built-in object
Pi            → Math.PI accessed later
--------------------------------------------------------
```

### Important:
- `const circle` exists but is **not initialized** yet → in **TDZ**
- `function add()` is **fully stored** (function declarations are hoisted)

------------------------------------------------------------
# 2. EXECUTION PHASE (Line-by-Line Execution)

Now JS begins executing from top.

------------------------------------------------------------
## STEP 1: Execute `const circle = {...}`

At this moment, JS:

1. Allocates an **object in the heap**:

```
Heap:
--------------------------
circleObj: {
  radius: 10,
  area: function() {...}
}
--------------------------
```

2. The variable `circle` now points to this object:

```
Memory:
circle → reference to circleObj
```

### Inside circle.area:
- It is a **normal function**, not an arrow
- So `this` will refer to **the object that calls it**

------------------------------------------------------------
## STEP 2: Function add is already in memory

```
add → function(x,y){ console.log(x+y) }
```

Nothing else happens right now.

------------------------------------------------------------
## STEP 3: Execute `console.log(circle.area())`

### 3.1 Evaluate `circle.area()`

Calling method:

```
circle.area()
```

Creates a new **Function Execution Context (FEC)**:

```
Call Stack:
-----------------------
| area() EC           |
-----------------------
| Global EC           |
-----------------------
```

### 3.2 Set value of `this` inside area()

Since `circle.area()` was called using the object:

```
this = circleObj
```

### 3.3 Execute the return expression:

```
return Math.PI * this.radius * this.radius;
```

Substitute values:

```
this.radius = 10
Math.PI ≈ 3.14159

Area = 3.14159 * 10 * 10
     = 314.1592653589793
```

The function returns:

```
314.1592653589793
```

The Execution Context of area() is popped off:

```
Call Stack:
-----------------------
| Global EC           |
-----------------------
```

### 3.4 console.log prints:

```
314.1592653589793
```

------------------------------------------------------------
## STEP 4: Execute `add(12,5)`

Calling:

```
add(12,5)
```

Creates another Function Execution Context:

```
Call Stack:
-----------------------
| add() EC            |
-----------------------
| Global EC           |
-----------------------
```

### Inside add():
- x = 12  
- y = 5  

Executes:

```
console.log(x+y)
```

This prints:

```
17
```

After printing, add() returns `undefined` and its EC is removed.

```
Call Stack:
-----------------------
| Global EC           |
-----------------------
```

------------------------------------------------------------
# 5. END OF PROGRAM

No more code.  
Global Execution Context remains and then clears.

------------------------------------------------------------
# 6. VISUAL DIAGRAM OF ENTIRE EXECUTION

### MEMORY BEFORE EXECUTION

```
Global Memory
------------------------------------------------------
circle     → TDZ
add        → function add(x,y)
console    → built-in
Math       → built-in
------------------------------------------------------
```

### AFTER EXECUTING circle = {...}

```
Heap:
circleObj = {
   radius: 10,
   area: function(){...}
}

Memory:
circle → circleObj
```

### CALL STACK DURING EXECUTION

```
Initial:
[ Global EC ]

When calling circle.area():
[ area EC ]
[ Global EC ]

After area completes:
[ Global EC ]

When calling add(12,5):
[ add EC ]
[ Global EC ]

After add completes:
[ Global EC ]
```

------------------------------------------------------------
# 7. How `this` was determined in circle.area()

Because we called:

```
circle.area()
```

The rule:

```
Object before dot → becomes `this`
```

So:

```
this = circleObj
this.radius = 10
```

If we did:

```
let a = circle.area;
a();
```

Then `this` would be `undefined` (strict mode) or `window` (non-strict).

------------------------------------------------------------
# 8. FINAL OUTPUT

```
314.1592653589793
17
```

------------------------------------------------------------

# Final Summary (Very Clear)

- **circle** is created during execution and stored in heap  
- **area()** gets its `this` from the caller object (circle)  
- **add()** is hoisted and ready before execution  
- **Call Stack** manages function execution order  
- **Heap** stores the object `{radius:10, area:fn}`  
- **TDZ** applies to circle until initialization occurs  

This is the full execution picture.


