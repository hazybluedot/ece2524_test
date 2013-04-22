#!/bin/sh

count=0
while true; do
 echo $count
 if [ -n "$1" ]; then
     sleep $1
 fi
 count=`expr $count + 10`
done
