#!/bin/bash

##################################################### Début doc in code #################################################################################
#  _    ___
# | |  / __|    Ce script sert à afficher qui a quel package...
# | |__\__ \    exemples:
# |____|___/    outils/host_stuff/find_me_a_package.sh "all" nginx "1.20.1"
#
###################################################### Fin doc in code ##################################################################################
# quelques vérifs
if [ "$#" -ne 4 ]
  then
    echo "Ça prends trois arguments minimum cher ami $(whoami)"
    echo "le limiteur"
    echo "le nom du package"
    echo 'la version du package (sinon mettre ".*" pour tous)'
    echo 'la release du package (sinon mettre ".*" pour tous)'
    exit
fi

ansible-playbook -l $1 playbooks/top/hosts/package_finder.yml -e "__package=$2 __version=$3 __release=$4"
