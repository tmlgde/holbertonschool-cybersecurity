# Environmental CVSS Recalibration

| Finding | Sarah base (severity) | Environmental (severity) | Delta | Justification |
| --- | --- | --- | --- | --- |
| F-01 | 8.1 (High) | 8.8 (High) | ↑ | Les résultats de diagnostic sont des données de santé réglementées, ce qui porte l'exigence de confidentialité et d'intégrité à « High ». L'accès inter-tenant sur une plateforme de 400 laboratoires augmente l'impact environnemental. |
| F-02 | 6.1 (Medium) | 6.1 (Medium) | = | La sensibilité santé et l'accès multi-tenant de l'analyste tirent la gravité vers le haut, mais la MFA, les postes gérés et la CSP la compensent. Les deux effets s'annulent, le score reste stable. |
| F-03 | 8.8 (High) | 9.3 (Critical) | ↑ | Le jeton large agit sur plusieurs tenants hospitaliers via la passerelle d'intégration, un actif critique traitant des données de santé. L'exigence de confidentialité et d'intégrité « High » hisse le score en zone critique. |
| F-04 | 8.2 (High) | 5.4 (Medium) | ↓ | Le trafic du worker passe par une passerelle d'egress privée qui impose un TLS mutuel et valide le certificat amont, réduisant fortement le risque réel. Il subsiste un défaut de défense en profondeur si ce contrôle tombe. |
| F-05 | 7.5 (High) | 8.1 (High) | ↑ | L'intégrité du statut d'échantillon est critique car les workflows aval de libération et d'export lui font confiance. Cette dépendance porte l'exigence d'intégrité à « High » et augmente l'impact. |
| F-06 | 6.5 (Medium) | 7.1 (High) | ↑ | La rétention d'exports de données de santé bien au-delà de la durée documentée crée une exposition RGPD et HDS directe. La responsabilité réglementaire porte l'exigence de confidentialité à « High ». |
| F-07 | 9.1 (Critical) | 3.1 (Low) | ↓ | Le contexte client établit qu'il s'agit d'un workflow d'urgence autorisé, protégé par ticket DPO, WebAuthn, double validation, clé dédiée, expiration et logs immuables. Le rôle de test avait été pré-approuvé ; le comportement observé relève de la fonctionnalité voulue. |
| F-08 | 5.3 (Medium) | 5.3 (Medium) | = | L'énumération de comptes reste de faible gravité intrinsèque et la sensibilité des identités de laboratoire est limitée. Sa valeur réelle tient à son rôle de maillon dans une chaîne, pas à un impact isolé. |
| F-09 | 7.2 (High) | 7.2 (High) | = | La persistance de privilèges après rétrogradation reste significative mais exige déjà un rôle privilégié. Le score de base tient ; la faille partage une cause racine de gouvernance des identités avec F-03. |
| F-10 | 8.0 (High) | 8.5 (High) | ↑ | Le service d'analytics est atteignable depuis le réseau applicatif et expose l'activité de diagnostic d'autres laboratoires, ce qui porte l'exigence de confidentialité à « High ». Il sert aussi d'amplificateur pour les chaînes impliquant F-03 et F-01. |
