# Summary Table: When to Use Array, Object, Set, Map, String

---

## 1. Purpose & When to Use

| Data Type  | When Should You Use It?                                  | Best For                                   |
| ---------- | -------------------------------------------------------- | ------------------------------------------ |
| **Array**  | When you need ordered, indexed values                    | Lists, sequences, loops, collections       |
| **Object** | When you need key–value pairs with known property names  | User profiles, configs, structured data    |
| **Set**    | When you need unique values with no duplicates           | Removing duplicates, fast existence checks |
| **Map**    | When you need key–value pairs where keys can be any type | Caches, lookup tables, dynamic keys        |
| **String** | When working with text data                              | Names, messages, labels                    |

---

## 2. Where Each Type is Best (Practical Use Cases)

| Data Type  | Where to Use                                    | Why                                                             |
| ---------- | ----------------------------------------------- | --------------------------------------------------------------- |
| **Array**  | Ordered data, lists, results, collections       | Fast iteration, index access, map/filter/reduce                 |
| **Object** | Fixed structured data representing an entity    | Easy to access by named properties                              |
| **Set**    | Fast checking of existence, removing duplicates | No duplicates, O(1) lookup                                      |
| **Map**    | Dynamic keys, storing computed results, caching | Keys can be objects, ordered, better than objects for key-value |
| **String** | Any form of textual data                        | Immutable & efficient for text processing                       |

---

## 3. Real-Time Examples (One for Each)

### Array – real-time example

Storing items in a shopping cart:

```javascript
let cart = ["milk", "bread", "eggs"];
```

### Object – real-time example

User profile in an application:

```javascript
let user = { name: "Jaswanth", age: 22, city: "Hyderabad" };
```

### Set – real-time example

Removing duplicate values:

```javascript
let ids = new Set([101, 102, 102, 103]);
```

### Map – real-time example

Caching computed results:

```javascript
let squareCache = new Map();
squareCache.set(4, 16);
squareCache.set(5, 25);
```

### String – real-time example

Storing text:

```javascript
let msg = "Welcome to the dashboard";
```

---

## 4. One-View Quick Summary

| Type   | Ordered?              | Unique?        | Key–Value?         | Best Purpose             |
| ------ | --------------------- | -------------- | ------------------ | ------------------------ |
| Array  | Yes                   | No             | No                 | Lists, iteration         |
| Object | No                    | No             | Yes (string keys)  | Entity representation    |
| Set    | Yes (insertion order) | Yes            | No                 | Unique collections       |
| Map    | Yes                   | No             | Yes (any key type) | Flexible key-value store |
| String | Yes                   | Not applicable | Not applicable     | Text handling            |

---

# Final Quick Notes

- Use **Array** for lists
- Use **Object** for structured data
- Use **Set** for unique items
- Use **Map** for advanced key-value lookups
- Use **String** for all text processing
