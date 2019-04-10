/*
movie, actor, acting
 */

create or replace view E_actor_movie(title, year, name) as
select movie.title, movie.year, actor.name
from movie, actor, acting
where movie.id = acting.movie_id and actor.id = acting.actor_id;


select title from E_actor_movie where name ilike 'Tom Cruise'
intersect
select title from E_actor_movie where name ilike 'Jeremy Renner';



-- tom cruise - 539
-- jeremy renner - 1685

/*
intersect
select movie_id from acting where actor_id = 1685;
*/