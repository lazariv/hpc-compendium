#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`
wordlistfile=$basedir/wordlist.aspell

function getNumberOfAspellOutputLines(){
  cat - | aspell -p "$wordlistfile" --ignore 2 -l en_US list | sort -u | wc -l
}

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

any_fails=false

source_hash=`git merge-base HEAD "$branch"`
files=$(git diff --name-only "$source_hash")
for f in $files; do
    if [ "${f: -3}" == ".md" ]; then
        previous_count=`git show "$source_hash:$f" | getNumberOfAspellOutputLines`
        current_count=`cat "$f" | getNumberOfAspellOutputLines`
        if [ $current_count -gt $previous_count ]; then
            echo "-- File $f"
            echo "Change increases spelling mistake count (from $previous_count to $current_count)"
            any_fails=true
        fi
    fi
done

if [ "$any_fails" == true ]; then
    exit 1
fi
