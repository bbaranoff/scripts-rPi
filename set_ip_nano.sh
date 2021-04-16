#!/bin/sh
test -s ip_nano
if [[ $? -eq 1 ]] ; then
ifconfig eth0 | awk '/inet / {print $2}' | cut -d ':' -f2 > ip_loc
./abisip-ip.sh > ip_nano
ipaccess-config -r $(cat ip_nano) -o $(cat ip_loc) -u 1801/0/0
fi
