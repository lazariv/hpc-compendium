#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`
forbiddenpatternsfile=$(realpath $basedir/forbidden.patterns)

#This is the ruleset. Each line represents a rule of tab-separated fields.
#The first field represents whether the match should be case-sensitive (s) or insensitive (i).
#The second field represents the pattern that should not be contained in any file that is checked.
#Further fields represent patterns with exceptions.
#For example, the first rule says:
# The pattern \<io\> should not be present in any file (case-insensitive match), except when it appears as ".io".
ruleset="i	\<io\>	\.io
s	\<SLURM\>
i	file \+system
i	\<taurus\>	taurus\.hrsk	/taurus
i	\<hrskii\>
i	hpc \+system
i	hpc[ -]\+da\>"

function grepExceptions () {
  if [ $# -gt 0 ]; then
    firstPattern=$1
    shift
    grep -v "$firstPattern" | grepExceptions "$@"
  else
    cat -
  fi
}

function usage () {
  echo "$0 [options]"
  echo "Search forbidden patterns in markdown files."
  echo ""
  echo "Options:"
  echo "  -a     Search in all markdown files (default: git-changed files)" 
  echo "  -s     Silent mode"
  echo "  -h     Show help message"
}

# Options
all_files=false
silent=false
while getopts ":ahs" option; do
 case $option in
   a)
     all_files=true
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

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

any_fails=false

if [ $all_files = true ]; then
  echo "Search in all markdown files."
  files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/docs/ | grep .md)
else
  echo "Search in git-changed files."
  files=`git diff --name-only "$(git merge-base HEAD "$branch")"`
fi

cnt=0
for f in $files; do
  if [ "$f" != doc.zih.tu-dresden.de/README.md -a "${f: -3}" == ".md" ]; then
    echo "Check wording in file $f"
    while IFS=$'\t' read -r flags pattern exceptionPatterns; do
      while IFS=$'\t' read -r -a exceptionPatternsArray; do
        if [ $silent = false ]; then
          echo "  $pattern"
        fi
        case "$flags" in
          "i")
            if grep -n -i "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" ; then
              ((cnt=cnt+1))
              any_fails=true
            fi
          ;;
          "s")
            if grep -n "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" ; then
              ((cnt=cnt+1))
              any_fails=true
            fi
          ;;
        esac
      done <<< $exceptionPatterns
    done <<< $ruleset
  fi
done

echo "" 
echo "Found Forbidden Patterns: $cnt"
if [ "$any_fails" == true ]; then
  exit 1
fi
