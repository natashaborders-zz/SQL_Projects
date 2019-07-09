-- You are given a table, Functions, containing two columns: X and Y. Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1. Write a query to output all such symmetric pairs in ascending order by the value of X.

--https://www.hackerrank.com/challenges/symmetric-pairs/problem

SELECT a.X, a.Y
FROM Functions a INNER JOIN Functions b
ON a.X = b.Y AND b.X = a.Y
GROUP BY a.X, a.Y
HAVING COUNT(a.X)>1 OR a.X<a.Y
ORDER BY a.X;
