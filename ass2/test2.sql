
-- join two potential paths together and select the ones with our starting and ending actor
SELECT ma1.movie movie1
,ma1.end_actor actor1
,ma2.movie movie2
,ma2.end_actor actor2
,ma3.movie movie3
,ma3.end_actor actor3
,ma4.movie movie4
,ma4.end_actor movie4
,ma5.movie movie5
FROM E_movie_actor ma1 JOIN E_movie_actor ma2 ON (ma1.end_actor = ma2.start_actor)
                        join E_movie_actor ma3 on (ma2.end_actor = ma3.start_actor)
                        join E_movie_actor ma4 on (ma3.end_actor = ma4.start_actor)
                        join E_movie_actor ma5 on (ma4.end_actor = ma5.start_actor)
WHERE ma1.start_actor = 1598
AND ma5.end_actor = 2624;


-- chris evans 1598, bill clinton 2624

SELECT ma1.movie movie1
,ma1.end_actor actor1
,ma2.movie movie2
,ma2.end_actor actor2
,ma3.movie movie3
,ma3.end_actor actor3
,ma4.movie movie4
,ma4.end_actor movie4
,ma5.movie movie5
,ma5.end_actor actor5
,ma6.movie movie6
FROM E_movie_actor ma1 JOIN E_movie_actor ma2 ON (ma1.end_actor = ma2.start_actor)
                        join E_movie_actor ma3 on (ma2.end_actor = ma3.start_actor)
                        join E_movie_actor ma4 on (ma3.end_actor = ma4.start_actor)
                        join E_movie_actor ma5 on (ma4.end_actor = ma5.start_actor)
                        join E_movie_actor ma6 on (ma5.end_actor = ma6.start_actor)
WHERE ma1.start_actor = 369
AND ma6.end_actor = 3975;

-- emma stone 369, chelsea field = 3975


