
/* Say you're an analyst at Parch & Posey and you want to see:

    each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
    but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)

This type of question is rare, but FULL OUTER JOIN is perfect for it. In the following SQL Explorer, write a query with FULL OUTER JOIN to fit 
the above described Parch & Posey scenario (selecting all of the columns in both of the relevant tables, accounts and sales_reps) then answer the subsequent multiple choice quiz.*/

SELECT a.*, s.*
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id
WHERE a.id = NULL OR s.id = null

/* In the following SQL Explorer, write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so:
accounts.primary_poc < sales_reps.name*/
SELECT a.name, a.primary_poc, s.name
FROM accounts a
LEFT JOIN sales_reps s
ON a.sales_rep_id = s.id AND
	a.primary_poc < s.name

/*Modify the query from the previous video, which is pre-populated in the SQL Explorer below, to perform the same interval analysis except for the web_events table. Also:

    change the interval to 1 day to find those web events that occurred after, but not more than 1 day after, another web event
    add a column for the channel variable in both instances of the table in your query

You can find more on the types of INTERVALS (and other date related functionality) in the Postgres documentation here.*/

SELECT w1.id wid1, w1.account_id w1account_id, w2.account_id w2account_id, w2.id wid2, w1.occurred_at w1time, w2.occurred_at w2time
FROM web_events w1
LEFT JOIN web_events w2
ON w1.account_id = w2.account_id
 	and w1.occurred_at < w2.occurred_at
 	AND w1.occurred_at + INTERVAL '1 day' >= w2.occurred_at
ORDER BY w1account_id, w1time



SELECT *
    FROM accounts

UNION ALL

SELECT *
  FROM accounts



SELECT *
    FROM accounts
    WHERE name = 'Walmart'

UNION ALL

SELECT *
  FROM accounts
  WHERE name = 'Disney'


WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC

/* exemple abans d'agregar*/
SELECT o.occurred_at AS DATE,
	.sales_rep_id,
	o.id AS order_id,
	we.id AS web_events_id
FROM accounts a
JOIN orders o
ON o.account_id = a.id
JOIN web_events we
ON DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day',o.occurred_at)
ORDER BY 1 DESC 


/*optimitzat amb subqueries*/

SELECT COALESCE(orders.date, web_events.date) AS DATE,
	orders.active_sales_reps,
	orders.orders,
	web_events.web_visites
FROM(

	SELECT DATE_TRUNC('day',o.occurred_at) AS DATE,
		count( a.sales_rep_id) AS active_sales_reps,
		COUNT(  o.id) AS orders
	FROM accounts a
	JOIN orders o
	ON o.account_id = a.id
	GROUP BY 1
	) AS orders
FULL JOIN 
	(
	SELECT DATE_TRUNC('day', we.occurred_at) AS DATE,
	count(we.id) AS web_visites
	from web_events we
	GROUP BY 1
	ORDER BY 1 DESC
	) AS web_events 
		
ON web_events.date = orders.date