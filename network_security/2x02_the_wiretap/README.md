# 🕵️ Nexus Financial — Analyse de Paquets & Investigation Réseau

> *« Le réseau ne ment jamais. Les gens, si. Les journaux peuvent être supprimés. Les fichiers peuvent être chiffrés. Mais les paquets ? Ils étaient là. Ils ont existé. Et si vous savez où regarder, ils vous raconteront tout. »*
>
> — **Richard Bejtlich, *The Practice of Network Security Monitoring***

<p align="center">
  <strong>🔍 Analyser. Investiguer. Reconstruire. Prouver.</strong>
</p>

<p align="center">
  <em>Une enquête pratique en analyse réseau, investigation forensique et threat hunting.</em>
</p>

---

## 📖 Introduction

Tous les outils de sécurité du marché sont capables de générer des alertes du type :

> **« Anomalie détectée »**

La plupart sont du bruit.

Certaines sont des faux positifs.

Et quelques-unes correspondent à des intrusions **réellement en cours**.

La différence entre un analyste junior et un threat hunter expérimenté ne se résume pas au nombre de tableaux de bord qu'ils surveillent.

Elle réside dans leur capacité à plonger dans les **paquets réseau bruts**, comprendre ce qui s'est réellement passé au niveau du réseau et produire des preuves.

Ce projet a pour objectif d'aller au-delà de l'analyse basée uniquement sur des interfaces et des alertes.

Vous apprendrez l'art de l'**analyse manuelle de paquets réseau** :

* 🔎 Naviguer efficacement dans de grandes captures réseau
* 🌐 Comprendre les protocoles à leur niveau fondamental
* 🧬 Reconnaître les signatures d'attaques
* 🕵️ Reconstruire l'activité d'un attaquant
* 📊 Construire une chronologie basée sur des preuves
* 🚨 Identifier et extraire des **Indicators of Compromise (IoC)**

L'investigation suit une méthodologie proche de celles utilisées dans les environnements professionnels de :

* 🛡️ SOC
* 🔥 Incident Response
* 🕵️ Threat Hunting
* 🔬 Network Forensics

> ## 🎯 Votre objectif
>
> Ne devinez pas ce qui s'est passé.
>
> **Prouvez-le.**

---

# 🎯 Pourquoi est-ce important ?

Lors d'un entretien en cybersécurité, une question revient souvent :

> **« Expliquez-moi comment vous enquêteriez sur une suspicion de compromission. »**

Si votre réponse se limite à :

```text
« Je vérifierais les alertes du SIEM. »
```

Alors il manque une partie essentielle de votre investigation.

Un professionnel de la cybersécurité doit être capable d'aller au-delà de l'alerte.

Il doit pouvoir analyser les **preuves sous-jacentes**.

Dans ce projet, votre démarche sera la suivante :

```text
PCAP
  │
  ▼
Paquets
  │
  ▼
Conversations réseau
  │
  ▼
Chronologie
  │
  ▼
Preuves
```

Une capture réseau peut révéler :

* 🌍 L'origine de l'attaquant
* 🎯 Les systèmes ciblés
* 🔎 Les activités de reconnaissance
* 💥 Les tentatives d'exploitation
* 🔑 Des identifiants transmis en clair
* 💻 Des commandes exécutées à distance
* 📁 Des fichiers transférés
* 📤 Une éventuelle exfiltration de données
* 📡 Des communications Command & Control

---

# 🧠 Compétences développées

| Domaine                  | Pourquoi l'analyse réseau est importante         |
| ------------------------ | ------------------------------------------------ |
| 🛡️ **SOC**              | Investiguer les alertes suspectes                |
| 🔥 **Incident Response** | Reconstruire l'activité d'un attaquant           |
| 🕵️ **Threat Hunting**   | Identifier des comportements anormaux            |
| 🔬 **Digital Forensics** | Construire une chronologie basée sur des preuves |
| 💻 **Pentesting**        | Comprendre les traces laissées par un attaquant  |
| 🌐 **Network Security**  | Détecter les abus et anomalies réseau            |

---

# 🏦 Le scénario

Bienvenue chez **Nexus Financial**.

Vous venez de rejoindre le **Security Operations Center (SOC)** d'une banque régionale comptant plus de **2 000 employés**.

Votre mentor, un analyste senior possédant quinze années d'expérience en réponse à incident, a conçu votre programme d'entraînement.

## 🚨 La situation

La veille, le système de détection d'intrusion a signalé une activité suspecte dans la **DMZ**.

Cependant, l'alerte a été classée :

```text
Low Confidence
```

L'équipe de nuit a finalement fermé l'incident.

Ce matin, un administrateur système découvre plusieurs fichiers inhabituels dans :

```text
/tmp
```

sur l'un des serveurs legacy.

Le **CISO** décide alors d'escalader la situation.

L'incident est désormais considéré comme une :

> 🚨 **Potentielle compromission de sécurité**

---

# 📦 La preuve

L'équipe réseau vous fournit une capture provenant d'un TAP réseau dans la DMZ :

```text
nexus_capture.pcap
```

La capture contient :

* ⏱️ Deux heures de trafic
* 📦 Plus de 100 000 paquets
* 🌐 Du trafic métier légitime
* 👨‍💻 Des sessions administratives
* 🔐 Des connexions chiffrées
* 🚨 L'activité malveillante que vous devez identifier

Votre mentor vous remet le fichier et vous dit :

> *« Cette capture contient du trafic légitime, des sessions administratives, des connexions chiffrées et l'attaque que nous investiguons. Votre travail consiste à trouver l'aiguille dans la botte de foin. Je veux des preuves, pas des suppositions. Lorsque vous aurez terminé, vous devrez être capable de me dire exactement qui nous a attaqués, comment ils sont entrés et ce qu'ils ont récupéré. »*

---

# 🎯 Votre mission

Vous devez analyser :

```text
nexus_capture.pcap
```

Votre objectif final est de répondre aux questions suivantes :

### 👤 Qui ?

```text
Quelle est l'origine de l'activité malveillante ?
```

### 🚪 Comment ?

```text
Quel vecteur a été utilisé pour compromettre le système ?
```

### 🕒 Quand ?

```text
À quel moment l'activité malveillante a-t-elle commencé ?
```

### 💻 Quoi ?

```text
Quelles actions ont été réalisées après la compromission ?
```

### 📤 Jusqu'où ?

```text
Des données ont-elles été consultées ou exfiltrées ?
```

Chaque réponse doit être accompagnée de :

* 🔍 Un filtre Wireshark valide
* 📦 Une preuve visible dans la capture
* 🕒 Un élément permettant de reconstruire la chronologie

---

# 🧭 Les 5 phases de l'investigation

## 1️⃣ Premier contact

### Objectif : comprendre la capture avant de commencer l'enquête.

Vous apprendrez à :

* Examiner rapidement une capture réseau
* Identifier les principaux protocoles
* Observer les conversations réseau
* Repérer les hôtes les plus actifs
* Utiliser les statistiques de Wireshark

---

## 2️⃣ Fondamentaux des protocoles

Vous analyserez les protocoles essentiels :

```text
TCP
UDP
DNS
HTTP
ARP
```

Vous devrez comprendre ce qui se passe réellement à l'intérieur des paquets.

---

## 3️⃣ Les protocoles dangereux

Tous les protocoles ne protègent pas les données.

Certains peuvent exposer :

```text
Identifiants
Commandes
Fichiers
Informations sensibles
```

Vous apprendrez pourquoi les protocoles en clair représentent un risque majeur dans un environnement sécurisé.

---

## 4️⃣ Le laboratoire en direct

Vous générerez et observerez votre propre trafic réseau.

Vous étudierez notamment :

* Les connexions TCP
* Les requêtes DNS
* Les échanges HTTP
* Les scans réseau
* Les différents comportements visibles dans Wireshark

L'objectif est simple :

> **Voir ce qu'une attaque ressemble réellement sur le réseau.**

---

## 5️⃣ La chasse

C'est la phase finale.

Vous devrez retrouver l'attaquant au milieu de plus de **100 000 paquets**.

Votre enquête devra permettre de reconstruire :

```text
Reconnaissance
      │
      ▼
Scan
      │
      ▼
Accès initial
      │
      ▼
Compromission
      │
      ▼
Actions post-exploitation
      │
      ▼
Transfert ou exfiltration
```

---

# 🎓 Objectifs pédagogiques

À la fin de ce projet, vous devrez être capable d'expliquer, **sans utiliser Google**, les concepts suivants.

## 🧠 Maîtrise conceptuelle

* Comment le modèle **OSI** correspond aux structures visibles dans Wireshark
* La différence entre les **Capture Filters** et les **Display Filters**
* Comment TCP établit une connexion
* Comment TCP maintient et termine une session
* Pourquoi UDP fonctionne différemment de TCP
* Ce que cela implique pour les scans réseau
* Comment fonctionne la résolution DNS
* Pourquoi certains protocoles exposent les identifiants
* Comment le chiffrement protège les communications
* Comment fonctionne ARP et pourquoi il est important

---

# 💻 Maîtrise technique

Vous devrez être capable de :

* Utiliser les vues **Statistics** de Wireshark
* Naviguer efficacement dans l'interface à trois panneaux
* Écrire des **Display Filters** complexes
* Combiner plusieurs conditions dans un filtre
* Reconstruire des conversations avec :

```text
Follow TCP Stream
```

* Extraire des fichiers depuis du trafic non chiffré
* Identifier des identifiants transmis en clair
* Utiliser `tcpdump`
* Écrire des filtres `BPF`
* Identifier différents types de scans

Notamment :

```text
SYN Scan
Connect Scan
UDP Scan
```

---

# 🧑‍💼 Maîtrise professionnelle

À la fin du projet, vous devrez être capable de :

* Effectuer un triage initial d'une grande capture
* Différencier le trafic légitime du trafic malveillant
* Construire une chronologie d'attaque
* Identifier les activités suspectes
* Extraire des **Indicators of Compromise**
* Produire une investigation reproductible
* Justifier vos conclusions avec des preuves

---

# 🛠️ Outils utilisés

## 🔍 Wireshark

Utilisé pour :

* L'analyse de paquets
* Les Display Filters
* L'analyse des conversations
* Les statistiques
* La reconstruction de flux TCP

```bash
wireshark nexus_capture.pcap
```

---

## 🦈 tcpdump

Utilisé pour capturer et filtrer le trafic depuis la ligne de commande.

Exemple :

```bash
tcpdump -i eth0
```

Avec un filtre :

```bash
tcpdump -i eth0 tcp port 80
```

---

# 🧪 Filtres : Capture vs Display

## Capture Filter — BPF

Les filtres de capture permettent de limiter les paquets enregistrés.

Exemple :

```text
tcp port 80
```

```text
host 192.168.1.10
```

```text
udp port 53
```

---

## Display Filter — Wireshark

Les filtres d'affichage permettent d'analyser les paquets déjà présents dans la capture.

Exemple :

```text
tcp
```

```text
dns
```

```text
http.request
```

```text
ip.addr == 192.168.1.10
```

```text
tcp.flags.syn == 1 && tcp.flags.ack == 0
```

---

# 🧩 Structure de l'investigation

```text
.
├── README.md
├── nexus_capture.pcap
│
├── 0-first_contact/
│
├── 1-protocol_foundations/
│   ├── tcp/
│   ├── udp/
│   ├── dns/
│   ├── http/
│   └── arp/
│
├── 2-dark_protocols/
│
├── 3-live_lab/
│
└── 4-the_hunt/
    ├── reconnaissance/
    ├── exploitation/
    ├── post_exploitation/
    └── timeline/
```

---

# 📚 Ressources

## Wireshark

* Wireshark User's Guide
* Wireshark Display Filter Reference
* Wireshark Statistics

## Analyse des protocoles

* *Practical Packet Analysis*
* Chris Sanders — Packet Analysis
* RFC 793 — TCP
* RFC 768 — UDP
* RFC 1035 — DNS

## Ligne de commande

* `man tcpdump`
* `man pcap-filter`

---

# ⚙️ Prérequis

Votre environnement doit disposer de :

* 🐉 Kali Linux
* 🦜 Parrot OS
* 🐧 Ubuntu

Ainsi que :

```text
Wireshark 3.x+
tcpdump
```

Vérifiez l'installation :

```bash
wireshark --version
```

```bash
tcpdump --version
```

---

# 📜 Contraintes

## 📦 Intégrité de la preuve

Le fichier :

```text
nexus_capture.pcap
```

est considéré comme une preuve.

> ⚠️ **Ne modifiez jamais la capture originale.**

---

## 🧾 Reproductibilité

Chaque conclusion doit être accompagnée de :

```text
Filtre utilisé
      +
Preuve observée
      +
Conclusion
```

Exemple :

```text
Filtre :
tcp.flags.syn == 1 && tcp.flags.ack == 0

Observation :
Un nombre important de paquets SYN provenant d'une même adresse IP.

Conclusion :
Possible activité de reconnaissance ou scan SYN.
```

---

# 🖥️ Bash

Tous les scripts doivent respecter les contraintes suivantes :

* Être exécutables

```bash
chmod +x script.sh
```

* Commencer par :

```bash
#!/bin/bash
```

* Contenir exactement deux lignes
* Se terminer par une nouvelle ligne
* Produire une sortie propre
* Éviter les messages de debug inutiles

---

# 🚩 Flags

Les flags permettent de valider certaines découvertes.

Format standard :

```text
FLAG{...}
```

Chaque découverte doit être justifiée par un filtre Wireshark valide.

---

# 🏁 Objectif final

À la fin de cette investigation, vous devrez être capable de prendre une capture réseau inconnue et de transformer :

```text
100 000+ paquets
```

en une histoire complète :

```text
QUI
 │
 ▼
QUAND
 │
 ▼
COMMENT
 │
 ▼
QUEL SYSTÈME
 │
 ▼
QUELLE ACTION
 │
 ▼
QUEL IMPACT
```

---

# 🔥 La règle du Threat Hunter

> **Une alerte n'est pas une preuve.**

> **Une intuition n'est pas une conclusion.**

> **Un paquet, correctement analysé, peut raconter toute l'histoire.**

---


### 🔍 *Analyze the traffic.*

### 🕵️ *Find the attacker.*

### 📦 *Follow the evidence.*

### 🚨 *Prove the breach.*

<br>

**Nexus Financial — Packet Analysis & Network Forensics**

</p>
