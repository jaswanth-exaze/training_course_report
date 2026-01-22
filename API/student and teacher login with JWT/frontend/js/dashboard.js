const token = localStorage.getItem("token");

if (!token) {
  window.location.href = "index.html";
}

const params = new URLSearchParams(window.location.search);
const role = params.get("role");

const title = document.getElementById("title");
const message = document.getElementById("message");

title.textContent = role === "student" ? "Student Dashboard" : "Teacher Dashboard";

const url =
  role === "student"
    ? "http://localhost:3000/student/dashboard"
    : "http://localhost:3000/teacher/dashboard";

fetch(url, {
  headers: {
    "Authorization": "Bearer " + token
  }
})
  .then(res => res.json())
  .then(data => {
    message.textContent = data.message;
    return data.role;
    
  })
//   .then((x)=>{
//     console.log(x)
//     window.location.href = (x=="student"?"Student_demo.html":"Teacher_demo.html")
//   })
  .catch(() => {
    message.textContent = "Access denied";
  });

function logout() {
  localStorage.removeItem("token");
  window.location.href = "index.html";
}
