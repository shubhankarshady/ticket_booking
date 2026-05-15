
SELECT * FROM available_movies;

-- ======================
-- 2. Check all available seats for a specific showtime
-- Replace showtime_id = 1 with your test showtime
-- ======================
SELECT *
FROM available_seats
WHERE showtime_id = 1
  AND status = 'available'
ORDER BY seat_number;

-- ======================
-- 3. Check all bookings for a specific user
-- Replace user_id = 1 with your test user
-- ======================
SELECT *
FROM user_bookings
WHERE user_id = 1;

-- ======================
-- 4. Check total revenue per movie/showtime
-- ======================
SELECT *
FROM revenue_report
ORDER BY total_revenue DESC;

-- ======================
-- 5. Example: Book tickets using the function (for testing)
-- ======================
-- SELECT book_tickets(1, 1, ARRAY[1,2,3]);

-- ======================
-- 6. Verify show_seats status after booking
-- ======================
-- SELECT * FROM show_seats WHERE showtime_id = 1 ORDER BY seat_id;

-- ======================
-- 7. Cancel a booking (for testing triggers)
-- ======================
-- DELETE FROM booking_seats WHERE booking_id = 1;
-- DELETE FROM bookings WHERE booking_id = 1;

-- ======================
-- 8. Verify seats are reverted to available after cancellation
-- ======================
-- SELECT * FROM show_seats WHERE showtime_id = 1 AND status = 'available';
