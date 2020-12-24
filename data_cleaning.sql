/*In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.*/
SELECT right(website,3) as web, count(website)
from accounts
group by web
/*There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number). */
SELECT LEFT(NAME,1) AS fl, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY COUNT DESC 

/*Use the accounts table and a CASE statement to create two groups: one group of company names that start with a 
number and a second group of those company names that start with a letter. What proportion of company names start with a letter?*/

select SUM(nums) nums, SUM(letters) letters
FROM(
	SELECT NAME, CASE WHEN LEFT(UPPER(NAME),1) IN  ('0','1','2','3','4','5','6','7','8','9')  THEN 1 ELSE 0 END AS nums,
	CASE WHEN LEFT(UPPER(NAME),1) IN ('0','1','2','3','4','5','6', '7', '8', '9') THEN 0 ELSE 1 END AS letters
	FROM accounts) t1

/*Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else? */
SELECT SUM(vowel) AS vowel, COUNT(*) AS total
FROM(
SELECT NAME, CASE WHEN LEFT(UPPER(NAME),1) IN ('A', 'E', 'I', 'O', 'U') THEN 1 ELSE 0 END AS vowel,
	CASE WHEN LEFT(UPPER(NAME),1) IN ('A', 'E', 'I', 'O', 'U') THEN 0 ELSE 1 END AS consonant
FROM accounts) t1

/*Suppose the company wants to assess the performance of all the sales representatives. 
Each sales representative is assigned to work in a particular region. To make it easier to understand for the HR team, display the concatenated sales_reps.id, ‘_’ (underscore), 
and region.name as EMP_ID_REGION for each sales representative.  */
SELECT s.name, concat(s.id, '_', r.name) EMP_ID_REGION
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
/*     

    From the web_events table, display the concatenated value of account_id, '_' , channel, '_', count of web events of the particular channel.
  */
WITH T1 AS (
	SELECT account_id, channel, COUNT(*)
	FROM web_events
	GROUP BY 1,2 
	ORDER BY 1,3 DESC)
SELECT CONCAT(account_id, '_', channel,'_', COUNT)
FROM t1

/* convert a text to the correct date format originally it is in the form mm/dd/yyyy*/
select CAST(concat(substr(date,7,4),'-',substr(date,1,2), '-', substr(date,4,2)) as DATE) as c
from sf_crime_data
/* alternativa */
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;
/* Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc. */
WITH p AS (
	SELECT primary_poc AS pp,  POSITION(' ' IN primary_poc) AS po
	FROM accounts)
SELECT LEFT(pp,po), SUBSTR(pp,po)
FROM p

/* Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.*/

WITH p AS (
	SELECT name AS pp,  POSITION(' ' IN name) AS po
	FROM sales_reps)
SELECT LEFT(pp,po)first_name , SUBSTr(pp,po) last_name
FROM p


/*Each company in the accounts table wants to create an email address for each primary_poc. 
The email address should be the first name of the primary_poc . last name primary_poc @ company 
name .com.*/
SELECT primary_poc, concat(LEFT(primary_poc, position(' ' IN primary_poc)-1),
	 '.', SUBSTR(primary_poc, position(' ' IN primary_poc)+1), '@', NAME,'.com')
FROM accounts

/*You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.*/
WITH t1 AS (
	SELECT primary_poc, concat(LEFT(primary_poc, position(' ' IN primary_poc)-1),
		 '.', SUBSTR(primary_poc, position(' ' IN primary_poc)+1), '@', NAME,'.com') email
	FROM accounts)
SELECT primary_poc, REPLACE(email, ' ', '')
FROM t1

/* We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces. */
WITH n AS (
	SELECT primary_poc, LEFT(primary_poc, position(' ' IN primary_poc)-1) first_name, SUBSTR(primary_poc, position(' ' IN primary_poc)+1) last_name, NAME AS c_name
	FROM accounts)
SELECT primary_poc, concat(LEFT(lower(first_name),1), 
	right(lower(first_name),1), LEFT(LOWER(last_name),1), 
	RIGHT(LOWER(last_name),1), LENGTH(first_name), length(last_name),UPPER(REPLACE(c_name,' ',''))) 
FROM n