-- Создать, развернуть и протестировать 6 объектов SQL CLR

-- 1
-- Определяемую пользователем скалярную функцию CLR,
-- Находит имя актера озвучки с конкретным id

select * from pg_language;
SELECT name, default_version, installed_version FROM pg_available_extensions;
create extension if not exists plpython3u;

CREATE OR REPLACE FUNCTION get_name_sounder_by_id(_id INT)
RETURNS TEXT
AS $$
res = plpy.execute(f" \
    SELECT name FROM public.sounders WHERE id = {_id};")
if res:
    return res[0]['name']
$$ LANGUAGE plpython3u;

select * from get_name_sounder_by_id(2);

select id, name, surname, patronymic, sex from public.sounders
where name = get_name_sounder_by_id(2);

-- 2
-- Пользовательскую агрегатную функцию CLR
-- Считает количество всех актеров озвучки у которых рейтинг выше 9

create or replace function count_sounders_rate_more_than(_a int , _rate float)
returns int
as $$
    _amount = 0
    res = plpy.execute(f" \
    select * from public.sounders where rate > {_rate}")
    return len(res)
    $$ language plpython3u;

CREATE OR REPLACE AGGREGATE count_sounedrs(float)
(
        sfunc = count_sounders_rate_more_than,
        stype = int
);

select count_sounedrs(9) from public.resounders;

-- 3
-- Определяемую пользователем табличную функцию CLR
-- Найти всех актеров звучки, у которых часовая оплата лежит в заданном диапазоне

drop function find_sounders_by_min_max_cost(_min int, _max int);

create or replace function find_sounders_by_min_max_cost(_min int, _max int)
returns table (
    id int,
    name text,
    surname text,
    patronymic text,
    sex char,
    country text,
    rate  float,
    hour_price int
)
AS $$
    buf = plpy.execute(f"select * from public.sounders")
    result = []
    for sounder in buf:
        if (sounder["hour_price"] >= _min and _max >= sounder["hour_price"]):
            result.append(sounder)
    return result
$$ LANGUAGE plpython3u;

select * from find_sounders_by_min_max_cost(101, 200);

-- 4
-- Хранимую процедуру CLR
-- Добавляет студию переозвучки в таблицу
CREATE OR REPLACE PROCEDURE add_resounder_clr(_name text, _multiple_voice text, _rate float, _year_create int)
as $$
    request = plpy.prepare("INSERT INTO public.resounders (name, multiple_voice, rate, year_create)  VALUES ($1, $2, $3, $4)", ["TEXT", "TEXT", "FLOAT", "INT"])
    plpy.execute(request, [_name, _multiple_voice, _rate, _year_create])
$$ language plpython3u;

select * from public.resounders;

CALL add_resounder_clr('Animedia', 'y', 9.5, 2017);

-- 5
-- Триггер CLR
-- 


