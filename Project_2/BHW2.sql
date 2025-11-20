--Задание 1
SELECT 
    MONTH(Date_of_Order) AS OrderMonth,
    Book_ID,
    CASE WHEN MAX(CASE WHEN Qty_ord IS NOT NULL THEN 1 ELSE 0 END) = 1 THEN SUM(Price_RUR) END AS Ordered,
    CASE WHEN MAX(CASE WHEN Qty_ord IS NOT NULL THEN 1 ELSE 0 END) = 1 AND MAX(Pmnt_RUR) = MAX(Sum_RUR) THEN SUM(Price_RUR) END AS Sold,
    CASE WHEN MAX(CASE WHEN Qty_ord IS NOT NULL THEN 1 ELSE 0 END) = 1 AND MAX(Qty_out) = MAX(Qty_ord) THEN SUM(Price_RUR) END AS Issued
FROM Orders AS T1 INNER JOIN Orders_data AS T2 ON 
    T1.ndoc = T2.ndoc
WHERE YEAR(Date_of_Order) = 2025
GROUP BY MONTH(Date_of_Order), Book_ID
ORDER BY OrderMonth

--Задание 2
SELECT 
	MAX(Section) as Section,
	(SELECT COUNT(DISTINCT DAY(Date_of_Order)) FROM Orders WHERE Date_of_Order BETWEEN DATEADD(month, -1, GETDATE()) AND GETDATE()) AS Sum_days,
	SUM(Qty_ord * Orders_data.Price_RUR) as Sum_Revenue,
	CAST(SUM(Qty_ord * Orders_data.Price_RUR) AS float) / (SELECT COUNT(DISTINCT DAY(Date_of_Order)) FROM Orders WHERE Date_of_Order BETWEEN DATEADD(month, -1, GETDATE()) AND GETDATE()) AS Average_rev
FROM Orders INNER JOIN Orders_data ON 
	Orders.ndoc = Orders_data.ndoc
INNER JOIN Books ON
	Orders_data.Book_ID = Books.Book_ID
INNER JOIN Sections ON
	Sections.Section_ID = Books.Section_ID
WHERE Date_of_Order BETWEEN DATEADD(month, -1, GETDATE()) AND GETDATE()
GROUP BY Books.Section_ID

--Задание 3
SELECT MAX(T1.Name) AS Name, MAX(T1.Surname) as Surname, T1.Sum_Revenue AS Sum_Revenue, COUNT(T2.Author_ID) as Rating
FROM (
SELECT Books.Author_ID, MAX(Name) as Name, MAX(Surname) as Surname, SUM(Qty_ord * Orders_data.Price_RUR) as Sum_Revenue
FROM Orders_data INNER JOIN Books ON 
	Books.Book_ID = Orders_data.Book_ID
INNER JOIN Authors ON 
	Authors.Author_ID = Books.Author_ID
GROUP BY Books.Author_ID
) AS T1 INNER JOIN 
(
SELECT Books.Author_ID, MAX(Name) as Name, MAX(Surname) as Surname, SUM(Qty_ord * Orders_data.Price_RUR) as Sum_Revenue
FROM Orders_data INNER JOIN Books ON 
	Books.Book_ID = Orders_data.Book_ID
INNER JOIN Authors ON 
	Authors.Author_ID = Books.Author_ID
GROUP BY Books.Author_ID
) AS T2 ON T1.Sum_Revenue <= T2.Sum_Revenue
GROUP BY T1.Author_ID, T1.Sum_Revenue
ORDER BY Rating

--Задание 4
SELECT MAX(Customer) as Customer, ISNULL(SUM(Pmnt_RUR), 0) as Overall_pmnt
FROM Customers LEFT JOIN Orders ON
	Orders.Cust_ID = Customers.Cust_ID AND Date_of_Order BETWEEN DATEADD(month, -1, GETDATE()) AND GETDATE() 
GROUP BY Customers.Cust_ID