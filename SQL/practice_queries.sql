# Comprehensive customer value analysis by segment
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



# Customer value analysis by loyalty program

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




# Customer value analysis by loyalty program with median value
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



# Customer value analysis by purchase frequency

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


# Customer value analysis by recency segments using CTE's

Select
case
when b.days_since_last_purchase <= 30 then 'Recent'
when b.days_since_last_purchase <= 90 then 'At risk'
when b.days_since_last_purchase <= 180 then 'Dormant'
else 'Inactive'
end as recency_segment,
count(*) as customer_count,
round(median(p.calculated_customer_value),2) as median_calculated_value,
round(avg(p.calculated_customer_value),2) as avg_calculated_value,
round(avg(c.churned_flag)*100,2) as churn_rate,
round(avg(b.days_since_last_purchase),2) as avg_days_since_last_purchase,
round(avg(b.customer_support_calls),2) as avg_customer_support_calls,
from customer_behavior b
join purchase_activity p on b.customer_id = p.customer_id
join customers c on b.customer_id = c.customer_id
group by recency_segment
order by avg_calculated_value desc





# Customer value analysis by product category with ranking

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



# Customer value analysis by promotion type with ranking

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