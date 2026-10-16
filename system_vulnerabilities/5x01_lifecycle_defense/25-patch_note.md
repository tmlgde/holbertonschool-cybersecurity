# NovaTech Solutions — Patch Management Policy

**Document owner:** CyberShield Consulting (Security Engineering)
**Approved by:** NovaTech CISO
**Date:** 2026-10-16
**Classification:** Internal

## 1. Purpose and Scope
Cette policy définit comment NovaTech applique les mises à jour de sécurité de façon sûre sur son serveur de production. Son objectif est de réduire le risque lié aux vulnérabilités connues tout en préservant la continuité de service. Elle s'applique au serveur de production `novatech-prod` et à l'ensemble des paquets qui y sont installés.

## 2. Roles and Responsibilities
- **Security Engineer** : configure et maintient le système de gestion des patches (mises à jour automatiques, blacklist, holds, sauvegardes), et assure le suivi des incidents liés aux mises à jour.
- **CISO** : approuve cette policy, reçoit les rapports et notifications de mises à jour, et valide les patches d'urgence hors cycle.
- **System Administrators** : gèrent manuellement les paquets critiques blacklistés qui nécessitent une revue avant mise à jour, et révisent régulièrement les holds en place.

## 3. Patch Classification
Les patches sont classés selon leur criticité, qui détermine le délai maximal de correction :
- **Critical** : correction sous 24-48 heures (faille activement exploitée, impact majeur).
- **High** : correction sous 7 jours.
- **Medium** : correction sous 30 jours.
- **Low** : correction sous 90 jours.
La criticité combine le score CVSS, l'exploitabilité réelle et l'impact business.

## 4. Update Schedule
Les mises à jour automatiques s'exécutent pendant une fenêtre de maintenance nocturne, lorsque le trafic est minimal :
- **02:00** : mise à jour de la liste des paquets
- **03:00** : installation des mises à jour de sécurité
- **04:00** : redémarrage automatique si une mise à jour du noyau l'exige (uniquement si aucun utilisateur n'est connecté)
- **Fenêtre de maintenance : 02:00 - 05:00**
Ce créneau est choisi pour minimiser l'impact sur l'activité : une mise à jour appliquée en pleine journée peut provoquer une interruption de service coûteuse.

## 5. Protected Packages
Certains paquets critiques sont exclus des mises à jour automatiques (blacklist), car une mise à jour non supervisée pourrait interrompre la production :
- `apache2`, `apache2-bin` (serveur web)
- `mysql-server`, `mysql-server-*` (base de données)
- `nginx` (serveur web)
- `docker-ce` (conteneurs)
Ces paquets sont mis à jour manuellement, après revue et test, pendant une fenêtre de maintenance planifiée. Même les mises à jour de sécurité de ces paquets passent par une validation humaine.

## 6. Exception Process
Un hold peut être placé sur un paquet pour éviter qu'une version buggée ne soit réinstallée automatiquement (par exemple après une régression constatée).
- Tout hold doit être documenté : la raison, le paquet, la version et la date sont enregistrés dans `/var/log/package_holds.log`.
- Un hold est une mesure temporaire : il doit être révisé régulièrement (sous 14 à 30 jours), car il bloque aussi les mises à jour de sécurité du paquet concerné.
- Le hold est libéré dès que le problème upstream est corrigé.
Toute addition à la blacklist suit le même processus : justification documentée et révision périodique.

## 7. Emergency Patching
Lorsqu'une faille critique est activement exploitée (par exemple listée au catalogue CISA KEV), un patch peut être appliqué en urgence, hors du cycle de maintenance normal (out-of-band).
Même en urgence, les règles de prudence s'appliquent :
- Sauvegarde (backup) de la configuration avant toute modification.
- Test en dry-run quand c'est possible, pour valider l'impact.
- Plan de rollback prêt, permettant de revenir en arrière si le patch provoque une régression.
Un patch d'urgence requiert l'approbation du CISO et toute l'opération est documentée.

## 8. Compliance and Auditing
Le respect de cette policy est vérifié grâce à une traçabilité complète :
- **Journalisation** : toutes les mises à jour sont enregistrées dans syslog et dans des fichiers de log dédiés (`/var/log/unattended-upgrades/`).
- **Notifications** : le CISO reçoit un rapport par email à chaque changement appliqué.
- **Audits réguliers** : des revues périodiques vérifient que la configuration et les procédures sont conformes à cette policy, et que les holds en place sont justifiés et à jour.
