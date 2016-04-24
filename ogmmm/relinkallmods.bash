#!/bin/bash

. config

cd $datafolder

find . -type l -exec sh -c "file -b {} | grep -q ^broken" \; -print | \
    xargs -I {} rm -rf {}

owners=( `find . -mindepth 1 -maxdepth 1 -type d -exec basename {} \;` )

cd $og3mfolder

./linkmods.bash "${owners[@]}"
