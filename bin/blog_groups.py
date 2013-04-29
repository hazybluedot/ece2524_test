#!/usr/bin/env python

import re

group_re = re.compile(r'Group ([1-3])')

def blogger(filename):
    group = None
    with open(filename, 'r') as f:
        for line in map(str.strip, f):
            m = group_re.match(line)
            if m:
                group = "group{0}".format(m.group(1))
            if not line.startswith('='):
                yield line,group

if __name__ == '__main__':
    import sys
    
    for (name,group) in blogger(sys.argv[1]):
        print("{0} : {1}".format(name,group))
            
