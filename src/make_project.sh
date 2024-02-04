#!/bin/bash

# 
# 初回のみ実行 init.sh でコンテナ外からキックされる
# create project でのフォルダと
# apache confでの設定を合わせるためプロジェクト名を app にしている
cd /var/www/laravel && composer create-project laravel/laravel app