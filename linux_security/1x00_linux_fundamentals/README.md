🐧 Linux Fundamentals & Security Baseline
« Au pays de la Cybersécurité, Linux est la langue commune. Si tu ne la parles pas couramment, tu es un touriste — et les touristes se font dévaliser. »


📑 Sommaire
🧭 Introduction
❓ Pourquoi c'est important
🔎 Ce qu'est vraiment ce projet
📂 Contexte : "Toxic Legacy"
🎯 Objectifs pédagogiques
📚 Ressources
📋 Exigences


🧭 Introduction
Avant de faire défiler cette introduction à la recherche de la première tâche, lis attentivement. Ce que tu t'apprêtes à commencer n'est pas "juste un autre projet". Ce n'est pas un échauffement. Ce n'est pas quelque chose que tu peux apprendre à moitié et rattraper plus tard.

C'est la fondation de tout.

Chaque module de ce programme — sécurité réseau, tests d'intrusion, forensic, automatisation, durcissement système — suppose que tu as maîtrisé ce qui est enseigné ici. Si tu prends des raccourcis, si tu copies-colles sans comprendre, si tu te dis "je reviendrai dessus plus tard", tu construis toute ta carrière en cybersécurité sur du sable. Et le sable s'effondre.

Soyons directs sur ce que représente ce projet :

🌐 96,3% des meilleurs serveurs web au monde tournent sous Linux.
🏦 L'infrastructure cloud derrière ta banque, ton dossier médical, les systèmes de ton gouvernement → Linux.
🕵️ Les machines d'attaque utilisées par les hackers étatiques et les organisations criminelles → Linux.
🔬 Les postes de forensic utilisés pour enquêter sur les brèches → Linux.
📡 Les plateformes SIEM qui surveillent les réseaux d'entreprise → tournent sous Linux.
📦 Les containers qui font tourner les applications modernes → noyaux Linux.


❓ Pourquoi c'est important
Il n'existe aucun chemin en cybersécurité qui évite Linux. Aucun.

Métier visé
Pourquoi Linux est incontournable
🎯 Pentester
Chaque exploit, chaque shell obtenu, chaque pivot se fait sur Linux
🖥️ Analyste SOC
Les logs, les alertes, les systèmes investigués tournent majoritairement sous Linux
🦠 Analyste Malware
Ton sandbox, ton désassembleur, ton environnement d'analyse → Linux
☁️ Ingénieur Cloud Security
AWS, GCP, Azure : leur colonne vertébrale, c'est Linux
🔍 Enquêteur Forensic
Tes outils d'acquisition, ta suite d'analyse, ton traitement des preuves → Linux
🕵️ Threat Intelligence
Tes outils OSINT, tes pipelines de traitement de données → Linux
🛠️ Créateur d'outils sécurité
Le standard de l'industrie, c'est le développement Linux-first


Ce n'est pas de l'exagération. C'est la réalité de l'industrie que tu rejoins.


🔎 Ce qu'est vraiment ce projet
Ce projet n'est pas "apprendre des commandes Linux". Tu pourrais mémoriser chaque commande existante et rester inutile dans un vrai contexte de sécurité.

Ce projet, c'est développer une fluidité opérationnelle — la capacité de penser en termes de systèmes de fichiers, de permissions, de processus, d'accès distant. C'est construire les réflexes qui te permettent de naviguer sur un serveur compromis à 3h du matin, pendant que ton entreprise perd des données. C'est comprendre le modèle de permissions si profondément que tu repères un vecteur d'élévation de privilèges en quelques secondes, pas en quelques heures.

Tu ne cliqueras pas dans des interfaces graphiques. Tu ne suivras pas de tutoriels pas-à-pas. Tu seras lâché dans un environnement en ligne de commande, avec une mission et une deadline. Débrouille-toi.

Cet inconfort est voulu. C'est là que l'apprentissage a lieu.


📂 Contexte : "Toxic Legacy"
DE : Marcus Chen, Directeur IT — ACME Corp À : Junior Security Engineer (toi) SUJET : URGENT — Remédiation requise sur serveur legacy PRIORITÉ : Haute

Bienvenue à bord. J'aurais aimé que ton premier jour se passe dans de meilleures circonstances.

Ton prédécesseur, appelons-le "Larry le Fainéant", a été licencié vendredi dernier pour négligence grave. Durant son mandat, Larry a pris des "raccourcis" qui ont laissé notre infrastructure dans un état dangereux. Concrètement, le serveur srv-legacy-01 est un désastre :

Problème
"Solution" de Larry
Risque réel
L'appli avait besoin d'un accès en écriture
chmod 777 sur des fichiers de config sensibles
N'importe quel utilisateur peut lire les identifiants
Mot de passe de la base de données oublié
Stocké en clair dans un fichier "quelque part"
Exposition d'identifiants
Nouveau développeur avait besoin d'accès
Ajouté à tous les groupes
Privilèges excessifs
Le script de backup ne voulait pas tourner
Bit SUID posé sur des binaires au hasard
Vecteur d'élévation de privilèges


Ta mission : tu as un accès SSH à srv-legacy-00. Ta tâche est d'auditer et de corriger le désordre de Larry. Mais voici la contrainte qui sépare les professionnels des amateurs :

🚫 Tu ne corrigeras RIEN manuellement.

Dans le monde réel, on ne se connecte pas en SSH sur 500 serveurs pour taper des commandes une par une. On construit des scripts en local, on les teste, on les déploie via SCP, et on les exécute à distance via SSH. C'est l'Infrastructure as Code. C'est comme ça que travaillent les professionnels.

Construis ta boîte à outils. Nettoie le désordre. Prouve que tu n'es pas un autre Larry.


🎯 Objectifs pédagogiques
D'ici la fin de ce projet, tu devras pouvoir expliquer à n'importe qui, sans l'aide de Google :
🧱 Compétences fondamentales
La hiérarchie du système de fichiers Linux — ce qui vit dans /etc, /var, /home, /usr, et pourquoi ça compte pour la sécurité
Le modèle de permissions — comment fonctionnent les bits rwx pour Propriétaire, Groupe et Autres, et ce que permet chaque combinaison
Notation octale vs. symbolique — convertir entre chmod 755 et chmod u=rwx,go=rx avec fluidité
Les bits spéciaux — ce que font SUID, SGID et le Sticky Bit, et pourquoi un SUID sur le mauvais binaire est une vulnérabilité critique
⚙️ Compétences opérationnelles
Workflow distant — gérer des serveurs exclusivement via SSH/SCP, sans accès interactif
Recherche de précision — utiliser find avec des critères complexes (type, taille, date, permissions) pour localiser des fichiers précis
Reconnaissance de motifs — utiliser grep et les regex pour extraire de l'information de fichiers
ACL (Access Control Lists) — accorder des permissions granulaires au-delà du modèle classique propriétaire/groupe/autres
🧠 Réflexe sécurité
Auditer avant de corriger — pourquoi une remédiation à l'aveugle est dangereuse, et comment évaluer avant d'agir
Le moindre privilège — le principe selon lequel utilisateurs et processus ne doivent avoir que les permissions strictement nécessaires
La défense en profondeur — pourquoi les permissions ne sont qu'une couche parmi une stratégie de sécurité multi-niveaux


📚 Ressources
🧩 Fondations conceptuelles
Linux Filesystem Hierarchy Standard — spécification officielle de l'emplacement des fichiers
Linux Journey: Permissions — introduction interactive au modèle de permissions
Red Hat: SUID, SGID, and Sticky Bit — les trois bits spéciaux expliqués
Linux Journey: Access Control Lists — quand les permissions standards ne suffisent plus
SSH Academy: SSH Protocol — comment fonctionne réellement l'accès distant sécurisé
📖 Référence technique (à mettre en favoris)
GNU Coreutils: File Permissions — référence officielle sur chmod
GNU Find Manual — documentation complète sur la recherche de fichiers
Grep Manual — référence sur le pattern matching
SSH manual — utiliser ssh pour se connecter à un serveur distant
SCP manual — utiliser scp pour transférer des fichiers
🛡️ Contexte sécurité
MITRE ATT&CK: File and Directory Permissions Modification — comment les attaquants abusent des permissions
CWE-732: Incorrect Permission Assignment — la classification de vulnérabilité pour les problèmes de permissions
NIST SP 800-123: Guide to General Server Security — chapitre 5 sur les permissions de fichiers (sections 5.1 à 5.3)
📄 Pages de manuel
man chmod    man chown    man find    man grep

man setfacl  man getfacl  man ssh     man scp


📋 Exigences
🌐 Général
Tous les scripts seront testés sur Kali Linux, ParrotOS, ou Ubuntu 22.04+
Éditeurs autorisés : vi, vim, emacs, nano
Un fichier README.md à la racine du projet est obligatoire
Tous les fichiers doivent se terminer par une nouvelle ligne
📜 Bash Scripting
✅ Tous les scripts doivent être exécutables (chmod +x)
✅ La première ligne de chaque fichier doit être exactement #!/bin/bash
✅ Tous les scripts doivent faire exactement deux lignes (wc -l fichier doit afficher 2)
✅ Tous les fichiers doivent se terminer par une nouvelle ligne
✅ Les pipes et opérateurs logiques sont encouragés
✅ Les scripts doivent produire une sortie propre (pas de messages de debug sauf indication contraire)
🔄 Exigences de workflow
Les scripts doivent être développés en local, sur ta machine
Les scripts doivent être déployés sur la cible via scp
Les scripts doivent être exécutés sur la machine distante via ssh <user>@<host>

