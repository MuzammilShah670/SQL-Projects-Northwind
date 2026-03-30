-- ============================================================
-- Employee Performance Queries — Northwind Database (mywind schema)
-- ============================================================
USE northwind;

-- ------------------------------------------------------------
-- 1. Total Revenue Generated per Employee
-- ------------------------------------------------------------
SELECT
    e.id                                                                AS employee_id,
    CONCAT(e.first_name, ' ', e.last_name)                             AS employee_name,
    e.job_title,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS total_revenue
FROM employees e
JOIN orders o         ON e.id = o.employee_id
JOIN order_details od ON o.id = od.order_id
GROUP BY e.id, employee_name, e.job_title
ORDER BY total_revenue DESC;

-- ------------------------------------------------------------
-- 2. Number of Orders Handled per Employee
-- ------------------------------------------------------------
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COUNT(o.id)                             AS total_orders
FROM employees e
JOIN orders o ON e.id = o.employee_id
GROUP BY e.id, employee_name
ORDER BY total_orders DESC;

-- ------------------------------------------------------------
-- 3. Employee Ranking by Revenue
-- ------------------------------------------------------------
SELECT
    RANK() OVER (ORDER BY SUM(od.unit_price * od.quantity * (1 - od.discount)) DESC) AS `rank`,
    CONCAT(e.first_name, ' ', e.last_name)                                             AS employee_name,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)                   AS total_revenue
FROM employees e
JOIN orders o         ON e.id = o.employee_id
JOIN order_details od ON o.id = od.order_id
GROUP BY e.id, employee_name
ORDER BY `rank`;

-- ------------------------------------------------------------
-- 4. Average Order Value per Employee
-- ------------------------------------------------------------
SELECT
    CONCAT(e.first_name, ' ', e.last_name)                             AS employee_name,
    ROUND(AVG(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS avg_order_value
FROM employees e
JOIN orders o         ON e.id = o.employee_id
JOIN order_details od ON o.id = od.order_id
GROUP BY e.id, employee_name
ORDER BY avg_order_value DESC;

-- ------------------------------------------------------------
-- 5. Employee Sales Performance per Year
-- ------------------------------------------------------------
SELECT
    CONCAT(e.first_name, ' ', e.last_name)                             AS employee_name,
    YEAR(o.order_date)                                                  AS year,
    COUNT(o.id)                                                         AS total_orders,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2)    AS total_revenue
FROM employees e
JOIN orders o         ON e.id = o.employee_id
JOIN order_details od ON o.id = od.order_id
GROUP BY e.id, employee_name, YEAR(o.order_date)
ORDER BY employee_name, year;

-- ------------------------------------------------------------
-- 6. Manager vs Direct Report Performance
-- ------------------------------------------------------------
SELECT
    CONCAT(m.first_name, ' ', m.last_name)  AS manager,
    CONCAT(e.first_name, ' ', e.last_name)  AS employee,
    COUNT(o.id)                              AS total_orders,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue
FROM employees e
LEFT JOIN employees m  ON e.reports_to    = m.id
JOIN orders o          ON e.id            = o.employee_id
JOIN order_details od  ON o.id            = od.order_id
GROUP BY manager, employee
ORDER BY manager, total_revenue DESC;
