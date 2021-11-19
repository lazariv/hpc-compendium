#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`

#This is the ruleset. Each rule consists of a message (first line), a tab-separated list of files to skip (second line) and a pattern specification (third line).
#A pattern specification is a tab-separated list of fields:
#The first field represents whether the match should be case-sensitive (s) or insensitive (i).
#The second field represents the pattern that should not be contained in any file that is checked.
#Further fields represent patterns with exceptions.
#For example, the first rule says:
# The pattern \<io\> should not be present in any file (case-insensitive match), except when it appears as ".io".
ruleset="The word \"IO\" should not be used, use \"I/O\" instead.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\<io\>	\.io
\"SLURM\" (only capital letters) should not be used, use \"Slurm\" instead.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
s	\<SLURM\>
\"File system\" should be written as \"filesystem\", except when used as part of a proper name.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	file \+system	HDFS
Use \"ZIH systems\" or \"ZIH system\" instead of \"Taurus\". \"taurus\" is only allowed when used in ssh commands and other very specific situations.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\<taurus\>	taurus\.hrsk	/taurus	/TAURUS	ssh	^[0-9]\+:Host taurus$
\"HRSKII\" should be avoided, use \"ZIH system\" instead.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\<hrskii\>
The term \"HPC-DA\" should be avoided. Depending on the situation, use \"data analytics\" or similar.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	hpc[ -]\+da\>
\"ATTACHURL\" was a keyword in the old wiki, don't use it.

i	attachurl
Replace \"todo\" with real content.

i	\<todo\>	<!--.*todo.*-->
Replace \"Coming soon\" with real content.

i	\<coming soon\>
Avoid spaces at end of lines.

i	[[:space:]]$
When referencing partitions, put keyword \"partition\" in front of partition name, e. g. \"partition ml\", not \"ml partition\".
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\(alpha\|ml\|haswell\|romeo\|gpu\|smp\|julia\|hpdlf\|scs5\)-\?\(interactive\)\?[^a-z]*partition
Give hints in the link text. Words such as \"here\" or \"this link\" are meaningless.
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	\[\s\?\(documentation\|here\|this \(link\|page\|subsection\)\|slides\?\|manpage\)\s\?\]
Use \"workspace\" instead of \"work space\" or \"work-space\".
doc.zih.tu-dresden.de/docs/contrib/content_rules.md
i	work[ -]\+space"

function grepExceptions () {
  if [ $# -gt 0 ]; then
    firstPattern=$1
    shift
    grep -v "$firstPattern" | grepExceptions "$@"
  else
    cat -
  fi
}

function checkFile(){
  f=$1
  echo "Check wording in file $f"
  while read message; do
    IFS=$'\t' read -r -a files_to_skip
    skipping=""
    if (printf '%s\n' "${files_to_skip[@]}" | grep -xq $f); then
      skipping=" -- skipping"
    fi
    IFS=$'\t' read -r flags pattern exceptionPatterns
    while IFS=$'\t' read -r -a exceptionPatternsArray; do
      if [ $silent = false ]; then
        echo "  Pattern: $pattern$skipping"
      fi
      if [ -z "$skipping" ]; then
        grepflag=
        case "$flags" in
          "i")
            grepflag=-i
          ;;
        esac
        if grep -n $grepflag $color "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" ; then
          number_of_matches=`grep -n $grepflag $color "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" | wc -l`
          ((cnt=cnt+$number_of_matches))
          if [ $silent = false ]; then
            echo "    $message"
          fi
        fi
      fi
    done <<< $exceptionPatterns
  done <<< $ruleset
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
  files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/ | grep .md)
elif [[ ! -z $file ]]; then
  files=$file
else
  echo "Search in git-changed files."
  files=`git diff --name-only "$(git merge-base HEAD "$branch")"`
fi

echo "... $files ..."
cnt=0
if [[ ! -z $file ]]; then
  checkFile $file
else
  for f in $files; do
    if [ "${f: -3}" == ".md" -a -f "$f" ]; then
      checkFile $f
    fi
  done
fi

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
