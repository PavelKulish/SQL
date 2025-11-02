--Задание 1
SELECT Покупатели.Покупатель_ID, ISNULL(COUNT(нДок),0)  Res
FROM Покупатели LEFT JOIN Документы ON
	Покупатели.Покупатель_ID = Документы.Покупатель_ID
GROUP BY Покупатели.Покупатель_ID

--Задание 2
SELECT Наименование
FROM Товары LEFT JOIN Документы_данные ON
	Товары.Товар_ID = Документы_данные.Товар_ID
WHERE нДок IS NULL

--Задание 3
SELECT Наименование
FROM Товары LEFT JOIN Документы_данные ON
		Товары.Товар_ID = Документы_данные.Товар_ID
	LEFT JOIN Документы ON 
		Документы.ндок = Документы_данные.ндок
	LEFT JOIN Покупатели ON
		Покупатели.Покупатель_ID = Документы.Покупатель_ID and Фамилия LIKE 'Иванов'
WHERE Покупатели.Покупатель_ID IS NULL


--Задание 4
SELECT Покупатели.Покупатель_ID, Товары.Товар_ID
FROM Покупатели, Товары

EXCEPT

SELECT Документы.Покупатель_ID, Документы_данные.Товар_ID
FROM Документы INNER JOIN Документы_данные ON 
	Документы.ндок = Документы_данные.ндок
	
--Задание 5
SELECT Покупатели.Покупатель_ID, Товары.Товар_ID
FROM Покупатели, Товары

EXCEPT

SELECT Документы.Покупатель_ID, Документы_данные.Товар_ID
FROM Документы INNER JOIN Документы_данные ON 
	Документы.ндок = Документы_данные.ндок
WHERE Дата > '20251001'

--Задание 6 
SELECT Покупатель_ID, COUNT(DISTINCT(Товар_ID)) as Res
FROM Документы INNER JOIN Документы_данные ON
	Документы.ндок = Документы_данные.ндок
GROUP BY Покупатель_ID
HAVING COUNT(DISTINCT(Товар_ID)) < 5

--Задание 7
SELECT 
    T1.Покупатель_ID as id1, 
    T2.Покупатель_ID as id2
FROM Документы AS T1
INNER JOIN Документы AS T2 ON T1.Покупатель_ID < T2.Покупатель_ID
WHERE NOT EXISTS (
    SELECT DD1.Товар_ID
    FROM Документы_данные AS DD1
    WHERE DD1.ндок = T1.ндок

    EXCEPT

    SELECT DD2.Товар_ID
    FROM Документы_данные AS DD2
    INNER JOIN Документы D2 ON DD2.ндок = D2.ндок
    WHERE D2.Покупатель_ID = T2.Покупатель_ID
)
AND NOT EXISTS (
    SELECT DD2.Товар_ID
    FROM Документы_данные DD2
    INNER JOIN Документы D2 ON DD2.ндок = D2.ндок
    WHERE D2.Покупатель_ID = T2.Покупатель_ID

    EXCEPT

    SELECT DD1.Товар_ID
    FROM Документы_данные DD1
    WHERE DD1.ндок = T1.ндок
)

--Задание 8
SELECT T1.Покупатель_ID, T1.Сумма, COUNT(T2.Покупатель_ID) as Рейтинг
FROM Документы AS T1 INNER JOIN Документы AS T2 ON
    T1.Сумма <= T2.Сумма
GROUP BY T1.Покупатель_ID, T1.Сумма
ORDER BY Рейтинг 

--Задание 9
SELECT Товар_ID
FROM Товары
WHERE Остаток > 0

UNION

SELECT Товары.Товар_ID
FROM Товары INNER JOIN Документы_данные ON
        Товары.Товар_ID = Документы_данные.Товар_ID
    INNER JOIN Документы ON
        Документы_данные.ндок = Документы.ндок
WHERE Дата BETWEEN '20251101' and '20251130'

UNION 

SELECT Товары.Товар_ID
FROM Товары INNER JOIN Документы_данные ON
        Товары.Товар_ID = Документы_данные.Товар_ID
    INNER JOIN Документы ON
        Документы_данные.ндок = Документы.ндок
WHERE (Дата BETWEEN '20251101' and '20251130') and (Остаток > 0)

--Задание 10
SELECT Товар_ID, SUM(Колво * Цена) / (SELECT COUNT(DISTINCT(CASE WHEN Дата is not NULL THEN Дата END)) FROM Документы) AS Res
FROM Документы_данные
GROUP BY Товар_ID