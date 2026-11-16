# Findings Triage and Consolidation

## Retired Findings

### Retired finding F-07

Après vérification du dossier client, cette capacité d'export massif n'est pas une faille, mais une fonction prévue et encadrée. Son usage en production exige un ticket approuvé par le DPO, une authentification forte par clé (WebAuthn), une double validation par le responsable des opérations de support et un délégué du DPO, un chiffrement avec une clé propre à chaque cas, une expiration courte et des journaux non modifiables. Le compte de test utilisé pendant l'audit avait été autorisé à l'avance pour vérifier ce contrôle, ce qui explique pourquoi la fonction a répondu. Le comportement observé correspond donc à la fonction voulue, et non à un défaut. La faille est retirée du rapport principal. Recommandation : confirmer par un contrôle ponctuel que chaque chemin de production applique bien ces validations, et conserver cette trace pour l'audit HDS.

## Merged Findings

### Merger F-03 and F-09 as F-03/09

Ces deux constats décrivent deux symptômes d'un même problème de fond : la gestion des droits d'accès ne retire pas assez vite, ni assez précisément, les autorisations qui ne devraient plus être valables. Dans F-03, un jeton de connexion pour un hôpital reste valable 180 jours et garde des droits trop larges, qui fonctionnent sur d'autres hôpitaux que le sien. Dans F-09, un compte rétrogradé en lecture seule garde ses droits d'écriture pendant environ 27 minutes, le temps que le système mette à jour ses autorisations. Dans les deux cas, la cause commune est la même : les droits ne sont pas liés à une vérification fiable et à jour, et il n'existe pas de retrait immédiat et centralisé. Les réunir en un seul constat de cause racine évite de proposer deux fois le même correctif et pointe le vrai chantier : une gestion des droits qui se révoque tout de suite et qui limite chaque accès à son strict périmètre. Les deux manifestations (jeton trop large et longue durée ; session privilégiée qui survit à la rétrogradation) restent décrites pour rester traçables.

## Consolidated Retained List

| Finding | Final severity | Carried to Task 6 |
| --- | --- | --- |
| F-01 | 8.8 (High) | Oui |
| F-02 | 6.1 (Medium) | Oui |
| F-03/09 | 9.3 (Critical) | Oui |
| F-04 | 5.4 (Medium) | Oui |
| F-05 | 8.1 (High) | Oui |
| F-06 | 7.1 (High) | Oui |
| F-08 | 5.3 (Medium) | Oui |
| F-10 | 8.5 (High) | Oui |
| F-07 | Retirée | Non (annexe des retirées) |
