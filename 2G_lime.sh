#!/bin/bash
killall -9 osmo-nitb osmo-bts-trx osmo-trx-lms > kill.log 2>&1
echo -e "Hello World stop w/ Ctrl-C\n"
asterisk > asterisk.log 2>&1
modprobe mISDN_core > mISDN.log 2>&1
modprobe mISDN_dsp >> mISDN.log 2>&1
modprobe snd-pcm > snd-pcm.log 2>&1
exec lcr start > lcr.log 2>&1 &
echo -e "I am going to wait for 10 seconds only ...\n"
./bar.sh
echo -e "\nLCR started !\n"
exec /usr/bin/osmo-nitb -c /etc/osmocom/nitb/openbsc.cfg -l hlr.sqlite3 -P -m /tmp/bsc_mncc -C --debug=DRLL:DCC:DMM:DRR:DRSL:DMM --yes-i-really-want-to-run-prehistoric-software > osmo-nitb.log 2>&1 &
echo -e "I am going to wait for 10 seconds only ...\n"
./bar.sh
echo -e "\nopenbsc started !\n"
exec /usr/bin/osmo-trx-lms -C /etc/osmocom/nitb/osmo-trx.cfg 2>&1 osmo-trx.log  &
echo -e "\nI am going to wait for 10 seconds only ...\n"
./bar.sh
echo -e "\nosmo-trx started ! \n"
exec /usr/bin/osmo-bts-trx -c /etc/osmocom/nitb/osmo-bts.cfg 2>&1 osmo-bts.log
./bar.sh
echo -e "\nosmo-bts started !\n"
exec killall -9 osmo-nitb osmo-bts-trx osmo-trx-lms
