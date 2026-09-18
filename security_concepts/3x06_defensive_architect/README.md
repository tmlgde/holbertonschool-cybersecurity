# Holistic Security Program

## Introduction

Ce projet simule une mission de **Senior Cybersecurity / Interim CISO** dans une entreprise dont la sécurité a été négligée.

L'objectif est d'identifier les **Critical Risks** et de mettre en place une stratégie de sécurité cohérente sans bloquer l'activité.

## Context

**Client :** Nexus Financial, une FinTech préparant son IPO.
**Deadline :** Audit externe dans **5 jours**.

Principaux risques identifiés :

* Accès physique au bureau et au serveur insuffisamment contrôlé.
* Mots de passe sensibles exposés sur un whiteboard.
* Ordinateurs laissés déverrouillés.
* Clé SSH `nexus_master.pem` partagée sur Slack.
* Port PostgreSQL `5432` exposé à Internet.
* Sauvegardes S3 non vérifiées.
* Accès `root` excessifs.
* Absence de logs et de capacités de détection.
* PIN administrateur faible.

### Mission

Mettre en place un **Holistic Security Program** couvrant :

1. **Governance** — Définir les politiques de sécurité.
2. **Prevention** — Hardening, RBAC, MAC, sécurité réseau et physique.
3. **Detection** — Logging centralisé et IDS.
4. **Response** — Incident Response Plan et playbooks.

## Learning Objectives

À la fin du projet, savoir :

* Transformer une **Risk Assessment** en contrôles techniques.
* Concevoir un modèle **RBAC** sous Linux.
* Appliquer la **Defense in Depth**.
* Construire une architecture de **Centralized Logging**.
* Rédiger des **Security Policies** et un **Incident Response Plan**.

## Requirements

* Tests sur **Ubuntu 20.04 ou supérieur**.
* Éditeurs autorisés : `vi`, `vim`, `emacs`.
* Un `README.md` est obligatoire à la racine.
* Les configurations doivent être **automatisées avec des scripts `.sh`**.
* Les scripts doivent être **idempotents** et pouvoir être exécutés plusieurs fois sans casser le système.

### Deliverables

```text
3x06_defensive_architect/
├── policy/
│   ├── threat_model.md
│   ├── access_control_policy.md
│   ├── physical_security_plan.md
│   └── incident_response_plan.md
├── technical/
│   ├── hardening.sh
│   ├── rbac_setup.sh
│   ├── network_defense.sh
│   └── logging_setup.sh
├── audit/
│   └── final_report.md
└── README.md
```

