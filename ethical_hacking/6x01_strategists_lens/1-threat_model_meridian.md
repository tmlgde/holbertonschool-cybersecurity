Framework Declaration

STRIDE

Rationale

Le schéma de migration montre que, pendant les six semaines de double fonctionnement, le mainframe et l'environnement hybride AWS / sur site tournent en parallèle, reliés par des flux de synchronisation qui créent de nouvelles frontières de confiance. La mission consiste à identifier les risques de cet état de transition : c'est une question d'architecture, que STRIDE traite élément par élément. Le public, l'équipe d'architecture interne, attend des résultats directement traduisibles en décisions d'ingénierie. Les Rules of Engagement limitent le périmètre aux composants de la migration, ce qui convient à une décomposition technique plutôt qu'à une analyse business (PASTA) ou centrée sur des attaquants nommés (ATT&CK).

Framework Selection Feedback

Force : STRIDE oblige à examiner chaque flux entre le mainframe, le site et AWS, là où la transition crée des risques propres (deux sources de vérité, comptes temporaires, journaux répartis). Limite : STRIDE ne classe pas les menaces selon les attaquants réels ; le briefing de renseignement sur le secteur financier américain sert seulement à pondérer les priorités.

Threat Model
Mainframe historique
Spoofing : identifiants de service partagés avec les outils de migration.
Tampering : écritures en parallèle d'AWS, qui font diverger les données.
Repudiation : journaux réduits avant l'arrêt du mainframe.
Information disclosure : extractions de données conservées hors du mainframe.
Denial of service : surcharge due à la réplication.
Elevation of privilege : comptes de migration privilégiés jamais retirés.
Flux de synchronisation mainframe ↔ AWS
Spoofing : une source non authentifiée peut injecter des données.
Tampering : transactions modifiées en transit.
Repudiation : aucun contrôle ne prouve que les deux côtés sont identiques.
Information disclosure : flux non chiffrés contenant des données clients.
Denial of service : un arrêt de la synchronisation laisse deux versions des données.
Elevation of privilege : le compte de synchronisation peut écrire partout des deux côtés.
Lien réseau site ↔ AWS
Spoofing : usurpation d'un bout du tunnel.
Tampering : routes trop larges.
Repudiation : pas de journaux de flux réseau.
Information disclosure : trafic interne non chiffré.
Denial of service : lien unique, sans secours.
Elevation of privilege : accès possible des agences vers l'administration AWS.
Applications et bases de données AWS
Spoofing : comptes partagés entre les outils de migration et les applications.
Tampering : données importées sans vérification.
Repudiation : journaux désactivés pour des raisons de performance.
Information disclosure : snapshots de bases non chiffrés.
Denial of service : saturation lors des imports massifs.
Elevation of privilege : rôles d'application trop permissifs.
Stockage S3 de migration
Spoofing : accès par des clés d'accès statiques.
Tampering : fichiers modifiables avant leur import.
Repudiation : accès aux fichiers non journalisés.
Information disclosure : copies complètes des données clients accessibles trop largement.
Denial of service : suppression accidentelle de lots non importés.
Elevation of privilege : droits accordés à des rôles sans lien avec la migration.
Identités et accès (IAM)
Spoofing : fédération entre l'annuaire et AWS mal configurée.
Tampering : politiques d'accès modifiées sans revue.
Repudiation : comptes partagés au sein de l'équipe de migration.
Information disclosure : clés d'accès exposées dans des scripts.
Denial of service : comptes critiques verrouillés lors des bascules.
Elevation of privilege : rôles « temporaires » d'administrateur sans date d'expiration.
Journalisation
Spoofing : faux événements injectés dans la supervision.
Tampering : journaux modifiables par les comptes qu'ils surveillent.
Repudiation : piste d'audit coupée entre le mainframe et AWS, alors que SOX exige la traçabilité.
Information disclosure : données clients en clair dans les journaux.
Denial of service : journaux perdus à l'arrêt du mainframe.
Elevation of privilege : administrateurs système disposant d'un accès en écriture aux journaux.
Identified Findings
Flux de synchronisation mainframe ↔ AWS — critique. Seul élément touché par les six catégories STRIDE, et propre à la transition : une erreur non détectée crée deux versions des données financières (intégrité SOX, confidentialité GLBA).
Comptes et rôles temporaires de migration — critique. L'élévation de privilèges revient sur presque chaque élément : des droits larges « le temps de la migration », sans date de fin, donnent le contrôle des deux environnements.
Piste d'audit coupée — haute. La répudiation est faible partout : journaux répartis et risque de perte à l'arrêt du mainframe, alors que SOX exige de pouvoir retracer chaque transaction.
Données de transit (S3, snapshots) — haute. Les copies complètes des données clients concentrent le risque de fuite et sont souvent oubliées après la migration.
