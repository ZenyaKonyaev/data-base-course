drop table if exists public.animes;
create table public.animes(
      name text primary key NOT NULL,
      genre text NOT NULL,
      amount_episodes int NOT NULL CHECK (amount_episodes > 0),
      rate  float NOT NULL CHECK (rate > 0),
      studio text NOT NULL,
      mangaca_id int NOT NULL CHECK (rate > 0),
      studio_draw text NOT NULL
);

COPY public.animes(name, genre, amount_episodes, rate, studio, mangaca_id, studio_draw)
    FROM 'C:\bmstu_bd\lab_01\datasets\anime_titles_transformed.csv'
    DELIMITER ',';

drop table if exists public.studios;
create table public.studios(
                              name text primary key NOT NULL,
                              money int NOT NULL CHECK (money > 0),
                              country text NOT NULL,
                              rate  float NOT NULL CHECK (rate > 0)
);
COPY public.studios(name, money, country, rate)
    FROM 'C:\bmstu_bd\lab_01\datasets\studios.csv'
    DELIMITER ',';

drop table if exists public.mangacas;
create table public.mangacas(
                               id int primary key NOT NULL,
                               name text NOT NULL,
                               surname text NOT NULL,
                               patronymic text NOT NULL,
                               sex text NOT NULL CHECK (sex='m' or sex='f'),
                               rate  float NOT NULL CHECK (rate > 0),
                               percent_income int NOT NULL
);
COPY public.mangacas(id, name, surname, patronymic, sex, rate, percent_income)
    FROM 'C:\bmstu_bd\lab_01\datasets\mangacas.csv'
    DELIMITER ',';

drop table if exists public.sounders;
create table public.sounders(
                                id int primary key NOT NULL,
                                name text NOT NULL,
                                surname text NOT NULL,
                                patronymic text NOT NULL,
                                sex text NOT NULL CHECK (sex='m' or sex='f'),
                                country text NOT NULL,
                                rate  float NOT NULL CHECK (rate > 0),
                                hour_price int NOT NULL
);
COPY public.sounders(id, name, surname, patronymic, sex, country, rate, hour_price)
    FROM 'C:\bmstu_bd\lab_01\datasets\sounders.csv'
    DELIMITER ',';

drop table if exists public.studios_draw;
create table public.studios_draw(
                                name text primary key NOT NULL,
                                style_draw text NOT NULL,
                                hour_price int NOT NULL,
                                rate  float NOT NULL CHECK (rate > 0)
);
COPY public.studios_draw(name, style_draw, hour_price, rate)
    FROM 'C:\bmstu_bd\lab_01\datasets\drawStudios.csv'
    DELIMITER ',';




drop table if exists public.link_sounders_animes;
create table public.link_sounders_animes(
                                    id int NOT NULL CHECK (id > 0),
                                    name text NOT NULL
);
COPY public.link_sounders_animes(id, name)
    FROM 'C:\bmstu_bd\lab_01\datasets\link_table_sounder_anime.csv'
    DELIMITER ',';