#!/bin/bash

argpostfix() {
    echo "$@" | sed -re 's/[-]/_/g' -e 's/ //g' 
}

function runsingle() {
    local solution_script="$1"; shift
    local input_file="$1"; shift
    timeout -k 5 2 $(envrun $solution_script $@ 2>&4) < $input_file
    local status="$?"
    echo "$status" >&3
    if [ "$status" -eq 124 ]; then
	echo "(timed out)" >&3
    fi
}

function runtests() {
    local testbin="$1"
    local input_path="$2"
    local basestub="$3"
    if [ -r "$testbin" ]; then
	for input_file in $input_path/input[0-9]; do
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

singlediff() {
    local inputrefstub="$1"
    local inputteststub="$2"
    for ext in stdout stderr status; do		
	diff_file="$inputteststub.$ext.diff"
	ref_file="$inputrefstub.$ext"
	test_file="$inputteststub.$ext"
	if [ -r $ref_file -a -r $test_file ]; then
	    #echo "diffing $(basename $ref_file) with $(basename $test_file) to $diff_file"
	    echo -n $(basename $test_file | sed "s/progtest_$$_//" )": "
	    diff -c $ref_file $test_file > $diff_file
	    if fail_stderr_linecount "$ext" "$ref_file" "$diff_file"; then
		echo "FAIL"
		echo "$diff_file" >&2
	    else
		echo "PASS"
	    fi
	else
	    echo "could not read $test_file" >&2
	fi
    done
}

makediffs() {
    local refstub="$1"
    local teststub="$2"
    local input_path="$3"
    for input_file in $input_path/input[0-9]; do
	local inputrefstub="${refstub}_$(basename $input_file)"
	local inputteststub="${teststub}_$(basename $input_file)"
	if [ -r "$input_file".args ]; then
	    while read args; do 
		stubstub=${inputrefstub}$(argpostfix $args)
		teststubstub=${inputteststub}$(argpostfix $args)
		singlediff "$stubstub" "$teststubstub"
	    done < "$input_file".args
	else
	    singlediff "$inputrefstub" "$inputteststub"
	fi
    done
}

usage() {
    echo "$(basename $0) REFBIN INPUTPATH"
}

if [ ! -x "$1" ]; then
    echo "$1: not executable" >&2
    usage >&2
    exit 1
else
    refbin=$(realpath "$1")
fi

if [ ! -d "$2" ]; then
    echo "$2: not a directory" >&2
    usage >&2
    exit 1
else
    inputpath=$(realpath "$2")
fi

refstub="/tmp/progtest_$$_ref_$(basename $refbin)"
runtests "$refbin" "$inputpath" "$refstub" \
    4>${refstub}.testerr

while read path; do
    if [ -r $path ]; then
	teststub="/tmp/progtest_$$_$(basename $path)"
	#echo "running tests on $path with $inputpath" >&2
	runtests $path $inputpath $teststub 4>${teststub}.testerr
	if [ -s "${teststub}.testerr" ]; then
	    echo "${teststub}.testerr" | movefiles $(dirname $path)/dkm_review "progtest_$$_"
	fi
	mkdir -p $(dirname $path)/dkm_review/diffs/
	makediffs "$refstub" "$teststub" "$inputpath" \
	    2> >(movefiles $(dirname $path)/dkm_review/diffs "progtest_$$_")
	rm -f ${teststub}*
    fi
done

rm -f ${refstub}*
