-- Write a query modification of the above example query that shows the duration of each ride as a percentage of the total time accrued by riders from each start_terminal.

SELECT start_terminal,
       duration_seconds, SUM(duration_seconds) OVER
         (PARTITION BY start_terminal) AS start_terminal_total,
         duration_seconds/SUM(duration_seconds) OVER
         (PARTITION BY start_terminal)*100 AS percent_of_total
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, percent_of_total DESC;

-- Write a query that shows a running total of the duration of bike rides (similar to the last example), but grouped by end_terminal, and with ride duration sorted in descending order.

SELECT end_terminal,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY end_terminal ORDER BY duration_seconds DESC) AS running_total
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08';

 -- Write a query that shows the 5 longest rides from each starting terminal, ordered by terminal, and longest to shortest rides within each terminal. Limit to rides that occurred before Jan. 8, 2012.

SELECT *
FROM(
SELECT start_terminal, start_time,
       duration_seconds,
       RANK() OVER (PARTITION BY start_terminal
                    ORDER BY duration_seconds DESC)
              AS rank
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08') sub
 WHERE sub.rank<=5;
