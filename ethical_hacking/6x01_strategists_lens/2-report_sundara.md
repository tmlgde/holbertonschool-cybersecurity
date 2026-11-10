# Vanguard Security: Threat Modeling Engagement Report
## Client: Sundara Lifestyle

**Prepared by:** [Ton nom], Junior Consultant
**Date:** [Date]
**Distribution:** Sundara board (CFO, CEO, independent directors)

## 1. Executive Summary

Lancer en Europe comme prévu expose Sundara à deux risques majeurs : une fuite de données de fidélité semblable à celle qui a ruiné le lancement européen d'un concurrent, et une non-conformité au droit européen dès le premier client, car les données des clients européens partent vers Singapour sans cadre légal. Un report complet de six mois n'est toutefois pas nécessaire. Nous recommandons un lancement conditionnel : ouvrir comme prévu, mais n'activer le programme de fidélité et la réservation transfrontalière pour les clients européens qu'une fois trois conditions remplies, réalisables en quelques semaines : encadrer légalement les transferts de données vers Singapour, protéger les comptes de fidélité contre le piratage, et réaliser l'analyse d'impact obligatoire sur la géolocalisation et les recommandations personnalisées. Le risque résiduel après ces mesures est modéré et compatible avec le calendrier de l'introduction en Bourse.

## 2. Engagement Context

Sundara, marque singapourienne présente dans 180 magasins en Asie, lance son expansion en Allemagne, en France et aux Pays-Bas en vue d'une introduction en Bourse. Vanguard a été mandaté après qu'une marque asiatique comparable a subi une fuite massive de données de fidélité quelques semaines avant son propre lancement européen, ce qui a détruit sa crédibilité. Le conseil doit décider s'il retarde le lancement de six mois pour renforcer la sécurité, ou s'il le maintient.

## 3. Framework Choice and Rationale

**Framework retenu : PASTA.**

Le document de contexte business place la décision du conseil au centre (retarder ou lancer, sous la pression de l'IPO) et cite le précédent du concurrent ; le schéma de l'application mobile montre 12 millions de comptes de fidélité, de la géolocalisation, des recommandations par IA et un module de réservation transfrontalier soumis à deux régimes juridiques. PASTA part des objectifs business avant de descendre vers la technique, et relie chaque menace à son impact sur cette décision. Ce choix contraste avec Meridian (STRIDE, question purement architecturale pour une équipe technique) et Helix (MITRE ATT&CK, résistance à des attaquants identifiés).

## 4. Threat Model

L'analyse suit les sept étapes de PASTA, ancrées sur un objectif : réussir le lancement européen sans incident de données qui compromettrait l'IPO.

- **Objectifs business :** lancer sans incident, protéger l'IPO, être conforme au RGPD dès le premier client européen et rester conforme à la PDPA en Asie.
- **Périmètre :** application mobile, comptes de fidélité, paiement intégré (côté Sundara), géolocalisation, recommandations IA, réservation transfrontalière, partage avec les partenaires marketing. Le matériel des caisses, géré par un tiers, n'est pas modélisé.
- **Flux et régimes juridiques :** les données des clients européens relèvent du RGPD, y compris lorsqu'elles sont traitées à Singapour ; leur transfert vers Singapour exige un mécanisme légal. La PDPA impose de son côté ses propres règles aux données qui quittent Singapour.
- **Menaces :** prise de contrôle de comptes de fidélité, vol de données de paiement par code malveillant, fuite via les partenaires marketing, sanctions réglementaires européennes.
- **Vulnérabilités :** comptes peu protégés, transferts non encadrés, profilage sans analyse d'impact, partage de données non minimisé.
- **Scénarios d'attaque :** piratage massif de comptes rendu public avant l'IPO ; capture des cartes bancaires dans l'application ; enquête d'une autorité européenne bloquant le programme de fidélité.
- **Impact business :** les deux scénarios les plus graves (piratage des comptes et non-conformité des transferts) touchent directement la crédibilité du lancement et la valorisation de l'IPO.

## 5. Recommendations and Prioritization

1. **Encadrer les transferts de données vers Singapour (condition au lancement du programme de fidélité en Europe).** Mettre en place un mécanisme légal de transfert (clauses contractuelles types), réaliser l'évaluation du transfert, et documenter les flux. Sans cela, chaque inscription européenne est une non-conformité.
2. **Protéger les comptes de fidélité (condition au lancement).** Authentification renforcée, détection et blocage des tentatives de connexion automatisées, alertes aux clients en cas de connexion inhabituelle. C'est la protection directe contre le scénario du concurrent.
3. **Réaliser l'analyse d'impact sur la géolocalisation et les recommandations IA (condition au lancement).** Obligatoire au titre du RGPD pour ce type de profilage ; prévoir un consentement clair et la possibilité de refuser.
4. **Limiter et encadrer le partage avec les partenaires marketing (dans les trois mois).** Ne transmettre que les données nécessaires, avec des contrats de traitement conformes au RGPD.
5. **Contrôler l'intégrité du parcours de paiement (dans les trois mois).** Surveillance du code exécuté lors du paiement, pour détecter toute injection malveillante.

## 6. Limitations and Uncertainty

- **Matériel des caisses (POS) :** fourni et exploité par un tiers, il n'a pas été modélisé comme une responsabilité de Sundara. Sa sécurité doit être garantie contractuellement par le fournisseur ; nous recommandons de demander ses rapports d'audit.
- **Interaction PDPA / RGPD :** notre analyse identifie les points de friction entre les deux régimes (transferts, notification des incidents : 72 heures pour le RGPD, 3 jours pour la PDPA), mais elle ne constitue pas un avis juridique. Une validation par un juriste spécialisé dans chaque juridiction est nécessaire.
- **Partenaires et prestataire de paiement :** seule la part de Sundara (ce qui est transmis et sur quelle base) a été évaluée, pas les systèmes de ces tiers.
- **Analyse documentaire :** aucun test technique n'a été réalisé ; les vulnérabilités identifiées doivent être confirmées par un test d'intrusion ciblé de l'application.

## 7. Appendix: Sourced Findings

Aucune découverte cachée n'a été documentée lors de l'exploration de l'espace de travail.
