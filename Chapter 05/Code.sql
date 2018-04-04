USE TSQL2012;

--grouping
SELECT COUNT(*)
FROM Sales.Orders;

SELECT
     shipperid
    ,COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY shipperid;

SELECT
     shipperid
    ,YEAR(shippeddate) AS shippedyear
    ,COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY
     shipperid
    ,YEAR(shippeddate);

SELECT
     shipperid
    ,YEAR(shippeddate) AS shippedyear
    ,COUNT(*) AS numorders
FROM Sales.Orders
WHERE shippeddate IS NOT NULL
GROUP BY
     shipperid
    ,YEAR(shippeddate)
HAVING COUNT(*) < 100;

--stat functions
SELECT
     shipperid
    ,COUNT(*) AS numorders
    ,COUNT(shippeddate) AS shippedorders
    ,MIN(shippeddate) AS firstshippeddate
    ,MAX(shippeddate) AS lastshippeddate
    ,SUM(val) AS totalvalue
FROM Sales.OrderValues
GROUP BY shipperid;

--grouping with name
SELECT
     S.shipperid
    ,S.companyname
    ,COUNT(*) AS numorders
FROM Sales.Shippers AS S
    INNER JOIN Sales.Orders AS O
        ON S.shipperid = O.shipperid
GROUP BY S.shipperid, S.companyname;

SELECT
     S.shipperid
    ,MAX(S.companyname)
    ,COUNT(*) AS numorders
FROM Sales.Shippers AS S
    INNER JOIN Sales.Orders AS O
        ON S.shipperid = O.shipperid
GROUP BY S.shipperid;

WITH C AS
( SELECT
     shipperid
    ,COUNT(*) AS numorders
  FROM Sales.Orders
  GROUP BY shipperid)
SELECT
     S.shipperid
    ,S.companyname
    ,numorders
FROM Sales.Shippers AS S
    INNER JOIN C
        ON S.shipperid = C.shipperid;

--groupping sets
SELECT
     shipperid
    ,YEAR(shippeddate) AS shippedyear
    ,COUNT(*) AS numorders
FROM Sales.Orders
WHERE shippeddate IS NOT NULL
GROUP BY GROUPING SETS
(
     (shipperid, YEAR(shippeddate))
    ,(shipperid                   )
    ,(YEAR(shippeddate)           )
    ,(                            )
);

--cube
SELECT
     shipperid
    ,YEAR(shippeddate) AS shippedyear
    ,COUNT(*) AS numorders
FROM Sales.Orders
WHERE shippeddate IS NOT NULL
GROUP BY CUBE
    (shipperid, YEAR(shippeddate));

--rollup
SELECT
     shipcountry
    ,shipregion
    ,shipcity
    ,COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY ROLLUP(shipcountry, shipregion, shipcity);

--grouping
SELECT
     shipcountry
    ,GROUPING(shipcountry) AS grpcountry
    ,shipregion
    ,GROUPING(shipregion)  AS grpregion
    ,shipcity
    ,GROUPING(shipcity)    AS grpcity
    ,COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY ROLLUP(shipcountry, shipregion, shipcity);

--grouping_id
SELECT
     GROUPING_ID(shipcountry, shipregion, shipcity) AS grp_id
    ,shipcountry
    ,shipregion
    ,shipcity
    ,COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY ROLLUP(shipcountry, shipregion, shipcity);
