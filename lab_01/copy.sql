COPY public.animes(name, genre, amount_episodes, rate, studio, mangaca_id, studio_draw)
    FROM './datasets/anime_titles.csv'
    DELIMITER ',';

COPY public.studios(name, money, country, rate)
    FROM './datasets/studios.csv'
    DELIMITER ',';

COPY public.mangacas(id, name, surname, patronymic, sex, rate, percent_income)
    FROM './datasets/mangacas.csv'
    DELIMITER ',';

COPY public.sounders(id, name, surname, patronymic, sex, country, rate, hour_price)
    FROM './datasets/sounders.csv'
    DELIMITER ',';

COPY public.studios_draw(name, style_draw, hour_price, rate)
    FROM './datasets/drawStudios.csv'
    DELIMITER ',';


COPY public.link_sounders_animes(id, name)
    FROM './datasets/link_table_sounder_anime.csv'
    DELIMITER ',';

COPY public.resounders(name,
                       multiple_voice,
                       rate ,
                       year_create)
    FROM './datasets/resound_studio.csv'
    DELIMITER ',';

COPY public.link_resounders_animes(name_resounder,
                                   name_anime)
    FROM './datasets/link_resound_anime.csv'
    DELIMITER ',';
