#!/usr/bin/env python2
import sys
import re

def three_letter_word_that_ends_in_t(word):
    charcount = 0
    state = 'start'
    for char in word:
        if state == 'start':
            charcount = 1
            state = 'count'
        elif state == 'count':
            charcount += 1
            
            if charcount == 3 and char == 't':
                state = 'end'

        elif state == 'end' and char != '\n':
            state = 'start'
        else:
            return True

    return False


if __name__ == '__main__':

    for line in sys.stdin:
        if three_letter_word_that_ends_in_t(line):
            sys.stdout.write("{line}: FSM matched!\n".format(line=line.strip()))

        if re.match(r'..t\b', line):
            sys.stdout.write("{line}: regex matched!\n".format(line=line.strip()))

        words1 = re.findall(r'\s*(\w+)\s*', line)
        words2 = line.split()
        if len(words1) > 1 or len(words2) > 2:
            sys.stdout.write("split words with regex: {list}\n".format(list=words1))
            sys.stdout.write("split words with split: {list}\n".format(list=words2))

        ## What if you wanted to get a list of all three letter words that ended in 't'?
        twords = re.findall(r'\b..t\b', line)
        sys.stdout.write("three letter words that end in 't': {list}\n".format(list=twords))
