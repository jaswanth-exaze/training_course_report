# Node.js Event Loop — Restaurant Analogy (Simple & Clear)

---

## Imagine This

You enter a small restaurant.  
There is only **ONE waiter**.

At first you think:

> Only one waiter? This will be slow.

But this waiter is smart.

He does **NOT** wait near the kitchen.

Instead:

1. Takes your order  
2. Gives the order to the kitchen  
3. Immediately goes to the next customer  
4. Kitchen rings a bell when food is ready  
5. Waiter delivers the food  

Because of this system, many customers are served fast.

---

## Who Is Who In Node.js

Restaurant Story -> Real Meaning

Waiter -> Event Loop  
Kitchen -> OS / System APIs  
Bell -> Callback / Promise Resolve  
Customer Order -> Your Code Request  

---

## What Does Single-Threaded Mean?

Node.js has **ONLY ONE waiter**.

This means:

- One main execution thread  
- One call stack  
- One event loop  

### Other Languages (Traditional Servers)

- 1 user = 1 thread  
- 100 users = 100 threads  
- High memory usage  
- High CPU usage  

### Node.js Approach

- 1000 users  
- Still ONE smart waiter  
- Uses async system help  

That is why Node.js is **fast and memory efficient**.

---

## Golden Rule (Very Important)

### NEVER make the waiter cook.

Bad examples:

- Big loops  
- Heavy calculations  
- Blocking code  
- Synchronous file operations  

### What Happens?

- Waiter stops taking orders  
- Whole app freezes  
- Requests are blocked  

This is called:

BLOCKING THE EVENT LOOP

### Correct Approach

Give heavy work to:

- File system  
- Database  
- External APIs  
- Worker threads  

Let the Event Loop only manage tasks.

---

## How Event Loop Works (Simple Flow)

The waiter runs in a circle.

Each round it checks these stations:

---

### 1. Timers Phase

Handles:

- setTimeout()  
- setInterval()  

If time is finished -> callback executes.

---

### 2. Pending Callbacks Phase

Handles:

- System callbacks  
- Network error callbacks  

Mostly internal.

---

### 3. Idle / Prepare Phase

Internal housekeeping.

Usually ignored by developers.

---

### 4. Poll Phase (MOST IMPORTANT)

This is the heart of Node.js.

Here Event Loop waits for:

- File read completion  
- API responses  
- Database responses  

Most async I/O happens here.

---

### 5. Check Phase

Handles:

- setImmediate()  

Runs immediately after Poll phase.

---

### 6. Close Callbacks Phase

Cleanup tasks:

- Closing DB connections  
- Closing sockets  
- Resource cleanup  

---

## Microtasks (VIP Line)

Some tasks are **VIP guests**.

These include:

- Promise.then()  
- process.nextTick()  

### Rule

After EVERY task execution:

Event Loop clears Microtask Queue first.

Only then it moves to next phase.

That is why:

Promises run BEFORE timers.

### Danger

If you keep creating promises inside promises:

- Event Loop stays busy with VIPs  
- Other tasks starve  

This is called:

MICROTASK STARVATION

---

## Confusing Example Everyone Faces

Code Example:

    console.log("A");

    setTimeout(() => {
      console.log("B");
    }, 0);

    Promise.resolve().then(() => {
      console.log("C");
    });

    console.log("D");

---

## Step By Step Execution

### 1. Synchronous Code Runs First

Output:

    A
    D

---

### 2. Microtask Queue Executes

Output:

    C

---

### 3. Timer Executes In Next Loop

Output:

    B

---

## Final Output

    A
    D
    C
    B

---

## Why You Must Understand This

Without Event Loop knowledge:

- You guess execution order  
- You write blocking code  
- You build slow servers  

With Event Loop knowledge:

- You write fast APIs  
- You avoid blocking  
- You build scalable systems  
- You debug async bugs easily  

---

## Final Memory Trick

Remember this:

Node.js has one smart waiter.  
Do not make him cook.  
Heavy work goes to kitchen.  
VIPs (Promises) are served first.  
Timers come later.  

If you understand this, you understand **80% of Node.js async behavior**.