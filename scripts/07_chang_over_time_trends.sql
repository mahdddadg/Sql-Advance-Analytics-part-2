/* ============================================================
   Project: Advanced Sales Performance Analysis
   Objective:
   Analyze sales trends over time using yearly and monthly
   aggregations to identify growth patterns, customer activity,
   product demand, and seasonal business behavior.

   Key Metrics:
   - Total Sales Revenue
   - Total Customers
   - Total Quantity Sold

   Analysis Includes:
   1. Yearly Sales Performance
   2. Monthly Seasonality Analysis
   3. Year-Month Trend Analysis
   4. Formatted Time-Based Reporting

   Dataset:
   gold.facts_sales
============================================================ */



--  1) analyze the sales performance over time .




-- by year 

select

year (order_date) as years ,
sum (sales_amount) as totall_sales ,
count( distinct customer_key ) as totall_customers ,
sum(quality) as totall_quantity

from gold.facts_sales
where year (order_date) is not null
group by year (order_date)
order by year (order_date)

--by month ( for all 5 years ) to check up seasonality of out data .



select

month (order_date) as months ,
sum (sales_amount) as totall_sales ,
count( distinct customer_key ) as totall_customers ,
sum(quality) as totall_quantity

from gold.facts_sales
where month (order_date) is not null
group by month (order_date)
order by month (order_date) desc



-- with both year and month : 


select

datefromparts (year (order_date),month (order_date),1) date ,
sum (sales_amount) as totall_sales ,
count( distinct customer_key ) as totall_customers ,
sum(quality) as totall_quantity

from gold.facts_sales
where datefromparts (year (order_date),month (order_date),1) is not null
group by datefromparts (year (order_date),month (order_date),1)
order by datefromparts (year (order_date),month (order_date),1) desc


-- also we can have : 


select

format (order_date,'yyyy-MMM')as order_date ,
sum (sales_amount) as totall_sales ,
count( distinct customer_key ) as totall_customers ,
sum(quality) as totall_quantity

from gold.facts_sales
where format (order_date,'yyyy-MMM') is not null
group by format (order_date,'yyyy-MMM')
order by format (order_date,'yyyy-MMM') desc
