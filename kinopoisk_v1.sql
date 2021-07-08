/*
 * 	Курсовой проект
 * "Основы реляционных баз данных. MySQL"
 * "Кинопоиск"
*/

/*
 * 	Создание базы данных
*/

DROP DATABASE IF EXISTS kinopoisk;
CREATE DATABASE kinopoisk;
USE kinopoisk;


/*
 * 	Проектирование базы данных
 * 
 * 	При проектировании БД пользовалась логикой: сущность - признак.
 * 	БД представляет собой очень упрощенную версию БД сайта Кинопоиск.
 * 	БД состоит из 10 таблиц:
 * 	1. Фильмы - главная таблица, содержит в себе основную информацию о фильме. 
 * 	2. Пользователи - содержит в себе список пользователей, которые могут оставлять отзывы к фильмам (в реальном кинопоиске, которые имеют личный профиль).
 * 	3. Рецензии - связь между таблицами Фильмы - Пользотватели, users которые оставили рецензцию к фильму 
 * 	4. Жанры
 * 		4.1 Типы жанров
 * 	5. Награды
 * 		5.1 Типы наград
 * 	6. Возрастные ограничения
 * 		6.1 Группы возрастных ограничей
 * 	7. Знаменитости
 * 	    7.1 Связь знаменитость - фильм
 *  
*/

DROP TABLE IF EXISTS films;
CREATE TABLE films (
	id BIGINT(50) UNSIGNED NOT NULL AUTO_INCREMENT,
	name_film VARCHAR(145) DEFAULT 'NO NAME',
	year_release BIGINT(10) UNSIGNED NOT NULL,
	duration_film BIGINT(10) UNSIGNED NOT NULL,
	description TEXT,
	PRIMARY KEY (id),
	KEY film_name_year_idx (name_film, year_release) -- на всякий случай
);


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	login_user VARCHAR(145),
	password_user_hash VARCHAR(145) DEFAULT NULL, -- пока не знаю про пароли ничего
	birth DATE NOT NULL,
	email VARCHAR(145) DEFAULT NULL,
	KEY id_user_idx (id),
	UNIQUE KEY login (login_user)
) COMMENT = 'Пользователи сайта, имеющие личный кабинет';


DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	id_film_rew BIGINT UNSIGNED NOT NULL,
	id_user_rew BIGINT UNSIGNED NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	txt TEXT,
	PRIMARY KEY (id),
	KEY id_film_idx (id_film_rew),
	KEY id_user_idx (id_user_rew),
	CONSTRAINT fk_review_id_film FOREIGN KEY (id_film_rew) REFERENCES films (id),
	CONSTRAINT fk_review_id_users FOREIGN KEY (id_user_rew) REFERENCES users (id)
);



/*
 * 	Таблицы "Типы жанров" и "Жанры".
*/


DROP TABLE IF EXISTS genre_types;
CREATE TABLE genre_types (
	id INT(100) UNSIGNED NOT NULL,
	name_genre VARCHAR(145) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY name_genre (name_genre)
);


DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	id_film_gen BIGINT UNSIGNED NOT NULL,
	id_genre_types INT(100) UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	KEY genre_id_genre_types_idx (id_genre_types),
	KEY genre_id_film_idx (id_film_gen),
	CONSTRAINT fk_genre_film FOREIGN KEY (id_film_gen) REFERENCES films (id),
	CONSTRAINT fk_genre_types FOREIGN KEY (id_genre_types) REFERENCES genre_types (id)
);

/*
 * 	Таблицы "Типы наград" и "Награды".
*/

DROP TABLE IF EXISTS awards_types;
CREATE TABLE awards_types (
	id INT(100) UNSIGNED NOT NULL,
	name_awards VARCHAR(145) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY name_awards (name_awards)
);

DROP TABLE IF EXISTS awards;
CREATE TABLE awards (
	id INT(100) UNSIGNED NOT NULL,
	id_film_aw BIGINT UNSIGNED NOT NULL,
	id_awards_types INT(100) UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	KEY awards_id_film_idx (id_film_aw),
	KEY awards_id_awards_types_idx (id_awards_types),
	CONSTRAINT fk_awards_id_film FOREIGN KEY (id_film_aw) REFERENCES films (id),
	CONSTRAINT fk_id_awards_types FOREIGN KEY (id_awards_types) REFERENCES awards_types (id)
);

/*
 * 	Таблицы "Группы возрастных ограничений" и "Ограничения".
*/

DROP TABLE IF EXISTS age_limit_types;
CREATE TABLE age_limit_types (
	id INT(100) UNSIGNED NOT NULL,
	age_limit_types VARCHAR(145) NOT NULL,
	PRIMARY KEY (id),
	UNIQUE KEY age_limit_types (age_limit_types)
);


DROP TABLE IF EXISTS age_limit_film;
CREATE TABLE age_limit_film (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	id_film_agelim BIGINT UNSIGNED NOT NULL,
	id_age_limit_types INT(100) UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	KEY age_limit_id_film_idx (id_film_agelim),
	KEY id_age_limit_types_idx (id_age_limit_types),
	CONSTRAINT fk_age_limit_types FOREIGN KEY (id_age_limit_types) REFERENCES age_limit_types (id),
	CONSTRAINT fk_id_film FOREIGN KEY (id_film_agelim) REFERENCES films (id)
);

/*
 * 	Таблицы "Персоны" - таблица с известными людьми, таблица "Человек - фильм"- таблица с людьми, которые учавствовали в создании фильма.
*/

DROP TABLE IF EXISTS persons;
CREATE TABLE persons (
	id_person BIGINT(255) UNSIGNED NOT NULL AUTO_INCREMENT,
	name_person VARCHAR(145),
	birth DATE NOT NULL,
	death DATE DEFAULT NULL,
	PRIMARY KEY (id_person)
);

DROP TABLE IF EXISTS person_in_film;
CREATE TABLE person_in_film (
	id  BIGINT UNSIGNED NOT NULL,
	id_pers BIGINT(255) UNSIGNED NOT NULL,
	id_film_pers BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (id),
	KEY id_pers_idx (id_pers),
	KEY id_film_perss_idx (id_film_pers),
	CONSTRAINT fk_pers FOREIGN KEY (id_pers) REFERENCES persons (id_person),
	CONSTRAINT fk_pers_film FOREIGN KEY (id_film_pers) REFERENCES films (id)
);



/*
 * 	Скрипты наполнения БД данными
*/

INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1000, 'Бесславные ублюдки', 2009, 153, 'Вторая мировая война, в оккупированной немцами Франции группа американских солдат-евреев наводит страх на нацистов');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1020, 'Александр', 2004, 175, 'Спустя 40 лет после гибели Александра пожилой Птолемей, один из ближайших соратников Македонского, ставший после его смерти наместником Египта, решает рассказать и записать историю побед великого полководца.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1001, 'Душа', 2020, 106, 'Уже немолодой школьный учитель музыки Джо Гарднер всю жизнь мечтал выступать на сцене в составе джазового ансамбля. Однажды он успешно проходит прослушивание у легендарной саксофонистки и, возвращаясь домой вне себя от счастья, падает в люк и умирает.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1002, 'Игры разума', 2001, 135, 'Гениальный математик в плену галлюцинаций.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1003, 'Аватар', 2009, 162, 'Парализованный морпех становится мессией жителей Пандоры.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1004, 'Я - Болт', 2016, 107, 'Усэйн Болт – единственный в мире спринтер, выигравший забеги на трех Олимпийских играх подряд. Ему рукоплескали Пекин, Лондон и Рио. За свою спортивную карьеру Болт установил 8 мировых рекордов и стал главным ямайским спринтером всех времен.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1005, 'Гарри Поттер и Филосовский камень', 2001, 152, 'Гарри поступает в школу магии Хогвартс и заводит друзей.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1006, 'Догвилль', 2003, 178, 'Девушка приезжает в город, где ей совсем не рады: эпос о насилии в театральных декорациях');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1007, 'Криминальное чтиво', 1994, 154, 'Несколько связанных историй из жизни бандитов.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1008, 'Загадочная история Бенджамина Баттона', 2008, 166, 'Фильм о мужчине, который родился в возрасте 80 лет, а затем… начал молодеть. Этот человек, как и каждый из нас, не мог остановить время.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1009, 'Социальная сеть', 2010, 120, 'В фильме рассказывается история создания одной из самых популярных в Интернете социальных сетей - Facebook.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1010, 'Фантастические твари и где они обитают', 2016, 132, 'Поиск и изучение необычайных волшебных существ приводят магозоолога Ньюта Саламандера в Нью-Йорк.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1011, 'Ночь в музее', 2006, 108, 'Молодой человек в поисках работы попадает в музей, где приступает к обязанностям ночного сторожа.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1012, 'Джетлаг', 2021, 107, 'Из-за обычной ссоры в аэропорту жизнь Жени и Никиты кардинально меняется. Влюблённые оказываются по разные стороны света. Женя попадает на съёмочную площадку в Берлине, встречает гениального режиссёра и становится соавтором его фильма.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1013, 'Война и мир', 1965, 373, 'История нескольких дворянских семей на фоне событий в Российской империи времен Наполеоновских войн.'); 
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1014, 'Дон Кихот', 1957 ,100 , 'Бессмертная история о романтике, чудаке и мечтателе храбром рыцаре Дон Кихоте Ламанчском, и о его спутнике, верном оруженосце Санчо Пансе.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1015, 'Три идиота', 2009, 170, 'Двое друзей отправляются на поиски пропавшего приятеля. В этом путешествии им предстоит постоянно ввязываться в уже давно забытые споры, расстроить чужую свадьбу и побывать на похоронах.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1016, 'Алиса в Стране чудес', 2010, 108, 'Жизнь 19-летней Алисы Кингсли принимает неожиданный оборот. На викторианской вечеринке, устроенной в её честь, Алисе делает предложение Хэмиш, богатый, но глупый сын лорда и леди Эскот.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1017, 'Титаник', 1997, 194, 'В первом и последнем плавании шикарного «Титаника» встречаются двое. Пассажир нижней палубы Джек выиграл билет в карты, а богатая наследница Роза отправляется в Америку, чтобы выйти замуж по расчёту.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1018, 'Унесенные ветром', 1939, 222,'Могучие ветры Гражданской войны в один миг уносят беззаботную юность южанки Скарлетт О`Хара, когда привычный шум балов сменяется грохотом канонад на подступах к родному дому.');
INSERT INTO films (id, name_film, year_release, duration_film, description) VALUES (1019, 'Во все тяжкое', 2018, 90, 'Профессор колледжа решает жить на полную катушку после того, как ему ставят серьезный диагноз.');


INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1001', 'Adeline', 'abc37db41d3e874fe716d358eb2ed1e59f119f17', '1978-05-16', 'emily26@example.org');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1002', 'Pietro', 'b359aa87c230fb198971bef955689d425103c7b5', '1990-07-16', 'javier04@example.com');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1003', 'Ola', '58c4b9054191227ca07b56d559cb0aeefadf4dc3', '1988-11-20', 'veum.arnulfo@example.org');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1004', 'Amber', '7bd82406e9e067403b2700cdbae87c19cb2b673d', '2018-06-28', 'lucie65@example.org');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1005', 'Milan', '9417497079518d1cb78ee6179aefc0a13d90b8aa', '2012-10-26', 'bertram23@example.net');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1006', 'Hollie', '45ac7de440f0a049b7418a6f7cf63bcdabf42a9e', '1988-03-04', 'ledner.domingo@example.org');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1007', 'Charlene', '1840b517afe0df1508710071060ec72c491ac13d', '2002-01-22', 'eromaguera@example.com');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1008', 'Liam', '7349f6b8dd0cc3fc2eab6e4e9491cd2824726313', '1978-10-20', 'wunsch.nathen@example.org');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1009', 'Keeley', '0a794bffe37eac553c5d74ee1905adc808cdad3d', '1993-05-07', 'alf.brakus@example.com');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1010', 'Idella', 'eb54e69e9876569829c94247045bbbea208a9f0d', '1980-08-22', 'qwehner@example.com');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1011', 'Mariana', '39bc4d6afd3f93388cc4f7a15a24b99a150930ff', '1978-09-03','ccremin@example.org');
INSERT INTO users (id, login_user, password_user_hash, birth, email) VALUES ('1012', 'Reanna', '6c07599e7852059a3040169f05b810d3699c955f', '1981-04-12', 'aniyah.pollich@example.net');


INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (1, 1000, 1001, '2013-07-28 16:13:56', 'Отличный фильм!');
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (2, 1001, 1000, '2020-08-27 04:10:37', 'Рекомендую');
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (3, 1002, 1002, '2001-12-01 17:45:00', 'Лучший фильм по ученых и их мир!'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (4, 1003, 1003, '2010-04-20 13:10:37', 'Крутые спецэффекты!'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (5, 1004, 1004, '2017-02-13 17:31:17', 'Невозможное возможно'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (6, 1005, 1005, '2020-04-20 13:10:37', 'Идеальный фильм для погружения в детство во время сидения дома на карантине');  
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (7, 1005, 1005, '2015-07-20 19:12:00', 'Любимый фильм'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (8, 1006, 1006, '2004-07-20 15:18:36', 'Очень необычный фильм'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (9, 1007, 1007, '1994-03-05 11:10:11', 'На все времена'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (10, 1008, 1008, '2008-11-20 15:18:36', 'Одна из любимых ролей Брэд Питта'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (11, 1009, 1009, '2012-07-20 12:15:04', 'Айзек очень хорошо сыграл, фильм захватывающий');
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (12, 1010, 1010, '2017-01-01 16:14:32', 'Очередной фильм о мире Гарри Поттера, крутой!'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (13, 1011, 1011, '2009-08-02 20:14:58', 'Смешной семейный фильм!');
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (14, 1012, 1012, '2021-07-01 10:14:32', 'Новый русский фильм');
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (15, 1013, 1013, '2000-04-16 04:19:14', 'Классика'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (16, 1014, 1014, '2002-01-07 15:14:32', 'Стоит посмотреть!'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (17, 1015, 1015, '2009-12-01 07:14:32', 'Этот фильм стоит посмотреть всем и каждому, очень легкий и глубокий фильм!');
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (18, 1016, 1003, '2011-03-28 02:10:11', 'Очень интересный фильм с Джони Деппом');
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (19, 1017, 1004, '2000-04-25 19:17:29', 'Легендарный фильм'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (20, 1018, 1005, '2007-09-04 09:14:32', 'Нестареющий очень старый фильм'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (21, 1019, 1006, '2019-10-17 17:00:02', 'Депп в роли писателя - класс'); 
INSERT INTO reviews (id, id_film_rew, id_user_rew, created_at, txt) VALUES (22, 1020, 1003, '2004-11-01 01:05:59', 'Великий фильм'); 



INSERT INTO genre_types (id, name_genre) VALUES (1, 'комедия');
INSERT INTO genre_types (id, name_genre) VALUES (2, 'драма');
INSERT INTO genre_types (id, name_genre) VALUES (3, 'боевик');
INSERT INTO genre_types (id, name_genre) VALUES (4, 'вестерн');
INSERT INTO genre_types (id, name_genre) VALUES (5, 'детектив');
INSERT INTO genre_types (id, name_genre) VALUES (6, 'исторический фильм');
INSERT INTO genre_types (id, name_genre) VALUES (7, 'мелодрама');
INSERT INTO genre_types (id, name_genre) VALUES (8, 'сказка');
INSERT INTO genre_types (id, name_genre) VALUES (9, 'мюзикл');
INSERT INTO genre_types (id, name_genre) VALUES (10, 'трагикомедия');
INSERT INTO genre_types (id, name_genre) VALUES (11, 'ужасы');
INSERT INTO genre_types (id, name_genre) VALUES (12, 'фантастика');
INSERT INTO genre_types (id, name_genre) VALUES (13, 'триллер');
INSERT INTO genre_types (id, name_genre) VALUES (14, 'фэнтези');
INSERT INTO genre_types (id, name_genre) VALUES (15, 'приключения');
INSERT INTO genre_types (id, name_genre) VALUES (16, 'семейный фильм');
INSERT INTO genre_types (id, name_genre) VALUES (17, 'биография');
INSERT INTO genre_types (id, name_genre) VALUES (18, 'криминальное чтиво');
INSERT INTO genre_types (id, name_genre) VALUES (19, 'мультфильм');

INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (1, 1020, 3);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (2, 1019, 2);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (3, 1018, 7);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (4, 1017, 7);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (5, 1016, 14);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (6, 1015, 1);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (7, 1014, 1);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (8, 1013, 2);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (9, 1012, 1);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (10, 1012, 2);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (11, 1011, 14);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (12, 1010, 14);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (13, 1010, 15);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (14, 1009, 2);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (15, 1009, 17);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (16, 1008, 2);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (17, 1008, 14);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (18, 1007, 18);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (19, 1006, 13);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (20, 1005, 14);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (21, 1005, 15);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (22, 1005, 16);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (23, 1004, 17);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (24, 1003, 12);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (25, 1002, 2);
INSERT INTO genre (id, id_film_gen, id_genre_types) VALUES (26, 1001, 19);

INSERT INTO awards_types (id, name_awards) VALUES (1, 'Оскар');
INSERT INTO awards_types (id, name_awards) VALUES (2, 'Премия канала MTV');
INSERT INTO awards_types (id, name_awards) VALUES (3, 'Золотой глобус');
INSERT INTO awards_types (id, name_awards) VALUES (4, 'Британская киноакадения BAFTA');
INSERT INTO awards_types (id, name_awards) VALUES (5, 'Сезар');
INSERT INTO awards_types (id, name_awards) VALUES (6, 'ЭММИ');
INSERT INTO awards_types (id, name_awards) VALUES (7, 'Ника');
INSERT INTO awards_types (id, name_awards) VALUES (8, 'Золотая малина');
INSERT INTO awards_types (id, name_awards) VALUES (9, 'Нет наград');

INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (1, 1020, 9);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (2, 1019, 9); 
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (3, 1018, 1); 
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (4, 1017, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (5, 1016, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (6, 1015, 9);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (7, 1014, 9);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (8, 1013, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (9, 1012, 9);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (10, 1011, 2);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (11, 1010, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (12, 1009, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (21, 1009, 2);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (13, 1008, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (14, 1007, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (15, 1006, 9);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (16, 1005, 9);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (17, 1004, 9);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (18, 1003, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (22, 1003, 3);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (19, 1002, 1);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (23, 1002, 3);
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (20, 1001, 1); 
INSERT INTO awards (id, id_film_aw, id_awards_types) VALUES (24, 1001, 3); 

INSERT INTO age_limit_types (id, age_limit_types) VALUES (1, '6+');
INSERT INTO age_limit_types (id, age_limit_types) VALUES (2, '12+');
INSERT INTO age_limit_types (id, age_limit_types) VALUES (3, '16+');
INSERT INTO age_limit_types (id, age_limit_types) VALUES (4, '18+');
INSERT INTO age_limit_types (id, age_limit_types) VALUES (5, '0+');

INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (1, 1020, 3);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (2, 1019, 4); 
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (3, 1018, 2); 
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (4, 1017, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (5, 1016, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (6, 1015, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (7, 1014, 1);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (8, 1013, 3);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (9, 1012, 3);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (10, 1011, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (11, 1010, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (12, 1009, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (13, 1008, 3);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (14, 1007, 4);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (15, 1006, 4);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (16, 1005, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (17, 1004, 5);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (18, 1003, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (19, 1002, 2);
INSERT INTO age_limit_film (id, id_film_agelim, id_age_limit_types) VALUES (20, 1001, 1); 

INSERT INTO persons (id_person, name_person, birth, death) VALUES (20000, 'Джейми Фокс', '1967-12-13', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20001, 'Брэд Питт', '1963-12-18', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20002, 'Сэмюэл Л. Джексон', '1948-12-21', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20003, 'Рассел Кроу', '1964-04-07', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20004, 'Сэм Уортингтон', '1976-08-02', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20005, 'Зои Салдана', '1978-06-19', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20006, 'Усэйн Болт', '1986-08-21', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20007, 'Дэниэл Рэдклифф', '1989-07-23', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20008, 'Руперт Гринт', '1988-08-24', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20009, 'Эмма Уотсон', '1990-04-15', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20010, 'Алан Рикман', '1946-02-21', '2016-01-14');
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20011, 'Николь Кидман', '1967-06-20', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20012, 'Пол Беттани', '1971-05-27', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20013, 'Джесси Айзенберг', '1983-10-05', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20014, 'Эдди Редмэйн', '1982-01-06', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20015, 'Ирина Старшенбаум', '1992-03-30', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20016, 'Сергей Бондарчук ст', '1920-09-25', '1994-10-20');
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20017, 'Джонни Депп', '1963-06-09', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20018, 'Аамир Кхан', '1965-03-14', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20019, 'Леонардо ДиКаприо', '1974-11-11', null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20020, 'Колин Фаррелл', '1976-05-31',  null);
INSERT INTO persons (id_person, name_person, birth, death) VALUES (20021, 'Анджелина Джоли', '1975-06-04', null);




INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (1, 20020, 1020);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (2, 20021, 1020);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (3, 20019, 1017);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (4, 20018, 1015);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (5, 20017, 1019);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (6, 20017, 1010);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (7, 20015, 1012);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (8, 20014, 1010);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (9, 20013, 1009);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (10, 20012, 1006);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (11, 20011, 1006);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (12, 20010, 1005);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (13, 20009, 1005);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (14, 20008, 1005);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (15, 20007, 1005);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (16, 20006, 1004);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (17, 20005, 1003);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (18, 20004, 1003);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (19, 20003, 1002);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (20, 20002, 1007);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (21, 20001, 1008);
INSERT INTO person_in_film (id, id_pers, id_film_pers) VALUES (22, 20000, 1001);


/*
 * 	Скрипты характерных выборок:
 * 		Группировки
 * 		JOIN
 * 		Вложенные таблицы
*/


SELECT id_person, name_person 
FROM persons
WHERE death IS NOT NULL
ORDER BY id_person;

SELECT id_film_pers, COUNT(*) AS AmountP
FROM person_in_film
GROUP BY id_film_pers;


SELECT fl.id, fl.name_film 'Название фильма', rew.txt 'Реценция'
FROM films fl
JOIN reviews rew ON rew.id_film_rew = fl.id;

SELECT * FROM films
WHERE id IN (SELECT id_film_aw FROM awards WHERE id_awards_types = 9);

/*
 * 	Представления
*/

-- 1. Создала view показывающее сколько фильмов имеют Оскар

CREATE or replace VIEW vw_awards_film
AS 
 SELECT fl.id AS id_film
 FROM films AS fl 
 	JOIN awards AS aw ON (fl.id = aw.id_film_aw)
 	JOIN awards_types AS aw_types ON (aw_types.id = aw.id_awards_types)
 WHERE aw_types.name_awards = 'Оскар'
 ORDER BY fl.id;
 
SELECT * FROM vw_awards_film; -- 11 фильмов

-- 2. Создала view показывающее сколько фильмов имют жанр Фэнтези

CREATE or replace VIEW vw_genre_film
AS
	 SELECT fl.id AS id_film
 FROM films AS fl 
 	JOIN genre AS gr ON (fl.id = gr.id_film_gen)
 	JOIN genre_types AS gr_types ON (gr_types.id = gr.id_genre_types)
 WHERE gr_types.name_genre = 'фэнтези'
 ORDER BY fl.id; 


SELECT * FROM vw_genre_film; -- 4 фильма

/*
 * 	Хранимые процедуры и триггеры
*/

DROP TRIGGER IF EXISTS check_birth_user_before_insert;

DELIMITER //

CREATE TRIGGER check_birth_user_before_insert BEFORE INSERT ON users
FOR EACH ROW
begin
    IF NEW.birth >= CURRENT_DATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insert Canceled. Birthday must be in the past!';
    END IF;
END//

DELIMITER ;

