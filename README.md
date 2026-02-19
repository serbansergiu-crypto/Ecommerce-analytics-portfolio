# 🛒 E-Commerce Sales Analytics — Portfolio Project

> **A end-to-end data analysis project** using SQL to explore sales trends, customer behavior, and product performance across a simulated e-commerce dataset (~12,400 orders, 2023–2024).

---

## 📌 Project Overview

This project demonstrates core data analyst skills: data modeling, SQL querying, KPI analysis, and storytelling with data. It simulates a real-world scenario where a retail analytics team is tasked with understanding revenue drivers, customer segments, and retention patterns.

**Business Questions Answered:**
- What does monthly revenue look like, and where are the seasonal peaks?
- Which product categories drive the most revenue — and the most returns?
- Who are our most valuable customers, and how do we segment them?
- How well are we retaining customers after their first purchase?
- What levers could increase average order value?

---

## 🗂 Dataset Schema

The project uses a normalized relational schema with 5 tables, designed to be compatible with **PostgreSQL**, **Snowflake**, and **BigQuery**.

| Table | Description |
|---|---|
| `orders` | One row per order — date, total, status, shipping method |
| `customers` | Customer profile — name, location, signup date |
| `order_items` | Line items linking orders to products with quantity and price |
| `products` | Product catalog — category, brand, cost |
| `returns` | Return records — reason, refund amount, linked to order items |

**Key relationships:**
- `orders` → `customers` via `customer_id`
- `order_items` → `orders` via `order_id`
- `order_items` → `products` via `product_id`
- `returns` → `order_items` via `order_item_id`

---

## 🔍 SQL Techniques Demonstrated

| Query | Concepts Used |
|---|---|
| Monthly Revenue Trend | `DATE_TRUNC`, `SUM`, `GROUP BY`, `LAG()` window function, MoM growth rate |
| RFM Customer Segmentation | Multi-CTE pipeline, `NTILE()` window function, `CASE WHEN` scoring |
| Product Return Rate Analysis | `LEFT JOIN`, `HAVING`, conditional aggregation, ratio calculation |
| Cohort Retention Analysis | Self-join pattern, `DATE_DIFF`, cohort grouping, month-over-month retention |

---

## 📊 Key Findings

1. **Q4 drives 38% of annual revenue** — November alone accounts for $385K due to Black Friday and holiday demand.
2. **Electronics = high revenue, high risk** — 42% of revenue but a 14.3% return rate, nearly 3× the company average.
3. **Top 5% of customers generate 31% of revenue** — RFM segmentation reveals a highly concentrated base ideal for a loyalty program.
4. **Retention drops 60% after the first purchase** — only 16% of customers return in month 2, but those who do have a 68% chance of becoming long-term buyers.
5. **AOV grew 6.1% YoY** despite slower new customer acquisition — upsell and bundling strategies appear to be working.
6. **Free shipping threshold drives order clustering** — 22% of orders fall just above the $50 threshold, suggesting room to raise it to $65 for higher AOV.

---

## 🛠 Tools & Technologies

- **SQL** — PostgreSQL / Snowflake / BigQuery compatible syntax
- **JavaScript / Chart.js** — Interactive dashboard visualizations
- **HTML / CSS** — Dashboard layout and design

---

## 📁 Project Files

```
ecommerce-analytics-portfolio/
├── README.md                            ← You are here
├── ecommerce_portfolio_project.html     ← Interactive dashboard (open in browser)
├── ecommerce_analytics_portfolio.xlsx   ← Full dataset + KPI dashboard
├── portfolio_descriptions.md            ← LinkedIn & resume descriptions
└── sql/
    ├── 01_monthly_revenue_trend.sql
    ├── 02_rfm_segmentation.sql
    ├── 03_product_return_rate.sql
    ├── 04_cohort_retention.sql
    └── 05_category_revenue_summary.sql
```

> 💡 **Tip for recruiters:** Open `ecommerce_portfolio_project.html` in any browser to explore the live dashboard — no setup required.

---

## 🚀 How to Run the SQL Queries

1. **Generate the dataset** using a tool like [Mockaroo](https://mockaroo.com) or the included schema as a guide, or use a public e-commerce dataset from [Kaggle](https://www.kaggle.com/datasets).
2. **Load tables** into your SQL environment (PostgreSQL, BigQuery sandbox, Snowflake trial, or [Mode](https://mode.com) — all free options).
3. **Run queries** in the `/sql` folder in order — they build on each other.

---

## 💡 Potential Extensions

- Connect to a **live Kaggle dataset** (e.g., Brazilian E-Commerce by Olist) for real data
- Build a **Tableau or Power BI** version of the dashboard
- Add a **forecasting model** using Python (Prophet or statsmodels) for Q4 revenue prediction
- Create an **email churn alert** for customers in the "At Risk" RFM segment

---

## 👤 About

**[Serban Sergiu]**
Data Analyst | SQL · Python · Tableau · Dashboard Design

- 🔗 www.linkedin.com/in/sergiu-serban-48043313b
- 🐙 https://github.com/serbansergiu-crypto
- 📧 serban.sergiu@gmail.com

---

*This project was built as part of a personal data analytics portfolio. The dataset is simulated and does not represent any real company.*
