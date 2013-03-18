#!/usr/bin/env python2
from sys import stdout,stderr
from math import pi
import re

print "list comprehension"
# list comprehension has a syntax similar to mathmatical set comprehension
N=5
squares=[ x**2 for x in range(1,N+1) ]
print "squares of natural numbers between 1 and {0}: {1}".format(N, squares)

mylist = [ 'apple', 'orange', 'cat', 'hat', 'ece2524', '42', 'pie', 'pi', pi ]
print "mylist: {0}".format(mylist)

threes = [ item for item in mylist if re.match(r'^...$', str(item)) ]
print "threes: {0}".format(threes)

print "a numbered list:"
numbered = [ "{0}. {1}\n".format(index, item) for index,item in enumerate(mylist) ]
stdout.writelines(numbered)

colors = [ "red", "blue", "green" ]
things = [ "cat", "hat", "mat" ]

colored_things = [ (c,t) for c in colors for t in things ]
print "colored things: {0}".format(colored_things)

colored_things3 = [ (c,t) for c in colors for t in things if len(c)+len(t) == 2*len(c) ]
print "colored things with filter: {0}".format(colored_things3)
