#!/bin/bash

##################################################### Début doc in code #################################################################################
#  _    ___
# | |  / __|    Ce script sert à encrypter une string
# | |__\__ \
# |____|___/
#
###################################################### Fin doc in code ##################################################################################

# arbourm@PP68637:~/ansible$ outils/vault_stuff/encrypte_moi_ca_svp.sh nom_de_variable secretImportantÀCacher
# Si tout va bien, tu va pouvoir copier-coller tout après la ligne 'Encryption successful' dans ton fichier
# Encryption successful
# nom_de_variable: !vault |
#           $ANSIBLE_VAULT;1.1;AES256
#           35343539636232346432333764653730633861613035393863313033666339623637353632386566
#           3235303332623734633534613031663563653231306566640a303734373765393663663862343962
#           37363131373563323734316463383662376465363639653364613266376235333034363234653030
#           6166613063616237310a313638393365663335633530346362343333653637666166343161306463
#           30633163316363386135626539393762636466653530306662633464646236393465
# arbourm@PP68637:~/ansible$

# quelques vérifs
if [ $# -eq 0 ]
  then
    echo "Ça prends deux argument cher ami $(whoami)"
    echo "argument 1 = le nom de la string"
    echo "argument 2 = le secret à encrypter"
    exit
fi

# que fait-on après ?
echo "Si tout va bien, tu va pouvoir copier-coller tout après la ligne 'Encryption successful' dans ton fichier"
ansible-vault encrypt_string --name "$1" "$2"
echo ""
