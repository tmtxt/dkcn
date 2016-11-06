FROM postgres:9.6.1
MAINTAINER TruongTX

COPY ./init-main-db.sh /docker-entrypoint-initdb.d/init-main-db.sh
COPY ./init-auth-db.sh /docker-entrypoint-initdb.d/init-auth-db.sh
