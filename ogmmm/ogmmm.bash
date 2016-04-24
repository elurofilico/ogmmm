#!/bin/bash

. config

runfiles=( `basename $0` github_lsrepos.bash github_reposdl.bash )

runfolder=`pwd`

function dltrunk() {
	local t=(`echo "$1"|sed 's/\//\n/g'`)
	local turl=( "$1/trunk" "${t[3]}" )
	local todir="$datafolder/${t[2]}"
	mkdir -p "$todir"
	cd "$todir"
	echo "downloading $1..."
	svn co "${turl[@]}"
	cd "$datafolder"
}

mkdir -p "$modsfolder" "$og3mfolder" "$datafolder"

for f in "${runfiles[@]}"; do
  if [ ! -e ~/.minetest/ogmmm/$f ]; then
    cp "$f" ~/.minetest/ogmmm
  fi
done

repos=`$og3mfolder/repos_list_retriever.bash`

for repo in `echo "$repos"`; do

  repodata=(`echo "$repo"|sed 's/\//\n/g'`)
  owner="${repodata[2]}"
  repo="${repodata[3]}"

  repofolder="$datafolder/$owner"
  mkdir -p "$repofolder"
  cd "$repofolder"
  echo  "$repofolder"
  if [ -d $repo ]; then
    echo "updating github.com/${owner}/${repo}..."
    cd "$repo"
    svn up
  else
    echo "clone github.com/${owner}/${repo}..."
    svn co "https://github.com/${owner}/${repo}/trunk" "${repo}"
  fi
  cd "$datafolder"
done

exit 1

mods=( `find . -maxdepth 2 -type f -name init.lua -or -name modpack.txt |xargs -I {} readlink -f {}|xargs -I {} dirname {}` )

for mod in "${mods[@]}"; do

  basename "$mod"

done
