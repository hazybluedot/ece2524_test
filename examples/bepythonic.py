#!/usr/bin/env python2

from sys import stdout,stderr,argv

print "iterating over a list, as in C"
for i in range(len(argv)):
    print "arg[{0}]: {1}".format(i,argv[i])

print "ranged loops are cleaner and less prone to bugs"
for arg in argv:
    print "arg: {0}".format(arg)

print "if you really do need to keep track of the index, use enumerate(...)"
for index,arg in enumerate(argv):
    print "arg[{0}]: {1}".format(index,arg)

print "use list index notation to only iterate over a subportion of a list"
for arg in argv[1:]:
    print "arg: {0}".format(arg)


