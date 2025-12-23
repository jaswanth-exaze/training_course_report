# Constructor Functions, Prototypes, and Object Creation in JavaScript  
(Deep Step-by-Step Explanation)

------------------------------------------------------------
## The Code

```javascript
const Person = function (firstName, birthYear) {
  this.firstName = firstName;
  this.birthYear = birthYear; 
};

const jk = new Person('jaswanth', 2001);

Person.prototype.calcAge = function () {
  console.log(2025 - this.birthYear);
};

jk.calcAge();
```

------------------------------------------------------------
## 1. What This Code Is Demonstrating (Big Picture)

This code shows **how JavaScript creates objects before ES6 classes** using:

- Constructor functions
- The `new` keyword
- Prototypes
- Prototype inheritance

Important:
- JavaScript is **prototype-based**, not class-based
- Classes in JS are just **syntactic sugar** over this mechanism

------------------------------------------------------------
## 2. The Constructor Function

```javascript
const Person = function (firstName, birthYear) {
  this.firstName = firstName;
  this.birthYear = birthYear; 
};
```

### What is a constructor function?
- A **regular function**
- Used to create multiple similar objects
- By convention, starts with a **capital letter**

### What does `this` mean here?
- `this` does NOT point to anything yet
- Its value is determined **only when the function is called with `new`**

This function defines:
- Properties that every `Person` object should have

------------------------------------------------------------
## 3. What Happens When `new Person('jk', 2001)` Runs

```javascript
const jk = new Person('jaswanth', 2001);
```

This single line triggers **4 internal steps**.

------------------------------------------------------------
### Step 1: A New Empty Object Is Created

Internally:
```javascript
{}
```

------------------------------------------------------------
### Step 2: `this` Is Set to the New Object

Inside the constructor:
```javascript
this === {}
```

------------------------------------------------------------
### Step 3: Constructor Function Executes

```javascript
this.firstName = firstName;
this.birthYear = birthYear;
```

After execution, the object becomes:
```javascript
{
  firstName: "jaswanth",
  birthYear: 2001
}
```

------------------------------------------------------------
### Step 4: Prototype Linking

JavaScript automatically sets:

```javascript
jk.__proto__ === Person.prototype
```

This is **the most important step**.

Now the object:
- Does NOT copy methods
- Instead, it **links** to `Person.prototype`

------------------------------------------------------------
## 4. The Resulting Object in Memory

```javascript
jk = {
  firstName: "jaswanth",
  birthYear: 2001
}
```

Hidden internal link:
```javascript
jk → [[Prototype]] → Person.prototype
```

------------------------------------------------------------
## 5. Adding a Method Using Prototype

```javascript
Person.prototype.calcAge = function () {
  console.log(2025 - this.birthYear);
};
```

### Why prototype?
If we put this inside the constructor:
- Every object gets its **own copy** (memory waste)

Using prototype:
- One shared method
- All instances can access it

------------------------------------------------------------
## 6. What `Person.prototype` Is

```javascript
Person.prototype = {
  constructor: Person,
  calcAge: function() { ... }
}
```

This object:
- Is shared by all instances
- Acts like a **method repository**

------------------------------------------------------------
## 7. Calling the Method

```javascript
jk.calcAge();
```

### How JavaScript Resolves This Call

1. Look inside `jk` object  
   → `calcAge` ❌ not found

2. Look inside `jk.__proto__`  
   → `Person.prototype.calcAge` ✅ found

3. Execute the function with:
```javascript
this === jk
```

------------------------------------------------------------
## 8. Method Execution

```javascript
console.log(2025 - this.birthYear);
```

Since:
```javascript
this === jk
this.birthYear === 2001
```

Result:
```
24
```

------------------------------------------------------------
## 9. Prototype Chain Visualization

```
jk
 ├─ firstName
 ├─ birthYear
 └─ [[Prototype]] ──► Person.prototype
                        ├─ calcAge()
                        └─ constructor
                              │
                              ▼
                        Function Person
                              │
                              ▼
                        Object.prototype
                              │
                              ▼
                            null
```

------------------------------------------------------------
## 10. How This Relates to Classes

This constructor-prototype pattern is **exactly what classes do internally**.

Equivalent ES6 class:

```javascript
class Person {
  constructor(firstName, birthYear) {
    this.firstName = firstName;
    this.birthYear = birthYear;
  }

  calcAge() {
    console.log(2025 - this.birthYear);
  }
}
```

Internally:
- Methods still go to `Person.prototype`
- `new` still works the same
- No real classes exist behind the scenes

------------------------------------------------------------
## 11. Key Takeaways (Very Important)

- JavaScript objects are created via **constructor functions**
- `new` does FOUR things:
  1. Creates empty object
  2. Binds `this`
  3. Executes constructor
  4. Links prototype
- Methods live on **prototype**, not inside objects
- Prototype lookup happens automatically
- ES6 classes are just cleaner syntax for this system

------------------------------------------------------------
## Mental Model (One Line)

**Objects do not copy methods — they delegate method lookup through the prototype chain**

------------------------------------------------------------

