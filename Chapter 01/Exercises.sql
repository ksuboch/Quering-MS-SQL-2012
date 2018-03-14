USE TSQL2012;

--non relatonal
--1. no column alias
--2. sorting use number of column
--3. can return duplicates
--4. result orders by something
SELECT
  custid
 ,YEAR(orderdate)
FROM Sales.Orders
ORDER BY 1, 2;

--relational
SELECT DISTINCT
  custid
 ,YEAR(orderdate) AS orderyear
FROM Sales.Orders;

--error
SELECT
  custid
 ,orderid
FROM Sales.Orders
GROUP BY custid;

--correct
SELECT
  custid
 ,MAX(orderid)
FROM Sales.Orders
GROUP BY custid;

--error
SELECT
  shipperid
 ,SUM(freight) AS totalfreight
FROM Sales.Orders
WHERE freight > 20000
GROUP BY shipperid;

--correct
SELECT
  shipperid
 ,SUM(freight) AS totalfreight
FROM Sales.Orders
GROUP BY shipperid
HAVING SUM(freight) > 20000;

