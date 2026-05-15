-- ===========================================
-- Migration 010: Cleanup / Reset Database
-- Purpose: Drop all tables, views, functions, and triggers
-- ===========================================

BEGIN;

-- Ensure using public schema
SET search_path TO public;

-- ======================
-- Drop triggers first
-- ======================
DROP TRIGGER IF EXISTS trg_update_seat_status ON booking_seats;

-- ======================
-- Drop functions
-- ======================
DROP FUNCTION IF EXISTS update_show_seat_status() CASCADE;
DROP FUNCTION IF EXISTS book_tickets(INT, INT, INT[]) CASCADE;

-- ======================
-- Drop views
-- ======================
DROP VIEW IF EXISTS revenue_report CASCADE;
DROP VIEW IF EXISTS user_bookings CASCADE;
DROP VIEW IF EXISTS available_seats CASCADE;
DROP VIEW IF EXISTS available_movies CASCADE;

-- ======================
-- Drop tables (in order to avoid FK errors)
-- ======================
DROP TABLE IF EXISTS booking_seats CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS show_seats CASCADE;
DROP TABLE IF EXISTS showtimes CASCADE;
DROP TABLE IF EXISTS seats CASCADE;
DROP TABLE IF EXISTS screens CASCADE;
DROP TABLE IF EXISTS theatres CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS users CASCADE;

COMMIT;

-- ======================
-- Optional: Reset sequences (if needed)
-- ======================
-- ALTER SEQUENCE users_user_id_seq RESTART WITH 1;
-- ALTER SEQUENCE movies_movie_id_seq RESTART WITH 1;
