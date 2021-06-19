/* Практическое задание #6. */


/* Задание # 2.
 * Пусть задан некоторый пользователь. 
 * Из всех друзей этого пользователя найдите человека, 
 * который больше всех общался с нашим пользователем
*/

SELECT 
	(SELECT firstname FROM users WHERE id = m.from_user_id) AS first_name,
    (SELECT lastname FROM users WHERE id = m.from_user_id) AS last_name,
	COUNT(*) AS messages_sent
FROM messages m
WHERE to_user_id = 1001
GROUP BY from_user_id
ORDER BY messages_sent DESC
LIMIT 1;


/* Задание # 3.
 * Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
*/

/* 
 * Пока не разобралась как соединить два запроса в один, 
 * возможно совсем другая логика должна быть, но получилось пока только так
*/

SELECT 
	(SELECT birthday) AS Birthday,
	(SELECT (YEAR(CURRENT_DATE) - YEAR(birthday))) AS Age
FROM profiles
ORDER BY birthday DESC LIMIT 10;


SELECT 
	(SELECT COUNT(user_id)) AS Likes,
FROM posts_likes 
GROUP BY user_id;


/* Задание # 4.
 * Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/

SELECT COUNT(user_id) AS likes_count, gender
  FROM profiles
  GROUP BY gender
  ORDER BY likes_count DESC LIMIT 1;

/* Задание # 5.
 * Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
*/

SELECT 
  CONCAT(firstname, ' ', lastname) AS user_name, 
  (SELECT COUNT(*) FROM posts_likes WHERE posts_likes.user_id = users.id) + 
  (SELECT COUNT(*) FROM media WHERE media.user_id = users.id) + 
  (SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS activity 
FROM users
ORDER BY activity
LIMIT 10;
