/* ============================================================
   Project: Cumulative & Moving Average Sales Analysis

   Objective:
   Perform time-series sales analysis using SQL window functions
   to evaluate business growth trends, cumulative revenue, and
   moving average performance over monthly and yearly periods.

   Analysis Includes:
   1. Monthly Cumulative Sales Analysis
      - Calculate total monthly sales
      - Track running total sales over time

   2. Yearly Cumulative Sales Analysis
      - Calculate total yearly sales
      - Measure long-term revenue growth trends

   3. Monthly Moving Average Analysis
      - Compute average monthly sales values
      - Identify short-term sales trends and fluctuations
      - Combine moving averages with cumulative metrics

   4. Yearly Moving Average Analysis
      - Evaluate yearly sales stability and growth
      - Analyze long-term average revenue behavior

   SQL Concepts Used:
   - Window Functions
   - SUM() OVER()
   - AVG() OVER()
   - Running Totals
   - Moving Averages
   - Date Truncation
   - Aggregate Functions
   - Subqueries

   Dataset:
   gold.facts_sales
============================================================ */


--- calculating the total sales per month and the running total of sales over time ( cumuletice analysis ) :



select
order_date ,
totall_sales ,
sum(totall_sales ) over (partition by order_date order by order_date asc ) as runing_totall_sales 

from (


select
datetrunc(month ,order_date ) as order_date,
sum(sales_amount) as totall_sales 



from gold.facts_sales
where order_date is not null 
group by datetrunc(month ,order_date )

)t


--- calculating the total sales per year and the running total of sales over time ( cumuletice analysis ) :

select
order_date ,
totall_sales ,
sum(totall_sales ) over ( order by order_date asc ) as runing_totall_sales 

from (


select
datetrunc(year ,order_date ) as order_date,
sum(sales_amount) as totall_sales 



from gold.facts_sales
where order_date is not null 
group by datetrunc(year ,order_date )

)t

-- now let's find moving avrage of our price over month toghether with running totall: 


select
order_date ,
totall_sales ,
sum(totall_sales ) over (partition by order_date order by order_date asc ) as runing_totall_sales ,
avg(avg_sales  ) over (partition by order_date order by order_date asc ) as moving_avrage_sales  

from (


select
datetrunc(month ,order_date ) as order_date,
sum(sales_amount) as totall_sales ,
avg(sales_amount) as avg_sales 



from gold.facts_sales
where order_date is not null 
group by datetrunc(month ,order_date )

)t

-- now let's find moving avrage of our price over year toghether with running totall: 


select
order_date ,
totall_sales ,
sum(totall_sales ) over ( order by order_date asc ) as runing_totall_sales ,
avg( avg_sales  ) over ( order by order_date asc ) as moving_avrage_sales  

from (


select
datetrunc(year ,order_date ) as order_date,
sum(sales_amount) as totall_sales ,
avg(sales_amount) as avg_sales 


from gold.facts_sales
where order_date is not null 
group by datetrunc(year ,order_date )

)t
