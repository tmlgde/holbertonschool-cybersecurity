# Threat Model — Nexus Financial

**Date:** 18 septembre 2026
**Auteur:** CISO par intérim
**Version:** 1.0 — pré-audit externe (J-5)
**Statut:** Document de référence pour policy/, technical/ et audit/

## Contexte

Ce document fait suite à l'audit terrain réalisé cette semaine, qui a révélé de multiples failles de sécurité critiques à travers l'organisation. Il identifie formellement les actifs à risque, la menace STRIDE dominante pour chacun, et l'acteur le plus réaliste susceptible de l'exploiter.

L'entreprise entre en phase d'introduction en bourse (IPO), avec un audit de sécurité externe prévu dans 5 jours. Ce document constitue la première pierre du programme de sécurité défensif, structuré ensuite en quatre piliers : Governance, Prevention, Detection, Response.

## Scope

Le périmètre couvre l'infrastructure réseau, les secrets d'authentification, les bases de données de production, le contrôle d'accès physique et logique, ainsi que les capacités de détection et de reprise après incident. Les composants applicatifs métier ne sont pas couverts par cette version et feront l'objet d'une itération ultérieure.

## Méthodologie

L'analyse suit le framework STRIDE. Pour chaque composant identifié lors de l'audit terrain, la menace la plus directe et la plus critique est retenue comme "Top 1 Threat", accompagnée de l'acteur ayant la capacité et la motivation réalistes de l'exploiter.

### Glossaire STRIDE

| Lettre | Menace | Propriété violée |
|---|---|---|
| S | Spoofing | Authentification |
| T | Tampering | Intégrité |
| R | Repudiation | Non-répudiation |
| I | Information Disclosure | Confidentialité |
| D | Denial of Service | Disponibilité |
| E | Elevation of Privilege | Autorisation |

### Acteurs considérés

- **Insider** : personne disposant (ou ayant disposé) d'un accès légitime à l'entreprise, physique ou logique.
- **Cybercriminels** : acteurs externes financièrement motivés, opportunistes ou menant une reconnaissance ciblée.

## Analyse STRIDE

| Component | Top STRIDE Threat | Threat Actor | Justification |
|---|---|---|---|
| Réseau Wi-Fi (mot de passe au marqueur, tableau visible) | Information Disclosure | Insider | Secret exposé à toute personne physiquement présente dans les locaux. |
| Clé SSH `nexus_master.pem` (Slack interne public) | Information Disclosure | Insider | Clé maître postée dans un channel accessible à toute l'entreprise. |
| Base de données Postgres (`0.0.0.0/0`) | Information Disclosure | Cybercriminels | Base scannable et accessible depuis Internet sans restriction. |
| Système de badges (génériques, cartes non tracées) | Spoofing | Insider | Badges non nominatifs : impossible de vérifier l'identité du porteur. |
| Salle serveur (porte biométrique bloquée par un extincteur) | Elevation of Privilege | Insider | Contrôle d'accès totalement contourné, privilège maximal sans vérification. |
| PIN admin (= année de naissance du CEO) | Spoofing | Cybercriminels | Secret devinable via reconnaissance ciblée (OSINT) sur le CEO. |
| Logs absents | Repudiation | Cybercriminels | Aucune action ne peut être attribuée avec certitude. |
| Sauvegardes non vérifiées (3 mois) | Denial of Service | Cybercriminels | Sauvegardes potentiellement inutilisables lors d'une restauration critique. |

## Synthèse

Deux patterns structurent la priorisation de la remédiation.

D'une part, une gestion des secrets défaillante domine les risques de confidentialité (Wi-Fi, clé SSH, PIN admin) : trois constats sur huit partagent la même cause racine et relèvent d'une seule et même politique de gestion des secrets, plutôt que de trois correctifs isolés.

D'autre part, l'acteur "Insider" domine tout ce qui touche au physique et à l'interne, tandis que "Cybercriminels" domine tout ce qui est exposé à Internet ou reconstructible par reconnaissance externe. Cette séparation nette justifie de mener en parallèle deux chantiers de remédiation distincts.

## Prochaines étapes

Ce threat model sert de base de justification pour l'Access Control Policy, le Physical Security Plan et l'Incident Response Plan à venir dans `policy/`, ainsi que pour les scripts de remédiation dans `technical/` et le rapport de preuve dans `audit/`.

## Révision

Ce document sera revu et mis à jour après remédiation des constats de l'audit terrain, avant la venue de l'auditeur externe.
