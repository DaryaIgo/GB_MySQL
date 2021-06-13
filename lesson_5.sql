/* Практическое задание #4. */

/* Задание # 1.
 * Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
 * Заполните их текущими датой и временем
*/

UPDATE users SET created_at = CURRENT_TIMESTAMP;
UPDATE users SET updated_at = CURRENT_TIMESTAMP;


/* Задание # 2.
 * Таблица users была неудачно спроектирована. 
 * Записи created_at и updated_at были заданы типом VARCHAR и 
 * в них долгое время помещались значения в формате 20.10.2017 8:10. 
 * Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
*/

ALTER TABLE users MODIFY COLUMN created_at VARCHAR(100) NULL; -- меняем для того, чтобы подходило под условие задачи
ALTER TABLE users MODIFY COLUMN updated_at VARCHAR(100) NULL;

UPDATE users SET created_at = „20.10.2017 8:10“ ;
UPDATE users SET updated_at = „20.10.2017 8:10“ ;

UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i');
UPDATE users SET updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');

ALTER TABLE users MODIFY COLUMN created_at datetime;
ALTER TABLE users MODIFY COLUMN updated_at datetime;

/* Задание # 3.
 * В таблице складских запасов storehouses_products в поле value могут встречаться 
 * самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. 
 * Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 * Однако нулевые запасы должны выводиться в конце, после всех записей
*/

SELECT id, value FROM storehouses_products ORDER BY CASE WHEN value = 0 then 1 else 0 end, value;


/* Задание # 4.
 * Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
 * Месяцы заданы в виде списка английских названий (may, august)
*/

SELECT 
	name, birthday_at,
	CASE 
		WHEN DATE_FORMAT(birthday_at, '%m') = 05 THEN 'may' 
		WHEN DATE_FORMAT(birthday_at, '%m') = 08 THEN 'august' 
	END AS mounth 
FROM 
	users WHERE DATE_FORMAT(birthday_at, '%m') = 05 OR DATE_FORMAT(birthday_at, '%m') = 08;

/* Задание # 5.
 * Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
 * Отсортируйте записи в порядке, заданном в списке IN.
*/

SELECT 
	*
	FROM 
		catalogs WHERE id IN(5, 1, 2)
	ORDER BY CASE
		WHEN id = 5 THEN 0
		WHEN id = 1 THEN 1
		WHEN id = 2 THEN 2
	END;


/* Практическое задание #5. */

/* Задание # 1.
 * Подсчитайте средний возраст пользователей в таблице users.
*/

SELECT 
AVG( DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(birthday_at, '%Y'))
AS Age FROM users;

/* Задание # 2.
 * Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 * Следует учесть, что необходимы дни недели текущего года, а не года рождения.
*/

SELECT 
	DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10))) AS weekday_bd,
	COUNT(DAYNAME(CONCAT(YEAR(NOW()), '-', SUBSTRING(birthday_at, 6, 10)))) AS amount
FROM
	users
GROUP BY
	weekday_bd;