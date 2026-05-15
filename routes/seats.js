const express = require("express");
const router = express.Router();
const pool = require("../db/db");

router.get("/:showtimeId", async (req, res) => {
  const { showtimeId } = req.params;

  try {
    // Fetch only seats that are available or reserved (exclude sold)
    const result = await pool.query(
      `SELECT ss.show_seat_id, ss.status, s.seat_number
       FROM show_seats ss
       JOIN seats s ON ss.seat_id = s.seat_id
       WHERE ss.showtime_id = $1 AND ss.status != 'sold'
       ORDER BY s.seat_number`,
      [showtimeId]
    );

    const seats = result.rows;

    res.render("seats", { seats, showtimeId });
  } catch (err) {
    console.error(err);
    res.send("Error fetching seats");
  }
});

module.exports = router;

