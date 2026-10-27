# Docker Container Security

## 📌 Introduction

Ce projet vise à apprendre à sécuriser les conteneurs Docker en identifiant les mauvaises configurations et en appliquant les bonnes pratiques de sécurité.

Les conteneurs ne constituent pas une frontière de sécurité absolue. Une mauvaise configuration peut permettre à un attaquant de compromettre le conteneur, voire d'accéder à la machine hôte.

## 🎯 Objectifs

- Comprendre l'isolation Docker : namespaces et cgroups.
- Identifier les risques liés à l'exécution en root.
- Analyser les vulnérabilités avec `docker-bench-security`.
- Sécuriser les Dockerfiles et les images.
- Protéger les secrets et utiliser des utilisateurs non-root.
- Appliquer des limites de ressources et des restrictions de sécurité.
- Créer un environnement Python sécurisé.

## ⚠️ Contexte

L'entreprise DevStream a subi une attaque exploitant une vulnérabilité de son application Flask. La configuration Docker insuffisamment sécurisée a permis à l'attaquant d'accéder à des fichiers sensibles, au socket Docker, puis à la machine hôte.

Les principaux problèmes identifiés sont :

- Exécution du conteneur en root.
- Identifiants de base de données inscrits dans le Dockerfile.
- Image Ubuntu trop volumineuse.
- Absence de limites de ressources.
- Permissions et capacités Linux excessives.

## 🛠️ Travail à réaliser

1. **Analyser** les risques de la configuration existante.
2. **Auditer** la sécurité avec `docker-bench-security`.
3. **Corriger** le Dockerfile selon les bonnes pratiques.
4. **Construire** un environnement Python sécurisé.
5. **Renforcer** la sécurité à l'exécution des conteneurs.
6. **Documenter** les règles de sécurité pour l'équipe de développement.

## 🔐 Bonnes pratiques

- Utiliser des images officielles et minimales.
- Privilégier les utilisateurs non-root.
- Ne jamais intégrer de secrets dans les images.
- Utiliser des builds multi-étapes si nécessaire.
- Supprimer les capacités Linux inutiles.
- Activer un système de fichiers en lecture seule lorsque possible.
- Configurer les limites CPU et mémoire.
- Utiliser `no-new-privileges` et des profils seccomp adaptés.
- Scanner les images avec Trivy et vérifier les Dockerfiles avec Hadolint.

## 📚 Outils

- **Docker** : création et exécution des conteneurs.
- **docker-bench-security** : audit de sécurité.
- **Trivy** : détection des vulnérabilités.
- **Hadolint** : analyse des Dockerfiles.

## ✅ Exigences

- Environnement : Kali Linux, ParrotOS ou Ubuntu.
- Tous les Dockerfiles doivent passer Hadolint sans erreur.
- Les images doivent être compilables avec `docker build`.
- Les conteneurs doivent fonctionner sans privilèges root, sauf justification.
- Aucun secret ne doit être codé en dur.
- Les applications doivent rester fonctionnelles après les modifications.
- Un fichier `README.md` est obligatoire à la racine du projet.

## 🏁 Résultat attendu

Créer un environnement Docker Python sécurisé, réutilisable et conforme aux bonnes pratiques, tout en réduisant les risques de compromission du conteneur et de la machine hôte.
