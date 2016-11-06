#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER app_auth;
    CREATE DATABASE app_auth WITH OWNER = app_auth;
EOSQL
