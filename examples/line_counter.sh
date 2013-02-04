#!/bin/sh

counter=0
while read line; do
	(( counter++ ))
done
echo "read $counter lines"
