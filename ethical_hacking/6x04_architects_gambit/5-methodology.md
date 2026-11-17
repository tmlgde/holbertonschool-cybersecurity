# Methodology, Nordstrøm Power Group

## PTES phases: full / abbreviated / extended

**Étendues (on fait plus que d'habitude) :**
- **Phase 1 – Pré-engagement : étendue.** Cinq filiales, cinq pays, cinq versions de NIS2 (plus la Norvège hors UE) : le cadrage, le contrat et les règles d'engagement demandent beaucoup plus de travail que pour un client d'un seul pays.
- **Phase 3 – Modèle de menace : étendue.** On ne fait pas un seul modèle « énergie » : on en fait un différent par filiale (gaz, barrages, trading, hydrogène, solaire), car chaque secteur attire des attaquants différents.
- **Phase 7 – Reporting : étendue.** Le rapport sert d'appui au plan à trois ans qu'Elin présente à son conseil dans 90 jours : il doit viser plusieurs publics et être de niveau « board », pas un simple rapport technique.

**Complètes (déployées normalement) :**
- **Phase 2 – Collecte d'informations : complète.** Le groupe a des services communs et une grande surface visible sur internet : il faut tout cartographier sérieusement.
- **Phase 4 – Analyse des vulnérabilités : complète.** C'est le cœur de l'engagement, mené sur le périmètre de test.

**Raccourcies (volontairement limitées) :**
- **Phase 5 – Exploitation : raccourcie et contrôlée.** On exploite uniquement sur un périmètre de test, jamais sur les systèmes industriels en production, et sans action destructrice. Raison : couper une turbine ou un gazoduc mettrait en jeu la sécurité physique et l'approvisionnement national.
- **Phase 6 – Post-exploitation : raccourcie.** On montre l'impact possible, mais on ne s'installe pas durablement et on ne pivote pas en production. Même raison de sécurité.

## Complementary frameworks and where they apply

- **OWASP (guide de test web) → Danemark.** Utilisé seulement sur la plateforme de trading, la seule vraie surface web et API du groupe.
- **MITRE ATT&CK (version entreprise) → la partie IT de toutes les filiales.** Sert à décrire les attaques côté bureautique et les chemins qui mènent des PC vers les systèmes industriels, surtout via les services communs du groupe.
- **ATT&CK for ICS → la partie OT.** Utilisé pour le gaz norvégien, les barrages suédois et les gazoducs/hydrogène néerlandais, car il décrit précisément les attaques sur les machines industrielles.
- **NIST 800-53 → là où la conformité compte.** On relie les failles trouvées à des contrôles de sécurité reconnus, pour que le rapport parle le langage de la conformité et aide Elin à bâtir sa feuille de route devant le board.

## Per-adaptation justification (tied to a Nordstrøm specific)

- **Pré-engagement étendu** ← cinq transpositions NIS2 différentes + la Norvège dans l'EEE (hors UE) : le droit applicable et les règles d'engagement changent d'un pays à l'autre.
- **Modèle de menace étendu** ← chaque filiale a un secteur et un attaquant propres (ex. Sandworm sur le réseau suédois, acteur financier sur le trading danois) : un modèle unique raterait ces différences.
- **Reporting étendu** ← la deadline board à 90 jours et le plan à trois ans d'Elin : le rapport doit être directement utilisable par un conseil d'administration.
- **Exploitation raccourcie** ← le gaz offshore et les barrages touchent la sécurité physique et l'énergie du pays : on ne prend aucun risque sur la production.
- **Post-exploitation raccourcie** ← même criticité OT : prouver l'impact suffit, inutile d'aller plus loin.
- **OWASP ciblé sur le Danemark** ← c'est la seule filiale avec un site de marché exposé sur internet.
- **Allemagne non testée pour l'instant** ← intégration pas finie : la méthode prévoit une validation indépendante plus tard, pas une confiance dans l'audit du cabinet concurrent.
