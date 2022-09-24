-- №1 Инструкция SELECT, исп. предикат сравнения
-- все аниме, у которых рейтинг выше 7 и жанр Action
select name, amount_episodes from public.animes
where rate > 7 and genre = 'Action';

-- №2 Инструкция SELECT, исп. предикат BETWEEN
-- все мангаки у которых процент от прибыли между 5 и 10
select name, surname, patronymic, rate from public.mangacas
where percent_income between 5 and 10;

-- №3 Инструкция SELECT, исп предикат LIKE
-- все студии у которых имя начинается со Studio...
select name, rate from public.studios
where name like 'Studio%';

-- №4 Инструкция SELECT, исп предикат IN c вложенным подзапросом
-- Все аниме у которых студия из Китая
Select name, amount_episodes from public.animes
where studio in (select name from public.studios
                               where country = 'China');

-- №5 Инструкция SELECT, исп предикат EXISTS c вложенным подзапросом
-- Все аниме у которых мангаки - женщины
select * from public.animes
where EXISTS(select sex from public.mangacas
    where public.animes.mangaca_id = public.mangacas.id and sex='f');

-- №6 Инструкция SELECT, исп предикат сравнения с квантором
-- найти аниме у которых самая оплачиваемая худ. студия
select public.animes.name, public.animes.studio_draw, public.animes.rate from public.animes
where public.animes.studio_draw in (select public.studios_draw.name from public.studios_draw
                                        where public.studios_draw.hour_price >= ALL (select public.studios_draw.hour_price from public.studios_draw));

-- №7 Инструкция SELECT, исп агрегатные функции в выражениях столбцов
-- найти кол-во аниме с самым маленьким кол-вом серий
select COUNT(*) as AMOUNT_ANIME_WITH_MIN_EPISODES from (select name from public.animes
                                  where amount_episodes =
                                        (select MIN(amount_episodes) from public.animes)) as TableNamesAnume;

-- №8 Инструкция SELECT, исп скалярные подзапросы в выражениях столбцов
-- найти все студии, у которых бюджет ниже среднего
select name, money from public.studios
where money < (select AVG(money) from public.studios);

-- №9 Инструкция SELECT, исп простое выражение case
-- найти сколько лет назад основали студии переозвучки
SELECT name,
       CASE
           WHEN year_create = date_part('year', CURRENT_DATE) then 'This year'
           WHEN year_create = date_part('year', CURRENT_DATE) - 1 then 'Last year'
           ELSE CAST(date_part('year', CURRENT_DATE) - resounders.year_create as text) || ' years ago'
       END as year_start_resound
from public.resounders;

-- №10 Инструкция SELECT, исп поисковое выражение case
-- на основании кол-ва эпизодов понять какой тайтл по продолжительности (короткий, средний, долги)
select name,
       CASE
           when amount_episodes < (select AVG(amount_episodes) from public.animes) then 'short'
           when amount_episodes = (select AVG(amount_episodes) from public.animes) then 'normal'
           else 'long'
       END as longest_title
from public.animes;

-- №11 Создание новой локальной таблицы из результирующего набора данных SELECT
-- создание временной таблицы c кол-вом актеров озвучки из японии или китая
drop table if exists amount_sounders_from_country;
select country, count(name) INTO amount_sounders_from_country from public.sounders
where country = 'China' or country = 'Japan' group by country;
select  * from amount_sounders_from_country;

-- №12 Инстуркция SELECT, использующая вложенные корелированные подзапросы в качестве производных таблиц в предложении FROM
-- Найти мангак, которые работали над аниме, у которых оценка выще 9
select id, name, surname, patronymic from public.mangacas m
where m.id IN (select a.mangaca_id from public.animes a where a.rate > 9);

-- №13 Инуструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3
-- найти актеров озвучки, которые озвучивали аниме с рейтингом выше 8.5
select id, name, surname, patronymic from public.sounders s
where s.id IN (select lsa.id from public.link_sounders_animes lsa where lsa.name in (select a.name from public.animes a where a.rate > 8.5));

-- №14 Инструкция SELECT консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING
-- для каждой студии посчитать средий рейтинг всех тайтлов, которые они курировали
select s.name, (select avg(a.rate) from public.animes a where a.studio = s.name) as mid_rate_titles from public.studios s group by s.name, mid_rate_titles;

-- №15 Инструкция SELECT консолидирующая данные с помощью предложения GROUP BY и предложения HAVING
-- найти все тайтлы у которых кол-во актеров озвучки, занимающихся ими больше 1
select name, COUNT(id) as AMOUNT_SOUNDERS from public.link_sounders_animes
group by name
having COUNT(id) > 1;

-- №16 Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений
INSERT INTO public.resounders (name, multiple_voice, rate, year_create) VALUES ('Super Resounders', 'y', 6.7, 2020);

-- №17 Многострочня инструкция INSERT, выполняющая втсавку в таблицу результирующего набора данных вложенного подзапроса
-- Вставить студию озвучки, у которой рейтинг будет равняться максимальному рейтингу из всех студий-издателей
insert into public.amount_sounders_from_country (country, count)
select country, (select COUNT(name) from public.sounders where country = 'Malta') from public.sounders where country = 'Malta' group by country;


-- №18 Простая инструкция UPDATE
UPDATE public.resounders
set
    rate = 7
where
    name = 'Super Resounders';

-- №19 Инстуркция UPDATE со скалярным подзапросом в приложении set
-- устанавливаем студии переозвучки Super Resounders рейтинг, который равняется среднему рейтингу среди студий рисовки
update public.resounders
set
    rate = (select AVG(rate) from public.studios_draw)
where
    name = 'Super Resounders';

-- №20 Просая инструкция DELETE
delete from amount_sounders_from_country where country = 'Malta';

-- №21 Инструкция delete со вложенным корелированным подзапросом в предложении WHERE
-- Удалить из базы актером озвучки с минимальным рейтингом
delete from public.sounders
where rate = (select MIN(rate) from public.sounders);

-- №22 Инструкция select использующая простое обобщенное табличное выражение
-- Вывести средний рейтинг всех актеров озвучки
WITH TestCTE (id, name, surname, patronymic, rate) AS
    (
        SELECT id, name, surname, patronymic, rate from public.sounders
    )
SELECT AVG(rate) as middle_rate_of_all_sounders from TestCTE;

-- №23 Инструкция select использующая рекурсивное обобщенное табличное выражение
-- Найти уровень в иерархии начальства конкретного сотрудника из таблицы сотрудников компании
drop table if exists public.workers;
create table workers(
    id int not null,
    name text not null,
    manager_id int
);
insert into public.workers VALUES (1, 'Capitan', NULL);
insert into public.workers VALUES (2, 'SubCapitan 1', 1);
insert into public.workers VALUES (3, 'SubCapitan 2', 1);
insert into public.workers VALUES (4, 'Common human_SubCapitan 1', 2);
insert into public.workers VALUES (5, 'Common human_SubCapitan 1', 2);
insert into public.workers VALUES (6, 'Common human_SubCapitan 1', 2);
insert into public.workers VALUES (7, 'Common human_SubCapitan 2', 3);
insert into public.workers VALUES (8, 'Common human_SubCapitan 2', 3);
insert into public.workers VALUES (9, 'Common human_SubCapitan 2', 3);
WITH RECURSIVE TestCTE(id, name, manager_id, level) as
    (
        -- Anchor
        select id, name, manager_id, 0 from public.workers where manager_id is NULL
        UNION ALL
        -- Iterations
        select w.id, w.name, w.manager_id, c.level + 1 from (workers as w join TestCTE as c on w.manager_id = c.id)
    )
SELECT * from TestCTE order by level;

-- №24 Оконные функции. Использование конструкции MIN/MAX/AVG OVER()
-- Для каждой страны посчитать средний, минимальный и минимальный плату за час актеров озвучки, принадлежащих этой стране
select distinct country,
       AVG(hour_price) OVER(PARTITION BY country) as mid_price,
       MIN(hour_price) OVER(PARTITION BY country) as min_price,
       MAX(hour_price) OVER(PARTITION BY country) as max_price
from public.sounders order by country;

-- №25 Оконные функции для устранения дублей
-- из таблицы убрать все полные дубли с помощью ROW_NUMBER()
drop table if exists public.workers;
create table workers(
    id int not null,
    name text not null,
    manager_id int
);
insert into public.workers VALUES (1, 'Capitan', NULL);
insert into public.workers VALUES (2, 'SubCapitan 1', 1);
insert into public.workers VALUES (2, 'SubCapitan 1', 1);
insert into public.workers VALUES (3, 'Common human_SubCapitan 1', 2);
insert into public.workers VALUES (3, 'Common human_SubCapitan 1', 2);
insert into public.workers VALUES (3, 'Common human_SubCapitan 1', 2);
insert into public.workers VALUES (3, 'Common human_SubCapitan 1', 3);
insert into public.workers VALUES (3, 'Common human_SubCapitan 1', 3);
insert into public.workers VALUES (1, 'Common human_SubCapitan 1', 2);
insert into public.workers VALUES (1, 'Common human_SubCapitan 1', 2);
select id, name, manager_id from (select id,
                      name,
                      manager_id,
                      row_number() over (PARTITION BY id, name, manager_id) as num_row
               from public.workers) as newT
where num_row = 1;


-- Доп задание (еще не сделано)
drop table if exists public.versionsA;
create table versionsA(
    id int,
    var1 text,
    valid_from_dttm date,
    valid_to_dttm date
);
insert into versionsA values (1, 'A1', '2018-09-01', '2018-09-15');
insert into versionsA values (1, 'A2', '2018-09-16', '5999-12-31');
drop table if exists public.versionsB;
create table versionsB(
    id int,
    var2 text,
    valid_from_dttm date,
    valid_to_dttm date
);
insert into versionsA values (1, 'B1', '2018-09-01', '2018-09-18');
insert into versionsA values (1, 'B2', '2018-09-19', '5999-12-31');


