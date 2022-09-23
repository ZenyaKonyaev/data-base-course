# data-base-course

Wonderful course of data base BMSTU

Область данных бд: ну зачем, ну зачем, ты смотрела аниме...


Useful info about docker:

- sudo docker run --name postgres-0 -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres:alpine -> up postgres data base in docker container

- sudo docker ps -a -> show docker containers (include exited)

- sudo docker container start 1a970630cbe4 -> runs docker container (where 1a970630cbe4 is docker container id)

- sudo docker exec -it postgres-0 bash -> open container (name of container postgres-0) in bash (ctrl+D for exit from containres`s bash to terminal)

- sudo docker container cp datasets/. postgres-0:/var/lib/postgresql/data/datasets -> copy data files for scripts into docker container 

- sudo docker container exec -it postgres-0 psql --dbname=postgres --username postgres -f /copy.sql  -> copy sql file into docker container

- sudo docker container exec -it postgres-0 psql --dbname=postgres --username postgres -f /copy.sql -> run sql file into docker container

