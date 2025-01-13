#!/bin/bash

##################################################### Début doc in code #################################################################################
#  _    ___
# | |  / __|    Ce script sert à afficher une key/pair value...
# | |__\__ \
# |____|___/
#
###################################################### Fin doc in code ##################################################################################
# quelques vérifs
if [ $# -eq 0 ]
  then
    echo "Ça prends deux arguments cher ami $(whoami)"
    echo "le host FQDN"
    echo "la variable voulue (exemple: ansible_facts.default_ipv4.interface ou encore group_names)"
    exit
fi

ansible-playbook -l $1 playbooks/top/hosts/debug_ansible_facts_or_var.yml -e "__variable=$2"
