#!/bin/bash
export LANG=C
for i in `find -name \*.md`
do
cat $i | aspell -p ./wordlist.aspell list
done | sort -u
