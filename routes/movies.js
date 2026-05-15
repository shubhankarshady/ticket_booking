const express = require("express");
const router = express.Router();
const pool = require("../db/db");


router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM movies");
    const movies = result.rows;
     res.render("index", { movies });
  } catch (err) {
    console.error(err);
    res.send("Error fetching movies");
  }
});

module.exports = router;
