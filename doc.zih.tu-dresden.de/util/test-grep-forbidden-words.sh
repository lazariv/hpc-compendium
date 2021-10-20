#!/bin/bash

number_of_matches=$(bash ./doc.zih.tu-dresden.de/util/grep-forbidden-words.sh -f doc.zih.tu-dresden.de/util/grep-forbidden-words-testdoc.md -c -c | grep "Forbidden Patterns:" | sed -e 's/.*: //' | sed -e 's/ matches.*//')

if [ $number_of_matches -eq 32 ]; then
	echo "Test OK"
	exit 0
else
	echo "Test failed"
	exit 1
fi
