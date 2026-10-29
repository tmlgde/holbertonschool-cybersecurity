# 5x05 - Hardened Shield

## Introduction

Ce projet consiste à créer une image Docker sécurisée et renforcée, destinée au déploiement d'applications web. Il rassemble les bonnes pratiques étudiées dans les projets précédents concernant le durcissement système, la gestion des identités et la sécurité des conteneurs.

L'objectif est de fournir une infrastructure sécurisée, automatisée, auditable et documentée.

## Objectifs

- Appliquer les mesures de durcissement système du projet 5x02.
- Renforcer la gestion des utilisateurs et des identités du projet 5x03.
- Appliquer les bonnes pratiques Docker du projet 5x04.
- Configurer un accès d'administration SSH sécurisé.
- Automatiser les contrôles de sécurité.
- Documenter les mesures de sécurité et leur conformité.

## Structure du projet

```text
5x05_hardened_shield/
├── Dockerfile
├── docker-compose.yml
├── SECURITY.md
├── COMPLIANCE_REPORT.md
├── audit_result.md
├── README.md
├── scripts/
│   ├── init-hardening.sh
│   ├── init-identity.sh
│   ├── init-services.sh
│   └── audit.py
└── config/
```

## Description des fichiers

- **Dockerfile** : construit l'image Docker sécurisée.
- **docker-compose.yml** : configure le conteneur et ses restrictions d'exécution.
- **init-hardening.sh** : applique les mesures de durcissement système.
- **init-identity.sh** : configure les utilisateurs et les accès SSH.
- **init-services.sh** : initialise et démarre les services nécessaires.
- **audit.py** : vérifie automatiquement les contrôles de sécurité.
- **SECURITY.md** : décrit les mesures de sécurité appliquées.
- **COMPLIANCE_REPORT.md** : présente les contrôles de conformité.
- **audit_result.md** : contient les résultats des audits.
- **config/** : regroupe les fichiers de configuration nécessaires.

## Mesures de sécurité

### Durcissement système

- Réduire les services et paquets inutiles.
- Appliquer des permissions adaptées.
- Renforcer la configuration du système.
- Limiter les privilèges des utilisateurs.

### Gestion des identités

- Utiliser des comptes dédiés.
- Sécuriser l'accès SSH avec des clés publiques.
- Désactiver l'accès SSH direct pour root.
- Appliquer le principe du moindre privilège.

### Sécurité des conteneurs

- Utiliser une image de base maîtrisée.
- Éviter l'exécution en root lorsque cela est possible.
- Ne pas intégrer de secrets dans l'image.
- Limiter les capacités Linux et les ressources du conteneur.
- Utiliser des options de sécurité adaptées.

### Audit automatisé

Le script `audit.py` vérifie les contrôles définis et permet de consigner les résultats dans `audit_result.md`. Les résultats doivent refléter les vérifications réellement effectuées.

## Installation et utilisation

Construire l'image :

```bash
docker build -t hardened-shield .
```

Démarrer le conteneur avec Docker Compose :

```bash
docker compose up -d --build
```

Vérifier son état :

```bash
docker compose ps
```

Consulter les journaux :

```bash
docker compose logs
```

Exécuter l'audit de sécurité :

```bash
python3 scripts/audit.py
```

Les commandes et les paramètres exacts dépendent de l'implémentation des fichiers du projet.

## Tests et validation

Avant de considérer l'image comme sécurisée, vérifier que :

- Le conteneur démarre sans intervention manuelle.
- Les services nécessaires fonctionnent correctement.
- L'accès SSH respecte les règles de sécurité définies.
- Les comptes disposent uniquement des privilèges nécessaires.
- Les contrôles Docker sont correctement appliqués.
- L'audit produit des résultats exploitables.
- La documentation correspond à la configuration réelle.

## Documentation

- `SECURITY.md` : politiques et mesures de sécurité.
- `COMPLIANCE_REPORT.md` : état de conformité des contrôles.
- `audit_result.md` : résultats des vérifications réalisées.

## Environnement

- Ubuntu 20.04 LTS
- Docker
- Docker Compose
- Python 3

## Conclusion

Ce projet vise à intégrer le durcissement système, la sécurisation des identités et les bonnes pratiques Docker dans une solution cohérente. L'automatisation et la documentation permettent de faciliter la maintenance, les audits et le suivi de la sécurité.

La conformité finale doit être confirmée par des tests et des audits effectifs avant toute utilisation en production.
