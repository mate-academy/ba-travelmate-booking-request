-- ============================================================
-- TravelMate Database Schema
-- SQL Scripts for PostgreSQL / MySQL
-- ============================================================

-- ============================================================
-- DROP EXISTING TABLES (if needed for reset)
-- ============================================================

-- Drop tables in reverse order of dependencies
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS hotel_amenities;
DROP TABLE IF EXISTS amenities;
DROP TABLE IF EXISTS hotels;
DROP TABLE IF EXISTS users;

-- ============================================================
-- CREATE TABLES
-- ============================================================

-- ------------------------------------------------------------
-- USERS TABLE
-- Stores user account information
-- ------------------------------------------------------------
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('user', 'admin') DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes for common queries
    INDEX idx_users_email (email),
    INDEX idx_users_role (role)
);

-- ------------------------------------------------------------
-- HOTELS TABLE
-- Stores hotel information
-- ------------------------------------------------------------
CREATE TABLE hotels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    star_rating TINYINT NOT NULL CHECK (star_rating BETWEEN 1 AND 5),
    price_per_night DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(500),
    total_rooms INT NOT NULL DEFAULT 0,
    available_rooms INT NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Indexes for common queries
    INDEX idx_hotels_city (city),
    INDEX idx_hotels_country (country),
    INDEX idx_hotels_price (price_per_night),
    INDEX idx_hotels_rating (star_rating)
);

-- ------------------------------------------------------------
-- AMENITIES TABLE
-- Lookup table for hotel amenities
-- ------------------------------------------------------------
CREATE TABLE amenities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- HOTEL_AMENITIES TABLE
-- Junction table for many-to-many relationship
-- ------------------------------------------------------------
CREATE TABLE hotel_amenities (
    hotel_id INT NOT NULL,
    amenity_id INT NOT NULL,
    PRIMARY KEY (hotel_id, amenity_id),
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenities(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- BOOKINGS TABLE
-- Stores booking/reservation information
-- ------------------------------------------------------------
CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    hotel_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    guests INT NOT NULL DEFAULT 1,
    rooms INT NOT NULL DEFAULT 1,
    price_per_night DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    taxes DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_price DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    special_requests TEXT,
    confirmation_code VARCHAR(20) UNIQUE,
    payment_reference VARCHAR(50),
    cancelled_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Foreign keys
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,

    -- Indexes for common queries
    INDEX idx_bookings_user (user_id),
    INDEX idx_bookings_hotel (hotel_id),
    INDEX idx_bookings_status (status),
    INDEX idx_bookings_dates (check_in_date, check_out_date),
    INDEX idx_bookings_confirmation (confirmation_code)
);

-- ============================================================
-- INSERT SAMPLE DATA
-- ============================================================

-- ------------------------------------------------------------
-- Sample Users
-- Password for all users: "Password123!" (hashed with bcrypt)
-- ------------------------------------------------------------
INSERT INTO users (email, password_hash, first_name, last_name, phone, role) VALUES
('admin@travelmate.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Admin', 'User', '+1-555-000-0001', 'admin'),
('john.doe@example.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'John', 'Doe', '+1-555-123-4567', 'user'),
('jane.smith@example.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Jane', 'Smith', '+1-555-987-6543', 'user'),
('bob.wilson@example.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Bob', 'Wilson', '+1-555-456-7890', 'user'),
('alice.johnson@example.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Alice', 'Johnson', '+1-555-321-9876', 'user');

-- ------------------------------------------------------------
-- Sample Amenities
-- ------------------------------------------------------------
INSERT INTO amenities (name, icon) VALUES
('WiFi', 'wifi'),
('Pool', 'pool'),
('Spa', 'spa'),
('Gym', 'fitness_center'),
('Restaurant', 'restaurant'),
('Bar', 'local_bar'),
('Room Service', 'room_service'),
('Parking', 'local_parking'),
('Airport Shuttle', 'airport_shuttle'),
('Pet Friendly', 'pets'),
('Beach Access', 'beach_access'),
('Breakfast Included', 'free_breakfast'),
('Concierge', 'concierge'),
('Business Center', 'business_center'),
('Laundry Service', 'local_laundry_service');

-- ------------------------------------------------------------
-- Sample Hotels
-- ------------------------------------------------------------
INSERT INTO hotels (name, description, address, city, country, postal_code, star_rating, price_per_night, image_url, total_rooms, available_rooms) VALUES
('Grand Plaza Hotel', 'Luxury 5-star hotel in the heart of Paris with world-class amenities and stunning views of the Eiffel Tower.', '123 Champs-Élysées', 'Paris', 'France', '75008', 5, 299.99, 'https://images.travelmate.com/hotels/grand-plaza.jpg', 150, 23),
('Cozy Inn', 'Charming boutique hotel near Montmartre, perfect for romantic getaways and art lovers.', '45 Rue Lepic', 'Paris', 'France', '75018', 3, 89.99, 'https://images.travelmate.com/hotels/cozy-inn.jpg', 25, 8),
('Seaside Resort', 'Beautiful beachfront resort with stunning ocean views and direct beach access.', '789 Ocean Drive', 'Miami', 'USA', '33139', 4, 199.99, 'https://images.travelmate.com/hotels/seaside-resort.jpg', 200, 45),
('Mountain Lodge', 'Rustic mountain retreat with breathtaking alpine scenery and ski-in/ski-out access.', '456 Alpine Way', 'Zermatt', 'Switzerland', '3920', 4, 259.99, 'https://images.travelmate.com/hotels/mountain-lodge.jpg', 80, 12),
('City Center Suites', 'Modern all-suite hotel in downtown Manhattan, walking distance to Times Square.', '100 Broadway', 'New York', 'USA', '10005', 4, 349.99, 'https://images.travelmate.com/hotels/city-center.jpg', 120, 30),
('Tropical Paradise Resort', 'All-inclusive tropical resort with private beach and world-class spa facilities.', '1 Paradise Island', 'Cancun', 'Mexico', '77500', 5, 449.99, 'https://images.travelmate.com/hotels/tropical-paradise.jpg', 300, 67),
('Historic Palace Hotel', 'Elegant historic hotel in a restored 18th-century palace with modern luxury amenities.', '77 Royal Street', 'London', 'UK', 'SW1A 1AA', 5, 399.99, 'https://images.travelmate.com/hotels/historic-palace.jpg', 100, 15),
('Budget Stay Inn', 'Clean and comfortable budget accommodation, perfect for backpackers and budget travelers.', '22 Traveler Road', 'Bangkok', 'Thailand', '10110', 2, 29.99, 'https://images.travelmate.com/hotels/budget-stay.jpg', 50, 35),
('Business Elite Hotel', 'Premium business hotel with state-of-the-art conference facilities and executive lounges.', '500 Corporate Plaza', 'Singapore', 'Singapore', '018989', 4, 279.99, 'https://images.travelmate.com/hotels/business-elite.jpg', 180, 42),
('Lakeside Retreat', 'Peaceful lakeside resort with water sports, fishing, and nature trails.', '88 Lakeview Drive', 'Lake Como', 'Italy', '22021', 4, 229.99, 'https://images.travelmate.com/hotels/lakeside-retreat.jpg', 60, 18);

-- ------------------------------------------------------------
-- Link Hotels to Amenities
-- ------------------------------------------------------------
-- Grand Plaza Hotel (Paris) - Full luxury amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 13), (1, 15);

-- Cozy Inn (Paris) - Basic amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(2, 1), (2, 12);

-- Seaside Resort (Miami) - Beach resort amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(3, 1), (3, 2), (3, 3), (3, 5), (3, 6), (3, 8), (3, 11);

-- Mountain Lodge (Switzerland) - Mountain amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(4, 1), (4, 3), (4, 4), (4, 5), (4, 6), (4, 8), (4, 12);

-- City Center Suites (NYC) - Business amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(5, 1), (5, 4), (5, 5), (5, 7), (5, 8), (5, 14), (5, 15);

-- Tropical Paradise Resort (Cancun) - All-inclusive amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6), (6, 7), (6, 9), (6, 11), (6, 12);

-- Historic Palace Hotel (London) - Luxury amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(7, 1), (7, 3), (7, 4), (7, 5), (7, 6), (7, 7), (7, 13), (7, 15);

-- Budget Stay Inn (Bangkok) - Basic amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(8, 1), (8, 15);

-- Business Elite Hotel (Singapore) - Business amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(9, 1), (9, 2), (9, 4), (9, 5), (9, 6), (9, 7), (9, 8), (9, 9), (9, 14), (9, 15);

-- Lakeside Retreat (Italy) - Nature amenities
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(10, 1), (10, 5), (10, 6), (10, 8), (10, 10), (10, 12);

-- ------------------------------------------------------------
-- Sample Bookings
-- ------------------------------------------------------------
INSERT INTO bookings (user_id, hotel_id, check_in_date, check_out_date, guests, rooms, price_per_night, subtotal, taxes, total_price, status, special_requests, confirmation_code, payment_reference) VALUES
(2, 1, '2024-03-15', '2024-03-20', 2, 1, 299.99, 1499.95, 149.99, 1649.94, 'confirmed', 'Late check-in requested, arriving around 11 PM', 'TM-2024-ABC123', 'PAY-001234567'),
(2, 2, '2024-04-10', '2024-04-12', 1, 1, 89.99, 179.98, 18.00, 197.98, 'pending', NULL, 'TM-2024-DEF456', NULL),
(3, 3, '2024-03-25', '2024-03-30', 4, 2, 199.99, 1999.90, 199.99, 2199.89, 'confirmed', 'Ocean view room preferred', 'TM-2024-GHI789', 'PAY-001234568'),
(4, 6, '2024-05-01', '2024-05-07', 2, 1, 449.99, 2699.94, 269.99, 2969.93, 'confirmed', 'Honeymoon package requested', 'TM-2024-JKL012', 'PAY-001234569'),
(5, 4, '2024-02-15', '2024-02-18', 2, 1, 259.99, 779.97, 78.00, 857.97, 'completed', 'Ski equipment storage needed', 'TM-2024-MNO345', 'PAY-001234570'),
(3, 7, '2024-06-20', '2024-06-25', 3, 2, 399.99, 3999.90, 399.99, 4399.89, 'pending', 'Connecting rooms if possible', 'TM-2024-PQR678', NULL),
(2, 5, '2024-01-10', '2024-01-12', 1, 1, 349.99, 699.98, 70.00, 769.98, 'cancelled', NULL, 'TM-2024-STU901', NULL);

-- ============================================================
-- USEFUL QUERIES FOR STUDENTS
-- ============================================================

-- Query 1: Get all hotels with their amenities
-- SELECT h.*, GROUP_CONCAT(a.name) as amenities
-- FROM hotels h
-- LEFT JOIN hotel_amenities ha ON h.id = ha.hotel_id
-- LEFT JOIN amenities a ON ha.amenity_id = a.id
-- GROUP BY h.id;

-- Query 2: Get bookings for a specific user
-- SELECT b.*, h.name as hotel_name, h.city, h.country
-- FROM bookings b
-- JOIN hotels h ON b.hotel_id = h.id
-- WHERE b.user_id = 2;

-- Query 3: Check hotel availability for dates
-- SELECT h.*,
--        h.available_rooms - COALESCE(booked.rooms_booked, 0) as rooms_available
-- FROM hotels h
-- LEFT JOIN (
--     SELECT hotel_id, SUM(rooms) as rooms_booked
--     FROM bookings
--     WHERE status IN ('pending', 'confirmed')
--     AND check_in_date <= '2024-03-20'
--     AND check_out_date >= '2024-03-15'
--     GROUP BY hotel_id
-- ) booked ON h.id = booked.hotel_id
-- WHERE h.id = 1;

-- Query 4: Get booking statistics by status
-- SELECT status, COUNT(*) as count, SUM(total_price) as total_revenue
-- FROM bookings
-- GROUP BY status;

-- Query 5: Get top hotels by bookings
-- SELECT h.name, h.city, COUNT(b.id) as booking_count, SUM(b.total_price) as revenue
-- FROM hotels h
-- LEFT JOIN bookings b ON h.id = b.hotel_id
-- GROUP BY h.id
-- ORDER BY booking_count DESC
-- LIMIT 5;
