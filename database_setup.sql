-- Create Database
CREATE DATABASE IF NOT EXISTS protein_gallery CHARACTER SET utf8 COLLATE utf8_general_ci;
USE protein_gallery;

-- USERS
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,      -- BCrypt
    phone_number VARCHAR(15),
    role ENUM('USER','ADMIN') DEFAULT 'USER',
    is_active TINYINT(1) DEFAULT 1,
    reset_otp VARCHAR(6) DEFAULT NULL,        -- 6-digit OTP for password reset
    otp_expiry DATETIME DEFAULT NULL,         -- OTP expiry timestamp
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- PRODUCTS
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    brand VARCHAR(100),
    category ENUM('Whey Protein','Mass Gainer','Creatine','Pre-Workout','Vitamins','Beginner Pack'),
    goal_tag ENUM('muscle-gain','weight-loss','beginner','endurance'),
    price DECIMAL(10,2) NOT NULL,
    discount_percent INT DEFAULT 0,
    description TEXT,
    nutrition_info TEXT,
    stock INT DEFAULT 0,
    image_url VARCHAR(500),
    rating_avg DECIMAL(3,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CART
CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ORDERS
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2),
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    coupon_code VARCHAR(50),
    status ENUM('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
    shipping_address TEXT,
    tracking_number VARCHAR(100),
    payment_method VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ORDER ITEMS
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- PAYMENTS
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNIQUE,
    razorpay_order_id VARCHAR(100),
    razorpay_payment_id VARCHAR(100),
    razorpay_signature VARCHAR(255),
    status ENUM('PENDING','SUCCESS','FAILED') DEFAULT 'PENDING',
    paid_at TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- REVIEWS
CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- COUPONS
CREATE TABLE IF NOT EXISTS coupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percent INT,
    min_order_amount DECIMAL(10,2),
    expiry_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

-- =========================================================
-- SEED DATA
-- =========================================================

-- Admin User (password is 'admin123' hashed with BCrypt)
-- Hash generated using a standard tool: $2a$12$KkQ/... (we'll insert a dummy hash for now, you will need to register an admin via the app to get a real hash or use this if it matches your BCrypt configuration)
INSERT IGNORE INTO users (name, email, password_hash, role) VALUES 
('Admin Account', 'prachipawar5133@gmail.com', '$2a$10$8K1p/a0gF1TZz.5sA2O25O8.n2V31b8R70701Yn0P10w1P505r08O', 'ADMIN');

-- Products (10 items across categories and goal_tags)
INSERT INTO products (name, brand, category, goal_tag, price, discount_percent, description, nutrition_info, stock, image_url) VALUES 
('Optimum Nutrition Gold Standard 100% Whey', 'Optimum Nutrition', 'Whey Protein', 'muscle-gain', 65.00, 10, 'Premium whey protein isolate for muscle recovery.', '24g Protein, 5.5g BCAAs', 100, 'images/products/on_whey.jpg'),
('MuscleTech Mass Tech Extreme 2000', 'MuscleTech', 'Mass Gainer', 'muscle-gain', 85.00, 15, 'High-calorie mass gainer for extreme muscle growth.', '80g Protein, 400g Carbs', 50, 'images/products/mass_tech.jpg'),
('Cellucor C4 Original Pre Workout', 'Cellucor', 'Pre-Workout', 'endurance', 30.00, 0, 'Explosive energy and performance pre-workout.', '150mg Caffeine, 1.6g Beta-Alanine', 75, 'images/products/c4_pre.jpg'),
('MyProtein Creatine Monohydrate', 'MyProtein', 'Creatine', 'muscle-gain', 25.00, 5, 'Pure creatine monohydrate for strength and power.', '5g Creatine per serving', 200, 'images/products/creatine.jpg'),
('Hydroxycut Hardcore Elite', 'Hydroxycut', 'Vitamins', 'weight-loss', 40.00, 20, 'Thermogenic weight loss support.', 'Green Coffee Extract', 60, 'images/products/hydroxycut.jpg'),
('BSN Syntha-6 Edge', 'BSN', 'Whey Protein', 'muscle-gain', 55.00, 10, 'Premium protein matrix with great taste.', '24g Protein, 11g EAAs', 80, 'images/products/syntha6.jpg'),
('Ultimate Nutrition Prostar 100% Whey', 'Ultimate Nutrition', 'Whey Protein', 'beginner', 50.00, 0, 'High quality whey for beginners.', '25g Protein, 6g BCAAs', 120, 'images/products/prostar.jpg'),
('Scivation Xtend BCAA', 'Scivation', 'Pre-Workout', 'endurance', 35.00, 5, 'Intra-workout BCAA for endurance and recovery.', '7g BCAAs, 0 Carbs', 90, 'images/products/xtend.jpg'),
('Optimum Nutrition Opti-Men', 'Optimum Nutrition', 'Vitamins', 'beginner', 20.00, 0, 'Daily multivitamin for active men.', 'Vitamins C, D, E, B-Complex', 150, 'images/products/optimen.jpg'),
('Beginner Stack (Whey + Creatine)', 'Protein Gallery', 'Beginner Pack', 'beginner', 75.00, 25, 'Essential starter pack for beginners.', 'Whey + Creatine Combo', 40, 'images/products/beginner_stack.jpg');
