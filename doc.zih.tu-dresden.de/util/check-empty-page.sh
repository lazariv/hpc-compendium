#!/bin/bash

set -euo pipefail

scriptpath=${BASH_SOURCE[0]}
basedir=`dirname "$scriptpath"`
basedir=`dirname "$basedir"`

if find $basedir -name \*.md -exec wc -l {} \; | grep '^0 '; then
  exit 1
fi
