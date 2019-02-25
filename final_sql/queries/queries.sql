-- W 1 Показать топ 10 клиентов, которые потратили больше всего денег в антикафе [expense]

-- W 2 Показать число посещений и выручку за ноябрь 2018 по каждому антикафе [expense + visit]

-- W 3 Показать, какую выручку приносят клиенты с каждым типом карты (card_level) [expense + client]



-- 4 Показать долю посещений клиентов с гостевой картой от общего числа посещений по каждому антикафе [client + visit]

-- 5 Показать, клиенты с каким уровнем карты чаще всего бронируют комнаты [booking + client]

-- 6 Показать среднее количество посещений за последние 3 месяца в выходной день и в рабочий [visit]


-- 8 Топ 10 количества новых клиентов за смену [client + shift]

-- 9 Среднее количество гостей за утреннюю, дневную, вечернюю смену [visit + shift]

-- 10 Выбрать всех клиентов, которых зарегали первые 3 человека и посмотреть, сколько количество их посещений за время выборки

SET search_path TO final_sql;

-- 7 [client]
-- Кто из сотрудников зарегистрировал больше всего клиентов, топ 10.
SELECT creation_place_id AS cafe_id, creator_employee_id AS employee_id, count(creator_employee_id) AS n_registered_users
FROM client
GROUP BY creation_place_id, creator_employee_id
ORDER BY count(creator_employee_id) DESC
LIMIT 10;

-- 10 [client + visit]
-- Выбрать всех клиентов, которых зарегали первые 3 сотрудника (из предыдущего запроса). 
-- Посмотреть количество посещений по каждому сотруднику отдельно у топ 40 клиентов.
WITH first_three AS
(
	SELECT creator_employee_id, count(creator_employee_id) AS n_registered_users
	FROM client
	GROUP BY creator_employee_id
	ORDER BY count(creator_employee_id) DESC
	LIMIT 3
)

, client_list AS
(
	SELECT first_three.creator_employee_id, client_id 
	FROM client INNER JOIN first_three
	ON client.creator_employee_id = first_three.creator_employee_id
)

SELECT creator_employee_id, visit.client_id, count(visit_id) AS n_visits
FROM visit INNER JOIN client_list
ON visit.client_id = client_list.client_id
GROUP BY creator_employee_id, visit.client_id
ORDER BY count(visit_id) DESC
LIMIT 40;

