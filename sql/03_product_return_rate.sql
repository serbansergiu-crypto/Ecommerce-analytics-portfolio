-- ============================================================
-- QUERY 03: Product Performance & Return Rate Analysis
-- ============================================================
-- Purpose  : Identify top-selling products by gross revenue,
--            and flag those with high return rates that are
--            quietly eroding net revenue.
-- Skills   : JOIN, LEFT JOIN, GROUP BY, HAVING, conditional
--            aggregation (CASE WHEN inside COUNT), ratio
--            calculation, calculated margin column
-- Tables   : order_items, products, returns
-- ============================================================

SELECT
    p.product_name,
    p.category,
    p.brand,

    -- Volume
    COUNT(oi.order_item_id)                             AS units_sold,

    -- Revenue
    ROUND(SUM(oi.line_total), 2)                        AS gross_revenue,

    -- Cost & Margin
    ROUND(SUM(oi.quantity * p.unit_cost), 2)            AS total_cost,
    ROUND(
        (SUM(oi.line_total) - SUM(oi.quantity * p.unit_cost))
        / SUM(oi.line_total) * 100
    , 1)                                                AS gross_margin_pct,

    -- Returns
    COUNT(CASE WHEN r.return_id IS NOT NULL THEN 1 END) AS total_returns,

    ROUND(
        COUNT(CASE WHEN r.return_id IS NOT NULL THEN 1 END)
        * 100.0
        / NULLIF(COUNT(oi.order_item_id), 0)
    , 1)                                                AS return_rate_pct,

    -- Net revenue after refunds
    ROUND(
        SUM(oi.line_total) - COALESCE(SUM(r.refund_amount), 0)
    , 2)                                                AS net_revenue

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN returns r
    ON oi.order_item_id = r.order_item_id

WHERE p.is_active = TRUE

GROUP BY
    p.product_name,
    p.category,
    p.brand

-- Only include products with meaningful sales volume
HAVING COUNT(oi.order_item_id) > 50

ORDER BY gross_revenue DESC
LIMIT 20;


-- ============================================================
-- EXPECTED OUTPUT COLUMNS:
--   product_name      | VARCHAR | Product display name
--   category          | VARCHAR | e.g. Electronics
--   brand             | VARCHAR | Brand name
--   units_sold        | INT     | Total units across all orders
--   gross_revenue     | DECIMAL | Revenue before returns ($)
--   total_cost        | DECIMAL | Sum of unit_cost * qty ($)
--   gross_margin_pct  | DECIMAL | Margin % e.g. 42.3
--   total_returns     | INT     | Number of returned units
--   return_rate_pct   | DECIMAL | e.g. 14.3 (%)
--   net_revenue       | DECIMAL | Revenue after refunds ($)
-- ============================================================
-- KEY INSIGHT: Electronics has a 14.3% return rate — nearly
-- 3× the company average of ~5%. This erodes ~$180K in gross
-- revenue, which is invisible without this return rate query.
-- ============================================================
