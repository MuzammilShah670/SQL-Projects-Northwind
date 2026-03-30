-- ============================================================
-- Product & Inventory Analysis — Northwind Database (mywind schema)
-- ============================================================
USE northwind;

-- ------------------------------------------------------------
-- 1. All Products with Category and Supplier Info
-- ------------------------------------------------------------
SELECT
    p.id            AS product_id,
    p.product_name,
    p.category,
    p.list_price,
    p.quantity_per_unit,
    p.reorder_level,
    p.target_level,
    p.discontinued
FROM products p
ORDER BY p.category, p.product_name;

-- ------------------------------------------------------------
-- 2. Products with Low Stock (Below Reorder Level)
-- ------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    p.reorder_level,
    p.target_level,
    p.minimum_reorder_quantity
FROM products p
WHERE p.reorder_level > 0
  AND p.discontinued = 0
ORDER BY p.reorder_level ASC;

-- ------------------------------------------------------------
-- 3. Revenue Contribution by Product Category
-- ------------------------------------------------------------
SELECT
    p.category,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)   AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------
-- 4. Most Discounted Products
-- ------------------------------------------------------------
SELECT
    p.product_name,
    ROUND(AVG(od.discount) * 100, 2)  AS avg_discount_percent,
    SUM(od.quantity)                   AS total_units_sold
FROM order_details od
JOIN products p ON od.product_id = p.id
WHERE od.discount > 0
GROUP BY p.product_name
ORDER BY avg_discount_percent DESC;

-- ------------------------------------------------------------
-- 5. Impact of Discounts on Revenue
-- ------------------------------------------------------------
SELECT
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity), 2)                         AS revenue_without_discount,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS actual_revenue,
    ROUND(SUM(od.unit_price * od.quantity) -
          SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS revenue_lost_to_discount
FROM order_details od
JOIN products p ON od.product_id = p.id
GROUP BY p.product_name
ORDER BY revenue_lost_to_discount DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 6. Discontinued Products
-- ------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    p.list_price
FROM products p
WHERE p.discontinued = 1;

-- ------------------------------------------------------------
-- 7. Inventory Value per Product
-- ------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    p.list_price,
    p.target_level,
    ROUND(p.list_price * p.target_level, 2) AS estimated_inventory_value
FROM products p
WHERE p.discontinued = 0
ORDER BY estimated_inventory_value DESC;
