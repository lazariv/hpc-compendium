#!/bin/bash
## Purpose:
##   Checks internal links for all (git-)changed markdown files (.md) of the repository.
##   We use the markdown-link-check script from https://github.com/tcort/markdown-link-check,
##   which can either be installed as local or global module
##   nmp npm install [--save-dev|-g] markdown-link-check
##   module.
##
## Author: Martin.Schroschk@tu-dresden.de

usage() {
  echo "Usage: sh $0"
}

echo "$#"
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

any_fails=false

for f in $(git diff master --name-only); do
  if [ ${f: -3} == ".md" ]; then
	  $mlc -q -p $f
	if [ "$?" -ne 0 ]; then
	    any_fails=true
	fi
    fi
done

if [ "$any_fails" == true ]; then
    exit 1
fi
