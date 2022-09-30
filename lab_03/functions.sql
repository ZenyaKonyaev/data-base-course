-- 1

CREATE FUNCTION countSoundedAnime(idx int)
returns int as '
-- считает кол-во озвученных аниме у актера озвучки
select count(*) from public.link_sounders_animes as lsa
where lsa.id = idx'
LANGUAGE sql;

select *, countSoundedAnime(id) as amountSounded from sounders
where id = 316;

-- 2

CREATE FUNCTION soundersFromCity(city_name text)
returns TABLE (id_sounder int, name_sounder text, surname_sounder text, rate_sounder float)
AS '
-- находит всех актеров озвучки из определенной страны
select id, name, surname, rate from public.sounders
where country = city_name;
'
language sql;
select * from soundersFromCity('China');

-- 3

create or replace function getStudioDrawByRateOrStyle(_rate float, _style_draw text)
returns TABLE (studio_name text) as '
-- ищет студии рисовки с определенным рейтингом или стилем рисовки
begin
    RETURN QUERY
    select name from studios_draw
    where _style_draw = style_draw group by name;

    RETURN QUERY
    select name from studios_draw
    where _rate = rate group by name;

end
'
language plpgsql;

select studio_name from getStudioDrawByRateOrStyle(6.25, 'Realistic');

-- 4

CREATE OR REPLACE FUNCTION factorial(number INT)
RETURNS int
AS '
-- функция для посдчета факториала
BEGIN
    IF number = 1 THEN
        RETURN 1;
    ELSE
        RETURN number * factorial(number - 1);
    END IF;
END
'
LANGUAGE plpgsql;

SELECT factorial(2);

-- 5

CREATE OR REPLACE PROCEDURE insertResounder(_name text, _multiple_voice text, _rate float, _year_create int)
AS '
BEGIN
    INSERT INTO public.resounders (name, multiple_voice, rate, year_create)  VALUES (_name, _multiple_voice, _rate, _year_create);
END
'
LANGUAGE plpgsql;

CALL insertResounder('MyAwesomeResounder', 'y', 8.8, 2022);

-- 6

CREATE OR REPLACE PROCEDURE factorialProc
(
	res INOUT int,
	number int
)
AS '
BEGIN
	IF number = 1 THEN
        res = 1;
    ELSE
        CALL factorialProc(res, number - 1);
        res = res * number;
    END IF;
END;
' LANGUAGE plpgsql;

CALL factorialProc(1, 5);

-- 7
DROP PROCEDURE findAnimeUpTheRate;
CREATE OR REPLACE PROCEDURE findAnimeUpTheRate
(
	INOUT res refcursor,
	_rate float
)
AS '
begin
    OPEN res for select * from animes where rate > _rate;
end;
'
LANGUAGE plpgsql;

ROLLBACK;

BEGIN;
    CALL findAnimeUpTheRate('funccursor', 9);
    FETCH ALL in funccursor;
    close funccursor;
END;

-- 8

CREATE OR REPLACE PROCEDURE accessToMeta(
	_name_table text
)
AS '
DECLARE
	el RECORD;
BEGIN
	FOR el IN
		SELECT column_name, data_type
		FROM information_schema.columns
        WHERE table_name = _name_table
	LOOP
		RAISE NOTICE ''el = %'', el;
	END LOOP;
END;
' LANGUAGE plpgsql;

CALL accessToMeta('animes');

-- 9

CREATE table resounders_audit
(
    operation char(1) NOT NULL,
    time_operation timestamp NOT NULL,
    name_studio text NOT NULL
);

CREATE OR REPLACE FUNCTION auditResoundersTrigger()
RETURNS TRIGGER
AS '
-- функция для посдчета факториала
BEGIN
    IF tg_op = ''DELETE'' THEN
        insert into resounders_audit (operation, time_operation, name_studio) values (''D'', now(), OLD.name);
        RETURN OLD;
    ELSIF tg_op = ''UPDATE'' THEN
        insert into resounders_audit (operation, time_operation, name_studio) values (''U'', now(), NEW.name);
        RETURN NEW;
    ELSIF tg_op = ''INSERT'' THEN
        insert into resounders_audit (operation, time_operation, name_studio) values (''I'', now(), NEW.name);
        RETURN NEW;
    END IF;
    RETURN NULL;
END
'
LANGUAGE plpgsql;

create trigger resounders_audit after INSERT OR UPDATE OR DELETE ON resounders
    for each row execute procedure auditResoundersTrigger();


CALL insertResounder('MyAwesomeResounder2', 'y', 8.8, 2022);

-- 10

CREATE VIEW resounders_buf as select * from resounders;
select * from resounders_buf;

CREATE OR REPLACE FUNCTION deleteResounderTrigger()
RETURNS TRIGGER
AS '
-- функция для посдчета факториала
BEGIN
    RAISE NOTICE ''Old = %'', old;
    UPDATE resounders
    set rate = 0, name = ''deleted''
    where name = old.name;
    return old;
END
'
LANGUAGE plpgsql;

create trigger deleteResounder INSTEAD OF DELETE ON resounders_buf
    for each row execute procedure deleteResounderTrigger();


delete from resounders_buf
where name = 'MyAwesomeResounder2';



