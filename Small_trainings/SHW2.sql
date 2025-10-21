--Задание 1
SELECT 
	COUNT(*) as Overall_Passengers,
	SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers, CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / COUNT(*) as Survivability
FROM Titanic_train

--Задание 2
SELECT 
	pClass as Ticket_class,
	COUNT(*) as Overall_Passengers,
	SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers, CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / COUNT(*) as Survivability
FROM Titanic_train
GROUP BY pClass

--Задание 3
SELECT 
	Sex, 
	pClass as Ticket_class,
	COUNT(*) as Overall_Passengers,
	SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers,
	CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / COUNT(*) as Survivability
FROM Titanic_train
GROUP BY pClass, Sex

--Задание 4
SELECT 
	Embarked as Departure_port,
	COUNT(*) as Overall_Passengers,
	SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_Passengers,
	CAST(SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as float) / COUNT(*) as Survivability
FROM Titanic_train
GROUP BY Embarked
HAVING Embarked != 'NULL'

--Задание 5
SELECT top 1 with ties
	Embarked as Departure_port,
	COUNT(*) as Overall_Passengers
FROM Titanic_train
GROUP BY Embarked
ORDER BY COUNT(*) desc


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
SELECT Ticket, Pclass, Fare, Embarked, COUNT(*) as Number_per_comb, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survived_per_comb 
FROM Titanic_train
GROUP BY Ticket, Pclass, Fare, Embarked

--Задание 10
SELECT Ticket
FROM Titanic_train
GROUP BY Ticket
HAVING (COUNT(*) > 1) and (SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) = COUNT(*))

--Задание 11
SELECT 
	CAST(SUM(CASE WHEN Survived = 1 and Name LIKE '%Mary%' THEN 1 ELSE 0 END) as float) / SUM(CASE WHEN Name LIKE '%Mary%' THEN 1 END) as Survivability_Mary,
	CAST(SUM(CASE WHEN Survived = 1 and Name LIKE '%Elizabeth%' THEN 1 ELSE 0 END) as float) / SUM(CASE WHEN Name LIKE '%Elizabeth%' THEN 1 END) as Survivability_Elizabeth
FROM Titanic_train


--Задание 12
SELECT pClass, COUNT(Name) as Men_per_class, SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as Survive_men_per_class
FROM Titanic_train
GROUP BY pClass, Sex
HAVING Sex = 'male'
-- Данная выборка полностью опровегает представленную гипотезу. Наибольшее количество мужчин спаслось из 3его класса, потому что в 3м классе было банально больше мужчин, чем в 1м.