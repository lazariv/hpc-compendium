#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`

#This is the ruleset. Each line represents a rule of tab-separated fields.
#The first field represents whether the match should be case-sensitive (s) or insensitive (i).
#The second field represents the pattern that should not be contained in any file that is checked.
#Further fields represent patterns with exceptions.
#For example, the first rule says:
# The pattern \<io\> should not be present in any file (case-insensitive match), except when it appears as ".io".
ruleset="i	\<io\>	\.io
s	\<SLURM\>
i	file \+system	HDFS
i	\<taurus\>	taurus\.hrsk	/taurus	/TAURUS
i	\<hrskii\>
i	hpc[ -]\+da\>
i	attachurl
i	\<todo\>	<!--.*todo.*-->
i	[[:space:]]$
i	\(alpha\|ml\|haswell\|romeo\|gpu\|smp\|julia\|hpdlf\|scs5\)-\?\(interactive\)\?[^a-z]*partition
i	\[\s\?\(documentation\|here\|this \(link\|page\|subsection\)\|slides\?\|manpage\)\s\?\]
i	work[ -]\+space"

# Whitelisted files will be ignored
# Whitespace separated list with full path
whitelist=(doc.zih.tu-dresden.de/README.md doc.zih.tu-dresden.de/docs/contrib/content_rules.md doc.zih.tu-dresden.de/docs/access/ssh_login.md)

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
  echo "  -f     Search in a specific markdown file" 
  echo "  -s     Silent mode"
  echo "  -h     Show help message"
  echo "  -c     Show git matches in color"
}

# Options
all_files=false
silent=false
file=""
color=""
while getopts ":ahsf:c" option; do
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
   c)
     color=" --color=always "
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
  echo "Search in all markdown files."
  files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/docs/ | grep .md)
elif [[ ! -z $file ]]; then
  files=$file
else
  echo "Search in git-changed files."
  files=`git diff --name-only "$(git merge-base HEAD "$branch")"`
fi

echo "... $files ..."
cnt=0
for f in $files; do
  if [ "${f: -3}" == ".md" -a -f "$f" ]; then
    if (printf '%s\n' "${whitelist[@]}" | grep -xq $f); then
      echo "Skip whitelisted file $f"
      continue
    fi
    echo "Check wording in file $f"
    while IFS=$'\t' read -r flags pattern exceptionPatterns; do
      while IFS=$'\t' read -r -a exceptionPatternsArray; do
        if [ $silent = false ]; then
          echo "  Pattern: $pattern"
        fi
        grepflag=
        case "$flags" in
          "i")
            grepflag=-i
          ;;
        esac
        if grep -n $grepflag $color "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" ; then
	  number_of_matches=`grep -n $grepflag $color "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" | wc -l`
          ((cnt=cnt+$number_of_matches))
        fi
      done <<< $exceptionPatterns
    done <<< $ruleset
  fi
done

echo "" 
case $cnt in
  1)
    echo "Forbidden Patterns: 1 match found"
  ;;
  *)
    echo "Forbidden Patterns: $cnt matches found"
  ;;
esac
if [ $cnt -gt 0 ]; then
  exit 1
fi
