#!/bin/sh
#on prend l'ip locale du pi
ifconfig eth0 | awk '/inet / {print $2}' | cut -d ':' -f2 > ip_loc
#On verifie que l'on a pas déja l ip de la nano
test -s ip_nano
#Si elle n'est pas dans un fichier c est que la nano n a pas été initialisée
if [[ $? -eq 1 ]] ; then
#on lance le script joint
./abisip-ip.sh > ip_nano
#et enfin on configure la nano avec les ip recherchées
ipaccess-config -r $(cat ip_nano) -o $(cat ip_loc) -u 1801/0/0
fi
