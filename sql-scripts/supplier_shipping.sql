-- ============================================================
-- Supplier & Shipping Analysis — Northwind Database (mywind schema)
-- ============================================================
USE northwind;

-- ------------------------------------------------------------
-- 1. Orders Grouped by Shipping Company
-- ------------------------------------------------------------
SELECT
    sh.company                          AS shipper,
    COUNT(o.id)                         AS total_orders,
    ROUND(SUM(o.shipping_fee), 2)       AS total_shipping_fee
FROM orders o
JOIN shippers sh ON o.shipper_id = sh.id
GROUP BY sh.company
ORDER BY total_orders DESC;

-- ------------------------------------------------------------
-- 2. Average Shipping Time per Shipper (Days)
-- ------------------------------------------------------------
SELECT
    sh.company                                                  AS shipper,
    ROUND(AVG(DATEDIFF(o.shipped_date, o.order_date)), 1)      AS avg_shipping_days
FROM orders o
JOIN shippers sh ON o.shipper_id = sh.id
WHERE o.shipped_date IS NOT NULL
GROUP BY sh.company
ORDER BY avg_shipping_days ASC;

-- ------------------------------------------------------------
-- 3. Late Orders (Shipped After Required Date)
-- ------------------------------------------------------------
SELECT
    o.id                                                        AS order_id,
    c.company                                                   AS customer,
    sh.company                                                  AS shipper,
    o.order_date,
    o.shipped_date,
    DATEDIFF(o.shipped_date, o.order_date)                     AS days_to_ship
FROM orders o
JOIN customers c  ON o.customer_id  = c.id
JOIN shippers  sh ON o.shipper_id   = sh.id
WHERE o.shipped_date IS NOT NULL
  AND DATEDIFF(o.shipped_date, o.order_date) > 7
ORDER BY days_to_ship DESC;

-- ------------------------------------------------------------
-- 4. Revenue Generated per Supplier (via products)
-- ------------------------------------------------------------
SELECT
    s.company                                                           AS supplier,
    s.country_region,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS total_revenue
FROM suppliers s
JOIN products      p  ON p.supplier_ids LIKE CONCAT('%', s.id, '%')
JOIN order_details od ON p.id           = od.product_id
GROUP BY s.id, s.company, s.country_region
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------
-- 5. Shipping Fee by Destination Country
-- ------------------------------------------------------------
SELECT
    o.ship_country_region,
    COUNT(o.id)                     AS total_orders,
    ROUND(SUM(o.shipping_fee), 2)   AS total_shipping_fee,
    ROUND(AVG(o.shipping_fee), 2)   AS avg_shipping_fee
FROM orders o
GROUP BY o.ship_country_region
ORDER BY total_shipping_fee DESC;

-- ------------------------------------------------------------
-- 6. Unshipped Orders (Not Yet Shipped)
-- ------------------------------------------------------------
SELECT
    o.id            AS order_id,
    c.company       AS customer,
    sh.company      AS assigned_shipper,
    o.order_date,
    o.order_date    AS expected_by
FROM orders o
JOIN customers c  ON o.customer_id = c.id
JOIN shippers  sh ON o.shipper_id  = sh.id
WHERE o.shipped_date IS NULL
ORDER BY o.order_date ASC;

-- ------------------------------------------------------------
-- 7. Orders per Shipper per Year
-- ------------------------------------------------------------
SELECT
    sh.company              AS shipper,
    YEAR(o.order_date)      AS year,
    COUNT(o.id)             AS total_orders
FROM orders o
JOIN shippers sh ON o.shipper_id = sh.id
GROUP BY sh.company, YEAR(o.order_date)
ORDER BY shipper, year;
