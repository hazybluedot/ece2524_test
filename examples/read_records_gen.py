#!/usr/bin/env python2
import sys
import myrecordtype as records

if __name__ == '__main__':
    for record in records.read(sys.stdin):
        print "\"{title}\" by {author}, {date}".format(
            title=record['title'], 
            author=record['author'], 
            date=record['published'])
