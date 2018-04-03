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
