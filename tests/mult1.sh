#!/bin/bash

status="0"
script_path=$(realpath ".")
if [ -d "$1" ]; then
    script_path=$(realpath "$1")
fi

require() {
    require_status="0"
    for file in "$@"; do
        if [ ! -r "$file" ]; then
	    echo "$file: file not found or not readable" >>dkm_review/test.errors
	    require_status=`expr $require_status + 1`
	fi
    done
    return "$require_status"
}

compile() {
    g++ -Wall -g -c mult.cc >dkm_review/mult.cc.g++.stdout 2>dkm_review/mult.cc.g++.stderr
    g++ -Wall -g -o mult mult.o -lboost_program_options >>dkm_review/mult.cc.g++.stdout 2>>dkm_review/mult.cc.g++.stderr
}

dotests() {
    local refpath="$1"
    local inputpath="$2"
    do_sh_tests "$refpath" "$inputpath"
    do_py_tests "$refpath" "$inputpath"
    do_cc_tests "$refpath" "$inputpath"
}

do_sh_tests() {
    local refpath="$1"
    local inputpath="$2"
    require 'mult.sh' && echo $(realpath "./mult.sh") | progtest.sh "${refpath}/mult.sh" "$inputpath" >dkm_review/mult.sh.tests
}

do_py_tests() {
    local refpath="$1"
    local inputpath="$2"
    require 'mult.py' && echo $(realpath "./mult.py") | progtest.sh "${refpath}/mult.py" "$inputpath" >dkm_review/mult.py.tests
}

do_cc_tests() {
    local refpath="$1"
    local inputpath="$2"
    require 'mult.cc' && compile && echo $(realpath "./mult") | progtest.sh "${refpath}/mult" "$inputpath" >dkm_review/mult.cc.tests
}

part3() {
    local refpath="$1"
    local inputpath="$2"
    git ls-files mult --error-unmatch 2>/dev/null && ( echo "Do not track binary/compiled files with git" > dkm_review/general.errors; git rm mult 2>/dev/null )
    case $(ls group[0-9] 2>/dev/null) in
	group1)
	    do_sh_tests "$refpath" "$inputpath" ;;
	group2)
	    do_py_tests "$refpath" "$inputpath" ;;
	group3) 
	    do_cc_tests "$refpath" "$inputpath" ;;
	*)
	    echo "No group file found" >> dkm_review/general.errors
    esac
}

# check that expected files are present and readable
pushd .
cd ${script_path}

mkdir -p dkm_review
rm -f dkm_review/mult.*.* 
rm -f dkm_review/diffs/*
rm -f dkm_review/test.errors
rm -f dkm_review/general.errors

branch=$(git symbolic-ref --short HEAD)
case $branch in
    dkm_review_part1)
	dotests "$HOME/ece2524/solutions/mult1" "$HOME/ece2524/tests/mult1"
	;;
    dkm_review_part2)
	dotests "$HOME/ece2524/solutions/mult2" "$HOME/ece2524/tests/mult2"
	;;
    dkm_review_part3)
	part3 "$HOME/ece2524/solutions/mult3" "$HOME/ece2524/tests/mult3"
	;;
    dkm_review_makefile)
	rm -f *.o mult
	make >dkm_review/make.stdout 2>dkm_review/make.stderr
	make clean >dkm_review/make.clean.stdout 2>dkm_review/make.clean.stderr
	;;
    *)
	echo "$branch: unknown branch" >&2
	;;
esac

rm -f *.o *.d
rm -f mult

popd

exit "$status"
