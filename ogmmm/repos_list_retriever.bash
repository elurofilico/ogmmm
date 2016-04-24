#!/bin/bash

. config
 
function list_retrieving() {
  local owner=`basename "$1"`
  local list=`$og3mfolder/github_lsrepos.bash $owner`
  echo "$list" > $datafolder/$owner.temp
  local filtered=`echo "$list"|grep -E "$2"`
  local line
  for line in `echo "$filtered"`; do
    echo "https://github.com/$owner/$line"
  done
}

for line in `cat "$og3mfolder/repos.list"`; do
  descriptor=`echo "$line"|cut -f5 -d'/'`
  baserepo=`echo "$line"|cut -f1-4 -d'/'`
  echo "$descriptor" | grep -Pq '[\*\.\$\^\[\]\(\)\|]'
  if [ $? -eq 0 ]; then
    list_retrieving "$baserepo" "$descriptor"
  else
    echo "$line"
  fi
done
