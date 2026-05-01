--Задание 1
DECLARE @param as int = 8

SELECT Good_ID
FROM Log.Goods_Properties

EXCEPT

SELECT Good_ID
FROM Log.Goods_Properties
WHERE Prop_ID = @param

--Задание 2
SELECT TOP 5 Good_ID, rn as Res
FROM 
(
	SELECT Good_ID, COUNT(*) as rn
	FROM Log.Goods_Properties
	GROUP BY Good_ID
) AS T1
ORDER BY rn desc

--Задание 3
DECLARE @param1 AS INT = 1;
DECLARE @param2 AS INT = 2;

WITH PropSet AS 
(
	SELECT Prop_ID
	FROM Log.Goods_Properties
	WHERE Good_ID = @param1

	UNION

	SELECT Prop_ID
	FROM Log.Goods_Properties
	WHERE Good_ID = @param2
)
SELECT T0.Good_name AS Good_name1, T01.Good_name AS Good_name2, T3.Property, T1.[Value] AS Value1, 
	T2.[Value] AS Value2
FROM PropSet CROSS JOIN 
(
	SELECT Good_name
	FROM Log.Goods
	WHERE Good_ID = @param1
) AS T0 CROSS JOIN 
(
	SELECT Good_name
	FROM Log.Goods
	WHERE Good_ID = @param2
) AS T01
INNER JOIN Log.Properties AS T3 ON
	PropSet.Prop_ID = T3.Prop_ID
LEFT JOIN Log.Goods_Properties AS T1 ON
	PropSet.Prop_ID = T1.Prop_ID AND T1.Good_ID = @param1
LEFT JOIN Log.Goods_Properties AS T2 ON
	PropSet.Prop_ID = T2.Prop_ID AND T2.Good_ID = @param2
ORDER BY T3.Property

--Задание 4
SELECT Good_name
FROM LOG.Goods AS T0
WHERE 
( 
SELECT SUM(CASE WHEN Prop_id IS NOT NULL THEN 1 ELSE 0 END)
FROM LOG.Goods AS T1 LEFT JOIN Log.Goods_Properties AS T2 ON
	T1.Good_id = T2.Good_id
GROUP BY T1.Good_id
HAVING T1.Good_id = T0.Good_id
) < 5

--Задание 5
DECLARE @date AS date = '20260101';
DECLARE @id AS INT = 1

SELECT T1.Good_ID, T1.Prop_ID, T2.Property, T1.[Value]
FROM
(
	SELECT Good_ID, Prop_ID, [Value]
	FROM Log.Goods_Properties_log
	WHERE Date_of_change <= @date AND Good_ID = @id
	GROUP BY Good_ID, Prop_ID, [Value]
	HAVING SUM([Action]) != 0
) AS T1 INNER JOIN Log.Properties AS T2 ON
	T1.Prop_ID = T2.Prop_ID
ORDER BY T2.Prop_ID