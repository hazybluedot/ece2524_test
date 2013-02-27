#!/bin/bash

status="0"
solution_path="$HOME/ece2524/solutions/mult"

function require() {
    require_status="0"
    for file in "$@"; do
        if [ ! -r "$file" ]; then
	    echo "$file not found or not readable" >&2
	    require_status=1
	fi
    done
    return "$require_status"
}

function runtests() {
    for file in "$@"; do
	solution_script="$solution_path/$file"
	if [ -x "$solution_script" ]; then
	    $solution_script < $input > $ref_stdout 2> $ref_stderr
	    ref_status="$?"
	    $file < $input >$test_stdout 2>$test_stderr
	    test_status="$?"
	fi
    done
}

# check that expected files are present and readable
require 'mult.sh' 'mult.py' 'mult.cc'
status="$?"

runtests 'mult.sh' 'mult.py' 'mult.cc'

exit "$status"
