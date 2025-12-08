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
