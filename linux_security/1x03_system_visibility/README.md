🕵️ Process & Network Forensics
« You cannot kill what you cannot see. »


📑 Sommaire
🧭 Introduction
❓ Pourquoi c'est important
📂 Contexte : "The Crypto-Jacking"
🎯 Objectifs pédagogiques
📚 Ressources
📋 Exigences
🔑 Accès au lab


🧭 Introduction
Un système Linux est une métropole grouillante. À chaque seconde, des centaines de processus naissent, travaillent, attendent des ressources, meurent. Les malwares, crypto-mineurs et backdoors se cachent dans ce bruit — ils déguisent leurs noms, se détachent des terminaux, écoutent sur des ports obscurs.

Pour sécuriser un système, ls -la ne suffit plus. Il faut voir le flux d'exécution :

Couche
Question
Outils
⚙️ Processus
Quel code s'exécute en ce moment ?
ps, top, /proc
🌐 Réseau
Quel processus a ouvert ce port ?
ss, lsof, netstat
📜 Logs
Que s'est-il passé avant le crash ?
journalctl, dmesg


Dans ce projet, tu quittes les fichiers statiques. Tu vas auditer l'état dynamique d'un système : suivre des PID, les corréler à des sockets réseau, et terminer des processus renégats à coups de signaux noyau.


❓ Pourquoi c'est important
Quand tu réponds à un incident, le malware de l'attaquant tourne, là, maintenant. Il n'est pas planqué dans un fichier qui attend d'être trouvé — c'est un processus qui consomme du CPU, garde des connexions réseau ouvertes, écrit sur le disque. Si tu ne peux pas l'identifier parmi des centaines de processus légitimes, tu ne peux pas l'arrêter.

Les commandes apprises ici — ps, ss, lsof, kill, journalctl — sont celles qu'un incident responder utilise dans les 10 premières minutes d'une investigation de brèche.


📂 Contexte : "The Crypto-Jacking"
DE : Marcus Chen, Directeur IT — ACME Corp À : Security Engineer (toi) SUJET : Dégradation des performances serveur, compromission suspectée PRIORITÉ : Haute

Notre serveur web principal est à la traîne. Ventilateurs à 100%. CPU au taquet.

Le top habituel montre une charge élevée, mais quelque chose cloche — les noms de processus ont l'air génériques. On soupçonne un crypto-mineur installé par un prestataire véreux. Il cache son nom, écoute des commandes sur un port haut aléatoire, et repart si on essaie de le tuer.

Ta mission :

🔍 Identifier les processus renégats qui consomment les ressources
🗺️ Cartographier les processus vers leurs ports réseau ouverts
💀 Terminer les menaces avec les signaux appropriés
📜 Investiguer les logs pour déterminer comment tout a démarré

⚠️ Règles forensiques standards : tout documenter, ne pas détruire de preuves prématurément.


🎯 Objectifs pédagogiques
D'ici la fin de ce projet, tu devras pouvoir expliquer à n'importe qui, sans l'aide de Google :
🧱 Fondamentaux des processus
La hiérarchie des processus — ce que signifient PID, PPID, et les états de processus (Running, Sleeping, Zombie)
Le système de fichiers /proc — où ps et top récupèrent réellement leurs données
La propriété des processus — comment déterminer quel utilisateur a lancé un processus
💀 Gestion des signaux
SIGTERM vs SIGKILL — pourquoi on demande poliment d'abord, avant de forcer
SIGSTOP/SIGCONT — geler des processus pour les analyser
La gestion des signaux — pourquoi un malware peut ignorer SIGTERM mais pas SIGKILL
🌐 Visibilité réseau
Les états de socket — ce que signifient LISTEN, ESTABLISHED et TIME_WAIT
Le mapping port → processus — identifier quel processus possède quel port
Les outils ss et lsof — les alternatives modernes à netstat
📜 Analyse de logs
systemd-journald — interroger des logs structurés avec des filtres temporels
Le kernel ring buffer — où sont journalisés les événements matériels et bas niveau
La corrélation de logs — relier l'activité d'un processus à des événements journalisés


📚 Ressources
📖 Documentation
Linux Process Management — documentation noyau sur les processus
The /proc Filesystem — référence complète sur /proc
Signal Handling in Linux — types de signaux et comportements
ss Command Tutorial — guide des statistiques de sockets
journalctl Guide — interrogation des logs systemd
📄 Pages de manuel
man ps     man top     man kill    man ss

man lsof   man journalctl   man dmesg   man proc


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
🚫 Contraintes
Outils autorisés : ps, grep, awk, ss, lsof, kill, journalctl, dmesg
Interdits : htop (apprends d'abord les commandes brutes), killall (sois chirurgical, pas large)
🔄 Exigences de workflow
Les scripts doivent être développés en local, sur ta machine
Les scripts doivent être déployés sur la cible via scp
Les scripts doivent être exécutés sur la machine distante via ssh <user>@<host>


🔑 Accès au lab
Paramètre
Valeur
🏷️ Nom du lab
M1-Proc-Net
🎯 Hôte cible
[PROVIDED_IP]
👤 Utilisateur
student
🔐 Méthode d'auth
Clé SSH (fournie via l'interface du lab)


Exemple de connexion :

ssh [USER]@[PROVIDED_IP]

🧪 La machine cible fait tourner plusieurs processus suspects simulés à investiguer. Certains vont respawn. Certains vont se cacher. Traite ça comme un vrai incident.



🕵️ You cannot kill what you cannot see.

