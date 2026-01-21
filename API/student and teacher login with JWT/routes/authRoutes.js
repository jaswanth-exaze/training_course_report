const express = require("express");
const bcrypt = require("bcrypt");
const db = require("../db");

const jwt = require("jsonwebtoken");

const router = express.Router();

router.post("/register", async (req, res) => {
  const { name, email, password, role } = req.body;
  // Basic validation
  if (!name || !email || !password || !role) {
    return res.status(400).json({
      message: "All fields are required",
    });
  }

  // Allow only student or teacher
  if (role !== "student" && role !== "teacher") {
    return res.status(400).json({
      message: "Invalid role",
    });
  }

  // Check if user already exists
  const checkQuery = "select * from users where email = ?";

  db.query(checkQuery, [email], async (err, result) => {
    if (err) {
      return res.status(500).json({ message: "Database Eroor" });
    }
    if (result.length > 0) {
      return res.status(400).json({
        message: "User already exists",
      });
    }
  });

  // Hash password
  const hashedPassword = await bcrypt.hash(password, 10);

  // Insert user
  const insertQuery =
    "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";

  db.query(insertQuery, [name, email, hashedPassword, role], (err) => {
    if (err) {
      return res.status(500).json({
        message: "Failed to register user",
      });
    }

    res.status(201).json({
      message: "User registered successfully",
    });
  });
});

//    ====================LOGIN=================== //
router.post("/login",  (req, res) => {
  const { email, password } = req.body;

  //basic validation
  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required" });
  }
  // Check if user exists
  const sql = "SELECT * FROM users WHERE email = ?";
  db.query(sql, [email], (err, result) => {
    if (err) {
      return res.status(500).json({
        message: "Database error",
      });
    }

    if (result.length == 0) {
      return res.status(401).json({
        message: "Invalid email or password",
      });
    }


    const user = result[0];

    //compare password
    const isMatch =  bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        message: "Invalid email or password",
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      {
        id: user.id,
        role: user.role,
      },
      "secretKey",
      {
        expiresIn: "1h",
      },
    );
    res.json({
      message: "Login successful",
      token: token,
    });
  });
});

module.exports = router;
