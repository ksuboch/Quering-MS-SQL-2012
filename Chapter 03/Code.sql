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
DECLARE @t AS DATETIME;

SELECT
  orderid
 ,orderdate
 ,empid
FROM Sales.Orders
WHERE shippeddate = @t
OR (shippeddate IS NULL
AND @t IS NULL);

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

--limit selection
SELECT TOP(3)
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--total with percent
SELECT TOP(1) PERCENT
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--top with vars
DECLARE @n AS BIGINT = 5;

SELECT TOP (@n)
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--three any rows
SELECT TOP (3)
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY (SELECT NULL);

--determin result
SELECT TOP(3) WITH TIES
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY orderdate DESC;

--using offset - fetch
SELECT
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

--top analogue
SELECT
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 0 ROWS FETCH FIRST 25 ROWS ONLY;

--offset without fetch
SELECT
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 50 ROWS;

--select any rows
SELECT
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY (SELECT NULL)
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;

--pager
DECLARE @pagesize AS BIGINT = 25, @pagenum AS BIGINT = 3;

SELECT
   orderid
  ,orderdate
  ,custid
  ,empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET (@pagenum - 1) * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;
