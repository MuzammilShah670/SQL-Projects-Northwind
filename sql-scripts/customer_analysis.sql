-- ============================================================
-- Customer Analysis Queries — Northwind Database (mywind schema)
-- ============================================================
USE northwind;

-- ------------------------------------------------------------
-- 1. Top 10 Customers by Total Order Value
-- ------------------------------------------------------------
SELECT
    c.id                                                                AS customer_id,
    c.company,
    c.country_region,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS total_spent
FROM customers c
JOIN orders o         ON c.id       = o.customer_id
JOIN order_details od ON o.id       = od.order_id
GROUP BY c.id, c.company, c.country_region
ORDER BY total_spent DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 2. Total Number of Orders per Customer
-- ------------------------------------------------------------
SELECT
    c.company,
    COUNT(o.id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.company
ORDER BY total_orders DESC;

-- ------------------------------------------------------------
-- 3. Average Order Value per Customer
-- ------------------------------------------------------------
SELECT
    c.company,
    ROUND(AVG(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS avg_order_value
FROM customers c
JOIN orders o         ON c.id = o.customer_id
JOIN order_details od ON o.id = od.order_id
GROUP BY c.id, c.company
ORDER BY avg_order_value DESC;

-- ------------------------------------------------------------
-- 4. Customers with No Orders (Inactive)
-- ------------------------------------------------------------
SELECT
    c.id,
    c.company,
    c.country_region
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- ------------------------------------------------------------
-- 5. Customers Who Haven't Ordered in the Last Year (Churn Detection)
-- ------------------------------------------------------------
SELECT
    c.company,
    MAX(o.order_date) AS last_order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.company
HAVING MAX(o.order_date) < DATE_SUB(
    (SELECT MAX(order_date) FROM orders), INTERVAL 1 YEAR
)
ORDER BY last_order_date ASC;

-- ------------------------------------------------------------
-- 6. Customers by Country
-- ------------------------------------------------------------
SELECT
    country_region,
    COUNT(id) AS total_customers
FROM customers
GROUP BY country_region
ORDER BY total_customers DESC;

-- ------------------------------------------------------------
-- 7. Revenue per Customer per Year
-- ------------------------------------------------------------
SELECT
    c.company,
    YEAR(o.order_date)                                                 AS year,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)   AS yearly_revenue
FROM customers c
JOIN orders o         ON c.id = o.customer_id
JOIN order_details od ON o.id = od.order_id
GROUP BY c.id, c.company, YEAR(o.order_date)
ORDER BY c.company, year;
