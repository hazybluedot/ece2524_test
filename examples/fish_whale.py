#!/usr/bin/env python2

import re
import sys

for line in sys.stdin:
    line = re.sub('[Ff]ish','whale',line)
    sys.stdout.write(line)
