import psycopg2

def printresult(elements):
    print('Результат:')
    for element in elements:
        for value in element:
            print(str(value) + ' | ', end='')
        print('\n')

def scalar_request(con):
    con.execute('select name, money from public.studios where money < (select AVG(money) from public.studios);')
    printresult(con.fetchall())

def many_con_request(con):
    con.execute('select t1.name, t2.style_draw from (public.animes as t1 join public.studios_draw as t2 on t1.studio_draw = t2.name);')
    printresult(con.fetchall())

def otv_request(con):
    con.execute(
        'WITH TestCTE (id, name, surname, patronymic, max_rate, country) AS \
    ( \
        SELECT id, name, surname, patronymic, max(rate) OVER(partition by country) as max_rate, country from public.sounders \
    ) \
SELECT max(max_rate), country from TestCTE group by country;')
    printresult(con.fetchall())

def meta_request(con):
    con.execute('SELECT column_name, data_type FROM information_schema.columns WHERE table_name = \'animes\';')
    printresult(con.fetchall())

def scalar_third_request(con):
    con.execute('CREATE FUNCTION countSoundedAnime(idx int)\
    returns int as \' \
    select count(*) from public.link_sounders_animes as lsa \
    where lsa.id = idx\'LANGUAGE sql; select *, countSoundedAnime(id) as amountSounded from sounders where id = 316;')
    printresult(con.fetchall())

def many_op_request(con):
    con.execute('create or replace function getStudioDrawByRateOrStyle(_rate float, _style_draw text) \
returns TABLE (studio_name text) as \'\
begin\
    RETURN QUERY \
    select name from studios_draw \
    where _style_draw = style_draw group by name; \
\
    RETURN QUERY \
    select name from studios_draw \
    where _rate = rate group by name; \
end \
\'\
language plpgsql; select studio_name from getStudioDrawByRateOrStyle(6.25, \'Realistic\');')
    printresult(con.fetchall())

def store_proc_request(con):
    con.execute('CREATE OR REPLACE PROCEDURE insertResounder(_name text, _multiple_voice text, _rate float, _year_create int)\
AS \'\
BEGIN\
    INSERT INTO public.resounders (name, multiple_voice, rate, year_create)  VALUES (_name, _multiple_voice, _rate, _year_create);\
END\
\'\
LANGUAGE plpgsql;\
CALL insertResounder(\'MyAwesomeResounder124\', \'y\', 8.8, 2022); select * from resounders;')
    printresult(con.fetchall())

def system_fun_request(con):
    con.execute('select current_database();')
    printresult(con.fetchall())
def create_table(con):
    con.execute('drop table if exists public.resounders;\
create table public.resounders(\
                                    name text,\
                                    multiple_voice text,\
                                    rate  float,\
                                    year_create int);\
COPY public.resounders(name,\
                       multiple_voice,\
                       rate ,\
                       year_create)\
    FROM \'./datasets/resound_studio.csv\' DELIMITER \',\';')
def insert_data(con):
    con.execute('INSERT INTO public.resounders (name, multiple_voice, rate, year_create) VALUES (\'Super Resounders\', \'y\', 6.7, 2020);')

def main():
    try:
        con = psycopg2.connect(
            database="postgres",
            user="postgres",
            password="123",
            host="localhost",  # Адрес сервера базы данных.
            port="30432"  # Номер порта.
        )
    except:
        print("Ошибка при подключении к Базе Данных")
        return

    functions = [scalar_request, many_con_request, otv_request, meta_request, scalar_third_request, many_op_request,
                 store_proc_request, system_fun_request, create_table, insert_data]
    msg = ['найти все студии, у которых бюджет ниже среднего',
           'найти стиль рисовки для каждого аниме',
           'найти лучшие оценки актеров переозвучки в каждой стране',
           'получить доступ к метаданным таблицы с аниме',
           'накти кол-во озвученных аниме у актера озвучки с id 316',
           'найти студии рисовки с определенным рейтингом (6.25) или стилем рисовки(Realistic)',
           'вставить студию переозвучки в таблицу',
           'вывести базу данных, к которой сейчас подключены',
           'создать таблицу студий переозвучки и заполнить ее из файла resund_studio.csv',
           'вставить в таблицу resounders значение (\'Super Resounders\', \'y\', 6.7, 2020)']

    print('Меню:\n'
          '1) Выполнит скалярный запрос\n'
          '2) Выполнить запрос с несколькими соединениями (JOIN)\n'
          '3) Выполнить запрос с ОТВ(CTE) и оконными функциями\n'
          '4) Выполнить запрос к метаданным\n'
          '5) Вызвать скалярну функцию (написанную в третьей лаборатрной работе)\n'
          '6) Вызвать многооператорную или табличную функцию (написанную в третьей лабораторной работе)\n'
          '7) Вызвать хранимую процедуру (написанную в третьей лабораторной работе)\n'
          '8) Вызвать системную функцию или процедуру\n'
          '9) Создать таблицу в базе данных, соответствующую тематике БД\n'
          '10) Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY\n')

    action = int(input("Ваше действие: "))

    print(msg[action - 1])
    (functions[action - 1])(con.cursor())
    if (action == 10): #костыльменеджер, лень переделывать
        con.commit()

main()




