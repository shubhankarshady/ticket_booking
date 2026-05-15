
BEGIN;

-- Ensure using public schema
SET search_path TO public;

CREATE OR REPLACE FUNCTION update_show_seat_status()
RETURNS TRIGGER AS $$
BEGIN
    -- When a seat is booked, mark it as sold
    IF TG_OP = 'INSERT' THEN
        UPDATE show_seats
        SET status = 'sold', last_updated = CURRENT_TIMESTAMP
        WHERE show_seat_id = NEW.show_seat_id;
    END IF;

    -- When a booking_seat is deleted (cancellation), mark it as available
    IF TG_OP = 'DELETE' THEN
        UPDATE show_seats
        SET status = 'available', last_updated = CURRENT_TIMESTAMP
        WHERE show_seat_id = OLD.show_seat_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ======================
-- TRIGGER: on booking_seats
-- ======================
CREATE TRIGGER trg_update_seat_status
AFTER INSERT OR DELETE ON booking_seats
FOR EACH ROW
EXECUTE FUNCTION update_show_seat_status();

-- ======================
-- FUNCTION: book_tickets
-- Purpose: Book multiple seats in a single transaction
-- ======================
CREATE OR REPLACE FUNCTION book_tickets(
    p_user_id INT,
    p_showtime_id INT,
    p_seat_ids INT[]
)
RETURNS INT AS $$
DECLARE
    v_booking_id INT;
    v_seat_id INT;
    v_price DECIMAL(7,2);
BEGIN
    
    INSERT INTO bookings(user_id, showtime_id, total_amount)
    VALUES (p_user_id, p_showtime_id, 0)
    RETURNING booking_id INTO v_booking_id;

    -- Loop through each seat to reserve
    FOREACH v_seat_id IN ARRAY p_seat_ids LOOP
        -- Lock the row to avoid race conditions
        PERFORM 1 FROM show_seats
        WHERE showtime_id = p_showtime_id AND show_seat_id = v_seat_id AND status = 'available'
        FOR UPDATE;

        -- Get seat price from showtime
        SELECT price INTO v_price FROM showtimes WHERE showtime_id = p_showtime_id;

        -- Insert into booking_seats
        INSERT INTO booking_seats(booking_id, show_seat_id, seat_price)
        VALUES (v_booking_id, v_seat_id, v_price);
    END LOOP;

    -- Update total_amount in bookings
    UPDATE bookings
    SET total_amount = (SELECT SUM(seat_price) FROM booking_seats WHERE booking_id = v_booking_id)
    WHERE booking_id = v_booking_id;

    RETURN v_booking_id;
END;
$$ LANGUAGE plpgsql;

COMMIT;


