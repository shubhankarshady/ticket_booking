

BEGIN;

-- Ensure using public schema
SET search_path TO public;


CREATE TABLE IF NOT EXISTS bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    showtime_id INT NOT NULL REFERENCES showtimes(showtime_id) ON DELETE CASCADE,
    total_amount DECIMAL(7,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(20) DEFAULT 'confirmed' CHECK (status IN ('confirmed','cancelled')),
    booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS booking_seats (
    booking_seat_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    show_seat_id INT NOT NULL REFERENCES show_seats(show_seat_id) ON DELETE CASCADE,
    seat_price DECIMAL(7,2) NOT NULL CHECK (seat_price >= 0),
    UNIQUE (booking_id, show_seat_id)
);

COMMIT;

