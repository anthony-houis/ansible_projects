- [Création de rôle ansible](#création-de-rôle-ansible)
- [Une note à propos des `handlers`](#une-note-à-propos-des-handlers)
  - [La magie des symlinks](#la-magie-des-symlinks)

# Création de rôle ansible

Dans le but de créer un rôle dans la conformité, vous êtes priés d'utiliser le script `outils/createRole/createRole.sh`

Lors de son execution sans paramètre, le manuel d'emploi vous sera affiché.

```
marbour@marbour:~/git/poc-conformite$ outils/createRole/createRole.sh
Ça prends 2 arguments cher ami marbour
1- dans quel dossier de role tu veux ta patente (agents, applicatifs, backups, communs, divers)
2- le nom du rôle

As per Ansible doc : Role names are limited to lowercase word characters (i.e., a-z, 0-9) and '_'
marbour@marbour:~/git/poc-conformite$
```

> # Pourquoi ?
> L'utilisation du script va faire un galaxy init pour créer un rôle et ensuite, il corrigera tout un tas de truc qui sont soulevés au premier `ansible-lint`.

# Une note à propos des `handlers`

Il arrive régulièrement que nous soyons appelés à notifier des handlers pour des rôles autres que celui dans lequel nous sommes. Par exemple, je travaille dans le role ABC qui doit déposer un fichier de conf pour apache. Il est clair que je dois redémarrer apachepour prendre en comtpe le nouveau fichier de conf. Mais n'étant pas dans le rôle apache, soit je double le handler de redémarrage de service ou...

## La magie des symlinks
Gitlab permet les symlink si l'on ne quitte pas l'arborescence du repo. Le script, donc, efface le fichier `handlers/main.yml` du nouveau rôle et le symlink vers un seul fichier `handlers.yml` à la racine du dossier `roles`. Ceci permet, dans le rôle ABC, de notifier un handler du rôle DEF et ainsi recycler le même code conditionnel de redémarrage si applicable.
