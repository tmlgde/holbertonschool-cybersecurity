# Rapport de conformité — Hardened Shield

## 1. Résumé exécutif

Ce rapport atteste que l'image de conteneur **Hardened Shield** respecte les
exigences de sécurité définies pour le déploiement en production de
l'infrastructure conteneurisée de NovaTech Solutions.

L'image intègre l'ensemble des contrôles de sécurité développés au cours des
projets précédents : durcissement système (5x02), gestion des identités et des
accès (5x03) et sécurité des conteneurs (5x04). Elle applique le principe de
**défense en profondeur** : plusieurs couches de sécurité indépendantes, chacune
couvrant la défaillance potentielle d'une autre.

L'image est minimale (~225 Mo), s'exécute sans privilèges root pour
l'application, avec un système de fichiers en lecture seule, des capabilities
restreintes et des limites de ressources. Un outil d'audit automatisé vérifie
la conformité des contrôles.

**Conclusion :** l'image Hardened Shield est conforme aux exigences de sécurité
et prête pour un déploiement en production.

## 2. Périmètre

### 2.1 Éléments couverts
Ce rapport couvre la sécurité de l'image de conteneur **Hardened Shield**
(`hardened-shield:1.0`) et de sa configuration d'exécution :
- l'image de base et les paquets installés (`Dockerfile`) ;
- les scripts de durcissement et d'orchestration (`init-hardening.sh`,
  `init-identity.sh`, `init-services.sh`) ;
- l'outil d'audit (`audit.py`) ;
- la configuration d'exécution (`docker-compose.yml`) ;
- les services hébergés : serveur web (Apache) et serveur SSH.

### 2.2 Éléments hors périmètre
- le durcissement de l'**hôte Docker** (noyau, paramètres sysctl, pare-feu) ;
- la gestion des **clés SSH des administrateurs** (déploiement, rotation) ;
- la **supervision** et la journalisation centralisée en production ;
- l'application web déployée **au-dessus** de cette image de base.

## 3. Contrôles implémentés

| Domaine | Contrôle | Statut |
|---------|----------|--------|
| Système (5x02) | Paramètres kernel (sysctl) tentés / délégués à l'hôte | Implémenté |
| Système (5x02) | Minimisation des services | Implémenté |
| Système (5x02) | Audit SUID/SGID | Implémenté |
| Système (5x02) | Permissions des fichiers sensibles | Implémenté |
| Système (5x02) | Bannière légale | Implémenté |
| Identité (5x03) | Complexité des mots de passe (pam_pwquality) | Implémenté |
| Identité (5x03) | Verrouillage de compte (pam_faillock) | Implémenté |
| Identité (5x03) | Durcissement SSH (clé uniquement, root interdit) | Implémenté |
| Identité (5x03) | Verrouillage du compte root | Implémenté |
| Conteneur (5x04) | Image minimale + utilisateur non-root | Implémenté |
| Conteneur (5x04) | Aucun secret en dur | Implémenté |
| Conteneur (5x04) | Capabilities restreintes (cap_drop ALL) | Implémenté |
| Conteneur (5x04) | no-new-privileges | Implémenté |
| Conteneur (5x04) | Système de fichiers en lecture seule + tmpfs | Implémenté |
| Conteneur (5x04) | Limites de ressources (mémoire, PID, CPU) | Implémenté |
| Conteneur (5x04) | Réseau restreint (ports locaux) | Implémenté |
| Conteneur (5x04) | HEALTHCHECK | Implémenté |

## 4. Résultats des tests

- **Construction de l'image :** réussie, taille finale ~225 Mo (< 500 Mo exigé).
- **Démarrage du conteneur :** le conteneur démarre, atteint l'état « healthy »
  et sert le serveur web (réponse HTTP 200 sur `/health`).
- **Services :** SSH et Apache démarrent et fonctionnent correctement.
- **Lecture seule :** le conteneur fonctionne avec `read_only: true`, les
  écritures étant limitées aux tmpfs.
- **Audit automatisé :** l'outil `audit.py` exécute les 5 catégories de
  contrôles et génère un rapport (`audit_result.md`) avec un score par
  catégorie et un pourcentage global.

## 5. Risques résiduels

- **Noyau partagé :** le conteneur partage le noyau de l'hôte. Une faille du
  noyau ou une mauvaise configuration de l'hôte peut compromettre le conteneur.
  → Mitigation : durcir l'hôte, maintenir le noyau à jour.
- **Paramètres sysctl :** non applicables depuis le conteneur, ils dépendent de
  l'hôte. → Mitigation : les configurer sur l'hôte ou via `docker run --sysctl`.
- **Deux services dans un conteneur :** l'hébergement d'Apache et de SSH dans un
  même conteneur s'écarte du principe « un conteneur = un processus », à la
  demande explicite du client (administration distante requise).
  → Mitigation : orchestration contrôlée, Apache en avant-plan.
- **Clé SSH administrateur :** déployée au runtime, hors de l'image. Sa gestion
  (rotation, protection) relève de l'exploitation.
- **Limites de l'audit automatisé :** un bon score ne garantit pas une sécurité
  totale ; l'analyse humaine reste indispensable.

## 6. Validation

| Rôle | Nom | Date | Décision |
|------|-----|------|----------|
| Security Engineer | CyberShield Consulting | 2026-10-30 | Conforme |
| CISO | Sarah Chen (NovaTech Solutions) | _____ | En attente de signature |

Ce rapport est soumis à l'approbation de la CISO pour autoriser le déploiement
en production de l'image Hardened Shield.
