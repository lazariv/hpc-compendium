#!/bin/bash

set -euo pipefail

branch="${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-}"
if [ -z "$branch" ]; then
    branch="preview"
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
