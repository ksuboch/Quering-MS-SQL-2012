USE TSQL2012;

--error filtering
SELECT
  orderid
 ,orderdate
 ,custid
 ,empid
FROM Sales.Orders
WHERE shippeddate = NULL;

--correct filtering
SELECT
  orderid
 ,orderdate
 ,custid
 ,empid
FROM Sales.Orders
WHERE shippeddate IS NULL;

--filtering using date column and BETWEEN
SELECT
  orderid
 ,orderdate
 ,custid
 ,empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20080211' AND '20080211 23:59:59.999';

--correct filtering
SELECT
  orderid
 ,orderdate
 ,custid
 ,empid
FROM Sales.Orders
WHERE orderdate >= '20080211' AND orderdate < '20080213';
