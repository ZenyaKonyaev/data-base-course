# data-base-course

Wonderful course of data base BMSTU

Область данных бд: ну зачем, ну зачем, ты смотрела аниме...


Useful info about docker:

Before lab_04:

- sudo docker run --name postgres-0 -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres:alpine -> up postgres data base in docker container

- sudo docker ps -a -> show docker containers (include exited)

- sudo docker container start postgres-0 -> runs docker container (where 1a970630cbe4 is docker container id)

- sudo docker exec -it postgres-0 bash -> open container (name of container postgres-0) in bash (ctrl+D for exit from containres`s bash to terminal)

- sudo docker container cp datasets/. postgres-0:/var/lib/postgresql/data/datasets -> copy data files for scripts into docker container 

- sudo docker container exec -it postgres-0 psql --dbname=postgres --username postgres -f /copy.sql  -> copy sql file into docker container

- sudo docker container exec -it postgres-0 psql --dbname=postgres --username postgres -f /copy.sql -> run sql file into docker container

After lab_03 (i cant install plpython3u for previous docker-container, because it use default linux, not ubuntu ;/ ):

- sudo docker pull ubuntu/postgres -> downloads image 

- sudo docker run -d --name postgres-container -e TZ=UTC -p 30432:5432 -e POSTGRES_PASSWORD=My:s3Cr3t/ ubuntu/postgres:14-22.04_beta -> (generally run)

```
-e TZ=UTC 	Timezone.
-e POSTGRES_PASSWORD=secret 	Set the password for the superuser which is postgres by default. Bear in mind that to connect to the database in the same host the password is not needed but to access it via an external host (for instance another container) the password is needed. This option is mandatory and must not be empty.
-e POSTGRES_USER=john 	Create a new user with superuser privileges. This is used in conjunction with POSTGRES_PASSWORD.
-e POSTGRES_DB=db_test 	Set the name of the default database.
-e POSTGRES_INITDB_ARGS="--data-checksums" 	Pass arguments to the postgres initdb call.
-e POSTGRES_INITDB_WALDIR=/path/to/location 	Set the location of the Postgres transaction log. By default it is stored in a subdirectory of the main Postgres data folder (PGDATA).
-e POSTGRES_HOST_AUTH_METHOD=trust 	Set the auth-method for host connections for all databases, all users, and all addresses. The following will be added to the pg_hba.conf if this option is passed: host all all all $POSTGRES_HOST_AUTH_METHOD.
-e PGDATA=/path/to/location 	Set the location of the database files. The default is /var/lib/postgresql/data.
-p 30432:5432 	Expose Postgres on localhost:30432.
-v /path/to/postgresql.conf:/etc/postgresql/postgresql.conf 	Local configuration file postgresql.conf (try this example).
-v /path/to/persisted/data:/var/lib/postgresql/data 	Persist data instead of initializing a new database every time you launch a new container.
```

- sudo docker run -d --name postgres-1 -p 30432:5432 -e POSTGRES_PASSWORD=123 ubuntu/postgres -> (run that i use) 

- for install plpython3u:
	- apt update -> updates apt (befor run container via bush)
	- apt -y install postgresql-plpython3-14 (befor run container via bush)

- 

