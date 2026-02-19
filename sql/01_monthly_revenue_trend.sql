-- ============================================================
-- QUERY 01: Monthly Revenue Trend with MoM Growth Rate
-- ============================================================
-- Purpose  : Track total revenue and order volume by month,
--            and calculate month-over-month growth rate.
-- Skills   : DATE_TRUNC, SUM, COUNT, LAG() window function,
--            arithmetic for growth rate, CTE
-- Tables   : orders
-- ============================================================

WITH monthly AS (

    SELECT
        DATE_TRUNC('month', order_date)     AS month,
        COUNT(order_id)                     AS total_orders,
        ROUND(SUM(order_total), 2)          AS revenue

    FROM orders
    WHERE status != 'cancelled'
    GROUP BY 1

)

SELECT
    month,
    total_orders,
    revenue,

    -- Month-over-month revenue change in dollars
    revenue - LAG(revenue) OVER (ORDER BY month)    AS mom_revenue_change,

    -- Month-over-month growth as a percentage
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month) * 100
    , 1)                                            AS mom_growth_pct

FROM monthly
ORDER BY month;


-- ============================================================
-- EXPECTED OUTPUT COLUMNS:
--   month            | DATE     | e.g. 2024-01-01
--   total_orders     | INT      | e.g. 738
--   revenue          | DECIMAL  | e.g. 168200.00
--   mom_revenue_change | DECIMAL | e.g. -26100.00
--   mom_growth_pct   | DECIMAL  | e.g. -15.5 (%)
-- ============================================================
-- KEY INSIGHT: November and December drive the highest revenue,
-- accounting for ~38% of the full year total.
-- ============================================================
