#!/bin/bash

ogmmm_folder=~/.minetest/ogmmm

function dltrunk() {
	local t=(`echo "$1"|sed 's/\//\n/g'`)
	local turl=( "$1/trunk" "${t[3]}" )
	local todir="$ogmmm_folder/${t[2]}"
	mkdir -p "$todir"
	cd "$todir"
	echo "downloading $1..."
	svn co "${turl[@]}"
}

for var in "$@";do
    dltrunk "$var"
done
