PRAGMA auto_vacuum = 1;

CREATE TEMPORARY TABLE posts_tmp (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  slug VARCHAR(255) NOT NULL,
  content_type SMALLINT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  guid VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  cached_content LONGTEXT NOT NULL,
  user_id SMALLINT UNSIGNED NOT NULL,
  status SMALLINT UNSIGNED NOT NULL,
  pubdate INT UNSIGNED NOT NULL,
  updated INT UNSIGNED NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS slug ON posts_tmp(slug);

CREATE TEMPORARY TABLE comments_tmp (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  post_id INTEGER UNSIGNED NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  url VARCHAR(255) NULL,
  ip INTEGER UNSIGNED NOT NULL,
  content TEXT,
  status SMALLINT UNSIGNED NOT NULL,
  date INT UNSIGNED NOT NULL,
  type SMALLINT UNSIGNED NOT NULL
);
CREATE INDEX IF NOT EXISTS comments_post_id ON comments_tmp(post_id);

CREATE TEMPORARY TABLE log_tmp (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  user_id INTEGER NULL DEFAULT NULL,
  type_id INTEGER NOT NULL,
  severity_id TINYINT NOT NULL,
  message VARCHAR(255) NOT NULL,
  data BLOB NULL,
  timestamp INT UNSIGNED NOT NULL,
  ip INTEGER UNSIGNED NOT NULL
);

INSERT INTO posts_tmp SELECT id, slug, content_type, title, guid, content, cached_content, user_id, status, strftime('%s', pubdate), strftime('%s', updated) FROM {$prefix}posts;
INSERT INTO comments_tmp SELECT id, post_id, name, email, url, ip, content, status, strftime('%s', date), type FROM {$prefix}comments;
INSERT INTO log_tmp SELECT id, user_id, type_id, severity_id, message, data, strftime('%s', timestamp), ip FROM {$prefix}log;

DROP TABLE {$prefix}posts;
DROP TABLE {$prefix}comments;
DROP TABLE {$prefix}log;

CREATE TABLE {$prefix}posts (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  slug VARCHAR(255) NOT NULL,
  content_type SMALLINT UNSIGNED NOT NULL,
  title VARCHAR(255) NOT NULL,
  guid VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  cached_content LONGTEXT NOT NULL,
  user_id SMALLINT UNSIGNED NOT NULL,
  status SMALLINT UNSIGNED NOT NULL,
  pubdate INT UNSIGNED NOT NULL,
  updated INT UNSIGNED NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS slug ON {$prefix}posts(slug);

CREATE TABLE {$prefix}comments (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  post_id INTEGER UNSIGNED NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  url VARCHAR(255) NULL,
  ip INTEGER UNSIGNED NOT NULL,
  content TEXT,
  status SMALLINT UNSIGNED NOT NULL,
  date INT UNSIGNED NOT NULL,
  type SMALLINT UNSIGNED NOT NULL
);
CREATE INDEX IF NOT EXISTS comments_post_id ON {$prefix}comments(post_id);

CREATE TABLE {$prefix}log (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  user_id INTEGER NULL DEFAULT NULL,
  type_id INTEGER NOT NULL,
  severity_id TINYINT NOT NULL,
  message VARCHAR(255) NOT NULL,
  data BLOB NULL,
  timestamp INT UNSIGNED NOT NULL,
  ip INTEGER UNSIGNED NOT NULL
);

INSERT INTO {$prefix}posts SELECT * FROM posts_tmp;
INSERT INTO {$prefix}comments SELECT * FROM comments_tmp;
INSERT INTO {$prefix}log SELECT * FROM log_tmp;