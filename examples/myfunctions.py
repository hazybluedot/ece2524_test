#!/usr/bin/env python2

def function1(x):
    "do something with x"
    print "calling funtion 1 with x={0}".format(x)

def function2(x):
    "do something else with x "
    print "calling function 2 with x={0}".format(x)

if __name__ == '__main__':
    import sys
    sys.stderr.write("Don't call me, I just define functions!\n")
    sys.exit(1)
