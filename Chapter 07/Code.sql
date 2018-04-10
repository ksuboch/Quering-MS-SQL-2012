USE TSQL2012;

--XML with namespaces
WITH XMLNAMESPACES('TK461-CustomersOrders' AS co)
SELECT
     [co:Customer].custid      AS [co:custid]
    ,[co:Customer].companyname AS [co:companyname]
    ,[co:Order].orderid        AS [co:orderid]
    ,[co:Order].orderdate      AS [co:orderdate]
FROM Sales.Customers AS [co:Customer]
    INNER JOIN Sales.Orders AS [co:Order]
        ON [co:Customer].custid = [co:Order].custid
WHERE [co:Customer].custid <= 2
    AND [co:Order].orderid % 2 = 0
ORDER BY [co:Customer].custid, [co:Order].orderid
FOR XML AUTO, ROOT('CustomersOrders');

--XSD schema
SELECT
     [Customer].custid      AS [custid]
    ,[Customer].companyname AS [companyname]
    ,[Order].orderid        AS [orderid]
    ,[Order].orderdate      AS [orderdate]
FROM Sales.Customers AS [Customer]
    INNER JOIN Sales.Orders AS [Order]
        ON [Customer].custid = [Order].custid
WHERE 1 = 2
FOR XML AUTO, ELEMENTS,
    XMLSCHEMA('TK461-CustomersOrders');

--XPath
SELECT
     Customer.custid      AS [@custid]
    ,Customer.companyname AS [companyname]
FROM Sales.Customers AS Customer
WHERE Customer.custid <= 2
ORDER BY Customer.custid
FOR XML PATH ('Customer'), ROOT('Customer');

--openxml
DECLARE @DocHandle AS INT;
DECLARE @XmlDocument AS NVARCHAR(1000);
SET @XmlDocument = N'
<CustomersOrders>
  <Customer custid="1">
    <companyname>Customer NRZBB</companyname>
    <Order orderid="10692">
      <orderdate>2007-10-03T00:00:00</orderdate>
    </Order>
    <Order orderid="10702">
      <orderdate>2007-10-13T00:00:00</orderdate>
    </Order>
    <Order orderid="10952">
      <orderdate>2008-03-16T00:00:00</orderdate>
    </Order>
  </Customer>
  <Customer custid="2">
    <companyname>Customer MLTDN</companyname>
    <Order orderid="10308">
      <orderdate>2006-09-18T00:00:00</orderdate>
    </Order>
    <Order orderid="10926">
      <orderdate>2008-03-04T00:00:00</orderdate>
    </Order>
  </Customer>
</CustomersOrders>';

--create DOM
EXEC sys.sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument;

--attributes
SELECT *
FROM OPENXML(@DocHandle, '/CustomersOrders/Customer', 1)
    WITH (custid INT, companyname NVARCHAR(40));

--elements
SELECT *
FROM OPENXML(@DocHandle, '/CustomersOrders/Customer', 2)
    WITH (custid INT, companyname NVARCHAR(40));

--attributes and elements
SELECT *
FROM OPENXML(@DocHandle, '/CustomersOrders/Customer', 11)
    WITH (custid INT, companyname NVARCHAR(40));

--remove DOM
EXEC sys.sp_xml_removedocument @DocHandle;
GO

DECLARE @x AS XML;
SET @x = N'
<root>
    <a>1<c>3</c><d>4</d></a>
    <b>2</b>
</root>';
SElECT
     @x.query('*') AS CompleteSequence
    ,@x.query('data(*)') AS CompleteData
    ,@x.query('data(root/a/c)') AS Element_c_Data;
