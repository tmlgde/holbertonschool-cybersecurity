# Phase 1 Action Log, Nordstrøm engagement

| Timestamp (UTC) | Phase | Action | Target | Observed result |
| --------------- | ----- | ------ | ------ | --------------- |
| 2026-04-21T09:02:11Z | Recon | Reconnaissance externe de la surface publique | npg-lab.example (apex + sous-domaines publics) | Apex public et jeu de sous-domaines identifiés ; la porte d'entrée corporate www répond HTTP 200, aucune authentification tentée. |
| 2026-04-21T09:20:45Z | Identification | Repérage d'une API lors de la reconnaissance | api.solar-de.npg-lab.example (API filiale allemande) | Étiquette d'API de la filiale allemande découverte ; hors périmètre phase 1, reportée volontairement en phase 2. |
| 2026-04-21T09:31:18Z | Identification | Identification de la surface d'attaque | supplier-portal.npg-lab.example | Application périphérique d'enrôlement fournisseurs identifiée (HTTP 200, en-tête de maintenance activé). |
| 2026-04-21T09:47:33Z | Foothold | Point d'entrée contrôlé en lecture seule | supplier-portal.npg-lab.example | Preuve d'un point d'entrée contrôlé, en lecture seule, sur le workflow fournisseur. Marqueur de preuve : flag{npg_phase1_supplier_portal_foothold} |
| 2026-04-21T09:52:06Z | Recon | Consolidation de la cartographie de surface | Nordstrom lab public surface | Cartographie de la surface publique consolidée. Marqueur de preuve : flag{npg_phase1_public_surface_mapped} |
