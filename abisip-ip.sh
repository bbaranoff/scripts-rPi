#!/bin/bash
test -s monip
while [[ $(echo $?) -eq 1 ]]; do
echo $(abisip-find | awk -F\' '{print $4}') > monip & (sleep 3 && killall -9 abisip-find)
test -s monip
done
sort -u monip > ip_nano
