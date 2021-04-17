#!/bin/bash
#A lancer en tant que sudoer
#on supprime les sessions précédentes sinon la lime ne se lancera pas
#si il reste des process
killall -9 osmo-nitb osmo-bts-trx osmo-trx-lms asterisk lcr > kill.log 2>&1
#Pour quitter le script Ctrl-C
echo -e "Hello World stop w/ Ctrl-C\n"
#On lance ou relance asetisk pour etre sur qu'il tourne
asterisk > asterisk.log 2>&1
#On charge les drivers pour lcr
modprobe mISDN_core > mISDN.log 2>&1
modprobe mISDN_dsp >> mISDN.log 2>&1
modprobe snd-pcm > snd-pcm.log 2>&1
#On lance un fork de lcr et on attend dix secondes
exec lcr start > lcr.log 2>&1 &
echo -e "I am going to wait for 10 seconds only ...\n"
./bar.sh
echo -e "\nLCR started !\n"
#On lance un fork de Openbsc et on attends dix secondes pour qu'il
#soit apte à accueillir osmo-trx-lms
exec /usr/bin/osmo-nitb -c /etc/osmocom/nitb/openbsc.cfg -l hlr.sqlite3 -P -m /tmp/bsc_mncc -C --debug=DRLL:DCC:DMM:DRR:DRSL:DMM --yes-i-really-want-to-run-prehistoric-software > osmo-nitb.log 2>&1 &
echo -e "I am going to wait for 10 seconds only ...\n"
./bar.sh
echo -e "\nopenbsc started !\n"
#On lance un fork de Openbsc et on attends dix secondes pour qu'il
#soit apte à accueillir osmo-bts-trx
exec /usr/bin/osmo-trx-lms -C /etc/osmocom/nitb/osmo-trx.cfg 2>&1 osmo-trx.log  &
echo -e "\nI am going to wait for 10 seconds only ...\n"
./bar.sh
echo -e "\nosmo-trx started ! \n"
#Enfin on lance un process (non forké de osmo-bts-trx) pour pouvoir killer
exec /usr/bin/osmo-bts-trx -c /etc/osmocom/nitb/osmo-bts.cfg 2>&1 osmo-bts.log
./bar.sh
echo -e "\nosmo-bts started !\n"
exec killall -9 osmo-nitb osmo-bts-trx osmo-trx-lms
