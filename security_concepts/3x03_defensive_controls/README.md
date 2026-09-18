# GRC & Defense in Depth

## Introduction

Ce projet introduit le **GRC (Governance, Risk and Compliance)** et la **Defense in Depth**.

L'objectif est de comprendre comment les contrôles **administratifs, techniques et physiques** fonctionnent ensemble pour protéger une organisation.

## Context

**Client :** BioHealth Inc., une startup biotech traitant des données génomiques de patients en France, Allemagne et Royaume-Uni.

La CNIL a lancé un contrôle après la découverte d'accès non autorisés à des données patients, notamment via des identifiants partagés.

BioHealth doit mettre en place un cadre de sécurité **documenté et auditable sous 90 jours**.

### Mission

1. **Control Inventory** — Classer les contrôles administratifs, techniques et physiques.
2. **Incident Reconstruction** — Analyser un incident impliquant une clé USB et un keylogger.
3. **Policy Drafting** — Rédiger une Acceptable Use Policy (AUP).
4. **Physical Security Review** — Identifier les vulnérabilités physiques du nouveau serveur.
5. **Gap Analysis** — Identifier les écarts et proposer des remédiations ou compensating controls.

## Learning Objectives

À la fin du projet, savoir :

- Distinguer les contrôles **Administrative, Technical et Physical**.
- Distinguer les fonctions **Preventive, Detective, Corrective, Deterrent et Compensating**.
- Réaliser une **Gap Analysis**.
- Rédiger une **Acceptable Use Policy**.
- Comprendre **ISO 27001** et **NIST SP 800-53**.
- Appliquer la **Defense in Depth**.
- Analyser les risques liés à la sécurité physique.
- Concevoir des **Compensating Controls** pour les systèmes impossibles à mettre à jour.

## Requirements

- Les livrables doivent être **professionnels, précis et structurés**.
- Les Gap Analyses doivent préciser : **finding, current state, required state, remediation, owner et deadline**.
- Chaque problème identifié doit avoir une remédiation.
- Les recommandations doivent tenir compte du budget d'environ **40 000 €** et du délai de **90 jours**.
- Le système Windows XP de l'IRM ne peut pas être mis à jour : un **Compensating Control** doit être proposé.
