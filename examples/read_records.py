#!/usr/bin/env python2
import sys

if __name__ == '__main__':
    record = {}
    for line in sys.stdin:
        if line.startswith('%%'):
            print "\"{title}\" by {author}, {date}".format(
                title=record['title'], 
                author=record['author'], 
                date=record['published'])
            record = {}
        else:
            key,part,value=line.partition(':')
            record[key] = value.strip()

