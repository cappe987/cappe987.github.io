#!/bin/bash

ignore_list="README.md _config.yml Gemfile Gemfile.lock jekyll-clean-dark.gemspec publish.sh run.sh"


rm -r /var/www/casan.se/*
cp -r _site/* /var/www/casan.se

for file in $ignore_list
do
	rm "/var/www/casan.se/$file"
done

