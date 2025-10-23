-- creating the table 

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- checking the dataset

SELECT *
FROM retail_sales
LIMIT 10;


-- Exploratory Analysis

-- Find total sales and number of transactions per month
SELECT
    DATE_TRUNC('month', sale_date) AS month,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;

-- Find daily total and average sales
SELECT
    sale_date,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_transactions,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_sale_per_transaction
FROM retail_sales
GROUP BY sale_date
ORDER BY sale_date;

-- Find which day of week has highest average sales
SELECT
    TO_CHAR(sale_date, 'Day') AS day_of_week,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_sales
FROM retail_sales
GROUP BY TO_CHAR(sale_date, 'Day')
ORDER BY avg_sales DESC;

-- Find which hour of the day has the highest total sales
SELECT
    EXTRACT(HOUR FROM sale_time) AS hour_of_day,
    ROUND(SUM(total_sale)::numeric, 2) AS total_sales
FROM retail_sales
GROUP BY EXTRACT(HOUR FROM sale_time)
ORDER BY total_sales DESC;

-- Top 5 customers by total spending
SELECT
    customer_id,
    gender,
    SUM(total_sale) AS total_spent,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY customer_id, gender
ORDER BY total_spent DESC
LIMIT 5;


-- Category-wise total sales and average order value
SELECT
    category,
    SUM(total_sale) AS total_sales,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_order_value,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;


-- Gender-wise purchasing behaviour
SELECT
    gender,
    COUNT(*) AS total_transactions,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_sale,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY gender
ORDER BY total_sales DESC;

-- Calculate profit and profit margin per transaction
SELECT
    transactions_id,
    category,
    total_sale,
    cogs,
    (total_sale - cogs) AS profit,
    ROUND(((total_sale - cogs) / cogs)::numeric * 100, 2) AS profit_margin_percent
FROM retail_sales
ORDER BY profit DESC
LIMIT 10;


-- Average profit margin by category
SELECT
    category,
    ROUND(AVG((total_sale - cogs) / cogs * 100)::numeric, 2) AS avg_profit_margin_percent,
    SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY avg_profit_margin_percent DESC;


-- Relationship between quantity sold and profit
SELECT
    category,
    SUM(quantity) AS total_quantity_sold,
    SUM(total_sale - cogs) AS total_profit,
    ROUND(AVG((total_sale - cogs) / cogs * 100)::numeric, 2) AS avg_profit_margin_percent
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

-- Identify the most profitable month overall
SELECT
    TO_CHAR(sale_date, 'Month') AS month_name,
    SUM(total_sale - cogs) AS total_profit,
    ROUND(AVG((total_sale - cogs) / cogs * 100)::numeric, 2) AS avg_profit_margin_percent
FROM retail_sales
GROUP BY TO_CHAR(sale_date, 'Month')
ORDER BY total_profit DESC;

-- Check if weekends perform better than weekdays
SELECT
    CASE
        WHEN EXTRACT(ISODOW FROM sale_date) IN (6, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM(total_sale) AS total_sales,
    SUM(total_sale - cogs) AS total_profit,
    ROUND(AVG((total_sale - cogs) / cogs * 100)::numeric, 2) AS avg_profit_margin_percent
FROM retail_sales
GROUP BY day_type
ORDER BY total_profit DESC;

-- See average order value by month (seasonal trend)
SELECT
    DATE_TRUNC('month', sale_date) AS month,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_order_value
FROM retail_sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;







