## Framework Declaration
MITRE ATT&CK

## Rationale
Les extraits de contrat du document de contexte business exigent explicitement que Helix démontre sa résistance à deux groupes d'attaquants nommés, avec leurs techniques MITRE ATT&CK documentées : un groupe étatique couramment attribué à la Russie et un groupe criminel opportuniste actif contre les fournisseurs de la défense européenne. La note de menace non classifiée du BSI, document opérationnel central de la mission, constitue la spécification contractuelle de ces adversaires. Le livrable doit donc être exprimé dans le langage des techniques adverses, celui qu'utiliseront les auditeurs du BSI, les acheteurs de la DGA et les évaluateurs OTAN. Ce choix contraste avec Meridian (STRIDE, architecture en transition) et Sundara (PASTA, décision business du conseil d'administration) : ici, la question n'est ni l'architecture ni la décision, mais la résistance à des adversaires précis.

## Framework Selection Feedback
Force : ATT&CK permet de relier chaque exigence contractuelle à des techniques identifiables et vérifiables, dans un vocabulaire commun au BSI, à l'ANSSI et à l'OTAN. Limite : ATT&CK ne couvre que les techniques déjà publiées ; la technique signalée comme émergente dans la note du BSI n'y figure pas encore et doit être modélisée à part, avec un statut explicite.

## Threat Model

### Profils d'adversaires (issus des extraits de contrat)
- Groupe A — groupe étatique couramment attribué à la Russie [nom exact à reprendre du contrat]. Objectif : espionnage, accès durable et discret aux données d'analyse opérationnelle des clients de la défense.
- Groupe B — groupe criminel opportuniste [nom exact à reprendre du contrat]. Objectif : gain financier par vol de données et extorsion (rançongiciel) contre les fournisseurs de la défense européenne.

### Actifs de Helix concernés
- Plateforme SaaS multi-clients et son isolation par client.
- Comptes d'administration de la plateforme et identités cloud.
- Chaîne de développement et de déploiement du logiciel.
- Données d'analyse opérationnelle des clients aéronautiques et défense.
- Sauvegardes et capacité de restauration.

### Accès initial
- T1566 Phishing (T1566.001 pièce jointe, T1566.002 lien) — groupes A et B. Cible : comptes d'administration et d'ingénierie.
- T1078.004 Valid Accounts: Cloud Accounts — groupes A et B. Cible : identités d'administration de la plateforme.
- T1190 Exploit Public-Facing Application — groupe B principalement. Cible : interfaces exposées de la plateforme SaaS.
- T1195.002 Compromise Software Supply Chain — groupe A. Cible : chaîne de développement et de déploiement de Helix.

### Accès aux identifiants et persistance
- T1110.003 Brute Force: Password Spraying — groupes A et B. Cible : portails d'authentification.
- T1552.001 Unsecured Credentials: Credentials In Files — groupes A et B. Cible : dépôts de code, scripts de déploiement.
- T1098 Account Manipulation — groupe A. Cible : création ou modification discrète de comptes d'administration.
- T1550.001 Use Alternate Authentication Material: Application Access Token — groupe A. Cible : jetons d'accès aux API de la plateforme.

### Mouvement et collecte
- T1199 Trusted Relationship — groupe A. Passage d'un client ou d'un prestataire vers la plateforme, ou d'un environnement client à un autre.
- T1530 Data from Cloud Storage — groupes A et B. Cible : données d'analyse stockées par client.
- T1213 Data from Information Repositories — groupe A. Cible : documentation interne et outils de collaboration.

### Exfiltration et impact
- T1567 Exfiltration Over Web Service — groupes A et B. Sortie de données via des services web légitimes.
- T1486 Data Encrypted for Impact — groupe B. Chiffrement par rançongiciel.
- T1490 Inhibit System Recovery — groupe B. Destruction des sauvegardes avant le chiffrement.

### Technique émergente (non publiée dans ATT&CK)
- EMERGING-HELIX-01 — [description exacte à reprendre de la note du BSI, passage en italique]. Statut : ÉMERGENTE, pas encore publiée dans les matrices ATT&CK. Source : note de menace non classifiée du BSI. Adversaire associé : [selon la note]. Modélisée séparément, sans identifiant ATT&CK officiel.

## Identified Findings
1. **Isolation entre clients — critique (exigence contractuelle de résistance au groupe A).** Les techniques T1078.004, T1199 et T1530 permettraient au groupe étatique de passer d'un environnement client à un autre ; pour des données de défense, une rupture d'isolation invaliderait l'argument central présenté au BSI et à la DGA.
2. **Identités d'administration cloud — critique (groupes A et B).** Le phishing (T1566), le password spraying (T1110.003) et l'abus de comptes valides (T1078.004) convergent vers les mêmes comptes : ils sont le point d'entrée commun aux deux adversaires.
3. **Chaîne logicielle — haute (groupe A).** Une compromission de la chaîne de développement (T1195.002) toucherait tous les clients à la fois ; c'est la technique au plus fort impact pour un fournisseur SaaS de la défense.
4. **Résistance au rançongiciel — haute (groupe B).** T1490 puis T1486 : sans sauvegardes protégées contre la suppression, Helix ne peut pas démontrer sa capacité de restauration exigée par le contrat.
5. **Technique émergente de la note BSI — haute.** Aucune règle de détection publiée n'existe encore ; Helix doit démontrer des mesures compensatoires spécifiques, faute de quoi l'exigence contractuelle n'est pas couverte.
