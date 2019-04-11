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
select movie_id from (
    select distinct actor_id from ((select movie_id from acting where actor_id = 539) as hello join acting on (acting.movie_id = hello.movie_id)) as depth1
    join
    acting on (acting.actor_id = depth1.actor_id)) as depth2;
/*
intersect
select movie_id from acting where actor_id = 1685;
*/

    --Tom cruise and robert downey jr.
--
/*
if recursive fails, continue with this stuff
select movie_id from (
                         select movie_id
                         from (
                                  select actor_id
                                  from ((select movie_id from acting where actor_id = 539) as hello natural join acting) as depth1
                                      except
                                  select actor_id
                                  from acting
                                  where actor_id = 539
                              ) as depthh1
                                  natural join acting
                         intersect

                         select movie_id
                         from acting
                         where actor_id = 1685
                     ) as result;
*/