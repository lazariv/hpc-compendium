#!/bin/bash

expected_match_count=32

number_of_matches=$(bash ./doc.zih.tu-dresden.de/util/grep-forbidden-patterns.sh -f doc.zih.tu-dresden.de/util/grep-forbidden-patterns.testdoc -c -c | grep "Forbidden Patterns:" | sed -e 's/.*: //' | sed -e 's/ matches.*//')

if [ $number_of_matches -eq $expected_match_count ]; then
	echo "Test OK"
	exit 0
else
	echo "Test failed: $expected_match_count matches expected, but only $number_of_matches found"
	exit 1
fi
