#!/bin/sh

if [ $# -lt 2 ]; then
    echo "Usage: `basename $0` REFERENCE_PROG TEST_PROG" >&2
    exit 1
fi

refbin="$1"
testbin="$2"

for file in sample/numbers/*
do
    outfile=/tmp/$$_test.stdout
    errfile=/tmp/$$_test.stderr
    $refbin <$file >$outfile.ref 2>$errfile.ref
    $testbin <$file >$outfile 2>$errfile
    
    echo -n "$file: "
    if diff $outfile $outfile.ref >/dev/null; then
	echo -n "PASS,"
    else
	echo -n "FAIL,"
    fi
    if diff $errfile $errfile.ref >/dev/null; then
	echo "PASS"
    else
	echo "FAIL"
    fi
    rm -f $outfile $errfile
done

##I looked for a 2> redirection to another temporary file and then a
##similar diff check for the error reference and test outputs. There
##is likely a cleaner way to do this by turning outfile and errfile
##into a list and iterating over it, but array syntax gets somewhat
##messy in bash
