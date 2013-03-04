#!/usr/bin/env python2

import re
import sys

phonefilter1 = r'\b([0-9]{3})([-. ]?)([0-9]{3})\2([0-9]{4})\b'
phonefilter2 = r'\(([0-9]{3})\) ([0-9]{3})[-. ]?([0-9]{4})\b'

# r'string' is a raw string litteral.  Python will treate \ as a
# literal '\' in raw string literals unless the \ escapes a quote that
# would otherwise terminate the string.

for line in sys.stdin:
    m1 = re.match(phonefilter1, line)
    m2 = re.match(phonefilter2, line)

    if m1:
        parts = { 'area': m1.group(1), 'exc': m1.group(3), 'base': m1.group(4) }
    if m2:
        parts = { 'area': m2.group(1), 'exc': m2.group(2), 'base': m2.group(3) }

    if m1 or m2:
        print "+1-{area}-{exc}-{base}".format(area=parts['area'], exc=parts['exc'], base=parts['base'])
