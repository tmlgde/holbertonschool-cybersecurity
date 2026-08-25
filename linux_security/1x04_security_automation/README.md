🤖 Sentinel — Self-Healing Infrastructure Agent
« Stability is not a state, it is a process. »


📑 Sommaire
🧭 Introduction
❓ Pourquoi c'est important
📂 Contexte : "The Unstable Server"
🎯 Objectifs pédagogiques
📚 Ressources
📋 Exigences🤖 Sentinel — Self-Healing Infrastructure Agent

« Stability is not a state, it is a process. »

Projet pratique consacré à l'automatisation, au contrôle de configuration et à l'auto-remédiation Linux.

L'objectif : construire Sentinel, un agent Bash capable de détecter les dérives d'un système, de les corriger automatiquement et de fonctionner de manière persistante via systemd.

📑 Sommaire
🧭 Introduction
❓ Pourquoi c'est important
📂 Contexte — The Unstable Server
🎯 Objectifs
🛠️ Technologies
📋 Exigences
🔄 Workflow
🧭 Introduction

Dans les projets précédents, les problèmes étaient corrigés manuellement.

Mais dans une infrastructure réelle, les configurations dérivent, les services tombent et les erreurs humaines se répètent.

Sentinel automatise ce processus :

🔍 Audit
   ↓
📊 Détection de dérive
   ↓
🛠️ Remédiation
   ↓
📝 Logging
   ↓
🔄 Vérification

L'agent doit maintenir le système dans un état désiré défini par sa configuration.

❓ Pourquoi c'est important ?

La remédiation manuelle est :

🐌 Lente
🔁 Répétitive
⚠️ Sujette aux erreurs
🌙 Difficile à maintenir à grande échelle

L'automatisation permet au contraire de mettre en place des baselines de sécurité et de corriger automatiquement les dérives.

Ces principes sont directement liés à l'Infrastructure as Code, à la gestion de configuration et aux solutions de sécurité comme les EDR ou les systèmes de monitoring.

📂 Contexte — The Unstable Server

De : Responsable Ops — ACME Corp
À : Security Engineer
Sujet : 🚨 Instabilité du serveur de production
Priorité : Haute

Le serveur srv-prod-01 présente plusieurs problèmes :

Problème	Description
💥 Service instable	Le serveur web crash régulièrement
🔓 Configuration SSH	/etc/ssh/sshd_config est régulièrement modifié
👻 Processus inconnus	Des processus apparaissent sur des ports inhabituels

L'équipe Ops souhaite éviter les interventions manuelles répétitives.

🎯 Mission

Développer et déployer sentinel.sh, un agent capable de :

🔍 Surveiller les services et fichiers critiques
🛠️ Corriger automatiquement les écarts
📊 Produire des logs structurés en JSON
⏱️ Fonctionner automatiquement en arrière-plan
🔄 Survivre aux redémarrages grâce à systemd
🎯 Objectifs
🏗️ Architecture Bash

Comprendre :

Le découpage en fonctions
La séparation code / configuration
Les codes de sortie
La conception modulaire
🔄 Idempotence

Le script doit pouvoir être exécuté plusieurs fois sans provoquer d'effets indésirables.

État incorrect
      ↓
   Sentinel
      ↓
État correct
      ↓
Sentinel à nouveau
      ↓
Aucune modification inutile
⚙️ Gestion de configuration

Utiliser une configuration externe pour définir notamment :

Les services à surveiller
Les fichiers critiques
Les ports
Les valeurs attendues

🚫 Les valeurs importantes ne doivent pas être codées en dur dans le script.

🔧 Systemd

Comprendre :

Les service units
Les timer units
Les dépendances
La gestion des logs
La différence avec une simple tâche cron
📊 Logging structuré

Sentinel doit produire des événements exploitables par des outils de monitoring ou un SIEM :

{
  "timestamp": "...",
  "level": "INFO",
  "action": "check",
  "status": "ok"
}
🛠️ Technologies

Principaux composants :

🐚 Bash
⚙️ systemd
⏱️ systemd timers
🔐 md5sum
📝 JSON
📊 logger

Pages de manuel utiles :

man systemctl
man systemd.unit
man systemd.timer
man md5sum
man logger
📋 Exigences
🌐 Général

Le projet doit fonctionner sur :

Kali Linux
ParrotOS
Ubuntu 22.04+

Éditeurs autorisés :

vi
vim
emacs
nano

Un README.md doit être présent à la racine.

📜 Bash

Tous les scripts doivent :

Être exécutables avec chmod +x
Commencer exactement par :
#!/bin/bash
Contenir exactement 2 lignes
Se terminer par une nouvelle ligne
Produire une sortie propre
Utiliser les pipes et opérateurs logiques lorsque nécessaire

Vérification :

wc -l fichier

Résultat attendu :

2
🚨 Contraintes critiques
🔄 Idempotence

Relancer Sentinel ne doit jamais casser le système ni effectuer de modifications inutiles.

🔐 Privilèges

L'agent est exécuté avec les privilèges root via systemd.

⚙️ Configuration externe

Les éléments tels que :

Services
Chemins
Ports
Fichiers de référence

doivent provenir du fichier de configuration et non être directement codés dans le script.

🔄 Workflow
💻 Développement local
        ↓
🧪 Tests
        ↓
📤 SCP
        ↓
🖥️ Machine cible
        ↓
🔐 SSH
        ↓
⚙️ Installation systemd
        ↓
🤖 Sentinel
        ↓
🔍 Audit → 🛠️ Remédiation → 📊 JSON

Les scripts doivent être développés localement, transférés via scp, puis exécutés sur la cible avec :

ssh <user>@<host>
🎓 Résultat attendu

À la fin du projet, Sentinel doit être capable de maintenir automatiquement une baseline système :

        🤖 SENTINEL
             │
     ┌───────┴───────┐
     ↓               ↓
   🔍 Audit       📊 Logs
     │
     ↓
⚠️ Dérive détectée
     │
     ↓
🛠️ Remédiation
     │
     ↓
✅ État désiré

🤖 Stability is not a state, it is a process.


🧭 Introduction
Dans les projets précédents, tu réparais les choses à la main : tu auditais des utilisateurs, tuais des processus, parsais des logs. Cette approche ne passe pas à l'échelle. Dans une infrastructure réelle, l'entropie gagne toujours : les configurations dérivent, les services crashent, les admins juniors font des erreurs.

Tu ne peux pas réparer le même serveur à la main tous les jours. Il te faut un agent automatisé qui garantit que le système reste dans l'état désiré. C'est le fondement de l'Infrastructure as Code (IaC) et des outils de gestion de configuration comme Ansible ou Puppet.

Dans ce projet, tu vas construire Sentinel, un agent auto-réparateur (self-healing). Il lit une configuration, audite le système, corrige automatiquement les écarts détectés, et persiste à travers les redémarrages.


❓ Pourquoi c'est important
La remédiation manuelle est réactive — tu répares les problèmes après qu'ils se soient produits, souvent à 3h du matin quand tu préférerais dormir. Les agents automatisés sont proactifs — ils détectent la dérive et la corrigent avant que quiconque ne s'en aperçoive.

Chaque équipe sécurité mature s'appuie sur l'automatisation pour faire respecter des lignes de base (baselines). Les scripts que tu construis ici sont le fondement pour comprendre des outils comme OSSEC, Wazuh, et les solutions EDR commerciales.


📂 Contexte : "The Unstable Server"
DE : Responsable de l'équipe Ops, ACME Corp À : Security Engineer (toi) SUJET : Instabilité du serveur de production PRIORITÉ : Haute

Le serveur de production srv-prod-01 est critique mais instable :

Problème
Description
💥 Serveur web instable
Il crash aléatoirement et personne ne le redémarre avant que les utilisateurs se plaignent
🔓 Config SSH modifiée
Quelqu'un modifie sans arrêt /etc/ssh/sshd_config pour réactiver le login root
👻 Processus inconnus
Des processus apparaissent sur des ports étranges


L'équipe Ops est épuisée par les réveils à 3h du matin.

Ta mission : développer et déployer sentinel.sh, un agent Bash qui :

🔍 Surveille les services et fichiers critiques
🛠️ Les répare automatiquement quand ils sont cassés ou modifiés
📊 Rapporte son activité en format JSON structuré
⏱️ Persiste via systemd pour tourner automatiquement en arrière-plan


🎯 Objectifs pédagogiques
D'ici la fin de ce projet, tu devras pouvoir expliquer à n'importe qui, sans l'aide de Google :
🏗️ Architecture de scripting
Design modulaire — fonctions et fichiers de config séparés
Idempotence — pourquoi les scripts doivent être sûrs à relancer plusieurs fois
Codes de sortie — comment les utiliser pour contrôler le flux d'exécution
⚙️ Gestion de configuration
Séparer le code de la donnée en utilisant des fichiers de config externes
Application d'état (state enforcement) vs corrections ponctuelles
Copies de référence (golden copies) et vérification d'intégrité
🔧 Intégration Systemd
Service units — définir quoi exécuter
Timer units — planifier quand l'exécuter
Avantages sur cron — logging et gestion des dépendances
📊 Logging structuré
Sortie JSON pour l'ingestion par un SIEM
Formatage des timestamps pour la corrélation de logs
Niveaux de log et catégorisation


📚 Ressources
📖 Documentation
Bash Scripting Guide — référence Bash avancée
Systemd Service Documentation — syntaxe des unités de service
Systemd Timer Documentation — syntaxe des unités de timer
JSON in Bash — générer du JSON depuis un script shell
📄 Pages de manuel
man systemctl   man systemd.unit   man systemd.timer

man md5sum      man logger


📋 Exigences
🌐 Général
Tous les scripts seront testés sur Kali Linux, ParrotOS, ou Ubuntu 22.04+
Éditeurs autorisés : vi, vim, emacs, nano
Un fichier README.md à la racine du projet est obligatoire
📜 Bash Scripting
✅ Tous les scripts doivent être exécutables (chmod +x)
✅ La première ligne de chaque fichier doit être exactement #!/bin/bash
✅ Tous les scripts doivent faire exactement deux lignes (wc -l fichier doit afficher 2)
✅ Tous les fichiers doivent se terminer par une nouvelle ligne
✅ Les pipes et opérateurs logiques sont encouragés
✅ Les scripts doivent produire une sortie propre (pas de messages de debug sauf indication contraire)
🚨 Contraintes critiques
Idempotence : le script doit pouvoir être relancé plusieurs fois sans jamais rien casser
Privilèges : le script tourne en tant que root via systemd
Pas de valeurs codées en dur : noms de service, chemins de fichiers et ports doivent venir du fichier de config
🔄 Exigences de workflow
Les scripts doivent être développés en local, sur ta machine
Les scripts doivent être déployés sur la cible via scp
Les scripts doivent être exécutés sur la machine distante via ssh <user>@<host>



🤖 Stability is not a state, it is a process.


