# Movie Ticket Booking System - Gemini CLI Instructions

This project is a movie ticket booking application built with Node.js, Express, and PostgreSQL. It features user authentication, movie browsing, showtime management, and seat selection.

## Project Overview

-   **Architecture:** Express.js MVC-style application.
-   **Frontend:** EJS (Embedded JavaScript) templating engine.
-   **Backend:** Node.js with Express for routing and middleware.
-   **Database:** PostgreSQL, using the `pg` library for connection pooling.
-   **Authentication:** Session-based authentication using `express-session` and password hashing with `bcrypt`.
-   **Styling:** Custom CSS located in `public/style.css`.

## Core Technologies

-   **Runtime:** Node.js
-   **Framework:** Express
-   **Database Driver:** `pg` (node-postgres)
-   **View Engine:** EJS
-   **Auth:** `bcrypt`, `express-session`
-   **Config:** `dotenv`

## Getting Started

### Prerequisites

-   Node.js and npm installed.
-   PostgreSQL database instance running.
-   A `.env` file configured with the following variables:
    ```env
    DB_USER=your_user
    DB_HOST=your_host
    DB_DATABASE=your_database
    DB_PASSWORD=your_password
    DB_PORT=5432
    SESSION_SECRET=your_secret
    ```

### Building and Running

1.  **Install Dependencies:**
    ```bash
    npm install
    ```
2.  **Database Setup:**
    Execute the SQL scripts in the `sql/` directory in sequential order (001 to 010).
3.  **Start the Application:**
    ```bash
    npm start
    ```
    The application will run on `http://localhost:3000` (or the port specified in `.env`).

## Directory Structure

-   `app.js`: Main entry point and application configuration.
-   `db/db.js`: Database connection pool configuration.
-   `middleware/auth.js`: Authentication middleware for protecting routes.
-   `public/`: Static assets (CSS, images).
-   `routes/`: Express routers for different application modules:
    -   `admin.js`: Administrative functions (showtime management, etc.).
    -   `bookings.js`: Booking process and history.
    -   `movies.js`: Movie browsing.
    -   `seats.js`: Seat selection logic.
    -   `showtimes.js`: Showtime retrieval.
    -   `users.js`: User registration, login, and dashboard.
-   `sql/`: SQL migration, seeding, and utility scripts.
-   `views/`: EJS templates for the frontend.

## Development Conventions

-   **Routing:** Modular routing using `express.Router()`.
-   **Auth Guards:** Use the `requireLogin` middleware (from `middleware/auth.js`) to protect routes that require authentication.
-   **Database Queries:** Use the exported `pool` from `db/db.js` for executing SQL queries.
-   **Error Handling:** Basic error handling is present in routes; ensure to maintain consistent error response patterns.
-   **Migrations:** Database schema changes should be added as new SQL files in the `sql/` directory with a sequential numeric prefix.

## Testing Strategy

-   Currently, there is no automated testing framework (like Jest or Mocha) integrated. 
-   **TODO:** Implement unit and integration tests for core booking logic and user authentication.
-   Manual testing can be performed by running the application and navigating through the user and admin flows.
