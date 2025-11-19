# 📘 COMPLETE HTML COURSE REPORT  
### Beginner-Friendly • Well Structured • Clear Explanations • HTML Only

---

## 1. Introduction to HTML
### 1.1 What is HTML?
HTML (HyperText Markup Language) is the standard language used to create **web pages**.  
It defines the **structure** of a webpage using tags like headings, paragraphs, links, images, forms, tables, etc.

### 1.2 Why HTML?
- It's the **foundation** of web development  
- All websites rely on HTML  
- Easy to learn  
- Works in all browsers  

### 1.3 How HTML Works
The browser reads HTML, interprets tags, and displays content.

---

## 2. Structure of an HTML Document
### 2.1 Basic Template
```html
<!DOCTYPE html>
<html>
<head>
    <title>My Webpage</title>
</head>
<body>
    <h1>Hello World</h1>
</body>
</html>
```

### 2.2 Explanation
- `<!DOCTYPE html>` → tells browser this is HTML5  
- `<html>` → root element  
- `<head>` → metadata (title, links, scripts)  
- `<body>` → content visible to users  

---

## 3. HTML Elements, Tags & Attributes
### 3.1 Elements
An element includes an opening tag, content, and closing tag.  
Example:
```html
<p>This is a paragraph.</p>
```

### 3.2 Attributes
Attributes give extra information to an element.
```html
<img src="image.jpg" alt="Description">
```

### 3.3 Self-Closing Tags
Some tags do not need a closing tag:  
`<br>`, `<img>`, `<hr>`, `<input>`

---

## 4. HTML Headings & Paragraphs
### 4.1 Headings
HTML provides 6 heading levels:
```html
<h1>Main Heading</h1>
<h2>Sub Heading</h2>
<h6>Smallest Heading</h6>
```

### 4.2 Paragraphs
```html
<p>This is a paragraph of text.</p>
```

### 4.3 Line Breaks & Horizontal Lines
```html
<br>  <!-- line break -->
<hr>  <!-- horizontal rule -->
```

### 4.4 Theory
- Headings should follow a **hierarchy**  
- Paragraphs help divide content into readable blocks  

---

## 5. Text Formatting
### 5.1 Bold, Italic, Underline
```html
<b>Bold</b>
<i>Italic</i>
<u>Underline</u>
```

### 5.2 Semantic Formatting
```html
<strong>Important text</strong>
<em>Emphasized text</em>
```

### 5.3 Quotes & Code
```html
<blockquote>Large quotation</blockquote>
<q>Small quote</q>
<code>inline code</code>
```

---

## 6. Links & Navigation
### 6.1 Basic Link
```html
<a href="https://google.com">Visit Google</a>
```

### 6.2 Open Link in New Tab
```html
<a href="https://google.com" target="_blank">Open in new tab</a>
```

### 6.3 Internal Page Linking
```html
<a href="#section1">Go to Section 1</a>
```

### 6.4 Link to Email or Phone
```html
<a href="mailto:test@example.com">Email</a>
<a href="tel:+123456789">Call</a>
```

### Theory
- Links connect webpages  
- Anchor tag is the navigator of the internet  

---

## 7. Images & Multimedia
### 7.1 Adding an Image
```html
<img src="photo.jpg" alt="My Photo" width="300">
```

### 7.2 Adding Audio
```html
<audio controls>
    <source src="song.mp3">
</audio>
```

### 7.3 Adding Video
```html
<video controls width="400">
    <source src="video.mp4">
</video>
```

### Theory
- Always use **alt** text for accessibility  
- Media elements enhance user experience  

---

## 8. Lists in HTML
### 8.1 Ordered List
```html
<ol>
    <li>First item</li>
    <li>Second item</li>
</ol>
```

### 8.2 Unordered List
```html
<ul>
    <li>Bullet item</li>
</ul>
```

### 8.3 Definition List
```html
<dl>
    <dt>CPU</dt>
    <dd>Central Processing Unit</dd>
</dl>
```

### Theory
- Lists help organize data  
- OL for steps, UL for points, DL for definitions  

---

## 9. HTML Tables
### 9.1 Basic Table
```html
<table border="1">
    <tr>
        <th>Name</th>
        <th>Age</th>
    </tr>
    <tr>
        <td>John</td>
        <td>23</td>
    </tr>
</table>
```

### 9.2 Merging Cells
```html
<td colspan="2">Merged Cell</td>
```

### 9.3 Table Sections
- `<thead>` → header  
- `<tbody>` → body  
- `<tfoot>` → footer  

### Theory
Tables are best suited for **tabular data** like reports, schedules, charts.

---

## 10. HTML Forms (Very Important)
### 10.1 Basic Form
```html
<form action="/submit">
    <input type="text" placeholder="Enter name">
    <button>Submit</button>
</form>
```

### 10.2 Input Types
```html
<input type="email">
<input type="password">
<input type="number">
<input type="file">
<input type="checkbox">
<input type="radio">
```

### 10.3 Labels
```html
<label for="user">Name:</label>
<input id="user" type="text">
```

### 10.4 Select & Textarea
```html
<select>
    <option>Option 1</option>
</select>

<textarea rows="4"></textarea>
```

### Theory
Forms collect data from users (login, signup, surveys, search).

---

## 11. Semantic HTML (Modern & Important)
### What is Semantic HTML?
Tags that clearly describe their meaning.

### 11.1 Common Semantic Tags
```html
<header></header>
<nav></nav>
<section></section>
<article></article>
<footer></footer>
<aside></aside>
<main></main>
```

### Why Use Semantics?
- Better for SEO  
- Accessible for screen readers  
- Clean code structure  

---

## 12. HTML5 APIs (Intro Only)
### 12.1 Audio & Video  
Built-in multimedia support — no plugins needed.

### 12.2 Geolocation Example
```html
<script>
navigator.geolocation.getCurrentPosition(x => console.log(x));
</script>
```

### 12.3 Local Storage
```html
<script>
localStorage.setItem("name", "John");
</script>
```

### Theory
HTML5 introduced powerful APIs used in modern web apps.

---

## 13. Iframes (Embedding)
### 13.1 Embed Website
```html
<iframe src="https://example.com" width="500" height="300"></iframe>
```

### 13.2 Embed YouTube Video
```html
<iframe src="https://www.youtube.com/embed/xyz"></iframe>
```

### Theory
Iframes allow embedding external content into your webpage.

---

## 14. File Structure & Project Organization
### 14.1 Common Folder Structure
```
project/
 ├── index.html
 ├── about.html
 └── assets/
      ├── images/
      ├── audio/
      └── video/
```

### 14.2 Tips for Clean HTML
- Use semantic tags  
- Add alt text for images  
- Keep indentation clean  
- Use comments `<!-- -->`  

---

## 15. HTML Best Practices (Final Topic)
### 15.1 Clean Coding Rules
- Use lowercase tags  
- Close all tags properly  
- Use meaningful file names  
- Avoid unnecessary nesting  
- Validate HTML using w3 validator  

### 15.2 Accessibility Tips
- Use `alt` for images  
- Use labels for form inputs  
- Use headings in correct hierarchy  

---

