# Physical & Human Security Plan — Nexus Financial

**Date:** 21 septembre 2026
**Auteur:** CISO par intérim
**Contexte:** Ce plan répond directement aux constats de sécurité physique et humaine identifiés dans le Threat Model, avec une contrainte budgétaire explicite du CEO — pas de gardiennage biométrique. La logique de priorisation retenue est simple : le coût détermine le délai. Ce qui ne coûte rien peut être corrigé dès aujourd'hui ; ce qui demande un investissement suit dans un second temps.

## 1. Immediate Actions (0 Cost)

Ces actions sont des changements de configuration ou de process, exécutables immédiatement avec les ressources déjà en place :

- **Réseau Wi-Fi** : effacer le mot de passe du tableau blanc et en définir un nouveau, communiqué uniquement via un canal restreint.
- **Clé SSH** : supprimer le message contenant `nexus_master.pem` du channel Slack public et régénérer une nouvelle clé.
- **Base Postgres** : modifier la règle de firewall/security group pour fermer l'accès `0.0.0.0/0` immédiatement.
- **Badges** : réaliser l'inventaire des badges existants dans le système actuel et désactiver toutes les cartes de rechange non tracées.
- **Salle serveur** : retirer l'extincteur qui bloque la porte biométrique, pour que le contrôle d'accès redevienne effectif.
- **PIN admin** : remplacer le PIN actuel (année de naissance du CEO) par une valeur non devinable.
- **Logs** : activer le logging basique déjà disponible sur les systèmes existants (OS, applicatif), même sans centralisation.
- **Sauvegardes** : effectuer un test de restauration immédiat sur les sauvegardes existantes pour vérifier leur intégrité.

## 2. Short Term (Low Cost)

Ces actions consolident les correctifs immédiats avec de petits investissements :

- **Réseau Wi-Fi** : segmenter un réseau invité (VLAN dédié) séparé du réseau interne.
- **Secrets (Wi-Fi, SSH, PIN)** : déployer un coffre-fort à secrets à faible coût (ex. Bitwarden) pour centraliser leur gestion et éviter tout partage informel.
- **Badges** : acquérir un kit d'impression de badges nominatifs avec photo et mettre en place un registre de passage des visiteurs à l'accueil.
- **Salle serveur** : installer un capteur de porte/alarme low-cost signalant toute ouverture prolongée.
- **Logs** : déployer une stack de log open-source auto-hébergée (ex. Grafana Loki), coût limité à l'hébergement.
- **Sauvegardes** : automatiser les tests de restauration via un script planifié récurrent, avec stockage hors-site à bas coût.

## 3. Long Term

Ces actions demandent un vrai projet et un budget dédié :

- **Contrôle d'accès physique** : système de badges nominatif centralisé, intégré au processus RH (désactivation automatique au départ d'un employé).
- **Salle serveur** : authentification à deux facteurs (carte + PIN, biométrie si le budget le permet ultérieurement), avec détection de tailgating.
- **Base Postgres** : accès exclusivement via réseau privé (VPN/bastion host), avec segmentation réseau complète.
- **Détection** : SIEM centralisé avec alerting et capacités IDS.
- **Continuité d'activité** : plan de reprise après sinistre complet, sauvegardes immuables hors-site, RTO/RPO définis formellement.

## 4. Training — Gérer la situation "Delivery Guy TikTok"

Le scénario d'un livreur filmant du contenu dans les locaux et captant par inadvertance des informations sensibles (mot de passe au tableau, écran ouvert, document confidentiel) combine deux failles distinctes, qui appellent chacune une réponse spécifique :

**Accès physique mal contrôlé.** Aucun visiteur, livreur inclus, ne doit dépasser un point de dépôt unique et surveillé situé au rez-de-chaussée. L'accès aux étages reste réservé aux employés badgés et aux visiteurs explicitement escortés.

**Hygiène visuelle défaillante.** Aucune information sensible ne doit être visible ou filmable, même par une personne disposant d'un accès légitime mais limité. Une politique de type "clean desk / clean whiteboard" est appliquée strictement, avec des vérifications visuelles régulières des zones accessibles aux tiers.

**Volet formation employés :**

- Sensibilisation courte (15 min) sur l'interpellation polie de toute personne non badgée ("Je peux vous aider à trouver quelqu'un ?").
- Signalétique visible interdisant photo/vidéo dans les zones non publiques.
- Rappel que toute information affichée (mots de passe, codes, documents) doit être considérée comme potentiellement publique.
- Procédure claire de signalement de comportement suspect au responsable sécurité.

## Synthèse

La structure en trois paliers permet de démontrer à l'auditeur une réduction de risque mesurable dès aujourd'hui, sans attendre un budget non disponible, tout en présentant une trajectoire crédible vers une posture de sécurité mature.
