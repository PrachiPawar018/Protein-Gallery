-- Protein Gallery database setup
CREATE DATABASE IF NOT EXISTS protein_gallery CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE protein_gallery;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(180) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(32) NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    goal_tag VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    featured BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(64) NOT NULL DEFAULT 'Pending',
    payment_id VARCHAR(255),
    payment_status VARCHAR(64) NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    provider VARCHAR(80) NOT NULL,
    transaction_id VARCHAR(255),
    amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(64) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE IF NOT EXISTS wishlist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT IGNORE INTO users (name, email, password_hash, role)
VALUES
('Admin User', 'admin@proteingallery.com', '$2a$12$7npwo/ZASU5ngfLKC8RRIeUaFhde6Q/KG7EJg5bJ8h6hpb76AqZrO', 'admin');

INSERT IGNORE INTO products (name, description, category, goal_tag, price, image_url, stock, featured)
VALUES
('Whey Protein Blend', 'High-quality whey protein for muscle recovery and growth.', 'Whey', 'muscle-gain', 1799.00, 'https://images.unsplash.com/photo-1554284126-aa88f22d8b0d', 120, TRUE),
('Lean Protein Isolate', 'Premium isolate for low-carb, high-protein nutrition.', 'Whey', 'weight-loss', 1999.00, 'https://images.unsplash.com/photo-1514996937319-344454492b37', 80, TRUE),
('Beginner Fitness Stack', 'Starter supplement stack curated for new gym-goers.', 'Supplement', 'beginner', 1499.00, 'https://images.unsplash.com/photo-1526401485004-9d1f17bfe31f', 50, TRUE),
('Endurance Pre-Workout', 'Boost energy and stamina for long training sessions.', 'Pre-workout', 'endurance', 999.00, 'https://images.unsplash.com/photo-1592496001028-e6b2046faeb5', 70, TRUE);
