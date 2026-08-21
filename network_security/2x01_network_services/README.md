# 🌐 DNS & DHCP — The Lost Emails

> **Projet pratique de cybersécurité consacré au DNS, DHCP, à la résolution de noms et aux problèmes de configuration réseau.**

---

## 📖 Introduction

> *"It's not DNS. There's no way it's DNS. It was DNS."* — **The Sysadmin Haiku**

Le **DNS** est l'annuaire d'Internet : il permet de transformer un nom de domaine comme `google.com` en adresse IP.

Le **DHCP**, lui, permet à une machine d'obtenir automatiquement sa configuration réseau : adresse IP, passerelle, serveur DNS, durée du bail, etc.

Ces deux protocoles fonctionnent généralement sans que l'utilisateur s'en rende compte. Pourtant, une mauvaise configuration ou une attaque peut avoir des conséquences importantes :

* 🔎 Reconnaissance et découverte d'infrastructure
* 🎣 Détection du phishing
* 🦠 Analyse des communications de malware
* 🚨 Investigation d'incidents
* 🕵️ Détection de DNS poisoning
* ⚠️ Rogue DHCP et attaques Man-in-the-Middle
* 🛡️ DHCP Snooping et sécurisation du réseau

---

## 🎯 Le scénario — *The Lost Emails*

ACME Corp rencontre plusieurs problèmes :

* Certains utilisateurs n'accèdent plus à `intranet.acme.corp`
* Des emails retournent des erreurs *domain not found*
* Certaines machines utilisent de mauvais serveurs DNS
* Un utilisateur affirme avoir été redirigé vers un faux site bancaire

Votre mission est d'auditer l'infrastructure **DNS/DHCP** afin de comprendre l'origine de ces problèmes.

### Votre mission

Créer une boîte à outils capable de :

1. 🔍 Identifier le serveur **DNS** et **DHCP** utilisé par une machine.
2. 📋 Interroger différents types d'enregistrements DNS.
3. 🌐 Suivre le chemin de résolution DNS.
4. ⚠️ Détecter des configurations dangereuses, notamment les **transferts de zone ouverts**.

---

## 🧠 Objectifs

### DNS

* Comprendre les requêtes récursives et itératives
* Comprendre la hiérarchie DNS :
  `Root → TLD → Authoritative`
* Connaître les principaux enregistrements :
  `A`, `AAAA`, `CNAME`, `MX`, `TXT`, `PTR`, `SOA`, `NS`
* Comprendre le **TTL** et le fonctionnement du cache DNS
* Comprendre le rôle de `/etc/hosts`
* Comprendre les enregistrements **SPF**
* Tester les transferts de zone
* Interroger directement un serveur DNS

### DHCP

Comprendre le processus **DORA** :

```text
Discover → Offer → Request → Acknowledge
```

Et identifier les informations fournies par DHCP :

```text
IP
Gateway
DNS
Lease Time
```

Comprendre également :

* Où sont stockées les informations DHCP sous Linux
* Le fonctionnement d'un **Rogue DHCP**
* Le principe du **DHCP Snooping**

---

## 🛠️ Outils principaux

```bash
dig
nslookup
host
```

Fichiers Linux importants :

```text
/etc/resolv.conf
/etc/hosts
DHCP lease files
```

Documentation utile :

```bash
man dig
man nslookup
man host
man resolv.conf
man hosts
man dhclient
```

---

## 🔎 Compétences pratiques

Le projet permet notamment de pratiquer :

* Requêtes DNS avec `dig`
* Recherche d'enregistrements spécifiques
* Reverse DNS
* Analyse de `/etc/resolv.conf`
* Analyse des informations DHCP
* Identification du serveur DNS utilisé
* Vérification de la configuration des domaines
* Détection de mauvaises configurations DNS

---

## 📋 Contraintes

Le projet doit fonctionner sur :

* Kali Linux
* ParrotOS
* Ubuntu 22.04+

### Scripts Bash

Tous les scripts doivent :

* Être exécutables avec `chmod +x`
* Commencer exactement par :

```bash
#!/bin/bash
```

* Contenir **exactement 2 lignes**
* Se terminer par une nouvelle ligne
* Produire une sortie propre, sans messages de debug inutiles

Vérification :

```bash
wc -l script
```

Les pipes et opérateurs logiques sont autorisés et encouragés.

---

## 🚀 Workflow

Les scripts doivent être :

```text
Développement local
       ↓
      scp
       ↓
Serveur distant
       ↓
      ssh
       ↓
   Exécution
```

L'objectif est donc de développer les outils localement, puis de les déployer et de les tester à distance.

---

## 🎓 Ce que vous allez apprendre

```text
DNS
 │
 ├── Records
 ├── Résolution
 ├── Cache & TTL
 └── Sécurité
        │
        ▼
DHCP
 │
 ├── DORA
 ├── Configuration réseau
 └── Rogue DHCP
        │
        ▼
Diagnostic
        │
        ▼
Sécurisation
```

> 🔐 **DNS et DHCP sont des services invisibles, mais essentiels. Comprendre leur fonctionnement permet de mieux diagnostiquer, détecter et sécuriser un réseau.**
