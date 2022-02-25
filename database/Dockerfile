FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD="bandtec"
ENV MYSQL_DATABASE="projeto-pi"
ENV MYSQL_USER="admin"
ENV MYSQL_PASSWORD="admin"

COPY ./create-database.sql /docker-entrypoint-initdb.d