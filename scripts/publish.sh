#!/bin/bash



if [ "$1" != "--nobuild" ]; then
	if ! bundle exec jekyll build; then
		exit $?
	fi
fi

rm -r /var/www/casan.se/*
cp -r _site/* /var/www/casan.se

./scripts/remove_extra.sh /var/www/casan.se
