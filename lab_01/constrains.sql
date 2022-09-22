-- Аниме
alter table public.animes add constraint amount_episodes_constr check (amount_episodes > 0);

-- Студии
alter table public.studios add constraint money_constr check (money > 0);
alter table public.studios add constraint rate_constr check (rate > 0);

-- Озвучка
alter table public.sounders add constraint sex_constr check (sex='m' or sex='f');
alter table public.sounders add constraint rate_constr check (rate > 0);

-- Худ студии
alter table public.studios_draw add constraint rate_constr check (rate > 0);

-- Мангака
alter table public.mangacas add constraint sex_constr check (sex='m' or sex='f');
