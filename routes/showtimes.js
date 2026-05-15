const express = require("express");
const router = express.Router();
const pool = require("../db/db");

router.get("/:movieId", async (req, res) => {
  const { movieId } = req.params;

  try {
    // Fetch showtimes with theater info
    const showtimesResult = await pool.query(
      `SELECT s.showtime_id, s.start_time, s.end_time, s.price, s.status,
              sc.screen_name, t.theatre_name AS theatre_name
       FROM showtimes s
       JOIN screens sc ON s.screen_id = sc.screen_id
       JOIN theatres t ON sc.theatre_id = t.theatre_id
       WHERE s.movie_id = $1
       ORDER BY t.theatre_name, s.start_time`,
      [movieId]
    );

    const showtimes = showtimesResult.rows;

    // Group by theater
    const groupedByTheatre = {};
    showtimes.forEach(st => {
      if (!groupedByTheatre[st.theatre_name]) {
        groupedByTheatre[st.theatre_name] = [];
      }
      groupedByTheatre[st.theatre_name].push(st);
    });

    // Fetch movie title
    const movieResult = await pool.query(
      "SELECT title FROM movies WHERE movie_id = $1",
      [movieId]
    );

    const movieTitle = movieResult.rows[0]?.title || "Unknown Movie";

    res.render("showtimes", { groupedByTheatre, movieTitle });
  } catch (err) {
    console.error(err);
    res.send("Error fetching showtimes");
  }
});

module.exports = router;



