const express = require("express");
const router = express.Router();
const pool = require("../db/db");

// ===== Admin Dashboard =====
router.get("/", async (req, res) => {
  try {
    const movies = await pool.query("SELECT * FROM movies ORDER BY movie_id DESC");
    res.render("admin", { movies: movies.rows });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error loading admin panel");
  }
});

// ===== Add Movie =====
router.post("/movies/add", async (req, res) => {
  const { title, genre, duration_minutes, language } = req.body;
  try {
    await pool.query(
      "INSERT INTO movies (title, genre, duration_minutes, language) VALUES ($1, $2, $3, $4)",
      [title, genre, duration_minutes, language]
    );
    res.redirect("/admin");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error adding movie");
  }
});

// ===== Delete Movie =====
router.post("/movies/:id/delete", async (req, res) => {
  try {
    await pool.query("DELETE FROM movies WHERE movie_id = $1", [req.params.id]);
    res.redirect("/admin");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error deleting movie");
  }
});

// ===== View Showtimes for a Movie =====
router.get("/movies/:id/showtimes", async (req, res) => {
  const { id } = req.params;
  try {
    const movie = await pool.query("SELECT * FROM movies WHERE movie_id = $1", [id]);
    const showtimes = await pool.query(
      "SELECT * FROM showtimes WHERE movie_id = $1 ORDER BY start_time",
      [id]
    );
    res.render("admin_showtimes", { movie: movie.rows[0], showtimes: showtimes.rows });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error loading showtimes");
  }
});

// ===== Add Showtime =====
router.post("/movies/:id/showtimes/add", async (req, res) => {
  const { id } = req.params;
  const { screen_id, start_time, end_time, price } = req.body;

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    // 1️⃣ Create the showtime
    const showtimeRes = await client.query(
      `INSERT INTO showtimes (movie_id, screen_id, start_time, end_time, price)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING showtime_id`,
      [id, screen_id, start_time, end_time, price || 200]
    );

    const showtimeId = showtimeRes.rows[0].showtime_id;

    // 2️⃣ Get all seat_ids for that screen
    const seatRes = await client.query(
      `SELECT seat_id FROM seats WHERE screen_id = $1`,
      [screen_id]
    );

    if (seatRes.rows.length === 0) {
      throw new Error(`No seats found for screen_id ${screen_id}`);
    }

    // 3️⃣ Create show_seat entries for each seat
    for (const seat of seatRes.rows) {
      await client.query(
        `INSERT INTO show_seats (showtime_id, seat_id, status)
         VALUES ($1, $2, 'available')`,
        [showtimeId, seat.seat_id]
      );
    }

    await client.query("COMMIT");
    console.log(`✅ Created showtime ${showtimeId} with ${seatRes.rows.length} seats`);
    res.redirect(`/admin/movies/${id}/showtimes`);
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("❌ Error adding showtime:", err);
    res.status(500).send("Error adding showtime");
  } finally {
    client.release();
  }
});


// ===== Delete Showtime =====
router.post("/showtimes/:id/delete", async (req, res) => {
  try {
    await pool.query("DELETE FROM showtimes WHERE showtime_id = $1", [req.params.id]);
    res.redirect("/admin");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error deleting showtime");
  }
});

module.exports = router;
