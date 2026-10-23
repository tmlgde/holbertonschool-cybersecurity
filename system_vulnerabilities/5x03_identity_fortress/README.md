# Linux IAM — Gestion des identités et des accès

## Introduction

Ce projet consiste à renforcer l’authentification et le contrôle des accès sur un serveur Linux. L’objectif est d’imposer des mots de passe robustes, de limiter les tentatives de connexion, de sécuriser SSH et d’ajouter une authentification multifacteur (MFA).

## Contexte

Vous travaillez comme ingénieur en sécurité chez **CyberShield Consulting**, pour **NovaTech Solutions**.

Après les projets précédents, le serveur est corrigé et renforcé. Cependant, un test d’intrusion révèle que plusieurs comptes utilisent des mots de passe faibles et que SSH autorise toujours l’authentification par mot de passe.

Votre mission est de sécuriser l’infrastructure d’authentification afin de réduire les risques de compromission des comptes.

## Objectifs

- **Sécuriser les mots de passe** : imposer des règles de qualité et empêcher leur réutilisation.
- **Limiter les attaques par force brute** : verrouiller les comptes après plusieurs échecs et bannir les adresses IP suspectes.
- **Sécuriser SSH** : passer progressivement à l’authentification par clés cryptographiques.
- **Ajouter une MFA** : configurer une authentification TOTP pour renforcer les connexions.
- **Gérer le cycle de vie des comptes** : définir l’expiration des mots de passe et des comptes.
- **Documenter les procédures** : prévoir des mécanismes de récupération d’urgence.

## Notions à maîtriser

- Fonctionnement de PAM (*Pluggable Authentication Modules*) et de ses fichiers de configuration.
- Modules `pam_pwquality`, `pam_pwhistory` et `pam_faillock`.
- Différence entre complexité et entropie d’un mot de passe.
- Fonctionnement des clés SSH publiques et privées.
- Protection contre les attaques par force brute avec `fail2ban`.
- Authentification multifacteur et codes temporaires TOTP.
- Gestion des comptes avec `chage`.

## Environnement de travail

- **Systèmes compatibles** : Kali Linux, ParrotOS ou Ubuntu.
- **Virtualisation** : Multipass.
- **Serveur cible** : `novatech-prod-03`.
- **Utilisateur** : `auditor`.
- **Connexion** : SSH.

## Contraintes

- Sauvegarder les fichiers PAM avant toute modification.
- Tester les changements dans un autre terminal avant de fermer la session actuelle.
- Ne jamais tester le verrouillage d’un compte avec son unique moyen d’accès.
- Préserver le fonctionnement des comptes de service.
- Effectuer la transition vers les clés SSH progressivement.
- Documenter les procédures de récupération d’urgence.

## Livrable attendu

Un `README.md` à la racine du projet, les scripts Bash exécutables et une documentation détaillant les politiques d’authentification, les protections mises en place et les procédures de récupération.

Le résultat final doit fournir une authentification robuste, limiter les tentatives malveillantes et renforcer la sécurité des accès au serveur.
