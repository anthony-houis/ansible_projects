# Normes de développement Ansible

## Table des matières

- [Normes de développement Ansible](#normes-de-développement-ansible)
  - [Table des matières](#table-des-matières)
  - [Bonnes pratiques](#bonnes-pratiques)
  - [Version d'Ansible](#version-dansible)
  - [Ne pas développer sur l'environnement de production](#ne-pas-développer-sur-lenvironnement-de-production)
  - [Cycle de développement](#cycle-de-développement)
    - [Tests](#tests)
    - [Choix de la branche cible](#choix-de-la-branche-cible)
    - [Mise en acceptation, mise en prod et rétroportage](#mise-en-acceptation-mise-en-prod-et-rétroportage)
  - [Bonnes pratiques des fonctionalités de Git](#bonnes-pratiques-des-fonctionalités-de-git)
    - [Commentaire de commits](#commentaire-de-commits)
    - [Remiser du code avec *git stash*](#remiser-du-code-avec-git-stash)
    - [Résolution de conflits](#résolution-de-conflits)
  - [Utilisation d'Ansible Galaxy](#utilisation-dansible-galaxy)
  - [Entête des fichiers](#entête-des-fichiers)
  - [Paramètres d'éditeur](#paramètres-déditeur)
  - [Espacement](#espacement)
  - [Citations (mettre une chaine de texte entre apostrophes/guillemets)](#Citations)
  - [Booléens](#booléens)
  - [Paires clé-valeur](#paires-clé-valeur)
  - [Indempotence des playbooks](#indempotence-des-playbooks)
  - [Validation des variables](#validation-des-variables)
  - [FQCN](#fqcn)
  - [Sudo](#sudo)
  - [Déclaration d'hôtes](#déclaration-dhôtes)
  - [Déclaration d'include](#déclaration-dinclude)
  - [Éviter l'utilisation des commandes](#éviter-lutilisation-des-commandes)
  - [Convention de nommage](#convention-de-nommage)
  - [Ordonnancement des modules et valeurs clefs paires](#ordonnancement-des-modules-et-valeurs-clefs-paires)
    - [``become: true``](#become-true)
    - [``loop:``](#loop)
    - [``when:``](#when)
    - [``register: __nom_de_variable``](#register-__nom_de_variable)
  - [Code conditionnel](#code-conditionnel)
    - [Éviter d'exclure des tâches basé sur le *check mode*](#éviter-dexclure-des-tâches-basé-sur-le-check-mode)
    - [Clauses `when` sur des lignes subséquentes indentées](#clauses-when-sur-des-lignes-subséquentes-indentées)
    - [Priorité des conditions](#priorité-des-conditions)
    - [Nom des variables](#nom-des-variables)
      - [Suffixes aux noms de variables](#suffixes-aux-noms-de-variables)
    - [Nom des rôles](#nom-des-rôles)
    - [Nom des groupes](#nom-des-groupes)
    - [Nom d'hôtes](#nom-dhôtes)
  - [Emplacement des variables](#emplacement-des-variables)
    - [Résumé de l'ordre d'héritage des variables](#résumé-de-lordre-dhéritage-des-variables)
    - [Définition de variables de rôle](#définition-de-variables-de-rôle)
  - [Commentaires et documentation](#commentaires-et-documentation)
  - [Langue](#langue)
  - [To merge or not to merge, là est la question](#to-merge-or-not-to-merge-là-est-la-question)
    - [Un ``README.md`` non modifié](#un-readmemd-non-modifié)
    - [Une typo de variable](#une-typo-de-variable)
    - [Du code fonctionnel sans danger imminent immédiat](#du-code-fonctionnel-sans-danger-imminent-immédiat)
    - [Un `merge` dans une conformité mature ou immature](#un-merge-dans-une-conformité-mature-ou-immature)

## Bonnes pratiques

Lors de la création d'une grande configuration Ansible avec une équipe, il est important de s'aligner sur un ensemble de conventions afin d'obtenir une configuration facile à maintenir et à étendre. Ce guide est destiné à compléter les directives de bonnes pratiques fournies par Ansible, avec des règles supplémentaires pour aider lorsqu'une configuration devient grande, complexe et est gérée par plusieurs administrateurs systèmes.

## Version d'Ansible

Nous utilisons actuellement la version X d'Ansible (ansible-core 2.XX.X). Tout le code doit être conçu pour fonctionner avec cette version d'Ansible.

## Ne pas développer sur l'environnement de production

Vous ne devez **jamais** exécuter du code Ansible qui n'a pas été fusionné dans la branche `prod` sur un serveur de production.

Le développement et les tests doivent être effectués sur des VM de développement dédié à cet usage.

> ### Pourquoi?
> Tous les changements apportés aux systèmes doivent être documentés et approuvés selon les politiques. Aussi, des "restants" d'essais de développement pourraient demeurer accidentellement sur des serveurs de production, ce qui pourrait causer des pannes ou des brèches de sécurité.

Même si du code a été révisé et a été accepté dans la branche `main`, il ne faut pas l'utiliser pour cibler un serveur de production, car le changement pourrait se faire renverser automatiquement en rejouant manuellement ou automatiquement la conformité à partir de la branche `prod`.

## Cycle de développement

L'ensemble du code est conservée dans un dépôt Git hébergée dans notre instance GitLab.

Nous utilisons le workflow [GitLab flow](https://nvie.com/posts/a-successful-git-branching-model/) légèrement modifié. La branche nommée *develop* se trouve à être notre branche `main`. Leur branche nommée `master` se trouve à être notre branche `prod`.

Le code en développement doit être publié dans une branche de fonctionalité dédiée (*feature branch*) que l'on crée à partir d'une des branches principales. Une fois que la tâche est complétée, la branche est poussée sur GitLab puis un *Merge Request* est créé.

Un MR doit être petite et circonscrite à une seule tâche afin de faciliter la révision. Pour un billet donné, il peut exister plus d'une MR, ce qui permet de découper le travail en plusieurs petites MR. L'utilisation de la fonctionalité [branch retargeting on merge](https://docs.gitlab.com/ee/user/project/merge_requests/getting_started#branch-retargeting-on-merge) de GitLab peut être utile dans ces situations.

Lorsque le code est prêt à être révisé, il reste maintenant à assigner le MR à un réviseur pour lui signaler que du code est prêt et est en attente de révision.

Le code est ensuite révisé et possiblement commenté par le réviseur. Si des modifications sont requises, le réviseur soumet une révision avec ses commentaires et suggestions.

Lorsque le code est approuvé, il est fusionné dans la branche ciblée par la MR et peut à présent être considéré comme étant du code de qualité suffisante pouvant être exécuté sur les serveurs de production.

### Tests

Il est important de réviser et tester son code avant de le soumettre à un réviseur.

Après avoir créé votre MR, il faut se mettre à la place du réviseur et réviser son propre code en analysant l'onglet *Changes* de la MR afin de vous assurer que tout est en ordre et qu'il ne reste pas de restants de déboguage ou autre code indésiré.

Tester ensuite votre code en ciblant une machine `sandbox ou test` qui n'a pas été utilisée dans le cadre de votre développement. Ça permet de tester le code à partir d'un environnement propre.

> Attention, les tests ne se font jamais sur un serveur en dtAP ! (pas en acceptation ni prod)

Source : https://en.wikipedia.org/wiki/Development,_testing,_acceptance_and_production

Enfin, il faut se questionner sur les tâches conditionnelles que contient notre code et y porter une plus grande attention. Du code conditionnel qui ne s'applique pas à une exécution de test n'est pas validé et pourrait tout de même avoir un impact sur la production.

### Choix de la branche cible

Lorsqu'on crée une nouvelle branche de fonctionalité, il faut se demander à partir de quelle branche on souhaite développer.

Les changements qui ont besoin d'être appliqués sur la prod immédiatement **et** qui sont triviaux doivent être fusionnés directement dans `prod`. On parle ici de faire un **hot fix*. Bien sûr, on ne fera pas de `code refactoring` directement sur la branche `prod`. Le même principe s'applique à la branche `acceptation`.

Les changements qui ne sont pas triviaux ou qui ne nécessites pas une application immédiate doivent cibler le branche `main`.

### Mise en acceptation, mise en prod et rétroportage

Généralement, une *mise en acceptation* est effectuée hebdomadairement, le mercredi. Une MR est alors créée afin de fusionner la branche `main` dans la branche `acceptation`. Une exécution du playbook *site.yml* est lancé en mode *check* pour valider les changements puis une seconde fois en mode réel pour appliquer les changements sur les serveurs de l'environnement dtAp.

Le mardi suivant a lieu la *mise en production* où une MR est créée afin de fusionner la branche `acceptation` dans la branche `prod`. Une exécution du playbook *site.yml* est lancé en mode *check* pour valider les changements puis une seconde fois en mode réel pour appliquer les changements sur les serveurs de l'environnement prod.

Au besoin, on peut envisager accélérer exceptionnellement le cycle de développement pour promouvoir en acceptation/prod plus rapidement un changement poussé sur la branche `main`.

Avant d'effectuer la mise en acceptation/prod, il est important de d'abord commencer par rétroporter (*backporter*) la `prod` dans `acceptation` puis le `acceptation` dans `main`.

Ces tâches sont généralement effectuées par un membre désigné, toujours le même, de l'équipe Infrastructure Linux mais peuvent être à l'occasion déléguées à un autre membre de l'équipe.

## Bonnes pratiques des fonctionalités de Git

Git est un outil puissant et il est essentiel de bien l'utiliser.

### Commentaire de commits

Chaque commit devrait avoir un commentaire approprié qui résume les modifications apportées. Éviter des commentaires comme "commit de fin de journée", car ceci n'apporte aucune information sur le changement effectué.

Un commit qui *n'a pas encore été poussé sur GitLab* peut toutefois être édité avec *git amend* afin de saisir une description approprié à un commit pour lequel un commentaire temporaire aurait pu être saisi ou pour y ajouter des modifications. Ne pas éditer un commit déjà poussé!

> #### Pourquoi?
> Le commentaire peut être très utile lorsqu'on souhaite savoir pourquoi un changement passé a été effectué (à l'aide de *git blame* par exemple).

### Remiser du code avec *git stash*
Éviter d'effectuer un commit pour mettre du code non fonctionnel de côté afin de pouvoir changer de branche et travailler sur autre chose. Utiliser plutôt la fonctionalité prévue à cet effet, *git stash*.

> #### Pourquoi?
> Du code commité, c'est du code qui risque de se retrouver éventuellement en production lors de la création de la MR. Il est possible que ce code non testé ou non terminé que vous commitez rapidement pour passer à autre chose soit oublié et se retrouve en prod accidentellement plus tard.

### Résolution de conflits

Porter une attention particulière à la résolution de conflits lors de fusion d'une branche de fonctionalité dans l'une des branches principales. La résolution ne doit pas être de conserver aveuglément la version locale comme aillant préséance sur la version distante. En faisant cela, vous pouvez défaire un changement qui a déjà été fusionné et causer des impacts négatifs sur les serveurs de production.

## Utilisation d'Ansible Galaxy

L'importation de rôles depuis Ansible Galaxy est autorisé. On les utilise toutefois avec parcimonie lorsque cela permet d'économiser beaucoup de temps de développement et que la qualité du code importé est adéquate.

L'administrateur système doit toutefois s'assurer de révisier le contenu complet du rôle afin de s'assurer qu'il ne contienne pas de code malicieux.

## Entête des fichiers

Vous devriez commencer vos scripts par `---` , suivi de quelques commentaires expliquant le but du script (et un exemple d'utilisation, si nécessaire) avec des lignes vides autour, puis suivi du reste du script.

```yaml
# Mauvais exemple
- name: "Changer le statut de s1m0n3"
  become: true
  ansible.builtin.service:
    enabled: true
    name: 's1m0ne'
    state: '{{ state }}'

# Bon exemple
---
# Exemple d'utilisation: ansible-playbook -e state=started playbook.yml
# Ce playbook change l'état de s1m0n3 le robot

- name: "Changer le statut de s1m0n3"
  become: true
  ansible.builtin.service:
    enabled: true
    name: 's1m0ne'
    state: '{{ state }}'
```

> #### Pourquoi?
> Cela facilite la recherche rapide du but/de l'utilisation d'un script, soit en ouvrant le fichier, soit en utilisant la commande `head`.

## Paramètres d'éditeur

Les paramètres d'équipe sont commités dans le fichier `ansible/.editorconfig` afin de standardiser l'approche pour tous.

* L'indentation doit être de 2 espaces. De plus, les *arrays* (c'est-à-dire les lignes qui commencent par `-`) doivent également être indentés de 2 espaces par rapport à leur parent.

* Les fins de ligne doivent utiliser le caractère `\n` (`LF`) utilisé par défaut sur les systèmes *nix.

* Les lignes ne doivent pas comporter d'espaces blancs en fin de ligne.

* Un fichier doit se terminer par un seul saut de ligne vide.

* Les fichiers doivent utiliser uniquement UTF-8 _sans_ BOM comme codage de caractères.

L'utilisation d'un éditeur qui supporte la norme *EditorConfig* tel que VSCode (avec l'extension appropriée) facilite le respect de ces règles.

> #### Pourquoi?
> La plupart sont des bonnes pratiques Unix courantes, et évitent tout désalignement de l'invite lors de l'impression des fichiers dans un terminal ou de la génération d'un fichier diff. Des paramètres communs de l'éditeur de texte facilitent aussi le travail collaboratif.

## Espacement

Il faut prévoir des lignes vides entre deux blocs d'hôte, entre deux blocs de tâche et entre les blocs d'hôte et d'include.

> #### Pourquoi?
> Cela permet d'obtenir un code agréable et facile à lire.

## Citations
### aka mettre une chaine de texte entre apostrophes/guillemets

**Nous citons toujours les chaînes de caractères** et préférons les guillemets simples aux guillemets doubles. Les guillemets doubles ne doivent être utilisés que lorsqu'ils sont imbriqués dans des guillemets simples (par exemple, une référence à un élément Jinja), ou lorsque votre chaîne nécessite des caractères d'échappement (par exemple, en utilisant "\n" pour représenter une nouvelle ligne).

Si vous devez écrire une longue chaîne, nous utilisons le style "scalaire plié/littéral" (*folded/literal scalar*) et omettons toute citation spéciale. Les seules choses que vous devez éviter de citer sont les booléens (par exemple, `true/false`), les nombres (par exemple, `42`) et les éléments faisant référence à l'environnement local d'Ansible (par exemple, la logique booléenne ou les noms des variables auxquelles nous attribuons des valeurs).

```yaml
# Mauvais exemple
- name: Arrêt d'un robot nommé S1m0ne
  become: true
  ansible.builtin.service:
    name: s1m0ne
    state: stopped
    enabled: true

# Bon exemple
- name: "Arrêt d'un robot nommé S1m0ne"
  become: true
  ansible.builtin.service:
    name: 's1m0ne'
    state: 'stopped'
    enabled: true

# Bon exemple : guillemets doubles avec guillemets simples imbriqués
- name: "Démarrer tous les robots"
  become: true
  ansible.builtin.service:
    name: '{{ item["robot_name"] }}'
    state: 'started'
    enabled: true
  loop:
    - '{{ robots }}'

# Bon exemple : guillemets doubles pour utiliser un retour à la ligne
- name: "Afficher du texte sur deux lignes"
  ansible.builtin.debug:
    msg: "Ce texte est sur\ndeux lignes."

# Bon exemple : guillemets doubles pour nommer une tâche qui contient une apostrophe
- name: "Affichage d'éléments du texte sur deux lignes"
  ansible.builtin.debug:
    msg: "Ce texte est sur\ndeux lignes."

# Bon exemple : utilisation d'un scalaire plié
- name: "Infos sur le robot"
  ansible.builtin.debug:
    msg: >
      Le robot {{ item['robot_name'] }} est actuellement
      {{ item['status'] }}. Il est situé dans la zone
      {{ item['az'] }} et possède le quotient de
      curiosité {{ item['curiosity_quotient'] }}.
  loop:
    - robots

# Bon exemple : scalaire plié lorsque la chaîne a déjà des guillemets imbriqués
- name: "Afficher du texte"
  debug:
    msg: >
      "Je n'en ai pas la moindre idée", dit le Chapelier.

# Bon exemple : ne pas citer les booléens et les chiffres
- name: "Télécharger la page Google"
  ansible.builtin.get_url:
    dest: '/tmp'
    timeout: 60
    url: 'https://google.com'
    validate_certs: true

# Bon exemple : définition d'une variable
- name: "Définir une variable"
  ansible.builtin.set_fact:
    ma_variable: 'test'

# Bon exemple : définition d'une variable #2
- name: "Afficher la valeur de ma_variable"
  ansible.builtin.debug:
    var: ma_variable
  when:
    - ansible_os_family == 'Darwin'

# Bon exemple : définition d'une variable #3
- name: "Définir une autre variable"
  set_fact:
    ma_seconde_variable: '{{ ma_variable }}'
```

> #### Pourquoi?
> Même si les chaînes de caractères sont le type par défaut de YAML, la coloration syntaxique est meilleure lorsque les types sont explicitement définis. Cela permet également de diagnostiquer plus aisément les chaînes malformées lorsqu'elles doivent être correctement échappées pour obtenir l'effet désiré.

## Booléens

Il y a plusieurs façons de spécifier une valeur booléenne dans ansible, `True/False`, `true/false`, `yes/no`, `1/0`. Bien qu'il soit agréable de voir toutes ces options, nous préférons nous en tenir à une seule : `true/false` à cause de `ansible-lint`.

```yaml
# Mauvais exemple
- name: "Démarre le sensu-client"
  become: true
  ansible.builtin.service:
    name: 'sensu-client'
    state: 'started'
    enabled: True

# Bon exemple
- name: "Démarre le sensu-client"
  become: true
  ansible.builtin.service:
    name: 'sensu-client'
    state: 'started'
    enabled: true
```

> #### Pourquoi?
> L'usage de `true/false`  plutôt que toutes autres a été choisie afin de mieux correspondre à `ansible-lint` malgré que la documentation officielle d'Ansible qui utilise `yes/no` comme nommenclature pour les variables booléennes.

## Paires clé-valeur

N'utilisez qu'un espace après les deux-points pour désigner une paire clé-valeur.

```yaml
# Mauvais exemple
- name : 'Démarre le sensu-client'
  become : true
  ansible.builtin.service:
    name    : 'sensu-client'
    state   : 'started'
    enabled : true

# Bon exemple
- name: "Démarre le sensu-client"
  become: true
  ansible.builtin.service:
    name: 'sensu-client'
    state: 'started'
    enabled: true
```

**Toujours utiliser la syntaxe de correspondance,** quel que soit le nombre de paires existant.

```yaml
# Mauvais exemples
- name: "Crée le répertoire checks"
  become: true
  ansible.builtin.file: 'path=/etc/sensu/conf.d/checks state=directory mode=0755 owner=sensu group=sensu'

- name: "Copier check-memory.json dans /etc/sensu/conf.d"
  become: true
  ansible.builtin.copy: 'dest=/etc/sensu/conf.d/checks/ src=checks/check-memory.json'

# Bons exemples
- name: "Crée le répertoire checks"
  become: true
  ansible.builtin.file:
    group: 'sensu'
    mode: '0755'
    owner: 'sensu'
    path: '/etc/sensu/conf.d/checks'
    state: 'directory'

- name: "Copier check-memory.json dans /etc/sensu/conf.d"
  become: true
  ansible.builtin.copy:
    dest: '/etc/sensu/conf.d/checks/'
    src: 'checks/check-memory.json'
```

> #### Pourquoi?
> C'est plus facile à lire et ce n'est pas difficile à faire. De plus, ça réduit les conflits lors de fusions de branches Git.

## Indempotence des playbooks

**L'idempotence des playbooks est un concept fondamental dans l'écriture de code Ansible.**

Lorsqu'un playbook est exécuté pour configurer un système, ce dernier doit toujours avoir le même état, bien défini. Si un playbook se compose de 10 étapes, et que le système s'écarte à l'étape 4 de l'état souhaité, seule cette étape particulière doit être appliquée.

> #### Pourquoi?
> L'exécution répétitive d'un playbook aboutit toujours à un état système bien défini et cohérent.

## Validation des variables

On utilise beaucoup les variables de rôles (`defaults` ou `vars`) et elles sont bien pratiques. Parfois, il n'est pas souhaitable de définir une valeur par défaut à une variable (car il n'y a pas de valeur appropriée) mais cette variable peut tout de même être obligatoire.

Plutôt que de laisser Ansible planter car une variable n'a pas été définie car nous avons oublié de définir une variable pour une nouvelle machine que nous sommes en train d'installer, il faut s'assurer de valider son existance dans les premières *tasks* du rôle à l'aide des assertions.

Exemple:

```yaml
- name: "controleurDeDomaine - Validation certificat ssl"
  ansible.builtin.assert:
    that:
      - 'samba_dc_tls_keyfile is defined'
      - 'samba_dc_tls_certfile is defined'
    fail_msg: "Le certificat SSL utilisé par Samba n'a pas été défini."
    quiet: true
```

Dans cet exemple, on affiche un message d'erreur clair dans l'éventualité où nous tentions de rouler le rôle samba sans définir de certificats SSL comme `hosts_var`.

## FQCN
Utilisez la nouvelle syntaxe FQCN (*Fully Qualified Collection Name*) pour indiquer quel module vous souhaitez utiliser.

> #### Pourquoi?
> Il est possible que, lorsque nous utilisons des rôles Galaxy, qu'un illuminé ailleurs sur terre utilise un nom identique à une autre classe. C'est particulièrement le cas lorsqu'un module "builtin" ne fait pas une chose (lire le pourquoi on doit parfois utiliser une `commande` au lieu d'un module). Or, un illuminé sur terre pourrait créer un rôle ou une colleciton contenant un module portant le même nom. Ainsi, par exemple, il devient difficile de différencier `lineinfile` fournit par Ansible et `lineinfile` fournit par cet illuminé.

```yaml
# Mauvais exemple
- name: "magnifique nom de tâche"
  lineinfile:
    dest: '/etc/sensu/conf.d/client.json'
    src: 'client.json.j2'

# Bon exemple
- name: "magnifique nom de tâche"
  ansible.builtin.lineinfile:
    dest: '/etc/sensu/conf.d/client.json'
    src: 'client.json.j2'

# Autre bon exemple
- name: "magnifique nom de tâche"
  community.nom_de_collection.lineinfile:
    dest: '/etc/sensu/conf.d/client.json'
    src: 'client.json.j2'
```

## Sudo
Utilisez la nouvelle syntaxe `become` pour indiquer qu'une tâche doit être exécutée avec les privilèges `sudo`.

```yaml
# Mauvais exemple
- name: "Copie client.json dans /etc/sensu/conf.d/"
  sudo: true
  ansible.builtin.template:
    dest: '/etc/sensu/conf.d/client.json'
    src: 'client.json.j2'

# Bon exemple
- name: "Copie client.json dans /etc/sensu/conf.d/"
  become: true
  ansible.builtin.template:
    dest: '/etc/sensu/conf.d/client.json'
    src: 'client.json.j2'
```

> #### Pourquoi?
> L'utilisation de `sudo` a été dépréciée dans la version  [version 1.9.1](https://docs.ansible.com/ansible/latest/user_guide/become.html) d'Ansible.

## Déclaration d'hôtes

Les sections `hosts` doivent suivre cet ordre général :

1. Déclaration des hôtes
1. Définition des options d'hôtes
1. Bloc de variables
1. Bloc de *pre_tasks*
1. Bloc de *roles*
1. Bloc de *tasks*

```yaml
# Exemple
- name: "Nom"
  hosts: 'webservers'
  remote_user: 'ansible'

  vars:
    tomcat_state: 'started'

  pre_tasks:
    - name: "Défini le fuseau horaire"
      become: true
      ansible.builtin.lineinfile:
        dest: '/etc/environment'
        line: 'TZ=America/Toronto'
        state: 'present'

  roles:
    - { role: 'apache' }

  tasks:
    - name: "start the apache service"
      ansible.builtin.service:
        name: 'apache'
        state: '{{ apache_state }}'
```

> #### Pourquoi?
> Une définition correcte de la manière d'ordonner ces éléments produit un code cohérent et facilement lisible.

## Déclaration d'include

Pour les déclarations `include`, assurez-vous de citer les noms de fichiers et d'utiliser des lignes vides entre les déclarations `include` uniquement si elles sont multi-lignes.

```yaml
# Mauvais exemple
- ansible.builtin.include: autre_fichier.yml

- ansible.builtin.include: 'second_fichier.yml'

- ansible.builtin.include: troisieme_fichier.yml tags=troisieme

# Bon exemple
- ansible.builtin.include: 'autre_fichier.yml'
- ansible.builtin.include: 'second_fichier.yml'

- ansible.builtin.include: 'troisieme_fichier.yml'
  tags: 'troisieme'
```

> #### Pourquoi?
> C'est généralement la façon la plus lisible d'avoir des déclarations `include` dans votre code.

## Éviter l'utilisation des commandes

On considère comme des `commandes` l'utilisation des modules `command`, `shell`, `raw` et `script` qui permettent aux utilisateurs d'effectuer des opérations en ligne de commande de différentes manières.  Elles constituent un excellent mécanisme polyvalent pour faire avancer les choses rapidement, mais elles doivent être utilisées avec parcimonie **et en dernier recours uniquement**.

Toujours rechercher s'il n'y a pas un module natif pour faire ce que vous tentez de faire avant d'utiliser une commande.

La définition de "dernier recours" devrait correspondre à:
- il n'existe pas de module pour faire ce que je fais
- le module existe mais ne contient pas l'option (la `switch`) dont j'ai besoin
- aucun rôle/collection Galaxy simple n'a été trouvé(e) pour résoudre le souci

L'utilisation de ces modules doit être justifiée par un commentaire au dessus de son utilisation expliquant la raison pourquoi il est utilisé.

> #### Pourquoi?
> La surutilisation des commandes d'exécution est souvent un symptôme de TL;DR dans Ansible et est fréquente chez ceux qui commencent à se familiariser avec Ansible pour automatiser leur travail. Ils utilisent le `shell` pour lancer une commande bash qu'ils connaissent déjà sans s'arrêter pour regarder la documentation Ansible. Cela fonctionne assez bien au début, mais cela sape la valeur de l'automatisation avec Ansible et crée des problèmes par la suite.

La chose la plus importante à considérer est que ces commandes d'exécutions ont peu de logique et aucun concept d'état souhaité comme un module Ansible typique. Il est aussi plutôt compliqué de garder ces commandes indempotentes.

Cette commande `shell` qui a réussi la première fois que vous avez exécuté votre playbook peut échouer la fois suivante lorsque quelque chose existe déjà. À moins que vous n'utilisez l'option *ignore_errors* (et là vous serez victime d'un coup de pied dans la tête par un collègue !) sur cette tâche mais alors comment attraper une véritable erreur? Comme des permissions erronées par exemple. Vous devez maintenant enregistrer le résultat de cette première commande et la faire suivre dans une autre tâche qui implémente une logique conditionnelle pour vérifier si une erreur s'est produite puis la traiter. On ne souhaite pas ça ! Et les coups de pieds sont trop douloureux !

## Convention de nommage

Il est important de bien nommer les différents objets, que ce soit un nom de variable, rôle, groupe ou hôte.

> ### Pourquoi ?
> Les configurations Ansible peuvent définir des centaines d'objets, qui peuvent être modifiés pour personnaliser la configuration. Lors de l'utilisation d'Ansible à grande échelle, il est important de respecter les conventions de nommage pour pouvoir travailler facilement avec autant d'objets.

## Ordonnancement des modules et valeurs clefs paires

### ``become: true``
Il est important de toujours nommer une tâche nous l'avons vu. Mais parfois, il arrive que nous devions utiliser une élévation de privilèges afin d'accomplir une tâche. Il est important alors de disposer le `become: true` entre la tâche et le nom du module.

> ### Pourquoi ?
> Ceci a pour effet de documenter le lecteur rapidement que la tâche en cours est réalisée avec élévation de privilège. Il est moche de lire plusieurs lignes de code avant de trouver un obscure `become: true` beaucoup plus bas.

```yaml
# mauvaise représentation de l'ordonnancement
- name: "Magnifique tâche"
  ansible.builtin.module:
    clef1: 'valeur'
    clef2: 'valeur'
    clef3: 'valeur'
    clef4: 'valeur'
    clef5: 'valeur'
    clef6: 'valeur'
    clef7: 'valeur'
    clef8: 'valeur'
    clef9: 'valeur'
  become: true

# bonne représentation de l'ordonnancement
- name: "Magnifique tâche"
  become: true
  ansible.builtin.module:
    clef1: 'valeur'
    clef2: 'valeur'
    clef3: 'valeur'
    clef4: 'valeur'
    clef5: 'valeur'
    clef6: 'valeur'
    clef7: 'valeur'
    clef8: 'valeur'
    clef9: 'valeur'
```
> Note: Si un become_user est requis, il doit immédiatement suivre le `become: true` afin de clarifier tout de suite de quelle élévation de privilège il s'agisse.

```yaml
# bonne représentation de l'ordonnancement
- name: "Magnifique tâche"
  become: true
  become_user: 'postgres'
  ansible.builtin.module:
    clef1: 'valeur'
```

### ``loop:``

On doit toujours indiquer la `loop` immédiatement après la dernière clef/valeur du module.

```yaml
# mauvaise représentation de l'ordonnancement
- name: "Magnifique tâche"
  become: true
  loop: __autant_de_fois_que_requis
  ansible.builtin.module:
    clef1: 'valeur'
    derniere_clef: 'valeur'

# bonne représentation de l'ordonnancement
- name: "Magnifique tâche"
  become: true
  ansible.builtin.module:
    clef1: 'valeur'
    derniere_clef: 'valeur'
  loop: __autant_de_fois_que_requis
```

### ``when:``
### Prise 1

On doit toujours indiquer la condition `when` à la toute fin de la tâche.

```yaml
# mauvaise représentation de l'ordonnancement
- name: "Magnifique tâche"
  become: true
  ansible.builtin.module:
    clef1: 'valeur'
    derniere_clef: 'valeur'
  when:
    - magnifique_condition
  loop: __autant_de_fois_que_requis

# bonne représentation de l'ordonnancement
- name: "Magnifique tâche"
  become: true
  ansible.builtin.module:
    clef1: 'valeur'
    derniere_clef: 'valeur'
  loop: __autant_de_fois_que_requis
  when:
    - magnifique_condition
```

### Prise 2

On doit toujours indiquer la condition `when` au tout début d'un `ansible.builtin.block` après le `name`

```yaml
# mauvaise représentation de l'ordonnancement
- name: "Magnifique tâche"
  ansible.builtin.block:
    clef1: 'valeur'
    derniere_clef: 'valeur'
    ...
    coupure d'un milliard six cent millions de lignes de code qui font que l'on a de la difficulté à bien se représenter l'alignement de la clause when avec le bloc ou une autre tâche
    ...
  when:
    - magnifique_condition

# bonne représentation de l'ordonnancement
- name: "Magnifique tâche"
  when:
    - magnifique_condition
  ansible.builtin.module:
    clef1: 'valeur'
    derniere_clef: 'valeur'
```

### ``register: __nom_de_variable``

Le `register` est la dernière chose que nous indiquons dans une tâche.
```yaml
# mauvaise représentation de l'ordonnancement
- name: "Magnifique tâche"
  become: true
  ansible.builtin.module:
    clef1: 'valeur'
    derniere_clef: 'valeur'
  register: __magnifique_variable
  when:
    - magnifique_condition
  loop: __autant_de_fois_que_requis

# bonne représentation de l'ordonnancement
- name: "Magnifique tâche"
  become: true
  ansible.builtin.module:
    clef1: 'valeur'
    derniere_clef: 'valeur'
  loop: __autant_de_fois_que_requis
  when:
    - magnifique_condition
  register: __magnifique_variable
```

## Code conditionnel

### Éviter d'exclure des tâches basé sur le *check mode*

Autant que possible, éviter d'exclure l'exécution d'une tâche basé sur la condition `ansible_check_mode`. Souvent, il est possible de programmer la tâche afin qu'elle n'échoue pas en mode check plutôt que de la sauter complètement. Comme exemple, si on doit faire un `lineinfile` dans un fichier qui n'existe pas puisque nous avons "installé en check mode" un paquet, il est préférable, juste avant la tâche qui "fatal" à cause de l'absence du fichier... De créer une tâche qui vérifie si le fichier existe et sauter conditionnellement la tâche qui fatal si le fichier n'est pas présent.

```yaml
- name: "Est-ce que java est installé déjà (pour indempotence sinon ca crash path not found)"
  become: true
  ansible.builtin.stat:
    path: "/chemin/vers/mon/fichier/qui/devrait/exister"
  register: __java_installed

- name: "Configurer le /usr/bin/java -> /etc/alternatives/java"
  become: true
  ansible.builtin.alternatives:
    name: 'java'
    path: '{{ /chemin/vers/mon/fichier/qui/devrait/exister }}'
  when:
    - __java_installed.stat.exists
```

> #### Pourquoi?
> On roule les playbooks en *check mode* pour évaluer les changements avant de rouler pour de vrai. En aillant des tâches qui sont tout simplement ignorées à cause de cette condition, on peut se retrouver à effectuer un changement qu'on avait pas venu venir.

### Clauses `when` sur des lignes subséquentes indentées

Chaque clause `when` doit être sur sa propre ligne convenablement indentée pour accentuer la facilité à lire les conditions `ET` par rapport à `OU`.

```yaml
# mauvaise gestion ET
when: (magnifiquer_condition | bool) and (autre_condition)

# saine gestion ET
when:
  - magnifiquer_condition | bool
  - autre_condition

# mauvaise gestion OU
when: (magnifiquer_condition | bool) or (autre_condition)

# saine gestion OU
when:
  - (magnifiquer_condition | bool) or (autre_condition)

# mauvaise gestion ET/OU
when: ((magnifiquer_condition | bool) or (autre_condition)) and (encore_autre_condition)

# saine gestion ET/OU
when:
  - encore_autre_condition
  - (magnifiquer_condition | bool) or (autre_condition)
```

### Priorité des conditions

Lorsque possible, avec l'utilisation unique de clauses `ET`, il faut ordonner les clauses dans l'ordre de priorité avec lesquelles elles peuvent échouer.

Il peut arriver que, lorsque l'on exécute un livre de jeu Ansible en mode `--check`, que nous obtenions une erreur sur un dossier devant exister puisque créé à l'étape précédente. Dans untel cas, la clause d'exception `--check` doit être la première.

```yaml
# mauvaise gestion d'exception
- name: "nom de ma magnifique tâche"
  ansible.builtin.module:
    clef: 'valeur'
  when:
    - mon_magnifique_dossier_existe.stat.exists
    # souvenez-vous du coup de pied dans la tête avec ansible_check_mode
    - not ansible_check_mode

# saine gestion d'exception
- name: "nom de ma magnifique tâche"
  ansible.builtin.module:
    clef: 'valeur'
  when:
    # souvenez-vous du coup de pied dans la tête avec ansible_check_mode
    - not ansible_check_mode
    - mon_magnifique_dossier_existe.stat.exists
```

> #### Pourquoi?
> L'exécution de la mauvaise gestion d'exception ci-dessus résultera en un `FATAL` qui mettra fin au livre de jeu Ansible alors que l'autre non. Ansible se butera à la première condition, qui sera mauvaise, et sortira de sa vérification sans poursuivre avec les clauses subséquentes.

### Nom des variables

Toutes les variables Ansible doivent être nommées pour permettre aux développeurs de trouver facilement où elles ont été définies et pour éviter les collisions de noms. En regardant uniquement le nom, il devrait être possible de savoir dans quel(s) fichier(s) la variable a été définie, sans faux positifs.

Etant donné qu'Ansible ne possède pas de concepte de *namespace*, nous utilisons une convention de nommage.

Les noms des variables doivent être :

* Descriptif et ne pas utiliser d'acronymes ou d'abréviations obscures.
* Toujours en snake_case (c'est-à-dire `mon_exemple_de_variable`).
* Préfixer avec le rôle/groupe/play auquel la variable appartient. Par exemple, les variables pour le rôle `apache` doivent être sous la forme `apache_*`, comme `apache_version`, `apache_ssl_key_file`).
* Commencer par `_` si elles sont destinées à être réservées au rôle (les variables réservées doivent toujours suivre toutes les autres règles).
* Commencer par `__` (deux soulignements) si elles sont destinées à être privées au **fichier courant** (les variables privées doivent toujours suivre toutes les autres règles). C'est très souvent le cas des variables enregistrées ou encore les `register: __nom_de_variable` puisque nous enregistrons souvent le résultat d'une tâche afin d'en utiliser le contenu rapidement dans la ou les tâche(s) qui suit(vent).
* Commencer par "ls" si la variable est utilisée dans plusieurs rôle et non seulement un seul.

```yaml
# définition dans un defaults/main ou un vars/main ou un group_vars/hosts_vars pour une variable de rôle
rundeck_user: 'nom'

# définition dans un defaults/main ou un vars/main mais NON un group_vars/hosts_vars pour une variable de rôle
# si on place ca dans un group_vars ou un hosts_vars, on est "sorti" du rôle
_rundeck_user: 'nom'

# définition pour une variable utilisée seulement dans le fichier actuel
# n'allez pas voir dans les defaults/main, vars/main, ni nulle part ailleurs que dans le fichier courant
__rundeck_user: 'nom'
```

#### Suffixes aux noms de variables

Un exemple de suffixe qui est fréquemement utilisé et qui fait plus de sens si on le standardise est "..._par_os" (notez qu'il n'y a pas de majuscule à *OS* - ansible-lint n'aime pas ça). Si, par exemple, nous avons une variable de chemin de répertoire qui peut varier en fonction du système d'exploitation, il serait tout indiqué de créer le nom de la variable en français, suffixée convenablement.

```yaml
# Zabbix configuration variables
zabbix_agent_logfile_folder_par_os:
  Ubuntu: '/var/log/zabbix'
  Debian: '/var/log/zabbix'
  FreeBSD: '/mnt/pool0/home/zabbix'
zabbix_agent_pidfile: '{{ zabbix_agent_logfile_folder_par_os[ansible_os_family] }}/zabbix_agentd.pid'
```

> #### Pourquoi?
> Ceci nous évite d'avoir trois variables correspondant à trois blocs de tâche pour trois OSs avec gestion de conditionnelles `when` pour chacun. Nous avons un seul bloc de tâches identiques qui produit un résultat différent en fonction du système

### Nom des rôles

Les noms de rôles doivent être :

* Descriptif et ne pas inclure d'acronymes ou abréviations obscure.
* Utiliser le kebab-case (exemple `mon-role`).

Afin de respecter les conventions de nommage, de disposition de dossiers et autres considérations, vous devez utiliser la script `outils/createRole/createRole.sh` en exécutant la commande au niveau du dossier contenant `ansible.cfg`. L'exécution du script sans paramètres vous fournira les instructions d'utilisation.

### Nom des groupes

Les noms de groupes doivent être :

* Descriptif et ne pas inclure d'acronymes ou abréviations obscure.
* Utiliser le camelCase (exemple `monGroupe`) ou le snake-case (exemple `mon_groupe`).

### Nom d'hôtes

Le nom d'hôte doit correspondre au *FQDN* du serveur utilisé chez LS (exemple: `bastion.legal-suite.ca`).

## Emplacement des variables

L'emplacement où sont définies les variables dans Ansible est très important en raison de [son système d'héritage de variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#understanding-variable-precedence).

### Résumé de l'ordre d'héritage des variables

| Emplacement            | Héritage       |
| -----------------------|----------------|
| rôle defaults          | hyper faible   |
| inventaire group vars  | super faible   |
| inventaire host vars   | plutôt faible  |
| play vars              | faible         |
| rôle vars              | moyen          |
| included vars          | fort           |
| set_fact               | pas mal fort   |
| extra-vars             | Dieu sur terre |

### Définition de variables de rôle

Les variables définies dans un rôle servent à définir des valeurs par défaut qui peuvent être ou ne pas être redéfinies, selon l'emplacement où on l'a intialisé.

* Les valeurs par défaut de variables *qui ne sont pas appelées* à changer doivent aller dans `vars/main.yml` (*rôle vars*). On peut considérer ces variables comme des constantes dont la valeur ne peut être modifiée ailleurs.
* Les valeurs par défaut de variables *qui sont appelées à changer* doivent aller dans `defaults/main.yml` (*rôle defaults*).

Il arrive qu'une variable ne puisse pas avoir de valeur par défaut qui aille un sens et pour laquelle sa valeur doit obligatoirement être définie ailleurs (par exemple dans un *host vars*). Dans ce cas, il ne faut pas la définir en tant que variable de rôle du tout.

Cela évite de laisser un valeur par défaut qui n'a pas de sens et force le développeur à définir sa variable à chaque utilisation du rôle.

> #### Pourquoi?
> Voici un exemple. L'adresse du serveur zabbix de l'entreprise est généralement la même pour tous les serveurs sauf dans de rares exceptions. La variable suivante devrait donc être déclarée dans *roles/zabbix-agent/default/main.yml* puisqu'elle est appelée à changer pour les hôtes sur lesquels nous exécutons des tests.

Pour un hôte en production, dans *roles/zabbix-agent/default/main.yml*:
```yaml
zabbix_url_presence: 'prod' # valeurs possible= devl, test, acpt, prod, all - sert à initier le host dans 1, l'autre pu les deux serveurs zabbix
```

Dans le cas spécial où un serveur ésotérique devait être surveillé par le serveur zabbix de dev pour des raisons de développement et de tests, alors la valeur de `zabbix_url_presence` pourrait être ré-écrite en tant que *host vars* du serveur en question, dans *inventaire/hosts_vers/bastion.legal-suite.ca.yml*

```yaml
zabbix_url_presence: 'both' # valeurs possible= devl, test, acpt, prod, all - sert à initier le host dans 1, l'autre pu les deux serveurs zabbix
```

Dans un autre cas où nous voudrions changer temporairement la valeur pour tous les serveurs (exemple de maintenance dans le zabbix de prod), alors on aurait seulement à modifier la valeur définie dans le *roles/zabbix-agent/default/main.yml* afin qu'elle s'applique à tous les serveurs.

> Actuellement, beaucoup de variables sont, à tort, définies dans *inventaire/group_vars/all/main.yml* et devront être déplacées dans leurs rôles respectifs, **sauf en cas d'utilisation multi-roles**.

## Commentaires et documentation

* Les commentaires explicatifs sont fortement encouragés. Une règle générale est que si vous regardez une section de code et vous vous dites "ouf, je ne souhaite pas devoir comprendre comment ça marche!", vous devez la commenter immédiatement avant d'oublier comment elle fonctionne.

* Pour des raisons de lisibilité, les commentaires doivent comporter un seul espace après le mot "#".

  ```yaml
  # Un bon commentaire.
  - name: "Magnifique nom de tâche"
    ansible.builtin.magnifiquemodule:

  #Un mauvais commentaire
  - name: "Magnifique nom de tâche"
    ansible.builtin.magnifiquemodule:

  #    Un autre mauvais commentaire
  - name: "Magnifique nom de tâche"
    ansible.builtin.magnifiquemodule:

  #  Encore un mauvais exemple de commentaire!
  - name: "Magnifique nom de tâche"
    ansible.builtin.magnifiquemodule:
  ```

* Il doit toujours y avoir une ligne vide au-dessus du début d'un bloc de commentaires.

  ```yaml
  # C'est mon code.
  key: commande_ansible

  # Encore plus de code
  key: autre_commande_ansible
  ```

* Pour les commentaires en ligne (par exemple, la mise en commentaire d'une ligne), le commentaire DOIT commencer après l'indentation appropriée, en faisant précéder la ligne d'un "`# `" (dièse espace). Vous ne devez pas ajouter un `#` au début d'une ligne, sans tenir compte de l'indentation.

  ```yaml
  # Mauvais exemple
  abc:
    def:
  #    - 123
      - 456
      - 789

  # Bon exemple
  abc:
    def:
      # - 123
      - 456
      - 789
  ```

Chaque rôle doit être acompagné de son fichier `README.md` documentant l'usage prévu du rôle et toute autre information qui pourrait être utile à un autre membre de l'équipe pour comprendre le fonctionnement du rôle.

## Langue

La langue de rédaction est le français. Ceci s'applique autant aux commentaires, au nommage d'une *task* qu'aux noms de variables. Dans le cas d'un nom de variable, il est toutefois justifié d'utiliser l'anglais lorsque cela fait plus de sens.

Le code Ansible provenant d'Ansible Galaxy peut demeurer en anglais, la traduction du code n'est pas requise.

## To merge or not to merge, là est la question

### Un ``README.md`` non modifié
Dans le cas d'un ``README.md`` non modifié, on ne devrait jamais merger.

> ### Pourquoi?
> Je crois qu'il est simple de penser comment un manque total de documentation dans le code pourrait ne pas bien servir les intérêts de l'entreprise.

### Une typo de variable
Dans le cas d'une typo n'empêchant pas le code de fonctionner sans souci immédiat ou projeté, ni même de souci de lisibilité, on devrait merger. Certes il est préférable de ne pas avoir de typo dans notre code que l'on `ansible-lint` de façon aussi intense. Cependant, une typo dans un nom de tâche n'a pas le même impact qu'un nom de variable pouvant porter à confusion.

> ### Pourquoi?
> Dans certains cas comme une typo dans un nom de variable, surtout lorsque la typo est répétée partout et que celle-ci ne rend pas le code illisible, il est beaucoup plus `économique` et `humain` de merger. Il est préférable de merger une typo que de se rendre coupable de `volonté de perfection` et ainsi possiblement causer des MR qui durent dans le temps et qui, à terme, pourraient causer des conflits. Certains cas peuvent aussi forcer des gens à devoir faire des ``rebase``, ce qui peut éventuellement générer encore plus de confits. Pire encore, un cas extrême pourrait forcer un cas de `cherry picking`, ce qui peut avoir des répercussions des mois, voire des années après le merge.

  ```yaml
  # Mauvais exemple que l'on doit merger
  - name: "Magnifique nom de magnifque tâche"
    ansible.builtin.exemple:

  # Mauvais exemple que l'on doit merger
  _nom_de_varaible_typo_tout_de_meme_lisible:
    - 456
    - 789

  # Utilisation correcte de la typo
  loop: '{{ _nom_de_varaible_typo_tout_de_meme_lisible }}'

  # Mauvais exemple que l'on NE DOIT PAS merger
  _nom_de_varaible_typo_tout_de_meme_lisible:
    - 456
    - 789

  # Utilisation INCORRECTE de la typo
  loop: '{{ _nom_de_variable_typo_tout_de_meme_lisible }}'

  # Mauvais exemple que l'on NE DOIT PAS merger - cette typo est trop proche de la logique du code pour pouvoir être tolérée
  _non_de_varaible: true
  _non_de_varaible: false

  # Bon exemple que l'on doit merger
  _nom_de_varaible: true
  _nom_de_varaible: false
```

### Du code fonctionnel sans danger imminent immédiat
Il est possible que Magnifique_Sysadmin_Numéro_Un aie codé un truc qui est tout à fait fonctionnel et qui aurait pu l'être différemment selon Magnifique_Sysadmin_Numéro_Deux. Certes il existe la notion de code incomplet ou d'oubli pur et simple de cas de figure dans le code. Mais dans le cas ou là logique du code est complète, qu'elle ne risque pas de causer de souci immédiat ou encore un souci connu d'avance, il est préférable de merger et éventuellement de créer un `todo` en ouvrant un billet à être traité plus tard dans le `backlog`.

> ### Pourquoi?
> Si l'on regarde des grosses MR, celles qui ont un grand risque de voir s'accumuler les typos, celles-là qui aussi pourraient voir plusieurs façons de compléter le même travail, il est possible que l'incessant `balai des aller-retour` de `threads` dans le billet Gitlab devienne un cas de découragement (ou encore d'autres sentiments humains normaux après 15 retour d'approbation). Le code doit être `propre` et simple à lire afin d'alléger sa maintenance et son évolution. Il faut considérer les impacts potentiels d'aller au point de la perfection et au-delà versus les impacts humains d'une décision... Ou d'une autre.

### Un `merge` dans une conformité mature ou immature
Il faut aussi considérer qu'il peut être plus ardu de prévoir tous les cas de figure le jour 1 de la création d'un nouveau rôle. Il pourrait être préférable, dans une conformité naissante, ou encore lors de l'apparition d'un tout nouveau rôle à une date ultérieure, de prévoir merger plus rapidement au profit de la création de billets de `backlog` et ainsi permettre une vélocité plus grande dans les livrables.
