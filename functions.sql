
-- 1. Create the log table
CREATE TABLE order_logs (
    id SERIAL PRIMARY KEY,
    order_id INT,
    action_message TEXT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create the Trigger Function
CREATE OR REPLACE FUNCTION log_new_order_trigger()
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
DECLARE
    order_count INT;
BEGIN
    SELECT COUNT(*) INTO order_count FROM orders WHERE user_id = NEW.user_id;
    
    INSERT INTO order_logs (order_id, action_message)
    VALUES (NEW.id, 'New order placed. User total orders: ' || order_count);
    
    RETURN NEW;
END;
$$;

-- 3. Create the Trigger binding
CREATE TRIGGER trg_after_order_insert
    AFTER INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION log_new_order_trigger();

-- 4. Create the main function
CREATE OR REPLACE FUNCTION place_test_order(
    p_user_id INT, 
    p_product_id INT, 
    p_quantity INT
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_product_price NUMERIC(10, 2);
    v_total_amount NUMERIC(10, 2);
    v_new_order_id INT;
BEGIN
    SELECT price INTO v_product_price FROM products WHERE id = p_product_id;
    
    v_total_amount := v_product_price * p_quantity;
    
    INSERT INTO orders (user_id, total_amount, status)
    VALUES (p_user_id, v_total_amount, 'Processing')
    RETURNING id INTO v_new_order_id;
    
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (v_new_order_id, p_product_id, p_quantity, v_product_price);

    RETURN v_new_order_id;
END;
$$;

