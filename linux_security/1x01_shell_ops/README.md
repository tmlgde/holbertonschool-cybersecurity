# 🔧 Shell Operations — Pipes, Filtres & Automatisation

> **« Si tu dois le faire plus de deux fois, script-le. Si tu dois le faire une fois mais sur 1000 fichiers, pipe-le. »**
>
> — *Unix Philosophy*

Projet pratique consacré à la **maîtrise du shell Linux**, avec un focus sur les pipes, redirections, filtres, traitement de données et automatisation.

---

## 📑 Sommaire

* 🧭 [Introduction](#-introduction)
* ❓ [Pourquoi c'est important](#-pourquoi-cest-important)
* 📂 [Contexte — The Forensic Needle](#-contexte--the-forensic-needle)
* 🎯 [Objectifs](#-objectifs)
* 🛠️ [Outils](#️-outils)
* 📋 [Exigences](#-exigences)
* 🔄 [Workflow](#-workflow)

---

## 🧭 Introduction

Dans le projet précédent, l'objectif était d'apprendre à naviguer et auditer un système Linux manuellement.

Mais en cybersécurité, les données sont rarement petites.

Un analyste peut devoir traiter :

* 📊 Des millions de lignes de logs
* 🖥️ Des centaines de machines
* 📁 Des milliers de fichiers
* 🚨 Des centaines d'indicateurs de compromission

Faire tout cela manuellement n'est ni efficace ni réaliste.

Ce projet permet donc de passer de :

> **Opérateur → Analyste**

L'objectif est d'utiliser de petits outils Unix, chacun spécialisé dans une tâche, puis de les **enchaîner avec des pipes** pour construire des opérations puissantes.

```text id="6j2j7m"
Commande simple
      ↓
    Pipe
      ↓
Filtrage
      ↓
Transformation
      ↓
Extraction
      ↓
Résultat exploitable
```

---

## ❓ Pourquoi c'est important ?

### 🖥️ SOC

Sur un serveur compromis, il n'y a pas forcément d'interface graphique.

Il peut simplement y avoir :

```text id="p0x8rj"
/var/log/auth.log
/var/log/syslog
/var/log/apache2/access.log
```

Et parfois plusieurs gigaoctets de données à analyser.

### 🎯 Pentest

Un scan peut produire des milliers de lignes. Il faut pouvoir rapidement :

* Filtrer
* Trier
* Extraire
* Comparer
* Identifier les informations importantes

### 🚨 Incident Response

Lors d'une compromission, **la vitesse d'analyse compte**.

Savoir construire rapidement un pipeline shell peut faire la différence entre identifier une activité malveillante et perdre du temps à parcourir manuellement des fichiers.

---

## 📂 Contexte — *The Forensic Needle*

**De :** Elena Vasquez, Lead Incident Responder — ACME Corp
**À :** Security Engineer
**Sujet :** 🚨 Analyse post-brèche — aucun SIEM disponible
**Priorité :** Critique

Une compromission vient d'être contenue.

Mais le SIEM a été désactivé pendant l'incident.

Il ne reste que les données brutes :

| Ressource       |          Taille | Contenu                       |
| --------------- | --------------: | ----------------------------- |
| 📄 `access.log` |          2.1 Go | ~18 millions de lignes Apache |
| 🔐 `auth.log`   |          340 Mo | Événements d'authentification |
| 📁 `configs/`   | 12 000 fichiers | Sauvegardes de configuration  |

### 🎯 Votre mission

Extraire les indicateurs d'attaque et répondre aux questions de l'équipe juridique **uniquement avec des outils shell**.

> ❌ Pas d'Excel
> ❌ Pas d'interface graphique
> ✅ Pipes, filtres et scripts

---

## 🎯 Objectifs

### 🧱 Concepts fondamentaux

Comprendre :

* `stdin` — descripteur `0`
* `stdout` — descripteur `1`
* `stderr` — descripteur `2`
* Les redirections
* Les descripteurs de fichiers
* Le fonctionnement des pipelines
* La substitution de processus `<()` et `>()`

### ⚙️ Outils

Maîtriser notamment :

| Outil   | Utilisation                               |
| ------- | ----------------------------------------- |
| `grep`  | Recherche et filtrage                     |
| `sed`   | Transformation de flux                    |
| `awk`   | Extraction et traitement par champs       |
| `xargs` | Exécution de commandes à partir d'un flux |
| `sort`  | Tri                                       |
| `uniq`  | Détection de valeurs uniques/répétées     |
| `cut`   | Extraction de colonnes                    |
| `tr`    | Transformation de caractères              |
| `tee`   | Duplication d'un flux                     |

### 🛡️ Applications cybersécurité

Le projet permet de pratiquer :

* 🔎 Analyse de logs
* 🎯 Extraction d'IoC
* 🌐 Identification d'adresses IP
* 📊 Analyse de codes HTTP
* 🚨 Détection d'anomalies
* 📁 Opérations sur des milliers de fichiers
* ⚡ Automatisation d'analyses répétitives

---

## 🛠️ Outils et ressources

### 📖 Documentation

* **The Art of Command Line**
* **GNU Grep Manual**
* **GNU Sed Manual**
* **GAWK User's Guide**
* Documentation Bash sur les redirections

### 🧪 Outils pratiques

* **Regex101** — tester des expressions régulières
* **ExplainShell** — comprendre une commande shell
* **ShellCheck** — analyser les scripts Bash

### 📄 Pages de manuel

```bash id="yixm8a"
man grep
man sed
man awk
man xargs
man sort
man uniq
man cut
man tee
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

Un fichier `README.md` doit être présent à la racine du projet.

### 📜 Bash

Tous les scripts doivent :

* Être exécutables avec `chmod +x`
* Commencer exactement par :

```bash id="w2w49k"
#!/bin/bash
```

* Contenir **exactement 2 lignes**
* Se terminer par une nouvelle ligne
* Produire une sortie propre
* Utiliser les pipes et opérateurs logiques lorsque nécessaire

Vérification :

```bash id="g4j8mz"
wc -l fichier
```

Résultat attendu :

```text id="f9g5u8"
2
```

---

## 🔄 Workflow

Les scripts sont développés localement puis exécutés sur la machine cible.

```text id="k4q9fc"
💻 Développement local
        ↓
🧪 Tests
        ↓
📤 SCP
        ↓
🖥️ Machine distante
        ↓
🔐 SSH
        ↓
📊 Analyse
```

Exécution distante :

```bash id="7u0l4c"
ssh <user>@<host>
```

---

## 🧠 Philosophie

Le shell Unix repose sur une idée simple :

> **De petits outils, chacun excellent dans une tâche, peuvent devenir extrêmement puissants lorsqu'ils sont combinés.**

```text id="5i7b3q"
grep → filtre
  ↓
awk → extrait
  ↓
sort → trie
  ↓
uniq → compte
  ↓
tee → sauvegarde
```

> 🔧 **Small tools, chained together, do anything.**
