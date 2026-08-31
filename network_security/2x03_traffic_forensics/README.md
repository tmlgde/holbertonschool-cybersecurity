# 🔎 Network Forensics — The Breach

> *« The network never lies. It just contains too much truth. »*

## 📌 Introduction

Bienvenue dans un projet de **Digital Forensics** appliqué au trafic réseau.

Après avoir appris à générer du trafic et à capturer des paquets, l'objectif est maintenant d'adopter le rôle d'un **investigateur en réponse à incident**.

Une compromission a eu lieu chez **ACME Corp**. Les preuves sont contenues dans un fichier PCAP massif : `incident.pcap`.

Notre mission consiste à analyser automatiquement cette capture afin de **reconstituer l'attaque de bout en bout** et de répondre à quatre questions essentielles :

* 👤 **Qui** nous a attaqués ?
* 🚪 **Comment** l'attaquant est-il entré ?
* 💾 **Qu'a-t-il volé ?**
* 🕐 **Quand** chaque étape de l'attaque a-t-elle eu lieu ?

L'objectif n'est pas de produire une montagne de paquets, mais de transformer les données réseau en **preuves exploitables**.

---

## 🎯 Objectifs du projet

Ce projet permet de mettre en pratique les techniques utilisées en **Network Forensics**, **Incident Response** et **SOC**.

À travers différents scripts Bash et `tshark`, nous allons apprendre à :

* identifier une activité de reconnaissance ;
* détecter des scans de ports ;
* analyser les requêtes HTTP suspectes ;
* repérer des tentatives d'exploitation ;
* identifier une prise de contrôle du système ;
* détecter des reverse shells ;
* extraire des fichiers transférés sur le réseau ;
* identifier des données potentiellement exfiltrées ;
* construire une timeline de l'incident ;
* corréler les différentes étapes d'une attaque.

---

# ☠️ Le scénario : « The Breach »

**FROM:** Chief Information Security Officer — ACME Corp
**TO:** Incident Response Team
**SUBJECT:** CONFIRMED BREACH — Forensic Analysis Required
**PRIORITY:** 🔴 Critical

À **14:32 UTC**, l'IDS de l'entreprise détecte un trafic sortant inhabituel provenant du serveur :

```text
10.10.10.50
```

Lorsque l'équipe de sécurité intervient, l'attaquant s'est déjà déconnecté.

Une capture complète du trafic réseau est disponible :

```text
incident.pcap
```

### Premières constatations

L'analyse préliminaire indique :

1. 🌐 une adresse IP externe a effectué une reconnaissance ;
2. 🕸️ une application web a été compromise ;
3. 💻 l'attaquant a obtenu un accès interactif ;
4. 📤 des fichiers sensibles ont été exfiltrés.

### Mission

Développer une boîte à outils automatisée permettant d'extraire les preuves correspondant à chaque phase de l'attaque.

Les scripts doivent permettre de déterminer :

| Question     | Élément recherché          |
| ------------ | -------------------------- |
| 👤 **Who?**  | Adresse IP de l'attaquant  |
| 🚪 **How?**  | Vecteur d'attaque          |
| 💾 **What?** | Données/fichiers exfiltrés |
| 🕐 **When?** | Chronologie de l'incident  |

---

# ⛓️ Attack Kill Chain

Une attaque sophistiquée laisse généralement des traces à différentes étapes.

Notre analyse suit les principales phases de la **Kill Chain**.

## 1. 🔭 Reconnaissance

L'attaquant commence par découvrir la cible.

Dans le trafic réseau, on peut notamment observer :

* des scans de ports ;
* de nombreux paquets TCP `SYN` ;
* des connexions vers des ports séquentiels ;
* de l'énumération de services ;
* des requêtes HTTP répétées ;
* du directory brute-forcing ;
* un grand nombre de réponses `404 Not Found`.

### Indicateurs recherchés

```text
TCP SYN
Port scanning
Service enumeration
HTTP 404 floods
Directory brute-force
```

---

## 2. 🚪 Initial Access

Une fois la surface d'attaque identifiée, l'attaquant tente d'exploiter une vulnérabilité.

Les traces possibles comprennent :

* SQL injection ;
* command injection ;
* paramètres HTTP malveillants ;
* `/bin/sh` ;
* `cmd.exe` ;
* tentatives répétées d'authentification ;
* credential stuffing ;
* connexion réussie après plusieurs échecs.

### Exemples de chaînes suspectes

```text
/bin/sh
cmd.exe
UNION SELECT
../
```

L'analyse devra notamment permettre d'identifier **le vecteur initial de compromission**.

---

## 3. 💻 Execution

Après exploitation, l'attaquant cherche à exécuter du code sur la machine compromise.

On peut alors rechercher :

* des connexions TCP sortantes inhabituelles ;
* des reverse shells ;
* des téléchargements de payloads ;
* des fichiers `.exe`, `.sh`, `.py` ;
* des commandes exécutées à distance ;
* des sorties de commandes visibles dans des flux TCP.

Une attention particulière sera portée aux connexions sortantes depuis le serveur compromis.

---

## 4. 📤 Exfiltration

Dernière étape : le vol des données.

Les indicateurs potentiels sont notamment :

* des transferts sortants volumineux ;
* des requêtes DNS anormalement longues ;
* du DNS tunneling ;
* des paquets ICMP inhabituels ;
* des transferts HTTP ;
* des requêtes `POST` contenant des noms de fichiers sensibles.

L'objectif est de déterminer précisément **quelles données ont quitté l'environnement**.

---

# 🛠️ Pourquoi TShark ?

[Wireshark](https://www.wireshark.org/) est extrêmement puissant pour l'analyse interactive de paquets.

Cependant, lorsqu'il faut analyser un fichier PCAP de plusieurs gigaoctets, effectuer des recherches répétitives et produire des résultats reproductibles, une interface graphique atteint rapidement ses limites.

**TShark** est la version en ligne de commande de Wireshark.

Il utilise les mêmes mécanismes de décodage et permet notamment de :

* sélectionner précisément des paquets ;
* extraire des champs spécifiques ;
* appliquer des display filters ;
* produire des statistiques ;
* analyser des millions de paquets ;
* récupérer des objets transférés ;
* automatiser les investigations ;
* combiner les résultats avec des outils Unix.

Exemple :

```bash
tshark -r incident.pcap
```

Puis filtrer un protocole :

```bash
tshark -r incident.pcap -Y "http"
```

Ou extraire certains champs :

```bash
tshark -r incident.pcap -T fields -e ip.src -e ip.dst
```

L'approche est particulièrement adaptée à une utilisation dans un **SOC** ou lors d'une procédure d'**Incident Response**.

---

# 🧰 Outils utilisés

## Outils principaux

| Outil      | Utilisation                         |
| ---------- | ----------------------------------- |
| `tshark`   | Analyse et extraction des paquets   |
| `capinfos` | Informations générales sur un PCAP  |
| `editcap`  | Manipulation de fichiers de capture |
| `mergecap` | Fusion de captures                  |
| `grep`     | Recherche de motifs                 |
| `awk`      | Traitement de données textuelles    |
| `sort`     | Tri des résultats                   |
| `uniq`     | Déduplication et comptage           |
| `strings`  | Extraction de chaînes lisibles      |
| `md5sum`   | Calcul d'empreintes MD5             |

---

# 📂 Structure du projet

Une organisation possible du projet :

```text
network-forensics/
│
├── README.md
├── incident.pcap
│
├── 0-pcap_info.sh
├── 1-source_ips.sh
├── 2-port_scan.sh
├── 3-http_analysis.sh
├── 4-attack_payloads.sh
├── 5-reverse_shell.sh
├── 6-file_extraction.sh
├── 7-exfiltration.sh
└── 8-timeline.sh
```

> Les noms des scripts peuvent naturellement être adaptés aux exercices réellement demandés par le projet.

---

# 📊 Méthodologie d'investigation

L'analyse doit être effectuée progressivement afin de pouvoir **corréler les événements**.

### Étape 1 — Comprendre la capture

Commencer par identifier :

* la durée de la capture ;
* le nombre de paquets ;
* les protocoles utilisés ;
* les adresses IP présentes ;
* les principaux hôtes.

```bash
capinfos incident.pcap
```

---

### Étape 2 — Identifier l'activité suspecte

Rechercher les comportements inhabituels :

```text
→ nombreux SYN
→ nombreux ports différents
→ nombreuses erreurs HTTP
→ requêtes anormales
→ connexions sortantes inhabituelles
→ transferts volumineux
```

---

### Étape 3 — Identifier l'attaquant

Corréler les premières activités de reconnaissance avec les événements suivants.

L'objectif est d'obtenir une chaîne logique :

```text
IP externe
    │
    ▼
Reconnaissance
    │
    ▼
Exploitation
    │
    ▼
Compromission
    │
    ▼
Accès interactif
    │
    ▼
Exfiltration
```

---

### Étape 4 — Analyser les flux

Une fois une communication suspecte identifiée, il faut remonter au **TCP stream** correspondant.

Cela permet notamment de rechercher :

* commandes ;
* payloads ;
* credentials ;
* fichiers ;
* réponses du serveur ;
* informations sensibles.

---

### Étape 5 — Construire la timeline

Chaque événement doit être replacé dans le temps.

Exemple :

```text
14:20:03  Reconnaissance
14:21:17  Port scan
14:23:41  Exploitation HTTP
14:23:45  Command execution
14:24:02  Reverse shell
14:27:18  File access
14:28:51  Data transfer
14:32:00  Attacker disconnects
```

Cette chronologie permet de relier les différents indicateurs et de reconstituer le scénario complet.

---

# 🔬 Forensic Evidence

Pendant l'investigation, plusieurs catégories d'éléments doivent être recherchées.

### 🌐 Réseau

* adresses IP ;
* ports ;
* protocoles ;
* connexions entrantes/sortantes ;
* volumes de données.

### 🕸️ HTTP

* méthodes `GET` / `POST` ;
* URLs ;
* paramètres ;
* User-Agent ;
* codes HTTP ;
* payloads d'exploitation.

### 🔐 Authentification

* usernames ;
* mots de passe transmis en clair ;
* tentatives de connexion ;
* succès après plusieurs échecs.

### 💻 Exécution

* commandes shell ;
* téléchargements ;
* reverse shell ;
* connexions vers des ports inhabituels.

### 📁 Fichiers

* noms de fichiers ;
* extensions ;
* taille ;
* contenu ;
* empreintes MD5.

### 📤 Exfiltration

* volume sortant ;
* destination ;
* protocole ;
* fichiers transférés ;
* DNS/ICMP tunneling éventuel.

---

# 🎓 Learning Objectives

À la fin de ce projet, vous devez être capable d'expliquer sans documentation externe :

## Traffic Identification

* différencier un scan d'une activité légitime ;
* identifier un payload d'exploitation HTTP ;
* reconnaître une connexion de reverse shell ;
* détecter des comportements d'exfiltration.

## Forensic Extraction

* extraire des fichiers depuis des flux réseau ;
* récupérer des credentials transmis en clair ;
* identifier des User-Agent suspects ;
* décoder des payloads URL-encodés.

## TShark

* utiliser efficacement les display filters ;
* extraire des champs spécifiques ;
* produire des statistiques ;
* automatiser une analyse PCAP ;
* récupérer des objets réseau.

## Attack Correlation

* construire une timeline ;
* relier reconnaissance et exploitation ;
* corréler exploitation et exécution ;
* identifier l'infrastructure utilisée par l'attaquant ;
* reconstituer une intrusion complète.

---

# ⚙️ Contraintes techniques

## Système

Les scripts sont conçus pour être exécutés sur :

* Kali Linux ;
* ParrotOS ;
* Ubuntu 22.04+.

## Éditeurs autorisés

```text
vi
vim
emacs
nano
```

## Contraintes Bash

Chaque script doit :

* être exécutable ;
* commencer exactement par :

```bash
#!/bin/bash
```

* recevoir le chemin du PCAP via `$1`, sauf indication contraire ;
* contenir sa logique sur **une seule ligne** ;
* se terminer par un caractère newline.

Pour rendre un script exécutable :

```bash
chmod +x script.sh
```

Puis :

```bash
./script.sh incident.pcap
```

---

# 📚 Ressources

### Documentation

* [TShark Documentation](https://www.wireshark.org/docs/man-pages/tshark.html)
* [Wireshark Display Filters](https://wiki.wireshark.org/DisplayFilters)
* [Wireshark Documentation](https://www.wireshark.org/docs/)
* [SANS — Network Forensics](https://www.sans.org/)

### Man pages

```bash
man tshark
man capinfos
man editcap
man mergecap
```

---

# 📦 Données fournies

Le projet utilise une capture réseau contenant les traces de l'incident :

```text
incident.pcap
```

Cette capture constitue la principale source de preuves de l'investigation.

> ⚠️ Le fichier PCAP peut être volumineux. Il est donc recommandé de privilégier les commandes et scripts capables de filtrer les informations pertinentes plutôt que de tenter d'ouvrir ou d'analyser l'intégralité de la capture de manière interactive.

---

# 🧩 Résultat attendu

À la fin de l'investigation, nous devons être capables de raconter l'attaque sous la forme d'un scénario cohérent :

```text
┌─────────────────────┐
│   Reconnaissance    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Initial Access    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Execution      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│    Exfiltration     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Forensic Conclusion │
└─────────────────────┘
```

La conclusion finale doit idéalement permettre d'établir :

> **Qui** a attaqué le système, **comment** l'accès initial a été obtenu, **quelles données** ont été exfiltrées et **à quel moment** chaque phase s'est déroulée.

---

# 🏁 Conclusion

Ce projet constitue une introduction pratique à la **forensique réseau**.

Au lieu d'observer passivement des paquets, l'objectif est de transformer une capture brute en **intelligence exploitable**.

La compétence essentielle développée ici est la capacité à passer de :

```text
Millions of packets
        ↓
Filtering
        ↓
Evidence extraction
        ↓
Correlation
        ↓
Timeline
        ↓
Attack reconstruction
```

En pratique, un bon analyste ne cherche pas simplement des paquets suspects.

Il cherche à **raconter l'histoire que les paquets racontent**.

> *The network never lies. It just contains too much truth.*

