-- COMP3311 19s1 Assignment 2
--
-- updates.sql
--
-- Written by <<Joshua Hing>> (<<z5117173>>), Apr 2019

--  This script takes a "vanilla" imdb database (a2.db) and
--  make all of the changes necessary to make the databas
--  work correctly with your PHP scripts.
--  
--  Such changes might involve adding new views,
--  PLpgSQL functions, triggers, etc. Other changes might
--  involve dropping or redefining existing
--  views and functions (if any and if applicable).
--  You are not allowed to create new tables for this assignment.
--  
--  Make sure that this script does EVERYTHING necessary to
--  upgrade a vanilla database; if we need to chase you up
--  because you forgot to include some of the changes, and
--  your system will not work correctly because of this, you
--  will lose half of your assignment 2 final mark as penalty.
--

--  This is to ensure that there is no trailing spaces in movie titles,
--  as some tasks need to perform full title search.
UPDATE movie SET title = TRIM (title);

--  Add your code below
--
-- Title, director, year, content rating, imdb score
-- Whatever It Takes -- David Raynr (2000, PG-13, 5.5)



create or replace view director_movie (movie_id, director_id, title, director, year, content_rating, imdb_score) as
select m.id, m.director_id,  m.title, d.name, m.year, m.content_rating, r.imdb_score
from movie m left outer join director d on (m.director_id = d.id), rating r
where r.movie_id = m.id
order by m.year asc, m.title asc;

create or replace view acted_in (actor_name, title, director, year, content_rating, imdb_score) as
select a.name, dm.title, dm.director, dm.year, dm.content_rating, dm.imdb_score
from director_movie dm, acting ac, actor a
where dm.movie_id = ac.movie_id and ac.actor_id = a.id;


-- List movie title, year, content rating , IMDB score and genres
-- movie, rating, genre
create or replace view movie_info (id, title, year, content_rating, imdb_score) as
select m.id, m.title, m.year, m.content_rating, r.imdb_score
from movie m, rating r
where m.id = r.movie_id;

create or replace view C_table(id, title, year, imdb_score, num_voted_users) as
select m.id, m.title, m.year, r.imdb_score, r.num_voted_users
from movie m, rating r
where m.id = r.movie_id;

create or replace view C_table_wgenre(id, title, year, imdb_score, num_voted_users, genre) as
select ct.*, genre
from C_table ct, genre g
where ct.id = g.movie_id
order by ct.id;

create or replace view C_ans(id, title, year, imdb_score, num_voted_users, common_genre_count, common_keyword_count) as
select ct.*, NULL, NULL
from C_table ct;


create or replace view D_movie_genre(id, genre) as
select m.id, g.genre
from movie m join genre g on (m.id = g.movie_id);

create or replace view D_movie_keyword(id, keyword) as
select m.id, k.keyword
from movie m join keyword k on (m.id = k.movie_id);
