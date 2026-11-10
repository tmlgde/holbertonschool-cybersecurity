# Vanguard Security: Threat Modeling Engagement Report
## Client: Helix Aerospace Systems

**Prepared by:** [Ton nom], Junior Consultant
**Date:** [Date]
**Distribution:** Helix CISO (with downstream BSI / DGA review)

## 1. Executive Summary

Les contrats BSI et DGA exigent que Helix démontre sa résistance à deux adversaires nommés : un groupe étatique attribué à la Russie, orienté espionnage, et un groupe criminel orienté extorsion. Notre modélisation MITRE ATT&CK montre que ces deux adversaires convergent vers les mêmes points d'entrée, les identités d'administration cloud, et que trois capacités conditionnent la crédibilité de la revendication contractuelle : l'isolation stricte entre clients, la protection de la chaîne de développement logicielle et la capacité de restauration face à un rançongiciel. La note de menace du BSI signale en outre une technique émergente, absente des matrices ATT&CK publiées, pour laquelle aucune détection standard n'existe encore. Nous recommandons de traiter ces quatre points avant l'entrée en phase opérationnelle du contrat BSI, et d'en documenter la couverture pour la négociation avec la DGA.

## 2. Engagement Context

Helix Aerospace Systems, éditeur SaaS munichois d'analyse de données opérationnelles pour l'aéronautique et la défense, opère une plateforme multi-clients sur une infrastructure souveraine européenne (OVHcloud et T-Systems), attestée BSI C5. Le contrat BSI, déjà signé, entre en phase opérationnelle, et le contrat DGA est en négociation ; ensemble, ils représentent environ la moitié du chiffre d'affaires prévu. Les deux contrats font explicitement référence à la résistance à deux groupes d'attaquants nommés et à leurs techniques ATT&CK documentées.

## 3. Framework Choice and Rationale

**Framework retenu : MITRE ATT&CK.**

Les extraits de contrat du document de contexte business et la note de menace non classifiée du BSI définissent précisément les adversaires contre lesquels Helix doit démontrer sa résistance, en termes de techniques ATT&CK. Le livrable doit donc parler le langage des techniques adverses, commun au BSI, à l'ANSSI et à l'OTAN. Ce choix contraste avec Meridian, où STRIDE servait à décomposer une architecture en transition pour une équipe d'ingénierie, et avec Sundara, où PASTA servait à éclairer une décision business du conseil d'administration : pour Helix, la question est la résistance à des adversaires identifiés.

## 4. Threat Model

**Adversaires (issus des contrats) :**
- **Groupe A**, étatique, attribué à la Russie : espionnage et accès durable aux données de défense des clients.
- **Groupe B**, criminel opportuniste : vol de données et extorsion par rançongiciel.

**Techniques retenues, par phase d'attaque :**
- **Accès initial :** phishing (T1566), comptes cloud valides (T1078.004), exploitation d'applications exposées (T1190, groupe B), compromission de la chaîne logicielle (T1195.002, groupe A).
- **Identifiants et persistance :** password spraying (T1110.003), identifiants dans des fichiers (T1552.001), manipulation de comptes (T1098, groupe A), vol de jetons d'accès applicatifs (T1550.001, groupe A).
- **Mouvement et collecte :** relation de confiance (T1199, groupe A), données du stockage cloud (T1530), dépôts d'information internes (T1213, groupe A).
- **Exfiltration et impact :** exfiltration via des services web (T1567), destruction des sauvegardes (T1490, groupe B), chiffrement par rançongiciel (T1486, groupe B).
- **Technique émergente :** EMERGING-HELIX-01, signalée dans la note du BSI comme non encore publiée dans ATT&CK (voir annexe).

**Lecture transversale :** les deux adversaires partagent les mêmes points d'entrée (identités d'administration), mais divergent ensuite. Le groupe A cherche la discrétion et le passage d'un client à un autre ; le groupe B cherche l'impact rapide, en détruisant les sauvegardes puis en chiffrant.

## 5. Recommendations and Prioritization

1. **Démontrer l'isolation entre clients (contre T1078.004, T1199, T1530 — groupe A).** Séparer les identités et les clés de chiffrement par client, interdire tout accès administratif transversal sans validation, et faire tester l'isolation par un test d'intrusion dédié dont les résultats seront présentés au BSI.
2. **Durcir les identités d'administration (contre T1566, T1110.003, T1078.004 — groupes A et B).** Authentification multifacteur résistante au phishing (clés matérielles) pour tous les comptes d'administration, accès d'administration à durée limitée, détection des connexions anormales et des modifications de comptes (T1098).
3. **Protéger la chaîne logicielle (contre T1195.002, T1552.001 — groupe A).** Signature des artefacts de déploiement, revue obligatoire des modifications, suppression des secrets dans les dépôts de code, séparation des droits entre développement et production.
4. **Garantir la restauration face au rançongiciel (contre T1490, T1486 — groupe B).** Sauvegardes immuables et isolées des comptes d'administration courants, exercices de restauration réguliers et documentés pour prouver la capacité de reprise.
5. **Couvrir la technique émergente (EMERGING-HELIX-01).** Définir des mesures de détection et de protection spécifiques à partir de la description du BSI, et documenter cette couverture comme preuve de résistance, faute de règle de détection standard.

## 6. Limitations and Uncertainty

- **Technique émergente :** EMERGING-HELIX-01 ne figure pas encore dans les matrices ATT&CK publiées. Sa modélisation repose uniquement sur la description de la note du BSI ; son identifiant est interne à ce rapport et devra être remplacé par l'identifiant officiel s'il est publié.
- **Limites d'ATT&CK :** le framework ne couvre que les techniques déjà observées et documentées ; un adversaire étatique peut employer des techniques inédites. La couverture présentée correspond aux techniques connues à la date du rapport.
- **Infrastructure des fournisseurs cloud :** la sécurité physique et l'infrastructure sous-jacente relèvent d'OVHcloud et de T-Systems (responsabilité partagée). Seuls les éléments contrôlés par Helix ont été modélisés.
- **Profils des parties prenantes :** les personnes nommées dans le document de profils n'ont pas été modélisées comme des menaces internes. Le profilage d'individus ne relève pas de la modélisation des menaces et serait problématique au regard du droit du travail européen ; seuls des rôles (comptes d'administration, équipes d'ingénierie) apparaissent dans le modèle.
- **Analyse documentaire :** aucun test technique n'a été réalisé ; la résistance doit être confirmée par des tests, idéalement un exercice d'émulation des deux adversaires.

## 7. Appendix: Sourced Findings

**EMERGING-HELIX-01 — STATUT : ÉMERGENTE, NON PUBLIÉE DANS MITRE ATT&CK**
- Source : note de menace non classifiée du BSI, passage signalé en italique.
- Description : [à reprendre exactement de la note du BSI].
- Adversaire associé : [selon la note].
- Traitement : modélisée séparément, sans identifiant ATT&CK officiel ; à réévaluer lors de la prochaine publication des matrices ATT&CK.
