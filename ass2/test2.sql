WITH RECURSIVE RecursiveCTE
     AS (SELECT
                E.end_actor as end,
                1 as Level
         FROM   e_movie_actor E
         WHERE  E.start_actor = 1598
         UNION ALL
         SELECT
                prev.end_actor,
                prev.Level + 1
         FROM   RecursiveCTE R
                JOIN ACTING c1
                  ON c1.movie_id = R.movie_id
                     AND R.Level < 2
                JOIN ACTING c2
                  ON c1.actor_id = c2.actor_id)

Select R.end, R.level
FROM   RecursiveCTE R
group by R.end, R.level;


WITH RECURSIVE RecursiveCTE
     AS (SELECT C.actor_id,
                C.movie_id,
                0 as Level
         FROM   acting C
                JOIN ACTOR A
                  ON A.id = C.actor_id
         WHERE  A.name = 'Chris Evans'
         UNION ALL
         SELECT c1.actor_id,
                c2.movie_id,
                R.Level + 1
         FROM   RecursiveCTE R
                JOIN acting c1
                  ON c1.movie_id = R.movie_id
                     AND R.Level < 6
                JOIN acting c2
                  ON c1.actor_id = c2.actor_id)
SELECT actor_id, level
FROM   RecursiveCTE
GROUP  BY actor_id, level

with recursive F_degrees
     as (select
                E.end_actor as end,
                1 as Level
         from   e_movie_actor E
         where  E.start_actor = 1598

        union all
         select
                prev.end_actor,
                prev.Level + 1
         from   (F_degrees F join e_movie_actor E on E.start_actor = F.end and R.level < 2) as prev)



select * from (select distinct A.name, min(R.Level) over (partition by F.end) as level
from   F_degrees R, actor A
where R.end != 1598 and A.id = R.end) as t1
where t1.level >= 2 and t1.level <= 3
order by t1.level, t1.name;



with recursive E_shortest
     as (select
                *
         from   e_movie_actor E
         where  E.start_actor = 1598

        union all
         select
                *
         from   (E_shortest S join e_movie_actor E on E.start_actor = S.end_actor) as prev)

select * from E_shortest;

select A.name, 1 as level from (
select ma1.end_actor
from E_movie_actor as ma1
where ma1.start_actor = 1598) as t1 join actor A on (A.id = t1.end_actor)
where t1.end_actor != 1598
order by A.name;

select A.name, 2 as level from (
select ma2.end_actor
from E_movie_actor as ma1 join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
where ma1.start_actor = 1598

except

select ma1.end_actor
from E_movie_actor as ma1

where ma1.start_actor = 1598) as t2 join actor A on (A.id = t2.end_actor)
where t2.end_actor  != 1598
order by A.name;


select A.name, 3 as level from (
select ma3.end_actor
from E_movie_actor as ma1 join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
                          join E_movie_actor as ma3 on (ma2.end_actor = ma3.start_actor)
where ma1.start_actor = 1598

except

select ma2.end_actor
from E_movie_actor as ma1 join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
where ma1.start_actor = 1598) as t3 join actor A on (A.id = t3.end_actor)
where t3.end_actor  != 1598
order by A.name;


select A.name, 4 as level from (
select ma4.end_actor
from E_movie_actor as ma1 join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
                          join E_movie_actor as ma3 on (ma2.end_actor = ma3.start_actor)
                            join E_movie_actor as ma4 on (ma3.end_actor = ma4.start_actor)
where ma1.start_actor = 1598

except

select ma3.end_actor
from E_movie_actor as ma1 join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
                          join E_movie_actor as ma3 on (ma2.end_actor = ma3.start_actor)
where ma1.start_actor = 1598) as t4 join actor A on (A.id = t4.end_actor)
where t4.end_actor != 1598
order by A.name;



select distinct A.name, 5 as level
from (
      select distinct ma5.end_actor from E_movie_actor as ma1
                            join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
                            join E_movie_actor as ma3 on (ma2.end_actor = ma3.start_actor)
                            join E_movie_actor as ma4 on (ma3.end_actor = ma4.start_actor)
                            join E_movie_actor as ma5 on (ma4.end_actor = ma5.start_actor)
          where ma1.start_actor = 369
            except
        select distinct ma4.end_actor from E_movie_actor as ma1
                            join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
                            join E_movie_actor as ma3 on (ma2.end_actor = ma3.start_actor)
                            join E_movie_actor as ma4 on (ma3.end_actor = ma4.start_actor)
            where ma1.start_actor = 369


        ) as res
 join actor A on (A.id = res.end_actor)
where res.end_actor != 369
order by A.name;


select distinct A.name, 6 as level
from (
         select t1.end_actor from ((select distinct ma5.end_actor as end from E_movie_actor as ma1
                            join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
                            join E_movie_actor as ma3 on (ma2.end_actor = ma3.start_actor)
                            join E_movie_actor as ma4 on (ma3.end_actor = ma4.start_actor)
                            join E_movie_actor ma5 on (ma4.end_actor = ma5.start_actor)
          where ma1.start_actor = 369) as checkpoint
        join F_actor_actor as ma6 on (checkpoint.end= ma6.start_actor)) as t1
            except
        (select distinct ma5.end_actor as end from E_movie_actor as ma1
                            join E_movie_actor as ma2 on (ma1.end_actor = ma2.start_actor)
                            join E_movie_actor as ma3 on (ma2.end_actor = ma3.start_actor)
                            join E_movie_actor as ma4 on (ma3.end_actor = ma4.start_actor)
                            join E_movie_actor as ma5 on (ma4.end_actor = ma5.start_actor)
            where ma1.start_actor = 369)


        ) as res
 join actor A on (A.id = res.end_actor)
where res.end_actor != 369
order by A.name;

create or replace view F_actor_actor (start_actor, end_actor) as
select a1.actor_id as start_actor, a2.actor_id as end_actor
from acting a1 join acting a2 on (a1.movie_id = a2.movie_id and a1.actor_id != a2.actor_id);



-- I don't want to carry over the end_ids from the previous iteration

