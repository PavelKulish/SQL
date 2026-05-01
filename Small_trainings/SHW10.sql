--Задание 1
CREATE TABLE #Hours(EmplID int, MonthID int, TotalHours int, PRIMARY KEY(EmplID, MonthID)) 
CREATE TABLE #MonthSalaries(EmplID int, [Month] date, EndSalary float, PRIMARY KEY(EmplID, [Month]))

INSERT INTO #Hours
SELECT T1.EmplID, DATEPART(MONTH, T1.TBDateTime) as MonthID, 
		SUM(CAST(DATEDIFF(HOUR, T2.TBDateTime, T1.TBDateTime) AS FLOAT)) AS TotalHours
FROM MDZ10.TimeBoard AS T1 INNER JOIN MDZ10.TimeBoard AS T2 ON
	T1.PrevRecordID = T2.RecordID
WHERE T1.StateID = -1 AND T2.StateID = 1 AND YEAR(T1.TBDateTime) = 2022
GROUP BY T1.EmplID, DATEPART(MONTH, T1.TBDateTime)
ORDER BY EmplID, MonthID

INSERT INTO #MonthSalaries
SELECT T1.EmplID, [Month], 
	CASE WHEN TotalHours < Norm THEN TotalHours * CAST(Salary as float) / Norm
		 WHEN TotalHours = Norm THEN Salary 
		 WHEN TotalHours > Norm THEN CAST(Salary as float) + (TotalHours - Norm) * (CAST(Salary as float) / Norm) * 2 
	END AS MonthSalary
FROM #Hours AS T1 INNER JOIN MDZ10.Months AS T2 ON
		T1.MonthID = T2.MonthID
	INNER JOIN MDZ10.Employers AS T3 ON
		T1.EmplID = T3.EmplID

SELECT EmplID, [Month], EndSalary, AVG(EndSalary) OVER (
												PARTITION BY EmplID ORDER BY [Month]
												ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
													   ) AS AvgSalary
FROM #MonthSalaries

-- берем алгоритм построения полного графа с путями из БДЗ_3 и адаптируем
CREATE TABLE #Domens_p(p_ID int, p_type int, ch_ID int, ch_type int, path varchar(1000))

INSERT #Domens_p
SELECT p_ID, p_type, ch_ID, ch_type,
	CAST(CONCAT('|', p_type, ':', p_ID, '|', ch_type, ':', ch_ID, '|') AS varchar(1000)) AS path
FROM MDZ10.Domens
WHERE p_type IN (1, 2, 3) AND ch_type IN (1, 2, 3)

DECLARE @count_ AS INT = 1

WHILE @count_ > 0
BEGIN
	SET @count_ =
	(
		SELECT COUNT(*)
		FROM
		(
			SELECT T1.p_ID, T1.p_type, T2.ch_ID, T2.ch_type,
				CAST(CONCAT(T1.path, T2.ch_type, ':', T2.ch_ID, '|') AS varchar(1000)) AS path
			FROM #Domens_p AS T1 INNER JOIN MDZ10.Domens AS T2 ON
				T1.ch_ID = T2.p_ID AND
				T1.ch_type = T2.p_type
			WHERE T2.p_type IN (1, 2, 3) AND T2.ch_type IN (1, 2, 3)
				AND T1.path NOT LIKE CONCAT('%|', T2.ch_type, ':', T2.ch_ID, '|%')
		) AS NEW LEFT JOIN #Domens_p ON
			#Domens_p.path = NEW.path
		WHERE #Domens_p.p_ID IS NULL
	)

	INSERT #Domens_p
	SELECT NEW.p_ID, NEW.p_type, NEW.ch_ID, NEW.ch_type, NEW.path
	FROM
	(
		SELECT T1.p_ID, T1.p_type, T2.ch_ID, T2.ch_type,
			CAST(CONCAT(T1.path, T2.ch_type, ':', T2.ch_ID, '|') AS varchar(1000)) AS path
		FROM #Domens_p AS T1 INNER JOIN MDZ10.Domens AS T2 ON
			T1.ch_ID = T2.p_ID AND
			T1.ch_type = T2.p_type
		WHERE T2.p_type IN (1, 2, 3) AND T2.ch_type IN (1, 2, 3)
			AND T1.path NOT LIKE CONCAT('%|', T2.ch_type, ':', T2.ch_ID, '|%')
	) AS NEW LEFT JOIN #Domens_p ON
		#Domens_p.path = NEW.path
	WHERE #Domens_p.p_ID IS NULL
END

--Задание 2
WITH DE AS
(
	SELECT DISTINCT p_ID AS DivisionID, ch_ID AS EmplID
	FROM #Domens_p
	WHERE p_type = 3 AND ch_type = 1
),
DS AS
(
	SELECT T2.[Month], T1.DivisionID,
		SUM(T2.EndSalary) AS DivSalary
	FROM DE AS T1 INNER JOIN #MonthSalaries AS T2 ON
		T1.EmplID = T2.EmplID
	GROUP BY T2.[Month], T1.DivisionID
)
SELECT [Month], DivisionID AS Division, DivSalary AS Salary
FROM DS AS T1
WHERE DivSalary IN
(
	SELECT MAX(DivSalary)
	FROM DS AS T2
	WHERE T1.[Month] = T2.[Month]
)
ORDER BY [Month], DivisionID

--Задание 3
DECLARE @par AS INT = 1;

WITH DE AS
(
	SELECT DISTINCT ch_ID AS EmplID
	FROM #Domens_p
	WHERE p_type = 3 AND ch_type = 1 AND p_ID = @par
),
DivHours AS
(
	SELECT T1.MonthID, SUM(T1.TotalHours) AS SumWorked
	FROM #Hours AS T1 INNER JOIN DE AS T2 ON
		T1.EmplID = T2.EmplID
	GROUP BY T1.MonthID
),
EmplCount AS
(
	SELECT COUNT(*) AS EmplCnt
	FROM DE
)
SELECT @par AS DivisionID, T1.[Month],
	T3.EmplCnt * T1.Norm AS SumNorm,
	ISNULL(T2.SumWorked, 0) AS SumWorked
FROM MDZ10.Months AS T1 LEFT JOIN DivHours AS T2 ON
		T1.MonthID = T2.MonthID
	CROSS JOIN EmplCount AS T3
WHERE YEAR(T1.[Month]) = 2022
ORDER BY T1.[Month]

--Задание 4
WITH DA AS (
	SELECT EmplID, DATEPART(Month, TBDateTime) AS M, DATEPART(DAY, TBDateTime) as D,
		CASE WHEN COUNT(*) >= 1 THEN 1 ELSE 0 END as Res
	FROM MDZ10.TimeBoard
	WHERE StateID = 1
	GROUP BY EmplID, DATEPART(Month, TBDateTime), DATEPART(DAY, TBDateTime)
)
SELECT EmplID, [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12]
FROM (SELECT DISTINCT EmplID, DATEPART(MONTH, TBDateTime) AS Месяц, 
			 (SELECT COUNT(*)
			  FROM DA 
			  GROUP BY EmplId, M 
			  HAVING EmplId = T1.EmplID AND M = DATEPART(MONTH, T1.TBDateTime)) AS Qnt
		FROM MDZ10.TimeBoard AS T1) AS D
PIVOT
(
	SUM(Qnt)
	FOR Месяц IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS P
ORDER BY EmplID
GO

--Задание 5
CREATE FUNCTION EmplQnt(@EmplID int, @date1 as date, @date2 as date)
RETURNS TABLE
AS
RETURN
(
	SELECT COUNT(*) as Attendance, MAX(TotalHours) AS TH
	FROM (
		SELECT EmplID, CAST(TBDateTime as date) as Date,
		CASE WHEN COUNT(*) >= 1 THEN 1 ELSE 0 END as Res
		FROM MDZ10.TimeBoard
		WHERE StateID = 1
		GROUP BY EmplID, CAST(TBDateTime as date)
	) AS D INNER JOIN (
		SELECT T1.EmplID,
			SUM(CAST(DATEDIFF(HOUR, T2.TBDateTime, T1.TBDateTime) AS FLOAT)) AS TotalHours
		FROM MDZ10.TimeBoard AS T1 INNER JOIN MDZ10.TimeBoard AS T2 ON
			T1.PrevRecordID = T2.RecordID
		WHERE T1.StateID = -1 AND T2.StateID = 1 AND T1.TBDateTime <= @date2 AND T2.TBDateTime >= @date1
		GROUP BY T1.EmplID
	) AS P ON D.EmplID = P.EmplID
	WHERE @date1 <= Date AND Date <= @date2 AND D.EmplID = @EmplID
)
GO

SELECT *
FROM dbo.EmplQnt(1, '20220501', '20220601')
GO





DROP TABLE #MonthSalaries
DROP TABLE #Hours