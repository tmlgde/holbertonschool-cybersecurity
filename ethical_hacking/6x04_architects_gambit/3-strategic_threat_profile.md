# Strategic Threat Profile, Nordstrøm Power Group

## Framework choice and rationale
J'utilise deux méthodes ensemble. **MITRE ATT&CK** (et sa version pour les systèmes industriels, **ATT&CK for ICS**) sert à dire précisément, pour chaque filiale, quel attaquant pourrait viser quel équipement avec quelle technique. **PASTA** sert à garder une vue d'ensemble du groupe centrée sur le risque métier : approvisionnement en énergie, marché, réputation. Autrement dit : MITRE pour le détail de chaque filiale, PASTA pour la photo globale. Ce choix colle au contexte : cinq filiales industrielles, cinq pays, et un rapport destiné à un conseil d'administration qui raisonne en risque business.

## Group-level profile
Nordstrøm est un groupe énergétique scandinave et européen. C'est donc une cible intéressante pour des attaquants liés à des États : depuis 2022, l'énergie est une arme politique, et les installations de la mer du Nord (gaz, éolien en mer) sont particulièrement surveillées. Trois grands risques au niveau du groupe :

- **Le mélange bureautique / industriel.** Une attaque commence souvent sur les ordinateurs de bureau, puis se déplace vers les machines industrielles qui produisent l'énergie.
- **Les outils partagés.** Si les filiales partagent un seul annuaire, un seul VPN ou une seule gestion des accès, il suffit de casser ce maillon commun pour toucher tout le groupe (technique Trusted Relationship, T1199).
- **La croissance par rachat.** L'intégration en cours de la filiale allemande ajoute des équipements mal connus, donc plus de portes d'entrée possibles.

Il faut aussi retenir que les règles ne sont pas les mêmes partout : quatre filiales sont dans l'UE, chacune avec sa propre loi NIS2, et la Norvège n'est pas dans l'UE (elle est dans l'EEE), donc elle applique NIS2 autrement, avec en plus sa loi de sécurité nationale.

## Subsidiary sub-profiles

### Norway (offshore gas)
| Threat actor | Asset exposure | Technique relevance | Severity | Regulatory dimension |
| --- | --- | --- | --- | --- |
| Un groupe lié à l'État russe (type Sandworm), qui voit le gaz de la mer du Nord comme un moyen de pression | Plateformes de gaz en mer sans personnel, accès à distance par satellite et VPN, systèmes qui pilotent la production | **Remote Services (T0886)** : ces plateformes sont pilotées à distance, et c'est difficile à surveiller. Avec des identifiants volés, un attaquant atteint les commandes et peut couper le contrôle de la plateforme (T0827). C'est le vrai point faible ici, car l'accès à distance **est** la porte d'entrée principale d'une plateforme sans personnel. | Critique (danger physique + énergie du pays) | Entité essentielle (énergie). **La Norvège n'est pas dans l'UE mais dans l'EEE** : elle applique NIS2 autrement, avec sa propre loi de sécurité nationale. |

### Sweden (hydro and wind)
| Threat actor | Asset exposure | Technique relevance | Severity | Regulatory dimension |
| --- | --- | --- | --- | --- |
| Sandworm, un groupe qui a déjà coupé des réseaux électriques (attaques Industroyer) | Commande des barrages, pilotage des parcs éoliens, raccordement au réseau électrique | **Unauthorized Command Message (T0855)** : lors de ses attaques, ce groupe a envoyé de fausses commandes aux postes électriques. Le même genre d'attaque menace les postes suédois, car l'hydro et le réseau utilisent exactement le type d'équipement qu'il a déjà su frapper. | Critique | Entité essentielle (électricité), loi NIS2 suédoise ; la sûreté des barrages suit en plus une réglementation suédoise à part. |

### Denmark (offshore wind and trading)
| Threat actor | Asset exposure | Technique relevance | Severity | Regulatory dimension |
| --- | --- | --- | --- | --- |
| Un attaquant qui cherche de l'argent (groupe rançongiciel) sur la plateforme de trading ; un attaquant lié à un État sur l'éolien | **Plateforme de trading d'énergie accessible sur internet** (positions de marché, argent), pilotage de l'éolien en mer | **Exploit Public-Facing Application (T1190)** : un attaquant motivé par l'argent vise le site de trading exposé sur internet pour fausser des transactions ou voler des données et des fonds. C'est pertinent car le Danemark est la **seule filiale** avec un vrai site web de marché, que les filiales 100 % industrielles n'ont pas. | Élevée (impact financier et marché) | Loi NIS2 danoise ; le trading touche en plus les règles des marchés de l'énergie (REMIT). |

### Netherlands (gas and hydrogen infrastructure)
| Threat actor | Asset exposure | Technique relevance | Severity | Regulatory dimension |
| --- | --- | --- | --- | --- |
| Un attaquant lié à un État visant les gazoducs ; de l'espionnage sur la technologie de l'hydrogène | Commande des gazoducs, systèmes des installations d'hydrogène (récents et peu solides), postes d'ingénieurs qui relient bureautique et industriel | **Spearphishing Attachment (T0865)** pour piéger un poste d'ingénieur, puis **Modify Controller Tasking (T0821)** pour changer le fonctionnement des automates du gazoduc. C'est pertinent car l'hydrogène est une installation neuve, mal sécurisée, et les postes d'ingénieurs servent de pont entre les deux mondes. | Élevée à critique | Loi NIS2 néerlandaise ; l'hydrogène est une installation nouvelle, peut-être pas encore bien classée — à clarifier au cadrage. |

### Germany (integration)
| Threat actor | Asset exposure | Technique relevance | Severity | Regulatory dimension |
| --- | --- | --- | --- | --- |
| Un groupe rançongiciel ou un vendeur d'accès qui profite de l'intégration pas finie ; risque réel d'une attaque déjà présente avant le rachat et pas encore repérée | Surveillance des fermes solaires juste raccordées, **le pont qui relie le réseau racheté au reste du groupe**, équipements anciens mal recensés | **Trusted Relationship (T1199) / Valid Accounts (T1078)** : pendant l'intégration, le réseau allemand qu'on vient de brancher devient un chemin de confiance vers le groupe. Un attaquant déjà installé dans l'entreprise rachetée peut passer dans Nordstrøm. C'est pertinent car une intégration pas finie = séparation faible entre réseaux, matériel mal connu, et attaque possible datant d'avant le rachat. | Élevée (et beaucoup d'incertitude) | Loi NIS2 allemande ; l'audit déjà fait par un autre cabinet pose la question de la fiabilité de ses preuves et d'un éventuel conflit d'intérêts. |
