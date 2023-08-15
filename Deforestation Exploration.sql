It's a resubmition. You can follow the revised parts by lines demonstrated below.


--Line 26 "ON l.country_code = f.country_code" to "ON l.country_code = f.country_code AND l.year = f.year"
--Line 175-206 SELF JOIN used to filter regions of the world DECREASED in forest area from 1990 to 2016. 
--Linelist = [25, 27, 195, 233, 261, 265, 268, 293, 297, 300,300, 339, 382, 383, 416, 429, 468, 472, 475, 499, 502, 505, 527, 530, 533, 541, 545, 548]
linelist represents the false join type that I forgot. All "JOIN" commands changed to "LEFT JOIN" commands.


--CREATING VIEW


CREATE VIEW Deforestation_Exploration2 AS
WITH abridged_fa AS (SELECT * 
                     FROM forest_area
                     WHERE year = 2016 or year = 1990)
SELECT 	f.year AS years, 
		f.country_name AS country_names, 
		f.country_code AS country_codes, 
		r.region AS regions, 
        f.forest_area_sqkm AS forest_area_sqkm,
        r.income_group AS income_groups,
		CAST(l.total_area_sq_mi*2.59 AS Numeric) AS total_area_sqkm
FROM forest_area f
LEFT JOIN land_area l
ON l.country_code = f.country_code AND l.year = f.year
LEFT JOIN regions r
ON r.country_code = f.country_code;


--1.GLOBAL SITUATION

--1.a What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.

SELECT year, country_name, SUM(forest_area_sqkm) forests
FROM forest_area
GROUP BY 1,2
HAVING country_name = 'World' AND year = 1990
ORDER BY 3 DESC;

--According to the World Bank, the total forest area of the world was 41.282.694.9 km² in 1990. 

--1.b, 1.c, 1.d
What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”
What was the change (in sq km) in the forest area of the world from 1990 to 2016?
What was the percent change in forest area of the world between 1990 and 2016?

SELECT year, country_name, SUM(forest_area_sqkm) forests
FROM forest_area
GROUP BY 1,2
HAVING country_name = 'World' AND year = 2016
ORDER BY 3;

--As of 2016, the most recent year for which data was available, that number had fallen to 39.958.245.9 km², a loss of 1.324.449 km² , or 3,21%.

--1.e If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?

SELECT year, country_name, SUM(total_area_sq_mi)*2.59 landarea
FROM land_area
GROUP BY 1,2
HAVING year = 2016 AND SUM(total_area_sq_mi)*2.59<1324449
ORDER BY 3 DESC
LIMIT 1;

--The forest area lost over this time period is slightly more than the entire land area of Peru listed for the year 2016 (which is 1.279.999,99 km² ).

--2. REGIONAL OUTLOOK

WITH abridged_f_area AS (SELECT *
                         FROM forest_area
                         WHERE year = 1990 or year = 2016)
SELECT f.year, region, SUM(total_area_sq_mi)*2.59 land_area_sqkm, SUM(forest_area_sqkm) forest_area_sqkm, SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59) forest_percentage
FROM abridged_f_area f
LEFT JOIN regions r
ON f.country_code = r.country_code
LEFT JOIN land_area l
ON f.country_code = l.country_code
GROUP BY 1,2
ORDER BY 5 DESC;



--2.a.1 What was the percent forest of the entire world in 2016?

WITH abridged_f_area AS (SELECT *
                         FROM forest_area
                         WHERE year = 2016)
SELECT f.year, region, SUM(total_area_sq_mi)*2.59 land_area_sqkm, SUM(forest_area_sqkm) forest_area_sqkm, ROUND(CAST((SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59)) AS numeric)*100,2) forest_percentage
FROM abridged_f_area f
LEFT JOIN regions r
ON f.country_code = r.country_code
LEFT JOIN land_area l
ON f.country_code = l.country_code
GROUP BY 1,2
HAVING region = 'World'
ORDER BY 5 DESC;

--2.a.2 Which region had the HIGHEST percent forest in 2016?

WITH abridged_f_area AS (SELECT *
                         FROM forest_area
                         WHERE year = 2016)
SELECT f.year, region, SUM(total_area_sq_mi)*2.59 land_area_sqkm, SUM(forest_area_sqkm) forest_area_sqkm, ROUND(CAST((SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59)) AS numeric)*100,2) forest_percentage
FROM abridged_f_area f
LEFT JOIN regions r
ON f.country_code = r.country_code
LEFT JOIN land_area l
ON f.country_code = l.country_code
GROUP BY 1,2
ORDER BY 5 DESC
LIMIT 1;

--2.a.3 Which region had the LOWEST percent forest in 2016?

WITH abridged_f_area AS (SELECT *
                         FROM forest_area
                         WHERE year = 2016)
SELECT f.year, region, SUM(total_area_sq_mi)*2.59 land_area_sqkm, SUM(forest_area_sqkm) forest_area_sqkm, ROUND(CAST((SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59)) AS numeric)*100,2) forest_percentage
FROM abridged_f_area f
LEFT JOIN regions r
ON f.country_code = r.country_code
LEFT JOIN land_area l
ON f.country_code = l.country_code
GROUP BY 1,2
ORDER BY 5 ASC
LIMIT 1;

--2.b.1 What was the percent forest of the entire world in 1990?

WITH abridged_f_area AS (SELECT *
                         FROM forest_area
                         WHERE year = 1990)
SELECT f.year, region, SUM(total_area_sq_mi)*2.59 land_area_sqkm, SUM(forest_area_sqkm) forest_area_sqkm, ROUND(CAST((SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59)) AS numeric)*100,2) forest_percentage
FROM abridged_f_area f
LEFT JOIN regions r
ON f.country_code = r.country_code
LEFT JOIN land_area l
ON f.country_code = l.country_code
GROUP BY 1,2
HAVING region = 'World'
ORDER BY 5 DESC;

--2.b.2 Which region had the HIGHEST percent forest in 1990?

WITH abridged_f_area AS (SELECT *
                         FROM forest_area
                         WHERE year = 1990)
SELECT f.year, region, SUM(total_area_sq_mi)*2.59 land_area_sqkm, SUM(forest_area_sqkm) forest_area_sqkm, ROUND(CAST((SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59)) AS numeric)*100,2) forest_percentage
FROM abridged_f_area f
LEFT JOIN regions r
ON f.country_code = r.country_code
LEFT JOIN land_area l
ON f.country_code = l.country_code
GROUP BY 1,2
ORDER BY 5 DESC
LIMIT 1;

--2.b.3 Which region had the LOWEST percent forest in 1990?

WITH abridged_f_area AS (SELECT *
                         FROM forest_area
                         WHERE year = 1990)
SELECT f.year, region, SUM(total_area_sq_mi)*2.59 land_area_sqkm, SUM(forest_area_sqkm) forest_area_sqkm, ROUND(CAST((SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59)) AS numeric)*100,2) forest_percentage
FROM abridged_f_area f
LEFT JOIN regions r
ON f.country_code = r.country_code
LEFT JOIN land_area l
ON f.country_code = l.country_code
GROUP BY 1,2
ORDER BY 5 ASC
LIMIT 1;

--2.c Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?

WITH forestation AS
(WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
),
abridged_f1990 AS (
  SELECT *
  FROM forest_area
  WHERE year = 1990
)
SELECT f16.years, f16.region, f16.forest_percentage AS fp16, f90.forest_percentage AS fp90, Round(CAST(f16.forest_percentage-f90.forest_percentage AS Numeric),2) AS fp_diff
FROM (
  SELECT f1.year AS years, r1.region AS region, ROUND(CAST(SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59)*100 AS Numeric),2) AS forest_percentage
  FROM abridged_f2016 f1
  LEFT JOIN regions r1 ON f1.country_code = r1.country_code
  LEFT JOIN land_area l1 ON f1.country_code = l1.country_code
  WHERE f1.year = 2016
  GROUP BY 1, 2
) f16
LEFT JOIN (
  SELECT f2.year AS years, r2.region AS region, ROUND(CAST(SUM(forest_area_sqkm)/(SUM(total_area_sq_mi)*2.59)*100 AS Numeric),2) AS forest_percentage
  FROM abridged_f1990 f2
  LEFT JOIN regions r2 ON f2.country_code = r2.country_code
  LEFT JOIN land_area l2 ON f2.country_code = l2.country_code
  WHERE f2.year = 1990
  GROUP BY 1, 2
) f90 ON f16.region = f90.region
ORDER BY 5)
SELECT *
FROM forestation a
WHERE a.fp16 < a.fp90;
......
There is one particularly bright spot in the data at the country level, China. This country actually increased in forest area from 1990 to 2016 by 527229.06 km2. 
It would be interesting to study what has changed in this country over this time to drive this figure in the data higher. 
The country with the next largest increase in forest area from 1990 to 2016 was the United States, but it only saw an increase of 79200 km2, much lower than the figure for China.

China and United States are of course very large countries in total land area, so when we look at the largest percent change in forest area from 1990 to 2016,
we aren’t surprised to find a much smaller country listed at the top. 


WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
),
abridged_f1990 AS (
  SELECT *
  FROM forest_area
  WHERE year = 1990
)
SELECT f16.country AS country, f16.fa16_sqkm, f90.fa90_sqkm, f16.fa16_sqkm - f90.fa90_sqkm change
FROM (
  SELECT f1.country_name AS country, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm
  FROM abridged_f2016 f1
  WHERE f1.year = 2016
  GROUP BY 1
) f16
LEFT JOIN (
  SELECT f2.country_name AS country, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa90_sqkm
  FROM abridged_f1990 f2
  WHERE f2.year = 1990
  GROUP BY 1
) f90 ON f16.country = f90.country
GROUP BY 1,2,3
HAVING f16.fa16_sqkm - f90.fa90_sqkm >0 OR f16.fa16_sqkm - f90.fa90_sqkm < 0
ORDER BY 4 DESC;

......

--3.a Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?

WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
),
abridged_f1990 AS (
  SELECT *
  FROM forest_area
  WHERE year = 1990
)
SELECT f16.region region, f16.country AS country, f16.fa16_sqkm, f90.fa90_sqkm, f16.fa16_sqkm-f90.fa90_sqkm fa_change
FROM (
  SELECT r1.region region, f1.country_name AS country, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm
  FROM abridged_f2016 f1
  LEFT JOIN regions r1 ON r1.country_code = f1.country_code
  WHERE f1.year = 2016
  GROUP BY 1,2
) f16
LEFT JOIN (
  SELECT r2.region region, f2.country_name AS country, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa90_sqkm
  FROM abridged_f1990 f2
  LEFT JOIN regions r2 ON r2.country_code = f2.country_code
  WHERE f2.year = 1990
  GROUP BY 1,2
) f90 ON f16.country = f90.country
GROUP BY 1,2,3,4
HAVING ((f16.fa16_sqkm-f90.fa90_sqkm)*100 >0 OR (f16.fa16_sqkm-f90.fa90_sqkm)*100 < 0) AND (f16.country != 'World')
ORDER BY 5 ASC
LIMIT 5;

--3.b Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?

WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
),
abridged_f1990 AS (
  SELECT *
  FROM forest_area
  WHERE year = 1990
)
SELECT f16.region region, f16.country AS country, f16.fa16_sqkm, f90.fa90_sqkm, ROUND(CAST(((f16.fa16_sqkm - f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) percent_change
FROM (
  SELECT r1.region region, f1.country_name AS country, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm
  FROM abridged_f2016 f1
  LEFT JOIN regions r1 ON r1.country_code = f1.country_code
  WHERE f1.year = 2016
  GROUP BY 1,2
) f16
LEFT JOIN (
  SELECT r2.region region, f2.country_name AS country, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa90_sqkm
  FROM abridged_f1990 f2
  LEFT JOIN regions r2 ON r2.country_code = f2.country_code
  WHERE f2.year = 1990
  GROUP BY 1,2
) f90 ON f16.country = f90.country
GROUP BY 1,2,3,4
HAVING (((f16.fa16_sqkm - f90.fa90_sqkm)/f90.fa90_sqkm)*100 >0 OR ((f16.fa16_sqkm - f90.fa90_sqkm)/f90.fa90_sqkm)*100 < 0) AND (f16.country != 'World')
ORDER BY 5 ASC
LIMIT 5;


-----

--3.c If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?

WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
)
SELECT
  f2.quartile,
  COUNT(*) AS num_countries
FROM
(
  SELECT
    f1.country,
    CASE 
		WHEN ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) >= 75 THEN 4
		WHEN ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2)< 75 AND ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) >= 50 THEN 3
		WHEN ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2)< 50 AND ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) >= 25 THEN 2
		ELSE 1
	END AS quartile
  FROM
    (
      SELECT
        f1.country_name AS country,
        ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm,
        ROUND(CAST(SUM(total_area_sq_mi)*2.59 AS Numeric),2) AS la16_sqkm
      FROM abridged_f2016 f1
      LEFT JOIN land_area l1 ON l1.country_code = f1.country_code
      GROUP BY f1.country_name
    ) f1
	GROUP BY 1
	HAVING ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) != 0
) f2
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


--3.d List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.

WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
)
SELECT
  f2.quartile,
  f2.countries,
  f2.percent_forestation_2016,
  f2.regions
FROM
(
  SELECT
    f1.country countries,
  	f1.region regions,
    ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) percent_forestation_2016,
    CASE 
		WHEN ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) >= 75 THEN 4
		WHEN ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2)< 75 AND ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) >= 50 THEN 3
		WHEN ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2)< 50 AND ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) >= 25 THEN 2
		ELSE 1
	END AS quartile
  FROM
    (
      SELECT
        f.country_name AS country,
      	r.region as region,
        ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm,
        ROUND(CAST(SUM(total_area_sq_mi)*2.59 AS Numeric),2) AS la16_sqkm
      FROM abridged_f2016 f
      LEFT JOIN land_area l ON l.country_code = f.country_code
      LEFT JOIN regions r ON r.country_code = f.country_code
      GROUP BY f.country_name, r.region
    ) f1
	GROUP BY 1,2
	HAVING ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) != 0
) f2
GROUP BY 1,2,3,4
HAVING percent_forestation_2016 <> 0 AND f2.quartile = 4
ORDER BY 3 DESC;

--3.e How many countries had a percent forestation higher than the United States in 2016?


WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
)
SELECT
  f2.countries,
  f2.percent_forestation_2016
FROM
(
  SELECT
    f1.country countries,
    ROUND(CAST(SUM(f1.fa16_sqkm/f1.la16_sqkm)*100 AS Numeric),2) percent_forestation_2016
  FROM
    (
      SELECT
        f.country_name country,
        ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) fa16_sqkm,
        ROUND(CAST(SUM(total_area_sq_mi)*2.59 AS Numeric), 2) la16_sqkm
      FROM abridged_f2016 f
      LEFT JOIN land_area l ON l.country_code = f.country_code
      GROUP BY f.country_name
    ) f1
  GROUP BY f1.country
) f2
WHERE f2.percent_forestation_2016 > (
  SELECT ROUND(CAST(SUM(f0.fa16_sqkm/f0.la16_sqkm)*100 AS Numeric), 2)
  FROM (
    SELECT
      f.country_name country1,
      ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) fa16_sqkm,
      ROUND(CAST(SUM(total_area_sq_mi)*2.59 AS Numeric),2) la16_sqkm
    FROM abridged_f2016 f
    LEFT JOIN land_area l ON l.country_code=f.country_code
    GROUP BY f.country_name
  ) f0
  WHERE f0.country1 = 'United States'
)
ORDER BY 2 DESC;



*In the following 3 questions (3f,3g,3h), I also calculated the change in forestation percentage. Thus, i didn't use only 2016 forestation percentages. 

I answer last 3 questions according to percentage changes between 1990 and 2016.


--3.f If countries were grouped by percent forestation change in quartiles, which group had the most countries (1990-2016)?

*I could use NTILE() function but there was a requirement for the usage of CASE command in the rubric.

WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
),
abridged_f1990 AS (
  SELECT *
  FROM forest_area
  WHERE year = 1990
)
SELECT f16.region region, f16.country AS country, f16.fa16_sqkm, f90.fa90_sqkm,
  CASE 
    WHEN ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) >= 75 THEN 4
    WHEN ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) < 75 AND ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) >= 50 THEN 3
    WHEN ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) < 50 AND ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) >= 25 THEN 2
    ELSE 1
  END AS percentile_grouped,
  ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) AS percent_change
FROM (
  SELECT r1.region AS region, f1.country_name AS country, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm
  FROM abridged_f2016 f1
  LEFT JOIN regions r1 ON r1.country_code = f1.country_code
  WHERE f1.year = 2016
  GROUP BY 1, 2
) f16
LEFT JOIN (
  SELECT r2.region region, f2.country_name AS country, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa90_sqkm
  FROM abridged_f1990 f2
  LEFT JOIN regions r2 ON r2.country_code = f2.country_code
  WHERE f2.year = 1990
  GROUP BY 1, 2
) f90 ON f16.country = f90.country
WHERE (((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100) <> 0 AND f16.country != 'World'
ORDER BY percent_change ASC;

--3.g List all of the countries that were in the 4th quartile (percent forest change > 75%) (1990-2016).

WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
),
abridged_f1990 AS (
  SELECT *
  FROM forest_area
  WHERE year = 1990
)
SELECT 	f16.country1,
		ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) percent_forest
	FROM (
		  SELECT f1.country_name AS country1, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm
		  FROM abridged_f2016 f1
		  LEFT JOIN regions r1 ON r1.country_code = f1.country_code
		  GROUP BY 1
		) f16
	LEFT JOIN (
		  SELECT f2.country_name AS country2, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa90_sqkm
		  FROM abridged_f1990 f2
		  LEFT JOIN regions r2 ON r2.country_code = f2.country_code
		  GROUP BY 1
		) f90 ON f16.country1 = f90.country2
WHERE f16.country1 != 'World' AND ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2)>= 75
ORDER BY 2 DESC;

--3.h How many countries had a percent forestation change higher than the United States (1990-2016)?

WITH abridged_f2016 AS (
  SELECT *
  FROM forest_area
  WHERE year = 2016
),
abridged_f1990 AS (
  SELECT *
  FROM forest_area
  WHERE year = 1990
)
SELECT 	COUNT(*) higher_than_USA
	FROM (
		  SELECT f1.country_name AS country1, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm
		  FROM abridged_f2016 f1
		  LEFT JOIN regions r1 ON r1.country_code = f1.country_code
		  GROUP BY 1
		) f16
	LEFT JOIN (
		  SELECT f2.country_name AS country2, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa90_sqkm
		  FROM abridged_f1990 f2
		  LEFT JOIN regions r2 ON r2.country_code = f2.country_code
		  GROUP BY 1
		) f90 ON f16.country1 = f90.country2
WHERE ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) > (
					SELECT ROUND(CAST(((f16.fa16_sqkm-f90.fa90_sqkm)/f90.fa90_sqkm)*100 AS Numeric),2) percent_forest
					FROM (
						SELECT f1.country_name AS country1, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa16_sqkm
						FROM abridged_f2016 f1
						LEFT JOIN regions r1 
						ON r1.country_code = f1.country_code
						GROUP BY 1
						) f16
					LEFT JOIN (
						SELECT f2.country_name AS country2, ROUND(CAST(SUM(forest_area_sqkm) AS Numeric),2) AS fa90_sqkm
						FROM abridged_f1990 f2
						LEFT JOIN regions r2 ON r2.country_code = f2.country_code
						GROUP BY 1) f90 
					ON f16.country1 = f90.country2
					WHERE f16.country1 = 'United States');