#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $(basename $0) [proccess name]..." >&2
fi

for PROC in "$@"
do
    echo "${PROC}:"
    ls -l /proc/$(pgrep $PROC)/fd | sed '1d'
    echo -ne "\n"
done
