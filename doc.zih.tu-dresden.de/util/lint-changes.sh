#!/bin/bash

set -euo pipefail

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

configfile=$(dirname $0)/../.markdownlintrc
echo "config: $configfile"

any_fails=false

files=$(git diff --name-only "$(git merge-base HEAD "$branch")")
for f in $files; do
    if [ "${f: -3}" == ".md" ]; then
        echo "Linting $f"
        if ! markdownlint -c $configfile "$f"; then
            any_fails=true
        fi
    fi
done

if [ "$any_fails" == true ]; then
    exit 1
fi
