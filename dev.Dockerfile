ARG ELIXIR=1.14.3
ARG OTP_VERSION=25.3
ARG DEBIAN_VERSION=bullseye-20210902-slim

ARG BUILDER_IMAGE="hexpm/elixir:1.14.0-erlang-25.0.3-debian-bullseye-20210902-slim"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

# update and install important packages suck as git, npm, curl, build-essential
RUN apt-get update -y && apt-get install -y build-essential git nodejs npm curl \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# install node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs

RUN mkdir -p /app
WORKDIR /app

# copy app files
COPY rel /app/rel
COPY mix.exs mix.lock /app/
COPY assets/ /app/assets
COPY config/ /app/config
COPY apps/ /app/apps

ENV MIX_ENV=dev

# install hex + rebar + deps
RUN mix local.rebar --force \
  && mix local.hex --force \
  && mix deps.get \
  && mix deps.compile


RUN MIX_ENV=${MIX_ENV} mix release

##########################################

FROM ${RUNNER_IMAGE}

EXPOSE 4000

ARG APP_NAME=game_critic_umbrella

RUN apt-get update -y && apt-get install -y libstdc++6 openssl inotify-tools libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

ENV PORT=4000 \
    MIX_ENV=dev \
    SHELL=/bin/bash

WORKDIR "/app"

# USER nobody:nobody
# RUN chown nobody:nobody /app

COPY --from=builder /app/_build/${MIX_ENV}/rel/${APP_NAME} .
# COPY --from=builder --chown=nobody:nobody /app/_build/${MIX_ENV}/rel/${APP_NAME} .

ENV HOME=/app

CMD ["bin/game_critic_umbrella", "start"]
