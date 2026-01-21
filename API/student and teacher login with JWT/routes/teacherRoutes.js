const express = require("express");
const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

const router = express.Router();

router.get(
  "/teacher/dashboard",
  authMiddleware,
  roleMiddleware("teacher"),
  (req, res) => {
    res.json({
      message: "Welcome Teacher",
      userId: req.user.id,
    });
  },
);

module.exports = router;
