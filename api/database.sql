-- ============================================================
-- TravelMate Database Schema
-- SQL Scripts for PostgreSQL / MySQL
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
    INDEX idx_users_email (email),
    INDEX idx_users_role (role)
);

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
    INDEX idx_hotels_city (city),
    INDEX idx_hotels_country (country),
    INDEX idx_hotels_price (price_per_night),
    INDEX idx_hotels_rating (star_rating)
);

CREATE TABLE amenities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hotel_amenities (
    hotel_id INT NOT NULL,
    amenity_id INT NOT NULL,
    PRIMARY KEY (hotel_id, amenity_id),
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenities(id) ON DELETE CASCADE
);

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
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    INDEX idx_bookings_user (user_id),
    INDEX idx_bookings_status (status)
);

-- ============================================================
-- INSERT SAMPLE DATA
-- ============================================================

-- 30 Users (Original 5 + 25 New English Users)
INSERT INTO users (email, password_hash, first_name, last_name, phone, role) VALUES
('admin@travelmate.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Admin', 'User', '+1-555-000-0001', 'admin'),
('john.doe@example.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'John', 'Doe', '+1-555-123-4567', 'user'),
('jane.smith@example.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Jane', 'Smith', '+1-555-987-6543', 'user'),
('bob.wilson@example.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Bob', 'Wilson', '+1-555-456-7890', 'user'),
('alice.johnson@example.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Alice', 'Johnson', '+1-555-321-9876', 'user'),
('michael.brown@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Michael', 'Brown', '+1-555-010-1122', 'user'),
('emily.davis@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Emily', 'Davis', '+1-555-010-3344', 'user'),
('james.miller@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'James', 'Miller', '+1-555-010-5566', 'user'),
('sarah.wilson@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Sarah', 'Wilson', '+1-555-010-7788', 'user'),
('robert.taylor@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Robert', 'Taylor', '+1-555-010-9900', 'user'),
('jessica.anderson@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Jessica', 'Anderson', '+44-20-7946-0123', 'user'),
('david.thomas@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'David', 'Thomas', '+44-20-7946-0456', 'user'),
('laura.jackson@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Laura', 'Jackson', '+44-20-7946-0789', 'user'),
('william.white@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'William', 'White', '+1-416-555-0111', 'user'),
('megan.harris@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Megan', 'Harris', '+1-416-555-0222', 'user'),
('charles.martin@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Charles', 'Martin', '+1-416-555-0333', 'user'),
('ashley.thompson@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Ashley', 'Thompson', '+1-416-555-0444', 'user'),
('christopher.garcia@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Christopher', 'Garcia', '+1-212-555-0101', 'user'),
('amanda.martinez@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Amanda', 'Martinez', '+1-212-555-0102', 'user'),
('matthew.robinson@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Matthew', 'Robinson', '+1-212-555-0103', 'user'),
('jennifer.clark@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Jennifer', 'Clark', '+1-212-555-0104', 'user'),
('daniel.lewis@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Daniel', 'Lewis', '+44-161-496-0123', 'user'),
('elizabeth.lee@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Elizabeth', 'Lee', '+44-161-496-0456', 'user'),
('thomas.walker@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Thomas', 'Walker', '+44-161-496-0789', 'user'),
('stephanie.hall@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Stephanie', 'Hall', '+1-312-555-0199', 'user'),
('joseph.allen@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Joseph', 'Allen', '+1-312-555-0188', 'user'),
('nicole.young@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Nicole', 'Young', '+1-312-555-0177', 'user'),
('kevin.king@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Kevin', 'King', '+1-312-555-0166', 'user'),
('rachel.wright@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'Rachel', 'Wright', '+1-312-555-0155', 'user'),
('george.scott@test.com', '$2b$10$rIC.8xbJj1V5CKz1L5l4Pu4K8H8vZ3mN7bF9xQ2wE1dR6yT4sU3mK', 'George', 'Scott', '+1-312-555-0144', 'user');

-- Amenities
INSERT INTO amenities (id, name, icon) VALUES
(1, 'WiFi', 'wifi'), (2, 'Pool', 'pool'), (3, 'Spa', 'spa'), (4, 'Gym', 'fitness_center'),
(5, 'Restaurant', 'restaurant'), (6, 'Bar', 'local_bar'), (7, 'Room Service', 'room_service'),
(8, 'Parking', 'local_parking'), (9, 'Airport Shuttle', 'airport_shuttle'), (10, 'Pet Friendly', 'pets'),
(11, 'Beach Access', 'beach_access'), (12, 'Breakfast Included', 'free_breakfast'),
(13, 'Concierge', 'concierge'), (14, 'Business Center', 'business_center'), (15, 'Laundry Service', 'local_laundry_service');

-- Hotels
INSERT INTO hotels (id, name, description, address, city, country, postal_code, star_rating, price_per_night, image_url, total_rooms, available_rooms) VALUES
(1, 'Grand Plaza Hotel', 'Luxury 5-star hotel in Paris', '123 Champs-Élysées', 'Paris', 'France', '75008', 5, 299.99, 'https://images.travelmate.com/hotels/grand-plaza.jpg', 150, 23),
(2, 'Cozy Inn', 'Charming boutique hotel', '45 Rue Lepic', 'Paris', 'France', '75018', 3, 89.99, 'https://images.travelmate.com/hotels/cozy-inn.jpg', 25, 8),
(3, 'Seaside Resort', 'Beachfront resort in Miami', '789 Ocean Drive', 'Miami', 'USA', '33139', 4, 199.99, 'https://images.travelmate.com/hotels/seaside-resort.jpg', 200, 45),
(4, 'Mountain Lodge', 'Rustic mountain retreat', '456 Alpine Way', 'Zermatt', 'Switzerland', '3920', 4, 259.99, 'https://images.travelmate.com/hotels/mountain-lodge.jpg', 80, 12),
(5, 'City Center Suites', 'Modern Manhattan hotel', '100 Broadway', 'New York', 'USA', '10005', 4, 349.99, 'https://images.travelmate.com/hotels/city-center.jpg', 120, 30),
(6, 'Tropical Paradise Resort', 'All-inclusive Cancun resort', '1 Paradise Island', 'Cancun', 'Mexico', '77500', 5, 449.99, 'https://images.travelmate.com/hotels/tropical-paradise.jpg', 300, 67),
(7, 'Historic Palace Hotel', 'Restored 18th-century palace', '77 Royal Street', 'London', 'UK', 'SW1A 1AA', 5, 399.99, 'https://images.travelmate.com/hotels/historic-palace.jpg', 100, 15),
(8, 'Budget Stay Inn', 'Backpacker accommodation', '22 Traveler Road', 'Bangkok', 'Thailand', '10110', 2, 29.99, 'https://images.travelmate.com/hotels/budget-stay.jpg', 50, 35),
(9, 'Business Elite Hotel', 'Premium business facilities', '500 Corporate Plaza', 'Singapore', 'Singapore', '018989', 4, 279.99, 'https://images.travelmate.com/hotels/business-elite.jpg', 180, 42),
(10, 'Lakeside Retreat', 'Peaceful lakeside resort', '88 Lakeview Drive', 'Lake Como', 'Italy', '22021', 4, 229.99, 'https://images.travelmate.com/hotels/lakeside-retreat.jpg', 60, 18);

-- Hotel Amenities Link (Full mapping for all 10 hotels)
INSERT INTO hotel_amenities (hotel_id, amenity_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,13),(1,15),
(2,1),(2,12),(2,5),
(3,1),(3,2),(3,3),(3,5),(3,6),(3,8),(3,11),
(4,1),(4,3),(4,4),(4,5),(4,6),(4,8),(4,12),
(5,1),(5,4),(5,5),(5,7),(5,8),(5,14),(5,15),
(6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,9),(6,11),(6,12),
(7,1),(7,3),(7,4),(7,5),(7,6),(7,7),(7,13),(7,15),
(8,1),(8,15),(8,5),
(9,1),(9,2),(9,4),(9,5),(9,6),(9,7),(9,8),(9,9),(9,14),(9,15),
(10,1),(10,5),(10,6),(10,8),(10,10),(10,12);

-- 20 Bookings
INSERT INTO bookings (user_id, hotel_id, check_in_date, check_out_date, guests, rooms, price_per_night, subtotal, taxes, total_price, status, confirmation_code) VALUES
(2, 1, '2024-03-15', '2024-03-20', 2, 1, 299.99, 1499.95, 149.99, 1649.94, 'confirmed', 'TM-2024-ABC123'),
(2, 2, '2024-04-10', '2024-04-12', 1, 1, 89.99, 179.98, 18.00, 197.98, 'pending', 'TM-2024-DEF456'),
(3, 3, '2024-03-25', '2024-03-30', 4, 2, 199.99, 1999.90, 199.99, 2199.89, 'confirmed', 'TM-2024-GHI789'),
(4, 6, '2024-05-01', '2024-05-07', 2, 1, 449.99, 2699.94, 269.99, 2969.93, 'confirmed', 'TM-2024-JKL012'),
(5, 4, '2024-02-15', '2024-02-18', 2, 1, 259.99, 779.97, 78.00, 857.97, 'completed', 'TM-2024-MNO345'),
(3, 7, '2024-06-20', '2024-06-25', 3, 2, 399.99, 3999.90, 399.99, 4399.89, 'pending', 'TM-2024-PQR678'),
(2, 5, '2024-01-10', '2024-01-12', 1, 1, 349.99, 699.98, 70.00, 769.98, 'cancelled', 'TM-2024-STU901'),
(6, 3, '2024-07-01', '2024-07-05', 2, 1, 199.99, 799.96, 80.00, 879.96, 'confirmed', 'TM-2024-NEW001'),
(7, 4, '2024-08-10', '2024-08-15', 2, 1, 259.99, 1299.95, 130.00, 1429.95, 'confirmed', 'TM-2024-NEW002'),
(8, 5, '2024-09-01', '2024-09-03', 1, 1, 349.99, 699.98, 70.00, 769.98, 'pending', 'TM-2024-NEW003'),
(10, 8, '2024-07-15', '2024-07-20', 1, 1, 29.99, 149.95, 15.00, 164.95, 'completed', 'TM-2024-NEW004'),
(12, 1, '2024-10-05', '2024-10-10', 2, 1, 299.99, 1499.95, 150.00, 1649.95, 'confirmed', 'TM-2024-NEW005'),
(15, 9, '2024-11-12', '2024-11-14', 1, 1, 279.99, 559.98, 56.00, 615.98, 'pending', 'TM-2024-NEW006'),
(18, 10, '2024-12-20', '2024-12-27', 4, 2, 229.99, 3219.86, 322.00, 3541.86, 'confirmed', 'TM-2024-NEW007'),
(20, 2, '2024-06-01', '2024-06-03', 2, 1, 89.99, 179.98, 18.00, 197.98, 'cancelled', 'TM-2024-NEW008'),
(22, 6, '2024-08-20', '2024-08-25', 2, 1, 449.99, 2249.95, 225.00, 2474.95, 'confirmed', 'TM-2024-NEW009'),
(25, 7, '2024-09-10', '2024-09-15', 2, 1, 399.99, 1999.95, 200.00, 2199.95, 'pending', 'TM-2024-NEW010'),
(27, 3, '2024-10-20', '2024-10-22', 1, 1, 199.99, 399.98, 40.00, 439.98, 'confirmed', 'TM-2024-NEW011'),
(29, 1, '2024-11-01', '2024-11-04', 2, 1, 299.99, 899.97, 90.00, 989.97, 'completed', 'TM-2024-NEW012'),
(30, 4, '2024-12-01', '2024-12-05', 3, 2, 259.99, 2079.92, 208.00, 2287.92, 'confirmed', 'TM-2024-NEW013');
