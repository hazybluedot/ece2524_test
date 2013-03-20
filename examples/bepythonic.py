#!/usr/bin/env python2

from sys import stdout,stderr,argv,exit

if not argv[1:]:
    stderr.write("please specify some arguments on the command line. They may be anything, anything at all\n")
    exit(1)

print "iterating over a list, as in C"
i = 0
while i < len(argv):
    print "arg[{0}]: {1}".format(i,argv[i])
    i += 1

print "ranged loops are cleaner and less prone to bugs"
for arg in argv:
    print "arg: {0}".format(arg)

## Note: the 'pythonic' solution used 2 lines of code instead of one, and didn't define an extra, unneeded variable.
## The most common source of bugs in C/C++ code are mis-used iterator variables, e.g. iterating past the end of an array,
## forgetting to increment an iterator variable, etc.

print "if you really do need to keep track of the index, use enumerate(...)"
for index,arg in enumerate(argv):
    print "arg[{0}]: {1}".format(index,arg)

print "use list index notation to only iterate over a subportion of a list"
for arg in argv[1:]:
    print "arg: {0}".format(arg)


