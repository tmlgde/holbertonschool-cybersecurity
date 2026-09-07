# 🛡️ LogiCorp — Network Security Overhaul

> **IronShield Consulting — Module Capstone**

> *“Amateurs hack systems, professionals hack people, but masters build the systems that survive both.”*

## 📌 Présentation

LogiCorp, entreprise internationale spécialisée dans la logistique, a récemment subi une **attaque ransomware** ayant paralysé ses opérations pendant deux jours.

L'analyse initiale indique que l'attaquant a pu effectuer un **mouvement latéral depuis un équipement connecté au Wi-Fi invité jusqu'à une base de données critique**, notamment en raison de l'absence de segmentation réseau.

IronShield Consulting est chargé de réaliser une **refonte complète de la sécurité réseau** du système existant.

### 🎯 Objectifs

En une semaine, notre équipe doit :

* Auditer l'infrastructure existante et identifier les failles.
* Comprendre la topologie et la configuration réelles du réseau.
* Identifier les causes ayant permis l'attaque.
* Concevoir une architecture **Zero Trust** limitant les mouvements latéraux.
* Implémenter les contrôles de sécurité sur la passerelle Linux.
* Valider automatiquement la nouvelle posture de sécurité.
* Documenter les choix techniques et assurer la maintenance future.

---

## 🔎 Méthodologie

Le projet suit une approche proche d'une mission de consulting réelle :

```text
DISCOVERY → ASSESSMENT → DESIGN → IMPLEMENTATION → VALIDATION → HANDOFF
```

### 1. Discovery

Analyse de la documentation fournie, identification des contraintes et formulation d'hypothèses sur l'infrastructure.

### 2. Assessment

Audit de la machine cible afin de vérifier la réalité du système : réseau, services, ports ouverts, règles firewall, VPN, proxy, etc.

### 3. Design

Conception de la nouvelle architecture réseau et définition des zones de sécurité, flux autorisés et règles de filtrage.

### 4. Implementation

Déploiement des mesures de sécurité sur la passerelle Linux à l'aide de scripts **idempotents** et reproductibles.

### 5. Validation

Création de tests automatisés permettant de vérifier que les contrôles sont correctement appliqués et que les flux interdits sont bloqués.

### 6. Handoff

Documentation finale des choix, règles, procédures de maintenance et recommandations destinées à l'équipe IT de LogiCorp.

---

## 👥 Organisation de l'équipe

| Rôle               | Responsabilités                                                   |
| ------------------ | ----------------------------------------------------------------- |
| 🔍 **Auditor**     | Discovery, scans, analyse des logs, gap analysis, rapport d'audit |
| 🏗️ **Architect**  | Architecture réseau, segmentation, firewall, VPN, documentation   |
| ⚙️ **Implementer** | Scripts de hardening, configuration, déploiement et validation    |

Les rôles peuvent être répartis différemment selon la taille de l'équipe, mais chaque membre doit comprendre **l'ensemble de la solution**.

---

## 🧰 Technologies étudiées

Le projet s'appuie notamment sur :

* **Nmap** — découverte réseau et audit des services
* **Wireshark / tshark** — analyse du trafic réseau
* **nftables** — firewalling et filtrage réseau
* **WireGuard** — VPN sécurisé
* **Squid** — proxy et contrôle des flux
* **Linux** — administration et hardening
* **GNS3 / Packet Tracer / Draw.io** — conception de l'architecture

---

## 📂 Structure du projet

```text
.
├── README.md
│
├── GAP_ANALYSIS.md
│   └── Analyse des écarts entre l'état actuel et l'état cible
│
├── AUDIT_REPORT.md
│   └── Résultats de l'audit technique de la passerelle
│
├── DESIGN_PACKAGE/
│   ├── topology.*
│   ├── architecture.*
│   └── ...
│   └── Architecture et segmentation réseau proposées
│
├── HARDENING/
│   ├── harden.sh
│   └── ...
│   └── Scripts de sécurisation et de configuration
│
├── VALIDATION/
│   ├── compliance_check.sh
│   └── ...
│   └── Tests automatisés de conformité
│
└── DEFENSE.md
    └── Justification des choix techniques et compromis
```

---

## 🔐 Architecture cible

L'objectif principal est de passer d'un réseau **plat et implicitement fiable** à une architecture segmentée suivant les principes du **Zero Trust**.

Principe général :

```text
                    ┌──────────────────┐
                    │     INTERNET     │
                    └────────┬─────────┘
                             │
                       ┌─────▼─────┐
                       │  GATEWAY  │
                       │ Firewall  │
                       └─────┬─────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
        ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐
        │   USERS   │  │ GUEST WiFi │  │  SERVERS  │
        │   ZONE    │  │    ZONE    │  │   ZONE    │
        └───────────┘  └───────────┘  └─────┬─────┘
                                            │
                                      ┌─────▼─────┐
                                      │ DATABASE  │
                                      │  CRITICAL │
                                      └───────────┘
```

Le principe est simple :

> **Tout flux est refusé par défaut et explicitement autorisé uniquement lorsqu'il est nécessaire.**

Une compromission d'un poste invité ne doit donc plus permettre d'atteindre directement les ressources critiques.

---

## ✅ Principes de sécurité

Les décisions techniques seront guidées par plusieurs principes :

* **Default Deny** — bloquer par défaut, autoriser explicitement.
* **Least Privilege** — limiter les accès au strict nécessaire.
* **Network Segmentation** — isoler les différentes catégories de systèmes.
* **Zero Trust** — ne jamais considérer un réseau comme fiable par défaut.
* **Defense in Depth** — plusieurs couches de protection indépendantes.
* **Idempotence** — les scripts doivent pouvoir être exécutés plusieurs fois sans casser la configuration.
* **Validation** — toute modification doit être testée et vérifiée.

---

## 🧪 Validation

La réussite du projet ne repose pas uniquement sur l'application des configurations.

Nous devons être capables de **prouver** que la nouvelle architecture fonctionne.

Les tests devront notamment vérifier :

* les ports et services exposés ;
* les règles `nftables` ;
* les flux autorisés ;
* les flux interdits entre zones ;
* la configuration WireGuard ;
* le comportement du proxy ;
* la persistance des configurations ;
* l'absence de régression sur les services nécessaires.

---

## 📚 Documentation de référence

Le projet s'appuie notamment sur :

* **NIST SP 800-123** — Server Security
* Documentation **nftables**
* Documentation **WireGuard**
* Man pages `nmap`, `ss`, `wg`, `nft`
* Documentation **GNS3**

---

## 🏁 Résultat attendu

À la fin du capstone, LogiCorp doit disposer d'une infrastructure :

**auditable · segmentée · durcie · testée · documentée**

L'objectif n'est pas seulement de corriger les vulnérabilités actuelles, mais de construire une architecture capable de **résister à une future compromission sans permettre un mouvement latéral incontrôlé**.

> **Secure by design. Verified by testing. Documented for the future.**

