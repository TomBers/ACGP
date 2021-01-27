FROM elixir:1.10.4-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs yarn python3 npm

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build assets
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
#COPY prod prod
RUN mix release

# prepare release image
FROM alpine:3.12 AS app
RUN apk add --update bash openssl

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/acgp ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

COPY entry.sh .

CMD ["./entry.sh"]