# Risk Prioritization Matrix

Cette matrice reprend directement les constats conservés après le triage (tâche 4) et les chaînes identifiées (tâche 5). F-07 a été retirée (fonctionnalité autorisée) et n'y figure pas. F-03 et F-09 ont été fusionnées en F-03/09. Les scores indiqués sont les scores environnementaux recalibrés (tâche 3).

| Item | Priority | Owner | Timeline | Cost | Dependencies |
| --- | --- | --- | --- | --- | --- |
| Chaîne 1 — fuite massive de résultats (F-03/09 → F-10 → F-01) | P1 | Identity and Access Management Lead | Immédiat | Élevé | Se résout par la correction de ses maillons : F-03/09, F-10 et F-01 |
| F-03/09 — 9.3 Critical (fusion de F-03 et F-09) | P1 | Identity and Access Management Lead | Immédiat | Élevé | Aucune ; maillon de la Chaîne 1 |
| F-01 — 8.8 High | P1 | Head of Platform Engineering | Immédiat | Moyen | Aucune ; maillon de la Chaîne 1 |
| F-10 — 8.5 High | P1 | Data Platform Lead | Immédiat | Moyen | Aucune ; maillon de la Chaîne 1 |
| F-05 — 8.1 High | P2 | Integration Engineering Lead | Trimestriel | Moyen | Aucune |
| F-06 — 7.1 High | P2 | Data Platform Lead | Trimestriel | Faible | Durée de rétention à fixer par le Data Protection Officer avant mise en œuvre ; maillon de la Chaîne 2 |
| Chaîne 2 — fuite via le support (F-08 → F-02 → F-06) | P2 | Support Operations Manager | Trimestriel | Moyen | Se résout par la correction de ses maillons : F-08, F-02 et F-06 |
| F-02 — 6.1 Medium | P2 | Support Operations Manager | Trimestriel | Moyen | Aucune ; maillon de la Chaîne 2 |
| F-04 — 5.4 Medium | P3 | Site Reliability Engineering Lead | Trimestriel | Faible | Aucune ; renfort de défense en profondeur |
| F-08 — 5.3 Medium | P3 | Identity and Access Management Lead | Backlog | Faible | Aucune ; maillon de la Chaîne 2 |
