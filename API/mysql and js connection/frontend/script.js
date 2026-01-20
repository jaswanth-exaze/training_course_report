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

function addEmpFetch() {
  console.log("fetch started");
  const id = document.getElementById("Idinput").value;
  const name = document.getElementById("nameinput").value;
  const email = document.getElementById("emailinput").value;
  const password_hash = document.getElementById("hashInput").value;
  const designation = document.getElementById("designationInput").value;
  const manager_id = document.getElementById("managerInput").value || null;

  fetch("http://localhost:3000/api/users/addemp", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      id,
      name,
      email,
      password_hash,
      designation,
      manager_id,
    }),
  })
    .then(res=>res.json())
    .then((data) => {
      if (data.affectedRows) clearResults("Employee Added Successfully");
    })
    .catch(() => clearResults("Server error"));
}

function addEmployee() {
  console.log("Add Employee Clicked");
  // document.querySelector(".results-section").classList.toggle('hidden')
  // clearResults();
  resultsContainer.innerHTML = `<form class="AddInput controls" onsubmit="addEmpFetch(event)">
  
  <input id="Idinput" type="number" placeholder="Enter id" required>
  
  <input id="nameinput" type="text" placeholder="Enter name required" required>
  
  <input id="emailinput" type="email" placeholder="Enter email required" required>
  
  <input id="hashInput" type="text" placeholder="Enter hash password required" required>
  
  <input id="designationInput" type="text" placeholder="Enter Designation required" required>
  
  <input id="managerInput" type="number" placeholder="Enter Manager Id">
  
  <button onclick="addEmpFetch()" type="submit">Add Employee</button>

</form>
`;
}

function deleteById() {
  const id = document.getElementById("idDeleteInput").value;

  fetch("http://localhost:3000/api/users/deleteById", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ id }),
  }).then(res=>res.json())
    .then((data) => {
      if (data.affectedRows) {clearResults("Employee Deleted Successfully")}
      else {clearResults("Employee ID not fount")}})
    .catch(() => clearResults("Server error"));
}
