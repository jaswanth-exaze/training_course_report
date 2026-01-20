const resultsContainer = document.getElementById("resultsContainer");

/* =========================
   HELPERS
   ========================= */
function clearResults(message = "") {
  resultsContainer.innerHTML = message ? message : "";
}

function renderUsers(users) {
  clearResults();

  if (!users.length) {
    clearResults("No records found");
    return;
  }

  users.forEach((user) => {
    const card = document.createElement("div");
    card.className = "employee-card";

    Object.entries(user).forEach(([key, value]) => {
      const field = document.createElement("div");
      field.className = `employee-field ${key}`;

      if (key === "manager_id" && value) {
        field.textContent = `${key}: ${value}`;

        field.innerHTML += `
          <button class="manager-button" onclick="searchManager(${value})">
            ${value}
          </button>
        `;
      } else {
        field.textContent = `${key}: ${value ?? "Employee has no manager"}`;
      }

      card.appendChild(field);
    });

    resultsContainer.appendChild(card);
  });
}

/* =========================
   API CALLS
   ========================= */
function searchByName() {
  const name = document.getElementById("nameSearchInput").value.trim();
  if (name.length < 3) return clearResults("Minimum 3 characters required");

  fetch("http://localhost:3000/api/users/search", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name }),
  })
    .then((res) => res.json())
    .then(renderUsers)
    .catch(() => clearResults("Server error"));
}

function searchById() {
  const id = document.getElementById("idSearchInput").value;
  if (!id) return clearResults("Enter an ID");

  fetch("http://localhost:3000/api/users/id", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ id }),
  })
    .then((res) => res.json())
    .then(renderUsers)
    .catch(() => clearResults("Server error"));
}

function fetchAllEmployees() {
  fetch("http://localhost:3000/api/users")
    .then((res) => res.json())
    .then(renderUsers)
    .catch(() => clearResults("Server error"));
}

function fetchAllSorted() {
  fetch("http://localhost:3000/api/users")
    .then((res) => res.json())
    .then((data) => {
      data.sort((a, b) => a.name.localeCompare(b.name));
      renderUsers(data);
    });
}

function searchManager(id) {
  fetch("http://localhost:3000/api/users/id", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ id }),
  })
    .then((res) => res.json())
    .then(renderUsers);
}
