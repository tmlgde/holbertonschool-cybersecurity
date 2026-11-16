# Business Impact Quantification

Toutes les hypothèses s'appuient sur les métriques fournies : 31,2 M€ de revenu annuel récurrent, 400 laboratoires, 78 000 € de contrat moyen par laboratoire, 1,9 million de patients, coût d'interruption 65 000 à 120 000 € par heure, 1 % de perte de clients ≈ 312 000 €. Rappel : le plafond RGPD (4 % du revenu ≈ 1,25 M€) est un maximum légal, pas la perte attendue.

## Item: F-01 — Accès inter-laboratoires aux résultats
- Range: EUR 300 000 to 2 000 000 (central estimate EUR 900 000)
- Reasoning: Fuite de données de santé. Trois moteurs : amende CNIL plausible (150 000 à 600 000 € pour une fuite de santé), coûts d'investigation et de notification au-delà du contrat d'astreinte (50 000 à 150 000 €), et perte de clients de 1 à 3 % (312 000 à 936 000 €).
- Assumptions:
    - Un sous-ensemble de laboratoires et de patients est exposé, pas la totalité.
    - Scénario réglementaire : enquête CNIL avec sanction modérée, pas le plafond.
    - Perte de clients comprise entre 1 % et 3 % des 400 laboratoires.

## Item: F-03/09 — Gestion des droits d'accès (fusion)
- Range: EUR 500 000 to 3 000 000 (central estimate EUR 1 400 000)
- Reasoning: Accès large à plusieurs tenants hospitaliers, donc exposition supérieure à une faille isolée. Amende réglementaire plausible plus élevée, réponse à incident étendue, et perte de clients de 2 à 5 % (624 000 à 1 560 000 €).
- Assumptions:
    - Plusieurs tenants hospitaliers potentiellement concernés.
    - Scénario réglementaire aggravé par l'ampleur, sous le plafond de 1,25 M€ sauf circonstances exceptionnelles.
    - Perte de clients de 2 à 5 %.

## Item: F-10 — Service analytics, en-tête non vérifié
- Range: EUR 150 000 to 1 200 000 (central estimate EUR 500 000)
- Reasoning: Exposition de données d'activité agrégées, moins directement nominatives que F-01. Coûts d'investigation et réputationnels, perte de clients plus limitée. Sert surtout d'amplificateur dans la Chaîne 1.
- Assumptions:
    - Données agrégées, exposition PII indirecte.
    - Perte de clients de 0,5 à 2 %.

## Item: F-05 — Webhook de statut non signé
- Range: EUR 100 000 to 1 100 000 (central estimate EUR 450 000)
- Reasoning: Risque opérationnel : un faux statut d'échantillon peut perturber la livraison des résultats. Coûts de réconciliation manuelle, dépassement du seuil de 2 heures déclenchant une escalade, et crédits de service (65 000 à 120 000 € par heure d'interruption).
- Assumptions:
    - Perturbation de quelques heures sur un volume partiel des 62 000 échantillons quotidiens.
    - Réconciliation manuelle possible mais coûteuse.

## Item: F-06 — Rétention d'exports au-delà de la durée prévue
- Range: EUR 100 000 to 1 000 000 (central estimate EUR 400 000)
- Reasoning: Manquement de rétention sur des données de santé, exposition RGPD et HDS. Amende plausible, analyse DPO/juridique, impact sur la preuve de conformité HDS en cours de renouvellement.
- Assumptions:
    - Volume d'exports concerné limité mais contenant des données de santé.
    - Impact possible sur le dossier de renouvellement HDS prévu dans 5 mois.

## Item: F-02 — Contenu actif stocké dans le portail support
- Range: EUR 50 000 to 600 000 (central estimate EUR 200 000)
- Reasoning: Compromission possible d'une session support à accès multi-laboratoires. Coûts d'investigation et réputationnels modérés ; maillon de la Chaîne 2.
- Assumptions:
    - Exposition limitée par la MFA et les postes gérés.
    - Pas de fuite massive en l'absence d'enchaînement.

## Item: F-04 — Validation de certificat désactivée
- Range: EUR 20 000 to 400 000 (central estimate EUR 100 000)
- Reasoning: Risque résiduel faible car la passerelle d'egress impose déjà un TLS mutuel. Le coût n'apparaît que si ce contrôle tombe (défense en profondeur).
- Assumptions:
    - La passerelle reste fonctionnelle dans le scénario central.
    - L'estimation haute suppose une défaillance simultanée de la passerelle.

## Item: F-08 — Énumération de comptes
- Range: EUR 10 000 to 200 000 (central estimate EUR 50 000)
- Reasoning: Faible impact isolé. Coût surtout indirect, comme préparation d'attaques ciblées ; maillon de la Chaîne 2.
- Assumptions:
    - Pas d'impact direct sans enchaînement.
    - Sensibilité limitée des identités de laboratoire.

## Item: Chain 1 — Fuite massive de résultats (F-03/09 → F-10 → F-01)
- Range: EUR 1 500 000 to 9 000 000 (central estimate EUR 4 500 000)
- Reasoning: Fuite organisée de données de santé sur de nombreux laboratoires. Cumul des quatre moteurs : sanction réglementaire proche du plafond en cas de circonstances aggravantes, notification à grande échelle, perte de clients de 5 % ou plus (1,56 M€+), et surtout risque de suspension de la certification HDS qui menacerait directement l'activité.
- Assumptions:
    - Exposition multi-laboratoires significative parmi les 400.
    - Perte de clients de 5 à 10 %.
    - Risque HDS traité comme un risque de queue à fort impact mais probabilité modérée.
    - L'estimation haute inclut une menace sérieuse sur le renouvellement HDS.

## Item: Chain 2 — Fuite via le support (F-08 → F-02 → F-06)
- Range: EUR 400 000 to 3 000 000 (central estimate EUR 1 300 000)
- Reasoning: Trois failles moyennes qui, enchaînées, produisent une fuite réelle de données de santé via un accès support multi-laboratoires et des exports mal expirés. Amende plausible, notification, et perte de clients de 1 à 4 %.
- Assumptions:
    - Accès support à plusieurs laboratoires.
    - Exports exposés contenant des données de santé.
    - Perte de clients de 1 à 4 %.
