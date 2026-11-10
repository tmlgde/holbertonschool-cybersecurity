## Framework Declaration
PASTA

## Rationale
La mission doit éclairer une décision du conseil d'administration : retarder le lancement européen de six mois ou le maintenir, sous la pression du calendrier d'introduction en Bourse. Le document de contexte business cite le précédent d'une marque asiatique comparable dont la fuite de données de fidélité a ruiné le lancement européen, et le schéma de l'application mobile montre 12 millions de comptes de fidélité, de la géolocalisation, des recommandations par IA et un module de réservation transfrontalier. Le risque central est donc business et réglementaire (passage du cadre PDPA singapourien au RGPD européen), pas seulement technique. PASTA part des objectifs business avant toute décomposition technique, ce qui correspond à cette question et à un public non technique. STRIDE a déjà été utilisé pour Meridian, dont la question était purement architecturale.

## Framework Selection Feedback
Force : PASTA relie chaque menace à son impact sur la décision « retarder ou lancer », ce qui rend l'analyse utilisable par le conseil. Limite : la méthode est plus lourde et moins exhaustive sur le détail technique de l'application qu'une décomposition STRIDE ; certaines faiblesses techniques fines devront être confirmées par un test d'intrusion ciblé.

## Threat Model

### Étape I — Objectifs business
- Lancer en Allemagne, en France et aux Pays-Bas sans incident de données qui compromettrait la crédibilité de la marque.
- Protéger l'introduction en Bourse : un incident majeur avant l'IPO toucherait directement la valorisation.
- Être conforme au RGPD dès le premier client européen, tout en restant conforme à la PDPA en Asie.
- Question à trancher par le conseil : retarder de six mois pour renforcer la sécurité, ou lancer comme prévu.

### Étape II — Périmètre technique
- Dans le périmètre (responsabilité de Sundara) : application mobile, comptes de fidélité (12 millions), module de paiement intégré (côté Sundara), géolocalisation, moteur de recommandations IA, module de réservation transfrontalier, flux de données vers les partenaires marketing.
- Hors du modèle : le matériel des caisses (POS), fourni et exploité par un tiers. Il est traité dans les limites du rapport, pas comme une responsabilité de Sundara.
- Pour les tiers (prestataire de paiement, partenaires marketing) : seule la part de Sundara est modélisée, c'est-à-dire ce que Sundara leur envoie, comment, et sur quelle base contractuelle et légale.

### Étape III — Décomposition de l'application et des flux
- Les clients européens créent un compte de fidélité depuis l'application ; leurs données (identité, historique d'achat, géolocalisation) alimentent le moteur de recommandations.
- Le module de réservation transfrontalier fait circuler des données entre l'Europe et l'Asie, notamment vers les systèmes basés à Singapour.
- Des données clients sont partagées avec les partenaires marketing.
- Deux régimes s'appliquent : la PDPA pour les données des clients asiatiques et les traitements à Singapour, le RGPD pour les données des clients européens, y compris lorsqu'elles sont traitées à Singapour.
- Point de friction : un transfert de données européennes vers Singapour est un transfert hors de l'UE ; il exige un mécanisme légal (par exemple des clauses contractuelles types) et une évaluation du transfert. La PDPA impose de son côté ses propres règles pour les données qui quittent Singapour.

### Étape IV — Analyse des menaces
- Prise de contrôle de comptes de fidélité (réutilisation de mots de passe volés, attaques automatisées), comme dans le précédent du concurrent.
- Vol de données de paiement par du code malveillant injecté dans l'application ou le parcours de paiement (« skimming »), activité citée dans le briefing de renseignement pour l'Asie et l'Europe.
- Revente ou exploitation des points et des données de fidélité.
- Fuite de données via un partenaire marketing qui reçoit plus de données que nécessaire.
- Menace réglementaire : sanction ou interdiction de traitement par une autorité européenne si les transferts ou le profilage ne sont pas conformes.

### Étape V — Analyse des vulnérabilités
- Protection insuffisante des comptes de fidélité (pas d'authentification renforcée, pas de détection d'attaques automatisées).
- Transferts de données UE → Singapour sans mécanisme de transfert documenté.
- Géolocalisation et recommandations IA constituant du profilage à grande échelle, sans analyse d'impact (AIPD) ni consentement clair au sens du RGPD.
- Partage de données avec les partenaires marketing sans minimisation ni contrats de traitement adaptés au RGPD.
- Intégrité du parcours de paiement dans l'application non contrôlée.

### Étape VI — Modélisation des attaques
- Scénario 1 : un attaquant teste des millions d'identifiants volés sur l'application, prend le contrôle de comptes européens, vole les points et les données personnelles ; la fuite est rendue publique quelques semaines avant l'IPO, exactement comme pour le concurrent.
- Scénario 2 : du code malveillant est injecté dans le parcours de paiement de l'application et capture les données de carte des nouveaux clients européens.
- Scénario 3 : une autorité de protection des données européenne enquête sur les transferts vers Singapour et le profilage ; elle peut sanctionner et ordonner l'arrêt des traitements, bloquant le programme de fidélité en Europe.

### Étape VII — Risque et impact business
- Scénario 1 (prise de contrôle des comptes) : probabilité élevée, impact critique. Atteinte directe à la crédibilité du lancement et à l'IPO ; notifications obligatoires dans les deux régimes (72 heures pour le RGPD, 3 jours pour la PDPA).
- Scénario 3 (non-conformité des transferts et du profilage) : probabilité élevée si rien n'est fait, impact critique. Sanction pouvant atteindre 4 % du chiffre d'affaires mondial au titre du RGPD, et arrêt possible des traitements en Europe.
- Scénario 2 (skimming du paiement) : probabilité moyenne, impact élevé. Pertes financières, atteinte à la confiance des clients.
- Partage avec les partenaires marketing : probabilité moyenne, impact élevé. Sundara reste responsable des données qu'il transmet.

## Identified Findings
1. **Transferts de données UE → Singapour non encadrés — critique, bloquant pour le lancement.** Sans mécanisme légal de transfert, chaque client européen inscrit crée une non-conformité au RGPD dès le premier jour ; c'est le risque le plus directement lié à la décision du conseil.
2. **Comptes de fidélité vulnérables à la prise de contrôle — critique.** C'est le scénario exact du concurrent ; 12 millions de comptes en font une cible de grande valeur, et un incident avant l'IPO aurait un impact maximal.
3. **Profilage (géolocalisation + IA) sans analyse d'impact ni consentement conforme — haute.** Obligation RGPD avant de traiter les données des clients européens ; corrigeable avant le lancement.
4. **Partage de données avec les partenaires marketing — haute.** Sundara reste responsable des données transmises ; il faut limiter les données partagées et encadrer les contrats.
5. **Intégrité du parcours de paiement — moyenne.** Menace active dans le secteur, mais réductible par des contrôles techniques sans retarder le lancement.
