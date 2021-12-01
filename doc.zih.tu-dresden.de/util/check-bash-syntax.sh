#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`

function usage () {
  echo "$0 [options]"
  echo "Search for bash files that have an invalid syntax."
  echo ""
  echo "Options:"
  echo "  -a           Search in all bash files (default: git-changed files)" 
  echo "  -f=FILE      Search in a specific bash file" 
  echo "  -s           Silent mode"
  echo "  -h           Show help message"
}

# Options
all_files=false
silent=false
file=""
while getopts ":ahsf:" option; do
 case $option in
   a)
     all_files=true
     ;;
   f)
     file=$2
     shift
     ;;
   s)
     silent=true
     ;;
   h)
     usage
     exit;;
   \?) # Invalid option
     echo "Error: Invalid option."
     usage
     exit;;
 esac
done

branch="origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-preview}"

if [ $all_files = true ]; then
  echo "Search in all bash files."
  files=`git ls-tree --full-tree -r --name-only HEAD $basedir/docs/ | grep '\.sh$' || true`
elif [[ ! -z $file ]]; then
  files=$file
else
  echo "Search in git-changed files."
  files=`git diff --name-only "$(git merge-base HEAD "$branch")" | grep '\.sh$' || true`
fi


cnt=0
for f in $files; do
  if ! bash -n $f; then
    if [ $silent = false ]; then
      echo "Bash file $f has invalid syntax"
    fi
    ((cnt=cnt+1))
  fi
done

case $cnt in
  1)
    echo "Bash files with invalid syntax: 1 match found"
  ;;
  *)
    echo "Bash files with invalid syntax: $cnt matches found"
  ;;
esac
if [ $cnt -gt 0 ]; then
  exit 1
fi
