-- Retail Customer Behavior Data Validation & SQL Analytics Project
-- SQL Practice Queries
-- Note: These queries were written using DuckDB SQL syntax.
-- The dataset was found to be highly synthetic, so these queries are used for SQL/reporting practice rather than strong business recommendations.








-- 1. Churn by Customer Value Segment
SELECT 
    p.calculated_value_segment,
    COUNT(c.customer_id) AS customer_count,
    ROUND(AVG(p.calculated_customer_value), 2) AS avg_calculated_value,
    ROUND(AVG(p.avg_transaction_value), 2) AS avg_transaction_value,
    ROUND(AVG(p.total_transactions), 2) AS avg_total_transactions,
    ROUND(AVG(c.churned_flag) * 100, 2) AS churn_rate
FROM customers c
JOIN purchase_activity p 
    ON c.customer_id = p.customer_id
GROUP BY p.calculated_value_segment
ORDER BY avg_calculated_value DESC;


-- 2. Loyalty Program Customer Value and Churn
select
c.loyalty_program,
count(*) as customer_count,
round(avg(p.calculated_customer_value),2) as avg_calculated_value,
round(avg(c.churned_flag)*100,2) as churn_rate,
round(median(p.calculated_customer_value),2) as median_calculated_value,
round(avg(p.avg_transaction_value),2) as avg_transaction_value,
round(avg(p.total_transactions),2) as avg_total_transactions,
from customers c
join purchase_activity p on c.customer_id = p.customer_id
group by c.loyalty_program
order by avg_calculated_value desc



-- 3. Income Bracket Customer Value and Churn
select
c.income_bracket,
count(*) as customer_count,
round(avg(p.calculated_customer_value),2) as avg_calculated_value,
round(avg(c.churned_flag)*100,2) as churn_rate,
round(median(p.calculated_customer_value),2) as median_calculated_value,
round(avg(p.avg_transaction_value),2) as avg_transaction_value,
round(avg(p.total_transactions),2) as avg_total_transactions,   
from customers c 
join purchase_activity p on c.customer_id = p.customer_id
group by c.income_bracket
order by avg_calculated_value desc



-- 4. Purchase Frequency Customer Value and Churn
select
b.purchase_frequency,
count(*) as customer_count,
round(median(p.calculated_customer_value),2) as median_calculated_value,
round(avg(p.calculated_customer_value),2) as avg_calculated_value,
round(avg(c.churned_flag)*100,2) as churn_rate,
round(avg(p.avg_transaction_value),2) as avg_transaction_value,
round(avg(p.total_transactions),2) as avg_total_transactions,

from customer_behavior b
join purchase_activity p
 on b.customer_id = p.customer_id
join customers c 
on b.customer_id = c.customer_id
group by b.purchase_frequency
order by avg_calculated_value desc


-- 5. Recency Segment CTE and Window Function
with recency_summary as(
    select
    CASE
    when b.days_since_last_purchase <= 30 then 'Recent'
    when b.days_since_last_purchase <= 90 then 'At risk'
    when b.days_since_last_purchase <= 180 then 'Dormant'
    else 'Inactive'
    end as recency_segment,
    count(*) as customer_count,
    round(avg(p.calculated_customer_value),2) as avg_calculated_value,
    round(median(p.calculated_customer_value),2) as median_calculated_value,
    round(avg(b.days_since_last_purchase),2) as avg_days_since_last_purchase,
    round(avg(b.customer_support_calls),2) as avg_customer_support_calls,
    round(avg(c.churned_flag)*100,2) as churn_rate

    from customer_behavior b
    join purchase_activity p on b.customer_id = p.customer_id
    join customers c on b.customer_id = c.customer_id
    group by
    CASE
    when b.days_since_last_purchase <= 30 then 'Recent'
    when b.days_since_last_purchase <= 90 then 'At risk'
    when b.days_since_last_purchase <= 180 then 'Dormant'
    else 'Inactive'
    end

)
select
recency_segment,
customer_count,
round(customer_count * 100.0/sum(customer_count) over(), 2) as percentage_of_customers, 
avg_calculated_value,
median_calculated_value,
avg_days_since_last_purchase,
avg_customer_support_calls,
churn_rate
from recency_summary
order by percentage_of_customers desc




-- 6. Product Category Ranking
    SELECT
        pr.product_category,
        COUNT(*) AS customer_count,
        ROUND(SUM(p.calculated_customer_value), 2) AS total_calculated_value,
        ROUND(AVG(p.calculated_customer_value), 2) AS avg_calculated_value,
        ROUND(MEDIAN(p.calculated_customer_value), 2) AS median_calculated_value,
        ROUND(AVG(p.avg_transaction_value), 2) AS avg_transaction_value,
        ROUND(AVG(p.total_transactions), 2) AS avg_total_transactions
    FROM product_attributes pr
    JOIN purchase_activity p
        ON pr.customer_id = p.customer_id
    GROUP BY pr.product_category
)

SELECT
    product_category,
    customer_count,
    total_calculated_value,
    avg_calculated_value,
    median_calculated_value,
    avg_transaction_value,
    avg_total_transactions,
    RANK() OVER (ORDER BY total_calculated_value DESC) AS category_value_rank
FROM category_summary
ORDER BY category_value_rank;



-- 7. Promotion Type Ranking
WITH promotion_summary AS (
    SELECT
        promo.promotion_type,
        COUNT(*) AS customer_count,
        ROUND(SUM(p.calculated_customer_value), 2) AS total_calculated_value,
        ROUND(AVG(p.calculated_customer_value), 2) AS avg_calculated_value,
        ROUND(MEDIAN(p.calculated_customer_value), 2) AS median_calculated_value,
        ROUND(AVG(promo.avg_discount_used), 2) AS avg_discount_used,
        ROUND(AVG(promo.total_discounts_received), 2) AS avg_total_discounts_received,
        ROUND(AVG(c.churned_flag) * 100, 2) AS churn_rate
    FROM promotion_attributes promo
    JOIN purchase_activity p
        ON promo.customer_id = p.customer_id
    JOIN customers c
        ON promo.customer_id = c.customer_id
    GROUP BY promo.promotion_type
)

SELECT
    promotion_type,
    customer_count,
    total_calculated_value,
    avg_calculated_value,
    median_calculated_value,
    avg_discount_used,
    avg_total_discounts_received,
    churn_rate,
    RANK() OVER (ORDER BY total_calculated_value DESC) AS promotion_value_rank
FROM promotion_summary
ORDER BY promotion_value_rank;
"""

conn.execute(promotion_ranking_query).df()