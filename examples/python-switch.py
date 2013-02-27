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
        option[command](argument) # using the command we read as a CLA
        # as the key to our dict if the key exists, the returned value
        # will be a callable object, so we can call it with the
        # (argument) syntax
    except KeyError as e:
        # if the command we read as a CLA is not a key in our dict,
        # then python will throw a KeyError exception when we try to
        # access it
        sys.stderr.write("I did not understand the command: {0}\n".format(command))
        sys.exit(1)

    sys.stdout.write("Done\n")
    # by default, exit with status code 0 (success)
