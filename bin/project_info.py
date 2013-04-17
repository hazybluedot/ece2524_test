#!/usr/bin/env python

import sys
import re
from collections import defaultdict

contrib_re = re.compile(r'[Cc]ontrib')
lfm_re = re.compile(r'\+lfm')
contrib_split_re = re.compile(r'[\s,]')

def default_project():
    project = {'contributors': None}
    return project

def smart_split(field):
    if ',' in field:
        return map(str.strip, field.split(','))
    else:
        return map(str.strip, field.split())

def group_status(fields):
    if '+lfm' in fields['contributors']:
        return 'lfm'
    elif len(fields['contributors']) == 1:
        return 'lfg'
    else:
        return 'full'


projects = defaultdict(default_project)
lfm = defaultdict(default_project)
groups = defaultdict(list)

for path in map(str.strip, sys.stdin):
    with open(path, 'r') as f:
        fields = dict([ (contrib_re.sub('contrib', name),value) for name,part,value in map(lambda x: x.strip().partition(':'), f) ])
        if 'contributors' in fields:
            fields['contributors'] = smart_split(fields['contributors'])
            projects[fields['title']].update(fields)

    for title,fields in projects.items():
        groups[group_status(fields)].append((fields['title'],fields))
    
for status in groups:
    sys.stdout.write("{0}\n".format(status))
    sys.stdout.writelines(( "\t{0} ({1})\n".format(fields['title'], fields['contributors']) for fields in groups[status] ))
