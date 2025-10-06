--Задание 2
DECLARE @id as int
SET @id = 2

SELECT *
FROM Polinomes
WHERE P_ID = @id

--Задание 3
SELECT P_ID
FROM Polinomes
GROUP BY P_ID
HAVING COUNT(Pow) = SUM(CASE WHEN Coef != 0 THEN 1 ELSE 0 END)

--Задание 4
DECLARE @m_id as int, @m_coef as float
SET @m_id = 3
SET @m_coef = 4.5

SELECT P_ID, Pow, Coef * @m_coef as New_coef
FROM Polinomes
WHERE P_ID = @m_id

--Задание 5
DECLARE @check_id as int, @check_pow as float
SET @check_id = 3
SET @check_pow = 2

SELECT 
	P_ID,
	CASE WHEN MAX(CASE WHEN Coef != 0 THEN Pow END) = @check_pow THEN 'Да' ELSE 'Нет' END as Res
FROM Polinomes
WHERE P_ID = @check_id
GROUP BY P_ID