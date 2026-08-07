🔧 Shell Operations — Pipes, Filtres & Automatisation

« Si tu dois le faire plus de deux fois, script-le. Si tu dois le faire une fois mais sur 1000 fichiers, pipe-le. » — Unix Philosophy


📑 Sommaire
🧭 Introduction
❓ Pourquoi c'est important
📂 Contexte : "The Forensic Needle"
🎯 Objectifs pédagogiques
📚 Ressources
📋 Exigences


🧭 Introduction
Dans le Projet 1x00, tu as appris à naviguer et auditer manuellement. Des compétences essentielles — mais qui ne passent pas à l'échelle.

En tant qu'Ingénieur Sécurité, tu vas traiter des gigaoctets de logs, gérer des centaines d'utilisateurs, comparer des configurations sur des parcs entiers de machines. Faire ça fichier par fichier n'est pas seulement lent — c'est professionnellement inacceptable.

Ce projet te transforme d'Opérateur (quelqu'un qui tape des commandes) en Analyste (quelqu'un qui extrait du sens à partir de données à grande échelle). Tu vas maîtriser les outils qui permettent à un praticien expérimenté de faire en 10 secondes ce qui prend 10 heures à un débutant : pipes, redirections, grep, sed, awk, xargs.

La philosophie Unix est simple : de petits outils qui font une seule chose, mais bien, enchaînés pour tout faire. Un pipe (|) n'est pas de la syntaxe — c'est un multiplicateur de force.


❓ Pourquoi c'est important
🖥️ Dans un SOC, il n'y a pas de visualiseur de logs graphique sur un serveur compromis — juste un terminal SSH et un auth.log de 10 Go.
🎯 En pentest, nmap te retourne 3000 lignes qu'il faut trier en quelques minutes, pas en quelques heures.
🚨 En réponse à incident à 3h du matin, la différence entre contenir une brèche et la regarder se propager, c'est la vitesse à laquelle tu extrais la bonne donnée.

Les commandes maîtrisées ici — filtrer avec grep, transformer avec sed, extraire avec awk — ne sont pas des exercices académiques. C'est le vocabulaire quotidien de tout professionnel de la sécurité qui travaille à grande échelle.


📂 Contexte : "The Forensic Needle"
DE : Elena Vasquez, Lead Incident Responder — ACME Corp À : Security Engineer (toi) SUJET : Analyse post-brèche, aucun SIEM disponible PRIORITÉ : Critique

Nous avons contenu la brèche de la semaine dernière, mais il faut maintenant comprendre ce qui s'est passé.

L'attaquant a désactivé notre SIEM pendant l'incident. Pas de dashboards. Pas de requêtes préconstruites. Juste de la donnée brute :

Ressource
Taille
Contenu
📄 access.log
2.1 Go
6 mois de logs Apache (~18M lignes)
🔐 auth.log
340 Mo
Événements d'authentification
📁 configs/
12 000 fichiers
Sauvegardes de configuration


Ta mission : le service juridique attend des réponses pour vendredi. Extraire les indicateurs d'attaque de ces fichiers en utilisant uniquement des outils shell. Pas d'Excel. Pas d'interface graphique. Juste des pipes et des filtres.


🎯 Objectifs pédagogiques
D'ici la fin de ce projet, tu devras pouvoir expliquer à n'importe qui, sans l'aide de Google :
🧱 Concepts fondamentaux
Les flux standards — ce que sont stdin (0), stdout (1) et stderr (2), et comment les rediriger
Les descripteurs de fichiers — comment Linux traite tout comme un fichier, y compris les flux d'E/S
Le modèle de pipeline — pourquoi cmd1 | cmd2 est fondamentalement différent de l'utilisation de fichiers temporaires
La substitution de processus — ce que font <() et >(), et quand les utiliser
⚙️ Maîtrise des outils
grep — pattern matching avec expressions régulières basiques et étendues
sed — édition de flux pour chercher/remplacer sans ouvrir de fichier
awk — traitement par champs pour données colonnaires (logs, CSV)
xargs — convertir un flux d'entrée en arguments de commande
sort, uniq, cut, tr, tee — les outils qui complètent les pipelines
🛡️ Applications sécurité
Analyse de logs — extraire timestamps, IP, codes de statut depuis des formats standards
Extraction d'IoC — récupérer des Indicateurs de Compromission dans de la donnée brute
Opérations en masse — appliquer des changements sur des milliers de fichiers
Détection d'anomalies — identifier des valeurs aberrantes dans de grands jeux de données


📚 Ressources
📖 Documentation
The Art of Command Line — guide de maîtrise du shell (lire "Basics" et "Processing files and data")
GNU Grep Manual — référence pattern matching
GNU Sed Manual — documentation de l'éditeur de flux
GAWK User's Guide — référence AWK (chapitres 1 à 4)
Bash Redirections Cheat Sheet — guide visuel des E/S
What is security information and event management
🧪 Outils interactifs
Regex101 — test de regex en temps réel
ExplainShell — décomposition de commandes
ShellCheck — linter de scripts shell
📄 Pages de manuel
man grep    man sed     man awk    man xargs

man sort    man uniq    man cut    man tee


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
🔄 Exigences de workflow
Les scripts doivent être développés en local, sur ta machine
Les scripts doivent être déployés sur la cible via scp
Les scripts doivent être exécutés sur la machine distante via ssh <user>@<host>



🔧 Small tools, chained together, do anything.

