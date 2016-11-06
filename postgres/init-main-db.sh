#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER app_main;
    CREATE DATABASE app_main WITH OWNER = app_main;
EOSQL
