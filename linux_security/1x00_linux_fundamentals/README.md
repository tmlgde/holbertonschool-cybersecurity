# 🐧 Linux Fundamentals & Security Baseline

> **« En cybersécurité, Linux est la langue commune. Si tu ne la parles pas couramment, tu es un touriste. »**

Projet pratique consacré aux **fondamentaux Linux et à la sécurisation d'un système**, avec un focus sur les permissions, les fichiers, les utilisateurs, les ACL et l'administration distante.

---

## 📑 Sommaire

* 🧭 [Introduction](#-introduction)
* ❓ [Pourquoi Linux ?](#-pourquoi-linux)
* 🔎 [Objectifs du projet](#-objectifs-du-projet)
* 📂 [Contexte — Toxic Legacy](#-contexte--toxic-legacy)
* 🎯 [Compétences](#-compétences)
* 🛠️ [Outils](#️-outils)
* 📋 [Exigences](#-exigences)
* 🔄 [Workflow](#-workflow)

---

## 🧭 Introduction

Linux constitue une base essentielle de la cybersécurité moderne.

Serveurs web, infrastructures cloud, outils de sécurité, plateformes SIEM, environnements de forensic et containers reposent largement sur Linux.

Ce projet ne consiste donc pas simplement à mémoriser des commandes.

L'objectif est de développer une **fluidité opérationnelle** : savoir naviguer dans un système, comprendre ses permissions, identifier des configurations dangereuses et automatiser les actions de sécurité depuis le terminal.

> **Pas de tutoriel pas-à-pas. Une mission, un environnement et une contrainte : débrouille-toi.**

---

## ❓ Pourquoi Linux ?

Linux est présent dans de nombreux domaines de la cybersécurité :

| Métier                      | Utilisation de Linux                               |
| --------------------------- | -------------------------------------------------- |
| 🎯 **Pentester**            | Exploitation, shells, pivots et outils de sécurité |
| 🖥️ **SOC Analyst**         | Logs, serveurs et investigation                    |
| 🦠 **Malware Analyst**      | Sandboxes et environnements d'analyse              |
| ☁️ **Cloud Security**       | Infrastructures cloud et containers                |
| 🔍 **Forensic**             | Acquisition et analyse de systèmes                 |
| 🕵️ **Threat Intelligence** | OSINT et automatisation                            |
| 🛠️ **Security Engineer**   | Automatisation et développement d'outils           |

---

## 🔎 Objectifs du projet

Le but est de savoir **auditer et sécuriser un serveur Linux**, plutôt que simplement exécuter des commandes.

Les principaux sujets abordés sont :

* 🗂️ Hiérarchie du système de fichiers
* 🔐 Permissions `rwx`
* 🔢 Permissions octales et symboliques
* 👤 Propriétaires et groupes
* ⚠️ SUID, SGID et Sticky Bit
* 🔎 Recherche de fichiers avec `find`
* 🧩 Analyse de contenu avec `grep`
* 🔑 ACL avec `setfacl` et `getfacl`
* 🌐 Administration distante avec SSH/SCP
* 🛡️ Principe du moindre privilège
* 🧱 Défense en profondeur

---

## 📂 Contexte — *Toxic Legacy*

**De :** Marcus Chen, Directeur IT — ACME Corp
**À :** Junior Security Engineer
**Sujet :** 🚨 URGENT — Remédiation du serveur legacy
**Priorité :** Haute

Votre prédécesseur a laissé le serveur `srv-legacy-01` dans un état particulièrement dangereux.

| Problème                     | Mauvaise solution           | Risque                           |
| ---------------------------- | --------------------------- | -------------------------------- |
| Accès en écriture nécessaire | `chmod 777`                 | Exposition de fichiers sensibles |
| Mot de passe oublié          | Stockage en clair           | Fuite d'identifiants             |
| Nouveau développeur          | Ajout à de nombreux groupes | Privilèges excessifs             |
| Backup défaillant            | SUID sur des binaires       | Élévation de privilèges          |

### 🎯 Votre mission

Vous disposez d'un accès SSH au serveur.

Vous devez :

1. 🔍 **Auditer** l'environnement.
2. 🚨 **Identifier** les mauvaises configurations.
3. 🔧 **Corriger** les problèmes.
4. 🛡️ **Réduire** les privilèges inutiles.
5. 🤖 **Automatiser** les opérations.

### 🚫 Une contrainte essentielle

**Aucune correction manuelle directement sur le serveur.**

Le workflow doit être :

```text
💻 Développement local
        ↓
🧪 Tests
        ↓
📤 SCP
        ↓
🖥️ Serveur distant
        ↓
🔐 SSH
        ↓
⚙️ Exécution
```

L'objectif est de reproduire une approche professionnelle basée sur l'automatisation et l'Infrastructure as Code.

---

## 🎯 Compétences

### 🧱 Fondamentaux Linux

* Comprendre `/etc`, `/var`, `/home`, `/usr`, etc.
* Maîtriser les permissions `rwx`
* Convertir entre notation octale et symbolique
* Comprendre les propriétaires et groupes
* Comprendre SUID, SGID et Sticky Bit

### ⚙️ Compétences opérationnelles

* Administrer un système à distance avec SSH/SCP
* Rechercher précisément des fichiers avec `find`
* Analyser des fichiers avec `grep`
* Utiliser les expressions régulières
* Manipuler les ACL avec `setfacl` et `getfacl`

### 🛡️ Réflexes sécurité

> **Auditer avant de corriger.**

Le projet insiste sur trois principes essentiels :

**Moindre privilège**
→ Accorder uniquement les permissions nécessaires.

**Défense en profondeur**
→ Ne jamais dépendre d'une seule mesure de sécurité.

**Remédiation contrôlée**
→ Comprendre le problème avant de modifier le système.

---

## 🛠️ Outils principaux

```bash id="bkg5s8"
chmod
chown
find
grep
setfacl
getfacl
ssh
scp
```

Pages de manuel utiles :

```bash id="v4j9gz"
man chmod
man chown
man find
man grep
man setfacl
man getfacl
man ssh
man scp
```

---

## 📋 Exigences

### 🌐 Général

Le projet doit fonctionner sur :

* Kali Linux
* ParrotOS
* Ubuntu 22.04+

Éditeurs autorisés :

* `vi`
* `vim`
* `emacs`
* `nano`

Un `README.md` doit être présent à la racine du projet.

### 📜 Bash

Tous les scripts doivent :

* Être exécutables avec `chmod +x`
* Commencer exactement par :

```bash id="v8z87s"
#!/bin/bash
```

* Contenir **exactement 2 lignes**
* Se terminer par une nouvelle ligne
* Produire une sortie propre
* Utiliser les pipes et opérateurs logiques lorsque nécessaire

Vérification :

```bash id="a9qz0v"
wc -l fichier
```

Le résultat attendu est :

```text id="k8r3by"
2
```

---

## 🔄 Workflow

```text
┌──────────────────────┐
│  💻 Machine locale   │
│  Écriture du script  │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│      🧪 Tests        │
└──────────┬───────────┘
           │ SCP
           ▼
┌──────────────────────┐
│   🖥️ Serveur cible   │
└──────────┬───────────┘
           │ SSH
           ▼
┌──────────────────────┐
│  ⚙️ Exécution        │
│  🔍 Audit / 🔧 Fix   │
└──────────────────────┘
```

> 🐧 **Comprendre Linux, c'est comprendre le système sur lequel repose une grande partie de la cybersécurité.**
>
> 🔐 **Audit. Automatisation. Moindre privilège. Sécurisation.**
