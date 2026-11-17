# Engagement Report, Nordstrøm Power Group
For: Elin Solberg (CISO) and the Nordstrøm board

**Distribution:** Elin Solberg (CISO) and the Nordstrøm board
**Classification:** Confidential
**Prepared by:** Vanguard Security

## 1. Executive summary (no jargon)

Ce premier engagement était un bilan de santé ciblé, destiné à nourrir le plan de sécurité à trois ans. Il n'a volontairement couvert qu'une partie du groupe, choisie pour sa valeur : ce qui est visible depuis l'extérieur, et la filiale solaire allemande récemment rachetée.

Le message principal pour le conseil est simple. La zone la plus fragile aujourd'hui n'est pas la production d'énergie elle-même, mais le rattachement de l'acquisition allemande au reste du groupe. Pendant le test, nous avons pu lire des données d'intégration qui n'auraient pas dû être accessibles, et nous avons constaté qu'un chemin existe depuis cette zone vers les systèmes industriels. Ce chemin n'a pas été utilisé pour agir sur des équipements : nous avons prouvé qu'il existe, sans jamais toucher à la production.

Deux autres points méritent l'attention du conseil : une porte d'entrée sur le portail d'enrôlement des fournisseurs (un risque de gouvernance des tiers), et le fait que plusieurs zones critiques (gaz norvégien, réseau suédois) n'ont pas encore été testées et le seront dans les phases suivantes.

Rien de ce qui a été trouvé ne met en danger immédiat l'approvisionnement en énergie. Mais ces constats sont des signaux à traiter dans le plan : prioriser l'intégration allemande, renforcer la gouvernance des fournisseurs, et financer un examen approfondi des systèmes industriels. Le risque est maîtrisable si ces actions sont engagées.

## 2. Context and methodology

L'engagement a exécuté les deux premières phases d'un pentest sur un périmètre de test contrôlé, à partir de preuves hors-ligne plutôt qu'un lab en direct. Ce point est assumé : nous ne revendiquons pas une couverture technique complète en conditions réelles (voir section 8). La méthode de base est PTES, adaptée au contexte de Nordstrøm :

- **Phase 1 limitée aux surfaces publiques et périphériques**, pour ne pas toucher aux flux les plus sensibles avant d'avoir des preuves justifiant l'escalade.
- **Portail fournisseur retenu comme point d'entrée contrôlé** : pertinent commercialement mais borné.
- **API d'intégration allemande retenue pour la phase 2**, car l'acquisition récente est stratégiquement importante.
- **Identification séparée de l'exploitation confirmée**, pour que le conseil distingue un soupçon d'une preuve.
- **Nettoyage tracé et vérifié**, pour démontrer une exécution réversible et contrôlée.

Cadres complémentaires : MITRE ATT&CK (bureautique), ATT&CK for ICS (frontière vers l'industriel), lecture NIS2 pays par pays.

## 3. Threat profile synthesis (post-execution)

Avant l'engagement, notre profil désignait deux zones à risque prioritaires : les services communs du groupe et la filiale allemande en cours d'intégration. L'exécution a confirmé les deux : le portail fournisseur (groupe) a donné un point d'entrée, et l'API allemande a permis une exposition de données et révélé un potentiel de pivot vers l'OT. À court terme, le risque vivant est donc la frontière de l'acquisition allemande, plus faible parce que l'intégration n'est pas finie.

Lecture par filiale, à porter dans le plan :
- **Norvège (gaz offshore)** : dépendance opérationnelle critique, OT à manier avec prudence ; ne pas diluer dans une conformité UE générique — traiter l'alignement lié à l'EEE et les attentes nationales explicitement.
- **Suède (hydro et éolien)** : la disponibilité et la résilience de la production renouvelable sont des priorités stratégiques ; cadrer via l'implémentation nationale et la continuité du secteur énergie.
- **Danemark (éolien et trading)** : l'intégrité des interfaces de trading et des données de marché pèse sur les décisions opérationnelles et financières ; inclure la résilience côté marché.
- **Pays-Bas (gaz et hydrogène)** : la continuité des infrastructures transfrontalières compte ; traiter l'intégration d'infrastructure comme un risque stratégique.
- **Allemagne (solaire, en intégration)** : intégration en cours, meilleur candidat pour la phase 4 ; les preuves de la phase 2 justifient une revue d'intégration dédiée.

## 4. Scope delivered and deferred

**Livré :**
- Phase 1 : reconnaissance externe, cartographie de la surface publique, point d'entrée contrôlé sur le portail fournisseur.
- Phase 2 : escalade ciblée sur l'API d'intégration allemande, exposition de données confirmée, validation du potentiel de pivot OT (au niveau métadonnées/routage), puis nettoyage vérifié.

**Reporté :**
- Test authentifié du **portail investisseurs** (D-01, suivi comme scope reporté).
- **Cœur industriel** de la Norvège (gaz) et de la Suède (barrages, réseau) → phase 3.
- **Revue complète de la filiale allemande** une fois l'intégration stable → phase 4.
- Test approfondi du **trading danois** et de l'**hydrogène néerlandais** → phases ultérieures.

## 5. Findings by subsidiary and IT/OT (environmental CVSS, prioritised)

Les scores CVSS ci-dessous sont ajustés au contexte (score environnemental) à partir des preuves disponibles ; ils seront réévalués après les phases 3 et 4.

| ID | Faille | Filiale | IT / OT | CVSS environnemental | Priorité | Statut |
| --- | --- | --- | --- | --- | --- | --- |
| **F-02** | Exposition de données via l'API d'intégration allemande | Allemagne (solaire) | IT, avec pertinence OT-adjacente | **7,7 (Élevé)** | Haute | Confirmée |
| **F-03** | Potentiel de pivot vers l'OT via les métadonnées de la passerelle télémétrie | Allemagne (solaire) | Frontière IT→OT | **8,2 (Élevé), jusqu'à 9,1 (Critique)** selon la séparation réseau réelle | Haute | Confirmée |
| **F-01** | Point d'entrée sur le portail d'enrôlement des fournisseurs | Groupe (fournisseurs) | IT | **5,4 (Moyen)** | Moyenne | Confirmée |
| **D-01** | Test authentifié du portail investisseurs | Groupe (relations investisseurs) | IT | Non scorée (scope reporté) | Reportée | Reportée |

Lecture : les deux failles les plus importantes sont allemandes et liées à l'intégration de l'acquisition. F-03 est donnée en fourchette car sa gravité réelle dépend de la solidité de la séparation entre bureautique et industriel, à confirmer en phase 3.

## 6. Strategic-plan recommendations (country-specific NIS2)

| ID | Recommandation | Pertinence pour le plan à 3 ans | Lien preuve | Note pays |
| --- | --- | --- | --- | --- |
| **R-01** | Contrôles d'intégration de l'acquisition | Mettre l'intégration allemande en tête du plan | F-02, F-03 | Allemagne |
| **R-02** | Gouvernance du portail fournisseurs | Renforcer l'assurance de l'enrôlement fournisseurs et des tiers | F-01 | Tout le groupe |
| **R-03** | Assurance de la frontière IT/OT | Créer une phase 3 d'examen OT approfondi et un suivi récurrent | F-03 | Par filiale, pas en conformité UE uniforme |
| **R-04** | Gouvernance consciente de NIS2 | Raisonner par implémentation nationale plutôt qu'en conformité générique | Toutes | Norvège, Suède, Danemark, Pays-Bas, Allemagne diffèrent |
| **R-05** | Proposition de continuation | Phase 3 OT, phase 4 Allemagne, retainer trimestriel optionnel | F-02, F-03 | Allemagne et filiales très industrielles d'abord |

Point clé pour le conseil : **ne pas traiter les cinq pays comme un bloc UE unique.** La Norvège relève de l'EEE avec des attentes nationales propres, la Suède et les Pays-Bas d'une continuité sectorielle, le Danemark ajoute la dimension marché/trading, et l'Allemagne demande une revue d'intégration dédiée.

## 7. Engagement continuation proposal

Nous recommandons de poursuivre en trois temps :

- **Phase 3 — examen OT approfondi** des filiales les plus critiques (gaz norvégien, barrages et réseau suédois). C'est là que se concentre le risque d'impact le plus grave, encore non testé.
- **Phase 4 — revue complète de la filiale allemande**, une fois l'intégration stable, en validation indépendante (sans réutiliser l'audit d'un tiers). Les preuves de la phase 2 justifient cette revue dédiée.
- **Retainer trimestriel optionnel** : un accompagnement continu pour réévaluer les scores, suivre la frontière IT/OT et maintenir la conformité NIS2 au fil des évolutions du groupe.

## 8. Limitations and uncertainty

Nous présentons honnêtement les limites de cet engagement :

- **Modèle de preuves hors-ligne** au lieu d'une exécution en direct (L-01) : nous l'indiquons clairement et ne surestimons pas la couverture technique réelle.
- **Portail investisseurs non testé en profondeur** (L-02) : listé en scope reporté (section 4).
- **Aucune commande industrielle exécutée** (L-03) : le pivot vers l'OT est présenté comme une validation au niveau métadonnées et routage seulement, pas une prise de contrôle.
- **Scores CVSS ajustés au contexte** à partir des preuves disponibles (L-04) : à réévaluer après les phases 3 et 4.

## 9. Appendices

### Appendix A — Detailed findings
- **F-01** — Point d'entrée en lecture seule sur le portail fournisseur. Source : journaux phase 1 + copie du portail. Preuve : flag{npg_phase1_supplier_portal_foothold}. Cartographie de surface associée : flag{npg_phase1_public_surface_mapped}.
- **F-02** — Lecture confirmée d'un jeu de données d'intégration synthétique via l'API allemande. Source : api_samples + journal phase 2. Preuve : flag{npg_phase2_german_api_exposure}.
- **F-03** — Potentiel de pivot OT validé au niveau métadonnées/routage, sans exécution de commande. Source : gateway_routes. Preuve : flag{npg_phase2_ot_pivot_potential_validated}.
- **Nettoyage** — Artefacts supprimés, jeton révoqué, restauration vérifiée. Preuve : flag{npg_phase2_cleanup_verified}.
- **D-01** — Portail investisseurs : test authentifié reporté (scope reporté).

### Appendix B — Threat profile detail
Rappel du profil par filiale : Norvège (gaz offshore, accès distants, menace étatique, EEE hors UE), Suède (barrages et réseau, menace type Sandworm), Danemark (trading exposé, risque financier et marché), Pays-Bas (gazoducs et hydrogène émergent), Allemagne (intégration non finie, frontière de confiance fragile). Détail complet dans le fichier de profil de menace de l'engagement.

### Appendix C — Methodology adaptations applied
- **M-01** — Phase 1 limitée aux surfaces publiques/périphériques, pour ne pas toucher aux flux critiques sans preuve justifiant l'escalade.
- **M-02** — Portail fournisseur comme point d'entrée contrôlé, preuve périphérique bornée mais pertinente.
- **M-03** — API d'intégration allemande retenue en phase 2, car l'acquisition récente est stratégique.
- **M-04** — Identification séparée de l'exploitation confirmée, pour distinguer soupçon et preuve.
- **M-05** — Nettoyage tracé et vérifié, pour prouver une exécution réversible et contrôlée.
