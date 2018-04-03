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
