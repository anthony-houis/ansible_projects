#!/bin/bash

##################################################### Début doc in code #################################################################################
#  _    ___
# | |  / __|    Ce script sert à Lister quels hôtes sont membre d'un groupe
# | |__\__ \
# |____|___/
#
###################################################### Fin doc in code ##################################################################################
# quelques vérifs
if [ $# -eq 0 ]
  then
    echo "Ça prends un argument cher ami $(whoami)"
    exit
fi

# on place le param dans une variable pcq c'est plus lisible pour la suite
groupe=$1;

# est-ce que le groupe existe ?
groupeExiste=$(ansible-inventory  --list 2>/dev/null | jq -r "keys" | grep "${groupe}" | wc -l)

# si j'ai 1 dans groupeExiste, ca baigne
if [ "$groupeExiste" -eq "1" ];
then
    ansible-inventory  --list 2>/dev/null | jq -r ".$groupe"
else
    echo "Ce groupe-là n'existe pas! On recommence ?"
    echo "Au pire tu peux lister les groupes avec la commande ci-dessous:"
    echo "outils/group_stuff/listInventoryGroups.sh"
    exit
fi
