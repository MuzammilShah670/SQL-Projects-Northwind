-- ============================================================
-- Sales Analysis Queries — Northwind Database (mywind schema)
-- ============================================================
USE northwind;

-- ------------------------------------------------------------
-- 1. Total Revenue Overall
-- ------------------------------------------------------------
SELECT
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue
FROM order_details od;

-- ------------------------------------------------------------
-- 2. Total Revenue Per Year
-- ------------------------------------------------------------
SELECT
    YEAR(o.order_date)                                                AS year,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)  AS total_revenue
FROM orders o
JOIN order_details od ON o.id = od.order_id
GROUP BY YEAR(o.order_date)
ORDER BY year;

-- ------------------------------------------------------------
-- 3. Total Revenue Per Quarter
-- ------------------------------------------------------------
SELECT
    YEAR(o.order_date)                                                AS year,
    QUARTER(o.order_date)                                             AS quarter,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)  AS total_revenue
FROM orders o
JOIN order_details od ON o.id = od.order_id
GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
ORDER BY year, quarter;

-- ------------------------------------------------------------
-- 4. Month-over-Month Sales
-- ------------------------------------------------------------
SELECT
    YEAR(o.order_date)                                                AS year,
    MONTH(o.order_date)                                               AS month,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)  AS monthly_revenue
FROM orders o
JOIN order_details od ON o.id = od.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY year, month;

-- ------------------------------------------------------------
-- 5. Top 10 Best-Selling Products by Revenue
-- ------------------------------------------------------------
SELECT
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)  AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 6. Top 10 Best-Selling Products by Quantity
-- ------------------------------------------------------------
SELECT
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN products p ON od.product_id = p.id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 7. Revenue by Ship Country
-- ------------------------------------------------------------
SELECT
    o.ship_country_region                                             AS country,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)  AS total_revenue
FROM orders o
JOIN order_details od ON o.id = od.order_id
GROUP BY o.ship_country_region
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------
-- 8. Average Order Value
-- ------------------------------------------------------------
SELECT
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT
        od.order_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS order_total
    FROM order_details od
    GROUP BY od.order_id
) AS order_summary;
