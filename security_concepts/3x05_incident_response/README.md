# Incident Response & Digital Forensics

## Introduction

Ce projet porte sur l'**Incident Response (IR)** : détecter, contenir, éradiquer et analyser un incident de sécurité tout en préservant les preuves.

L'objectif est de maîtriser le cycle **PICERL** et de prendre des décisions adaptées sous pression.

## Context

**Client :** DataFortress, un fournisseur de services de sécurité.

Un serveur de production présente plusieurs signes de compromission :
- CPU à 99 %.
- Connexion sortante vers une IP inconnue sur le port 4444.
- Nouvelle entrée dans `crontab`.
- Plaintes concernant un réseau lent.

### Mission

1. **Identify** — Analyser les alertes et identifier le processus malveillant.
2. **Contain** — Contenir l'incident sans détruire les preuves.
3. **Eradicate** — Supprimer la persistance et vérifier le système.
4. **Recover** — Restaurer le service après confirmation de la sécurité.
5. **Report** — Produire le Post-Mortem et gérer les obligations GDPR.
6. **Improve** — Relier les problèmes aux contrôles de sécurité à améliorer.

## Learning Objectives

À la fin du projet, savoir :

- Appliquer les six phases **PICERL**.
- Comprendre **Isolation vs Shutdown**.
- Préserver les données volatiles avant un reboot.
- Identifier un processus malveillant avec `ps`, `netstat` et `lsof`.
- Détecter les mécanismes de **Persistence** comme `crontab`.
- Utiliser `iptables` pour isoler une machine.
- Comprendre la **Chain of Custody** et l'importance du SHA-256.
- Rédiger un **Post-Mortem**.
- Comprendre la notification GDPR sous **72 heures**.

## Requirements

- Tests sur **Ubuntu 20.04 ou supérieur**.
- Éditeurs autorisés : `vi`, `vim`, `emacs`.
- Un `README.md` est obligatoire.
- Les scripts doivent être exécutables et commencer par `#!/bin/bash`.
- Les données utilisées sont simulées.
- Les preuves doivent être **hashées et documentées avant modification**.
- Toute décision de containment doit être réfléchie et documentée.
