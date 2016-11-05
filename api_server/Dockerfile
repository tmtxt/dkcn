FROM elixir:1.3.4
MAINTAINER TruongTX

RUN apt-get update
RUN apt-get install -y inotify-tools

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN mix local.hex --force

COPY . /usr/src/app
RUN mix deps.get

CMD mix phoenix.server
