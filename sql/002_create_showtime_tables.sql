
BEGIN;

-- Ensure using public schema
SET search_path TO public;

-- ======================
-- SHOWTIMES TABLE
-- ======================
CREATE TABLE IF NOT EXISTS showtimes (
    showtime_id SERIAL PRIMARY KEY,
    movie_id INT NOT NULL REFERENCES movies(movie_id) ON DELETE CASCADE,
    screen_id INT NOT NULL REFERENCES screens(screen_id) ON DELETE CASCADE,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    price DECIMAL(7,2) NOT NULL CHECK (price >= 0),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (screen_id, start_time)  -- prevents overlapping shows in same screen
);


CREATE TABLE IF NOT EXISTS show_seats (
    show_seat_id SERIAL PRIMARY KEY,
    showtime_id INT NOT NULL REFERENCES showtimes(showtime_id) ON DELETE CASCADE,
    seat_id INT NOT NULL REFERENCES seats(seat_id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available','reserved','sold')),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (showtime_id, seat_id)
);

COMMIT;


