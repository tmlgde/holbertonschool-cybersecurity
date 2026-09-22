# Incident Response Plan — Compromised Database Scenario

**Date:** 22 septembre 2026
**Auteur:** CISO par intérim
**Audience:** Ce document est écrit pour être exécuté par Sarah et Dave en l'absence du CISO. Chaque étape référence directement les outils déjà déployés dans `technical/`.

## 0. Équipe de réponse et matrice d'escalade

### Annuaire de contacts

| Rôle | Contact | Responsabilité |
|---|---|---|
| CISO par intérim | [nom / téléphone / email] | Coordination générale de la réponse à incident |
| CTO (Dave) | [téléphone / email] | Exécution technique, accès systèmes |
| Lead Dev (Sarah) | [téléphone / email] | Exécution technique, accès applicatif/BDD |
| Conseil juridique | [cabinet / téléphone / email] | Obligations réglementaires, notification de violation de données |
| Communication / PR | [contact / email] | Communication externe si des données clients sont affectées |
| Forces de l'ordre (cybercriminalité) | [contact local pertinent] | À contacter uniquement sur décision du CISO ou de la direction |

### Matrice d'escalade

| Niveau | Déclencheur | Délai de notification | Qui est notifié |
|---|---|---|---|
| Niveau 1 | Anomalie détectée, non confirmée (ex. pic de connexions refusées isolé) | Immédiat, en interne | Dave et/ou Sarah, investigation autonome |
| Niveau 2 | Compromission confirmée (corrélation de plusieurs indicateurs, cf. section Identification) | Dans l'heure suivant la confirmation | CISO |
| Niveau 3 | Compromission confirmée avec exposition de données clients/financières, ou impact sur le calendrier de l'IPO | Dans l'heure suivant la confirmation, en parallèle du Niveau 2 | CISO + Direction + Conseil juridique |
| Niveau 4 | Obligation légale de notification (violation de données avérée) ou suspicion d'activité criminelle nécessitant une plainte | Selon délai réglementaire applicable | Direction + Conseil juridique + Communication + Forces de l'ordre si décidé par la direction |

### Règles d'activation

- **Aucune communication externe** (client, presse, régulateur) ne doit être émise par Dave ou Sarah directement — toute communication externe passe obligatoirement par la Direction et le Conseil juridique, étant donné le contexte sensible de l'IPO.
- L'escalade vers le Niveau 3 est automatique dès qu'une donnée client ou financière est suspectée d'avoir été exposée, indépendamment de la gravité technique perçue de l'incident.

### Modèle de communication interne (statut d'incident)

```
STATUT INCIDENT — [Date/Heure]
Phase actuelle : [Identification/Containment/Eradication/Recovery]
Impact connu : [description courte]
Actions en cours : [description courte]
Prochaine mise à jour prévue : [heure]
```

## 1. Identification

Un événement isolé n'est pas une alerte. Le signal devient significatif lorsque plusieurs indicateurs se combinent :

- Un **volume anormal** de connexions refusées par UFW sur le port de la base de données (`5432`), visible dans les logs centralisés forwardés par `rsyslog` vers le serveur distant.
- Une entrée dans les logs `auditd` taguée `privilege_escalation` ou `identity`, correspondant à une modification non planifiée de `/etc/passwd`, `/etc/sudoers`, ou `/etc/ssh/sshd_config`.
- Une combinaison des deux ci-dessus dans une fenêtre de temps rapprochée est un signal fort de compromission active, pas juste de bruit de fond.

**Action immédiate :** consulter les logs sur le serveur central (jamais uniquement les logs locaux, qui pourraient avoir été altérés) et croiser les deux sources.

## 2. Containment

Objectif : limiter les dégâts sans détruire les preuves. On distingue le containment **immédiat** (à faire dans les premières minutes) du containment **à plus long terme** (le temps que l'investigation se poursuive) — ne pas confondre avec l'Eradication (phase 3), qui vient après, une fois la cause racine confirmée.

### Containment immédiat (court terme)

- **Ne jamais éteindre le serveur.** Couper l'alimentation détruit les preuves volatiles (mémoire, connexions actives) nécessaires à l'investigation.
- **Préserver une preuve avant toute autre action** : effectuer un instantané disque/mémoire du serveur affecté (snapshot de la VM, ou `dd` du disque vers un stockage externe) avant de modifier quoi que ce soit d'autre sur la machine — c'est la seule copie fidèle de l'état au moment de l'intrusion.
- Si l'IP source de l'attaquant est identifiable dans les logs, la bloquer explicitement via UFW (`ufw deny from <IP_ATTAQUANT>`), en plus du blocage général du port DB.
- Utiliser UFW (`network_defense.sh`) pour bloquer immédiatement tout accès entrant sur le port de la base de données, y compris depuis l'IP du serveur web habituellement autorisée, le temps de l'investigation.
- Si un compte utilisateur précis est suspecté d'être compromis, le désactiver immédiatement (`usermod -L <utilisateur>`), sans attendre la fin de l'investigation.

### Containment étendu (le temps de l'investigation)

- **Isoler le système affecté du reste du réseau** : au-delà du simple blocage du port DB, retirer l'hôte compromis de son segment réseau habituel (le placer dans un VLAN/groupe de sécurité de quarantaine dédié), pour empêcher tout mouvement latéral vers d'autres serveurs pendant que l'investigation se poursuit.
- **Révoquer les identifiants compromis** : au-delà de la désactivation du compte suspect, révoquer spécifiquement les identifiants de la base de données elle-même (changer le mot de passe des utilisateurs Postgres concernés), et toute clé SSH ou token d'API potentiellement exposé — pas seulement le compte système Linux.

Ces actions de containment sont temporaires par nature : elles limitent la casse pendant l'investigation, mais ne corrigent pas la cause racine — c'est le rôle de la phase Eradication qui suit.

## 3. Eradication

Une fois la cause racine identifiée via les logs `auditd` et `rsyslog`, l'éradication doit être exhaustive — supprimer la porte d'entrée ne suffit pas si l'attaquant a eu le temps d'installer une persistance ailleurs sur le système.

### Recherche de malware et de mécanismes de persistance

Avant de considérer le système comme propre, vérifier explicitement :

- **Services et processus** : lister les services actifs (`systemctl list-units --type=service`) et les processus en cours, comparer avec l'état de référence connu, identifier tout service ou binaire inconnu.
- **Tâches planifiées** : inspecter `crontab -l` pour chaque utilisateur ainsi que `/etc/cron.d/`, `/etc/cron.daily/`, etc. — un attaquant y installe fréquemment une tâche pour rétablir son accès automatiquement.
- **Clés SSH** : vérifier le contenu de `~/.ssh/authorized_keys` pour **tous** les comptes (pas seulement le compte suspecté), à la recherche d'une clé publique ajoutée par l'attaquant.
- **Configuration sudoers et PAM** : relire `/etc/sudoers`, `/etc/sudoers.d/`, et les fichiers de configuration PAM, pour détecter une règle de privilège ajoutée frauduleusement.
- **Hooks auditd** : vérifier que les règles dans `/etc/audit/rules.d/` n'ont pas été altérées ou désactivées par l'attaquant (rappel : la ligne `-e 2` doit avoir empêché ça jusqu'au prochain reboot — confirmer que c'est bien le cas).
- **Binaires système** : si possible, comparer les checksums des binaires critiques (`/usr/bin/`, `/usr/sbin/`) avec une source de référence connue, à la recherche d'un remplacement malveillant (rootkit).

### Correction de la vulnérabilité exploitée

- Identifier précisément le logiciel, le service ou la version de paquet ayant permis l'intrusion initiale (via les logs), et appliquer le correctif ou la mise à jour correspondante (`apt update && apt upgrade` ciblé, ou changement de configuration explicite du service concerné) — relancer `hardening.sh`/`rbac_setup.sh` restaure la ligne de base attendue, mais ne remplace pas ce correctif applicatif ciblé.

### Rotation complète des identifiants

Réinitialiser **tous** les identifiants potentiellement exposés, explicitement listés :

- Comptes Linux (mots de passe de tous les comptes du groupe concerné, pas seulement le compte suspect)
- Utilisateurs et mots de passe de la base de données elle-même
- Toutes les clés SSH individuelles (voir `access_control_policy.md`)
- Tout token d'API ou identifiant de service (service accounts) utilisé par les applications connectées à la base

### Vérification avant restauration

- Avant de passer à la phase Recovery, **vérifier explicitement l'intégrité de la sauvegarde** qui sera utilisée pour la restauration (checksum, test de restauration sur un environnement isolé) — pour confirmer qu'elle est antérieure à la compromission et qu'elle ne réintroduit pas la porte d'entrée de l'attaquant avec elle.

## 4. Recovery

### Restauration

- Restaurer les données à partir de la **sauvegarde vérifiée** la plus récente **antérieure** à la compromission (jamais une sauvegarde dont la date suit le début de l'incident, au risque de restaurer la porte d'entrée de l'attaquant avec elle).

### Vérification d'intégrité post-restauration

- Une fois les données restaurées, vérifier explicitement leur intégrité avant de les considérer utilisables : comparer les checksums avec ceux connus de la sauvegarde source, exécuter les contraintes d'intégrité natives de la base (contraintes de clé étrangère, cohérence des tables), et comparer un échantillon de données avec les enregistrements attendus.

### Tests de validation avant remise en production

- Avant toute exposition au trafic réel, valider le fonctionnement de la base restaurée et de l'application dans un environnement **isolé** (staging) : exécuter la suite de tests fonctionnels existante, vérifier que l'application se connecte correctement et que les opérations critiques (lecture, écriture, authentification) fonctionnent comme attendu sur des données propres.

### Remise en service progressive

- Remettre le service en ligne progressivement, pas d'un coup : rouvrir d'abord l'accès depuis le serveur web uniquement, sous surveillance renforcée des logs, avant de considérer l'incident clos.

### Période de surveillance renforcée

- Maintenir une surveillance renforcée (vérification active des logs `auditd`/`rsyslog`, pas seulement l'alerting automatique standard) pendant **72 heures minimum** après la remise en service. L'incident n'est déclaré définitivement clos que si, durant cette période, aucune anomalie n'est détectée — sinon, la période de surveillance renforcée est prolongée jusqu'à stabilisation confirmée.

## 5. Lessons Learned

### Réunion de retour d'expérience (post-incident review)

Dans les 5 jours ouvrés suivant la clôture de l'incident, organiser une réunion formelle réunissant le CISO, Dave, Sarah, et la direction. Cette réunion n'est pas optionnelle même si l'incident a été résolu rapidement — c'est elle qui transforme un incident en amélioration réelle du programme de sécurité.

### Analyse de cause racine (Root Cause Analysis)

Produire une analyse de cause racine formelle et écrite, distincte du rapport d'incident chronologique : pas seulement "quelle faille a été exploitée", mais pourquoi elle existait encore (défaut de processus, contrôle manquant, délai de patch, etc.) — la cause racine est souvent organisationnelle, pas uniquement technique.

### Documentation de l'incident

Rédiger un rapport d'incident structuré comme action de clôture formelle (pas de simples notes informelles), incluant : chronologie complète, indicateurs ayant permis la détection, actions de containment/eradication/recovery prises, durée d'indisponibilité, et impact estimé. Ce rapport est conservé comme preuve de traçabilité pour l'auditeur externe.

### Mise à jour des politiques et procédures

- Le `threat_model.md` doit être mis à jour si l'incident a révélé un acteur, un vecteur, ou une menace non anticipée dans l'analyse STRIDE initiale.
- Toute autre politique concernée par l'incident (`access_control_policy.md`, `physical_security_plan.md`) doit être révisée en conséquence, pas seulement le threat model.
- Ce présent document (`incident_response_plan.md`) doit lui-même être mis à jour si la réponse réelle à l'incident a révélé une étape manquante ou mal adaptée dans ce playbook.

### Amélioration des capacités de détection

Si l'incident a mis du temps à être détecté, ou si le signal était présent dans les logs mais pas assez visible, ajuster explicitement les règles `auditd` (`logging_setup.sh`) et les seuils d'alerte pour détecter ce type d'événement plus rapidement à l'avenir.

### Mise à jour des formations

Si l'incident révèle une lacune de sensibilisation (par exemple, un comportement humain ayant facilité l'intrusion), intégrer ce cas concret — anonymisé si nécessaire — dans la prochaine session de formation sécurité de l'équipe, pour que la leçon dépasse le cercle restreint impliqué dans la réponse à l'incident.

### Suivi des actions

Toute mesure de remédiation supplémentaire identifiée durant cette phase doit être documentée, assignée à un responsable et une échéance, et suivie jusqu'à clôture — pas traitée comme un correctif isolé oublié une fois la réunion terminée.
