const express = require("express");
const router = express.Router();
const pool = require("../db/db");
const requireLogin = require("../middleware/auth");

router.post("/", requireLogin, async (req, res) => {
  const { showtime_id } = req.body;
  const user_id = req.session.user.id;
  let seat_ids = req.body.seat_ids;

  // 🔹 Normalize seat_ids (handle JSON string, array, or single value)
  let seatIds = [];
  if (Array.isArray(seat_ids)) {
    seatIds = seat_ids.map(id => parseInt(id)).filter(Boolean);
  } else if (typeof seat_ids === "string" && seat_ids.trim() !== "") {
    try {
      const parsed = JSON.parse(seat_ids);
      seatIds = Array.isArray(parsed)
        ? parsed.map(id => parseInt(id)).filter(Boolean)
        : [parseInt(parsed)];
    } catch {
      seatIds = [parseInt(seat_ids)];
    }
  }

  if (!seatIds.length) {
    return res.status(400).send("No seats selected");
  }

  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    // 1️⃣ Create booking
    const bookingResult = await client.query(
      `INSERT INTO bookings (user_id, showtime_id, total_amount, status, booked_at)
       VALUES ($1, $2, 0, 'confirmed', NOW())
       RETURNING booking_id`,
      [user_id, showtime_id]
    );
    const booking_id = bookingResult.rows[0].booking_id;

    // 2️⃣ Process each seat
    for (const seat_id of seatIds) {
      const showSeatResult = await client.query(
  `SELECT show_seat_id, status 
   FROM show_seats 
   WHERE show_seat_id = $1 
   FOR UPDATE`,
  [seat_id] // seat_id now actually holds show_seat_id from frontend
);


      if (!showSeatResult.rows.length)
        throw new Error(`Seat ${seat_id} not found`);
      const showSeat = showSeatResult.rows[0];

      if (showSeat.status === "sold")
        throw new Error(`Seat ${seat_id} already sold`);

      // Mark sold
      await client.query(
        `UPDATE show_seats SET status = 'sold' WHERE show_seat_id = $1`,
        [showSeat.show_seat_id]
      );

      // Record booking seat
      await client.query(
        `INSERT INTO booking_seats (booking_id, show_seat_id, seat_price)
         VALUES ($1, $2, 200)`,
        [booking_id, showSeat.show_seat_id]
      );
    }

    await client.query("COMMIT");
    res.redirect("/users/history");
  } catch (err) {
    await client.query("ROLLBACK");
    console.error("Error booking seats:", err.message);
    res.status(500).send("Error booking seats: " + err.message);
  } finally {
    client.release();
  }
});

module.exports = router;
