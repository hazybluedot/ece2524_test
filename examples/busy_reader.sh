#!/bin/sh

while read line; do
    echo "line: $line";
    echo "debug: got a line" >&2
done

while :
do
 sleep 1
done
