
-- in project Tickit Booking System 


-- LIST PARTITION on THEATRES (city-wise)

CREATE TABLE theatres (
    theatre_id NUMBER PRIMARY KEY,
    theatre_name VARCHAR2(100),
    city VARCHAR2(50),
    address VARCHAR2(200),
    total_screens NUMBER
)
PARTITION BY LIST(city)
(
    PARTITION p_mumbai VALUES ('Mumbai'),
    PARTITION p_delhi VALUES ('Delhi'),
    PARTITION p_other VALUES (DEFAULT)
);

SELECT * FROM theatres PARTITION(p_mumbai);

SELECT city, AVG(total_screens)
FROM theatres
GROUP BY city;




-- RANGE PARTITION on BOOKINGS

CREATE TABLE bookings (
    booking_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    showtime_id NUMBER,
    total_amount NUMBER(7,2),
    status VARCHAR2(20),
    booked_at DATE
)
PARTITION BY RANGE(booked_at)
(
    PARTITION p1 VALUES LESS THAN (TO_DATE('01-01-2025','DD-MM-YYYY')),
    PARTITION p2 VALUES LESS THAN (TO_DATE('01-07-2025','DD-MM-YYYY')),
    PARTITION p3 VALUES LESS THAN (TO_DATE('01-01-2026','DD-MM-YYYY')),
    PARTITION p4 VALUES LESS THAN (MAXVALUE)
);

SELECT * FROM bookings PARTITION(p1)
UNION
SELECT * FROM bookings PARTITION(p2);

SELECT * FROM bookings PARTITION(p1)
WHERE status='confirmed';

SELECT * FROM bookings
ORDER BY total_amount ASC;




-- HASH PARTITION on PAYMENTS

CREATE TABLE payments (
    payment_id NUMBER PRIMARY KEY,
    booking_id NUMBER,
    payment_method VARCHAR2(20),
    amount NUMBER(7,2),
    status VARCHAR2(20),
    paid_at DATE
)
PARTITION BY HASH(payment_id)
PARTITIONS 4;


SELECT * FROM payments PARTITION(SYS_P2);

SELECT payment_method, amount
FROM payments PARTITION(SYS_P4)
WHERE amount BETWEEN 2000 AND 5000;

SELECT AVG(amount)
FROM payments PARTITION(SYS_P3);

SELECT * FROM USER_TAB_PARTITIONS
WHERE TABLE_NAME='BOOKINGS';

SELECT * FROM USER_TAB_PARTITIONS
WHERE TABLE_NAME='PAYMENTS'; 