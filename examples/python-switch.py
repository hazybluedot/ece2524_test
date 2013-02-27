#!/usr/bin/env python2

import sys

usage_string="""Usage: {prog} COMMAND ARGUMENT
COMMAND may be any of {commands}
"""

def function1(x):
    "do something with x"
    print "calling funtion 1 with x={0}".format(x)

def function2(x):
    "do something else with x "
    print "calling function 2 with x={0}".format(x)

if __name__ == '__main__': # python's way of defining the "main" function
    option = { 'one': function1, 'two': function2 } # a dict with two items
    
    try:
        myname, command, argument = sys.argv
    except ValueError as e:
        sys.stderr.write(usage_string.format(prog=sys.argv[0], commands=option.keys()))
        sys.exit(1)

    try:
       option[command](argument)
    except KeyError as e:
       sys.stderr.write("I did not understand the command: {0}\n".format(command))
       sys.exit(1)

    sys.stdout.write("Done\n")
