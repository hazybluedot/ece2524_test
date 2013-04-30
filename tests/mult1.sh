#!/bin/bash

status="0"
branch="$1"
date="$2"

echo "checking out commit no later than $date to $branch"
switch_to_review_branch "$date" "$branch"

if [ "$branch" != $(git symbolic-ref --short HEAD) ]; then
    echo "Branch mismatch: $branch" >&2
    exit 1
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
    local l="$1"
    g++ -Wall -std=c++11 -g -c mult.cc >dkm_review/mult.cc.g++.stdout 2>dkm_review/mult.cc.g++.stderr
    g++ -Wall -std=c++11 -g -o mult mult.o $l >>dkm_review/mult.cc.g++.stdout 2>>dkm_review/mult.cc.g++.stderr
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
    require 'mult.sh' && echo $(realpath "./mult.sh") | \
	progtest.sh "${refpath}/mult.sh" "$inputpath" >dkm_review/mult.sh.tests || \
	echo "errors running tests on mult.sh" >&2

}

do_py_tests() {
    local refpath="$1"
    local inputpath="$2"
    require 'mult.py' && echo $(realpath "./mult.py") | \
	progtest.sh "${refpath}/mult.py" "$inputpath" >dkm_review/mult.py.tests || \
	echo "errors running tests on mult.py" >&2
}

do_cc_tests() {
    local refpath="$1"
    local inputpath="$2"
    require 'mult.cc' && compile '-lboost_program_options' && echo $(realpath "./mult") | \
	progtest.sh "${refpath}/mult" "$inputpath" >dkm_review/mult.cc.tests || \
	echo "errors running tests on mult.cc" >&2
}

part3() {
    local refpath="$1"
    local inputpath="$2"
    gituser=$(echo $(pwd) | sed -r 's|.*assignments/(\w+)/mult|\1|')
    realname=$(gitrealname $gituser $HOME/ece2524/repos/gitusers $HOME/ece2524/current/roster.csv | cut -d '(' -f 1)
    group=$(echo $(grep "$realname" $HOME/ece2524/repos/groups | cut -d ':' -f 2))
    git ls-files mult --error-unmatch 2>/dev/null && ( echo "Do not track binary/compiled files with git" > dkm_review/general.errors; git rm mult 2>/dev/null )
    if [ -z "$group" ]; then
	echo "Could not deduce group for $realname ($gituser)" >&2
	exit 1
    fi
    case $group in
	group1)
	    do_sh_tests "$refpath" "$inputpath" ;;
	group2)
	    do_py_tests "$refpath" "$inputpath" ;;
	group3) 
	    do_cc_tests "$refpath" "$inputpath" ;;
	*)
	    echo "$group: invalid group" >> dkm_review/general.errors
    esac
}

# check that expected files are present and readable

mkdir -p dkm_review
rm -f dkm_review/mult.*.* 
rm -f dkm_review/diffs/*
rm -f dkm_review/test.errors
rm -f dkm_review/general.errors

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

$HOME/ece2524/tests/mult.summarize

echo "adding/commiting $branch in $(pwd)"
git add dkm_review/
git commit -m "tests run on $(date)" >/dev/null

exit "$status"
