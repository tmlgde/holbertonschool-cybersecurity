# Phase 2 Action Log (append-only)

| Timestamp (UTC) | Phase | Action | Target | Observed result |
| --------------- | ----- | ------ | ------ | --------------- |
| 2026-04-21T10:12:09Z | Identification | suspected: passerelle de test héritée suggérée par la bannière | api.solar-de.npg-lab.example | Bannière évoquant une passerelle de staging héritée ; identification seulement, aucune preuve. |
| 2026-04-21T10:28:44Z | Exploitation | confirmed: lecture d'un jeu de données d'intégration | api.solar-de.npg-lab.example | Lecture seule confirmée d'un jeu de données d'intégration synthétique. Marqueur de preuve : flag{npg_phase2_german_api_exposure} |
| 2026-04-21T10:43:20Z | Exploitation | confirmed: potentiel de pivot OT validé | telemetry-gw-solar-de.npg-lab.example | Potentiel de pivot vers l'OT validé au niveau métadonnées et routage ; aucune commande industrielle exécutée. Marqueur de preuve : flag{npg_phase2_ot_pivot_potential_validated} |
| 2026-04-21T10:56:31Z | Reporting prep | impact documenté | German solar integration scope | Impact sur l'intégration de l'acquisition et la gouvernance NIS2 documenté. |
| 2026-04-21T11:03:58Z | Cleanup | artefact removed | Nordstrom lab evidence workspace | Artefacts temporaires supprimés, jeton synthétique révoqué, session en lecture seule fermée, restauration vérifiée. Marqueur de preuve : flag{npg_phase2_cleanup_verified} |
