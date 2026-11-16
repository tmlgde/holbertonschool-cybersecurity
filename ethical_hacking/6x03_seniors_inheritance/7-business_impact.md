# Business Impact Quantification

Toutes les hypothèses s'appuient sur les métriques fournies : 31,2 M€ de revenu annuel, 400 laboratoires, 78 000 € par laboratoire, coût d'interruption 65 000 à 120 000 € par heure, 1 % de perte de clients ≈ 312 000 €. Le plafond RGPD (4 % du revenu ≈ 1,25 M€) est un maximum légal, pas la perte attendue. Les montants sont volontairement arrondis : ce sont des ordres de grandeur pour décider d'un budget.

## Hiérarchie des impacts (par estimation centrale)

1. Chaîne 1 — central 4,5 M€ — la plus grave, car elle seule menace la certification HDS.
2. F-03/09 — central 1,5 M€ — le maillon racine, dont la correction désamorce une grande partie de la Chaîne 1.
3. Chaîne 2 — central 1,2 M€.
4. F-01 — central 1 M€.
5. F-10 — central 0,5 M€.
6. F-05 — central 0,45 M€.
7. F-06 — central 0,4 M€.
8. F-02 — central 0,2 M€.
9. F-04 — central 0,1 M€.
10. F-08 — central 0,05 M€.

Lecture pour le budget : corriger d'abord F-03/09, F-01 et F-10 fait tomber la Chaîne 1, donc le plus gros poste de perte. C'est le meilleur retour par euro investi.

## Item: F-01 — Accès inter-laboratoires aux résultats
- Range: EUR 0,3 M to 2 M (central estimate EUR 1 M)
- Reasoning: Fuite de données de santé. Coût = amende CNIL plausible + investigation et notification + départ de clients.
- Remediation lever: vérifier l'appartenance du résultat au demandeur ; désamorce un maillon de la Chaîne 1.
- Assumptions:
    - Un sous-ensemble de laboratoires et de patients exposé, pas la totalité.
    - Sanction CNIL modérée, pas le plafond.
    - Départ de 1 à 3 % des laboratoires.

## Item: F-03/09 — Gestion des droits d'accès (fusion)
- Range: EUR 0,5 M to 3 M (central estimate EUR 1,5 M)
- Reasoning: Accès large à plusieurs tenants hospitaliers. Amende plus élevée, réponse à incident étendue, départ de clients plus fort.
- Remediation lever: jetons à périmètre et durée réduits, révocation immédiate. Maillon racine : réduit aussi fortement la Chaîne 1.
- Assumptions:
    - Plusieurs tenants hospitaliers concernés.
    - Sanction sous le plafond de 1,25 M€ sauf circonstances exceptionnelles.
    - Départ de 2 à 5 % des laboratoires.

## Item: F-10 — Service analytics, en-tête non vérifié
- Range: EUR 0,15 M to 1,2 M (central estimate EUR 0,5 M)
- Reasoning: Exposition de données agrégées, moins nominatives que F-01. Amplificateur dans la Chaîne 1.
- Remediation lever: authentifier les appels internes et dériver l'identité du laboratoire de données vérifiées ; coupe un maillon de la Chaîne 1.
- Assumptions:
    - Données agrégées, exposition indirecte.
    - Départ de 0,5 à 2 % des laboratoires.

## Item: F-05 — Webhook de statut non signé
- Range: EUR 0,1 M to 1,1 M (central estimate EUR 0,45 M)
- Reasoning: Risque opérationnel : un faux statut d'échantillon perturbe la livraison des résultats. Réconciliation manuelle, escalade au-delà de 2 heures, crédits de service.
- Remediation lever: signer les événements et valider les transitions d'état ; supprime le risque d'interruption liée aux faux statuts.
- Assumptions:
    - Perturbation de quelques heures sur une partie des 62 000 échantillons quotidiens.
    - Réconciliation manuelle possible mais coûteuse.

## Item: F-06 — Rétention d'exports au-delà de la durée prévue
- Range: EUR 0,1 M to 1 M (central estimate EUR 0,4 M)
- Reasoning: Manquement de rétention sur des données de santé. Exposition RGPD et impact sur la preuve de conformité HDS en cours de renouvellement.
- Remediation lever: aligner l'expiration des liens et des objets sur la durée approuvée ; protège directement le dossier HDS.
- Assumptions:
    - Volume d'exports limité mais contenant des données de santé.
    - Impact possible sur le renouvellement HDS prévu dans 5 mois.

## Item: F-02 — Contenu actif stocké dans le portail support
- Range: EUR 0,05 M to 0,6 M (central estimate EUR 0,2 M)
- Reasoning: Compromission possible d'une session support multi-laboratoires. Maillon de la Chaîne 2.
- Remediation lever: encodage de sortie et CSP en mode blocage ; coupe le pivot central de la Chaîne 2.
- Assumptions:
    - Exposition limitée par la MFA et les postes gérés.
    - Pas de fuite massive sans enchaînement.

## Item: F-04 — Validation de certificat désactivée
- Range: EUR 0,02 M to 0,4 M (central estimate EUR 0,1 M)
- Reasoning: Risque résiduel faible car la passerelle impose déjà un TLS mutuel. Coût seulement si ce contrôle tombe.
- Remediation lever: réactiver la vérification du certificat dans le worker ; renfort de défense en profondeur.
- Assumptions:
    - Passerelle fonctionnelle dans le scénario central.
    - Estimation haute = défaillance simultanée de la passerelle.

## Item: F-08 — Énumération de comptes
- Range: EUR 0,01 M to 0,2 M (central estimate EUR 0,05 M)
- Reasoning: Faible impact isolé. Coût surtout indirect, comme préparation d'attaques ciblées. Maillon de la Chaîne 2.
- Remediation lever: réponse uniforme et limitation par compte ; retire le point de départ de la Chaîne 2.
- Assumptions:
    - Pas d'impact direct sans enchaînement.
    - Sensibilité limitée des identités de laboratoire.

## Item: Chain 1 — Fuite massive de résultats (F-03/09 → F-10 → F-01)
- Range: EUR 1,5 M to 9 M (central estimate EUR 4,5 M)
- Reasoning: Fuite organisée de données de santé sur de nombreux laboratoires. Cumul des quatre postes de coût, plus le risque de suspension de la certification HDS, qui menacerait l'activité entière. C'est ce qui place cette chaîne au sommet de la hiérarchie.
- Remediation lever: corriger F-03/09, F-10 et F-01 ; la correction du maillon racine F-03/09 est la plus efficace.
- Assumptions:
    - Exposition multi-laboratoires significative.
    - Départ de 5 à 10 % des laboratoires.
    - Risque HDS traité comme un risque de queue, à fort impact et probabilité modérée.
    - L'estimation haute inclut une menace sérieuse sur le renouvellement HDS.

## Item: Chain 2 — Fuite via le support (F-08 → F-02 → F-06)
- Range: EUR 0,4 M to 3 M (central estimate EUR 1,2 M)
- Reasoning: Trois failles moyennes qui, enchaînées, produisent une fuite réelle via un accès support multi-laboratoires et des exports mal expirés. Deuxième rang après correction de la Chaîne 1.
- Remediation lever: corriger F-02 (pivot central) en priorité, puis F-08 et F-06.
- Assumptions:
    - Accès support à plusieurs laboratoires.
    - Exports exposés contenant des données de santé.
    - Départ de 1 à 4 % des laboratoires.
