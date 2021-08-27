#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`
wordlistfile=$(realpath $basedir/wordlist.aspell)
branch="origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-preview}"

function usage() {
  cat <<-EOF
usage: $0 [file]
If file is given, outputs all words of the file, that the spell checker cannot recognize.
If file is omitted, checks whether any changed file contains more unrecognizable words than before the change.
If you are sure a word is correct, you can put it in $wordlistfile.
EOF
}

function getAspellOutput(){
  aspell -p "$wordlistfile" --ignore 2 -l en_US --mode=markdown list | sort -u
}

function getNumberOfAspellOutputLines(){
  getAspellOutput | wc -l
}

function isMistakeCountIncreasedByChanges(){
  any_fails=false

  source_hash=`git merge-base HEAD "$branch"`
  #Remove everything except lines beginning with --- or +++
  files=`git diff $source_hash | sed -n 's#^[-+]\{3,3\} \(\(/\|./\)[^[:space:]]\+\)$#\1#p'`
  #echo "$files"
  #echo "-------------------------"
  #Assume that we have pairs of lines (starting with --- and +++).
  while read oldfile; do
    read newfile
    if [ "${newfile: -3}" == ".md" ]; then
      if [[ $newfile == *"accessibility.md"* ||
            $newfile == *"data_protection_declaration.md"* ||
            $newfile == *"legal_notice.md"* ]]; then
        echo "Skip $newfile"
      else
        echo "Check $newfile"
        if [ "$oldfile" == "/dev/null" ]; then
          #Added files should not introduce new spelling mistakes
          previous_count=0
        else
          previous_count=`git show "$source_hash:${oldfile:2}" | getNumberOfAspellOutputLines`
        fi
        if [ "$newfile" == "/dev/null" ]; then
          #Deleted files do not contain any spelling mistakes
          current_count=0
        else
          #Remove the prefix "b/"
          newfile=${newfile:2}
          current_count=`cat "$newfile" | getNumberOfAspellOutputLines`
        fi
        if [ $current_count -gt $previous_count ]; then
          echo "-- File $newfile"
          echo "Change increases spelling mistake count (from $previous_count to $current_count)"
          any_fails=true
        fi
      fi
    fi
  done <<< "$files"

  if [ "$any_fails" == true ]; then
    return 1
  fi
  return 0
}

if [ $# -eq 1 ]; then
  case $1 in
  help | -help | --help)
    usage
    exit
  ;;
  *)
    cat "$1" | getAspellOutput
  ;;
  esac
elif [ $# -eq 0 ]; then
  isMistakeCountIncreasedByChanges
else
  usage
fi
