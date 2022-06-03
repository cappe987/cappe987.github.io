#!/bin/sh

docker run -p 4000:4000 -v $(pwd):/site bretfisher/jekyll-serve bundle exec jekyll serve --unpublished --host=0.0.0.0 $@
