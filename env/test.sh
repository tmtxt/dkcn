#!/usr/bin/env sh

export COMPOSE_PROJECT_NAME=dkcn_test
export DKCN_ENV=test

function before_test_api_server {
    # update backing service
    docker-compose up -d postgres
    docker-compose up -d redis

    # migrate
    docker-compose run --rm schemup_main schemup commit
    docker-compose run --rm schemup_auth schemup commit
}

function after_test_api_server {
    docker-compose down
}

function test_api_server {
    before_test_api_server
    docker-compose run --rm api_server /bin/bash
}
