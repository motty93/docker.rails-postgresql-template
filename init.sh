#!/bin/bash

echo "rails new"
docker-compose run web rails _5.2.4_ new . --skip --database=postgresql \
  --skip-git --skip-bundle --skip-turbolinks --skip-coffee --skip-test

if [ "$(uname)" == 'Linux' ]; then
  echo "Linux chown all file"
  sudo chown -R $USER:$USER *
fi

echo "force files checkout"
git checkout README.md .gitignore

echo "fig build"
docker-compose build

if [ "$(uname)" == 'Linux' ]; then
  echo "Linux chown all file"
  sudo chown -R $USER:$USER *
fi

echo "bundle install"
docker-compose run web bundle install --path=vendor/bundle

echo "copy env setting"
cp ./init/env_sample ./.env

echo "copy database.yml"
\cp -f ./init/init_database.yml ./config/database.yml

echo "db create & migrate"
docker-compose run web rails db:create
docker-compose run web rails db:migrate

echo "fig up"
docker-compose up
