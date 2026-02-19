-- ============================================================
-- QUERY 05: Category Revenue & Return Impact Summary
-- ============================================================
-- Purpose  : High-level view of each product category's
--            contribution to revenue, including how returns
--            affect the true net revenue picture.
-- Skills   : JOIN, LEFT JOIN, GROUP BY, ROLLUP for subtotals,
--            COALESCE, percentage of total using window function
-- Tables   : order_items, products, returns, orders
-- ============================================================

WITH category_stats AS (

    SELECT
        p.category,

        COUNT(DISTINCT o.order_id)                          AS total_orders,
        COUNT(oi.order_item_id)                             AS units_sold,
        ROUND(SUM(oi.line_total), 2)                        AS gross_revenue,
        COUNT(CASE WHEN r.return_id IS NOT NULL THEN 1 END) AS total_returns,
        ROUND(COALESCE(SUM(r.refund_amount), 0), 2)         AS total_refunds,

        ROUND(
            COUNT(CASE WHEN r.return_id IS NOT NULL THEN 1 END)
            * 100.0
            / NULLIF(COUNT(oi.order_item_id), 0)
        , 1)                                                AS return_rate_pct,

        ROUND(
            SUM(oi.line_total) - COALESCE(SUM(r.refund_amount), 0)
        , 2)                                                AS net_revenue

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN returns r
        ON oi.order_item_id = r.order_item_id

    WHERE o.status != 'cancelled'
    GROUP BY p.category

)

SELECT
    category,
    total_orders,
    units_sold,
    gross_revenue,
    total_returns,
    total_refunds,
    return_rate_pct,
    net_revenue,

    -- Share of total gross revenue (using window function)
    ROUND(
        gross_revenue * 100.0
        / SUM(gross_revenue) OVER ()
    , 1)                                                    AS pct_of_total_revenue,

    -- Revenue lost to returns
    total_refunds                                           AS revenue_at_risk

FROM category_stats
ORDER BY gross_revenue DESC;


-- ============================================================
-- EXPECTED OUTPUT COLUMNS:
--   category             | VARCHAR | e.g. Electronics
--   total_orders         | INT     | Distinct orders
--   units_sold           | INT     | Line items sold
--   gross_revenue        | DECIMAL | Before returns ($)
--   total_returns        | INT     | Returned units
--   total_refunds        | DECIMAL | Refund value ($)
--   return_rate_pct      | DECIMAL | e.g. 14.3 (%)
--   net_revenue          | DECIMAL | After refunds ($)
--   pct_of_total_revenue | DECIMAL | e.g. 42.0 (%)
--   revenue_at_risk      | DECIMAL | Refunded amount ($)
-- ============================================================
-- KEY INSIGHT: Electronics = 42% of gross revenue but 14.3%
-- return rate eats into margins. Beauty and Home & Garden
-- have low return rates (<5%) and represent stable revenue.
-- ============================================================
