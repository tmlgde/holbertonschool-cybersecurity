# Access Control Policy — Nexus Financial

**Date:** 21 septembre 2026
**Auteur:** CISO par intérim
**Objectif:** Définir les règles d'engagement numérique pour remplacer la pratique de la clé SSH partagée (`nexus_master.pem`) par un modèle individuel, sans ralentir l'équipe de développement — y compris l'équipe frontend distante basée à Bali. Ce document est rédigé pour être directement implémentable par script (voir `technical/`).

## 1. Authentication

- Chaque développeur et administrateur dispose d'une **paire de clés SSH individuelle**. Aucune clé partagée n'est autorisée, sous quelque forme que ce soit (fichier, message Slack, etc.).
- L'authentification par mot de passe est désactivée sur tous les serveurs : `PasswordAuthentication no`.
- Le login root direct via SSH est interdit : `PermitRootLogin no`. Chaque utilisateur se connecte avec son compte nominatif, puis élève ses privilèges via `sudo` si nécessaire.
- L'authentification multi-facteurs (MFA) est **obligatoire pour les accès à l'environnement de production**, et non exigée pour les environnements de développement, afin de ne pas ajouter de friction inutile au travail quotidien.
- La révocation d'un accès (départ d'un employé, compromission suspectée) se fait en retirant sa clé publique individuelle du système — aucune régénération globale n'est nécessaire.

## 2. Authorization

L'accès est structuré par groupes Unix, chacun correspondant à un niveau d'environnement et un niveau de droits :

| Groupe | Accès SSH | Droits sudo | MFA |
|---|---|---|---|
| `dev-team` | Environnements dev et staging | Restreints (pas d'accès prod) | Non requis |
| `prod-admins` | Environnement de production | Étendus, limités aux tâches de gestion des services | Requis |
| `db-access` | Base de données uniquement (via le groupe applicable) | Aucun droit système additionnel | Selon environnement |

Aucun utilisateur n'appartient par défaut à `prod-admins` : l'ajout à ce groupe nécessite une validation explicite documentée, en cohérence avec le principe du moindre privilège.

## 3. Network

- Aucune connexion SSH directe depuis Internet vers un serveur interne n'est autorisée.
- L'ensemble du trafic SSH transite obligatoirement par un **bastion host** unique et durci, seul point d'entrée exposé.
- Les serveurs internes n'acceptent de connexions SSH **que** depuis l'adresse IP du bastion — toute autre source est bloquée au niveau du pare-feu/security group.
- La base de données Postgres n'est **jamais** exposée directement à Internet (`0.0.0.0/0` interdit en toute circonstance), y compris pour répondre à des besoins de performance.

### Cas particulier : équipe distante (Bali)

L'ouverture du port 5432 au monde entier était une réponse à un problème réel — la latence du VPN pour l'équipe frontend basée à Bali — mais ce n'est pas une solution acceptable. La cause racine (distance réseau) est traitée directement plutôt que contournée :

- Une **réplique Postgres en lecture seule** est déployée dans une région proche de l'équipe Bali (Asie du Sud-Est), synchronisée en continu depuis la base primaire.
- L'équipe frontend, dont le besoin est exclusivement de la **lecture** de données, interroge cette réplique localement — latence réduite, sans jamais exposer la base primaire.
- La réplique reste soumise aux mêmes règles d'accès que la base primaire : jamais accessible depuis `0.0.0.0/0`, uniquement via réseau privé/VPN.
- Tout besoin d'écriture exceptionnel depuis Bali (ex. un admin) passe par le bastion host classique, pas par la réplique.

## Synthèse

Ce modèle répond simultanément aux contraintes exprimées : il **simplifie** la gestion des accès pour Dave (onboarding/offboarding en une seule action, point d'entrée unique à administrer, performance correcte pour l'équipe distante) tout en **réduisant drastiquement la surface d'attaque** pour Sarah (accountability individuelle, MFA ciblé sur ce qui compte, aucun accès direct aux serveurs ou à la base depuis l'extérieur, quelle que soit la justification opérationnelle invoquée).
