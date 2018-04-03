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

--getting client ordders by clientid
SELECT
   orderid
  ,empid
  ,shipperid
  ,shippeddate
FROM Sales.Orders
WHERE custid = 77;

--getting client ordders by clientid with ordering
SELECT
   orderid
  ,empid
  ,shipperid
  ,shippeddate
FROM Sales.Orders
WHERE custid = 77
ORDER BY shipperid;

--determin ordering
SELECT
   orderid
  ,empid
  ,shipperid
  ,shippeddate
FROM Sales.Orders
WHERE custid = 77
ORDER BY shipperid, shippeddate DESC, orderid DESC;

--top 5 products
SELECT TOP(5)
   productid
  ,unitprice
FROM Production.Products
WHERE categoryid = 1
ORDER BY unitprice DESC;

--top 5 prices
SELECT TOP(5) WITH TIES
   productid
  ,unitprice
FROM Production.Products
WHERE categoryid = 1
ORDER BY unitprice DESC;

--top 5
SELECT TOP(5)
   productid
  ,unitprice
FROM Production.Products
WHERE categoryid = 1
ORDER BY unitprice DESC, productid DESC;

--first 5 products
SELECT
   productid
  ,categoryid
  ,unitprice
FROM Production.Products
ORDER BY unitprice, productid
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

--next 5 rows
SELECT
   productid
  ,categoryid
  ,unitprice
FROM Production.Products
ORDER BY unitprice, productid
OFFSET 5 ROWS FETCH FIRST 5 ROWS ONLY;
