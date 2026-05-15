const express = require("express");
const path = require("path");
const session = require("express-session");
require("dotenv").config();

const pool = require("./db/db");

// Import routes
const usersRoutes = require("./routes/users");
const moviesRoutes = require("./routes/movies");
const showtimesRoutes = require("./routes/showtimes");
const seatsRoutes = require("./routes/seats");
const bookingsRoutes = require("./routes/bookings");
const adminRoutes = require("./routes/admin");
const app = express();
const PORT = process.env.PORT || 3000;

// ===== MIDDLEWARES =====
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

app.use(
  session({
    secret: process.env.SESSION_SECRET || "supersecretkey",
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false }, // set to true for HTTPS
  })
);

// ===== VIEW ENGINE =====
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use("/admin", adminRoutes);
// ===== ROUTES =====
app.use("/users", usersRoutes);
app.use("/movies", moviesRoutes);
app.use("/showtimes", showtimesRoutes);
app.use("/seats", seatsRoutes);
app.use("/bookings", bookingsRoutes);

app.get("/", (req, res) => {
  res.redirect("/movies");
});
// ===== 404 fallback =====
app.use((req, res) => {
  res.status(404).send("404 - Page Not Found");
});

// ===== SERVER START =====
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
