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
WHERE ct_purchases.ct > (
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