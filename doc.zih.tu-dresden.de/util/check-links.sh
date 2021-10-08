#!/bin/bash
## Purpose:
##   Checks internal links for all (git-)changed markdown files (.md) of the repository.
##   We use the markdown-link-check script from https://github.com/tcort/markdown-link-check,
##   which can either be installed as local or global module
##   nmp npm install [--save-dev|-g] markdown-link-check
##   module.
##
## Author: Martin.Schroschk@tu-dresden.de

set -euo pipefail

usage() {
  echo "Usage: bash $0"
}

# Any arguments?
if [ $# -gt 0 ]; then
  usage
  exit 1
fi

mlc=markdown-link-check
if ! command -v $mlc &> /dev/null; then
  echo "INFO: $mlc not found in PATH (global module)"
  mlc=./node_modules/markdown-link-check/$mlc
  if ! command -v $mlc &> /dev/null; then
    echo "INFO: $mlc not found (local module)"
    echo "INFO: See CONTRIBUTE.md for information."
    echo "INFO: Abort."
    exit 1
  fi
fi

echo "mlc: $mlc"

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

any_fails=false

files=$(git diff --name-only "$(git merge-base HEAD "$branch")")
echo "Check files:"
echo "$files"
echo ""
for f in $files; do
  if [ "${f: -3}" == ".md" ]; then
    # do not check links for deleted files
    if [ -e $f ]; then
      echo "Checking links for $f"
      if ! $mlc -q -p "$f"; then
        any_fails=true
      fi
    fi
  fi
done

if [ "$any_fails" == true ]; then
    exit 1
fi
