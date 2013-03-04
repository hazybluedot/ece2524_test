#!/usr/bin/env python2

import re
import sys

patterns = [ ('[Ff]ish','whale'), 
             ('Polar Sea', 'Arctic Ocean') ]

for line in sys.stdin:
    for pattern in patterns:
        line = re.sub(pattern[0], pattern[1], line)
    
    sys.stdout.write(line)
