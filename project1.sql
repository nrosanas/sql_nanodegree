CREATE VIEW forestation AS
    SELECT fa.country_code country_code, 
        fa.country_name, 
        fa.year, 
        fa.forest_area_sqkm, 
        la.total_area_sq_mi, 
        la.total_area_sq_mi*2.59 total_area_sqkm, 
        fa.forest_area_sqkm/(la.total_area_sq_mi*2.59)*100 pct_forest_area, 
        r.region, 
        r.income_group
    FROM forest_area fa
    JOIN land_area la
        ON fa.country_code = la.country_code AND fa.year = la.year
    JOIN regions r
        ON r.country_code = fa.country_code;
    
/* 1. GLOBAL SITUATION */
/* a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World' in the region table.*/

SELECT country_name, year, forest_area_sqkm
FROM forestation
WHERE region = 'World' AND year = 1990;

/* B.  What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.” */
SELECT country_name, year, forest_area_sqkm
FROM forestation
WHERE region = 'World' AND year = 2016;



/*  c. What was the change (in sq km) in the forest area of the world from 1990 to 2016? */
/*  d. What was the percent change in forest area of the world between 1990 and 2016*/
WITH t1 AS (SELECT forest_area_sqkm, country_name
            FROM forestation
            WHERE year = 1990 AND country_name = 'World'),
     t2 AS (SELECT forest_area_sqkm, country_name
            FROM forestation
            WHERE year = 2016 AND country_name = 'World')
            
SELECT t1.forest_area_sqkm area90, 
    t2.forest_area_sqkm area16, 
    t1.forest_area_sqkm-t2.forest_area_sqkm AS change_abs,
    (1- t2.forest_area_sqkm/t1.forest_area_sqkm)*100 AS change_pct
FROM t1
JOIN t2
    ON t1.country_name = t2.country_name

/*e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?*/

WITH t1 AS (SELECT forest_area_sqkm, country_name
            FROM forestation
            WHERE year = 1990 AND country_name = 'World'),
     t2 AS (SELECT forest_area_sqkm, country_name
            FROM forestation
            WHERE year = 2016 AND country_name = 'World'),
     lost_area AS (SELECT t1.forest_area_sqkm-t2.forest_area_sqkm AS lost_area
                   FROM t1
                   JOIN t2
                    ON t1.country_name = t2.country_name)
SELECT country_name, total_area_sqkm 
FROM forestation
WHERE total_area_sqkm < (SELECT lost_area
                        FROM lost_area) AND year = 2016
ORDER BY total_area_sqkm DESC
LIMIT 1

/*REGIONAL OUTLOOK*/

/*a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?*/

SELECT region, 
    year, 
    ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) AS numeric)*100, 2) pct_forest
FROM forestation
WHERE year = 2016
GROUP BY region, year
ORDER BY pct_forest DESC

/* b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?*/

SELECT region, 
    year, 
    ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) AS numeric)*100, 2) pct_forest
FROM forestation
WHERE year = 1990
GROUP BY region, year
ORDER BY pct_forest DESC

/*c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?*/
WITH t90 as (
       SELECT region, 
        year, 
        ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) AS numeric)*100, 2) pct_forest
       FROM forestation
       WHERE year = 1990
       GROUP BY region, year
       ORDER BY pct_forest DESC
),
t16 as (
       SELECT region, 
        year, 
        ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) AS numeric)*100, 2) pct_forest
       FROM forestation
       WHERE year = 2016
       GROUP BY region, year
       ORDER BY pct_forest DESC
)
SELECT t90.region, 
       t90.pct_forest pct_forest_1990, 
       t16.pct_forest pct_forest_2016, 
       t16.pct_forest-t90.pct_forest pct_change
FROM t90 
JOIN t16
    ON t90.region = t16.region
ORDER BY pct_change

/* COUNTRY-LEVEL DATA*/
/*a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?*/
 SELECT s.country_name, 
       s.region, 
       s.forest_area_sqkm - e.forest_area_sqkm decrease
 FROM forestation s
 JOIN forestation e
    ON (s.country_name = e.country_name) AND (s.year = 1990 AND e.year = 2016 )
 WHERE s.forest_area_sqkm IS NOT NULL 
    AND e.forest_area_sqkm IS NOT NULL 
    AND (s.country_name != 'World')
 ORDER BY decrease DESC
 LIMIT 5

/*b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?*/

SELECT s.country_name, 
       s.region,
       ROUND(CAST((((s.forest_area_sqkm-e.forest_area_sqkm)/s.forest_area_sqkm)) AS numeric)*100, 2) pct_forest
 FROM forestation s
 JOIN forestation e
    ON (s.country_name = e.country_name) 
    AND (s.year = 1990 AND e.year = 2016 )
 WHERE s.forest_area_sqkm IS NOT NULL 
    AND e.forest_area_sqkm IS NOT NULL 
    AND s.total_area_sqkm IS NOT NULL 
    AND e.total_area_sqkm IS NOT NULL 
    AND (s.country_name != 'World')
 ORDER BY pct_forest DESC
 LIMIT 5

 /*c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?*/
SELECT CASE  WHEN pct_forest_area < 25 THEN '<25%'
              WHEN pct_forest_area < 50 AND pct_forest_area >= 25 THEN'>=25% and <50%'
              WHEN pct_forest_area < 75 AND pct_forest_area >= 50 THEN '>=50% and < 75%'
              WHEN pct_forest_area < 100 AND pct_forest_area >= 75 THEN '>75%' END AS percentile, COUNT(*) 
FROM forestation
WHERE year = 2016 
    AND country_name != 'World' 
    AND pct_forest_area IS NOT NULL
GROUP BY percentile
Order by 2 DESC

/*d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.*/
SELECT country_name, region, ROUND(CAST(pct_forest_area AS numeric), 2)
FROM forestation
WHERE year = 2016 AND pct_forest_area > 75
ORDER BY 3 DESC

/*e. How many countries had a percent forestation higher than the United States in 2016? */
SELECT count(*)
FROM forestation
WHERE pct_forest_area > (
                            SELECT pct_forest_area
                            FROM forestation
                            WHERE year=2016 
                                AND country_name like 'United States' ) 
                     AND year=2016

/*Recomendations*/
/*Wich income group has less forest area*/
SELECT income_group, 
    year, 
    ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) AS numeric)*100, 2) pct_forest
FROM forestation
WHERE year = 2016
GROUP BY income_group, year
ORDER BY pct_forest DESC

WITH t90 as (
       SELECT income_group, 
        year, 
        ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) AS numeric)*100, 2) pct_forest
       FROM forestation
       WHERE year = 1990
       GROUP BY income_group, year
       ORDER BY pct_forest DESC
),
t16 as (
       SELECT income_group, 
        year, 
        ROUND(CAST(SUM(forest_area_sqkm)/SUM(total_area_sqkm) AS numeric)*100, 2) pct_forest
       FROM forestation
       WHERE year = 2016
       GROUP BY income_group, year
       ORDER BY pct_forest DESC
)
SELECT t90.income_group, 
       t90.pct_forest pct_forest_1990, 
       t16.pct_forest pct_forest_2016, 
       t16.pct_forest-t90.pct_forest pct_change
FROM t90 
JOIN t16
    ON t90.income_group = t16.income_group
ORDER BY pct_change