/* Практическое задание #11. */

/* “Оптимизация запросов” */

/* Задание # 1.
 * Создайте таблицу logs типа Archive. 
 * Пусть при каждом создании записи в таблицах users, 
 * catalogs и products в таблицу logs помещается время и дата создания записи, 
 * название таблицы, идентификатор первичного ключа и содержимое поля name.
*/

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id_str BEGINT(30) NOT NULL,
	name_table VARCHAR(30) NOT NULL,
	created_at DATETIME NOT NULL,
	body VARCHAR(30) NOT NULL
) ENGINE = ARCHIVE;


DROP TRIGGER IF EXISTS watchlog_users_after_insert;
delimeter //
CREATE TRIGGER watchlog_users_after_insert AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (id_str, name_table, created_at, body)
	VALUES (NEW.id, NEW.name, NOW(), 'users');
END //
delimeter ;


DROP TRIGGER IF EXISTS watchlog_catalogs_after_insert;
delimeter //
CREATE TRIGGER watchlog_ctalogs_after_insert AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (id_str, name_table, created_at, body)
	VALUES (NEW.id, NEW.name, NOW(), 'catalogs');
END //
delimeter ;


DROP TRIGGER IF EXISTS watchlog_products_after_insert;
delimeter //
CREATE TRIGGER watchlog_products_after_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (id_str, name_table, created_at, body)
	VALUES (NEW.id, NEW.name, NOW(), 'products');
END //
delimeter ;


/* “NoSQL” */



/* Задание # 1.
 * В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
*/

не поняла задание, в коллекциях же могут быть только уникальные значения
наверно, можно решить задачу используя INCR?

/* Задание # 2.
 * При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
*/

set daryaigoshina@mail.ru darya
get daryaigoshina@mail.ru -- darya

set darya daryaigoshina@mail.ru
get darya -- daryaigoshina@mail.ru


/* Задание # 3.
 * Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
*/

db.catalogs.insertMany([{"name": "Процессоры"}, {"name": "Мат.платы"}, {"name": "Видеокарты"}])


db.shop.insertMany([
{"name": "GeForce RTX", "description": "Характеристики видеокарты", "price": "9000.00", "catalog_id": "Видеокарты", "created_at": new Date(), "updated_at": new Date()},
{"name": "AMD", "description": "Характеристики процессора", "price": "9000.00", "catalog_id": "Процессоры", "created_at": new Date(), "updated_at": new Date()}])



