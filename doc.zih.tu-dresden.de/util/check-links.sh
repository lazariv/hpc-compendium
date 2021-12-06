#!/bin/bash
## Purpose:
##   Checks internal links for all (git-)changed markdown files (.md) of the repository.
##   We use the markdown-link-check script from https://github.com/tcort/markdown-link-check,
##   which can either be installed as local or global module
##   nmp npm install [--save-dev|-g] markdown-link-check
##   module.
##
## Author: Martin.Schroschk@tu-dresden.de

set -eo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`

usage() {
  cat <<-EOF
usage: $0 [file | -a]
If file is given, checks whether all links in it are reachable.
If parameter -a (or --all) is given instead of the file, checks all markdown files.
Otherwise, checks whether any changed file contains broken links.
EOF
}

mlc=markdown-link-check
if ! command -v $mlc &> /dev/null; then
  echo "INFO: $mlc not found in PATH (global module)"
  mlc=./node_modules/markdown-link-check/$mlc
  if ! command -v $mlc &> /dev/null; then
    echo "INFO: $mlc not found (local module)"
    exit 1
  fi
fi

echo "mlc: $mlc"

LINK_CHECK_CONFIG="$basedir/util/link-check-config.json"
if [ ! -f "$LINK_CHECK_CONFIG" ]; then
  echo $LINK_CHECK_CONFIG does not exist
  exit 1
fi

branch="preview"
if [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    branch="origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
fi

function checkSingleFile(){
  theFile="$1"
  if [ -e "$theFile" ]; then
    echo "Checking links in $theFile"
    if ! $mlc -q -c "$LINK_CHECK_CONFIG" -p "$theFile"; then
      return 1
    fi
  fi
  return 0
}

function checkFiles(){
any_fails=false
echo "Check files:"
echo "$files"
echo ""
for f in $files; do
  if ! checkSingleFile "$f"; then
    any_fails=true
  fi
done

if [ "$any_fails" == true ]; then
    exit 1
fi
}

function checkAllFiles(){
files=$(git ls-tree --full-tree -r --name-only HEAD $basedir/ | grep '.md$' || true)
checkFiles
}

function checkChangedFiles(){
files=$(git diff --name-only "$(git merge-base HEAD "$branch")" | grep '.md$' || true)
checkFiles
}

if [ $# -eq 1 ]; then
  case $1 in
  help | -help | --help)
    usage
    exit
  ;;
  -a | --all)
    checkAllFiles
  ;;
  *)
    checkSingleFile "$1"
  ;;
  esac
elif [ $# -eq 0 ]; then
  checkChangedFiles
else
  usage
fi
