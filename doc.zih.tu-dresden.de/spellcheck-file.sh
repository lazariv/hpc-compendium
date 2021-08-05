#!/bin/bash
export LANG=C
cat $1 | aspell -p ./wordlist.aspell list | sort -u
