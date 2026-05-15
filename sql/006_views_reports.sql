-- ===========================================
-- Migration 006: Create Views & Reports
-- Purpose: Provide read-only views for frontend and admin
-- ===========================================

BEGIN;

-- Ensure using public schema
SET search_path TO public;

-- ======================
-- VIEW: available_movies
-- Purpose: List movies with upcoming showtimes
-- ======================
CREATE OR REPLACE VIEW available_movies AS
SELECT 
    m.movie_id,
    m.title,
    m.genre,
    m.language,
    m.duration_minutes,
    m.rating,
    s.showtime_id,
    s.screen_id,
    s.start_time,
    s.end_time,
    s.price,
    s.status AS show_status
FROM movies m
JOIN showtimes s ON m.movie_id = s.movie_id
WHERE s.status = 'active'
ORDER BY s.start_time;

-- ======================
-- VIEW: available_seats
-- Purpose: List seats available for a specific showtime
-- ======================
CREATE OR REPLACE VIEW available_seats AS
SELECT 
    ss.show_seat_id,
    ss.showtime_id,
    se.seat_id,
    se.seat_number,
    se.seat_type,
    ss.status
FROM show_seats ss
JOIN seats se ON ss.seat_id = se.seat_id;

-- ======================
-- VIEW: user_bookings
-- Purpose: Show bookings for each user with seat details
-- ======================
CREATE OR REPLACE VIEW user_bookings AS
SELECT 
    b.booking_id,
    b.user_id,
    u.full_name,
    b.showtime_id,
    b.total_amount,
    b.status AS booking_status,
    b.booked_at,
    bs.show_seat_id,
    s.seat_number,
    s.seat_type
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN booking_seats bs ON b.booking_id = bs.booking_id
JOIN seats s ON bs.show_seat_id = s.seat_id;

-- ======================
-- VIEW: revenue_report
-- Purpose: Total revenue grouped by movie and showtime
-- ======================
CREATE OR REPLACE VIEW revenue_report AS
SELECT 
    m.movie_id,
    m.title,
    s.showtime_id,
    SUM(bs.seat_price) AS total_revenue,
    COUNT(bs.booking_seat_id) AS seats_sold
FROM movies m
JOIN showtimes s ON m.movie_id = s.movie_id
JOIN bookings b ON s.showtime_id = b.showtime_id AND b.status = 'confirmed'
JOIN booking_seats bs ON b.booking_id = bs.booking_id
GROUP BY m.movie_id, m.title, s.showtime_id
ORDER BY total_revenue DESC;

COMMIT;

-- ======================
-- Verification queries (optional)
-- ======================
-- \dv
-- SELECT * FROM available_movies LIMIT 5;
-- SELECT * FROM available_seats WHERE showtime_id = 1;
-- SELECT * FROM user_bookings WHERE user_id = 1;
-- SELECT * FROM revenue_report;
