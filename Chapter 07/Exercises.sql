USE TSQL2012;

--XML
SELECT
     Customer.custid
    ,Customer.companyname
    ,[Order].orderid
    ,[Order].orderdate
FROM Sales.Customers AS Customer
    INNER JOIN Sales.Orders AS [Order]
        ON Customer.custid = [Order].custid
ORDER BY Customer.custid, [Order].orderid
FOR XML RAW;

--XML AUTO
SELECT
     Customer.custid
    ,Customer.companyname
    ,[Order].orderid
    ,[Order].orderdate
FROM Sales.Customers AS Customer
    INNER JOIN Sales.Orders AS [Order]
        ON Customer.custid = [Order].custid
ORDER BY Customer.custid, [Order].orderid
FOR XML AUTO;

--XML with namespaces
WITH XMLNAMESPACES('TK461-CustomersOrders' AS co)
SELECT
     [co:Customer].custid      AS [co:custid]
    ,[co:Customer].companyname AS [co:companyname]
    ,[co:Order].orderid           AS [co:orderid]
    ,[co:Order].orderdate         AS [co:orderdate]
FROM Sales.Customers AS [co:Customer]
    INNER JOIN Sales.Orders AS [co:Order]
        ON [co:Customer].custid = [co:Order].custid
ORDER BY [co:Customer].custid, [co:Order].orderid
FOR XML AUTO, ELEMENTS, ROOT('CustomersOrders');

--XML fragment
SELECT
     Customer.custid      AS [@custid]
    ,Customer.companyname AS [@companyname]
    ,(SELECT
         [Order].orderid   AS [@orderid]
        ,[Order].orderdate AS [@orderdate]
      FROM Sales.Orders AS [Order]
      WHERE Customer.custid = [Order].custid
        AND [Order].orderid % 2 = 0
      ORDER BY [Order].orderid
      FOR XML PATH('Order'), TYPE)
FROM Sales.Customers AS Customer
WHERE Customer.custid <= 2
ORDER BY Customer.custid
FOR XML PATH('Customer');
