-- ============================================================
-- QUERY 04: Cohort Retention Analysis
-- ============================================================
-- Purpose  : Group customers by the month they first purchased
--            (cohort), then measure what % of each cohort
--            returns to buy again in subsequent months.
-- Skills   : Multi-CTE, DATE_TRUNC, MIN() for first purchase,
--            DATEDIFF for cohort month numbering, COUNT DISTINCT,
--            percentage calculation vs cohort size
-- Tables   : orders
-- ============================================================

-- STEP 1: Identify each customer's first-ever purchase month
WITH cohorts AS (

    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date))    AS cohort_month

    FROM orders
    WHERE status != 'cancelled'
    GROUP BY customer_id

),

-- STEP 2: For every order, calculate how many months after
-- the customer's cohort month it occurred
activity AS (

    SELECT
        o.customer_id,
        c.cohort_month,
        DATE_TRUNC('month', o.order_date)           AS order_month,

        -- Month number: 0 = first purchase month, 1 = one month later, etc.
        DATEDIFF(
            'month',
            c.cohort_month,
            DATE_TRUNC('month', o.order_date)
        )                                           AS month_number

    FROM orders o
    JOIN cohorts c
        ON o.customer_id = c.customer_id
    WHERE o.status != 'cancelled'

),

-- STEP 3: Count distinct returning customers per cohort per month
cohort_counts AS (

    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_id)                 AS customers

    FROM activity
    GROUP BY cohort_month, month_number

),

-- STEP 4: Get cohort size (month_number = 0 is always 100%)
cohort_sizes AS (

    SELECT
        cohort_month,
        customers                                   AS cohort_size

    FROM cohort_counts
    WHERE month_number = 0

)

-- STEP 5: Final output — retention count and percentage
SELECT
    cc.cohort_month,
    cc.month_number,
    cc.customers                                    AS retained_customers,
    cs.cohort_size,

    ROUND(
        cc.customers * 100.0 / cs.cohort_size
    , 1)                                            AS retention_pct

FROM cohort_counts cc
JOIN cohort_sizes cs
    ON cc.cohort_month = cs.cohort_month

ORDER BY
    cc.cohort_month,
    cc.month_number;


-- ============================================================
-- EXPECTED OUTPUT COLUMNS:
--   cohort_month       | DATE    | First purchase month
--   month_number       | INT     | 0 = acquisition month
--   retained_customers | INT     | Customers who returned
--   cohort_size        | INT     | Original cohort size
--   retention_pct      | DECIMAL | e.g. 41.2 (%)
-- ============================================================
-- HOW TO READ IT:
--   cohort_month = 2024-01, month_number = 0 → 100% (acquisition)
--   cohort_month = 2024-01, month_number = 1 → 41% (returned month 2)
--   cohort_month = 2024-01, month_number = 2 → 16% (returned month 3)
-- ============================================================
-- KEY INSIGHT: Retention drops 60% from month 1 to month 2.
-- But customers who DO return in month 2 have a 68% chance
-- of becoming long-term buyers — a strong re-engagement signal.
-- ============================================================
