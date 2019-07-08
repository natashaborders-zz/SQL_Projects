--## Part II: Baseball Data

--Please complete this exercise via SQLalchemy and Jupyter notebook.

--We will be working with the Lahman baseball data we uploaded to your AWS instance in class.

--1. What was the total spent on salaries by each team, each year?

SELECT teamid, yearid, sum(salary)
FROM salaries
GROUP BY teamid, yearid
ORDER BY teamid, yearid;


-- 2. What is the first and last year played for each player? *Hint:* Create a new table from 'Fielding.csv'.

____
playerID,yearID,stint,teamID,lgID,POS,G,GS,InnOuts,PO,A,E,DP,PB,WP,SB,CS,ZR
ansonca01,1871,1,RC1,NA,1B,1,,,7,0,0,0,,,,,
biermch01,1871,1,FW1,NA,1B,1,,,9,0,2,0,,,,,
carleji01,1871,1,CL1,NA,1B,29,,,295,4,34,10,,,,,
___
CREATE TABLE IF NOT EXISTS Fielding (id serial PRIMARY KEY, playerID varchar(20) NOT NULL,
yearID int NOT NULL, stint int NOT NULL, teamID text DEFAULT NULL, lgID text DEFAULT NULL,
POS text DEFAULT NULL, G int DEFAULT NULL, GS int DEFAULT NULL, InnOuts int DEFAULT NULL,
PO int DEFAULT NULL, A int DEFAULT NULL, E int DEFAULT NULL, DP int DEFAULT NULL, PB int DEFAULT NULL,
WP int DEFAULT NULL, SB int DEFAULT NULL, CS int DEFAULT NULL, ZR int DEFAULT NULL);
___
COPY Fielding (playerID,yearID,stint,teamID,lgID,POS,G,GS,InnOuts,PO,A,E,DP,PB,WP,SB,CS,ZR)  FROM '/home/ubuntu/baseballdata/Fielding.csv' DELIMITER ',' CSV HEADER;
___

SELECT playerid, MIN(yearid), MAX(yearid)
FROM fielding
GROUP BY playerid;

--3. Who has played the most all star games?


SELECT playerID, COUNT(DISTINCT(gameid))
FROM allstarfull
GROUP BY playerid
ORDER BY COUNT(DISTINCT(gameid))
DESC LIMIT 1;



-- 4. Which school has generated the most distinct players? *Hint:* Create new table from 'CollegePlaying.csv'.
___
playerID,schoolID,yearMin,yearMax
aardsda01,pennst,2001,2001
aardsda01,rice,2002,2003
abbeybe01,vermont,1888,1892
abbotgl01,carkansas,1970,1970
___
CREATE TABLE IF NOT EXISTS CollegePlaying (id serial PRIMARY KEY,
  playerID varchar(20) NOT NULL, schoolID text NOT NULL,
  yearMin int NOT NULL, yearMax int NOT NULL);
___
COPY CollegePlaying (playerID,schoolID,yearMin,yearMax)
FROM '/home/ubuntu/baseballdata/SchoolsPlayers.csv' DELIMITER ',' CSV HEADER;
___
SELECT schoolid, COUNT(DISTINCT(playerid))
FROM collegeplaying
GROUP BY schoolid
ORDER BY COUNT(DISTINCT(playerid)) DESC;


-- 5. Which players have the longest career? Assume that the `debut` and `finalGame` columns comprise the start and end, respectively, of a player's career. *Hint:* Create a new table from 'Master.csv'. Also note that strings can be converted to dates using the [`DATE`]
-- (https://wiki.postgresql.org/wiki/Working_with_Dates_and_Times_in_PostgreSQL#WORKING_with_DATETIME.2C_DATE.2C_and_INTERVAL_VALUES) function and can then be subtracted from each other yielding their difference in days.
___
playerID,birthYear,birthMonth,birthDay,birthCountry,birthState,birthCity,deathYear,deathMonth,deathDay,deathCountry,deathState,deathCity,nameFirst,nameLast,nameGiven,weight,height,bats,throws,debut,finalGame,retroID,bbrefID
aardsda01,1981,12,27,USA,CO,Denver,,,,,,,David,Aardsma,David Allan,205,75,R,R,2004-04-06,2013-09-28,aardd001,aardsda01
aaronha01,1934,2,5,USA,AL,Mobile,,,,,,,Hank,Aaron,Henry Louis,180,72,R,R,1954-04-13,1976-10-03,aaroh101,aaronha01
aaronto01,1939,8,5,USA,AL,Mobile,1984,8,16,USA,GA,Atlanta,Tommie,Aaron,Tommie Lee,190,75,R,R,1962-04-10,1971-09-26,aarot101,aaronto01
___
CREATE TABLE IF NOT EXISTS Master (id serial PRIMARY KEY, playerID varchar(20) NOT NULL,
birthYear int, birthMonth int, birthDay int, birthCountry text, birthState text,
birthCity text, deathYear int, deathMonth int, deathDay int, deathCountry text,
deathState text, deathCity text, nameFirst text, nameLast text, nameGiven text, weight int,
height int, bats text, throws text, debut DATE, finalGame DATE, retroID text, bbrefID text);
___
COPY Master (playerID, birthYear, birthMonth, birthDay, birthCountry, birthState, birthCity, deathYear, deathMonth, deathDay, deathCountry, deathState, deathCity, nameFirst, nameLast, nameGiven, weight, height, bats, throws, debut, finalGame, retroID, bbrefID)  FROM '/home/ubuntu/baseballdata/Master.csv' DELIMITER ',' CSV HEADER;
___

SELECT playerId, (finalGame-debut) as career_length
FROM Master
WHERE finalgame IS NOT NULL AND debut IS NOT NULL
GROUP BY playerID, finalgame, debut
ORDER BY career_length DESC;

-- 6. What is the distribution of debut months? *Hint:* Look at the `DATE` and [`EXTRACT`](https://www.postgresql.org/docs/current/static/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT) functions.

SELECT EXTRACT(MONTH FROM debut) AS month, COUNT(*)
FROM Master WHERE debut IS NOT NULL
GROUP BY EXTRACT(MONTH FROM debut)
ORDER BY COUNT(*) DESC;

-- 7. What is the effect of table join order on mean salary for the players listed in the main (master) table? *Hint:* Perform two different queries, one that joins on playerID in the salary table and other that joins on the same column in the master table. You will have to use left joins for each since right joins are not currently supported with SQLalchemy.

SELECT salaries.playerid, AVG(salary)
FROM salaries LEFT JOIN Master ON salaries.playerID = Master.playerId
GROUP BY salaries.playerid;

playerid  |       avg
-----------+------------------
 saitota01 | 1866666.66666667
 escaled01 |           491000
 ramirju01 |           250000
 suzukma01 | 250666.666666667
 meyerjo01 |            78750

SELECT master.playerid, AVG(salary)
FROM Master LEFT JOIN salaries ON Master.playerId = salaries.playerID
GROUP BY master.playerid; 


 playerid  |       avg
-----------+------------------
 jacobar01 |
 kriegbi01 |
 loesbi01  |
 peppela01 |
 cathete01 |
 solommo01 |
 westbu01  |
 nashji01  |
 ramirju01 |           250000
