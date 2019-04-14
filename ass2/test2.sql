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
         FROM   (RecursiveCTE R
                join e_movie_actor E
                on R.end = E.start_actor and R.Level < 2) as prev)
                /*
                JOIN ACTING c1
                  ON c1.movie_id = R.movie_id
                     AND R.Level < 2
                JOIN ACTING c2
                  ON c1.actor_id = c2.actor_id)
                  */
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
                     AND R.Level < 2
                JOIN acting c2
                  ON c1.actor_id = c2.actor_id)
SELECT actor_id
FROM   RecursiveCTE
GROUP  BY actor_id

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



-- I don't want to carry over the end_ids from the previous iteration

