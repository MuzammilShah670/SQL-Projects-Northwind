# 🗄️ SQL Projects — Northwind

A MySQL-based data analysis project built on the classic **Northwind** sample database. This project explores the database schema, writes analytical SQL queries, and builds stored procedures to extract meaningful business insights — all complemented by an interactive **Power BI dashboard**.

---

## 📌 Project Overview

The Northwind database simulates a fictional trading company that imports and exports specialty foods worldwide. It contains data on customers, orders, products, employees, suppliers, and shippers — making it an excellent dataset for practicing real-world SQL analysis and business reporting.

This project covers:
- Understanding and mapping the Northwind database schema
- Writing analytical queries to uncover sales trends and business performance
- Building reusable stored procedures for common reporting tasks
- Visualizing key metrics through a Power BI dashboard

---

## 🗂️ Database Schema

The Northwind database consists of the following core tables:

| Table | Description |
|---|---|
| `Customers` | Customer details and contact information |
| `Orders` | Order records linked to customers and employees |
| `Order Details` | Line items per order including quantity and price |
| `Products` | Product catalog with pricing and stock levels |
| `Categories` | Product category groupings |
| `Suppliers` | Supplier information for products |
| `Employees` | Employee records and reporting hierarchy |
| `Shippers` | Shipping company details |

---

## 🔍 Queries & Analysis

### 1. Sales Performance
- Total revenue generated per year and per quarter
- Month-over-month sales growth trends
- Top 10 best-selling products by revenue and quantity

### 2. Customer Analysis
- Top customers by total order value
- Customer order frequency and average order size
- Customers with no recent orders (churn detection)

### 3. Employee Performance
- Sales revenue attributed per employee
- Number of orders handled per employee
- Employee ranking by performance

### 4. Product & Inventory Analysis
- Products with low stock levels
- Revenue contribution by product category
- Most discounted products and impact on revenue

### 5. Supplier & Shipping Insights
- Orders grouped by shipping company
- Average shipping time per shipper
- Supplier contribution to product catalog

### 6. Stored Procedures
- `GetCustomerOrders(CustomerID)` — Returns all orders for a given customer
- `GetTopProducts(N)` — Returns the top N products by revenue
- `GetSalesByEmployee(EmployeeID)` — Returns sales summary for a specific employee
- `GetRevenueByCategory()` — Returns total revenue broken down by product category

---

## 📊 Power BI Dashboard

An interactive Power BI dashboard has been built on top of this data to provide visual business intelligence. Key dashboard pages include:

- **Sales Overview** — Total revenue, order count, and trend lines over time
- **Customer Insights** — Top customers and geographic distribution
- **Product Performance** — Category-wise revenue breakdown and top products
- **Employee Report** — Individual employee sales performance

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **MySQL** | Database engine and query execution |
| **MySQL Workbench** | Schema design and query development |
| **Power BI** | Data visualization and dashboard |

---

## 🚀 Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/sql-projects-northwind.git
   ```
2. Import the Northwind database into your MySQL instance using the provided `.sql` file.
3. Open the query files in MySQL Workbench or any SQL client.
4. Open the `.pbix` file in Power BI Desktop to explore the dashboard.

---

## 📁 Repository Structure

```
sql-projects-northwind/
│
├── schema/
│   └── northwind_schema.sql       # Database creation script
│
├── queries/
│   ├── sales_analysis.sql
│   ├── customer_analysis.sql
│   ├── employee_performance.sql
│   ├── product_inventory.sql
│   └── supplier_shipping.sql
│
├── stored_procedures/
│   └── procedures.sql
│
├── dashboard/
│   └── northwind_dashboard.pbix   # Power BI dashboard file
│
└── README.md
```

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
