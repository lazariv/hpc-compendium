#!/bin/bash

set -euo pipefail

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

any_fails=false

files=$(git diff --name-only "$(git merge-base HEAD "$branch")")
for f in $files; do
    if [ "${f: -3}" == ".md" ]; then
        #The following checks assume that grep signals success when it finds something,
        #while it signals failure if it doesn't find something.
        #We assume that we are successful if we DON'T find the pattern,
        #which is the other way around, hence the "!".

        echo "Checking wording of $f: IO"
        #io must be the whole word
        if ! grep -n -i '\<io\>' "$f"; then
            any_fails=true
        fi
        echo "Checking wording of $f: SLURM"
        #SLURM must be the whole word, otherwise it might match script variables
        #such as SLURM_JOB_ID
        if ! grep -n '\<SLURM\>' "$f"; then
            any_fails=true
        fi
        echo "Checking wording of $f: file system"
        #arbitrary white space in between
        if ! grep -n -i 'file \+system' "$f"; then
            any_fails=true
        fi
        echo "Checking wording of $f: taurus"
        if ! grep -n -i '\<taurus\>' "$f" | grep -v 'taurus\.hrsk' | grep -v '/taurus'; then
            any_fails=true
        fi
    fi
done

if [ "$any_fails" == true ]; then
    exit 1
fi
