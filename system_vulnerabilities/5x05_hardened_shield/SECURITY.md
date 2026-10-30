# SECURITY.md — Hardened Shield

## 1. Vue d'ensemble de l'architecture

Le **Hardened Shield** est une image de conteneur durcie, prête pour la
production, qui intègre tous les contrôles de sécurité des projets 5x02
(durcissement système), 5x03 (gestion des identités et des accès) et 5x04
(sécurité des conteneurs).

### Base
- **Image de base :** `python:3.11-slim` — empreinte minimale (~225 Mo),
  faible surface d'attaque, Python inclus pour l'outil d'audit.
- **Utilisateur non-root :** un utilisateur dédié `appuser` (UID 1000) avec un
  shell `nologin`.
- **Services :** Apache (web, port 80) et OpenSSH (administration distante,
  port 22).

### Configuration au build vs au runtime
Décision d'architecture clé : **toute la configuration de sécurité est
appliquée au moment du BUILD** (dans le Dockerfile), pas au runtime. Cela
produit une image immuable qui peut s'exécuter avec un système de fichiers
en **lecture seule** (read-only) au runtime.

### Orchestration au démarrage
Au démarrage du conteneur, `init-services.sh` (PID 1) prépare les répertoires
runtime (tmpfs), lance SSH (en arrière-plan) et Apache (en avant-plan).
Apache en avant-plan maintient le conteneur en vie : s'il plante, le conteneur
s'arrête et la politique de redémarrage le relance.

### Défense en profondeur
Chaque couche couvre la défaillance de la précédente : image minimale →
non-root → pas de secrets → capabilities retirées → système de fichiers en
lecture seule → limites de ressources → réseau restreint.


## 2. Contrôles de sécurité

### 2.1 Durcissement système (Projet 5x02)
Appliqué par `init-hardening.sh` au build :
- **Paramètres kernel (sysctl) :** tentés, puis **délégués à l'hôte** s'ils
  échouent. Le kernel étant partagé avec l'hôte, un conteneur ne peut pas le
  modifier ; ces paramètres doivent être fixés sur l'hôte ou via
  `docker run --sysctl`.
- **Minimisation des services :** l'image minimale ne contient déjà pas les
  services inutiles (cups, avahi, bluetooth).
- **Audit SUID/SGID :** inventaire des binaires à bits SUID/SGID.
- **Sécurité des fichiers :** permissions strictes sur les fichiers sensibles
  (`/etc/shadow`, `/etc/ssh`), umask restrictif.
- **Bannière légale :** avertissement dans `/etc/issue.net`.

### 2.2 Gestion des identités (Projet 5x03)
Appliqué par `init-identity.sh` au build :
- **Complexité des mots de passe :** `pam_pwquality` (minlen=12, majuscule,
  minuscule, chiffre, caractère spécial obligatoires).
- **Verrouillage de compte :** `pam_faillock` (5 échecs, déverrouillage auto
  après 15 min).
- **Durcissement SSH :** authentification par mot de passe désactivée,
  connexion root interdite, authentification par clé publique uniquement.
- **Verrouillage du compte root :** `passwd -l root`.

### 2.3 Sécurité du conteneur (Projet 5x04)
Appliqué via le Dockerfile et `docker-compose.yml` :
- **Image minimale + non-root :** faible surface d'attaque, exécution sans
  privilèges root pour l'application.
- **Pas de secrets en dur :** aucun mot de passe/clé dans l'image.
- **Capabilities restreintes :** `cap_drop: ALL`, puis ajout du strict minimum
  (NET_BIND_SERVICE, CHOWN, SETUID, SETGID pour Apache).
- **no-new-privileges :** empêche tout gain de privilège via setuid.
- **Système de fichiers en lecture seule :** `read_only: true`, avec des
  tmpfs (`/tmp` en noexec/nosuid) pour les répertoires d'écriture nécessaires.
- **Limites de ressources :** mémoire (256 Mo, sans swap), PID (100), CPU (0.5).
- **Réseau restreint :** ports exposés en local seulement (127.0.0.1).
- **HEALTHCHECK :** surveillance de la disponibilité du serveur web.


## 3. Instructions d'utilisation

### 3.1 Construire l'image
```bash
docker build -t hardened-shield:1.0 .
```

### 3.2 Lancer le conteneur (méthode recommandée)
Utiliser `docker-compose`, qui applique automatiquement toutes les options de
sécurité runtime :
```bash
docker compose up -d
```

### 3.3 Vérifier l'état
```bash
docker compose ps                        # statut du conteneur (doit être "healthy")
docker compose logs                      # logs de démarrage
curl http://localhost:8080/health        # test du serveur web (doit répondre "OK")
```

### 3.4 Accès
- **Web :** http://127.0.0.1:8080
- **SSH :** `ssh -p 2222 appuser@127.0.0.1` (authentification par clé publique
  uniquement — la clé publique de l'administrateur doit être déployée dans
  `authorized_keys`, voir section Maintenance).

### 3.5 Arrêter le conteneur
```bash
docker compose down
```

## 4. Procédures d'audit

### 4.1 Outil d'audit intégré
L'image embarque un outil d'audit Python (`audit.py`) qui vérifie 5 catégories
de contrôles : kernel, système de fichiers, identité, services et conteneur.

### 4.2 Lancer un audit sur le conteneur en cours
```bash
docker exec hardened-shield python /usr/local/bin/audit.py
```
L'audit affiche un rapport par catégorie, un score par catégorie, un pourcentage
global et un statut PASS/FAIL. Il génère également un rapport Markdown
(`audit_result.md`).

### 4.3 Interprétation
- **PASS/FAIL par contrôle :** chaque contrôle est vérifié individuellement.
- **Score par catégorie :** nombre de contrôles réussis / total.
- **Pourcentage global :** l'audit est considéré réussi à partir de 80 %.
- **Code de sortie :** 0 si réussi (≥ 80 %), 1 sinon.

### 4.4 Audits externes recommandés
En complément de l'audit intégré, il est recommandé d'utiliser :
- **hadolint** — analyse du Dockerfile (avant le build).
- **Trivy** — analyse des CVE de l'image (après le build).
- **docker-bench-security** — audit du conteneur selon le CIS (en marche).

> Note : un bon score d'audit ne garantit pas une sécurité totale. L'analyse
> humaine reste indispensable (certains contrôles, comme la gestion des secrets,
> ne sont pas entièrement détectables automatiquement).


## 5. Directives de maintenance

### 5.1 Déploiement de la clé SSH de l'administrateur
L'authentification SSH se fait par clé publique uniquement. La clé publique de
l'administrateur doit être déployée au runtime (elle n'est pas incluse dans
l'image). Par exemple, via un volume monté :
```bash
docker run -d \
  -v /chemin/vers/authorized_keys:/home/appuser/.ssh/authorized_keys:ro \
  hardened-shield:1.0
```

### 5.2 Mises à jour de sécurité
- Reconstruire régulièrement l'image pour intégrer les correctifs de sécurité
  des paquets (`docker build --no-cache`).
- Surveiller les CVE de l'image de base avec Trivy.
- Ne jamais utiliser le tag `latest` en production : fixer les versions
  (reproductibilité, protection contre les attaques de la chaîne
  d'approvisionnement).

### 5.3 Modification de la configuration de sécurité
- La configuration étant appliquée au build, toute modification des scripts
  `init-*.sh` nécessite une **reconstruction** de l'image (`docker build`).
- Après modification, relancer un audit (`audit.py`) pour vérifier la conformité.

### 5.4 Paramètres kernel (hôte)
Les paramètres sysctl (ip_forward, rp_filter, etc.) ne peuvent pas être
appliqués depuis le conteneur (kernel partagé). Ils doivent être configurés
sur l'**hôte** ou via `docker run --sysctl`.

### 5.5 Surveillance
- Vérifier régulièrement l'état du conteneur (`docker compose ps` → "healthy").
- Consulter les logs (`docker compose logs`) pour détecter les anomalies au
  démarrage.
- En cas d'incident, isoler le conteneur du réseau et préserver les preuves
  avant toute action (`docker inspect`, `docker logs`).
