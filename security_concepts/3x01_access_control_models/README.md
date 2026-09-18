# Access Control & Security Architecture

## Introduction

Ce projet porte sur la mise en place d'une **architecture de contrôle d'accès** basée sur plusieurs niveaux de protection : DAC, RBAC, ABAC et MAC.

L'objectif est de réduire les accès excessifs, appliquer le **Least Privilege** et limiter l'impact d'une compromission.

## Context

**Client :** SecureHealth, un réseau hospitalier de 3 sites et 2 000 employés.

L'hôpital présente plusieurs problèmes :
- Fichiers patients accessibles sans restrictions.
- Absence de structure **RBAC** entre les différents métiers.
- Absence de confinement des applications.

La mission consiste à corriger ces problèmes en cinq étapes :

1. **The Mess** — Corriger les permissions DAC.
2. **The Blueprint** — Concevoir une politique RBAC/ABAC.
3. **The Shield** — Mettre en place AppArmor.
4. **The Big Picture** — Comprendre la défense en profondeur.
5. **Validation** — Vérifier les connaissances acquises.

## Learning Objectives

À la fin du projet, savoir expliquer :

- Les différences entre **DAC, RBAC, ABAC et MAC**.
- L'utilisation des **ACL Linux**.
- Le **Least Privilege** et la **Separation of Duties**.
- Le fonctionnement d'**AppArmor** et son rôle de MAC.
- Les différences entre **AppArmor et SELinux**.
- Le principe de **Defense in Depth**.

## Resources

- Documentation NIST sur les modèles de contrôle d'accès.
- Documentation Linux sur les permissions et ACL.
- Documentation NIST sur RBAC.
- Documentation officielle Ubuntu sur AppArmor.
- Comparaison AppArmor / SELinux.
- Études de cas Capital One et Uber.

Commandes utiles : `chmod`, `chown`, `setfacl`, `getfacl`, `aa-status`, `aa-enforce`, `aa-complain`, `apparmor_parser`.

## Requirements

- Scripts testés sur **Ubuntu, Kali ou ParrotOS**.
- Éditeurs autorisés : `vi`, `vim`, `emacs`.
- Un `README.md` est obligatoire à la racine du projet.
- Les scripts Bash doivent être exécutables et commencer par `#!/bin/bash`.
- Les réponses doivent être **concises et techniquement précises**.
- L'approche doit être celle d'un **Security Architect** travaillant sur un environnement hospitalier réel.
