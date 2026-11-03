CREATE DATABASE ecommerce_analytics_db

USE ecommerce_analytics_db;

-- 1. Check total rows loaded
SELECT COUNT(*) AS total_rows FROM ecommerce_master_final;

-- 2. View top 5 rows
SELECT * FROM ecommerce_master_final LIMIT 5;

-- 3. Customer Churn Segmentation Query
SELECT 
    customer_id,
    customer_name,
    MAX(order_date) AS last_order_date,
    COUNT(order_id) AS total_orders,
    CASE 
        -- If a customer hasn't ordered in the last 6 months (180 days), classify as Churned
        WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 180 THEN 'Churned Customer'
        ELSE 'Active Customer'
    END AS customer_status
FROM ecommerce_master_final
GROUP BY customer_id, customer_name;

-- ==========================================
-- # 4. Overall Churn Rate Summary Query
-- ==========================================
SELECT 
    customer_status,
    COUNT(customer_id) AS total_customers,
    ROUND(COUNT(customer_id) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM ecommerce_master_final), 2) AS percentage
FROM (
    SELECT 
        customer_id,
        CASE 
            WHEN DATEDIFF(CURDATE(), MAX(order_date)) > 180 THEN 'Churned Customer'
            ELSE 'Active Customer'
        END AS customer_status
    FROM ecommerce_master_final
    GROUP BY customer_id
) AS churn_summary
GROUP BY customer_status;


-- ==========================================
-- # 5. Customer Retention & Repeat Purchase Analysis
-- ==========================================
SELECT 
    customer_id,
    customer_name,
    COUNT(order_id) AS total_orders,
    SUM(total_revenue) AS total_spent,
    CASE 
        WHEN COUNT(order_id) = 1 THEN 'One-Time Buyer'
        WHEN COUNT(order_id) BETWEEN 2 AND 5 THEN 'Repeat Customer'
        ELSE 'Loyal/Frequent Customer'
    END AS customer_segment_type
FROM ecommerce_master_final
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC;