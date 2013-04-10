#!/usr/bin/env python

import re
import sys

regexs = { r'^\w{3}$' : 'three letters', 
           r'.*t' : 'ends in t', 
           r'.*k.*': 'contains a k'
           }

for line in map(str.strip, sys.stdin):
    matches = [ desc for regex,desc in regexs.items() if re.match(regex,line) ]
    sys.stdout.write("{0}: {1}\n".format(line, ",".join(matches)))

## Generally if you eliminated the "i" variable and replaced the while
## loop with a for each loop, and turned the regex/descriptions lists
## into a dict you received full credit. Still be sure to understand
## these solutions and come to your own conclusion about which you
## think are better.

## Also, be descriptive with your variables.

if False:
    for i in regexs:
        ##what is i?
        re.match(i, 'some text')
    for regex in regexs:
        ##ah, this makes more sense
        re.match(regex, 'some text')
## likewise

if False:
    for key,value in regexs.items():
        ## all I know is that I have a 'key' and a 'value'
        if re.match(key, 'some text'):
            matches.append(value)
    for regex,description in regex.items():
        ## a tad more typing, but now I know exactly what is going on when I use the unpacked variables later.
        if re.match(regex, 'some text'):
            matches.append(description)
