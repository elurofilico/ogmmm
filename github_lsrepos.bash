#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Se necesita el nombre del dueño del repositorio..."
  exit 1
fi

fullrepos=()
owner="$1"
pages=10000
npage=1

oIFS=$IFS
IFS=$'\n'

while [ $npage -le $pages ]; do
  wdata=`wget -q -O - "https://github.com/${owner}?tab=repositories&page=${npage}"`
  if [ $pages -eq 10000 ]; then
    pages=`echo "?page=1"$'\n'"${wdata}" | grep -Eo '\?page=[0-9]+' | \
             sed 's/\?page=//g' | sort -u | tail -n1`
  fi

  repos=`echo "${wdata}" | \
         sed 's/>/>\n/g' | \
         grep -E "href=\"\/${owner}" | \
         grep -vE 'title=|class=' | \
         sed 's/"/\n/g' | \
         grep -E '^\/' | \
         cut -d\/ -f3`

  fullrepos=( "${fullrepos[@]}" `echo "$repos"` )

  npage=$((npage+1))
done

for repo in "${fullrepos[@]}"; do
  echo "${repo}"
done

IFS=$oIFS
