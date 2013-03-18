#!/usr/bin/env python2

def read(f):
    record = {}
    for line in f:
        if line.startswith('%%'):
            yield record ## 'yield' is the magic word
            record = {}
        else:
            key,part,value=line.partition(':')
            record[key] = value.strip()

if __name__ == '__main__':
    """a simple test of our records generator"""
    import sys

    print "write some record data to standard in"
    for record in read(sys.stdin):
        print "record: {0}".format(record)

