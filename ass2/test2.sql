/*select *, count(*) 
over (partition by id)
from movie_genre2;
*/

-- select count(*) from ((select genre from genre where movie_id = 532) intersect (select genre from genre where movie_id=398)) as intersection;

/*
select m.*, count(*)
over (partition by id)
from movie m join genre g on (m.id = g.movie_id);
*/


select m.*, count(intersection.*)
over (partition by m.id)
from movie m join genre g on (m.id = g.movie_id), ((select genre from genre where movie_id = m.id) intersect (select genre from genre where movie_id = 398)) as intersection;
