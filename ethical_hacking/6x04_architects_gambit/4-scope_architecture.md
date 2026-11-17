# Scope Architecture, Nordstrøm Power Group

## In scope / Out of scope (per subsidiary, IT and OT)

| Filiale | IT dans le périmètre | OT dans le périmètre | Hors périmètre |
| --- | --- | --- | --- |
| **Services groupe (communs)** | Annuaire central, VPN groupe, gestion des accès centrale | — | — |
| **Norway (gaz offshore)** | Accès distants aux plateformes, postes d'administration | Revue des systèmes de contrôle des plateformes (sur périmètre de test) | Exploitation réelle en production, équipements de sûreté physique |
| **Sweden (hydro + éolien)** | Postes reliés au pilotage | Revue des systèmes des barrages et du raccordement réseau (sur test) | Toute action sur les barrages en production |
| **Denmark (éolien + trading)** | **Plateforme de trading (web et API)**, authentification | Revue légère du pilotage éolien | Hébergeur tiers de la plateforme s'il n'appartient pas à Nordstrøm |
| **Netherlands (gaz + hydrogène)** | Postes d'ingénierie | Revue d'architecture des gazoducs et de l'hydrogène (pas d'exploitation) | Tests profonds sur l'hydrogène (installation trop neuve) |
| **Germany (solaire, en intégration)** | **Reporté** : le pont d'intégration sera validé une fois l'intégration stable | Idem, reporté | Réutilisation brute de l'audit du cabinet concurrent |

Exclusions valables pour tout l'engagement : pas de tests destructeurs, pas d'exploitation sur les systèmes en production, pas d'ingénierie sociale des employés sans accord écrit, pas de test sur des systèmes qui n'appartiennent pas à Nordstrøm.

## Phase 1 — Base groupe et exposition externe
- **Perimeter:** services communs du groupe (annuaire, VPN, accès centraux) + ce qui est visible depuis internet pour les 5 filiales. Pas encore d'intrusion industrielle.
- **Methodology depth:** PTES phases 1 et 2 (collecte d'informations + modèle de menace) et repérage des failles externes, sans exploitation. OWASP pour les surfaces web visibles.
- **Deliverable:** photo de l'exposition externe + carte des risques au niveau groupe.
- **Duration:** 3 semaines.
- **Consultant-days:** ~20.
- **Commercial rationale:** les services communs sont le seul chemin qui expose **tout** le groupe d'un coup : les tester une fois, en premier, donne le meilleur retour pour le prix. Le conseil d'Elin a besoin très vite d'une vue d'ensemble, et cette phase lui donne un premier résultat exploitable dès la troisième semaine, bien avant la deadline des 90 jours. On teste le socle commun **une seule fois** au lieu de le refacturer filiale par filiale.

## Phase 2 — Cœur critique : Norvège et Suède
- **Perimeter:** OT de la Norvège (accès distants, systèmes des plateformes gaz) et OT de la Suède (barrages, raccordement réseau), plus les chemins qui vont de la bureautique vers l'industriel. Sur périmètre de test, jamais en production.
- **Methodology depth:** ATT&CK for ICS, plus en profondeur : revue d'architecture + validation contrôlée sur le périmètre de test. Correspondance avec les contrôles NIST 800-53.
- **Deliverable:** évaluation des risques industriels des deux filiales les plus critiques + failles classées par priorité.
- **Duration:** 4 semaines.
- **Consultant-days:** ~35 (les spécialistes OT coûtent plus cher).
- **Commercial rationale:** ces deux filiales portent le risque le plus grave, car elles touchent l'approvisionnement national (gaz et électricité) et visent les attaquants les plus crédibles (type Sandworm). C'est là que se concentre l'essentiel du risque catastrophique, donc c'est là que le coût de spécialistes OT est justifié. La Norvège étant hors UE (EEE), on prévoit dès cette phase une gestion des données adaptée à sa loi nationale.

## Phase 3 — Marché et surfaces émergentes : Danemark et Pays-Bas
- **Perimeter:** plateforme de trading danoise (web et API, authentification, scénarios de manipulation de marché) + revue d'architecture OT des Pays-Bas (gaz et hydrogène), plus légère.
- **Methodology depth:** OWASP (guide de test web) pour le trading ; revue d'architecture ATT&CK for ICS pour les Pays-Bas, sans exploitation poussée.
- **Deliverable:** évaluation de sécurité applicative (Danemark) + note d'exposition OT (Pays-Bas).
- **Duration:** ~3 semaines (peut chevaucher la phase 2 avec une autre équipe).
- **Consultant-days:** ~22.
- **Commercial rationale:** le Danemark est la seule filiale avec un vrai site de marché exposé sur internet, avec un risque différent (financier, et soumis aux règles de marché REMIT) qui mérite son propre test. Les Pays-Bas, eux, ont une installation hydrogène trop neuve pour un test profond utile aujourd'hui : on la cadre léger maintenant et on signale qu'un test approfondi aura du sens plus tard. Dépenser moins ici, c'est garder le budget pour le risque réel.

## Phase 4 — Allemagne : validation reportée (conditionnelle)
- **Perimeter:** filiale solaire allemande, **reportée** tant que l'intégration n'est pas stable. Cadrée comme une validation indépendante du pont d'intégration, pas comme une confiance dans l'audit du concurrent.
- **Methodology depth:** revue d'architecture et de la séparation réseau une fois la connexion stable, avec un état d'esprit « recherche de compromission déjà présente ».
- **Deliverable:** validation de sécurité de l'intégration (conditionnelle).
- **Duration:** 2 semaines, planifiées après l'intégration.
- **Consultant-days:** ~15.
- **Commercial rationale:** tester une intégration pas finie, c'est viser une cible qui bouge : les failles changeraient chaque semaine et le client paierait pour un travail vite périmé. L'architecte reporte donc volontairement cette phase jusqu'à ce que l'intégration soit stable. On refait nos propres tests plutôt que de nous fier à l'audit d'un cabinet concurrent, ce qui évite aussi tout conflit d'intérêts. Ce report assumé est le vrai choix d'architecte de ce découpage.
