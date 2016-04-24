#!/bin/bash

. config

function linkmods() {

  if [ $# -ne 1 ]; then
    echo "Se necesita el nombre del dueño del repositorio..."
    return 1
  fi
  local ofolder=$datafolder/$1
  if [ ! -d $ofolder ]; then
    echo "No existe repo '$1'."
    return 1
  fi

  cd $ofolder

  mods=( `find . -maxdepth 2 -type f -name init.lua -or -name modpack.txt |xargs -I {} readlink -f {}|xargs -I {} dirname {}` )

  for mod in "${mods[@]}"; do

    echo "Vinculando `basename "$mod"`..."
    ln -f -s -t $modsfolder "$mod"

  done
  return 0
}

for var in "$@";do
    linkmods "$var"
done
