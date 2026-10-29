CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INT REFERENCES categories(id) ON DELETE SET NULL,
    product_name VARCHAR(150) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    brand VARCHAR(100),
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    cost_price NUMERIC(10, 2),
    stock_quantity INT NOT NULL DEFAULT 0,
    weight_kg NUMERIC(6, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(10, 2) NOT NULL,
    status VARCHAR(30) DEFAULT 'Pending'
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT REFERENCES products(id) ON DELETE RESTRICT,
    quantity INT NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL
);

CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(30) DEFAULT 'Completed'
);

CREATE TABLE IF NOT EXISTS contacts (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*
INSERT INTO contacts (full_name, email, subject, message) VALUES
('John Smith', 'john.smith@example.com', 'Question about order status', 'Hello, I would like to know when my recent order will be shipped. Thank you!'),
('Sarah Connor', 'sarah.c@example.com', 'Product availability inquiry', 'Hi, do you know when the wireless headphones will be back in stock?'),
('Michael Vance', 'mvance@example.com', 'Shipping address change', 'Is it possible to update the shipping address for order #1042? Thanks.'),
('Emily Blunt', 'e.blunt@example.com', 'Return policy question', 'Hello, what is the procedure for returning a defective item?'),
('David Kim', 'dkim@example.com', 'Payment issue', 'Hi team, my payment failed twice during checkout. Could you please check?'),
('Jessica Alba', 'j.alba@example.com', 'Account login help', 'I am having trouble resetting my password. Can you assist?'),
('Robert Fox', 'rfox@example.com', 'Wholesale inquiry', 'Hello, do you offer bulk discounts for corporate orders?'),
('Amanda Lee', 'a.lee@example.com', 'Feedback on recent purchase', 'Just wanted to say I love the new product! Great quality.'),
('James Bond', 'jbond@example.com', 'Technical support', 'The application crashes when I try to upload my profile picture.'),
('Laura Croft', 'lcroft@example.com', 'General question', 'Hi, what are your customer support working hours?');
*/
