#!/bin/bash

status="0"
if [ -d "$1" ]; then
    input_path=$(realpath "$1")
else
    input_path="$HOME/ece2524/tests/mult1"
fi
script_path=$(realpath ".")
if [ -d "$2" ]; then
    script_path=$(realpath "$2")
fi

function require() {
    require_status="0"
    for file in "$@"; do
        if [ ! -r "$file" ]; then
	    echo "$file: file not found or not readable" >>doc/test.errors
	    require_status=`expr $require_status + 1`
	fi
    done
    return "$require_status"
}

function runsingle() {
    solution_script="$1"; shift
    file="$1"; shift
    input_file="$1"; shift
    postfix="$(echo "$@" | sed -re 's/[-]/_/g' -e 's/ //g' )"
    
    stub=output/${file}_$(basename ${input_file})
    ref_stdout=${stub}${postfix}.stdout
    ref_stderr=${stub}${postfix}.stderr
    #echo "timeout -k 5 2 $(envrun $solution_script $@ 2>>doc/test.errors) < $input_file "
    timeout -k 5 2 $(envrun $solution_script $@ 2>>doc/test.errors) < $input_file > $ref_stdout 2> $ref_stderr
    status="$?"
    echo "$status" > ${stub}${postfix}.status
    if [ "$status" -eq 124 ]; then
	echo "(timed out)" >> ${stub}${postfix}.status
    fi
}

function runtests() {
    for file in "$@"; do
	solution_script="$script_path/$file"
	if [ -r "$solution_script" ]; then
	    for input_file in $input_path/input[0-9]; do
		if [ -r "$input_file".args ]; then
		    while read args; do 
			runsingle "$solution_script" "$file" "$input_file" $args
		    done < "$input_file".args
		else
		    runsingle "$solution_script" "$file" "$input_file"
		fi 
	    done
	fi
    done
}

# check that expected files are present and readable
pushd .
cd ${script_path}

mkdir -p output
mkdir -p doc

rm -rf output/*
rm -f doc/test.errors
rm -f doc/general.errors

require 'mult.sh' 'mult.py' 'mult.cc'
status="$?"


git ls-files mult --error-unmatch 2>/dev/null && ( echo "Do not track binary/compiled files with git" > doc/general.errors; git rm mult 2>/dev/null )

case $(ls group[0-9] 2>/dev/null) in
    group1)
	runtests 'mult.sh' ;;
    group2)
	runtests 'mult.py' ;;
    group3) 
	g++ -Wall -g -c mult.cc >output/mult.cc.g++.stdout 2>output/mult.cc.g++.stderr
	g++ -Wall -g -o mult mult.o -lboost_program_options >>output/mult.cc.g++.stdout 2>>output/mult.cc.g++.stderr
	runtests 'mult' ;;
    *)
	echo "No group[0-9] file found" >> doc/general.errors
	g++ -Wall -g -c mult.cc >output/mult.cc.g++.stdout 2>output/mult.cc.g++.stderr
	g++ -Wall -g -o mult mult.o -lboost_program_options >>output/mult.cc.g++.stdout 2>>output/mult.cc.g++.stderr
	runtests 'mult.sh' 'mult.py' 'mult'
esac
popd

exit "$status"
