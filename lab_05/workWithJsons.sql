--1. Из таблиц базы данных, созданной в первой лабораторной работе, извлечь
--данные в XML (MSSQL) или JSON(Oracle, Postgres). Для выгрузки в XML
--проверить все режимы конструкции FOR XML

select row_to_json(a) result from public.animes a;
select row_to_json(m) result from public.mangacas m;
select row_to_json(r) result from public.resounders r;
select row_to_json(s) result from public.sounders s;
select row_to_json(st) result from public.studios st;
select row_to_json(st_d) result from public.studios_draw st_d;

--2. Выполнить загрузку и сохранение XML или JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.

drop table if exists public.animes_copy;
create table if not exists animes_copy(
    name text primary key,
    genre text,
    amount_episodes int,
    rate  float,
    studio text,
    mangaca_id int,
    studio_draw text
);

COPY
(
    select row_to_json(a) result from public.animes a
)
TO '/home/docUser/animes.json';

drop table if exists public.animes_copy_import;
create table if not exists public.animes_copy_import( doc json );

-- нужно чтобы у всех категорий был доступ на запись к данному файлу. По умолчанию это не так
-- В linux фиксится командой: chmod uog+w <имя файла json>
COPY public.animes_copy_import from '/home/docUser/animes.json';

select * from public.animes_copy_import;

insert into animes_copy(name, genre, amount_episodes, rate, studio, mangaca_id, studio_draw)
select doc->>'name', doc->>'genre', (doc->>'amount_episodes')::integer, (doc->>'rate')::float, doc->>'studio', (doc->>'mangaca_id')::integer, doc->>'studio_draw' from animes_copy_import;

select * from animes_copy;



--3. Создать таблицу, в которой будет атрибут(-ы) с типом XML или JSON, или
-- добавить атрибут с типом XML или JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT
-- или UPDATE.

drop table if exists cars;
create table if not exists cars
(
    id serial primary key,
    brand text,
    info json
);

insert into cars(brand, info) values
    ('BMW', '{"model": "X-5", "cost_usd": 40000, "rate_top":7.6, "adres_promouter": { "city": "Moscow", "street": "Lenina"}}'::json),
    ('Lamborgini', '{"model": "Hurakan", "cost_usd": 75000, "rate_top":9.1, "adres_promouter": { "city": "Berlin", "street": "Shlaigthster"}}'::json),
    ('Lada', '{"model": "Granta", "cost_usd": 15000, "rate_top":5.9, "adres_promouter": { "city": "New-Yourk", "street": "Green"}}'::json);

select * from cars;

--4. Выполнить следующие действия:
--4.1. Извлечь XML/JSON фрагмент из XML/JSON документа

drop table if exists geted_info_signature;
CREATE TABLE IF NOT EXISTS geted_info_signature
(
	name text,
	rate float
);

SELECT * FROM animes_copy_import, json_populate_record(NULL::geted_info_signature, doc);

-- 4.2. Извлечь значения конкретных узлов или атрибутов XML/JSON
-- документа

select info->'adres_promouter'->'city' from cars;

-- 4.3. Выполнить проверку существования узла или атрибута

drop function if exists check_on_exists_field_animes_import;
create or replace function check_on_exists_field_animes_import(field_name text)
returns bool
as $$
    res = plpy.execute(f" \
    select count(doc->'{field_name}') from public.animes_copy_import")
    if res[0]['count'] > 0:
        return True
    return False
    $$ language plpython3u;

select * from check_on_exists_field_animes_import('rate');

--4.4. Изменить XML/JSON документ

drop table if exists carsb;
create table if not exists carsb
(
    id serial primary key,
    brand text,
    info jsonb
);

insert into carsb(brand, info) values
    ('BMW', '{"model": "X-5", "cost_usd": 40000, "rate_top":7.6, "adres_promouter": { "city": "Moscow", "street": "Lenina"}}'::jsonb),
    ('Lamborgini', '{"model": "Hurakan", "cost_usd": 75000, "rate_top":9.1, "adres_promouter": { "city": "Berlin", "street": "Shlaigthster"}}'::jsonb),
    ('Lada', '{"model": "Granta", "cost_usd": 15000, "rate_top":5.9, "adres_promouter": { "city": "New-Yourk", "street": "Green"}}'::jsonb);

select * from carsb;

update carsb
set info = jsonb_set(info, '{model}', '"Granta"')
WHERE id = 3;



-- 4.5 Разделить XML/JSON документ на несколько строк по узлам

drop table if exists cars;
create table if not exists cars
(
    id serial primary key,
    info json
);

insert into cars(info) values
(
'[{"model": "X-5", "cost_usd": 40000, "rate_top":7.6, "adres_promouter": { "city": "Moscow", "street": "Lenina"}},
{"model": "Hurakan", "cost_usd": 75000, "rate_top":9.1, "adres_promouter": { "city": "Berlin", "street": "Shlaigthster"}},
{"model": "Granta", "cost_usd": 15000, "rate_top":5.9, "adres_promouter": { "city": "New-Yourk", "street": "Green"}}]'
);

select json_array_elements(info) from cars;

