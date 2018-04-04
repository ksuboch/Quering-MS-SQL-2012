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
