#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`
wordlistfile=$(realpath $basedir/wordlist.aspell)
branch="origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-preview}"
files_to_skip=(doc.zih.tu-dresden.de/docs/accessibility.md doc.zih.tu-dresden.de/docs/data_protection_declaration.md data_protection_declaration.md)
aspellmode=
if aspell dump modes | grep -q markdown; then
  aspellmode="--mode=markdown"
fi

function usage() {
  cat <<-EOF
usage: $0 [file | -a]
If file is given, outputs all words of the file, that the spell checker cannot recognize.
If parameter -a (or --all) is given instead of the file, checks all markdown files.
Otherwise, checks whether any changed file contains more unrecognizable words than before the change.
If you are sure a word is correct, you can put it in $wordlistfile.
EOF
}

function getAspellOutput(){
  aspell -p "$wordlistfile" --ignore 2 -l en_US $aspellmode list | sort -u
}

function getNumberOfAspellOutputLines(){
  getAspellOutput | wc -l
}

function isWordlistSorted(){
  #Unfortunately, sort depends on locale and docker does not provide much.
  #Therefore, it uses bytewise comparison. We avoid problems with the command tr.
  if sed 1d "$wordlistfile" | tr [:upper:] [:lower:] | sort -C; then
    return 1
  fi
  return 0
}

function shouldSkipFile(){
  printf '%s\n' "${files_to_skip[@]}" | grep -xq $1
}

function checkAllFiles(){
  any_fails=false

  if isWordlistSorted; then
    echo "Unsorted wordlist in $wordlistfile"
    any_fails=true
  fi

  files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/ | grep .md)
  while read file; do
    if [ "${file: -3}" == ".md" ]; then
      if shouldSkipFile ${file}; then
        echo "Skip $file"
      else
        echo "Check $file"
        echo "-- File $file"
        if { cat "$file" | getAspellOutput | tee /dev/fd/3 | grep -xq '.*'; } 3>&1; then
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

function isMistakeCountIncreasedByChanges(){
  any_fails=false

  if isWordlistSorted; then
    echo "Unsorted wordlist in $wordlistfile"
    any_fails=true
  fi

  source_hash=`git merge-base HEAD "$branch"`
  #Remove everything except lines beginning with --- or +++
  files=`git diff $source_hash | sed -E -n 's#^(---|\+\+\+) ((/|./)[^[:space:]]+)$#\2#p'`
  #echo "$files"
  #echo "-------------------------"
  #Assume that we have pairs of lines (starting with --- and +++).
  while read oldfile; do
    read newfile
    if [ "${newfile: -3}" == ".md" ]; then
      if shouldSkipFile ${newfile:2}; then
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
          echo "Change increases spelling mistake count (from $previous_count to $current_count), misspelled/unknown words:"
          cat "$newfile" | getAspellOutput
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
  -a | --all)
    checkAllFiles
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
