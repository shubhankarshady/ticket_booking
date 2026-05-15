-- ===========================================
-- Migration 001: Create Core Tables
-- Purpose: Defines core entities - users, movies, theatres, screens, seats
-- ===========================================

BEGIN;

-- Ensure using the correct schema
SET search_path TO public;

-- ======================
-- USERS TABLE
-- ======================
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(200) NOT NULL,
    phone_number VARCHAR(15),
    role VARCHAR(20) DEFAULT 'customer' CHECK (role IN ('customer', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================
-- MOVIES TABLE
-- ======================
CREATE TABLE IF NOT EXISTS movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    genre VARCHAR(50),
    language VARCHAR(50),
    duration_minutes INT CHECK (duration_minutes > 0),
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 10),
    release_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================
-- THEATRES TABLE
-- ======================
CREATE TABLE IF NOT EXISTS theatres (
    theatre_id SERIAL PRIMARY KEY,
    theatre_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address TEXT,
    total_screens INT CHECK (total_screens > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================
-- SCREENS TABLE
-- ======================
CREATE TABLE IF NOT EXISTS screens (
    screen_id SERIAL PRIMARY KEY,
    theatre_id INT NOT NULL REFERENCES theatres(theatre_id) ON DELETE CASCADE,
    screen_name VARCHAR(50) NOT NULL,
    total_seats INT CHECK (total_seats > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ======================
-- SEATS TABLE
-- ======================
CREATE TABLE IF NOT EXISTS seats (
    seat_id SERIAL PRIMARY KEY,
    screen_id INT NOT NULL REFERENCES screens(screen_id) ON DELETE CASCADE,
    seat_number VARCHAR(10) NOT NULL,
    seat_type VARCHAR(20) DEFAULT 'standard' CHECK (seat_type IN ('standard', 'premium', 'vip')),
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (screen_id, seat_number)
);

COMMIT;

-- ======================
-- Verification queries (optional, comment out after testing)
-- ======================
-- \dt
-- SELECT * FROM users LIMIT 1;
-- SELECT * FROM movies LIMIT 1;
