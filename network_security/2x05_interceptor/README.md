# 🔐 Squid — Proxy Web Sécurisé

> *« Si vous ne pouvez pas le voir, vous ne pouvez pas le sécuriser. »*

## 📖 Introduction

Dans le projet précédent, nous avons mis en place un **pare-feu** permettant de filtrer le trafic selon les adresses IP et les ports.

Ici, nous allons ajouter une couche de sécurité **Layer 7** avec **Squid**, un proxy HTTP/HTTPS.

Contrairement au pare-feu, le proxy peut analyser les requêtes web afin de :

* Bloquer des domaines malveillants
* Bloquer certains types de fichiers (`.exe`, `.bat`, `.ps1`)
* Contrôler les clients autorisés à utiliser le proxy
* Enregistrer les requêtes dans des logs
* Filtrer les connexions HTTPS sans déchiffrer leur contenu

### Proxy Forward vs Reverse

**Forward Proxy :**

```text
Client → Squid → Internet
```

Il protège les utilisateurs et contrôle leur trafic sortant.

**Reverse Proxy :**

```text
Internet → Proxy → Serveur
```

Il protège les serveurs internes contre les connexions entrantes.

Ce projet utilise un **forward proxy**.

---

## 🎯 Contexte

ACME Corp a subi plusieurs incidents de sécurité :

* Des postes infectés communiquant avec des serveurs C2 en HTTPS
* Des fichiers confidentiels envoyés vers un service cloud personnel
* Un manque de visibilité du pare-feu sur le contenu des connexions web

La solution demandée est donc de faire passer le trafic web sortant par Squid.

### Objectifs

* Déployer Squid sur `acme-gw01`
* Autoriser uniquement certains réseaux internes
* Bloquer les domaines malveillants
* Bloquer les fichiers dangereux
* Journaliser les requêtes
* Ne pas utiliser de SSL Bumping

---

## 🏗️ Architecture

```text
                 INTERNET
                     │
                     ▼
              ┌─────────────┐
              │  FIREWALL   │
              └──────┬──────┘
                     │
              ┌──────▼──────┐
              │    SQUID    │
              │  Layer 7    │
              └──────┬──────┘
                     │
                     ▼
              CLIENTS INTERNES
```

Le pare-feu filtre principalement **IP/ports**, tandis que Squid permet un contrôle au niveau **HTTP/HTTPS**.

---

## 🔒 HTTPS et SNI

HTTPS chiffre le contenu des communications.

Le projet ne doit **pas** casser ce chiffrement avec du SSL Bumping.

Squid utilise donc les informations disponibles lors du handshake TLS, notamment le **SNI**, afin d'identifier le domaine demandé.

```text
Client → TLS/SNI → Squid → Internet
                  │
                  └── Vérification du domaine
```

Cela permet de bloquer certains domaines sans déchiffrer le trafic.

---

## 🧩 ACL Squid

Les **ACL (Access Control Lists)** permettent de définir les règles de filtrage.

Exemple :

```text
acl internal src 192.168.1.0/24
```

`src` correspond à l'adresse IP du client.

Pour filtrer une destination :

```text
acl blocked_domains dstdomain "/etc/squid/blacklist.txt"
```

Les règles sont ensuite appliquées avec `http_access`.

> ⚠️ L'ordre des règles est important : les règles sont évaluées dans l'ordre.

---

## 🚫 Filtrage

### Domaines

Une blacklist contient les domaines interdits :

```text
.evil.example
.malware.example
```

### Extensions

Les fichiers dangereux peuvent être bloqués selon leur URL :

```text
.exe
.bat
.ps1
```

> Le filtrage par extension est une couche de sécurité supplémentaire et ne remplace pas un antivirus ou une solution EDR.

---

## 📝 Logs

Les requêtes Squid sont enregistrées dans les logs afin de permettre leur analyse.

Commande utile :

```bash
tail -f /var/log/squid/access.log
```

On peut également utiliser :

```bash
grep
awk
tail
```

pour rechercher et analyser les requêtes.

---

## 🧪 Tests

Les requêtes doivent être testées avec `curl`.

### HTTP

```bash
curl -x http://<PROXY_IP>:<PORT> http://example.com
```

### HTTPS

```bash
curl -x http://<PROXY_IP>:<PORT> https://example.com
```

### Vérification

Tester également :

* Un domaine autorisé
* Un domaine blacklisté
* Un fichier `.exe`
* Un fichier `.bat`
* Un fichier `.ps1`
* La présence des requêtes dans les logs

---

## 🛠️ Environnement

| Élément     | Valeur                          |
| ----------- | ------------------------------- |
| VM          | Multipass                       |
| Hôte        | `acme-gw01`                     |
| Utilisateur | `engineer`                      |
| Proxy       | Squid                           |
| Tests       | curl                            |
| OS          | Kali / ParrotOS / Ubuntu 22.04+ |

Déploiement :

```bash
scp <fichier> engineer@<hôte>:/chemin/
```

Connexion :

```bash
multipass shell acme-gw01
```

---

## 📁 Structure

```text
.
├── README.md
├── scripts/
├── config/
│   ├── squid.conf
│   └── blacklist.txt
└── tests/
```

Les scripts Bash doivent :

* Commencer par `#!/bin/bash`
* Être exécutables
* Se terminer par une nouvelle ligne

---

## ✅ Checklist

* [ ] Squid installé
* [ ] Configuration valide
* [ ] ACL configurées
* [ ] Réseaux autorisés
* [ ] Domaines malveillants bloqués
* [ ] Extensions dangereuses bloquées
* [ ] HTTP testé
* [ ] HTTPS testé
* [ ] Logs fonctionnels
* [ ] Pas de SSL Bumping
* [ ] Tests réalisés avec `curl`

---

## 🧠 À retenir

```text
Pare-feu → IP / Ports / Réseau
Squid    → Requêtes Web / Domaines / URLs / Logs
```

Le pare-feu contrôle **la connexion**.

Squid permet de contrôler **la requête**.

En combinant les deux, ACME Corp bénéficie d'une approche de **défense en profondeur**.

