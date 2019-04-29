DROP TABLE IF EXISTS fato;
DROP TABLE IF EXISTS bridge_keywords;
DROP TABLE IF EXISTS bridge_cast;
DROP TABLE IF EXISTS dim_movie;
DROP TABLE IF EXISTS dim_cast;
DROP TABLE IF EXISTS dim_actor;
DROP TABLE IF EXISTS dim_year;
DROP TABLE IF EXISTS dim_country;
DROP TABLE IF EXISTS dim_genre;
DROP TABLE IF EXISTS dim_director;
DROP TABLE IF EXISTS dim_likes;
DROP TABLE IF EXISTS dim_imdb;
DROP TABLE IF EXISTS dim_keywords;
DROP TABLE IF EXISTS dim_keyword;

CREATE TABLE dim_movie (
  movie_id INTEGER PRIMARY KEY,
  movie_title VARCHAR UNIQUE,
  duration NUMERIC,
  color VARCHAR,
  content_rating VARCHAR
);

CREATE TABLE dim_cast (
  cast_id INTEGER PRIMARY KEY
);

CREATE TABLE dim_actor (
  actor_id INTEGER PRIMARY KEY,
  facebook_likes INTEGER,
  actor_name VARCHAR UNIQUE
);

CREATE TABLE bridge_cast (
  cast_id INTEGER REFERENCES dim_cast(cast_id),
  actor_id INTEGER REFERENCES dim_actor(actor_id)
);

CREATE TABLE dim_year (
  year_id INTEGER PRIMARY KEY,
  year_date INTEGER
);

CREATE TABLE dim_country (
  country_id INTEGER PRIMARY KEY,
  country_name VARCHAR UNIQUE,
  language VARCHAR
);

CREATE TABLE dim_genre (
  genre_id INTEGER PRIMARY KEY,
  genre VARCHAR UNIQUE
);

CREATE TABLE dim_director (
  director_id INTEGER PRIMARY KEY,
  director_name VARCHAR UNIQUE,
  director_facebook_likes INTEGER
);

CREATE TABLE dim_likes (
  likes_id INTEGER PRIMARY KEY,
  movie_facebook_likes INTEGER,
  cast_total_likes INTEGER
);

CREATE TABLE dim_imdb (
  imdb_id INTEGER PRIMARY KEY,
  num_voted_users INTEGER,
  num_user_for_review INTEGER,
  num_critic_for_review INTEGER,
  imdb_score INTEGER
);

CREATE TABLE dim_keywords (
  keywords_id INTEGER PRIMARY KEY
);

CREATE TABLE dim_keyword (
  keyword_id INTEGER PRIMARY KEY,
  keyword VARCHAR UNIQUE
);

CREATE TABLE bridge_keywords (
  keywords_id INTEGER REFERENCES dim_keywords(keywords_id),
  keyword_id INTEGER REFERENCES dim_keyword(keyword_id)
);

CREATE TABLE fato (
  fato_id INTEGER PRIMARY KEY,
  budget NUMERIC,
  gross NUMERIC,
  profit NUMERIC,
  movie_id INTEGER REFERENCES dim_movie(movie_id),
  cast_id INTEGER REFERENCES dim_cast(cast_id),
  year_id INTEGER REFERENCES dim_year(year_id),
  country_id INTEGER REFERENCES dim_country(country_id),
  genre_id INTEGER REFERENCES dim_genre(genre_id),
  likes_id INTEGER REFERENCES dim_likes(likes_id),
  imdb_id INTEGER REFERENCES dim_imdb(imdb_id),
  director_id INTEGER REFERENCES dim_director(director_id),
  keywords_id INTEGER REFERENCES dim_keywords(keywords_id)
);