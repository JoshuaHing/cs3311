
--List all the company names (and countries) that are incorporated outside Australia.
/*
CREATE OR REPLACE VIEW Q1(Name, Country) AS
SELECT c.Name, c.Country
    FROM company c
WHERE NOT c.Country = 'Australia'
*/


--  List all the company codes that have more than five executive members on record (i.e., at least six).
/*
create or replace view Q2(Code) as
select e.Code
    from executive e
group by e.code
having count(e.code) > 5
*/

--List all the company names that are in the sector of "Technology
/*
create or replace view Q3(Name) as
select c.Name
    from company c join category c2 on (c.code = c2.code)
where c2.sector = 'Technology'
*/


--Find the number of Industries in each Sector
/*
create or replace view Q4(Sector, Number) as
select c.Sector, count(c.industry)
    from category c
group by c.sector
*/

--Find all the executives (i.e., their names) that are affiliated with companies in the sector of "Technology". If an executive is affiliated with more than one company, he/she is counted if one of these companies is in the sector of "Technology".
/*
create or replace view Q5(Name) as
select e.person
    from executive e join category c on (e.code = c.code)
where c.sector = 'Technology'
order by e.person
*/

/*
--List all the company names in the sector of "Services" that are located in Australia with the first digit of their zip code being 2.
create or replace view Q6(Name, Country, Zip) as
select c.Name, c.Country, c.Zip
    from company c join category c2 on (c.code = c2.code)
where c2.sector = 'Services' and c.country = 'Australia' and c.zip ~ '^2[0-9]{3}$'
*/


--create or replace view Q7("Date", Code, Volume, PrevPrice, Price, Change, Gain) as ...
/*
SELECT inner_nest.tnr, 100*(inner_nest.forward_price - inner_nest.price)/inner_nest.price as growth
FROM
(
  SELECT t1.*, (SELECT t2.price
                FROM pricelist AS t2
                WHERE t2.tnr = t1.tnr
                  AND t2.date > t1.date
                ORDER BY t2.date ASC LIMIT 1) AS forward_price
  FROM pricelist AS t1
) AS inner_nest
GROUP BY inner_nest.tnr
HAVING growth > 20

    --create or replace view Q7("Date", Code, Volume, PrevPrice, Price, Change, Gain) as ...
*/



--Find the most active trading stock (the one with the maximum trading volume; if more than one, output all of them) on every trading day. Order your output by "Date" and then by Code.

/*
--First, find the max for each
create or replace view max_volume("Date", Volume) as
select "Date", max(Volume)
from asx
group by "Date"

create or replace view Q8("Date", Code, Volume) as
select a."Date", a.Code, a.Volume
from asx a, max_volume m
where a."Date" = m."Date" and a.Volume = m.Volume
group by a."Date", a.Code
*/



/*
--Find the number of companies per Industry. Order your result by Sector and then by Industry.
create or replace view Q9(Sector, Industry, Number) as
select c.Sector, c.Industry, count(*)
from category c
group by c.Industry, c.Sector
*/


/*
--List all the companies (by their Code) that are the only one in their Industry (i.e., no competitors).
create or replace view Q10(Code, Industry) as
select c.Code, c.Industry
from category c
group by c.Industry, c.Code
having count(c.Industry) = 1
*/

/*
--List all sectors ranked by their average ratings in descending order.
--AvgRating is calculated by finding the average AvgCompanyRating for each sector (where AvgCompanyRating is the average rating of a company).

--join rating and category table
create or replace view Q11(Sector, AvgRating) as
select  c.Sector, avg(r.star)
from category c join rating r on (c.code = r.code)
group by c.sector
*/


--Output the person names of the executives that are affiliated with more than one company.
create or replace view Q12(Name) as
select Person
from executive
group by Person
having count(person) > 1



--create or replace view Q13(Code, Name, Address, Zip, Sector) as ...

--create or replace view Q14(Code, BeginPrice, EndPrice, Change, Gain) as ...

--create or replace view Q15(Code, MinPrice, AvgPrice, MaxPrice, MinDayGain, AvgDayGain, MaxDayGain) as ...

--Create a trigger on the Executive table, to check and disallow any insert or update of a Person in the Executive table to be an executive of more than one company. 

--Suppose more stock trading data are incoming into the ASX table. Create a trigger to increase the stock's rating (as Star's) to 5 when the stock has made a maximum daily price gain (when compared with the price on the previous trading day) in percentage within its sector. For example, for a given day and a given sector, if Stock A has the maximum price gain in the sector, its rating should then be updated to 5. If it happens to have more than one stock with the same maximum price gain, update all these stocks' ratings to 5. Otherwise, decrease the stock's rating to 1 when the stock has performed the worst in the sector in terms of daily percentage price gain. If there are more than one record of rating for a given stock that need to be updated, update (not insert) all these records. 

--Stock price and trading volume data are usually incoming data and seldom involve updating existing data. However, updates are allowed in order to correct data errors. All such updates (instead of data insertion) are logged and stored in the ASXLog table. Create a trigger to log any updates on Price and/or Voume in the ASX table and log these updates (only for update, not inserts) into the ASXLog table. Here we assume that Date and Code cannot be corrected and will be the same as their original, old values. Timestamp is the date and time that the correction takes place. Note that it is also possible that a record is corrected more than once, i.e., same Date and Code but different Timestamp.