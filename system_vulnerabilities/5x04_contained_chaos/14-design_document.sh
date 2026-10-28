# Environnement de développement Python sécurisé - Document de conception

## Présentation

Ce document décrit un environnement de développement Python conteneurisé pour
DevStream. Il applique les enseignements de l'audit de sécurité (tâches 0 à 13)
tout en restant confortable pour le travail quotidien. Un conteneur de
développement n'a pas les mêmes besoins qu'un conteneur de production (un shell,
des outils, du code modifiable) : chaque choix ci-dessous cherche l'équilibre
entre sécurité et confort du développeur.

## 1. Choix de l'image de base

**Choix :** `python:3.11-slim`

| Critère | Raison |
|---|---|
| Image officielle | Maintenue par Docker et la communauté Python, corrigée régulièrement |
| Minimale | Debian-slim : aucun paquet inutile, environ 5 fois plus légère qu'`ubuntu` |
| Compatible | glibc : pip installe des paquets précompilés, sans mauvaise surprise de compilation |
| Version fixée | Tag `3.11`, jamais `latest`, pour des builds reproductibles |

**Alternatives écartées :**

- `ubuntu:latest` : image généraliste, grande surface d'attaque, tag mobile
  (il a cassé le build de DevStream quand `latest` est passé à une nouvelle
  version d'Ubuntu).
- `alpine` : la bibliothèque musl pose des problèmes de compatibilité et ralentit
  les builds des paquets Python qui doivent être compilés.
- `distroless` : ni shell ni gestionnaire de paquets. Idéale en production, mais
  inutilisable pour du développement interactif.

Pour une reproductibilité maximale, l'image peut être fixée par son digest
(`python:3.11-slim@sha256:...`) et mise à jour à intervalles réguliers.

## 2. Outils inclus

Tous les outils sont fixés en version dans `requirements-dev.txt` et installés
dans un environnement virtuel (`/opt/venv`) pendant une étape de build dédiée.

| Outil | Rôle |
|---|---|
| `pytest`, `pytest-cov` | Tests unitaires et couverture de code |
| `ruff` | Linter et formateur (remplace flake8, isort et black) |
| `mypy` | Vérification statique des types |
| `bandit` | Linter de sécurité : détecte les pratiques dangereuses dans le code Python |
| `pip-audit` | Compare les dépendances aux vulnérabilités connues (CVE) |
| `git` | Gestion de versions depuis le conteneur |

Les outils qui analysent l'image tournent sur l'hôte ou dans la CI, pas dans le
conteneur : `hadolint` (linter de Dockerfile), `trivy` (scanner de
vulnérabilités d'images) et `docker-bench-security` (audit CIS Docker Benchmark).

**Volontairement exclus :** `gcc` et `make` (présents uniquement dans l'étape de
build), `sudo`, `curl`, `wget` et les outils réseau. Un développeur qui a besoin
d'un nouvel outil l'ajoute à `requirements-dev.txt` et reconstruit l'image :
l'environnement reste ainsi relu et reproductible.

## 3. Configuration de l'utilisateur

- Un utilisateur non-root `developer` est créé avec `groupadd` et `useradd`.
- **UID/GID 1000**, identique à l'utilisateur habituel de l'hôte. Contrairement
  à la production, c'est voulu : le code source est monté depuis l'hôte, et des
  identifiants identiques font que les fichiers créés dans le conteneur
  appartiennent au développeur sur sa machine, sans problème de permissions.
  L'UID est un argument de build (`ARG DEV_UID=1000`), pour que les développeurs
  ayant un autre UID puissent l'adapter.
- Shell de connexion `/bin/bash`, car les développeurs ont besoin d'un shell
  interactif.
- **Aucun mot de passe et pas de `sudo`** : il est impossible de devenir root
  depuis le conteneur.
- L'image se termine par `USER 1000:1000` (forme numérique, pour que les outils
  puissent vérifier qu'il ne s'agit pas de root).
- Les outils installés dans `/opt/venv` appartiennent à root : le développeur
  peut les utiliser mais pas les modifier.

## 4. Stratégie de volumes

| Montage | Destination | Mode | Raison |
|---|---|---|---|
| Dossier du projet | `/workspace` | lecture-écriture | Le code est modifié sur l'hôte et exécuté dans le conteneur ; les formateurs doivent pouvoir écrire |
| `tmpfs` | `/tmp` | `noexec,nosuid,size=256m` | Fichiers temporaires uniquement, effacés à l'arrêt |
| `tmpfs` | `/home/developer/.cache` | `nosuid,size=256m` | Caches des outils (pytest, mypy, ruff) |

**Jamais montés :**

- `/var/run/docker.sock` : donner le socket Docker à un conteneur revient à lui
  donner les droits root sur l'hôte. C'est exactement ainsi que l'attaquant de
  DevStream s'est échappé.
- `~/.ssh`, `~/.aws`, le dossier personnel entier ou `/` : une dépendance
  compromise volerait les identifiants du développeur.

Un fichier `.dockerignore` exclut `.git`, `.env`, `*.pem`, `*.key` et les caches
du contexte de build : ils ne peuvent jamais se retrouver dans une image.

## 5. Mesures de sécurité

| Mesure | Option | Problème de l'audit corrigé |
|---|---|---|
| Image de base officielle et minimale | `python:3.11-slim` | Ubuntu surchargée, tag `latest` |
| Build multi-stage | `FROM ... AS builder` | Outils de build dans l'image finale |
| Utilisateur non-root | `USER 1000:1000`, `--user` | Conteneur exécuté en root (CIS 4.1) |
| Aucun secret dans l'image | `--env-file` au lancement | Identifiants en dur |
| Toutes les capabilities retirées | `--cap-drop=ALL` | Capabilities inutiles (CIS 5.4) |
| Pas d'élévation de privilèges | `--security-opt=no-new-privileges:true` | Élévation via setuid (CIS 5.26) |
| Filtrage des appels système | Profil seccomp par défaut de Docker | Surface d'attaque du noyau (CIS 5.22) |
| Système de fichiers en lecture seule | `--read-only` + `tmpfs` | Dépôt d'outils, persistance (CIS 5.13) |
| Limites de ressources | `--memory`, `--cpus`, `--pids-limit` | Déni de service (CIS 5.11, 5.12, 5.29) |
| Ports limités à la machine locale | `-p 127.0.0.1:5000:5000` | Appli exposée au réseau (CIS 5.14) |
| Pas de socket Docker | jamais monté | Évasion du conteneur |

**Adaptations propres au développement :**

- Le dossier du projet est en lecture-écriture, puisque les développeurs doivent
  modifier le code. Le reste du système de fichiers reste en lecture seule.
- Les limites sont plus larges qu'en production (`--memory=1g`, `--cpus=2`,
  `--pids-limit=200`), pour lancer les tests et les outils confortablement.
- Le mode debug de Flask est autorisé en développement uniquement, et seulement
  sur `127.0.0.1` : son débogueur interactif permet d'exécuter du code à
  distance. Il ne doit jamais être joignable depuis le réseau, ni activé en
  production.

**Contrôles continus :** `hadolint` à chaque modification d'un Dockerfile,
`trivy` et `pip-audit` à chaque build, `docker-bench-security` régulièrement.

## 6. Expérience développeur

Un script `dev.sh` regroupe les longues commandes `docker`, pour que les
développeurs n'aient jamais à retenir (ni à oublier) les options de sécurité :

| Commande | Action |
|---|---|
| `./dev.sh build` | Construit l'image de développement |
| `./dev.sh shell` | Ouvre un shell interactif durci dans `/workspace` |
| `./dev.sh run` | Lance l'appli sur `http://127.0.0.1:5000` |
| `./dev.sh test` | Lance `pytest` avec la couverture de code |
| `./dev.sh lint` | Lance `ruff`, `mypy` et `bandit` |
| `./dev.sh audit` | Lance `pip-audit` sur les dépendances |

**Secrets :** chaque développeur garde un fichier `.env` local (`chmod 600`,
listé dans `.gitignore` et `.dockerignore`), passé avec `--env-file .env`. Un
fichier `.env.example` avec de fausses valeurs documente les variables attendues.

**Méthode de travail :**

1. Modifier le code sur l'hôte, avec n'importe quel éditeur.
2. Lancer `./dev.sh test` et `./dev.sh lint` dans le conteneur.
3. Commiter : les mêmes vérifications sont relancées dans la CI.

**Pourquoi c'est important :** une sécurité qui gêne finit par être contournée.
Si lancer le conteneur durci tient en une commande courte, les développeurs
n'ont aucune raison de revenir à `docker run --privileged` ou de tout faire
tourner en root « parce que c'est plus simple », exactement ce qui a mené à la
compromission de DevStream.
