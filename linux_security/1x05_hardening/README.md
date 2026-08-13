🏰 Capstone — The Golden Image
« No hand-holding. No step-by-step instructions. Just requirements and a deadline. »


📑 Sommaire
🧭 Introduction
❓ Pourquoi c'est important
📂 Contexte : "The Golden Image"
🎯 Objectifs pédagogiques
📚 Ressources
📋 Exigences
📦 Livrables
🔑 Accès au lab


🧭 Introduction
Tu as atteint la fin du module Linux Fundamentals. Ce projet Capstone valide ta capacité à sécuriser un système Linux via l'automatisation.

Contrairement aux projets précédents où chaque tâche était découpée en étapes guidées, ici tu agis comme un véritable Ingénieur : tu reçois une politique de sécurité, et c'est à toi de construire l'outil qui l'applique.

Pas d'accompagnement pas-à-pas. Pas d'instructions détaillées. Juste des exigences et une deadline.


❓ Pourquoi c'est important
Dans le monde réel, personne ne te dit "lance cette commande, puis celle-là". Tu reçois une politique de sécurité écrite en anglais courant, et ton travail est de la traduire en code fonctionnel. C'est exactement ce que font les ingénieurs sécurité au quotidien.

Le script que tu construis ici n'est pas un jouet pédagogique. C'est le fondement de la façon dont les organisations durcissent réellement leurs serveurs à grande échelle.


📂 Contexte : "The Golden Image"
DE : Chief Information Security Officer, DataFortress Inc. À : Security Engineer (toi) SUJET : Automatisation obligatoire du durcissement serveur PRIORITÉ : Critique

DataFortress Inc. étend son infrastructure. Nous déployons 200 nouveaux serveurs ce trimestre.

La configuration manuelle est interdite. Le taux d'erreur humain est inacceptable à cette échelle.

Ta mission : développer harden.sh, un outil d'automatisation de niveau production qui :

🖥️ Prend un serveur Ubuntu 22.04 fraîchement installé
🏰 Le transforme en Bastion Host sécurisé
✅ Assure la conformité à notre STIG-2024 interne (Security Technical Implementation Guide)
🚨 Contraintes
Idempotent : sûr à relancer plusieurs fois
Modulaire : aucun code monolithique
Traçable : doit générer un rapport d'audit prouvant la conformité

Livraison en fin de semaine. L'équipe infrastructure attend.


🎯 Objectifs pédagogiques
D'ici la fin de ce projet, tu devras pouvoir expliquer à n'importe qui, sans l'aide de Google :
🏗️ Scripting & Architecture
Écrire des scripts Bash robustes, modulaires et idempotents
La différence entre Configuration Management et scripting ad-hoc
Pourquoi coder des valeurs en dur crée des risques de sécurité
🛡️ Durcissement système
Automatiser des changements réseau sans se retrouver bloqué dehors
Appliquer des politiques de mot de passe via PAM
Configurer SSH pour une authentification par clé uniquement
✅ Conformité & Vérification
Traduire une politique de sécurité en contrôles techniques
Générer des rapports d'audit prouvant la conformité
La différence entre Authentification (AuthN) et Autorisation (AuthZ)


📚 Ressources
📖 Documentation
Bash Scripting Guide — référence Bash avancée
SSH Hardening Guide — configuration SSH sécurisée
UFW Essentials — configuration du pare-feu
Linux PAM Configuration — modules d'authentification
CIS Benchmarks — standards de durcissement de l'industrie
STIGs — qu'est-ce qu'un security technical implementation guide
📄 Pages de manuel
man ufw      man sshd_config   man pam

man faillock man sysctl        man passwd


📋 Exigences
🌐 Général
Tous les scripts seront testés sur Ubuntu 22.04 LTS
Éditeurs autorisés : vi, vim, emacs, nano, VScode
Un fichier README.md à la racine du projet est obligatoire
📜 Bash Scripting
✅ Tous les scripts doivent être exécutables (chmod +x)
✅ La première ligne de chaque fichier doit être exactement #!/bin/bash
✅ Les scripts doivent imposer une exécution en root et s'arrêter immédiatement sinon
✅ Tous les fichiers doivent se terminer par une nouvelle ligne
✅ Les pipes et opérateurs logiques sont encouragés
✅ Les scripts doivent produire une sortie propre (pas de messages de debug sauf indication contraire)
🏗️ Exigences d'architecture
Design modulaire : les scripts monolithiques sont interdits
Séparation de la configuration : aucune valeur codée en dur dans les fichiers de logique
Logging : toutes les actions doivent être loguées avec horodatage
Idempotence : les scripts doivent être sûrs à relancer plusieurs fois


📦 Livrables
hardening/

├── harden.sh              # Point d'entrée principal

├── config/

│   └── harden.cfg          # Variables de configuration

├── lib/

│   ├── network.sh          # Fonctions de durcissement réseau

│   ├── ssh.sh               # Fonctions de durcissement SSH

│   ├── identity.sh          # Fonctions utilisateurs/mots de passe

│   └── system.sh            # Fonctions de durcissement système

└── README.md               # Documentation


🔑 Accès au lab
Paramètre
Valeur
🏷️ Nom du lab
M1-Capstone
🎯 Hôte cible
[PROVIDED_IP]
👤 Utilisateur
student
🔐 Méthode d'auth
Clé SSH (fournie via l'interface du lab)


Exemple de connexion :

ssh [USER]@[PROVIDED_IP]

🧪 Un serveur Ubuntu 22.04 fraîchement installé, avec une configuration par défaut. Ton script doit le durcir jusqu'à la conformité STIG-2024.



🏰 No hand-holding. Just requirements and a deadline.

