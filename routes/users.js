const express = require("express");

const router = express.Router();
const bcrypt = require("bcrypt");
const pool = require("../db/db");
const requireLogin = require("../middleware/auth");

// ===== Register Page =====
router.get("/register", (req, res) => {
  res.render("register");
});

// ===== Register POST =====
router.post("/register", async (req, res) => {
  const { full_name, email, password, phone_number } = req.body;
  if (!full_name || !email || !password)
    return res.status(400).send("All fields are required");

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    await pool.query(
      "INSERT INTO users (full_name, email, password_hash, phone_number) VALUES ($1, $2, $3, $4)",
      [full_name, email, hashedPassword, phone_number]
    );
    res.redirect("/users/login");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error registering user");
  }
});

// ===== Login Page =====
router.get("/login", (req, res) => {
  res.render("login");
});

// ===== Login POST =====
router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).send("Email and password required");

  try {
    const result = await pool.query("SELECT * FROM users WHERE email = $1", [email]);
    if (result.rows.length === 0) return res.status(401).send("Invalid credentials");

    const user = result.rows[0];
    const validPassword = await bcrypt.compare(password, user.password_hash);
    if (!validPassword) return res.status(401).send("Invalid credentials");

    req.session.user = {
      id: user.user_id,
      name: user.full_name,
      role: user.role,
    };

    res.redirect("/movies");
  } catch (err) {
    console.error(err);
    res.status(500).send("Server error");
  }
});

// ===== Logout =====
router.get("/logout", (req, res) => {
  req.session.destroy(err => {
    if (err) return res.status(500).send("Logout failed");
    res.redirect("/users/login");
  });
});

// ===== Dashboard =====
router.get("/dashboard", requireLogin, (req, res) => {
  res.render("dashboard", { user: req.session.user });
});

// ===== Booking History =====
router.get("/history", requireLogin, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT 
         b.booking_id,
         b.total_amount,
         b.status AS booking_status,
         b.booked_at,
         m.title AS movie_title,
         sh.start_time
       FROM bookings b
       JOIN showtimes sh ON b.showtime_id = sh.showtime_id
       JOIN movies m ON sh.movie_id = m.movie_id
       WHERE b.user_id = $1
       ORDER BY b.booked_at DESC`,
      [req.session.user.id]
    );

    res.render("history", { user: req.session.user, bookings: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error loading history");
  }
});




module.exports = router;
