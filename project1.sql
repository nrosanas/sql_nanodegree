CREATE VIEW forestation AS
	SELECT fa.country_code country_code, fa.country_name, fa.year, fa.forest_area_sqkm, la.total_area_sq_mi, la.total_area_sq_mi*2.59 total_area_sqkm, fa.forest_area_sqkm/(la.total_area_sq_mi*2.59)*100 pct_forest_area, r.region, r.income_group
    FROM forest_area fa
    JOIN land_area la
    ON fa.country_code = la.country_code AND fa.year = la.year
    JOIN regions r
    ON r.country_code = fa.country_code;
    
/* 1. GLOBAL SITUATION */
/* a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.*/

SELECT country_name, year, forest_area_sqkm
FROM forestation
WHERE region = 'World' and year = 1990;

/* B.  What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.” */
SELECT country_name, year, forest_area_sqkm
FROM forestation
WHERE region = 'World' and year = 2016;



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