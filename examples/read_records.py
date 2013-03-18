#!/usr/bin/env python2
import sys

if __name__ == '__main__':
    record = {}
    for line in sys.stdin:
        if line.startswith('%%'):
            print "record: {0}".format(record)
            record = {}
        else:
            key,part,value=line.partition(':')
            record[key] = value.strip()

