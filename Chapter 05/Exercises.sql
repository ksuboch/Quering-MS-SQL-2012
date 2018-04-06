USE TSQL2012;

SELECT
    C.custid,
    COUNT(*) AS numorders
FROM Sales.Orders AS O
    INNER JOIN Sales.Customers AS C
        ON O.custid = C.custid
WHERE C.country = N'Spain'
GROUP BY C.custid;

SELECT
     C.custid
    ,COUNT(*) AS numorders
    ,C.city
FROM Sales.Orders AS O
    INNER JOIN Sales.Customers AS C
        ON O.custid = C.custid
WHERE C.country = N'Spain'
GROUP BY C.custid, C.city;

SELECT
     C.custid
    ,COUNT(*) AS numorders
    ,C.city
FROM Sales.Orders AS O
    INNER JOIN Sales.Customers AS C
        ON O.custid = C.custid
WHERE C.country = N'Spain'
GROUP BY GROUPING SETS ( (C.custid, C.city) , ())
ORDER BY GROUPING(C.custid);

WITH OrderCTE AS
(
    SELECT
         YEAR(orderdate) AS orderyear
        ,shippeddate
        ,shipperid
    FROM Sales.Orders
)
SELECT orderyear, [1], [2], [3]
FROM OrderCTE PIVOT( MAX(shippeddate) FOR shipperid IN ([1],[2],[3])) AS P;

WITH PivotData AS
(
    SELECT
        custid
        ,shipperid
        ,orderid
    FROM Sales.Orders
)
SELECT custid, [1], [2], [3]
FROM PivotData PIVOT( COUNT(orderid) FOR  shipperid IN ([1],[2],[3])) AS P;
