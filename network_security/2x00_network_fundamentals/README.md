# 🌐 Network Fundamentals — The Blind Auditor

> **Projet pratique de cybersécurité dédié aux fondamentaux réseau : adressage IP, subnetting, routage, ARP, binaire et VLSM.**

---

## 📖 Introduction

En cybersécurité, le réseau est partout.

Chaque attaque traverse un réseau, chaque défense protège un réseau et chaque analyse forensique peut nécessiter de comprendre les flux réseau.

> **Comprendre le réseau, c'est comprendre une grande partie de la cybersécurité.**

Ce projet permet de travailler ces notions directement depuis le terminal Linux, sans outils graphiques.

---

## 🎯 Le scénario — *The Blind Auditor*

Vous êtes chargé d'auditer l'infrastructure réseau de **ACME Corp**.

Le problème : la documentation est inexistante ou obsolète.

Vous disposez uniquement d'un poste Linux connecté au réseau.

### Votre mission

1. 🧮 **Créer des scripts** pour effectuer des calculs IP et subnetting.
2. 🗺️ **Analyser le réseau** avec les tables de routage et le cache ARP.
3. 🧩 **Concevoir une segmentation** réseau avec le VLSM.
4. 🛰️ **Comprendre le cheminement** des paquets entre une source et une destination.

---

## 🧠 Objectifs

À la fin du projet, vous devez comprendre :

### Adressage & Subnetting

* Conversion décimal ↔ binaire
* Fonctionnement des adresses IPv4 sur 32 bits
* Masques de sous-réseau
* Notation CIDR
* Network ID et Broadcast
* Plages d'adresses utilisables
* VLSM

### Routage & Réseau

* Différence entre destination locale et distante
* Fonctionnement d'ARP
* Rôle de la passerelle par défaut
* Lecture d'une table de routage
* Notion de **next hop**
* Fonctionnement du TTL
* Différence entre **on-link** et **off-link**

---

## 🛠️ Commandes principales

```bash
ip address
ip route
ip neighbour
ping
traceroute
bc
```

Documentation utile :

```bash
man ip-address
man ip-route
man ip-neighbour
man bc
man bash
```

---

## 📋 Contraintes

Le projet doit fonctionner sur :

* Kali Linux
* ParrotOS
* Ubuntu 22.04+

### Scripts Bash

Tous les scripts doivent :

* Être exécutables avec `chmod +x`
* Commencer exactement par `#!/bin/bash`
* Contenir **exactement 2 lignes**
* Se terminer par une nouvelle ligne
* Utiliser uniquement les outils et contraintes demandés par le projet

Vérification :

```bash
wc -l script
```

---

## 📂 Structure

```text
.
├── README.md
├── ...
└── ...
```

La structure exacte dépend des exercices réalisés.

---

## 🎓 Ce que vous allez apprendre

```text
IPv4
  ↓
Binaire & CIDR
  ↓
Subnetting
  ↓
ARP & MAC
  ↓
Routage
  ↓
VLSM
  ↓
Flux réseau
```

L'objectif n'est pas seulement de connaître des commandes, mais de **comprendre ce qui se passe réellement lorsqu'un paquet traverse un réseau**.

> 🔐 **Don't just use the network. Understand it.**
