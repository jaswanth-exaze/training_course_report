const express = require("express");
const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

const router = express.Router();

router.get(
  "/student/dashboard",
  authMiddleware,
  roleMiddleware("student"),
  (req, res) => {
    res.json({
      message: `Welcome ${req.user.name.toUpperCase()}`,
      userId: req.user.id,
      role: req.user.role,
    });
  },
);

module.exports = router;
