USE TSQL2012;

INSERT INTO Production.Suppliers (companyname, contactname, contacttitle,
       address, city, postalcode, country, phone)
VALUES(N'Supplier XYZ', N'Jiru', N'Head of Security',
       N'42 Sekimai Musashino-shi', N'Tokyo', N'01759', N'Japan',
       N'(02) 4311-2609');

--cross join
SELECT
     D.ID AS theday
    ,S.ID AS shiftno
FROM dbo.Nums AS D
    CROSS JOIN dbo.Nums AS S
WHERE D.ID <= 7
    AND S.ID <= 3
ORDER BY theday, shiftno;

--inner join
SELECT
     S.companyname AS supplier
    ,S.country
    ,P.productid
    ,P.productname
    ,P.unitprice
FROM Production.Suppliers AS S
    INNER JOIN Production.Products AS P
        ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';

--inner join - the same result
SELECT
     S.companyname AS supplier
    ,S.country
    ,P.productid
    ,P.productname
    ,P.unitprice
FROM Production.Suppliers AS S
    INNER JOIN Production.Products AS P
        ON S.supplierid = P.supplierid
            AND S.country = N'Japan';

--left join
SELECT
     S.companyname AS supplier
    ,S.country
    ,P.productid
    ,P.productname
    ,P.unitprice
FROM Production.Suppliers AS S
    LEFT OUTER JOIN Production.Products AS P
        ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';

--left join - the same query
SELECT
     S.companyname AS supplier
    ,S.country
    ,P.productid
    ,P.productname
    ,P.unitprice
FROM Production.Suppliers AS S
    LEFT JOIN Production.Products AS P
        ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';

--multi join
SELECT
     S.companyname AS supplier
    ,S.country
    ,P.productname
    ,P.unitprice
    ,C.categoryname
FROM Production.Suppliers AS S
    LEFT OUTER JOIN Production.Products AS P
        ON S.supplierid = P.supplierid
    INNER JOIN Production.Categories AS C
        ON C.categoryid = P.categoryid
WHERE S.country = N'Japan';

--multi join with order
SELECT
     S.companyname AS supplier
    ,S.country
    ,P.productname
    ,P.unitprice
    ,C.categoryname
FROM Production.Suppliers AS S
    LEFT OUTER JOIN
    (Production.Products AS P
        INNER JOIN Production.Categories AS C
            ON C.categoryid = P.categoryid)
    ON S.supplierid = P.supplierid
WHERE S.country = N'Japan';

--sub-query
SELECT
     productid
    ,productname
    ,unitprice
FROM Production.Products
WHERE unitprice = (SELECT MIN(unitprice)
                    FROM Production.Products);

--multi row subquery
SELECT
     productid
    ,productname
    ,unitprice
FROM Production.Products
WHERE supplierid IN
    (SELECT supplierid
     FROM Production.Suppliers
     WHERE country = N'Japan');

--corellated subquery
SELECT
     categoryid
    ,productid
    ,productname
    ,unitprice
FROM Production.Products AS P1
WHERE unitprice = (SELECT MIN(unitprice)
                   FROM Production.Products AS P2
                   WHERE P2.categoryid = P1.categoryid);

SELECT
     custid
    ,companyname
FROM Sales.Customers AS C
WHERE EXISTS
(SELECT *
 FROM Sales.Orders AS O
 WHERE O.custid = C.custid
    AND O.orderdate = '20070212');

--table expression
SELECT
     categoryid
    ,productid
    ,productname
    ,unitprice
FROM (SELECT
         ROW_NUMBER() OVER(PARTITION BY categoryid
                            ORDER BY unitprice, productid) AS rownum
        ,categoryid
        ,productid
        ,productname
        ,unitprice
      FROM Production.Products) AS D
WHERE rownum <= 2;

--common table expression
WITH C AS
(SELECT
    ROW_NUMBER() OVER(PARTITION BY categoryid
                        ORDER BY unitprice, productid) AS rownum
    ,categoryid
    ,productid
    ,productname
    ,unitprice
FROM Production.Products)
SELECT
     categoryid
    ,productid
    ,productname
    ,unitprice
FROM C
WHERE rownum <= 2;

--recoursive cte
WITH EmpsCTE AS
(SELECT
     empid
    ,mgrid
    ,firstname
    ,lastname
    ,0 AS distance
FROM HR.Employees
WHERE empid = 9

UNION ALL

SELECT
     M.empid
    ,M.mgrid
    ,M.firstname
    ,M.lastname
    ,S.distance + 1 AS distance
FROM EmpsCTE AS S
    JOIN HR.Employees AS M
        ON M.empid = S.mgrid)
SELECT
     empid
    ,mgrid
    ,firstname
    ,lastname
    ,distance
FROM EmpsCTE;

--view
IF OBJECT_ID('Sales.RankedProducts', 'V') IS NOT NULL
DROP VIEW Sales.RankedProducts;
GO

CREATE VIEW Sales.RankedProducts
AS
SELECT
    ROW_NUMBER() OVER(PARTITION BY categoryid
                        ORDER BY unitprice, productid) AS rownum
    ,categoryid
    ,productid
    ,productname
    ,unitprice
FROM Production.Products;
GO

SELECT
     categoryid
    ,productid
    ,productname
    ,unitprice
FROM Sales.RankedProducts
WHERE rownum <= 2;

--table function
IF OBJECT_ID('HR.GetManagers', 'IF') IS NOT NULL
DROP FUNCTION HR.GetManagers;
GO

CREATE FUNCTION HR.GetManagers(@empid AS INT) RETURNS TABLE
AS
RETURN
    WITH EmpsCTE AS
    (SELECT
        empid
        ,mgrid
        ,firstname
        ,lastname
        ,0 AS distance
    FROM HR.Employees
    WHERE empid = @empid

    UNION ALL

    SELECT
        M.empid
        ,M.mgrid
        ,M.firstname
        ,M.lastname
        ,S.distance + 1 AS distance
    FROM EmpsCTE AS S
        JOIN HR.Employees AS M
            ON M.empid = S.mgrid)
    SELECT
        empid
        ,mgrid
        ,firstname
        ,lastname
        ,distance
    FROM EmpsCTE;
GO

SELECT * FROM HR.GetManagers(9) AS M;

--cross apply
SELECT
     S.supplierid
    ,S.companyname AS supplier
    ,A.*
FROM Production.Suppliers AS S
    CROSS APPLY (SELECT
                     productid
                    ,productname
                    ,unitprice
                 FROM Production.Products AS P
                 WHERE P.supplierid = S.supplierid
                 ORDER BY unitprice, productid
                 OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY) AS A
WHERE S.country = N'Japan';

--outer apply
SELECT
     S.supplierid
    ,S.companyname AS supplier
    ,A.*
FROM Production.Suppliers AS S
    OUTER APPLY (SELECT
                     productid
                    ,productname
                    ,unitprice
                 FROM Production.Products AS P
                 WHERE P.supplierid = S.supplierid
                 ORDER BY unitprice, productid
                 OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY) AS A
WHERE S.country = N'Japan';
