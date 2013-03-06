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

        if re.match('..t', line):
            sys.stdout.write("{line}: regex matched!\n".format(line=line.strip()))
