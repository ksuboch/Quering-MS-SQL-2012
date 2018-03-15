USE TSQL2012;

SELECT
  empid
 ,firstname
 ,lastname
 ,country
 ,region
 ,city
FROM HR.Employees
WHERE country = N'USA';

--filtering
SELECT
  e.empid
 ,e.firstname
 ,e.lastname
 ,e.country
 ,e.region
 ,e.city
FROM HR.Employees AS e
WHERE e.region = N'WA';

--filtering (null values)
SELECT
  e.empid
 ,e.firstname
 ,e.lastname
 ,e.country
 ,e.region
 ,e.city
FROM HR.Employees AS e
WHERE e.region <> N'WA'
OR e.region IS NULL;

--orders that was shipped
SELECT
  orderid
 ,orderdate
 ,empid
FROM Sales.Orders
WHERE shippeddate = @dt
OR (shippeddate IS NULL
AND @dt IS NULL);

--filtering strings using template
SELECT
  empid
 ,firstname
 ,lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

--filtering using data
SELECT
  orderid
 ,empid
 ,custid
FROM Sales.Orders
WHERE orderdate = '20070212';

--don't use between; use >= and <
SELECT
  orderid
 ,orderdate
 ,empid
 ,custid
FROM Sales.Orders
WHERE orderdate >= '20070201'
AND orderdate < '20070301';

--sorting employees
SELECT
  empid
 ,firstname
 ,lastname
 ,city
 ,MONTH(birthdate) AS birthmonth
FROM HR.Employees
WHERE country = N'USA'
AND region = N'WA'
ORDER BY city;

--reversed sorting (non-determinated)
SELECT
  empid
 ,firstname
 ,lastname
 ,city
 ,MONTH(birthdate) AS birthmonth
FROM HR.Employees
WHERE country = N'USA'
AND region = N'WA'
ORDER BY city DESC;

--determinated sorting
SELECT
  empid
 ,firstname
 ,lastname
 ,city
 ,MONTH(birthdate) AS birthmonth
FROM HR.Employees
WHERE country = N'USA'
AND region = N'WA'
ORDER BY city, empid;

--ordering by field not from select
SELECT
  empid
 ,city
FROM HR.Employees
WHERE country = N'USA'
AND region = N'WA'
ORDER BY birthdate;

--ordering error
--SELECT DISTINCT city
--FROM HR.Employees
--WHERE country = N'USA' AND region = N'WA'
--ORDER BY birthdate;

--correct ordering
SELECT DISTINCT
  city
FROM HR.Employees
WHERE country = N'USA' AND region = N'WA'
ORDER BY birthdate;

--sorting nulls
SELECT orderid, shippeddate
FROM Sales.Orders
WHERE custid = 20
ORDER BY shippeddate;