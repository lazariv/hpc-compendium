#!/bin/bash

export LANG=C
acmd="aspell -p ./wordlist.aspell list --ignore 2 -d en_US"

function spell_check () {
  ret=$(cat $1 | $acmd)
  if [ ! -z "$ret" ]; then
    echo "-- File $i"
    echo "$ret" | sort -u
  fi
}

if [ $# -eq 1 ]; then
  spell_check $1
else
  for i in `find ../ -name \*.md`; do
  spell_check $i
  done
fi
