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
