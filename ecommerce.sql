USE ecommerce;

DROP TABLE IF EXISTS ecomm;

CREATE TABLE ecomm(
	  invoice_no TEXT NOT NULL
	, stock_code TEXT
    , descript TEXT
    , quantity INT
    , invoice_date DATETIME
    , unit_price DECIMAL(8,2)
    , customerid TEXT
    , country TEXT
    );

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dataset.csv'
	INTO TABLE ecomm
FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* 
Build a dashboard for stakeholders to identify:
1. Which area of the business to focus on for the next year
2. Who are our main customers
3. Are there any irregularities in our cancellation orders
*/

-- Explanatory data analysis --
-- Finding if missing data present
SELECT 
	  COUNT(*) AS missing_values
FROM ecomm
WHERE invoice_no IS NULL OR unit_price IS NULL OR quantity IS NULL OR customerid IS NULL OR country IS NULL OR invoice_date IS NULL; -- no missing values 

-- Understanding customer base
SELECT 
	  COUNT(DISTINCT(invoice_no)) AS orders
FROM ecomm; -- total of 25900 completed orders in 2011

SELECT COUNT(DISTINCT(customerid))
FROM ecomm;

-- Checking for irregular values by column
SELECT stock_code
FROM ecomm
WHERE stock_code NOT REGEXP '[0-9]{5,}'; -- includes other fees ie postage, subscription etc, row data will impact our sales only report; 2,995 

SELECT COUNT(*)
FROM ecomm
WHERE quantity <= 0; -- negative quantities indicate cancelled orders but should be excluded to filter sales data; 10,624

SELECT DISTINCT(unit_price)
FROM ecomm
WHERE unit_price <= 0; -- 0 and negative unit prices skewing sales data

SELECT COUNT(*)
FROM ecomm
WHERE unit_price <= 0; -- 2,521 values

SELECT COUNT(customerid)
FROM ecomm
WHERE customerid = 0; -- 135,080 missing customerid, not primary concern because the invoice_no is the main identifier value

-- Understanding time period used 
SELECT 
	  MIN(invoice_date) AS start_date
	, MAX(invoice_date) AS end_date
FROM ecomm; -- 2011 invoice/sales data

-- Data Cleaning -- 
DELETE FROM ecomm 
WHERE stock_code NOT REGEXP '[0-9]{5,}';

DELETE FROM ecomm 
WHERE unit_price <= 0;
-- negative quantities were kept to show loss in revenue due to cancellation or unfulfilled orders

-- Data Analysis --
-- Add revenue column
ALTER TABLE ecomm
	ADD revenue DECIMAL(8,2)
		AFTER unit_price;
UPDATE ecomm SET revenue = (quantity*unit_price);

-- Find percentage of cancelled order
SELECT
		confirmation
	  , count*100/SUM(count) OVER()
FROM (
		SELECT 
			  CASE
				WHEN invoice_no NOT LIKE 'c%' THEN 'orders'
				ELSE 'cancellation'
			  END AS confirmation
			, COUNT(*) AS count
		FROM ecomm
		GROUP BY confirmation
        ) AS percentage; -- 1.6% cancellation orders

-- Revenue based on customer demographic
SELECT 
	  country
	, SUM(revenue) AS total_revenue
FROM ecomm
WHERE revenue > 0 AND year(invoice_date) = '2011'
GROUP BY country
ORDER BY total_revenue DESC; -- Main customer base within europe. ASEAN region still have room to develop customer base. Expansion should still be kept within europe for the time being as there remains opportunity for other markets

-- quarterly earnings  
SELECT 
	  quarter(invoice_date) AS quarter
    , SUM(revenue) AS revenue
FROM ecomm
WHERE revenue > 0 AND year(invoice_date) = '2011'
GROUP BY quarter; -- steady growth QOQ in 2011, projection for final quarter should be higher but data only recorded for first 9 days in December

SELECT
	  quarter(invoice_date) AS quarter
	, COUNT(DISTINCT(customerid))
FROM ecomm
WHERE revenue > 0 AND year(invoice_date) = '2011'
GROUP BY quarter; -- QOQ growth in customer base

SELECT
	  descript
	, SUM(quantity) AS quantity
FROM ecomm
WHERE revenue > 0 AND year(invoice_date) = '2011'
GROUP BY descript
ORDER BY quantity DESC
LIMIT 20; -- top products in the year 2011

SELECT *
FROM ecomm;