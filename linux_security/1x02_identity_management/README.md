🔑 Identity Management & Access Control
« Identity is the new perimeter. »


📑 Sommaire
🧭 Introduction
❓ Pourquoi c'est important
📂 Contexte : "The Identity Purge"
🎯 Objectifs pédagogiques
📚 Ressources
📋 Exigences


🧭 Introduction
Les pare-feux définissaient autrefois les frontières de la sécurité. Aujourd'hui, les attaquants les contournent entièrement en volant des identifiants. Une fois qu'ils compromettent un compte utilisateur, ils sont à l'intérieur des murs. Si cet utilisateur a un accès sudo non contrôlé, l'attaquant possède la machine.

Un Ingénieur Sécurité ne se contente pas de "créer des utilisateurs". Il :

🔍 Audite les comptes existants pour trouver portes dérobées et menaces dormantes
🔐 Durcit les mécanismes d'authentification pour empêcher le brute force et le vol d'identifiants
⚖️ Applique le moindre privilège pour limiter le rayon d'impact quand (pas si) une compromission survient

Ce projet couvre le cycle de vie complet de l'identité : détecter les comptes malveillants, sécuriser l'authentification, et implémenter des contrôles d'accès qui fonctionnent réellement.


❓ Pourquoi c'est important
La majorité des brèches impliquent des identifiants compromis. Le rapport Verizon Data Breach Report montre de manière constante que les mots de passe volés sont le vecteur d'attaque n°1.

Comprendre /etc/passwd, /etc/shadow, PAM et sudoers n'est pas une connaissance optionnelle — c'est le fondement de tout contrôle de sécurité identitaire que tu implémenteras ou auditeras un jour.


📂 Contexte : "The Identity Purge"
DE : Marcus Chen, Directeur IT — ACME Corp À : Security Engineer (toi) SUJET : Audit d'identité requis, comptes backdoor suspectés PRIORITÉ : Haute

Notre audit de sécurité a révélé des découvertes préoccupantes sur srv-legacy-01 :

Découverte
Niveau de risque
Description
👻 Comptes fantômes UID 0
🔴 Critique
Des utilisateurs autres que root avec UID 0
⚙️ Comptes de service avec shell
🟠 Élevé
www-data a /bin/bash au lieu de /usr/sbin/nologin
🔓 Hashs de mot de passe faibles
🟠 Élevé
Certains comptes utilisent encore MD5 ($1$)
🚪 SSH autorise le login root
🟡 Moyen
Accès root direct activé
📋 Aucune politique de mot de passe
🟡 Moyen
PAM non configuré pour la complexité


Ta mission : construire une suite de scripts d'audit et de durcissement. Ne te contente pas de réparer la machine — crée des outils réutilisables qui détectent ces problèmes sur n'importe quel système.


🎯 Objectifs pédagogiques
D'ici la fin de ce projet, tu devras pouvoir expliquer à n'importe qui, sans l'aide de Google :
🧱 Fondamentaux de l'identité
La structure de /etc/passwd — ce que signifie chaque champ, et pourquoi l'UID 0 est spécial
La structure de /etc/shadow — les formats de hash de mot de passe, et ce qu'indiquent $1$, $5$, $6$
Comptes de service vs. comptes humains — pourquoi les UID en dessous de 1000 ne devraient jamais avoir de shell de login
⚖️ Gestion des privilèges
Groupes dangereux — pourquoi l'appartenance à docker, disk ou shadow équivaut à root
Syntaxe sudoers — comment accorder des permissions granulaires sans donner les clés du royaume
Le piège NOPASSWD — pourquoi la commodité crée des vulnérabilités critiques
🔐 Durcissement de l'authentification
Configuration SSH — désactiver l'authentification par mot de passe, imposer l'accès par clé
PAM (Pluggable Authentication Modules) — imposer complexité de mot de passe et politiques de verrouillage
Onboarding sans mot de passe — créer des comptes qui n'ont jamais de mot de passe à voler


📚 Ressources
📖 Documentation
Understanding /etc/passwd — structure de fichier expliquée
Understanding /etc/shadow — formats de hash de mot de passe
Introduction to PAM
SSH Hardening Guide — bonnes pratiques de configuration
Sudoers Manual — référence complète sudoers
📄 Pages de manuel
man passwd    man shadow    man useradd   man usermod

man groupadd  man sudoer    man sshd_config   man pam


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
🔒 Exigences de privilèges
La plupart des scripts nécessitent sudo pour lire /etc/shadow ou modifier des configurations système
Teste tes scripts sur des systèmes non-productifs en premier

⚠️ Avertissement de sécurité — Lorsque tu modifies la configuration SSH, garde TOUJOURS un second terminal ouvert. Si tu te bloques toi-même dehors, tu auras besoin de cette session pour corriger la config.
🔄 Exigences de workflow
Les scripts doivent être développés en local, sur ta machine
Les scripts doivent être déployés sur la cible via scp
Les scripts doivent être exécutés sur la machine distante via ssh <user>@<host>



🔑 Identity is the new perimeter.

