#!/usr/bin/env bash

laravel5Build() {
  . .env

  ENV_NAME="production"
  if [ "${SITE_ENV}" != "prod" ];then
    ENV_NAME="dev"
  fi;

  # Assets.
  wex site/exec -l -c="npm run ${ENV_NAME}"
}