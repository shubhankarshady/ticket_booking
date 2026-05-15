

BEGIN;

-- Ensure using public schema
SET search_path TO public;

-- ======================
-- USERS
-- ======================
INSERT INTO users (full_name, email, password_hash, role, phone_number)
VALUES 
('Alice Johnson', 'alice@example.com', 'hashed_password1', 'customer', '9876543210'),
('Bob Smith', 'bob@example.com', 'hashed_password2', 'customer', '9123456780'),
('Admin User', 'admin@example.com', 'hashed_password3', 'admin', '9000000000');

-- ======================
-- MOVIES
-- ======================
INSERT INTO movies (title, genre, language, duration_minutes, rating, release_date)
VALUES
('The Matrix', 'Action', 'English', 136, 8.7, '1999-03-31'),
('Inception', 'Sci-Fi', 'English', 148, 8.8, '2010-07-16'),
('Interstellar', 'Sci-Fi', 'English', 169, 8.6, '2014-11-07');

-- ======================
-- THEATRES
-- ======================
INSERT INTO theatres (theatre_name, city, address, total_screens)
VALUES
('Galaxy Cinema', 'Mumbai', '123 Main Street', 3),
('Starplex', 'Delhi', '45 Central Avenue', 2);

-- ======================
-- SCREENS
-- ======================
INSERT INTO screens (theatre_id, screen_name, total_seats)
VALUES
(1, 'Screen 1', 50),
(1, 'Screen 2', 40),
(1, 'Screen 3', 60),
(2, 'Screen A', 45),
(2, 'Screen B', 50);

-- ======================
-- SEATS (for simplicity, generate seat numbers like A1-A10, B1-B10, etc.)
-- ======================
-- Example: generate 10 seats per row (A-E), 10 rows per screen
DO $$
DECLARE
    scr RECORD;
    i INT;
    num INT;
    row CHAR;
BEGIN
    FOR scr IN SELECT screen_id, total_seats FROM screens LOOP
        FOR i IN 1..5 LOOP  -- rows A to E
            row := CHR(64 + i);  -- convert 1→A, 2→B, etc.
            FOR num IN 1..10 LOOP
                EXIT WHEN ((i - 1) * 10 + num) > scr.total_seats; -- stop if seat limit reached
                INSERT INTO seats (screen_id, seat_number, seat_type)
                VALUES (scr.screen_id, row || num::TEXT, 'standard');
            END LOOP;
        END LOOP;
    END LOOP;
END;
$$;


-- ======================
-- Verification queries (optional)
-- ======================
-- SELECT * FROM users;
-- SELECT * FROM movies;
-- SELECT * FROM theatres;
-- SELECT * FROM screens;
-- SELECT * FROM seats LIMIT 20;


