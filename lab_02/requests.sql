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
