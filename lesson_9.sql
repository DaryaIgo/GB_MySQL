/* “Транзакции, переменные, представления” */
/* Практическое задание #9. */

/* Задание # 1.
 * В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
*/

START TRANSACTION;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
COMMIT;


/* Задание # 2.
 * Создайте представление, которое выводит название name товарной позиции 
 * из таблицы products и соответствующее название каталога name из таблицы catalogs.
*/


CREATE OR REPLACE VIEW vw_prods(p_id, p_name, c_name) AS 
SELECT p.id AS p_id, p.name, c.name
FROM products AS p
LEFT JOIN catalogs AS c
ON p.catalog_id = c.id;

SELECT * FROM vw_prods;

/* “Хранимые процедуры и функции, триггеры" */

/* Задание # 1.
 *Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
 *в зависимости от текущего времени суток. 
 *С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 *с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 *с 18:00 до 00:00 — "Добрый вечер", 
 *с 00:00 до 6:00 — "Доброй ночи".
*/
DROP FUNCTION IF EXISTS hello;

delimeter //

CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
		DECLARE nowhour int;
		SET nowhour = HOUR(NOW());
		CASE
			WHEN nowhour BETWEEN 6 AND 12 THEN RETURN 'Доброе утро';
			WHEN nowhour BETWEEN 12 AND 18 THEN RETURN 'Добрый день';
			WHEN nowhour BETWEEN 18 AND 23 THEN RETURN 'Добрый вечер';
			WHEN nowhour BETWEEN 0 AND 6 THEN RETURN 'Доброй ночи';
		END CASE;
END//

delimeter ;

SELECT NOW(), hello();

/* Задание # 2.
 * В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 * Допустимо присутствие обоих полей или одно из них. 
 * Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 * При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/


DROP TRIGGER IF EXISTS tr_null_before_update;

delimeter //

CREATE TRIGGER tr_null_before_update BEFORE INSERT ON products
FOR EACH ROW 
BEGIN 
		IF (NEW.name IS NULL AND NEW.description IS NULL) THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NULL IS BOTH FIELDS';
		END IF;
END //

delimeter ;


INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 1000, 1); -- fail

INSERT INTO products (name, description, price, catalog_id)
VALUES ("GeForce RTX 3060", "Видеокарта", 15000, 12); -- success









