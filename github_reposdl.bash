#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Se necesita el nombre del dueño del repositorio..."
  exit 1
fi

fullrepos=()
owner="$1"
pages=10000
npage=1
while [ $npage -le $pages ]; do
  wdata=`wget -q -O - "https://github.com/${owner}?page=${npage}"`
  if [ $pages -eq 10000 ]; then
    pages=`echo "${wdata}" | grep -Eo '\?page=[0-9]+' | \
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
# grep -Eo '\?page=[0-9]+'|sort -u
echo "${repos[@]}"

exit 0

oIFS=$IFS
IFS=$'\n'

for repo in $repos; do
  echo "bajando ${repo} de ${owner}..."
  mkdir -p "${owner}/${repo}"
  echo -e "https://github.com/${owner}/${repo}\n" > "${owner}/${repo}/urls.txt"
  if [ ! -e "${owner}/${repo}/${repo}-master.zip" ]; then
    wget -q -O "${owner}/${repo}/${repo}-master.zip" "https://github.com/${owner}/${repo}/archive/master.zip"
  fi
done

echo -e "https://github.com/${owner}\n" > "${owner}/urls.txt" 

IFS=$oIFS
