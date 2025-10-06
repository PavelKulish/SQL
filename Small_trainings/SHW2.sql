--Задание 1
SELECT COUNT(Name) as Overall_Passengers, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers, CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / CAST(COUNT(Name) as float) as Survivability
FROM Titanic_train

--Задание 2
SELECT pClass as Ticket_class, COUNT(Name) as Overall_Passengers, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers, CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / CAST(COUNT(Name) as float) as Survivability
FROM Titanic_train
GROUP BY pClass

--Задание 3
SELECT 
	Sex, 
	pClass as Ticket_class,
	COUNT(Name) as Overall_Passengers,
	SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers,
	CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / CAST(COUNT(Name) as float) as Survivability
FROM Titanic_train
GROUP BY pClass, Sex

--Задание 4
SELECT 
	Embarked as Departure_port,
	COUNT(Name) as Overall_Passengers,
	SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers,
	CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / CAST(COUNT(Name) as float) as Survivability
FROM Titanic_train
GROUP BY Embarked
HAVING Embarked != 'NULL'

--Задание 5
SELECT top 1 
	Embarked as Departure_port,
	COUNT(Name) as Overall_Passengers
FROM Titanic_train
GROUP BY Embarked
ORDER BY COUNT(Name) desc

--Задание 6
SELECT 
	Sex, 
	pClass as Ticket_class,
	AVG(CASE WHEN Survived = 1 THEN Age END) as Av_surv_age, 
	AVG(CASE WHEN Survived = 0 THEN Age END) as Av_died_age
FROM Titanic_train
GROUP BY pClass, Sex

--Задание 7
-- Можно заметить, что для разных людей (строки 1 - 3, 4 - 7...) стоимость билета одинаковая => стоимость билета указана на группу
SELECT top 10 *
FROM Titanic_train
ORDER BY Fare desc

--Задание 8
SELECT Ticket
FROM Titanic_train
GROUP BY Ticket
HAVING COUNT(DISTINCT Fare) > 1
 
SELECT Ticket
FROM Titanic_train
GROUP BY Ticket
HAVING COUNT(DISTINCT Embarked) > 1

--Задание 9
SELECT Ticket, COUNT(Name) as Number_per_ticket, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survived_per_ticket 
FROM Titanic_train
GROUP BY Ticket

SELECT pClass, COUNT(Name) as Number_per_class, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survived_per_class
FROM Titanic_train
GROUP BY pClass

SELECT Fare, COUNT(Name) as Number_per_fare, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survived_per_fare
FROM Titanic_train
GROUP BY Fare

SELECT Embarked, COUNT(Name) as Number_per_port, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survived_per_port
FROM Titanic_train
GROUP BY Embarked
HAVING Embarked != 'NULL'

--Задание 10
SELECT Ticket
FROM Titanic_train
GROUP BY Ticket
HAVING (COUNT(Name) > 1) and (SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) = COUNT(Name))

--Задание 11
SELECT 
	COUNT(Name) as Overall_Passengers,
	SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers,
	CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / CAST(COUNT(Name) as float) as Survivability
FROM Titanic_train
WHERE Name like '%Mary%'

SELECT 
	COUNT(Name) as Overall_Passengers,
	SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers,
	CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / CAST(COUNT(Name) as float) as Survivability
FROM Titanic_train
WHERE Name like '%Elizabeth%'

--Задание 12
SELECT pClass, COUNT(Name) as Men_per_class, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_men_per_class
FROM Titanic_train
GROUP BY pClass, Sex
HAVING Sex = 'male'
-- Данная выборка полностью опровегает представленную гипотезу. Наибольшее количество мужчин спаслось из 3его класса, потому что в 3м классе было банально больше мужчин, чем в 1м.