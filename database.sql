CREATE DATABASE IF NOT EXISTS clothing_store CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE clothing_store;

CREATE TABLE IF NOT EXISTS users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(190) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'employee', 'customer') NOT NULL DEFAULT 'customer',
    employee_role ENUM('order_manager', 'product_manager', 'voting_moderator') NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS standard_products (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category ENUM('hoodie', 't-shirt', 'cap') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    description TEXT NOT NULL,
    image_path VARCHAR(255) NULL,
    drop_end_at DATETIME NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS custom_products (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    saved_design_id INT UNSIGNED NULL,
    display_name VARCHAR(150) NOT NULL,
    base_price DECIMAL(10,2) NOT NULL,
    is_featured TINYINT(1) NOT NULL DEFAULT 0,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS saved_designs (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NULL,
    name VARCHAR(150) NOT NULL,
    product_type ENUM('hoodie', 't-shirt', 'cap') NOT NULL,
    base_color VARCHAR(20) NOT NULL,
    size VARCHAR(20) NOT NULL,
    custom_text VARCHAR(120) NULL,
    image_path VARCHAR(255) NULL,
    preview_image VARCHAR(255) NULL,
    submit_to_vote TINYINT(1) NOT NULL DEFAULT 0,
    approval_status ENUM('private', 'pending', 'approved', 'rejected') NOT NULL DEFAULT 'private',
    is_featured_candidate TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_saved_design_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS votes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    design_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NULL,
    voter_fingerprint VARCHAR(128) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vote_design FOREIGN KEY (design_id) REFERENCES saved_designs(id) ON DELETE CASCADE,
    CONSTRAINT fk_vote_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY uniq_design_user_vote (design_id, user_id),
    UNIQUE KEY uniq_design_fingerprint_vote (design_id, voter_fingerprint)
);

CREATE TABLE IF NOT EXISTS orders (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    delivery_status VARCHAR(80) NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNSIGNED NOT NULL,
    product_type ENUM('standard', 'custom') NOT NULL,
    standard_product_id INT UNSIGNED NULL,
    custom_product_id INT UNSIGNED NULL,
    saved_design_id INT UNSIGNED NULL,
    product_name VARCHAR(150) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS website_settings (
    setting_key VARCHAR(100) PRIMARY KEY,
    setting_value JSON NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
