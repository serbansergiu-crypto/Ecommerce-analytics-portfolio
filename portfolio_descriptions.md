**E-Commerce Sales Analytics**
SQL · Business Intelligence · Dashboard

An end-to-end analytics project built to showcase SQL fluency and data storytelling skills. Covers revenue trend analysis, RFM customer segmentation, product return rate tracking, and cohort retention — presented in a live interactive dashboard. Designed around a realistic 5-table relational schema to mirror real-world data warehouse environments.

---


### The Problem
An e-commerce company is growing — but leadership doesn't know *why*. Revenue is up 18%, but customer retention is quietly slipping. Which customers matter most? Which products are quietly costing us money? Where does revenue actually come from?

### The Approach
I modeled a realistic e-commerce data warehouse with five interconnected tables: orders, customers, products, order items, and returns. Then I built a suite of SQL queries designed to answer the questions that matter to a business.

**Monthly Revenue Trend:** Using `DATE_TRUNC` and the `LAG()` window function, I tracked month-over-month growth and identified Q4 as the company's make-or-break quarter — contributing 38% of annual revenue.

**RFM Segmentation:** I scored every customer across Recency, Frequency, and Monetary value using `NTILE()` window functions across a multi-CTE pipeline. The result: a clear customer hierarchy from "Champions" (9.2 orders/year, $1,840 LTV) to "At Risk" customers who haven't been back in months.

**Return Rate Analysis:** A `LEFT JOIN` between order items and returns revealed that Electronics — the top revenue category — carries a 14.3% return rate. That's nearly 3× the company average and represents roughly $180K in eroded margin.

**Cohort Retention:** A self-join cohort model showed that only 16% of customers return in month 2. But customers who *do* come back have a 68% chance of becoming long-term buyers — a compelling case for a targeted re-engagement campaign.

### The Output
All findings are presented in a fully interactive dashboard — built with HTML, CSS, and Chart.js — with no setup required. Just open the file in a browser.

### What I Learned
Good analysis isn't just about writing correct SQL — it's about framing the right question. The free shipping threshold finding (22% of orders clustering just above $50) came from looking at the *distribution* of order values, not just the average. That's the kind of detail that drives real business decisions.

