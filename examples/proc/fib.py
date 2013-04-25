#!/usr/bin/env python3

def fib(stop):
    x = 0
    y = 1
    while stop(x):
        x, y = y, x+y
        yield x

if __name__ == '__main__':
    import sys

    for line in map(str.strip, sys.stdin):
        N = int(line)
        print(sum( x for x in fib(lambda x: x < N) ))
        sys.stdout.flush()
