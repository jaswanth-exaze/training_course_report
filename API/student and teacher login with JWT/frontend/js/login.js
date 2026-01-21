async function login() {
  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;
  const error = document.getElementById("error");

  error.textContent = "";

  try {
    const response = await fetch("http://localhost:3000/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ email, password })
    });

    const data = await response.json();

    if (!response.ok) {
      error.textContent = data.message;
      return;
    }

    // Save token
    localStorage.setItem("token", data.token);

    // Decode role from token (simple way)
    const payload = JSON.parse(atob(data.token.split(".")[1]));

    if (payload.role === "student") {
      window.location.href = "dashboard.html?role=student";
    } else {
      window.location.href = "dashboard.html?role=teacher";
    }

  } catch (err) {
    error.textContent = "Server error";
  }
}
