# Incident Response Plan — Compromised Database Scenario

**Date:** 22 septembre 2026
**Auteur:** CISO par intérim
**Audience:** Ce document est écrit pour être exécuté par Sarah et Dave en l'absence du CISO. Chaque étape référence directement les outils déjà déployés dans `technical/`.

## Contexte

Ce playbook couvre le scénario "Base de données compromise". Il part du principe que les mesures de préparation (`hardening.sh`, `rbac_setup.sh`, `network_defense.sh`, `logging_setup.sh`) sont déjà en place — ce document décrit ce qu'il faut faire **quand**, pas **avant que**, l'incident survienne.

## 1. Identification

Un événement isolé n'est pas une alerte. Le signal devient significatif lorsque plusieurs indicateurs se combinent :

- Un **volume anormal** de connexions refusées par UFW sur le port de la base de données (`5432`), visible dans les logs centralisés forwardés par `rsyslog` vers le serveur distant.
- Une entrée dans les logs `auditd` taguée `privilege_escalation` ou `identity`, correspondant à une modification non planifiée de `/etc/passwd`, `/etc/sudoers`, ou `/etc/ssh/sshd_config`.
- Une combinaison des deux ci-dessus dans une fenêtre de temps rapprochée est un signal fort de compromission active, pas juste de bruit de fond.

**Action immédiate :** consulter les logs sur le serveur central (jamais uniquement les logs locaux, qui pourraient avoir été altérés) et croiser les deux sources.

## 2. Containment

Objectif : limiter les dégâts sans détruire les preuves.

- **Ne jamais éteindre le serveur.** Couper l'alimentation détruit les preuves volatiles (mémoire, connexions actives) qui seraient nécessaires à l'investigation.
- Utiliser **UFW** (`network_defense.sh`) pour bloquer immédiatement tout accès entrant sur le port de la base de données, y compris depuis l'IP du serveur web habituellement autorisée, le temps de l'investigation.
- Si un compte utilisateur précis est suspecté d'être compromis, le désactiver immédiatement (`usermod -L <utilisateur>` ou suppression via les outils de `rbac_setup.sh`), sans attendre la fin de l'investigation.

## 3. Eradication

Une fois la cause racine identifiée via les logs `auditd` et `rsyslog` (comment l'attaquant est entré, quel compte ou quelle faille a été exploitée), il faut l'éliminer réellement, pas seulement bloquer le symptôme :

- Supprimer tout compte utilisateur non identifié ou confirmé malveillant.
- Révoquer et régénérer tous les identifiants (clés SSH, mots de passe) potentiellement exposés par la compromission.
- Fermer définitivement le port ou la règle réseau ayant permis l'intrusion initiale.
- Relancer `hardening.sh` et `rbac_setup.sh` pour s'assurer que la configuration de base n'a pas été altérée par l'attaquant, et repasser sur la configuration voulue.

## 4. Recovery

- Restaurer les données à partir de la **sauvegarde vérifiée** la plus récente **antérieure** à la compromission (jamais une sauvegarde dont la date suit le début de l'incident, au risque de restaurer la porte d'entrée de l'attaquant avec elle).
- Remettre le service en ligne progressivement, pas d'un coup : rouvrir d'abord l'accès depuis le serveur web uniquement, sous surveillance renforcée des logs, avant de considérer l'incident clos.

## 5. Lessons Learned

Dans les jours suivant la résolution de l'incident :

- Un compte-rendu doit être communiqué au CISO, à la direction, et à Dave/Sarah — pas seulement en interne technique, vu les enjeux de l'IPO.
- Le `threat_model.md` doit être mis à jour si l'incident a révélé un acteur, un vecteur, ou une menace non anticipée dans l'analyse STRIDE initiale.
- Toute mesure de remédiation supplémentaire identifiée doit être documentée et intégrée au programme de sécurité, pas traitée comme un correctif isolé.
