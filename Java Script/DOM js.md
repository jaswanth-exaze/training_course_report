# Part 9 – DOM (Document Object Model) – Deep & Enhanced Explanation

------------------------------------------------------------

## 1. What Is the DOM?

The **DOM (Document Object Model)** is a **tree-based, in-memory representation** of your HTML document created by the browser.

When a webpage loads, the browser performs these steps:

1. Parses the HTML file
2. Converts HTML tags into **nodes**
3. Organizes nodes into a **hierarchical tree**
4. Exposes this structure through the **document object**

This allows JavaScript to **read, modify, create, and delete** HTML elements dynamically.

### What the DOM Enables
- Dynamic UI updates without page reload
- Interactive web applications
- Event-driven programming
- Data-driven rendering (React, Angular, Vue all rely on DOM concepts)

### Visual Representation of DOM Tree

```
Document
 └── html
      ├── head
      │    └── title
      └── body
           ├── h1
           ├── p
           ├── img
           └── button
```

Each item above is a **node object**, accessible via JavaScript.

------------------------------------------------------------

## 2. Selecting Elements (DOM Querying)

Before manipulating anything, you must **select elements**.

### 2.1 getElementById()

Selects **one element** by unique id.

```javascript
<script>
let heading = document.getElementById("main-title");
console.log(heading.textContent);
</script>
```

- Fastest selector
- Returns `null` if not found
- IDs must be unique

------------------------------------------------------------

### 2.2 getElementsByClassName()

Selects elements by class name.

```javascript
<script>
let items = document.getElementsByClassName("item");
console.log(items.length);
</script>
```

- Returns **HTMLCollection**
- Live collection (auto-updates when DOM changes)
- Index-based access only

------------------------------------------------------------

### 2.3 getElementsByTagName()

Selects elements by tag.

```javascript
<script>
let paragraphs = document.getElementsByTagName("p");
console.log(paragraphs[0]);
</script>
```

- Returns **HTMLCollection**
- Live collection

------------------------------------------------------------

### 2.4 querySelector() (Modern & Recommended)

Selects the **first matching element** using CSS selectors.

```javascript
<script>
let btn = document.querySelector(".btn.primary");
</script>
```

- Supports all CSS selectors
- Returns single element or `null`

------------------------------------------------------------

### 2.5 querySelectorAll()

Selects **all matching elements**.

```javascript
<script>
let buttons = document.querySelectorAll("button");
buttons.forEach(btn => console.log(btn.textContent));
</script>
```

- Returns **NodeList**
- Static (does not auto-update)
- Supports `forEach`

------------------------------------------------------------

## 3. Reading & Modifying Content

### 3.1 textContent vs innerHTML

```javascript
<script>
let el = document.getElementById("main-title");
el.textContent = "Safe Text Update";
</script>
```

- `textContent`: plain text only (safe)
- `innerHTML`: parses HTML (can cause XSS if misused)

```javascript
<script>
el.innerHTML = "<span>Styled Text</span>";
</script>
```

------------------------------------------------------------

### 3.2 Working with Attributes

```javascript
<script>
let img = document.querySelector("img");
img.setAttribute("src", "photo.jpg");
img.setAttribute("alt", "Profile photo");
</script>
```

Common shortcuts:
```javascript
img.src = "photo.jpg";
img.alt = "Profile photo";
```

------------------------------------------------------------

### 3.3 Styling with JavaScript

```javascript
<script>
let box = document.querySelector(".box");
box.style.backgroundColor = "skyblue";
box.style.padding = "20px";
box.style.borderRadius = "8px";
</script>
```

Note:
- CSS properties use **camelCase**
- Inline styles override CSS files

------------------------------------------------------------

## 4. Creating Elements Dynamically

### 4.1 Creating Elements

```javascript
<script>
let p = document.createElement("p");
p.textContent = "This paragraph was created dynamically.";
</script>
```

At this stage:
- Exists in memory
- Not yet visible

------------------------------------------------------------

### 4.2 Inserting Elements

Append (bottom):
```javascript
<script>
document.body.appendChild(p);
</script>
```

Prepend (top):
```javascript
<script>
document.body.prepend(p);
</script>
```

Before / After:
```javascript
<script>
let ref = document.querySelector(".container");
ref.before(p);
ref.after(p);
</script>
```

------------------------------------------------------------

## 5. Removing & Replacing Elements

### 5.1 Removing Elements

```javascript
<script>
let item = document.querySelector(".item");
item.remove();
</script>
```

Older method:
```javascript
<script>
parent.removeChild(child);
</script>
```

------------------------------------------------------------

### 5.2 Replacing Elements

```javascript
<script>
let oldEl = document.querySelector(".old");
let newEl = document.createElement("div");
newEl.textContent = "New Element";
oldEl.replaceWith(newEl);
</script>
```

------------------------------------------------------------

## 6. DOM Traversing (Navigation)

DOM nodes have relationships.

### Parent
```javascript
<script>
let btn = document.querySelector("button");
console.log(btn.parentElement);
</script>
```

### Children
```javascript
<script>
let list = document.querySelector("ul");
console.log(list.children);
</script>
```

### Siblings
```javascript
<script>
let li = document.querySelector("li");
console.log(li.nextElementSibling);
console.log(li.previousElementSibling);
</script>
```

------------------------------------------------------------

## 7. Events & Event Listeners

Events allow JavaScript to react to user actions.

### 7.1 Click Event

```javascript
<script>
let btn = document.getElementById("save");
btn.addEventListener("click", function() {
  console.log("Button clicked");
});
</script>
```

------------------------------------------------------------

### 7.2 Input Event

```javascript
<script>
let input = document.querySelector("#name");
input.addEventListener("input", function(e) {
  console.log(e.target.value);
});
</script>
```

------------------------------------------------------------

### 7.3 Change Event

```javascript
<script>
let select = document.querySelector("select");
select.addEventListener("change", function(e) {
  console.log(e.target.value);
});
</script>
```

------------------------------------------------------------

## 8. Mini Project: Color Changer

HTML:
```html
<div id="box" style="width:100px;height:100px;background:gray;"></div>
<button id="change">Change Color</button>
```

JavaScript:
```javascript
<script>
let box = document.getElementById("box");
let btn = document.getElementById("change");

btn.addEventListener("click", function() {
  box.style.backgroundColor =
    "rgb(" +
    Math.floor(Math.random()*255) + "," +
    Math.floor(Math.random()*255) + "," +
    Math.floor(Math.random()*255) + ")";
});
</script>
```

------------------------------------------------------------

# Part 10 – Events & Event Handling (Enhanced)

------------------------------------------------------------

## 1. What Are Events?

Events are **signals** that something happened in the browser.

Examples:
- Mouse clicks
- Keyboard input
- Page load
- Form submit
- Scrolling

JavaScript listens to these signals and executes code.

------------------------------------------------------------

## 2. Ways to Handle Events

### Inline (Not Recommended)
```html
<button onclick="alert('clicked')">Click</button>
```

------------------------------------------------------------

### Property Handler
```javascript
<script>
btn.onclick = function() {
  console.log("Clicked");
};
</script>
```

Limitation:
- Only one handler allowed

------------------------------------------------------------

### addEventListener() (Recommended)

```javascript
<script>
btn.addEventListener("click", function() {
  console.log("Clicked");
});
</script>
```

Advantages:
- Multiple listeners
- Cleaner code
- Supports capturing

------------------------------------------------------------

## 3. Event Object

```javascript
<script>
document.addEventListener("click", function(event) {
  console.log(event.target);
  console.log(event.type);
});
</script>
```

------------------------------------------------------------

## 4. Preventing Default Behavior

```javascript
<script>
document.querySelector("a").addEventListener("click", function(e) {
  e.preventDefault();
});
</script>
```

------------------------------------------------------------

## 5. Event Bubbling

Events propagate upward.

Order:
```
target → parent → body → document
```

------------------------------------------------------------

## 6. Event Capturing

Events propagate downward.

```javascript
<script>
document.addEventListener("click", () => {
  console.log("capturing");
}, true);
</script>
```

------------------------------------------------------------

## 7. Event Delegation (Very Important)

```javascript
<script>
let list = document.querySelector("#items");

list.addEventListener("click", function(e) {
  if (e.target.tagName === "LI") {
    console.log(e.target.textContent);
  }
});
</script>
```

Benefits:
- Fewer listeners
- Works for dynamic elements
- Better performance

------------------------------------------------------------

## 8. Form Handling

```javascript
<script>
let form = document.querySelector("form");

form.addEventListener("submit", function(e) {
  e.preventDefault();
  console.log("Form submitted");
});
</script>
```

------------------------------------------------------------

## Practice Tasks

1. Build a todo list using DOM creation
2. Implement delete buttons using event delegation
3. Create a theme toggle (light/dark)
4. Build a counter app
5. Validate form input before submission

------------------------------------------------------------
