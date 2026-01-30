# Callbacks vs Promises vs Async/Await — With Restaurant Story + Real Examples

---

## First Understand The Situation

JavaScript is single-threaded.

Meaning:

- One waiter (Event Loop)  
- Many customers (requests)  
- Slow kitchen work (DB, file, API)  

We must NOT block the waiter.

So Node.js uses async patterns:

1) Callbacks  
2) Promises  
3) Async/Await  

All three solve the SAME problem.

Only the style changes.

---

# PART 1 — CALLBACK STYLE (OLD RESTAURANT METHOD)

---

## Callback Restaurant Story

Customer tells waiter:

"When food is ready, CALL me."

Waiter writes customer number.

Goes to serve other tables.

When kitchen finishes:

Waiter calls customer back.

---

## Callback Code Example

Imagine this function:

    function orderFood(callback) {
        console.log("Waiter: Order given to kitchen");

        setTimeout(() => {
            console.log("Kitchen: Food is ready");
            callback();
        }, 2000);
    }

Calling it:

    orderFood(() => {
        console.log("Customer: Eating food");
    });

---

## What Happens Step By Step

Execution flow:

1) Waiter sends order  
2) Kitchen starts cooking (2 seconds)  
3) Waiter serves other customers  
4) Kitchen finishes  
5) Callback is called  
6) Customer eats  

Output:

    Waiter: Order given to kitchen
    Kitchen: Food is ready
    Customer: Eating food

---

## Callback Problem (Multiple Steps)

Now imagine restaurant steps:

- Take order  
- Cook food  
- Pack food  
- Deliver food  

Callback version:

    takeOrder(() => {
        cookFood(() => {
            packFood(() => {
                deliverFood(() => {
                    console.log("Customer: Order completed");
                });
            });
        });
    });

Problems:

- Too much nesting  
- Hard to read  
- Hard to debug  
- Ugly structure  

This is called:

CALLBACK HELL

---

# PART 2 — PROMISE STYLE (TOKEN SYSTEM)

---

## Promise Restaurant Story

Instead of calling customer:

Kitchen gives TOKEN number.

Customer waits.

When food is ready:

System automatically notifies.

No phone calls.

No confusion.

---

## Promise Code Example

Function returns Promise:

    function orderFood() {
        return new Promise((resolve, reject) => {

            console.log("Waiter: Order sent to kitchen");

            setTimeout(() => {
                console.log("Kitchen: Food prepared");
                resolve("Pizza");
            }, 2000);

        });
    }

Using Promise:

    orderFood()
      .then(food => {
          console.log("Customer received:", food);
      })
      .catch(error => {
          console.log("Problem:", error);
      });

---

## What Happens Step By Step

Flow:

1) Waiter sends order  
2) Promise created  
3) Kitchen works  
4) resolve() sends food  
5) then() receives food  

Output:

    Waiter: Order sent to kitchen
    Kitchen: Food prepared
    Customer received: Pizza

---

## Multiple Steps Using Promise Chaining

Restaurant flow:

    orderFood()
      .then(food => cookExtra(food))
      .then(item => packFood(item))
      .then(box => deliverFood(box))
      .then(() => console.log("Customer: Order completed"))
      .catch(err => console.log("Error happened"));

Benefits:

- Clean chain  
- No nesting  
- Easy error handling  

---

# PART 3 — ASYNC / AWAIT (SMART WAITER STYLE)

---

## Async/Await Restaurant Story

Waiter says:

"I will wait here for food  
But restaurant will NOT stop"

Only THIS order pauses.

Other tables still work.

---

## Async/Await Code Example

Same Promise function:

    function orderFood() {
        return new Promise(resolve => {

            console.log("Waiter: Order sent to kitchen");

            setTimeout(() => {
                console.log("Kitchen: Food ready");
                resolve("Burger");
            }, 2000);

        });
    }

Using async/await:

    async function serveCustomer() {
        try {
            const food = await orderFood();
            console.log("Customer eating:", food);
        } catch (error) {
            console.log("Problem:", error);
        }
    }

    serveCustomer();

---

## What Actually Happens

Important truth:

await does NOT block Node.js.

It only pauses:

serveCustomer() function

Event Loop continues serving others.

---

## Execution Flow

1) serveCustomer() starts  
2) orderFood() sent to kitchen  
3) function pauses at await  
4) Event Loop keeps running  
5) Kitchen finishes  
6) Promise resolves  
7) Function resumes  
8) Customer eats  

Output:

    Waiter: Order sent to kitchen
    Kitchen: Food ready
    Customer eating: Burger

---

# COMPARISON USING SAME RESTAURANT TASK

---

## Same Task — Three Styles

---

### Callback Style

    orderFood(function(food) {
        console.log(food);
    });

Story:

"Call me when ready"

---

### Promise Style

    orderFood()
      .then(food => console.log(food))
      .catch(err => console.log(err));

Story:

"Give me token, notify me later"

---

### Async/Await Style

    async function eat() {
        const food = await orderFood();
        console.log(food);
    }

Story:

"I will wait here, restaurant keeps running"

---

# Error Handling Comparison

---

## Callback Error Handling

    orderFood(function(err, food) {
        if (err) {
            console.log(err);
        } else {
            console.log(food);
        }
    });

Messy and repetitive.

---

## Promise Error Handling

    orderFood()
      .then(food => console.log(food))
      .catch(err => console.log(err));

Cleaner.

---

## Async/Await Error Handling

    try {
        const food = await orderFood();
        console.log(food);
    } catch (err) {
        console.log(err);
    }

Most readable.

---

# Important Performance Truth

Callbacks, Promises, Async/Await:

ALL use:

- Same Event Loop  
- Same async system  
- Same background workers  

Difference is ONLY:

- Syntax  
- Readability  
- Maintainability  

Not speed.

---

# Final Restaurant Memory Trick

Callbacks:

"Call me when food is ready"

Promises:

"Give me token number"

Async/Await:

"I will wait, but restaurant stays open"

---

# Final Developer Summary

Callbacks = Basic foundation  
Promises = Structured async  
Async/Await = Clean professional style  

If you master all three:

- You control async flow  
- You avoid bugs  
- You write clean backend code  
- You understand interviews  
- You become production ready  