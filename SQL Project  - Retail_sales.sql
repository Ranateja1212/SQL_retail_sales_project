create database sql_project;

use sql_project;

drop table if exists retail_sales;
create table retail_sales(
transactions_id int primary key,	
sale_date date,	
sale_time time,	
customer_id	int,
gender varchar(15),	
age	int,
category varchar(15),
quantiy	int,
price_per_unit float,
cogs	float,
total_sale float
);

select * from retail_sales;

select * from retail_sales
limit 10;

select * from retail_sales
order by age desc 
limit 14;

select count(*) from retail_sales;

-- data cleaning 

select * from retail_sales
where transactions_id is null;

select * from retail_sales 
where sale_date is null;

select * from retail_sales 
where transactions_id is null 
or
sale_date is null 
or
sale_time is null 
or 
gender is null 
or 
category is null 
or 
quantiy is null 
or 
cogs is null 
or 
total_sale is null;


set sql_safe_updates = 0;
delete from retail_sales
where transactions_id is null 
or
sale_date is null 
or
sale_time is null 
or 
gender is null 
or 
category is null 
or 
quantiy is null 
or 
cogs is null 
or 
total_sale is null;


-- data exploration 

-- how many sales we have?

select count(*) as total_sales 
from retail_sales;

-- how many unique customers we have? 
select count(distinct customer_id) from retail_sales;

-- how many unique category we have ?
select count(distinct category) from retail_sales;

-- data analyst & business key problems & Answers

-- 1. write a sql query to retrive all columns for sales made on '2022-11-05'

select * from retail_sales 
where sale_date = '2022-11-05';


-- 2. Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select * from retail_sales 
where category = 'clothing' and quantiy > 10 and sale_date between '2022-11-01' and '2022-11-30';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

select category,count(total_sale) as total_sale from retail_sales;
select category,sum(total_sale) as total_sale,count(*) as total_orders  from retail_sales
group by 1;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2)  as average_age from retail_sales 
where category = 'beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales 
where total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender,category,count(*) as transaction_id from retail_sales
group by gender,category
order by 1;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
year,
month,
avg_sale 
from (
select year(sale_date) as year,
month(sale_date) as month,
avg(total_sale) as avg_sale,
rank() over(partition by year(sale_date) order by avg(total_sale)) as new_rank 
from retail_sales 
group by year,month) as t1
where new_rank = 1;


-- 8. Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,sum(total_sale) as highest_total_sales
from retail_sales
group by customer_id
order by highest_total_sales desc
limit 5;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

select category,count(distinct customer_id) as unique_cust 
from retail_sales 
group by category;


-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with t as (
select *,
case 
when hour(sale_time) < 12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon'
when hour(sale_time) > 17 then 'Evening'
else 'no status' 
end as shift 
from retail_sales)
select shift,
count(*) as number_of_orders 
from t
group by shift; 






