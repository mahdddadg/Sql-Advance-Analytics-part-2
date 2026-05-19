/* ============================================================
   Project: Product Performance & Year-Over-Year (YOY) Analysis

   Objective:
   Analyze product sales performance by comparing yearly product
   revenue against historical averages and previous year sales
   to identify growth trends, performance changes, and business insights.

   Analysis Includes:
   1. Product-Level Yearly Sales Performance
      - Calculate total yearly sales for each product

   2. Average Product Sales Benchmarking
      - Compare current yearly sales against the product's
        historical average sales performance
      - Classify products as:
          • Above Average
          • Below Average
          • Average

   3. Year-Over-Year (YOY) Analysis
      - Compare current year sales with previous year sales
      - Measure yearly growth or decline using LAG()

   4. Sales Trend Classification
      - Identify whether product sales are:
          • Increasing
          • Decreasing
          • No Change

   Dataset:
   - gold.facts_sales
   - gold.dim_products
============================================================ */

/*

we want to analyze performance of products by comparing thier sales
to both the avrage sales performnce of the products and the privous year's sales :

year over year ---- > YOY Analysis 
*/ 



with yearly_product_sales as (

select

year ( f.order_date ) as order_year ,
p.product_name ,
sum(f.sales_amount) as current_totall_sales 

from gold.facts_sales as f
left join gold.dim_products as p
on f.product_key = p.product_key

where f.order_date is not null
group by year ( f.order_date )  , p.product_name

)


select


order_year,
product_name ,
current_totall_sales ,
avg( current_totall_sales ) over ( partition by product_name ) as avg_current_totall_sales ,

current_totall_sales - avg( current_totall_sales ) over ( partition by product_name ) as digg_avg ,

case when current_totall_sales - avg( current_totall_sales ) over ( partition by product_name ) > 0 then 'Above Avrage '
when current_totall_sales - avg( current_totall_sales ) over ( partition by product_name ) < 0 then 'Below Avrage '
when current_totall_sales - avg( current_totall_sales ) over ( partition by product_name ) = 0 then ' Avrage '
else'n/a'
end as avg_change ,


--	YOY
lag(current_totall_sales ,1 ) over (partition by product_name order by order_year ) as prev_year_sales ,
current_totall_sales - lag(current_totall_sales ,1 ) over (partition by product_name order by order_year ) as diff_prev_year ,

case when current_totall_sales - lag(current_totall_sales ,1 ) over (partition by product_name order by order_year ) > 0 then 'Increasing '
when current_totall_sales - lag(current_totall_sales ,1 ) over (partition by product_name order by order_year ) < 0 then 'Decreasing '
when current_totall_sales - avg( current_totall_sales ) over ( partition by product_name ) = 0 then ' No change'
else'n/a'
end as previuous_year_change 

from yearly_product_sales
order by product_name ,order_year
