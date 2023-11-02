USE ecommerce;

DROP TABLE IF EXISTS ecomm;

CREATE TABLE ecomm(
	  invoice_no INT NOT NULL
	, stock_code TEXT
    , description TEXT
    , invoice_date DATETIME
	, quantity INT
    , unit_price DECIMAL(8,2)
    , revenue DECIMAL(10,2)
    , country TEXT
    , order_status TEXT
    );

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce_v4.csv'
	INTO TABLE ecomm
FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* 
Case Study Excercise
- clean ecommerce data
- summarise sale figures for 2011
- create a dashboard to present sales figures, with the following questions in mind:
    1. What is our order fulfilment, orders vs cancellation?
    2. Who are our main customers?
    3. Where to place our focus for the next year?
    4. Devise a marketing strategy to increase sales
*/

-- Explanatory data analysis --
-- Finding date range
SELECT 
	  MIN(invoice_date) AS start_date
	, MAX(invoice_date) AS end_date
FROM ecomm; -- we will use date range of invoice data obtained between 2010-12-01 and 2011-12-01

-- Amount of distinct orders
SELECT 
	  COUNT(DISTINCT(invoice_no)) AS orders
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'; -- total of 22242 completed orders in 2011

-- Data Analysis --
-- Find percentage of cancelled order
SELECT 
	  order_status
	, ROUND(COUNT(order_status)*100/(SELECT COUNT(*) FROM ecomm WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'), 2) AS percent
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY order_status; -- 1.63% cancellation

-- Who are our main customers
-- Distinct orders by demography
SELECT 
	  country
	, COUNT(DISTINCT(invoice_no)) AS orders
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY country
ORDER BY orders DESC
LIMIT 15; 

-- Revenue based on customer demographic
SELECT 
	  country
	, SUM(revenue) AS total_revenue
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 15; -- Main customer base within europe. ASEAN region still have room to develop customer base. Expansion should still be kept within europe for the time being as there remains opportunity for other products

-- What to focus on for the next year
-- Best performing sales by product description
SELECT 
	  description
	, SUM(revenue) AS total_revenue
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY description
ORDER BY total_revenue DESC
LIMIT 15;

-- Marketing Strategy
-- Based on the 4p's of marketing mix, we have established top performing products to launch promotions on. We will now solve for place/when to launch our promotions
-- months
WITH monthly_revenue AS 
	(
		SELECT 
			  MONTH(invoice_date) AS month
			, SUM(revenue) AS total_revenue
		FROM ecomm
		WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
		GROUP BY month
        )
SELECT *
FROM monthly_revenue
WHERE monthly_revenue.total_revenue > (SELECT ROUND(AVG(monthly_revenue.total_revenue), 2) FROM monthly_revenue); 
-- ecommerce sales picked up from September to the end of year. Thus would be better to launch more year end promotions

WITH daily_revenue AS 
	(
		SELECT 
			  WEEKDAY(invoice_date) AS day
			, SUM(revenue) AS total_revenue
		FROM ecomm
		WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
		GROUP BY day
		ORDER BY day ASC
        )
SELECT *
FROM daily_revenue
WHERE daily_revenue.total_revenue > (SELECT ROUND(AVG(daily_revenue.total_revenue), 2) FROM daily_revenue);
-- Tuesday, Wednesday and Thursdays had the best performing days to capture more sales

-- Additional information
-- Quarterly earnings  
SELECT 
	  quarter(invoice_date) AS quarter
    , SUM(revenue) AS revenue
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY quarter
ORDER BY quarter; 
-- steady growth QOQ in 2011; with the later months showing stronger growth

-- Quarterly Order Frequency report
SELECT
	  quarter(invoice_date) AS quarter
	, COUNT(DISTINCT(invoice_no)) AS orders
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY quarter; -- QOQ growth in order frequency
