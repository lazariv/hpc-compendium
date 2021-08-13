#!/bin/bash

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`
wordlistfile=$basedir/wordlist.aspell
acmd="aspell -p $wordlistfile --ignore 2 -l en_US list"

function spell_check () {
  file_to_check=$1
  ret=$(cat "$file_to_check" | $acmd)
  if [ ! -z "$ret" ]; then
    echo "-- File $file_to_check"
    echo "$ret" | sort -u
  fi
}

function usage() {
  cat <<-EOF
usage: $0 [file]
Outputs all words of the file (or, if no argument given, all files in the current directory, recursively), that the spell checker cannot recognize.
If you are sure a word is correct, you can put it in $wordlistfile.
EOF
}

if [ $# -eq 1 ]; then
  case $1 in
  help | -help | --help)
    usage
    exit
  ;;
  *)
    spell_check $1
  ;;
  esac
elif [ $# -eq 0 ]; then
  for i in `find -name \*.md`; do
  spell_check $i
  done
else
  usage
fi
