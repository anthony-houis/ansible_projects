#!/bin/bash

##################################################### Début doc in code #################################################################################
#  _    ___
# | |  / __|    Ce script sert à décrypter une string
# | |__\__ \
# |____|___/
#
###################################################### Fin doc in code ##################################################################################

# arbourm@PP68637:~/ansible$ outils/vault_stuff/encrypte_moi_ca_svp.sh nom_de_variable secretImportantÀCacher
# Si tout va bien, tu va pouvoir copier-coller tout après la ligne 'Encryption successful' dans ton fichier
# Encryption successful
# nom_de_variable: !vault |
#          $ANSIBLE_VAULT;1.1;AES256
#          63303037393062393232366330646330663036336435363239333230636532643564616161366335
#          3063613830366530356562323533663735613466623139340a326236666434313238393562326333
#          64663734356136376637633063343761633331633231663831303435616130393263323634653565
#          6237316538643530350a306131383537613739636361636130313366313263636464383837346436
#          34303035643265363737373837623865363037383338333163643566653332356561
# arbourm@PP68637:~/ansible$

# arbourm@PP68637:~/ansible$ echo '$ANSIBLE_VAULT;1.1;AES256
# > 63303037393062393232366330646330663036336435363239333230636532643564616161366335
# > 3063613830366530356562323533663735613466623139340a326236666434313238393562326333
# > 64663734356136376637633063343761633331633231663831303435616130393263323634653565
# > 6237316538643530350a306131383537613739636361636130313366313263636464383837346436
# > 34303035643265363737373837623865363037383338333163643566653332356561' | tr -d ' ' | ansible-vault decrypt && echo
# Decryption successful
# secretImportantÀCacher
# arbourm@PP68637:~/ansible$

# quelques vérifs
if [ $# -eq 0 ]
  then
    echo "Ça prends deux argument cher ami $(whoami)"
    echo "argument 1 = la string à décrypter"
    exit
fi

# que fait-on après ?
echo "Si tout va bien, tu va pouvoir voir ton stock décrypté"
echo "$1" | tr -d ' ' | ansible-vault decrypt && echo

echo ""
