-- #Query 1 Top 5 funds by AUM
SELECT fund_house, aum_crore FROM fact_aum
ORDER BY aum_crore DESC
LIMIT 5;


-- #Query 2 Average NAV per month
SELECT amfi_code,strftime('%Y-%m', date) AS month, ROUND(AVG(nav),2) AS avg_nav
FROM fact_nav
GROUP BY amfi_code, strftime('%Y-%m', date)
ORDER BY amfi_code, month;


-- #Query 3 SIP inflow YoY growth
SELECT month, sip_inflow_crore, yoy_growth_pct
FROM fact_sip_industry
ORDER BY month;


-- #Query 4 Transactions by state
SELECT state, COUNT(*) AS total_transactions, SUM(amount_inr) AS total_amount
FROM fact_transaction
GROUP BY state
ORDER BY total_amount DESC;


-- #Query 5 Funds with expense ratio <1%
SELECT scheme_name, fund_house, expense_ratio_pct
FROM dim_fund
WHERE expense_ratio_pct < 1;

-- #Query 6 Top performing funds (5-year return)
SELECT amfi_code, return_5yr_pct
FROM fact_performance
ORDER BY return_5yr_pct DESC
LIMIT 10;

-- #Query 7 Average expense ratio by category
SELECT
    category,
    ROUND(AVG(expense_ratio_pct),2) AS avg_expense
FROM dim_fund
GROUP BY category;

-- #Query 8 Sector allocation
SELECT
    sector,
    ROUND(SUM(weight_pct),2) AS total_weight
FROM fact_portfolio
GROUP BY sector
ORDER BY total_weight DESC;

-- #Query 9 Highest NAV for each fund
SELECT
    amfi_code,
    MAX(nav) AS highest_nav
FROM fact_nav
GROUP BY amfi_code;

-- #Query 10 Average transaction amount by payment mode
SELECT
    payment_mode,
    ROUND(AVG(amount_inr),2) AS avg_amount
FROM fact_transaction
GROUP BY payment_mode;