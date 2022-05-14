#!/bin/bash



if [ "$1" != "--nobuild" ]; then
	if ! bundle exec jekyll build; then
		exit $?
	fi
fi

./scripts/remove_extra.sh _site

rm -r /var/www/casan.se/*
cp -r _site/* /var/www/casan.se
