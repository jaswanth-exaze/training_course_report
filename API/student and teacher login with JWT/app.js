const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

const PORT = 3000;

const authRoutes = require("./routes/authRoutes");
app.use("/", authRoutes);

const authMiddleware = require("./middleware/authMiddleware");
app.get("/protected", authMiddleware, (req, res) => {
  res.json({
    message: "Protected route accessed",
    user: req.user,
  });
});

const studentRoutes = require("./routes/studentRoutes");
const teacherRoutes = require("./routes/teacherRoutes");

app.use("/", studentRoutes);
app.use("/", teacherRoutes);

app.get("/", (req, res) => {
  res.send("Student-Teacher Auth API running");
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
