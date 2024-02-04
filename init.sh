#!/bin/bash

# 初回のみ実行
# create project をコンテナ内で実行する
docker exec app /var/www/laravel/make_project.sh