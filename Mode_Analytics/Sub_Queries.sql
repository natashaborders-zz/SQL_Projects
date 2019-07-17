-- Write a query that selects all Warrant Arrests from the tutorial.sf_crime_incidents_2014_01 dataset, then wrap it in an outer query that only displays unresolved incidents.

SELECT sub.*
FROM
  (SELECT *
  FROM tutorial.sf_crime_incidents_2014_01
  WHERE descript = 'WARRANT ARREST') sub
WHERE resolution = 'NONE';

-- Write a query that displays the average number of monthly incidents for each category. Hint: use tutorial.sf_crime_incidents_cleandate to make your life a little easier.

SELECT category, sub.cleaned_date_month, AVG(sub.num_accidents)
FROM (
  SELECT category, LEFT(date, 2) AS cleaned_date_month,
  COUNT(*) AS num_accidents
  FROM tutorial.sf_crime_incidents_cleandate
  GROUP BY category, cleaned_date_month) sub
GROUP BY sub.category, sub.cleaned_date_month;

-- Write a query that displays all rows from the three categories with the fewest incidents reported.

SELECT * FROM tutorial.sf_crime_incidents_cleandate incidents JOIN
    (SELECT category, COUNT(*) AS incident_num
      FROM tutorial.sf_crime_incidents_cleandate
      GROUP BY category
      ORDER BY incident_num
      LIMIT 3) sub
      ON incidents.category = sub.category;

--Write a query that counts the number of companies founded and acquired by quarter starting in Q1 2012. Create the aggregations in two separate queries, then join them.

SELECT funded.quarter, funded.companies_funded, acquisitions.companies_acquired
FROM
(SELECT funded_quarter AS quarter,
  COUNT(DISTINCT company_permalink) AS companies_funded
  FROM tutorial.crunchbase_investments
  WHERE funded_quarter>='2012-Q1'
  GROUP BY quarter) funded JOIN
(SELECT acquired_quarter AS quarter,
               COUNT(DISTINCT company_permalink) AS companies_acquired
          FROM tutorial.crunchbase_acquisitions
          WHERE acquired_quarter>='2012-Q1'
         GROUP BY quarter) acquisitions
ON funded.quarter = acquisitions.quarter
ORDER BY funded.quarter;


--Write a query that ranks investors from the combined dataset above by the total number of investments they have made.

SELECT investor_name, COUNT(*) AS num_investments, RANK () OVER (ORDER BY COUNT(*) DESC)
  FROM (
        SELECT *
          FROM tutorial.crunchbase_investments_part1
         UNION ALL
        SELECT *
          FROM tutorial.crunchbase_investments_part2
       ) sub
GROUP BY investor_name;
