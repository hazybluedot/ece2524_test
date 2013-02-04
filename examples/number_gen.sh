#!/bin/sh

if [ -z "$1" ]; then
    echo "Dirt simple number generator" >&2
    echo "Usage: $(basename $0) [integer]" >&2
    exit 1
fi

for i in $(seq 1 1 $1)
do
   echo $i
done

echo "Press Ctrl+C to stop $(basename $0)" >&2
while :
do
   sleep 1
done
