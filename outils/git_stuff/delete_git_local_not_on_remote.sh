#!/bin/bash
##################################################### Début doc in code #################################################################################
#  _    ___
# | |  / __|    Ce script sert à effacer les branches locales non présentes dans gitlab.com
# | |__\__ \
# |____|___/
#
###################################################### Fin doc in code ##################################################################################
# retourner en branche devl et la mettre à jour
git checkout main
git pull

# git fetch
git fetch -p

# effacer les branches locales non présentes en repote
for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}');
do
    git branch -D $branch;
done

# clewanup des archives de mep_prep meti
/bin/rm roles/meti/files/*.zip
