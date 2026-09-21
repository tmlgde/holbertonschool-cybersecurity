# Access Control Policy — Nexus Financial

**Date:** 21 septembre 2026
**Auteur:** CISO par intérim
**Objectif:** Définir les règles d'engagement numérique pour remplacer la pratique de la clé SSH partagée (`nexus_master.pem`) par un modèle individuel, sans ralentir l'équipe de développement — y compris l'équipe frontend distante basée à Bali. Ce document est rédigé pour être directement implémentable par script (voir `technical/`).

## 1. Authentication

- Chaque développeur et administrateur dispose d'une **paire de clés SSH individuelle** (algorithme `ed25519` recommandé). Aucune clé partagée n'est autorisée, sous quelque forme que ce soit (fichier, message Slack, etc.). Cette règle remplace immédiatement et définitivement l'usage de `nexus_master.pem`, qui doit être révoquée et supprimée de tout canal de partage.
- L'authentification par mot de passe est désactivée sur tous les serveurs : `PasswordAuthentication no` dans `/etc/ssh/sshd_config`.
- Le login root direct via SSH est interdit : `PermitRootLogin no`. Chaque utilisateur se connecte avec son compte nominatif, puis élève ses privilèges via `sudo` si nécessaire.
- L'authentification multi-facteurs (MFA) est **obligatoire pour tout accès à l'environnement de production**, non exigée pour dev/staging afin de préserver la vélocité de l'équipe.
- Politique de rotation : chaque clé SSH individuelle est renouvelée tous les 12 mois, ou immédiatement en cas de suspicion de compromission.
- Révocation : suppression de la clé publique correspondante dans `~/.ssh/authorized_keys` de chaque serveur concerné — aucune régénération globale nécessaire, contrairement au modèle de clé partagée.

### Permissions de fichiers (SSH)

| Fichier / Dossier | Permissions | Propriétaire |
|---|---|---|
| `~/.ssh/` | `700` | utilisateur |
| `~/.ssh/id_ed25519` (clé privée) | `600` | utilisateur |
| `~/.ssh/authorized_keys` | `600` | utilisateur |
| `/etc/ssh/sshd_config` | `600` | root |

## 2. Authorization

Accès structuré par groupes Unix :

| Groupe | Accès SSH | Droits sudo | MFA |
|---|---|---|---|
| `dev-team` | dev, staging | Aucun droit root sur staging ; usage applicatif standard uniquement | Non requis |
| `prod-admins` | production | Commandes ciblées uniquement (voir ci-dessous) | Requis |
| `db-access` | Base de données (via réseau, pas de shell serveur) | Aucun | Selon environnement |

### Règle sudoers pour `prod-admins`
%prod-admins ALL=(root) NOPASSWD: /usr/bin/systemctl restart nexus-app, /usr/bin/systemctl status nexus-app, /usr/bin/systemctl stop nexus-app, /usr/bin/systemctl start nexus-app, /usr/bin/journalctl -u nexus-app, /usr/bin/apt-get update, /usr/bin/apt-get upgrade -y

Aucun accès `ALL=(ALL) ALL` n'est autorisé : chaque commande est nommée explicitement, en cohérence avec le principe du moindre privilège. L'ajout d'un utilisateur à `prod-admins` nécessite une validation documentée.

## 3. Network

### Règles firewall (ports + sources)

| Cible | Port | Source autorisée | Action |
|---|---|---|---|
| Bastion host | `22/tcp` | Plage IP bureaux / VPN connue (ex. `203.0.113.0/24`) | ALLOW |
| Bastion host | `22/tcp` | `0.0.0.0/0` | DENY |
| Serveurs internes | `22/tcp` | IP privée du bastion uniquement (ex. `10.0.0.5/32`) | ALLOW |
| Serveurs internes | `22/tcp` | Tout le reste | DENY |
| Base primaire Postgres | `5432/tcp` | CIDR privé applicatif (ex. `10.0.1.0/24`) | ALLOW |
| Base primaire Postgres | `5432/tcp` | `0.0.0.0/0` | DENY (aucune exception) |
| Réplique Postgres (Bali) | `5432/tcp` | CIDR privé régional Bali (ex. `10.1.0.0/16`) | ALLOW |
| Réplique Postgres (Bali) | `5432/tcp` | `0.0.0.0/0` | DENY |

### Cas particulier : équipe distante (Bali)

L'ouverture du port 5432 au monde entier était une réponse à un problème réel — la latence du VPN pour l'équipe frontend à Bali — mais inacceptable en l'état. La cause racine (distance réseau) est traitée directement :

- Une **réplique Postgres en lecture seule** est déployée dans une région proche de Bali, synchronisée en continu depuis la base primaire.
- L'équipe frontend (besoin exclusivement en lecture) interroge cette réplique localement.
- La réplique suit exactement les mêmes règles firewall que la base primaire (tableau ci-dessus) : jamais `0.0.0.0/0`.
- Tout besoin d'écriture exceptionnel depuis Bali passe par le bastion host, pas par la réplique.

## Synthèse

Ce modèle répond simultanément aux contraintes exprimées : il simplifie la gestion des accès pour Dave (onboarding/offboarding en une seule action, clé partagée éliminée, commandes de redémarrage prod accessibles sans `nexus_master.pem`, performance correcte pour l'équipe distante) tout en réduisant drastiquement la surface d'attaque pour Sarah (accountability individuelle, rotation de clés, permissions de fichiers strictes, règles firewall explicites, sudo limité à des commandes nommées, MFA en production, aucun accès direct depuis Internet quelle que soit la justification opérationnelle invoquée).
