--Задание 1
CREATE TABLE Данные (id int, val int)

--Задание 2
CREATE TABLE Данные_лог (Дата datetime, id int, val int, Action int)
GO

--Задание 3
CREATE TRIGGER Лог_insert 
   ON  Данные
   FOR INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for trigger here
    INSERT INTO Данные_лог (Дата, id, val, Action)
	SELECT GETDATE(), id, val, 1
	FROM INSERTED

END
GO

--Задание 4
--Добавил три строки - в логах отразились дата и время изменений, добавленные значения и Action = 1

--Задание 5
CREATE TRIGGER Лог_delete
   ON  Данные
   FOR DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for trigger here
    INSERT INTO Данные_лог (Дата, id, val, Action)
	SELECT GETDATE(), id, val, -1
	FROM DELETED

END
GO

--ЗАдание 6
--Удалил одну строку - в логе всё отобразилось с ACTION = -1

--Задание 7
CREATE TRIGGER Лог_update
   ON  Данные
   FOR UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for trigger here
    INSERT INTO Данные_лог (Дата, id, val, Action)
	SELECT GETDATE(), id, val, -1
	FROM DELETED

	UNION

	SELECT GETDATE(), id, val, 1
	FROM INSERTED

END
GO

--DROP TRIGGER Лог_update

--Задание 8 
--Работает корректно

--Задание 9
DECLARE @targ AS datetime = '20260329'

SELECT id, val
FROM 
(
	SELECT id, val, 1 AS Action
	FROM Данные

	UNION ALL

	SELECT id, val, -Action AS Action
	FROM Данные_лог
	WHERE Дата > @targ
) AS Res
GROUP BY id, val
HAVING SUM(Action) > 0

--Задание 10
SELECT id, val
FROM 
(
	SELECT id, val, Action
	FROM Данные_лог
	WHERE Дата <= @targ
) AS Итог
GROUP BY id, val
HAVING SUM(Action) > 0