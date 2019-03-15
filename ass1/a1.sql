

create or replace view Q1(Name, Country) AS
select Name, Country
from company
where not Country = 'Australia';


create or replace view Q2(Code) as
select Code
from executive e
group by Code
having count(Code) > 5;

create or replace view Q3(Name) as
select c.Name
from company c join category c2 on (c.code = c2.code)
where c2.sector = 'Technology';


create or replace view Q4(Sector) as
select Sector, count(distinct Industry)
from category
group by Sector;


create or replace view Q5(Name) as
select e.person
from executive e join category c on (e.code = c.code)
where c.sector = 'Technology';

create or replace view Q6(Name, Country, Zip) as
select c.Name, c.Country, c.Zip
from company c join category c2 on (c.code = c2.code)
where c2.sector = 'Services' and c.country = 'Australia' and c.zip ~ '^2[0-9]{3}$';



create or replace view min_date(Code, "Date") as
select Code, min("Date")
from asx
group by Code;

create or replace view prev_price(Code, "Date", Prev) as
select a.Code, a."Date", LAG(price, 1) over (partition by a.Code order by a."Date")
from asx a;

create or replace view daily_change(Code, "Date", Change) as
select a.Code, a."Date", price - LAG(price, 1) over (partition by a.Code order by a."Date")
from asx a;

create or replace view Q7("Date", Code, Volume, PrevPrice, Price, Change, Gain) as
select a."Date", a.Code, a.Volume, pp.Prev, a.Price, dc.Change, (dc.Change/pp.prev) * 100
from asx a, prev_price pp, daily_change dc, min_date md
where a.code = pp.code
  and a.code = dc.code
  and a.code = md.code
  and a."Date" != md."Date"
  and a."Date" = pp."Date"
  and a."Date" = dc."Date";





create or replace view max_volume("Date", Volume) as
select "Date", max(Volume)
from asx
group by asx."Date";

create or replace view Q8("Date", Code, Volume) as
select a."Date", a.Code, a.Volume
from asx a, max_volume m
where a."Date" = m."Date" and a.Volume = m.Volume
group by a."Date", a.Code;




create or replace view Q9(Sector, Industry, Number) as
select Sector, Industry, count(*)
from category
group by Industry, Sector
order by Sector, Industry;


create or replace view count_industry(Industry, Count) as
select Industry, Count(*)
from category
group by Industry;

create or replace view Q10(Code, Industry) as
select c.Code, c.Industry
from category c, count_industry ci
where c.Industry = ci.industry and ci.count = 1;

create or replace view Q11(Sector, AvgRating) as
select  c.Sector, avg(r.star)
from category c join rating r on (c.code = r.code)
group by c.sector, r.star
order by r.star desc;



create or replace view Q12(Name) as
select Person
from executive
group by Person
having count(person) > 1;



create or replace view not_in_aust(Code, Country) as
select c.code, c.country
from company c
where not c.country = 'Australia';

create or replace view sect(Sector) as
select c2.sector
from company c1 join category c2 on c1.code = c2.code,  not_in_aust nia
where c1.code = nia.code and c1.country = nia.Country
group by c2.sector;


create or replace view Q13(Code, Name, Address, Zip, Sector) as
select c1.Code, c1.Name, c1.Address, c1.Zip, c2.sector
from company c1 join category c2 on c1.code = c2.code, sect s
where c2.sector not in (select * from sect)
group by c2.sector, c1.code, name, address, zip;


create or replace view start_date(Date, Code) as
select min("Date"), Code
from asx
group by Code;

create or replace view end_date(Date, Code) as
select max("Date"), Code
from asx
group by Code;

create or replace view start_price(StartPrice, Code) as
select a.price, a.code
from asx a, start_date sd
where a.Code = sd.Code and a."Date" = sd.Date;


create or replace view end_price(EndPrice, Code) as
select a.price, a.code
from asx a, end_date ed
where a.Code = ed.Code and a."Date" = ed.Date;


create or replace view Q14(Code, BeginPrice, EndPrice, Change, Gain) as
select distinct a.Code, sp.startprice, ep.EndPrice,  (ep.EndPrice - sp.startprice), ((ep.EndPrice - sp.startprice)/(sp.startprice)) * 100 as Gain
from asx a, start_price sp, end_price ep
where a.code = sp.code and a.code = ep.Code
order by Gain desc,  Code asc;



create or replace view Q15(Code, MinPrice, AvgPrice, MaxPrice, MinDayGain, AvgDayGain, MaxDayGain) as
select a.Code, min(a.price), avg(a.price), max(a.price), min(q7.Gain), sum(q7.Gain)/count(q7.code), max(q7.Gain)
from asx a, q7
where a.code = q7.code
group by a.code;



create or replace function
    Q16_procedure() returns trigger
as $$
declare
    num_companies int;
begin
    select count(*) into num_companies from executive where person = new.person;
    if num_companies > 1
        then raise exception 'Executive must work for one company only.';
    end if ;
    return new;
end;
$$ language plpgsql;


create trigger Q16
    after insert or update on executive
for each row execute procedure Q16_procedure();


create or replace view daily_gain_by_sector(Sector, "Date", Code, gain) as
select c.Sector, q7."Date", c.Code, q7.gain
from Q7 as q7 join category c on (q7.code = c.code);

create or replace view daily_maxgain_by_sector(Sector, "Date", max_gain) as
select sector, "Date", max(gain)
from daily_gain_by_sector
group by sector, "Date"
order by sector, "Date";


create or replace view daily_mingain_by_sector(Sector, "Date", min_gain) as
select sector, "Date", min(gain)
from daily_gain_by_sector
group by sector, "Date"
order by sector, "Date";

create or replace function
    Q17_procedure() returns trigger
as $$
declare
    daily_max float;
    daily_min float;
    curr_gain float;
    company_sector varchar(40);
begin
    select sector into company_sector from category where new.code = code;
    select max_gain into daily_max from daily_maxgain_by_sector dgs1 where company_sector = dgs1.sector and "Date" = dgs1."Date";
    select min_gain into daily_min from daily_mingain_by_sector dgs2 where company_sector = dgs2.sector and "Date" = dgs2."Date";

    -- get the gain of the company in question
    select gain into curr_gain from daily_gain_by_sector where new.code = code and new."Date" = "Date";

    if curr_gain >= daily_max
    then
        update rating set star = 5
        where code = new.code;
        raise notice 'Changing % to 5 star rating...', new.code;
    end if;

    if curr_gain <= daily_min
    then
        update rating set star = 1
        where code = new.code;
        raise notice 'Changing % to 1 star rating...', new.code;
    end if;

    return new;

    -- Now, calculate the gain of the updated entry...?
end;
$$ language plpgsql;


create trigger Q17
    after insert or update on asx
for each row execute procedure Q17_procedure();



create or replace function
    Q18_procedure() returns trigger
as $$
declare

begin
    raise notice 'update triggered...';
    insert into asxlog values (now(), old."Date", old.Code, old.volume, old.price);
    return new;

end;
$$ language plpgsql;

create trigger Q18
    after update on asx
for each row execute procedure Q18_procedure();



