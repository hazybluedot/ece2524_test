#!/usr/bin/env python2
## The preceding line is the interpreter directive, it tells bash how
## to interpret the rest of the file.  In this case it is telling the
## shell to use python2 to interpret this file! I have noticed that on
## some versions of Ubuntu don't have a `python2` command, just
## `python`, given that there is a healthy mix of python 3 and python
## 2 code out there you probably do want to be explicit which version
## you are writing for.  I think Ubuntu 12.10 does have a `python2`
## command by default, but if you find that your system does not you
## can create a symbolic link to the binary:
# ln -s /usr/bin/python /usr/bin/python2

import sys
# we could also have used from sys import stdout and then just used
# stdout instead of sys.stdout in the code

acc=1
for line in sys.stdin:  # because of the way python buffers line input
                        # when used interactively the user will have
                        # to press ^D twice to 
    acc *= int(line) # int will throw an exception if the expression
                     # passed to it can not be converted to an
                     # integer. This will be relevant for the next
                     # assignment!

# write to standard out here.  Be aware that if you use `print`, a new
# line will be added automatically. Using the .write function writes
# only the characters you give it, so you need to explicitly give a
# new line character (\n) if you want one!
sys.stdout.write("{result}\n".format(result=acc))
