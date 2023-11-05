# Case Study #1 - E-commerce data
### About the Dataset
> This dataset provides historical transactional data for a UK based E-commerce company ranging between 01/12/2010 and 09/12/2011. This
E-commerce company is unique as unlike most E-commerce businesses, many of their customers are wholesellers purchasing unique all-occassion gifts.


### Case Study Questions
>*  We are required to clean the data to find sales figures for the year of 2011.
>*  Provide a detailed summary and dashboard of the E-commerce sales, while keeping the following questions in mind:
>     1. What is our order fulfilment?
>     2. Who are our main customers?
>     3. Where should we place our focus on for the next year?
>     4. How would we better position ourselves to capture more sales for the coming year?

### Dataset
<details>
<summary>
View Table
</summary>
The raw data captures all invoice numbers under `InvoiceNo` to represent the invoice information upon ordering on the E-commerce site.
  
|  InvoiceNo  |  StockCode  |  Description    |  Quantity  |     InvoiceDate     |  UnitPrice  |  CustomerID  |    Country     | 
|:-----------:|:-----------:|:----------------|:----------:|:-------------------:|:-----------:|:------------:|:--------------:|
|    536365   |    85123A   |  WHITE HANG...  |     6      | 2010-12-01 08:26:00 |    2.55     |    17850.0   | United Kingdom |
|    536365   |    71053    |  WHITE META...  |     6      | 2010-12-01 08:26:00 |    3.39     |    17850.0   | United Kingdom |   
|    536365   |    84406B   |  CREAM CUPI...  |     8      | 2010-12-01 08:26:00 |    2.75     |    17850.0   | United Kingdom | 
|    536365   |    84029G   |  KNITTED UN...  |     6      | 2010-12-01 08:26:00 |    3.39     |    17850.0   | United Kingdom | 
|    536365   |    84029E   |  RED WOOLLY...  |     6      | 2010-12-01 08:26:00 |    3.39     |    17850.0   | United Kingdom |  

[541909 rows x 8 columns]

</details>

### Data Cleaning

> Tasks Performed in Jupyter Notebooks:
> *  Fix structural issues in data i.e. `InvoiceNo` contained operational expenses as well as sales data
> *  Remove non relevant data to sales analysis
> *  Reassign data types for analysis

[More information provided in `ecommerce.ipynb` file]

### Case Study
#### Q1. What is our order fulfilment?
##### Percentage of order fulfilment
```sql
SELECT 
	  order_status
	, ROUND(COUNT(order_status)*100/(SELECT COUNT(*) FROM ecomm WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'), 2) AS percent
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY order_status;
```
<details>
  <summary>
    View Table
  </summary>

  |order_status|percent|
|:-----------|:------|
|cancelled   |1.64   |
|order       |98.36  |

</details>

---
#### Q2. Who are our main customers?
From our the data, we can only derive our customer based by country of residence. However, we can segregate them into 2 metric categories either to track the frequency or revenue of orders as shown below.

##### Distinct orders by country 
```sql
SELECT 
	  country
	, COUNT(DISTINCT(invoice_no)) AS orders
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY country
ORDER BY orders DESC
LIMIT 15;
```
<details>
  <summary>
    View Table
  </summary>
  
|    Country     |Orders|
|:---------------|:-----|
|United Kingdom  |20,068|
|Germany	       |556   |
|France          |422   |
|EIRE	           |335   |
|Belgium	       |112   |
|Spain	         |97    |
|Netherlands	   |93    |
|Switzerland	   |68    |
|Australia       |67    |
|Portugal        |51    |
|Italy           |48    |
|Sweden          |40    |
|Finland	       |40    |
|Norway          |31    |
|Channel Islands |29    |
  
</details>

##### Total revenue by country
```sql
SELECT 
	  country
	, SUM(revenue) AS total_revenue
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 15;
```

<details>
  <summary>
    View Table
  </summary>
  
|    Country    |Total Revenue|
|:--------------|:------------|
|United Kingdom |7,902,009.63 |
|Netherlands    |271,751.52   |
|EIRE           |252,540.42   |
|Germany        |193,963.70   |
|France         |175,772.12   |
|Australia      |136,990.00   |
|Switzerland    |52,505.35    |
|Spain          |51,521.77    |
|Japan          |35,536.72    |
|Belgium        |35,382.53    |
|Sweden         |35,176.91    |
|Norway         |29,547.26    |
|Portugal       |24,461.57    |
|Channel Islands|19,742.14    |
|Denmark        |17,891.24    |

</details>

---
#### Q3. Where should we place our focus on for the next year?
Intuitively, we should look towards maximising our sales based on the best performing products. Similarly, we could utilise this list to prioritise our marketing engagements and extract more value from the sales.

##### Best performing products by sales revenue
```sql
SELECT 
	  description
	, SUM(revenue) AS total_revenue
FROM ecomm
WHERE invoice_date BETWEEN '2010-12-01' AND '2011-12-01'
GROUP BY description
ORDER BY total_revenue DESC
LIMIT 15;
```

<details>
  <summary>
    View Table
  </summary>

|            Description            |Total Revenue|
|:----------------------------------|:------------|
|REGENCY CAKESTAND 3 TIER	          |158,859.27   |
|WHITE HANGING HEART T-LIGHT HOLDER	|97,464.40    |
|PARTY BUNTING	                    |97,384.50    |
|JUMBO BAG RED RETROSPOT	          |90,160.33    |
|RABBIT NIGHT LIGHT	                |57,138.58    |
|PAPER CHAIN KIT 50'S CHRISTMAS 	  |56,921.23    |
|ASSORTED COLOUR BIRD ORNAMENT	    |56,796.99    |
|CHILLI LIGHTS	                    |51,134.07    |
|SPOTTY BUNTING	                    |41,300.46    |
|JUMBO BAG PINK POLKADOT	          |40,693.34    |
|PICNIC BASKET WICKER 60 PIECES	    |39,619.50    |
|SET OF 3 CAKE TINS PANTRY DESIGN 	|36,364.89    |
|BLACK RECORD COVER FRAME	          |35,014.53    |
|DOORMAT KEEP CALM AND COME IN	    |35,007.17    |
|JAM MAKING SET WITH JARS	          |34,860.81    |

</details>

---
#### Q4. How would we better position ourselves to capture more sales for the coming year?
Currently, we have addressed what products to prioritise. However, we can also include metrics like which day or which month should we prioritise for better engagement marketing. As shown from the tables below: 

##### E-commerce sales that performed better than average based on the months of the year
```sql
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
```

<details>
  <summary>
    View Table
  </summary>

|Month|Total Revenue|
|:---:|:------------|
|9	  |1,013,424.10 |
|10	  |1,062,674.37 |
|11	  |1,432,731.70 |

</details>

##### E-commerce sales that performed better than the average grouped by days of the week
```sql
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
```

<details>
  <summary>
    View Table
  </summary>

|  Day  |Total Revenue|
|:------|:------------|
|Tues  	|1,915,523.18 |
|Wed  	|1,670,092.65 |
|Thurs	|1,957,684.37 |

</details>

---
<p>&copy; 2023 Chris G </p>
