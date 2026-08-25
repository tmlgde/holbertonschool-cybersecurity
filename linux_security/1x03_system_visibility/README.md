# 🕵️ Process & Network Forensics

> **« You cannot kill what you cannot see. »**

Projet pratique consacré à la **forensic système et réseau sous Linux** : processus, sockets, signaux, logs et corrélation d'événements.

---

## 📑 Sommaire

* 🧭 [Introduction](#-introduction)
* ❓ [Pourquoi c'est important](#-pourquoi-cest-important)
* 📂 [Contexte — The Crypto-Jacking](#-contexte--the-crypto-jacking)
* 🎯 [Objectifs](#-objectifs)
* 🛠️ [Outils](#️-outils)
* 📋 [Exigences](#-exigences)
* 🔄 [Workflow](#-workflow)
* 🔑 [Lab](#-lab)

---

## 🧭 Introduction

Un système Linux fait fonctionner en permanence des centaines de processus.

Parmi eux peuvent se cacher :

* 🦠 Des malwares
* ⛏️ Des crypto-mineurs
* 🚪 Des backdoors
* 🌐 Des processus ouvrant des connexions réseau
* ⚠️ Des processus qui redémarrent automatiquement

Pour analyser un système compromis, il faut aller au-delà des fichiers et observer **l'état dynamique de la machine**.

| Couche           | Question                         | Outils                |
| ---------------- | -------------------------------- | --------------------- |
| ⚙️ **Processus** | Quel code s'exécute ?            | `ps`, `top`, `/proc`  |
| 🌐 **Réseau**    | Quel processus utilise ce port ? | `ss`, `lsof`          |
| 📜 **Logs**      | Que s'est-il passé ?             | `journalctl`, `dmesg` |

---

## ❓ Pourquoi c'est important ?

Lors d'un incident, une menace peut être active **au moment même de l'investigation**.

Elle peut :

* Consommer du CPU
* Maintenir des connexions réseau
* Écouter sur un port
* Écrire sur le disque
* Masquer son véritable nom
* Redémarrer après son arrêt

L'analyste doit donc être capable de passer rapidement de :

```text id="h3v8g2"
Processus
    ↓
PID
    ↓
Utilisateur
    ↓
Port réseau
    ↓
Logs
    ↓
Origine de l'activité
```

---

## 📂 Contexte — *The Crypto-Jacking*

**De :** Marcus Chen, Directeur IT — ACME Corp
**À :** Security Engineer
**Sujet :** 🚨 Dégradation des performances — compromission suspectée
**Priorité :** Haute

Le serveur web principal présente :

* 🌡️ Une utilisation CPU anormalement élevée
* 🌀 Des ventilateurs constamment à pleine vitesse
* 🖥️ Des processus aux noms suspects ou génériques
* 🌐 Un port réseau inhabituel en écoute

Un crypto-mineur est suspecté.

### 🎯 Votre mission

Vous devez :

1. 🔍 Identifier les processus suspects.
2. 📊 Analyser leur consommation de ressources.
3. 🗺️ Relier les processus à leurs ports réseau.
4. 💀 Terminer les processus malveillants avec les signaux appropriés.
5. 📜 Examiner les logs pour comprendre l'origine de l'activité.

> ⚠️ **Règle forensique : documenter les actions et éviter de détruire prématurément les preuves.**

---

## 🎯 Objectifs

### ⚙️ Processus

Comprendre :

* `PID` et `PPID`
* La hiérarchie des processus
* Les états `Running`, `Sleeping` et `Zombie`
* La propriété des processus
* Le rôle de `/proc`

### 💀 Signaux Linux

Comprendre la différence entre :

```text id="b4x5eg"
SIGTERM
   ↓
Demande d'arrêt propre

SIGKILL
   ↓
Arrêt forcé
```

Et également :

* `SIGSTOP`
* `SIGCONT`
* Le comportement des processus face aux signaux

### 🌐 Forensic réseau

Identifier :

* `LISTEN`
* `ESTABLISHED`
* `TIME_WAIT`
* Les ports ouverts
* Le processus associé à un socket

### 📜 Analyse des logs

Utiliser :

* `journalctl`
* `dmesg`

Pour :

* Filtrer les événements
* Rechercher des informations temporelles
* Examiner les événements système
* Corréler les activités d'un processus avec les logs

---

## 🛠️ Outils

### Outils autorisés

```text id="w7p9c1"
ps
grep
awk
ss
lsof
kill
journalctl
dmesg
```

### 🚫 Outils interdits

```text id="x1r4ya"
htop
killall
```

L'objectif est de maîtriser les commandes Linux natives et d'effectuer des actions **précises**, plutôt que d'utiliser des outils automatisant tout le processus.

Pages de manuel :

```bash id="z6t2qm"
man ps
man top
man kill
man ss
man lsof
man journalctl
man dmesg
man proc
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

```bash id="zj7x1c"
#!/bin/bash
```

* Contenir **exactement 2 lignes**
* Se terminer par une nouvelle ligne
* Produire une sortie propre
* Utiliser les pipes et opérateurs logiques lorsque nécessaire

Vérification :

```bash id="x4a7hs"
wc -l fichier
```

Résultat attendu :

```text id="d0w8kn"
2
```

---

## 🔄 Workflow

```text id="f1k6s8"
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
🔍 Investigation
        ↓
📊 Corrélation
        ↓
💀 Remédiation
```

Les scripts doivent être développés localement, transférés avec `scp`, puis exécutés à distance avec :

```bash id="x2f9wq"
ssh <user>@<host>
```

---

## 🔑 Accès au lab

| Paramètre               | Valeur          |
| ----------------------- | --------------- |
| 🏷️ **Lab**             | `M1-Proc-Net`   |
| 🎯 **Hôte cible**       | `[PROVIDED_IP]` |
| 👤 **Utilisateur**      | `student`       |
| 🔐 **Authentification** | Clé SSH         |

Connexion :

```bash id="r5m8qz"
ssh student@[PROVIDED_IP]
```

La machine cible contient plusieurs processus suspects simulés.

Certains peuvent :

* 🔄 Redémarrer automatiquement
* 🫥 Être difficiles à identifier
* 🌐 Maintenir des connexions réseau

> 🕵️ **Traite cette machine comme un véritable incident de sécurité : observe, corrèle, documente, puis agis.**

---

## 🎓 Résultat attendu

```text id="n8q2wf"
⚙️ Processus
      ↓
🔎 Identification
      ↓
🌐 Ports & sockets
      ↓
📜 Logs
      ↓
🧩 Corrélation
      ↓
🚨 Menace
      ↓
💀 Remédiation
```

> 🕵️ **You cannot kill what you cannot see.**
