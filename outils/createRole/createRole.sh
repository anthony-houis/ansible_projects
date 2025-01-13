#!/bin/bash
##################################################### Début doc in code #################################################################################
#  _    ___
# | |  / __|    Ce script sert à créer un rôle et déjà faire 2-3 manips dedans dont résoudre des ansible-lint d'avance
# | |__\__ \
# |____|___/
#
###################################################### Fin doc in code ##################################################################################
# quelques vérifs
if [ $# -lt 2 ]
  then
    echo "Ça prends 2 arguments cher ami $(whoami)"
    echo "1- dans quel dossier de role tu veux ta patente (agents, applicatifs, backups, communs, divers)"
    echo "2- le nom du rôle"
    echo ""
    echo "As per Ansible doc : Role names are limited to lowercase word characters (i.e., a-z, 0-9) and '_'"
    exit
fi

# on sait RTFM ?
pattern="^[a-z][a-z0-9_]+$"

if [[ "$2" =~ $pattern ]]; then
  echo "Bon il est clair que tu sais lire... On continue !"
else
  echo "Grosse trace de break puisque tu ne sais pas lire -> As per Ansible doc : Role names are limited to lowercase word characters (i.e., a-z, 0-9) and '_'"
fi

# aller créer le rôle à la bonne place
cd roles/$1
    # ici il y a un --force mais c'est pour écraser si le dossier existe.
    # ansible-galaxy role init $2 --force
    # dans la vraie vie, on écrase pas
    ansible-galaxy role init $2 --force
cd ../../

# ajouter deux fichiers cachés pour pas que gitlab efface les 2 dossiers files et templates
touch roles/$1/$2/{files,templates}/.keep
echo "- fichiers vides .keep créés dans les dossiers roles/$1/$2/{files,templates}"

# on boucle pour créer les entêtes dans les fichiers main.yml (principalement pour doc in code)
for files in defaults handlers tasks vars;
do
    # copier le template
    cat outils/createRole/header.yml > roles/$1/$2/$files/main.yml
    # remplacer 1er et 2ième commentaire
    sed -i "s/commentaire1/$files\/main pour le rôle $2/" roles/$1/$2/$files/main.yml
    sed -i "s/commentaire2/Indiquez vos commentaires intéressants ici svp/" roles/$1/$2/$files/main.yml
done
echo "- blocs de commentaires créés dans les fichiers roles/$1/$2/{defaults handlers tasks vars}/main.yml"

# on boucle pour créer les fichiers vides des OS
for files in all CentOS7 OracleLinux7 OracleLinux8 RedHat7 RedHat8 Rocky8 SLES_SAP15 Ubuntu22;
do
    # copier le template
    cat outils/createRole/os_header.yml > roles/$1/$2/tasks/$files.yml
    # remplacer 1er et 2ième commentaire
    sed -i "s/ABCDEF/$2/" roles/$1/$2/tasks/$files.yml
    sed -i "s/123456/$files/" roles/$1/$2/tasks/$files.yml
done
echo "- Création des fichiers des OS"

# on boucle pour créer les fichiers vides des OS
# copier le template
cat outils/createRole/main.yml > roles/$1/$2/tasks/main.yml
# remplacer 1er et 2ième commentaire
sed -i "s/ABCDEF/$2/" roles/$1/$2/tasks/$files.yml
echo "- Création du fichiers tasks/main"

# ici on traite le fichier test.yml qui ne peut être dans la boucle ci-dessus à cause de... c'est un test.yml et non un main.yml
cat outils/createRole/header.yml roles/$1/$2/tests/test.yml > roles/$1/$2/tests/temp.yml
cp roles/$1/$2/tests/temp.yml roles/$1/$2/tests/test.yml
rm roles/$1/$2/tests/temp.yml
sed -i "s/commentaire1/tests\/test pour le rôle $2/" roles/$1/$2/tests/test.yml
sed -i "s/commentaire2/Indiquez vos commentaires intéressants ici svp/" roles/$1/$2/tests/test.yml
# on enlève les lignes en doubles
awk '!seen[$0]++' roles/$1/$2/tests/test.yml > roles/$1/$2/tests/temp.yml
cp roles/$1/$2/tests/temp.yml roles/$1/$2/tests/test.yml
rm roles/$1/$2/tests/temp.yml
echo "- blocs de commentaires créés dans les fichiers roles/$1/tests/test.yml"

# dans le fichier méta, changer les 3 valeurs par défaut pour éviter des erreurs automatique dans ansible-lint
sed -i "s/your name/$USER/" roles/$1/$2/meta/main.yml
sed -i "s/your role description/rôle $2/" roles/$1/$2/meta/main.yml
sed -i "s/your company (optional)/Legal-Suite/" roles/$1/$2/meta/main.yml
echo "- key-pair values modifiées dans roles/$1/meta/main.yml"
# sed -i '1s/^/---\n/' roles/$1/$2/meta/main.yml
sed -i 's/    # List tags for your role here, one per line. A tag is a keyword that describes/  # List tags for your role here, one per line. A tag is a keyword that describes/' roles/$1/$2/meta/main.yml
sed -i 's/    # and categorizes the role. Users find roles by searching for tags. Be sure to/  # and categorizes the role. Users find roles by searching for tags. Be sure to/' roles/$1/$2/meta/main.yml
sed -i 's/    # remove the .* above, if you add tags to this list./  # remove the "[]" above, if you add tags to this list./' roles/$1/$2/meta/main.yml
sed -i 's/    #/  #/' roles/$1/$2/meta/main.yml
sed -i 's/    # NOTE: A tag is limited to a single word comprised of alphanumeric characters./  # NOTE: A tag is limited to a single word comprised of alphanumeric characters./' roles/$1/$2/meta/main.yml
sed -i 's/    #       Maximum 20 tags per role./  #       Maximum 20 tags per role./' roles/$1/$2/meta/main.yml
sed -i 's/  # List your role dependencies here, one per line. Be sure to remove the .*$/# List your role dependencies here, one per line. Be sure to remove the "[]" above,/' roles/$1/$2/meta/main.yml
sed -i 's/  # if you add dependencies to this list./# if you add dependencies to this list./' roles/$1/$2/meta/main.yml
echo "- ré-indentations modifiées dans roles/$1/meta/main.yml"
sed -i 's/  # platforms:/  platforms:\n    - name: 'EL'\n      versions:\n        - "8"\n  # platforms:/' roles/$1/$2/meta/main.yml
echo "- platforms ajoutée dans roles/$1/$2/meta/main.yml"

# on fait pareil dans le fichier README.md
sed -i "s/Role Name/Rôle $1\/$2/g" roles/$1/$2/README.md
sed -i "s/BSD/It's a Legal-Suite secret/" roles/$1/$2/README.md
sed -i "s/hosts: servers/hosts: 'all'/" roles/$1/$2/README.md
sed -i "s/{ role: username.rolename, x: 42 }/'$2'/" roles/$1/$2/README.md
sed -i "s/An optional section for the role authors to include contact information, or a website (HTML is not allowed)./$USER/" roles/$1/$2/README.md
echo "- éditions de base faites dans le fichier roles/$1/$2/README.md"

# déjà régler des trucs qui vont déclencher avec ansible-lint au 1er passage
sed -i "s/license (GPL-2.0-or-later, MIT, etc)/LS/" roles/$1/$2/meta/main.yml
sed -i "s/min_ansible_version: 2.1/min_ansible_version: '2.13.1'/" roles/$1/$2/meta/main.yml
sed -i -r '/^\s*$/d' roles/$1/$2/tests/inventory

# on va maintenant faire le tasks main.yml à la sauce "OS"
cp outils/createRole/main.yml roles/$1/$2/tasks/main.yml
sed -i "s/ABCDEF/$2/" roles/$1/$2/tasks/main.yml

# on va maintenant créer le playbook pour respecter 1 rôle = 1 playbook
cp outils/createRole/playbook.yml.tpl playbooks/1r1p/$2.yml
sed -i "s/ABCDEF/$2/" playbooks/1r1p/$2.yml

# on crée le symlink handlers/main.yml
cd roles/$1/$2/handlers
rm main.yml
ln -s ../../../handlers.yml main.yml
cd ../../

# on roule un ansible-lint pour édifier le lecteur à faire les changements demandés
echo ""
echo "Je lance maintenant : ansible-lint roles/$1"
echo "-------------------------------------------------------------------------------------------------------"
ansible-lint roles/$1/$2 > /dev/null 2>&1

echo "-------------------------------------------------------------------------------------------------------"
echo "ansible-lint roles/$1/$2 effectué, des messages pourraient se trouver entre les 2 lignes ci-dessus"
echo ""

# on donne un avertissement au user d'ajouter la valeur de "platforms" dans me meta/main.yml
echo "J'ai fini ma job, mais comme indiqué avec un ansible-lint initial ci-dessus..."
echo "ATTENTION ! Valides 'platforms' dans le fichier roles/$1/meta/main.yml:31 <-- ctrl-click pour paresse"
echo "va falloir pcq là, je t'ai mis juste 'EL' version 8..."
echo ""
echo ""
