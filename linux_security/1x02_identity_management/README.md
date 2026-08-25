# 🔐 Identity & Access Management — The Identity Purge

> **« Identity is the new perimeter. »**

Projet pratique consacré à la **gestion des identités, des privilèges et de l'authentification sous Linux**.

L'objectif est d'apprendre à détecter les comptes suspects, sécuriser les mécanismes d'authentification et appliquer le principe du **moindre privilège**.

---

## 📑 Sommaire

* 🧭 [Introduction](#-introduction)
* 📂 [Contexte — The Identity Purge](#-contexte--the-identity-purge)
* 🎯 [Objectifs](#-objectifs)
* 🛡️ [Sécurité](#️-sécurité)
* 🛠️ [Outils](#️-outils)
* 📋 [Exigences](#-exigences)
* 🔄 [Workflow](#-workflow)
* 🧪 [Lab](#-lab)

---

## 🧭 Introduction

Les firewalls ne suffisent plus à définir une frontière de sécurité.

Lorsqu'un attaquant vole des identifiants, il peut entrer dans le système en utilisant une identité légitime. Si cette identité dispose de privilèges excessifs, le compromis peut rapidement devenir critique.

Un Security Engineer doit donc savoir :

1. 🔎 **Auditer** les comptes existants
2. 🛡️ **Sécuriser** l'authentification
3. 🔐 **Limiter** les privilèges
4. 🚨 **Détecter** les comptes et configurations dangereuses

Ce projet couvre ainsi le cycle complet de la sécurité des identités Linux.

---

## 📂 Contexte — *The Identity Purge*

**De :** Marcus Chen, IT Director — ACME Corp
**À :** Security Engineer
**Sujet :** 🚨 Audit des identités — comptes suspects
**Priorité :** Haute

Un audit de sécurité a identifié plusieurs problèmes sur `srv-legacy-01` :

| Problème                            | Risque      | Description                                     |
| ----------------------------------- | ----------- | ----------------------------------------------- |
| 👻 UID `0` supplémentaires          | 🔴 Critique | Des comptes autres que `root` possèdent l'UID 0 |
| 🖥️ Comptes de service avec shell   | 🟠 Élevé    | `www-data` possède un shell interactif          |
| 🔑 Hash faibles                     | 🟠 Élevé    | Certains comptes utilisent encore MD5           |
| 🚪 Root via SSH                     | 🟡 Moyen    | Connexion directe de `root` autorisée           |
| 🔐 Pas de politique de mot de passe | 🟡 Moyen    | PAM n'impose pas de règles suffisantes          |

### 🎯 Votre mission

Créer une suite de scripts capables de :

* 🔍 Détecter ces problèmes
* 🔧 Corriger les mauvaises configurations
* 🛡️ Renforcer l'authentification
* 🔐 Réduire les privilèges inutiles
* ♻️ Réutiliser les outils sur d'autres systèmes Linux

> **L'objectif n'est pas seulement de corriger une machine, mais de créer des outils d'audit réutilisables.**

---

## 🎯 Objectifs

### 👤 Identités Linux

Comprendre :

* La structure de `/etc/passwd`
* La structure de `/etc/shadow`
* Le rôle du **UID 0**
* La différence entre comptes humains et comptes de service
* Les formats de hash `$1$`, `$5$` et `$6$`

### 🔐 Gestion des privilèges

Savoir identifier :

* Les groupes dangereux
* Les privilèges liés à `docker`, `disk` ou `shadow`
* Les règles `sudoers`
* Les risques liés à `NOPASSWD`
* Les permissions excessives

### 🛡️ Authentification

Comprendre :

* Le durcissement de SSH
* L'authentification par clés
* La désactivation de l'accès SSH direct à `root`
* Le fonctionnement de PAM
* Les politiques de mots de passe
* Le principe du **passwordless onboarding**

---

## 🛠️ Outils principaux

```text id="n4v0m8"
/etc/passwd
/etc/shadow
/etc/sudoers
/etc/ssh/sshd_config
PAM
```

Commandes utiles :

```bash id="7h4b3p"
passwd
useradd
usermod
groupadd
sudo
ssh
```

Pages de manuel :

```bash id="4w0kz2"
man passwd
man shadow
man useradd
man usermod
man groupadd
man sudoer
man sshd_config
man pam
```

---

## 🛡️ Principes de sécurité

### 🔐 Moindre privilège

Un utilisateur ou un processus ne doit disposer que des permissions nécessaires à son activité.

### 🚨 Réduction du risque

Un compte compromis ne doit pas permettre automatiquement de compromettre toute la machine.

### 🔑 Authentification forte

Privilégier les clés SSH et éviter les mécanismes d'authentification faciles à voler ou à bruteforcer.

### 👻 Comptes de service

Les comptes qui n'ont pas besoin de connexion interactive doivent utiliser un shell approprié, par exemple :

```text id="9i4xcy"
/usr/sbin/nologin
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

Un `README.md` doit être présent à la racine.

### 📜 Bash

Tous les scripts doivent :

* Être exécutables avec `chmod +x`
* Commencer exactement par :

```bash id="z9q6yh"
#!/bin/bash
```

* Contenir **exactement 2 lignes**
* Se terminer par une nouvelle ligne
* Produire une sortie propre
* Utiliser les pipes et opérateurs logiques lorsque nécessaire

Vérification :

```bash id="s7n1gd"
wc -l fichier
```

Résultat attendu :

```text id="6nb3hs"
2
```

### 🔑 Privilèges

Certaines opérations nécessitent `sudo`, notamment pour :

* Lire `/etc/shadow`
* Modifier la configuration système
* Modifier les utilisateurs ou groupes
* Modifier SSH ou PAM

> ⚠️ Tester les scripts sur un environnement de laboratoire avant toute utilisation sur un système de production.

---

## ⚠️ Attention à SSH

Lors de la modification de la configuration SSH :

> **Gardez toujours une seconde session SSH ouverte.**

Une mauvaise configuration peut provoquer une perte d'accès au serveur.

---

## 🔄 Workflow

Les scripts doivent être développés localement puis exécutés sur la machine distante.

```text id="c8m2tj"
💻 Développement local
        ↓
🧪 Tests
        ↓
📤 SCP
        ↓
🖥️ Machine cible
        ↓
🔐 SSH
        ↓
🔍 Audit / 🛡️ Hardening
```

Connexion distante :

```bash id="v8x4qb"
ssh <user>@<host>
```

---

## 🧪 Lab

| Paramètre            | Valeur          |
| -------------------- | --------------- |
| **Lab**              | M1-Identity     |
| **Machine cible**    | `[PROVIDED_IP]` |
| **Utilisateur**      | `student`       |
| **Authentification** | Clé SSH         |

Connexion :

```bash id="gqz3jp"
ssh student@[PROVIDED_IP]
```

---

## 🎓 Résultat attendu

À la fin du projet, vous devez être capable de :

```text id="t2n6mq"
👤 Comptes
   ↓
🔎 Audit
   ↓
🔐 Authentification
   ↓
🛡️ Privilèges
   ↓
🚨 Détection des risques
   ↓
🔧 Remédiation
```

> 🔐 **L'identité est le nouveau périmètre. Protéger les comptes, c'est protéger le système.**
