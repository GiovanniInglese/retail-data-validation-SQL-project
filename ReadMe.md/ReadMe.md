# Retail Customer Behavior Data Validation & SQL Analytics Project

## Project Overview

This project analyzes a 1,000,000-row retail customer behavior dataset using Python, SQL, and Excel. The original goal was to explore customer value, churn risk, product performance, promotion performance, and customer engagement patterns.

After completing detailed data validation, the dataset was found to be highly synthetic and evenly distributed. Because of this, the project was reframed as a **data validation, SQL analytics, and reporting practice project** rather than a project focused on making strong business recommendations.

The final workflow includes:

* Python data inspection and validation
* Dataset grain and primary key analysis
* Feature engineering
* SQL-style analytical table creation
* DuckDB SQL practice queries
* CSV summary exports
* Excel dashboard creation

## Business Context

The initial business questions were:

1. Which customer segments generate the highest customer value?
2. How does churn differ by loyalty program status, income bracket, purchase frequency, and engagement level?
3. Which behavioral factors are associated with churn?
4. Which product categories, brands, and promotions are associated with higher customer value?
5. Can the dataset support churn prediction or customer risk analysis?

During validation, the data showed very weak relationships between churn and the available features, which changed the direction of the project.

## Tools Used

* Python
* Pandas
* NumPy
* Jupyter Notebook
* DuckDB SQL
* Excel
* Git / GitHub

## Key Data Validation Findings

The most important part of this project was validating the structure and reliability of the dataset before making conclusions.

Main findings:

* `customer_id` was the only reliable unique row identifier.
* `transaction_id` was not a reliable transaction-level primary key.
* Repeated `transaction_id` values were linked to multiple customers, products, dates, and sales values.
* `product_id`, `promotion_id`, and `store_location` were not reliable clean keys.
* `total_sales` did not align with `avg_transaction_value` and `total_transactions`.
* The `churned` field remained close to 50% across nearly all customer, product, promotion, loyalty, income, frequency, and engagement groups.
* Numeric and categorical churn signal scans showed little to no meaningful relationship between churn and the available features.

Because of these findings, the dataset should not be used to make strong business claims about churn, product performance, promotion effectiveness, or customer loyalty.

## Feature Engineering

Because the original `total_sales` field did not behave logically with transaction fields, a new behavior-based value metric was created:

```python
calculated_customer_value = avg_transaction_value * total_transactions
```

Customers were then segmented into:

* Low Calculated Value
* Medium Calculated Value
* High Calculated Value

This calculated metric produced more logical customer value groups than the original `total_sales` column.

## SQL-Style Table Creation

The original dataset was a single flat file. To practice SQL workflows, it was split into SQL-style analytical tables:

* `customers`
* `customer_behavior`
* `purchase_activity`
* `product_attributes`
* `promotion_activity`
* `location_attributes`

These tables were created for analytical practice and reporting, not as a perfectly normalized production database.

Most joins were performed using `customer_id`, since it was the only reliable unique identifier.

## SQL Practice Topics

The project includes SQL practice queries covering:

* `JOIN`
* `GROUP BY`
* `COUNT`
* `AVG`
* `MEDIAN`
* `SUM`
* `CASE WHEN`
* CTEs
* Window functions
* `RANK()`
* Percent-of-total calculations
* Customer segmentation
* Churn-rate calculations
* Dashboard/reporting summaries

Example analysis questions answered with SQL:

* Which customer value segments have the highest average customer value?
* How does churn compare by loyalty program status?
* How does customer value compare by income bracket?
* What percentage of customers fall into each recency segment?
* Which product categories rank highest by total calculated customer value?
* Which promotion types rank highest by total calculated customer value?

## Excel Dashboard

An Excel reporting dashboard was created from SQL-exported summary tables.

Dashboard link: [View Excel Dashboard](https://1drv.ms/x/c/f8070e33c8f3b0b1/IQAGHaYhXVMvQIplmdMIy0gRAatEXL45WL0h8lxjt2_Siwk?e=0Lflel)

The dashboard includes:

* KPI cards
* Product category value chart
* Recency segment distribution chart
* Customer value segment chart
* Data quality notes

The dashboard is intended for Excel, SQL, and reporting practice rather than strong business decision-making because the dataset was found to be synthetic and evenly distributed.

## Main Project Conclusion

This project demonstrates the importance of validating data before building dashboards or predictive models.

Although the dataset appeared useful for customer behavior and churn analysis, deeper validation showed that many fields were synthetic, evenly distributed, or weakly connected. The most valuable outcome of the project was identifying these limitations and adjusting the analysis approach accordingly.

The project is best viewed as a demonstration of:

* Data inspection
* Data validation
* Primary key analysis
* Feature engineering
* SQL table design
* SQL querying
* Excel dashboard preparation
* Honest analytical communication

## Repository Structure

```text
Retail Sales and Customer Behavior Intelligence Analysis/
│
├── Exports/
│   ├── customer_value_segment_summary.csv
│   ├── product_category_ranking.csv
│   ├── promotion_type_ranking.csv
│   ├── recency_segment_summary.csv
│   └── other SQL export files
│
├── Notebook/
│   └── Data_inspection_and_cleaning.ipynb
│
├── SQL/
│   └── practice_queries.sql
│
├── .gitignore
└── ReadMe.md
```

## Notes

The raw Kaggle dataset and large processed files are not included in this repository because of file size and storage limitations. The notebook documents the full validation and analysis process, while the exported CSV files support Excel dashboard practice.
