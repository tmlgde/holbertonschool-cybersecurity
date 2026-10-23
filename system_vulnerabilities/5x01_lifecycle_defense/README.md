# Gestion des correctifs — Patch Management

## Introduction

Ce projet consiste à apprendre à gérer les mises à jour de sécurité d’un serveur Linux de manière fiable, sans interrompre les services critiques. Il couvre la réparation des paquets endommagés, l’application des correctifs, l’automatisation des mises à jour et la mise en place de procédures de sécurité durables.

## Contexte

Vous travaillez comme ingénieur en sécurité chez **CyberShield Consulting**. Après un audit réalisé pour **NovaTech Solutions** dans le projet précédent, plusieurs vulnérabilités ont été identifiées : serveur FTP compromis, services web non corrigés, identifiants exposés et mauvaises configurations.

Entre-temps, un administrateur a interrompu une mise à jour avec `Ctrl+C`, provoquant des problèmes avec APT et DPKG. Apache ne démarre plus et le site e-commerce est indisponible depuis six heures.

Votre mission est de rétablir le fonctionnement du serveur, de corriger les vulnérabilités et d'automatiser la gestion des mises à jour.

## Objectifs

- **Récupération du système** : diagnostiquer les verrous APT/DPKG et réparer les paquets partiellement configurés.
- **Correction des vulnérabilités** : appliquer les mises à jour nécessaires en tenant compte des risques.
- **Automatisation** : configurer `unattended-upgrades` pour gérer les mises à jour de sécurité.
- **Gestion des paquets** : exclure temporairement certains paquets critiques et gérer les exceptions.
- **Retour arrière** : identifier les mises à jour problématiques et restaurer une version précédente si nécessaire.
- **Documentation** : rédiger une politique de gestion des correctifs et des procédures de réponse aux incidents.

## Notions à maîtriser

- Différence entre mises à jour de sécurité et mises à jour fonctionnelles.
- Fonctionnement de `apt`, `apt-get` et `dpkg`.
- Configuration des dépôts APT.
- Gestion des paquets bloqués avec `apt-mark hold`.
- Configuration des mises à jour automatiques et des redémarrages.
- Identification des régressions après une mise à jour.
- Sauvegarde, journalisation et restauration des configurations.

## Environnement de travail

- **Systèmes compatibles** : Kali Linux, ParrotOS ou Ubuntu.
- **Virtualisation** : Multipass.
- **Serveur cible** : `novatech-prod-01`.
- **Utilisateur** : `auditor`.
- **Connexion** : SSH.

Il s'agit du même environnement que dans le projet précédent, mais dans un état dégradé nécessitant une remise en état.

## Contraintes

- Toujours sauvegarder les fichiers avant de modifier leur configuration.
- Ne pas exécuter `apt upgrade` sans préciser les paquets à mettre à jour.
- Tester les configurations avec des simulations lorsque cela est possible.
- Créer des scripts idempotents, pouvant être exécutés plusieurs fois sans produire d'effets indésirables.
- Gérer les erreurs proprement.
- Journaliser toutes les modifications pour assurer la traçabilité.
- Préserver la disponibilité du serveur et privilégier les changements réversibles.

## Livrable attendu

Le projet doit inclure un `README.md` à la racine, des scripts Bash exécutables et une documentation présentant les opérations réalisées.

Le résultat final doit permettre de restaurer le serveur, d'appliquer les correctifs nécessaires et de mettre en place une stratégie de gestion des mises à jour fiable, automatisée et documentée.
