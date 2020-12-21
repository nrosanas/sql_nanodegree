SELECT channel, AVG(event_count)
FROM
(SELECT DATE_TRUNC('DAY', occurred_at) AS DAY,
		 channel,
		 COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2
	ORDER BY 1
	) sub
GROUP BY 1
ORDER BY 2 DESC
	
SELECT AVG(standard_qty) AS standard , AVG(gloss_qty) AS gloss, AVG(poster_qty) AS poster, SUM(total_amt_usd) AS total_amt_usd
FROM orders 
WHERE DATE_TRUNC('month',occurred_at) = 
	(SELECT DATE_TRUNC('month',MIN(occurred_at)) as min_month 
	FROM orders) 

/* What is the top channel used by each account to market prodcuts?
How often was the channel used?*/
SELECT t3.name, t3.channel, t3.event_count
FROM 	(SELECT a.name, w.channel, COUNT(*) event_count
			FROM accounts a
			JOIN web_events w
			ON a.id = w.account_id
			GROUP BY 1, 2) AS t3
JOIN	(SELECT t1.name,  MAX(t1.event_count) AS max_event_count
	FROM 	(SELECT a.name, w.channel, COUNT(*) event_count
			FROM accounts a
			JOIN web_events w
			ON a.id = w.account_id
			GROUP BY 1, 2) AS t1
	GROUP BY 1) AS t2
ON t2.name = t3.name AND t3.event_count = t2.max_event_count
ORDER BY 1 


/*

Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/
*/
SELECT t3.name, t3.sum_usd, t3.region_name
FROM 
	(SELECT s.name, SUM(o.total_amt_usd) AS sum_usd ,r.name AS region_name
		FROM sales_reps s
		JOIN region r
		ON s.region_id = r.id
		JOIN accounts a
		ON a.sales_rep_id = s.id
		JOIN orders o 
		ON o.account_id = a.id
		GROUP BY 1,3) AS t3
JOIN (SELECT t1.region_name, MAX(t1.sum_usd) max_region
	FROM 
		(SELECT s.name, SUM(o.total_amt_usd) AS sum_usd ,r.name AS region_name
		FROM sales_reps s
		JOIN region r
		ON s.region_id = r.id
		JOIN accounts a
		ON a.sales_rep_id = s.id
		JOIN orders o 
		ON o.account_id = a.id
		GROUP BY 1, 3) 
		AS T1
	GROUP BY 1) AS T2
ON t2.region_name = t3.region_name AND t2.max_region = t3.sum_usd
GROUP BY 1,2,3

/*For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? */
SELECT COUNT(o.*) ct_orders , r.name
	FROM sales_reps s
	JOIN region r
	ON s.region_id = r.id
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o 
	ON o.account_id = a.id
WHERE r.name = 
(SELECT t3.region_name
FROM (
	SELECT MAX(t1.sum_usd) AS max_region
	FROM 
		(SELECT SUM(o.total_amt_usd) AS sum_usd ,r.name AS region_name
		FROM sales_reps s
					JOIN region r
					ON s.region_id = r.id
					JOIN accounts a
					ON a.sales_rep_id = s.id
					JOIN orders o 
					ON o.account_id = a.id
		GROUP BY region_name	) AS t1) AS t2	
JOIN
	(SELECT SUM(o.total_amt_usd) AS sum_usd ,r.name AS region_name
		FROM sales_reps s
					JOIN region r
					ON s.region_id = r.id
					JOIN accounts a
					ON a.sales_rep_id = s.id
					JOIN orders o 
					ON o.account_id = a.id
		GROUP BY region_name	) AS t3
ON t2.max_region = t3.sum_usd)
GROUP BY 2
/*solucio elegant 
*/
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);

/* 
How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer? */
/*primer taula amb el nombre de compres total per account*/
SELECT *
FROM 
	(SELECT a.name, COUNT(o.*) ct
	FROM accounts a 
	JOIN orders o
	ON o.account_id = a.id
	GROUP BY 1) AS ct_purchases
 ct_purchases.ct > (
	SELECT COUNT(o.*)
	FROM
		(SELECT MAX(sum_qty.sum)
		FROM 
			(SELECT a.name, SUM(o.standard_qty) 
			FROM accounts a
			JOIN orders o
			ON a.id = o.account_id
			GROUP BY 1	) AS sum_qty) AS max_qty
	JOIN (SELECT a.name, SUM(o.standard_qty)
			FROM accounts a
			JOIN orders o
			ON a.id = o.account_id
			GROUP BY 1	) AS sum_qty2 
	ON sum_qty2.sum = max_qty.max
	JOIN accounts a
	ON a.name = sum_qty2.name
	JOIN orders o 
	ON o.account_id = a.id)

    /***********************
    /* millor solucio*/
    *******************/
SELECT COUNT(*)
FROM (
	SELECT a.name, COUNT(*)
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name
	HAVING sum(o.total)>
		(SELECT SUM(total) AS ct
		FROM orders
		GROUP BY account_id
		HAVING SUM(standard_qty) =
			(SELECT MAX(sum_standard)
			FROM (SELECT  SUM(standard_qty) AS sum_standard
			FROM orders
			GROUP BY account_id) 
		AS t2) 
		)
	)AS counter



    /*For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
*/


SELECT account_id, channel, COUNT(channel)
FROM web_events
GROUP BY account_id, channel
HAVING account_id = 
	(SELECT account_id 
	FROM orders 
	GROUP BY account_id
	HAVING SUM(total_amt_usd) = 
		(SELECT MAX(sum_total)
		FROM 
			(SELECT SUM(total_amt_usd) AS sum_total
			FROM orders
			GROUP BY account_id
			)
			AS t_in
		)
	)
    /* 
What is the lifetime average amount spent in terms of 
total_amt_usd for the top 10 total spending accounts?*/
SELECT  AVG(lt_usd) avg_spent
FROM  (
		SELECT SUM(o.total_amt_usd) AS lt_usd
		FROM orders o 
		GROUP BY account_id
		ORDER BY lt_usd DESC
		LIMIT 10 ) AS top_spenders
ORDER BY avg_spent 


/*What is the lifetime average amount spent in terms of total_amt_usd
 including only the companies that spent more per order, on average, than the average of all orders.*/
SELECT AVG(AVG)
FROM(
SELECT account_id, AVG(total_amt_usd)
FROM orders
GROUP BY account_id
HAVING AVG(total_amt_usd) > 
	(SELECT AVG(total_amt_usd)
	FROM orders) )AS t1

    /* 
Provide the name of the sales_rep in each region with the largest amount 
of total_amt_usd sales.*/
WITH sum_sales AS 
	(SELECT s.name, SUM(o.total_amt_usd) sum_sales, s.region_id
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON a.sales_rep_id = s.id
	GROUP BY s.name, s.region_id
	),
	max_region AS (
	SELECT r.name  , MAX(sum_sales) max_sum
	FROM sum_sales su
	JOIN region r
	ON su.region_id = r.id
	GROUP BY r.name)

SELECT m.name, s.name, s.sum_sales
FROM max_region m
JOIN sum_sales s
ON s.sum_sales = m.max_sum;

/* 
For the region with the largest sales total_amt_usd, 
how many total orders were placed? .*/

WITH sum_region AS (
	SELECT r.name, SUM(o.total_amt_usd)
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON a.sales_rep_id = s.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1),
	
	orders_region AS (
	SELECT r.name, COUNT(*) ct
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s
	ON a.sales_rep_id = s.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1)

SELECT o.name, o.ct, s.sum
FROM orders_region o
JOIN sum_region s
ON o.name = s.name
GROUP BY 1,2,3
HAVING s.sum = (
	SELECT MAX(s.sum)
	FROM sum_region s)
/*How many accounts had more total purchases than the account name which has 
bought the most standard_qty paper throughout their lifetime as a customer? */

WITH t1 AS (
	SELECT a.name, SUM(o.standard_qty) std_qty, SUM(o.total) total
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.name
	ORDER BY 2 DESC 
	LIMIT 1
	),
	t2 AS (
	SELECT a.name
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY name
	HAVING SUM(o.total)>
		(SELECT t1.total
		FROM t1))
		
SELECT COUNT(*)
FROM t2

/*For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
how many web_events did they have for each channel? */

WITH 
	cust AS (
		SELECT a.name aname, SUM(o.total_amt_usd) sum_total
		FROM accounts a 
		JOIN orders o 
		ON a.id = o.account_id
		GROUP BY a.name),
		
	topc AS (
		SELECT aname, sum_total
		FROM cust
		GROUP BY 1,2
		HAVING sum_total = 
			(SELECT MAX(sum_total)
			FROM cust))


SELECT a.name, w.channel, COUNT(*)
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY 1,2
HAVING a.name = 
	(SELECT aname
	FROM topc)
ORDER BY COUNT DESC

/*What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? */
WITH top_spending AS 
	(SELECT a.name, SUM(o.total_amt_usd)
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC 
	LIMIT 10
	)
	
	
SELECT AVG(SUM)
FROM top_spending;

/*
What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.*/
WITH c AS 
	(SELECT a.name, avg(o.total_amt_usd)
	FROM accounts a 
	JOIN orders o 
	ON a.id = o.account_id
	GROUP BY a.name
	HAVING AVG(o.total_amt_usd) > (
		SELECT AVG(o.total_amt_usd)
		FROM orders o)
		)

SELECT AVG(avg)
FROM C;