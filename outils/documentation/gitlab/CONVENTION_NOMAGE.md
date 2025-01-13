# Convention de nomage des branches

- [Convention de nomage des branches](#convention-de-nomage-des-branches)
- [Préfixes autorisés par regexp](#préfixes-autorisés-par-regexp)
- [Créer une branche+MR](#créer-une-branchemr)
  - [Directement à partir de Gitlab](#directement-à-partir-de-gitlab)
    - [Créer une branche+MR "ISSUE" à partir de Gitlab pour aller ensuite travailler dans VSCode](#créer-une-branchemr-issue-à-partir-de-gitlab-pour-aller-ensuite-travailler-dans-vscode)
    - [Moi je veux créer une branche+MR autre que "ISSUE" à partir de Gitlab pour aller ensuite travailler dans VSCode](#moi-je-veux-créer-une-branchemr-autre-que-issue-à-partir-de-gitlab-pour-aller-ensuite-travailler-dans-vscode)
  - [Directement à partir de VSCode](#directement-à-partir-de-vscode)
    - [Attention de ne pas brancher du vieux code](#attention-de-ne-pas-brancher-du-vieux-code)

# Préfixes autorisés par regexp

Afin de rendre encore plus rapide l'étude du code et l'approbation par pairs de ce dernier, nous avons cru bon d'instaurer des `push rules` sur les noms des branches.

Ainsi, elles doivents répondre à l'expression régulière suivante : `(bugfix|doc|feature|hotfix|issue|rewrite)-\/*`

Voici quelques exemples valables:
```yaml
bugfix-changement-de-nom-de-bd
doc-ajout-documentation-sujet-abc
feature-ajout-index-table-machin
hotfix-changement-dns-local-pour-haproxy
issue-9-titre (auto-généré lorsque l'on branche directement de Gitlab)
rewrite-convertgitlabir-yes-en-true
```

> ### Pourquoi?
> Chaque magnifique_admin_numéro_X n'étudie pas ses MR de la même manière et il incombe à l'auteur d'une branche de bien dire ce qu'il y ajoutera comme code.
>
> Ainsi, si je suis en train d'approuver une branche `doc-ajout-documentation-sujet-abc`, je vais porter une attention différente que si je dois approuver un `hotfix-changement-dns-local-pour-haproxy`. Qui plus est, si je regarde une `issue-9-titre`, je sais que pour de plus amples détails, je peux consulter Gitlab, dans ce projet, billet #9.

# Créer une branche+MR

## Directement à partir de Gitlab

### Créer une branche+MR "ISSUE" à partir de Gitlab pour aller ensuite travailler dans VSCode

Pour ce faire, il vous faut créer un billet. Par la suite, lorsque vous cliquez sur le bouton bleu `Create merge request`, vous aurez immédiatement une branche correctement intitulée `issue-numero-titre`.

### Moi je veux créer une branche+MR autre que "ISSUE" à partir de Gitlab pour aller ensuite travailler dans VSCode

Au lieu de cliquer le bouton `Create merge request`, il vous suffit de cliquer la petite flèche dans le bouton à droite et remplacer `issue` par votre choix. Ceci autant que votre choix respecte la regexp ci-dessus.

Exemple :

Si vous avez le billet #1 ayant `Corriger DNS` comme titre et que:
- vous cliquez le bouton `Create merge request`, votre branche s'appellera automatiquement `issue-1-corriger-dns`
- vous cliquez la petite flèche du boutton `Create merge request`, il vous sera présenté `issue-1-corriger-dns` et vous pourrez remplacer `issue` par un des mots clefs permis ci-dessus.

## Directement à partir de VSCode

Vous pouvez utiliser la barre d'état pour créer une branche à partir de...

Ou encore, à l'aide du menu de commandes (ctrl-shift-p), il vous est possible de tapper `create branch from` et faire `enter`. Vous allez devoir, par vous même, manuellement entrer un des mots clefs permis. Il vous sera demandé de ne pas utiliser `issue` qui lui est réservé à ce pourquoi nous avons un billet Gitlab en amont.

### Attention de ne pas brancher du vieux code

Si vous souhaitez faire une branche rapidement directement sur VSCode, il ne faut pas oublier de retourner sur la branche `main` et réaliser un `git pull` avant. En foi de quoi vous auriez une branche crée à partir de main, mais sans tirer toutes les mises-à-jour du repo.
