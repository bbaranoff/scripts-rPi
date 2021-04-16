#!/bin/bash
#on test si le fichier monip est présent (initialisation)
test -s monip
#Tant que mon est vide on fait :
while [[ $(echo $?) -eq 1 ]]; do
#On lance abisip-find en tant que fork et
#on prend le quatrième champ avec le séparateur ' on le stocke dans mon ip
#on kill le fork après 3 secondes
echo $(abisip-find | awk -F\' '{print $4}') > monip & (sleep 3 && killall -9 abisip-find)
#on rexecute le test pour la boucle while
test -s monip
done
#enfin on élimine les doublons et on stocke l'ip de la nanoBTS dans le fichier ip_nano
sort -u monip > ip_nano
