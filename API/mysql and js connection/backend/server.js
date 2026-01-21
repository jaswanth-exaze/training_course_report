const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const db = require("./db");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

/* =========================
   SEARCH BY NAME
   ========================= */
app.post("/api/users/search", (req, res) => {
  const { name } = req.body;
  const sql = `SELECT * FROM users WHERE LOWER(name) LIKE LOWER(?)`;

  db.query(sql, [`%${name}%`], (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

/* =========================
   SEARCH BY ID
   ========================= */
app.post("/api/users/id", (req, res) => {
  const { id } = req.body;
  const sql = `SELECT * FROM users WHERE id = ?`;

  db.query(sql, [id], (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

/* =========================
   FETCH ALL USERS
   ========================= */
app.get("/api/users", (req, res) => {
  const sql = `SELECT * FROM users`;

  db.query(sql, (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

app.post("/api/users/addemp", (req, res) => {
  const { id } = req.body;
  const { name } = req.body;
  const { email } = req.body;
  const { password_hash } = req.body;
  const { manager_id } = req.body;
  const { designation } = req.body;
  const sql = `insert into users(id,name,email,password_hash,designation,manager_id)values(${id},'${name}','${email}','${password_hash}','${designation}',${manager_id})`;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

app.delete("/api/users/deleteById", (req, res) => {
  const { id } = req.body;

  const sql = `delete from users where id=${id}`;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json(err);
    res.json(results);
  });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
