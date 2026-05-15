
-- Inheritance used for 

-- users → parent object type
-- customer_users → child object type
-- admin_users → child object type

-- in project Tickit Booking System 

CREATE TYPE user_t AS OBJECT (
    user_id NUMBER,
    full_name VARCHAR2(100),
    email VARCHAR2(100),
    password_hash VARCHAR2(200),
    phone_number VARCHAR2(15),
    role VARCHAR2(20),
    created_at TIMESTAMP
) NOT FINAL;
/

CREATE TYPE customer_t UNDER user_t (
    loyalty_points NUMBER,
    membership_type VARCHAR2(20)
);
/

CREATE TYPE admin_t UNDER user_t (
    admin_level NUMBER,
    access_area VARCHAR2(50)
);
/

CREATE TABLE users_obj OF user_t;
CREATE TABLE customer_users OF customer_t;


INSERT INTO users_obj VALUES (
    user_t(1,'Alice Johnson','alice@example.com','pass1','9876543210','customer',SYSTIMESTAMP)
);


INSERT INTO customer_users VALUES (
    customer_t(2,'Bob Smith','bob@example.com','pass2','9123456780','customer',SYSTIMESTAMP,500,'gold')
);


INSERT INTO admin_users VALUES (
    admin_t(3,'Admin User','admin@example.com','pass3','9000000000','admin',SYSTIMESTAMP,1,'system')
);


SELECT c.full_name,c.membership_type,c.loyalty_points
FROM customer_users c;

SELECT a.full_name,a.admin_level,a.access_area
FROM admin_users a;