Exercise Instructions
/*
In this exercise, you'll be asked to migrate a table of denormalized data into two normalized tables. The table called denormalized_people contains a list of people, but there is one problem with it: the emails column can contain multiple emails, violating one of the rules of first normal form. What more, the primary key of the denormalized_people table is the combination of the first_name and last_name columns. Good thing they're unique for that data set!

In a first step, you'll have to migrate the list of people without their emails into the normalized people table, which contains an id SERIAL column in addition to first_name and last_name.

Once that is done, you'll have to craft an appropriate query to migrate the email addresses of each person to the normalized people_emails table. Note that this table has columns person_id and email, so you'll have to find a way to get the person_id corresponding to the first_name + last_name combination of the denormalized_people table.

    Hint #1: You'll need to use the Postgres regexp_split_to_table function to split up the emails
    Hint #2: You'll be using INSERT...SELECT queries to achieve the desired result
    Hint #3: If you're not certain about your INSERT query, use simple SELECTs until you have the correct output. Then, use that same SELECT inside an INSERT...SELECT query to finalize the exercise.
*/

INSERT INTO people (first_name, last_name) SELECT first_name, last_name FROM denormalized_people;
/* emails separated by rows*/
SELECT first_name, last_name, REGEXP_SPLIT_TO_TABLE(emails,',')
FROM denormalized_people;
/*emails and IDs*/

SELECT p.id,  REGEXP_SPLIT_TO_TABLE(d.emails,',')
FROM people p
JOIN denormalized_people d
ON p.first_name = d.first_name AND p.last_name = d.last_name; 

INSERT INTO people_emails (person_id, email_address) 
    SELECT p.id,  REGEXP_SPLIT_TO_TABLE(d.emails,',')
    FROM people p
    JOIN denormalized_people d
    ON p.first_name = d.first_name AND p.last_name = d.last_name; 


/*Exercise Instructions

For this exercise, you're being asked to fix a people table that contains some data annoyances due to the way the data was imported:

    All values of the last_name column are currently in upper-case. We'd like to change them from e.g. "SMITH" to "Smith". Using an UPDATE query and the right string function(s), make that happen.

    Instead of dates of birth, the table has a column born_ago, a TEXT field of the form e.g. '34 years 5 months 3 days'. We'd like to convert this to an actual date of birth. In a first step, use the appropriate DDL command to add a date_of_birth column of the appropriate data type. Then, using an UPDATE query, set the date_of_birth column to the correct value based on the value of the born_ago column. Finally, using another DDL command, remove the born_ago column from the table.

*/
--1
UPDATE people SET last_name=initcap(last_name);
--2
ALTER TABLE people ADD COLUMN "date_of_birth" DATE;
--3
UPDATE people SET date_of_birth = CURRENT_DATE-born_ago::interval;
--4
ALTER TABLE people DROP COLUMN born_ago;