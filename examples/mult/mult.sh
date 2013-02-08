#!/bin/sh
## The preceding line is the interpreter directive, it tells bash how
## to interpret the rest of the file.  In this case it is telling the
## shell to use /bin/sh to interpret this file, hence, this is a shell
## script!

acc=1
while read line; do # read the man page for 'read'
    (( acc *= $line )) # because we are only conserned with integers
		       # we can handle this completely in bash. If we
		       # wanted to do floating point math in a bash
		       # scrit we would have to pipe to `bc` or
		       # something similar.
done
echo $acc # by default `echo` prints a new line character. If you are
	  # ever in a situation in which this situation is not
	  # desirable, check the man page!
