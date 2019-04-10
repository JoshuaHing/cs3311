create or replace view movie_genre(id, title, genre) as
select m.id, m.title, g.genre
from movie m join genre g on (m.id = g.movie_id)
where m.title = 'Happy Feet';

create or replace view movie_genre2(id, title, genre) as
select distinct m.id, m.title, g.genre
from movie m join genre g on (m.id = g.movie_id), movie_genre mg
where m.id != mg.id;
