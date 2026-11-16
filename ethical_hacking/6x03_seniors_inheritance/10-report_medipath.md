# Penetration Test Report, MediPath Diagnostics

**Engagement reference:** VS-MPD-26-041
**Reporting period:** 04–12 juin 2026 (tests techniques) ; finalisation novembre 2026
**Prepared by:**  Junior Consultant, Vanguard Security
**Distribution:** Medipath audit comittee

## 1. Executive Summary

Nous avons examiné la sécurité de la plateforme MediPath afin de préparer le comité d'audit et le renouvellement de la certification HDS. L'objectif était de vérifier si les données de santé gérées pour les 400 laboratoires partenaires sont correctement protégées, et de chiffrer ce qu'un incident coûterait réellement. L'évaluation est globalement rassurante sur la conception de la plateforme, mais elle met en évidence plusieurs points à corriger rapidement, dont un scénario majeur qui pourrait menacer l'activité s'il n'était pas traité.

Le comité peut prendre quatre décisions. Premièrement, financer en priorité la correction du scénario le plus grave : une combinaison de faiblesses pourrait permettre d'accéder aux résultats médicaux de nombreux laboratoires à la fois, pour une perte probable d'environ 4,5 millions d'euros et un risque pesant sur la certification HDS. Deuxièmement, autoriser la révision de la façon dont les droits d'accès sont accordés et retirés, cause commune de plusieurs problèmes, dont la correction désamorce une grande partie du risque principal. Troisièmement, mettre en conformité la durée de conservation des exports de données, directement liée au renouvellement HDS prévu dans cinq mois. Quatrièmement, approuver un second lot de corrections visant un scénario de fuite via le portail de support, estimé à environ 1,2 million d'euros.

Après ces corrections, le risque résiduel devient faible et maîtrisé. Aucune fuite réelle n'a eu lieu pendant l'évaluation, menée sur un environnement de test. Les corrections prioritaires tiennent dans la fenêtre de huit semaines du comité, pour un budget raisonnable au regard des pertes évitées.

## 2. Engagement Scope and Methodology

La phase technique de cette mission a été menée par Sarah Chen, consultante senior, du 4 au 12 juin 2026, sur un environnement de test équivalent à la production et sur les points d'intégration approuvés. Étaient exclus : les tests destructeurs, les tests de déni de service, l'ingénierie sociale, les dossiers patients réels de production et l'infrastructure des laboratoires tiers. Son rapport technique, complet et étayé par des preuves, constitue le socle du présent document.

Le présent rapport prolonge ce travail par la phase de traduction client : recalibrage des scores selon le contexte de MediPath, tri des constats, mise en évidence des enchaînements, chiffrage en euros et restructuration pour le comité. Les scores techniques de base établis lors des tests ont été conservés comme point de départ et ajustés au contexte, non remis en cause. Chaque ajustement est tracé par une note de correction neutre dans la section des constats.

## 3. Findings Synthesis

### Finding F-03/09, Severity 9.3 Critical (fusion de F-03 et F-09)
- **Description technique :** un jeton d'intégration reste valable 180 jours avec des droits trop larges qui fonctionnent au-delà de son périmètre (volet F-03) ; et des privilèges d'administration persistent environ 27 minutes après une rétrogradation, le temps que le cache d'autorisation expire (volet F-09).
- **Justification CVSS environnementale :** score porté à 9.3 (Critical). *Note de correction : F-03 et F-09 étaient deux constats séparés dans le rapport initial ; ils sont réunis ici car ils partagent une même cause racine de gouvernance des identités, afin d'éviter deux correctifs redondants. Les deux manifestations restent décrites pour la traçabilité.*
- **Impact business :** central 1,5 million d'euros ; fourchette 0,5 à 3 millions.
- **Contexte de chaîne :** maillon racine de la Chaîne 1.
- **Remédiation :** jetons à périmètre et durée réduits, révocation immédiate sur changement de rôle. Responsable : Identity and Access Management Lead. Délai : immédiat.

### Finding F-01, Severity 8.8 High
- **Description technique :** l'API de résultats vérifie que l'utilisateur est connecté mais pas que le résultat demandé appartient à son laboratoire ; en changeant l'identifiant, un laboratoire lit les résultats d'un autre.
- **Justification CVSS environnementale :** score porté de 8.1 à 8.8. *Note de correction : relèvement environnemental motivé par la sensibilité des données de santé (RGPD article 9) et l'exposition sur 400 laboratoires.*
- **Impact business :** central 1 million d'euros ; fourchette 0,3 à 2 millions.
- **Contexte de chaîne :** maillon de la Chaîne 1.
- **Remédiation :** vérifier l'appartenance du résultat au demandeur au niveau de l'accès aux données. Responsable : Head of Platform Engineering. Délai : immédiat.

### Finding F-10, Severity 8.5 High
- **Description technique :** le service d'analytics interne fait confiance à une étiquette de laboratoire fournie par l'appelant, modifiable depuis le réseau applicatif.
- **Justification CVSS environnementale :** score porté de 8.0 à 8.5. *Note de correction : relèvement lié à l'atteignabilité depuis le réseau applicatif et au rôle d'amplificateur dans les enchaînements.*
- **Impact business :** central 0,5 million d'euros ; fourchette 0,15 à 1,2 million.
- **Contexte de chaîne :** maillon de la Chaîne 1.
- **Remédiation :** authentifier les appels internes et dériver l'identité du laboratoire de données vérifiées. Responsable : Data Platform Lead. Délai : immédiat.

### Finding F-05, Severity 8.1 High
- **Description technique :** le webhook de statut d'échantillon accepte des événements non signés ; seule une liste d'adresses autorisées protège.
- **Justification CVSS environnementale :** score porté de 7.5 à 8.1. *Note de correction : relèvement lié à l'exigence d'intégrité élevée, les workflows aval faisant confiance au statut.*
- **Impact business :** central 0,45 million d'euros ; fourchette 0,1 à 1,1 million.
- **Remédiation :** signer les événements, valider les transitions d'état et la fraîcheur. Responsable : Integration Engineering Lead. Délai : trimestriel.

### Finding F-06, Severity 7.1 High
- **Description technique :** des exports de diagnostic restent téléchargeables 30 jours au lieu des 24 heures documentées.
- **Justification CVSS environnementale :** score porté de 6.5 à 7.1. *Note de correction : relèvement lié à l'exposition RGPD et HDS sur des données de santé.*
- **Impact business :** central 0,4 million d'euros ; fourchette 0,1 à 1 million.
- **Contexte de chaîne :** maillon de la Chaîne 2.
- **Remédiation :** aligner l'expiration des liens et des objets sur la durée approuvée, vérifier la suppression. Responsable : Data Platform Lead ; durée fixée en amont par le DPO. Délai : trimestriel.

### Finding F-02, Severity 6.1 Medium
- **Description technique :** une note de laboratoire peut contenir du contenu actif qui s'exécute dans le portail support lorsqu'un analyste l'ouvre.
- **Justification CVSS environnementale :** score inchangé à 6.1. *Note de correction : la sensibilité santé et l'accès multi-laboratoires du support tirent vers le haut, mais la MFA, les postes gérés et la politique de contenu compensent ; les effets s'annulent.*
- **Impact business :** central 0,2 million d'euros ; fourchette 0,05 à 0,6 million.
- **Contexte de chaîne :** pivot central de la Chaîne 2.
- **Remédiation :** encodage de sortie contextuel et politique de contenu en mode blocage. Responsable : Support Operations Manager. Délai : trimestriel.

### Finding F-04, Severity 5.4 Medium
- **Description technique :** un worker connecteur a la vérification du certificat désactivée.
- **Justification CVSS environnementale :** score abaissé de 8.2 à 5.4. *Note de correction : abaissement motivé par une mesure compensatoire réelle, la passerelle d'egress privée imposant déjà un TLS mutuel et validant le certificat amont ; subsiste un défaut de défense en profondeur.*
- **Impact business :** central 0,1 million d'euros ; fourchette 0,02 à 0,4 million.
- **Remédiation :** réactiver la vérification du certificat dans le worker. Responsable : Site Reliability Engineering Lead. Délai : trimestriel.

### Finding F-08, Severity 5.3 Medium
- **Description technique :** le flux de récupération de mot de passe répond différemment selon que le compte existe ou non.
- **Justification CVSS environnementale :** score inchangé à 5.3. *Note de correction : faible gravité isolée confirmée ; valeur principale comme maillon de chaîne.*
- **Impact business :** central 0,05 million d'euros ; fourchette 0,01 à 0,2 million.
- **Contexte de chaîne :** point de départ de la Chaîne 2.
- **Remédiation :** réponse uniforme et limitation par compte. Responsable : Identity and Access Management Lead. Délai : backlog.

### Chaînes d'attaque
- **Chaîne 1 (F-03/09 → F-10 → F-01) :** un accès large sert à cibler un laboratoire via l'étiquette non vérifiée, puis à lire ses résultats. Impact combiné central 4,5 millions d'euros, avec risque sur la certification HDS. Pilote : Identity and Access Management Lead.
- **Chaîne 2 (F-08 → F-02 → F-06) :** connaître les comptes existants rend un piège crédible dans le portail support, puis donne accès à des exports mal expirés. Impact combiné central 1,2 million d'euros. Pilote : Support Operations Manager.

## 4. Addendum: Retired and Merged Findings

**Constat retiré F-07.** Après vérification du contexte client, la capacité d'export massif n'est pas une faille mais une fonction d'urgence prévue et encadrée : ticket approuvé par le DPO, authentification forte par clé, double validation, chiffrement par clé dédiée, expiration courte et journaux non modifiables. Le compte de test avait été autorisé à l'avance pour exercer ce contrôle, ce qui explique sa réponse. Le comportement observé correspond à la fonction voulue ; le constat est retiré du rapport principal. Recommandation : confirmer par un contrôle ponctuel que chaque chemin de production applique ces validations, et conserver cette trace pour l'audit HDS.

**Constats fusionnés F-03 et F-09 en F-03/09.** Les deux décrivent deux symptômes d'une même cause : les droits d'accès ne sont pas retirés assez vite ni assez précisément. Les réunir évite de proposer deux fois le même correctif et désigne le vrai chantier : une gestion des droits à révocation immédiate et à périmètre strict. Les deux manifestations restent décrites pour la traçabilité.

## 5. Strategic Recommendations

- **Court terme (fenêtre de douze jours) :** financer et lancer la correction de la Chaîne 1 par son maillon racine F-03/09, puis F-01 et F-10. C'est le meilleur retour par euro investi, car il fait tomber le scénario à 4,5 millions d'euros.
- **Moyen terme (trimestriel) :** traiter F-05, F-06 et la Chaîne 2 (F-02, F-08). Prioriser F-06 avant le renouvellement HDS.
- **Gouvernance (niveau comité) :** inscrire la gestion des identités comme thème de suivi récurrent, vérifier l'application réelle du workflow d'urgence (ex-F-07), et aligner le budget de remédiation sur les pertes évitées chiffrées dans ce rapport.

## 6. Limitations and Uncertainty

L'évaluation a porté sur un environnement de test équivalent à la production et sur les intégrations approuvées ; elle exclut les dossiers patients réels, l'infrastructure des laboratoires tiers, les tests destructeurs et de déni de service, et l'ingénierie sociale. Les chiffres en euros sont des ordres de grandeur fondés sur les métriques fournies par MediPath, destinés à éclairer une décision de budget, non des montants exacts. Certaines faiblesses sont identifiées mais leur exploitation complète n'a pas été poussée au-delà du nécessaire (par exemple le risque d'accès entre laboratoires sur l'API, confirmé sur des comptes de test). Ce rapport apporte la preuve technique au dossier de conformité ; il ne constitue ni un audit HDS complet ni un avis juridique.

## 7. Appendices

### A. Detailed finding tables
| Finding | Base | Environnemental | Delta | Impact central | Responsable |
| --- | --- | --- | --- | --- | --- |
| F-03/09 | 8.8 / 7.2 | 9.3 Critical | ↑ | 1,5 M€ | IAM Lead |
| F-01 | 8.1 | 8.8 High | ↑ | 1 M€ | Head of Platform Engineering |
| F-10 | 8.0 | 8.5 High | ↑ | 0,5 M€ | Data Platform Lead |
| F-05 | 7.5 | 8.1 High | ↑ | 0,45 M€ | Integration Engineering Lead |
| F-06 | 6.5 | 7.1 High | ↑ | 0,4 M€ | Data Platform Lead |
| F-02 | 6.1 | 6.1 Medium | = | 0,2 M€ | Support Operations Manager |
| F-04 | 8.2 | 5.4 Medium | ↓ | 0,1 M€ | SRE Lead |
| F-08 | 5.3 | 5.3 Medium | = | 0,05 M€ | IAM Lead |
| F-07 | 9.1 | Retirée | — | — | — |

### B. CVSS environmental calculations
Le recalibrage applique, pour MediPath, des exigences de confidentialité et d'intégrité élevées (données de santé, intégrité du diagnostic). Les scores montent lorsque l'actif touche des données de santé, et descendent lorsqu'une mesure compensatoire réelle réduit l'exposition (F-04 : passerelle TLS ; F-07 : workflow validé, retiré).

### C. Attack chain diagrams
- Chaîne 1 : F-03/09 (accès large) → F-10 (cibler un laboratoire) → F-01 (lire les résultats) → fuite massive de données de santé.
- Chaîne 2 : F-08 (lister les comptes) → F-02 (piéger le support) → F-06 (récupérer des exports expirés) → fuite via le support.

### D. Glossary
- **Donnée de santé :** information médicale protégée par le RGPD (article 9).
- **HDS :** certification française obligatoire pour héberger des données de santé.
- **Tenant / laboratoire :** espace client isolé sur la plateforme.
- **Jeton d'accès :** clé numérique permettant à un système de se connecter.
- **Score CVSS :** note de gravité d'une faille, de 0 à 10 ; la version environnementale l'ajuste au contexte du client.
- **Chaîne d'attaque :** enchaînement de plusieurs faiblesses dont l'effet combiné dépasse la somme des parties.
