-- 1. Database Setup
-- Database Creation: The project starts by creating a database named sql_project_p1.
-- Table Creation: A table named retail_sales is created to store the sales data. 
-- The table structure includes columns for transaction ID, sale date, sale time, customer ID, 
-- gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
-- CREATE sql_project_p1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);


-- 2. Data Exploration & Cleaning
-- Record Count: Determine the total number of records in the dataset.
-- Customer Count: Find out how many unique customers are in the dataset.
-- Category Count: Identify all unique product categories in the dataset.
-- Null Value Check: Check for any null values in the dataset and delete records with missing data.


select * from retail_sales;

-- total records
select count(*) as "number of records"
from retail_sales;

-- transactions_id is a primary key
select * from retail_sales
where transactions_id is null;


-- customer_id have a duplicate values
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

-- check type of category
SELECT DISTINCT category 
FROM retail_sales;


-- checking for null records

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- now drop the null record from table

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- 3. Data Analysis & Findings
-- The following SQL queries were developed to answer specific business questions:


-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_sales
where sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales
where category = 'Clothing' and 
                 quantity >= 4 and
				 TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:

select category , sum(total_sale) as "net_sale_in_category",
count(*) as "total_order"
from retail_sales
group by category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

		-- using group by
		select avg_age from (
		select category , avg(age) as "avg_age"
		from retail_sales
		where category = 'Beauty'
		group by category) t;

        -- simple method
		SELECT
		    ROUND(AVG(age), 2) as avg_age
		FROM retail_sales
		WHERE category = 'Beauty';


-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select transactions_id , total_sale from retail_sales
where total_sale > 1000;


-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select gender , category,
count(*) as "net_transactions"
from retail_sales
group by gender , category 
order by category asc , net_transactions desc;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select * from retail_sales;


select year , month , avg_month_sales from (
select EXTRACT(year from sale_date) as "year" ,
EXTRACT(month from sale_date) as "month" ,
avg(total_sale) as "avg_month_sales",
rank() over(partition by EXTRACT(year from sale_date) order by avg(total_sale) desc ) as "rank"
from retail_sales
group by year,month
order by year asc , month asc
) t
where t.rank = 1


-- 8. Write a SQL query to find the top 5 customers based on the highest total sales **

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
-- in this using of CTE(common Table Expression)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)

SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift




				 