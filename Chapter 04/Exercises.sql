USE TSQL2012;

--inner join
SELECT
     C.custid
    ,C.companyname
    ,O.orderid
    ,O.orderdate
FROM Sales.Customers AS C
    INNER JOIN Sales.Orders AS O
        ON C.custid = O.custid;

--left outer join
SELECT
     C.custid
    ,C.companyname
    ,O.orderid
    ,O.orderdate
FROM Sales.Customers AS C
    LEFT OUTER JOIN Sales.Orders AS O
        ON C.custid = O.custid
WHERE orderdate >= '20080201' AND orderdate < '20080301';

--left outer join
SELECT
     C.custid
    ,C.companyname
    ,O.orderid
    ,O.orderdate
FROM Sales.Customers AS C
    LEFT OUTER JOIN Sales.Orders AS O
        ON C.custid = O.custid
WHERE O.orderid IS NULL;

--CTE
SELECT
     categoryid
    ,MIN(unitprice) AS mn
FROM Production.Products
GROUP BY categoryid;

WITH CatMin AS
    (SELECT
        categoryid
        ,MIN(unitprice) AS mn
    FROM Production.Products
    GROUP BY categoryid)
SELECT
     P.categoryid
    ,P.productid
    ,P.productname
    ,P.unitprice
FROM Production.Products AS P
    INNER JOIN CatMin AS M
        ON P.categoryid = M.categoryid
            AND P.unitprice = M.mn;

--apply
IF OBJECT_ID('Production.GetTopProducts', 'IF') IS NOT NULL
DROP FUNCTION Production.GetTopProducts;
GO

CREATE FUNCTION Production.GetTopProducts(@supplierid AS INT, @n AS BIGINT)
RETURNS TABLE
AS
    RETURN
    SELECT
        productid
        ,productname
        ,unitprice
    FROM Production.Products
    WHERE supplierid = @supplierid
    ORDER BY unitprice, productid
    OFFSET 0 ROWS FETCH FIRST @n ROWS ONLY;
GO

SELECT * FROM Production.GetTopProducts(1, 2) AS P;

SELECT
     S.supplierid
    ,S.companyname AS supplier
    ,A.*
FROM Production.Suppliers AS S
    CROSS APPLY Production.GetTopProducts(S.supplierid, 2) AS A
WHERE S.country = N'Japan';

SELECT
     S.supplierid
    ,S.companyname AS supplier
    ,A.*
FROM Production.Suppliers AS S
    OUTER APPLY Production.GetTopProducts(S.supplierid, 2) AS A
WHERE S.country = N'Japan';

IF OBJECT_ID('Production.GetTopProducts', 'IF') IS NOT NULL
DROP FUNCTION Production.GetTopProducts;
GO
