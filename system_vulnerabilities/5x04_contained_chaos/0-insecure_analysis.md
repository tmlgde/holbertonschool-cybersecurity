# Analyse de sécurité du Dockerfile de DevStream

## Introduction

Le Dockerfile de DevStream contient plusieurs failles de sécurité qui exposent l'application, la base de données et potentiellement la machine hôte à des attaques.

Cette analyse présente les huit vulnérabilités les plus importantes, leurs dangers et les méthodes d'exploitation possibles.

## 1. Exécution en tant que root

**Gravité : Critique**

**Problème :** Le Dockerfile ne définit aucun utilisateur spécifique avec l'instruction `USER`. L'application s'exécute donc en tant que root par défaut.

**Danger :** Si l'application est compromise, l'attaquant obtient des privilèges élevés dans le conteneur.

**Exploitation :** L'attaquant peut lire ou modifier des fichiers sensibles et exploiter d'autres mauvaises configurations pour tenter de compromettre la machine hôte.

## 2. Identifiants de base de données en dur

**Gravité : Critique**

**Problème :** Le nom d'utilisateur et le mot de passe de la base de données sont directement définis dans le Dockerfile avec `ENV`.

**Danger :** Ces informations peuvent être récupérées depuis la configuration du conteneur ou les métadonnées de l'image.

**Exploitation :** Après avoir compromis le conteneur, un attaquant peut récupérer les identifiants et tenter d'accéder aux données confidentielles de l'entreprise.

## 3. Mot de passe root codé en dur

**Gravité : Critique**

**Problème :** Le Dockerfile définit un mot de passe root fixe avec `chpasswd`.

**Danger :** Le mot de passe peut être retrouvé dans les couches ou l'historique de construction de l'image. Sa réutilisation augmente les risques.

**Exploitation :** Un attaquant ayant accès à l'image peut récupérer ce mot de passe et tenter de l'utiliser sur les systèmes où il serait accepté.

## 4. Utilisation du socket Docker

**Gravité : Critique**

**Problème :** Dans le contexte de l'incident, le socket Docker est monté dans le conteneur, même si cela n'apparaît pas dans le Dockerfile fourni.

**Danger :** L'accès au socket peut permettre de contrôler le démon Docker avec des privilèges élevés.

**Exploitation :** Un attaquant qui compromet l'application peut utiliser l'API Docker pour créer un conteneur privilégié et monter des répertoires de la machine hôte, ce qui peut conduire à une compromission de l'hôte.

## 5. Utilisation d'une image `ubuntu:latest`

**Gravité : Élevée**

**Problème :** L'image de base utilise le tag `latest`, qui ne fixe pas une version précise.

**Danger :** Les constructions peuvent produire des images différentes au fil du temps et introduire des changements ou vulnérabilités non vérifiés.

**Exploitation :** Une version ultérieure de l'image contenant une vulnérabilité peut être intégrée lors d'une nouvelle construction sans contrôle suffisant.

## 6. Copie de tous les fichiers du projet

**Gravité : Élevée**

**Problème :** L'instruction `COPY . /app` copie tout le contexte de construction, sans qu'un fichier `.dockerignore` soit montré.

**Danger :** Des fichiers sensibles comme `.env`, des clés privées ou l'historique Git peuvent être intégrés à l'image.

**Exploitation :** Une personne qui récupère l'image peut examiner les fichiers copiés et obtenir des secrets ou des informations confidentielles.

## 7. Installation de logiciels inutiles

**Gravité : Élevée**

**Problème :** Le Dockerfile installe des outils comme `curl`, `wget`, `sudo`, `gcc` et `make`, qui ne sont pas nécessairement utiles à l'exécution de l'application.

**Danger :** Ces logiciels augmentent la surface d'attaque et offrent des possibilités supplémentaires après une compromission.

**Exploitation :** Un attaquant peut utiliser ces outils pour télécharger des fichiers malveillants, explorer le réseau ou compiler du code dans le conteneur.

## 8. Utilisation d'un compte administrateur pour la base de données

**Gravité : Critique**

**Problème :** L'application utilise le compte `admin` pour se connecter à la base de données.

**Danger :** Ce compte possède potentiellement plus de droits que nécessaire, contrairement au principe du moindre privilège.

**Exploitation :** Si les identifiants sont volés, l'attaquant peut accéder aux données, les modifier ou les supprimer selon les permissions accordées au compte.

## Chaîne d'attaque

Un attaquant exploite d'abord une vulnérabilité de l'application Flask. Comme celle-ci s'exécute en root, il obtient des privilèges importants dans le conteneur. Il peut ensuite récupérer les identifiants de la base de données et accéder aux données sensibles avec le compte administrateur. Si le socket Docker est accessible, il peut tenter de créer un conteneur privilégié et de monter des répertoires de l'hôte, ce qui peut entraîner une compromission complète du système.

## Conclusion

Pour sécuriser ce Dockerfile, il faut exécuter l'application avec un utilisateur non privilégié, supprimer les secrets du Dockerfile, utiliser un compte de base de données limité, choisir une image maîtrisée et réduire les logiciels installés. Il faut également éviter de monter le socket Docker dans le conteneur sans nécessité absolue et renforcer les restrictions à l'exécution.
