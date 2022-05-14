#/bin/sh

ignore_list="README.md _config.yml Gemfile Gemfile.lock jekyll-clean-dark.gemspec admin.html scripts .git .github .jekyll-cache"
path=$1

for file in $ignore_list
do
	rm -rf "$path/$file"
done
