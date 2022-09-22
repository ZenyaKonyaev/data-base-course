drop table if exists public.animes;
create table public.animes(
      name text primary key,
      genre text,
      amount_episodes int,
      rate  float,
      studio text,
      mangaca_id int,
      studio_draw text
);

drop table if exists public.studios;
create table public.studios(
                              name text primary key,
                              money int,
                              country text,
                              rate float
);

drop table if exists public.mangacas;
create table public.mangacas(
                               id int primary,
                               name text,
                               surname text,
                               patronymic text,
                               sex text,
                               rate  float,
                               percent_income int
);

drop table if exists public.sounders;
create table public.sounders(
                                id int primary key,
                                name text,
                                surname text,
                                patronymic text,
                                sex text,
                                country text,
                                rate  float,
                                hour_price int
);

drop table if exists public.studios_draw;
create table public.studios_draw(
                                name text primary key,
                                style_draw text,
                                hour_price int,
                                rate  float
);




drop table if exists public.link_sounders_animes;
create table public.link_sounders_animes(
                                    id int,
                                    name text
);

drop table if exists public.resounders;
create table public.resounders(
                                    name text,
                                    multiple_voice text,
                                    rate  float,
                                    year_create int
);

drop table if exists public.link_resounders_animes;
create table public.link_sounders_animes(
                                    name_resounder text,
                                    name_anime text
);
