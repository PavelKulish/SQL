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