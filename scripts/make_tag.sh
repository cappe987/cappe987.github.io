#!/bin/bash

tag=$1
file="tag/$tag.md"

if [ "$tag" = "" ]; then
	echo "Error: missing <tag> argument"
	echo "Use: make_tag <tag>"
fi


echo "---" > $file
echo "layout: tag_index" >> $file
echo "tag: $tag" >> $file 
echo "---" >> $file
