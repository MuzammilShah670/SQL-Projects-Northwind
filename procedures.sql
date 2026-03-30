-- ============================================================
-- Stored Procedures — Northwind Database (mywind schema)
-- ============================================================
USE northwind;

-- ------------------------------------------------------------
-- 1. GetCustomerOrders(customer_id)
--    Returns all orders and total value for a given customer
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetCustomerOrders(IN p_customer_id INT)
BEGIN
    SELECT
        o.id                                                                AS order_id,
        o.order_date,
        o.shipped_date,
        sh.company                                                          AS shipper,
        ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS order_total
    FROM orders o
    JOIN order_details od ON o.id       = od.order_id
    JOIN shippers      sh ON o.shipper_id = sh.id
    WHERE o.customer_id = p_customer_id
    GROUP BY o.id, o.order_date, o.shipped_date, shipper
    ORDER BY o.order_date DESC;
END$$

DELIMITER ;

-- Usage: CALL GetCustomerOrders(1);


-- ------------------------------------------------------------
-- 2. GetTopProducts(N)
--    Returns the top N products by total revenue
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetTopProducts(IN p_limit INT)
BEGIN
    SELECT
        p.product_name,
        p.category,
        ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)   AS total_revenue,
        SUM(od.quantity)                                                   AS total_units_sold
    FROM order_details od
    JOIN products p ON od.product_id = p.id
    GROUP BY p.id, p.product_name, p.category
    ORDER BY total_revenue DESC
    LIMIT p_limit;
END$$

DELIMITER ;

-- Usage: CALL GetTopProducts(5);


-- ------------------------------------------------------------
-- 3. GetSalesByEmployee(employee_id)
--    Returns a sales summary for a specific employee
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetSalesByEmployee(IN p_employee_id INT)
BEGIN
    SELECT
        CONCAT(e.first_name, ' ', e.last_name)                             AS employee_name,
        e.job_title,
        COUNT(o.id)                                                         AS total_orders,
        ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS total_revenue,
        ROUND(AVG(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS avg_order_value
    FROM employees e
    JOIN orders        o  ON e.id  = o.employee_id
    JOIN order_details od ON o.id  = od.order_id
    WHERE e.id = p_employee_id
    GROUP BY employee_name, e.job_title;
END$$

DELIMITER ;

-- Usage: CALL GetSalesByEmployee(1);


-- ------------------------------------------------------------
-- 4. GetRevenueByCategory()
--    Returns total revenue broken down by product category
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetRevenueByCategory()
BEGIN
    SELECT
        p.category,
        COUNT(DISTINCT p.id)                                                AS total_products,
        ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS total_revenue,
        ROUND(AVG(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS avg_revenue_per_line
    FROM products p
    JOIN order_details od ON p.id = od.product_id
    GROUP BY p.category
    ORDER BY total_revenue DESC;
END$$

DELIMITER ;

-- Usage: CALL GetRevenueByCategory();


-- ------------------------------------------------------------
-- 5. GetLowStockProducts(threshold)
--    Returns products whose reorder level is above a threshold
-- ------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE GetLowStockProducts(IN p_threshold INT)
BEGIN
    SELECT
        p.product_name,
        p.category,
        p.reorder_level,
        p.target_level,
        p.minimum_reorder_quantity
    FROM products p
    WHERE p.reorder_level >= p_threshold
      AND p.discontinued = 0
    ORDER BY p.reorder_level DESC;
END$$

DELIMITER ;

-- Usage: CALL GetLowStockProducts(20);
