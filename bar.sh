#!/bin/bash
printf "["
for x in {1..150} ; do
    printf "#"
    sleep .05   # do some work here
done ;
printf "]\n"
