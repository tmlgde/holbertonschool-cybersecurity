# Linux Hardening — Sécurisation d’un serveur

## Introduction

Ce projet consiste à renforcer la sécurité d’un serveur Linux afin de réduire sa surface d’attaque avant son exposition directe à Internet. L’objectif est d’appliquer des mesures de durcissement (*hardening*) pour limiter les risques liés aux vulnérabilités inconnues, aux mauvaises configurations et aux privilèges excessifs.

## Contexte

Vous travaillez comme ingénieur en sécurité chez **CyberShield Consulting**, pour le client **NovaTech Solutions**.

Après les projets précédents, le serveur est désormais corrigé et fonctionnel. Cependant, il doit être déplacé dans une **DMZ (zone démilitarisée)** afin d’héberger un serveur web accessible depuis Internet.

Le serveur Ubuntu possède encore plusieurs faiblesses : outils de développement inutiles, paramètres réseau permissifs, nombreux exécutables SUID et répertoires temporaires autorisant l’exécution de code.

Votre mission est de transformer ce serveur en **Bastion Host**, tout en maintenant le fonctionnement d’Apache et l’accès SSH.

## Objectifs

- **Auditer le système** : établir un état initial de la sécurité avec Lynis.
- **Sécuriser le noyau** : configurer `sysctl` pour limiter les attaques réseau.
- **Réduire la surface d’attaque** : supprimer ou restreindre les logiciels inutiles.
- **Gérer les privilèges** : analyser les binaires SUID/SGID et limiter les privilèges excessifs.
- **Sécuriser les systèmes de fichiers** : appliquer les options `noexec`, `nosuid` et `nodev` aux répertoires concernés.
- **Respecter les normes** : appliquer les recommandations des CIS Benchmarks.
- **Documenter les changements** : justifier chaque mesure et produire un rapport de conformité.

## Notions à maîtriser

- Fonctionnement de `sysctl` et des paramètres du noyau.
- Transfert IP, redirections ICMP, attaques SYN flood et protection `rp_filter`.
- Risques liés aux compilateurs et aux outils système détournables (*Living off the Land*).
- Fonctionnement des bits SUID et SGID.
- Options de montage Linux : `noexec`, `nosuid` et `nodev`.
- Audit de sécurité avec `lynis`.
- Application et documentation des recommandations CIS.

## Environnement de travail

- **Systèmes compatibles** : Kali Linux, ParrotOS ou Ubuntu.
- **Virtualisation** : Multipass.
- **Serveur cible** : `novatech-prod-02`.
- **Utilisateur** : `auditor`.
- **Connexion** : SSH.

Il s’agit du serveur utilisé dans les projets précédents, désormais corrigé et prêt à être renforcé.

## Contraintes

- Maintenir Apache pleinement fonctionnel.
- Préserver et sécuriser l’accès SSH.
- Rendre les modifications persistantes après redémarrage.
- Justifier chaque suppression ou modification de configuration.
- Tester les services après chaque mesure de durcissement.
- Comprendre chaque paramètre avant de l’appliquer.

## Livrable attendu

Un `README.md` à la racine du projet, les scripts Bash exécutables et un **rapport de durcissement** détaillant les mesures appliquées, les tests réalisés et les recommandations CIS respectées.

Le serveur doit être suffisamment sécurisé pour envisager son déploiement en DMZ, sans compromettre sa disponibilité.
