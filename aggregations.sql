/* Find the total amount of poster_qty paper ordered in the orders table.*/
SELECT SUM(poster_qty)
FROM orders

/* Find the total amount of standard_qty paper ordered in the orders table*/
SELECT SUM(standard_qty)
FROM orders

/* Find the total dollar amount of sales using the total_amt_usd in the orders table.*/
SELECT SUM(total_amt_usd) 
FROM orders

/*
Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.*/
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

/* Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.*/
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

/* When was the earliest order ever placed? You only need to return the date.*/
SELECT MIN(occurred_at)
FROM orders

/*Try performing the same query as in question 1 without using an aggregation function. */
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1

/* When did the most recent (latest) web_event occur?*/
SELECT MAX(occurred_at)
FROM web_events

/*Try to perform the result of the previous query without using an aggregation function.*/
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1

/* Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.
*/
SELECT AVG(standard_amt_usd) avg_std_amt_usd, AVG(gloss_amt_usd) avg_gloss_amt_usd, AVG(poster_amt_usd) avg_poster_amt_usd, 
AVG(standard_qty) avg_std_qty, AVG(gloss_qty) 
avg_gloss_qty, AVG(poster_qty) avg_poster_qty
FROM orders

/* Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders? Note, this is more advanced than the topics we have covered thus far to build a general solution, but we can hard code a solution in the following way.*/

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
/* Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.*/
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at 
LIMIT 1

/*

Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name. */
SELECT a.name, SUM(o.total_amt_usd)
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name

/* Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.*/
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id 
ORDER BY w.occurred_at DESC
LIMIT 1;

/* 
Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.*/
SELECT COUNT(channel), channel
FROM web_events
GROUP BY channel

/* Who was the primary contact associated with the earliest web_event? */
SELECT a.primary_poc, w.occurred_at
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1

/* 
What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
*/

SELECT a.name, MIN(o.total_amt_usd) total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_usd

/* Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.*/
SELECT r.name, COUNT(s.id) sales_reps
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY sales_reps;

/* For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account. */
SELECT a.name, AVG(o.standard_qty) std, AVG(o.gloss_qty) gloss, AVG(o.poster_qty) poster
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name

/* For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.*/

/* 
Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
*/
SELECT COUNT(w.channel) cnt_channel, s.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name 
ORDER BY cnt_channel DESC

/* Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
*/

SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;

/* Use DISTINCT to test if there are any accounts associated with more than one region.*/

SELECT  r.name region_name, a.id account_id
FROM accounts a 
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON r.id = s.region_id

/* Ens retorna 351 files, tenim per tant 351 relacions de region amb account, si ara mirem quants accounts son diferents podrem veure quants n'hi ha*/

SELECT DISTINCT id, name
FROM accounts
/* També ens dóna 351 resultats per tant cada account està associat només a una regió

/*Have any sales reps worked on more than one account?*/

SELECT a.id, s.id s_rep_id
FROM accounts a
JOIN sales_reps s 
ON a.sales_rep_id = s.id 
/*fem el mateix raonament que abans i ens retorna 351 igual que abans ja que hi ha 351 comptes */
SELECT DISTINCT id
FROM sales_reps
/* Ens retorna 50 ids, per tant hi ha representatns que treballen en més d'un compte*/


/*
    How many of the sales reps have more than 5 accounts that they manage?
*/
SELECT s.id, COUNT(a.id) sum_accounts
FROM sales_reps s
JOIN accounts a 
ON s.id = a.sales_rep_id
GROUP BY s.id
HAVING COUNT(sum_accounts) > 5


/*
    How many accounts have more than 20 orders?
*/
SELECT a.name, COUNT(o.*)
FROM accounts a 
JOIN orders o 
ON a.id = o.account_id 
GROUP BY a.name 
HAVING COUNT(o.id)>20
/*

    Which account has the most orders?
*/
SELECT a.name, COUNT(o.*)
FROM accounts a 
JOIN orders o 
ON a.id = o.account_id 
GROUP BY a.name 
HAVING COUNT(o.id)>20
ORDER BY COUNT(o.*) DESC
LIMIT 1
/*
    Which accounts spent more than 30,000 usd total across all orders?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd)
FROM accounts a 
JOIN orders o
ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000

/*
    Which accounts spent less than 1,000 usd total across all orders?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd)
FROM accounts a 
JOIN orders o
ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000


/*
    Which account has spent the most with us?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd)
FROM accounts a 
JOIN orders o
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 1


/*
    Which account has spent the least with us?
*/
SELECT a.id, a.name, SUM(o.total_amt_usd)
FROM accounts a 
JOIN orders o
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY 3 
LIMIT 1


/*
    Which accounts used facebook as a channel to contact customers more than 6 times?
*/
SELECT a.name, COUNT(w.channel)
FROM accounts a 
JOIN web_events w 
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.name
HAVING COUNT(w.channel)>6

/*
    Which account used facebook most as a channel?
*/
SELECT a.name, COUNT(w.channel)
FROM accounts a 
JOIN web_events w 
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.name
ORDER BY COUNT(w.channel) DESC
LIMIT 1


/*
    Which channel was most frequently used by most accounts?
*/
SELECT a.name, w.channel, COUNT(w.channel) count_channel
FROM accounts a 
JOIN web_events w 
ON a.id = w.account_id
GROUP BY a.name, w.channel
ORDER BY count_channel DESC
LIMIT 15

/*
Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?*/
SELECT DATE_PART('year',occurred_at), SUM(total_amt_usd)
FROM orders
GROUP BY 1 
ORDER BY 2 DESC
/*
Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
*/
SELECT DATE_PART('month',occurred_at), SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 2 DESC
/*
Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
*/
SELECT DATE_PART('month',o.occurred_at), COUNT(o.*)
FROM orders o 
GROUP BY 1
ORDER BY 2 DESC
/*
Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
*/
SELECT DATE_PART('YEAR',o.occurred_at), COUNT(o.*)
FROM orders o 
GROUP BY 1
ORDER BY 2 DESC
/*
In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
*/
SELECT DATE_TRUNC('MONTH',o.occurred_at), SUM(o.gloss_amt_usd)
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name LIKE 'Walmart'
GROUP BY 1
ORDER BY 2 DESC

/* Podem arreglar el problema de la divisió per 0 de fa unes quantes lliçons amb un case */
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;


/*

    Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
*/
SELECT o.account_id, o.total_amt_usd, CASE WHEN total_amt_usd > 3000 THEN 'Large' ELSE 'Small' END AS level_of_order
FROM orders o
/*
    Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
*/
SELECT CASE WHEN total_amt_usd >= 2000 THEN 'At Least 2000'
            WHEN total_amt_usd < 2000 AND total_amt_usd >= 1000 THEN 'Between 1000 and 2000'
            WHEN total_amt_usd < 1000 THEN 'Less than 1000'
            END AS categories, COUNT(*)
FROM orders
GROUP BY 1



/*
    We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
*/
SELECT a.name, SUM(total_amt_usd) AS total, CASE WHEN SUM(total_amt_usd) > 200000 THEN 'BIG'
                                                WHEN SUM(total_amt_usd) <= 200000 AND SUM(total_amt_usd) >= 100000 THEN 'MID'
                                                WHEN SUM(total_amt_usd) < 100000 THEN 'SMALL' END AS class
FROM accounts a 
JOIN orders o 
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total DESC

/*
    We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
*/
SELECT a.name, SUM(total_amt_usd) AS total, CASE WHEN SUM(total_amt_usd) > 200000 THEN 'BIG'
                                                WHEN SUM(total_amt_usd) <= 200000 AND SUM(total_amt_usd) >= 100000 THEN 'MID'
                                                WHEN SUM(total_amt_usd) < 100000 THEN 'SMALL' END AS class
FROM accounts a 
JOIN orders o 
ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
GROUP BY a.name
ORDER BY total DESC


/*
    We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.
*/

SELECT s.name, COUNT(*) AS total_orders, CASE WHEN COUNT(*) > 200 THEN 'TOP'
                              ELSE 'not top'END AS Performance
FROM sales_reps s
JOIN accounts a 
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
/*
    The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!
*/

SELECT s.name, COUNT(*) AS total_orders, SUM(total_amt_usd) AS total_sales, 
CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'TOP'
      WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'MID'
ELSE 'LOW'END AS Performance
FROM sales_reps s
JOIN accounts a 
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC

