DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL, -- id автора
	txt TEXT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- когда пост создали
	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP, -- когда пост обновили
	INDEX user_idx (user_id), -- индекс для быстрого поиска по пользователю, чтобы найти все его посты
	CONSTRAINT user_posts_fk FOREIGN KEY (user_id) REFERENCES users (id) -- связь с таблицей users
);

DROP TABLE IF EXISTS posts_likes;
CREATE TABLE posts_likes (
	post_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	like_type BOOLEAN DEFAULT TRUE, -- если автор лайка убрал лайк ставим False
	PRIMARY KEY (post_id, user_id),
	INDEX post_idx (post_id),
	INDEX user_idx (user_id),
	CONSTRAINT posts_likes_fk FOREIGN KEY (post_id) REFERENCES posts (id),
	CONSTRAINT users_likes_fk FOREIGN KEY (user_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS black_list;
CREATE TABLE black_list (
	author_id BIGINT UNSIGNED NOT NULL, -- кто добавил в ЧС
	banned_id BIGINT UNSIGNED NOT NULL, -- кого добавил author_id в ЧС
	banned BOOLEAN DEFAULT False, -- если author_id убрал из ЧС пользователя - False
	PRIMARY KEY (author_id, banned_id),
	INDEX author_idx (author_id),
	INDEX banned_idx (banned_id),
	CONSTRAINT users_author_fk FOREIGN KEY (author_id) REFERENCES users (id),
	CONSTRAINT users_banned_fk FOREIGN KEY (banned_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS chats;
CREATE TABLE chats(
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, -- id чата
	name VARCHAR(255) NOT NULL, -- название чата
	author_id BIGINT UNSIGNED NOT NULL, -- id основателя чата
	INDEX author_idx (author_id), -- индекс для быстрого поиска по основателю, чтобы найти все чаты, которые он создал
	CONSTRAINT users_chats_fk FOREIGN KEY (author_id) REFERENCES users (id)
);

DROP TABLE IF EXISTS chat_users;
CREATE TABLE chat_users(
	chat_id BIGINT UNSIGNED NOT NULL, -- id чата
	user_id BIGINT UNSIGNED NOT NULL, -- id участника чата
	added_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- время добавления участника в чат
	PRIMARY KEY (chat_id, user_id),
	INDEX chat_id (chat_id), -- индекс для быстрого поиска по чату, чтобы искать участников чата
	INDEX user_id (user_id), -- индекс для быстрого поиска по участнику чата, чтобы искать все чаты, в которых он состоит
	CONSTRAINT chats_fk FOREIGN KEY (chat_id) REFERENCES chats (id),
	CONSTRAINT users_chats_users_fk FOREIGN KEY (user_id) REFERENCES users (id)
);
