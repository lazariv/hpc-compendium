#!/bin/bash

set -euo pipefail

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

any_fails=false

files=$(git diff $branch --name-only)
for f in $files; do
    if [ "${f: -3}" == ".md" ]; then
        echo "Linting $f"
        if ! markdownlint "$f"; then
            any_fails=true
        fi
    fi
done

if [ "$any_fails" == true ]; then
    exit 1
fi
