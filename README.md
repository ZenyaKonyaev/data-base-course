# data-base-course

Wonderful course of data base BMSTU

Область данных бд: ну зачем, ну зачем, ты смотрела аниме...


Useful info about docker:

- sudo docker container cp datasets/. postgres-0:/var/lib/postgresql/data/datasets -> copy data files for scripts into docker container 

- sudo docker container exec -it postgres-0 psql --dbname=postgres --username postgres -f /copy.sql  -> copy sql file into docker container

- sudo docker container exec -it postgres-0 psql --dbname=postgres --username postgres -f /copy.sql -> run sql file into docker container

