create or replace view movie_genre1(id, title, genre) as
select m.id, m.title, g.genre
from movie m join genre g on (m.id = g.movie_id);


create or replace view movie_genre2(id, title, genre) as
select m.id, m.title, g.genre
from movie m join genre g on (m.id = g.movie_id)
where m.id = 398;

create or replace view movie_keyword1(id, title, keyword) as
select distinct m.id, m.title, k.keyword
from movie m join keyword k on (m.id = k.movie_id);

create or replace view movie_keyword2(id, title, keyword) as
select distinct m.id, m.title, k.keyword
from movie m join keyword k on (m.id = k.movie_id)
where m.id = 398;

-- Now, take the join of the two???
select distinct movie_genre1.id as id2, count(*) over (partition by movie_genre1.id) as similar_genre_count
from movie_genre1 join movie_genre2 on (movie_genre1.genre = movie_genre2.genre)
where movie_genre1.id != movie_genre2.id
order by similar_genre_count desc;

select distinct movie_keyword1.id  as id3, count(*) over (partition by movie_keyword1.id) as similar_keyword_count
from movie_keyword1 join movie_keyword2 on (movie_keyword1.keyword = movie_keyword2.keyword)
where movie_keyword1.id != movie_keyword2.id
order by similar_keyword_count desc;

-- Now combine everything together

select id, title, year, coalesce(similar_genre_count, 0) as similar_genre_count, coalesce(similar_keyword_count, 0) as similar_keyword_count, imdb_score, num_voted_users from
    (select distinct * from ((select id, title, year, imdb_score, num_voted_users from movie m full outer join rating r on (m.id = r.movie_id)) as hello
            join (select movie_genre1.id as id2, count(*) over (partition by movie_genre1.id) as similar_genre_count
                    from movie_genre1 join (select m.id, m.title, g.genre
                                            from movie m join genre g on (m.id = g.movie_id)
                                            where m.id = 398) as movie_genre2 on (movie_genre1.genre = movie_genre2.genre)
                    where movie_genre1.id != movie_genre2.id
                    order by similar_genre_count desc) as genre_table on (genre_table.id2 = hello.id)) as hello2
                left join (select movie_keyword1.id  as id3, count(*) over (partition by movie_keyword1.id) as similar_keyword_count
                        from movie_keyword1 join (select distinct m.id, m.title,  k.keyword
                                                    from movie m join keyword k on (m.id = k.movie_id)
                                                    where m.id = 398)
                        as movie_keyword2 on (movie_keyword1.keyword = movie_keyword2.keyword)
                        where movie_keyword1.id != movie_keyword2.id
                        order by similar_keyword_count desc) as keyword_table on (keyword_table.id3 = hello2.id)) as hello3
order by similar_genre_count desc, similar_keyword_count desc, imdb_score desc, num_voted_users desc
limit 10;
-- Join all of the tables together
