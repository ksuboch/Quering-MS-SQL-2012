USE TSQL2012;

--multiset
SELECT
  country
FROM HR.Employees;

--set
SELECT DISTINCT
  country
FROM HR.Employees;

--no sorting by default
SELECT
  empid
 ,lastname
FROM HR.Employees;

--ordering by empid field
SELECT
  empid
 ,lastname
FROM HR.Employees
ORDER BY empid;

--non-relational ordering
SELECT
  empid
 ,lastname
FROM HR.Employees
ORDER BY 1;

--non-relational (no alias)
SELECT
  empid
 ,firstname + ' ' + lastname --AS fullname
FROM HR.Employees;

--order of entering qurery
--SELECT > FROM > WHERE > GROUP BY > HAVING > ORDER BY
--order of executing query
--FROM > WHERE > GORUP BY > HAVING > SELECT > ORDER BY

SELECT
  country
 ,YEAR(hiredate) AS yearhired
 ,COUNT(*) AS numemployees
FROM HR.Employees
WHERE hiredate >= '20030101'
GROUP BY country
        ,YEAR(hiredate)
HAVING COUNT(*) > 1
ORDER BY country, yearhired
DESC;
