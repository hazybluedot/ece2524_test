#!/bin/bash

argpostfix() {
    echo "$@" | sed -re 's/[-]/_/g' -e 's/ //g' 
}

function runsingle() {
    solution_script="$1"; shift
    input_file="$1"; shift
    timeout -k 5 2 $(envrun $solution_script $@ 2>&4) < $input_file
    status="$?"
    echo "$status" >&3
    if [ "$status" -eq 124 ]; then
	echo "(timed out)" >&3
    fi
}

function runtests() {
    testbin="$1"
    input_path="$2"
    basestub="$3"
    if [ -r "$testbin" ]; then
	echo "Running tests on $solution_script" >&4
	for input_file in $input_path/input[0-9]; do
	    echo -e "\t $(basename $input_file)" >&4
	    inputstub=${basestub}_$(basename $input_file)
	    if [ -r "$input_file".args ]; then
		while read args; do 
		    postfix="$(argpostfix $args)"
		    stub=${inputstub}${postfix}
		    runsingle "$testbin" "$input_file" $args \
			>$stub.stdout \
			2>$stub.stderr \
			3>$stub.status
		done < "$input_file".args
	    else
		runsingle "$testbin" "$input_file" \
			>$inputstub.stdout \
			2>$inputstub.stderr \
			3>$inputstub.status
	    fi 
	done
    fi
}

makediffs() {
    refstub="$1"
    teststub="$2"
    input_path="$3"
    for input_file in $input_path/input[0-9]; do
	inputrefstub="${refstub}_$(basename $input_file)"
	inputteststub="${teststub}_$(basename $input_file)"
	if [ -r "$input_file".args ]; then
	    while read args; do 
		stub=$inputrefstub$(argpostfix $args)
		teststub=$inputteststub$(argpostfix $args)
		echo argdiff $stub $teststub
	    done
	else
	    for ext in stdout stderr status; do		
		diff_file="$inputteststub.$ext.diff"
		ref_file="$inputrefstub.$ext"
		test_file="$inputteststub.$ext"
		if [ -r $ref_file -a -r $test_file ]; then
		    echo -n $(basename $test_file | sed "s/progtest_$$_//" )": "
		    diff -c $ref_file $test_file > $diff_file
		    if [ -s "$diff_file" ]; then
			echo "FAIL"
			echo "$diff_file" >&2
		    else
			echo "PASS"
		    fi
		else
		    echo "could not read $test_file" >&2
		fi
	    done
	fi
    done
}

refbin="$HOME/ece2524/solutions/mult3/mult.py"
inputpath="$HOME/ece2524/tests/mult3"

refstub="/tmp/progtest_$$_ref"
runtests $refbin $inputpath $refstub \
    4>$refstub.testerr

while read path; do
    if [ -r $path ]; then
	teststub="/tmp/progtest_$$_$(basename $path)"
	runtests $path $inputpath $teststub 4>$stub.testerr
	rm -f $(dirname $path)/diffs/*
	makediffs "$refstub" "$teststub" "$inputpath" \
	    2> >(movefiles $(dirname $path)/diffs "progtest_$$_")
    fi
done

#rm -f ${refstub}*
