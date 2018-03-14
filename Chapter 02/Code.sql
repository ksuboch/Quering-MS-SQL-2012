USE TSQL2012;

--using FROM
SELECT
  empid
 ,firstname
 ,lastname
FROM HR.Employees;

--using pseudoname
SELECT
  e.empid
 ,e.firstname
 ,e.lastname
FROM HR.Employees AS e;

--non-relational
SELECT
  e.empid
 ,e.firstname + N' ' + e.lastname
FROM HR.Employees AS e;

--relational
SELECT
  e.empid
 ,e.firstname + N' ' + e.lastname AS fullname
FROM HR.Employees AS e;

--no duplicates (relational)
SELECT DISTINCT
  e.country
 ,e.region
 ,e.city
FROM HR.Employees AS e;

--non standart
SELECT
  10 AS col1
 ,'ABC' AS col2;
