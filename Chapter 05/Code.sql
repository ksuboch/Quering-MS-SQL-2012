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

--pivot
WITH PivotData AS
(
    SELECT
        custid,
        shipperid,
        freight
    FROM Sales.Orders
)
SElECT
    custid,
    [1],
    [2],
    [3]
FROM PivotData
PIVOT(SUM(freight) FOR shipperid IN ([1], [2], [3])) AS P;

--unpivot
IF OBJECT_ID('Sales.FreightTotals') IS NOT NULL
DROP TABLE Sales.FreigtTotals;
GO

WITH PivotData AS
(
    SELECT
        custid,
        shipperid,
        freight
    FROM Sales.Orders
)
SElECT
    *
INTO Sales.FreigtTotals
FROM PivotData
PIVOT(SUM(freight) FOR shipperid IN ([1], [2], [3])) AS P;

SELECT * FROM Sales.FreigtTotals;

SELECT
     custid
    ,shipperid
    ,freight
FROM Sales.FreigtTotals
UNPIVOT(freight FOR shipperid IN ([1], [2], [3])) AS U;

IF OBJECT_ID('Sales.FreightTotals') IS NOT NULL
DROP TABLE Sales.FreigtTotals;

--window functions
SELECT
     custid
    ,orderid
    ,val
    ,SUM(val) OVER (PARTITION BY custid) AS custtotal
    ,SUM(val) OVER () AS grandtotal
FROM Sales.OrderValues;

SELECT
     custid
    ,orderid
    ,val
    ,CAST(100.0 * val / SUM(val) OVER (PARTITION BY custid) AS NUMERIC(5, 2)) AS pctcust
    ,CAST(100.0 * val / SUM(val) OVER ()                    AS NUMERIC(5, 2)) AS pcttotal
FROM Sales.OrderValues;

--bounds
SELECT
     custid
    ,orderid
    ,orderdate
    ,val
    ,SUM(val) OVER (PARTITION BY custid
                    ORDER BY orderdate, orderid
                    ROWS BETWEEN UNBOUNDED PRECEDING
                        AND CURRENT ROW) AS runtotal
FROM Sales.OrderValues;

--range window functions
SELECT
     custid
    ,orderid
    ,val
    ,ROW_NUMBER() OVER (ORDER BY val) AS rownum
    ,RANK()       OVER (ORDER BY val) AS rnk
    ,DENSE_RANK() OVER (ORDER BY val) AS densernk
    ,NTILE(100)   OVER (ORDER BY val) AS ntile100
FROM Sales.OrderValues;

--displacement functions
SELECT
     custid
    ,orderid
    ,orderdate
    ,val
    ,LAG(val)  OVER (PARTITION BY custid
                     ORDER BY orderdate, orderid) AS prev_val
    ,LEAD(val) OVER (PARTITION BY custid
                     ORDER BY orderdate, orderid) AS next_val
FROM Sales.OrderValues;

SELECT
     custid
    ,orderid
    ,orderdate
    ,val
    ,LAG(val, 1, 0)  OVER (PARTITION BY custid
                            ORDER BY orderdate, orderid) AS prev_val
    ,LEAD(val, 1, 0) OVER (PARTITION BY custid
                            ORDER BY orderdate, orderid) AS next_val
FROM Sales.OrderValues;

SELECT
     custid
    ,orderid
    ,orderdate
    ,val
    ,FIRST_VALUE(val) OVER (PARTITION BY custid
                            ORDER BY orderdate, orderid
                            ROWS BETWEEN UNBOUNDED PRECEDING
                                AND CURRENT ROW) AS first_value
    ,LAST_VALUE(val) OVER (PARTITION BY custid
                            ORDER BY orderdate, orderid
                            ROWS BETWEEN CURRENT ROW
                                AND UNBOUNDED FOLLOWING) AS last_value
FROM Sales.OrderValues;
