/* Практическое задание #7. */

/* Задание # 1.
 * Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/

SELECT DISTINCT u.id, u.name
FROM users AS u
   JOIN orders AS o ON u.id = o.user_id;

/* Задание # 2.
 * Выведите список товаров products и разделов catalogs, который соответствует товару.
*/

  SELECT
  p.id,
  p.name,
  p.price,
  c.name AS catalog
FROM products AS p
LEFT JOIN catalogs AS c ON p.catalog_id = c.id;
  
/* Задание # 3.
 * (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 * Поля from, to и label содержат английские названия городов, поле name — русское. 
 * Выведите список рейсов flights с русскими названиями городов.
*/

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  from_c VARCHAR(255) COMMENT 'Город отравления',
  to_c VARCHAR(255) COMMENT 'Город прибытия'
) COMMENT = 'Рейсы';

INSERT INTO flights (from_c, to_c) VALUES
('moscow', 'omsk'),
('novgorod', 'kazan'),
('irkutsk', 'moscow'),
('omsk', 'irkutsk'),
('moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) COMMENT 'Код города',
  name VARCHAR(255) COMMENT 'Название города'
) COMMENT = 'Словарь городов';

INSERT INTO cities (label, name) VALUES
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

SELECT
  f.id,
  cities_from.name AS `from`,
  cities_to.name AS `to`
FROM flights AS f
  JOIN cities AS cities_from ON f.from_c = cities_from.label
  JOIN cities AS cities_to ON f.to_c = cities_to.label;