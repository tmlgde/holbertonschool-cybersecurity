# Centralized Logging & Intrusion Detection

## Introduction

Ce projet consiste à construire une architecture de **centralized logging** pour surveiller l'infrastructure et détecter les activités suspectes.

L'objectif est de comprendre la **collection, l'analyse et l'alerting** des logs.

## Context

**Client :** DataFortress.

Un serveur web a été compromis et l'attaquant a supprimé les logs locaux avant de partir.

### Mission

1. **Architect** — Mettre en place un serveur centralisé pour conserver les logs.
2. **Analyze** — Analyser les logs afin de reconstruire l'attaque.
3. **Automate** — Créer des scripts permettant de détecter automatiquement de futures attaques.

## Learning Objectives

À la fin du projet, savoir :

- Comprendre l'importance du **Centralized Logging** pour le forensic et la non-répudiation.
- Configurer **rsyslog** pour envoyer et recevoir des logs.
- Comprendre les logs Linux : `auth.log`, `syslog`, `apache2/access.log`.
- Utiliser les **Regex** pour extraire des IP et usernames.
- Distinguer **False Positive** et **True Positive**.
- Comprendre le **Log Correlation**.
- Configurer **Logrotate** pour éviter la saturation du disque.

## Requirements

- Tests sur **Ubuntu 20.04 ou supérieur**.
- Éditeurs autorisés : `vi`, `vim`, `emacs`.
- Un `README.md` est obligatoire.
- Les scripts doivent être exécutables et commencer par `#!/bin/bash`.
- Les fichiers de logs sont uniquement à analyser : **ne jamais exécuter les payloads qu'ils contiennent**.
- Configurer correctement le firewall lors des tests rsyslog.
