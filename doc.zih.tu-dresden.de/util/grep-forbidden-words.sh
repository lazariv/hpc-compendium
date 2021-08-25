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

function grepExceptions(){
if [ $# -gt 0 ]; then
firstPattern=$1
shift
grep -v "$firstPattern" | grepExceptions "$@"
else
cat -
fi
}

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

any_fails=false

files=$(git diff --name-only "$(git merge-base HEAD "$branch")" | grep '.md$' | grep -v '^doc.zih.tu-dresden.de/README.md$')
for f in $files; do
    while IFS=$'\t' read -r flags pattern exceptionPatterns; do
        while IFS=$'\t' read -r -a exceptionPatternsArray; do
            echo "Checking wording of $f: $pattern"
            case "$flags" in
                "i")
                    if grep -n -i "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" ; then
                        any_fails=true
                    fi
                ;;
                "s")
                    if grep -n "$pattern" "$f" | grepExceptions "${exceptionPatternsArray[@]}" ; then
                        any_fails=true
                    fi
                ;;
            esac
        done <<< $exceptionPatterns
    done <<< $ruleset
done

if [ "$any_fails" == true ]; then
    exit 1
fi
