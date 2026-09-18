# Threat Model — Nexus Financial

**Date:** 18 septembre 2026
**Auteur:** CISO par intérim
**Contexte:** Suite à l'audit terrain réalisé 5 jours avant l'arrivée de l'auditeur externe pré-IPO, ce document identifie formellement les actifs à risque, la menace STRIDE dominante pour chacun, et l'acteur le plus réaliste susceptible de l'exploiter. Il sert de base de justification pour toutes les décisions de remédiation documentées dans `technical/` et `audit/`.

## Analyse STRIDE

| Component | Top STRIDE Threat | Threat Actor | Justification |
|---|---|---|---|
| Réseau Wi-Fi (mot de passe au marqueur, tableau visible) | Information Disclosure | Insider | Secret censé être confidentiel exposé à toute personne physiquement présente dans les locaux (employés, visiteurs, prestataires) — la confidentialité est rompue avant même qu'un acteur n'agisse. |
| Clé SSH `nexus_master.pem` (Slack interne public) | Information Disclosure | Insider | Clé maître postée dans un channel accessible à toute l'entreprise ; secret exposé en interne, sans besoin d'accès externe. |
| Base de données Postgres (`0.0.0.0/0`) | Information Disclosure | Cybercriminels | Base scannable et accessible depuis Internet sans restriction — profil type d'un scan automatisé ou d'un attaquant opportuniste externe. |
| Système de badges (génériques, cartes non tracées) | Spoofing | Insider | Badges non nominatifs : impossible de vérifier l'identité réelle du porteur, exploitable par un ancien employé ou un emprunt de carte. |
| Salle serveur (porte biométrique bloquée par un extincteur) | Elevation of Privilege | Insider | Le contrôle d'accès est totalement contourné : n'importe qui obtient le niveau de privilège maximal (accès physique aux serveurs) sans aucune vérification. |
| PIN admin (= année de naissance du CEO) | Spoofing | Cybercriminels | Secret prévisible et devinable via reconnaissance ciblée (OSINT) sur le CEO, permettant l'usurpation de l'identité admin. |
| Logs absents | Repudiation | Cybercriminels | Sans traçabilité, aucune action ne peut être attribuée avec certitude — bénéfice direct pour un acteur cherchant l'impunité. |
| Sauvegardes non vérifiées (3 mois) | Denial of Service | Cybercriminels | Sauvegardes potentiellement inutilisables au moment critique de la restauration — scénario typique d'une attaque ransomware pariant sur l'absence de plan B fonctionnel. |

## Synthèse

Deux patterns structurent la priorisation de la remédiation :

1. **Une gestion des secrets défaillante domine les risques de confidentialité** (Wi-Fi, clé SSH, PIN admin) — trois des huit constats partagent la même cause racine : des secrets stockés ou communiqués sans aucun contrôle. La remédiation de ces trois points relève d'une seule et même politique de gestion des secrets, pas de trois correctifs isolés.
2. **L'acteur "Insider" domine tout ce qui touche au physique et à l'interne**, tandis que **"Cybercriminels" domine tout ce qui est exposé à Internet ou reconstructible par reconnaissance externe**. Cette séparation nette justifie de traiter en parallèle deux chantiers distincts : durcissement du contrôle d'accès interne/physique, et réduction de la surface d'exposition externe.
