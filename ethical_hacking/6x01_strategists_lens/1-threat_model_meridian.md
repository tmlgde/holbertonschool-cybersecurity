Framework Declaration

STRIDE

Rationale

Le schéma de migration montre que, pendant les six semaines de double fonctionnement, le mainframe et l’environnement hybride AWS / sur site tournent en parallèle, reliés par des flux de synchronisation qui créent de nouvelles frontières de confiance. La mission consiste à identifier les risques de cet état de transition : c’est une question d’architecture, que STRIDE traite élément par élément. Le public, l’équipe d’architecture interne, attend des résultats directement traduisibles en décisions d’ingénierie. Les Rules of Engagement limitent le périmètre aux composants de la migration, ce qui convient à une décomposition technique plutôt qu’à une analyse business (PASTA) ou centrée sur des attaquants nommés (ATT&CK).

Framework Selection Feedback

Force : STRIDE oblige à examiner chaque flux entre le mainframe, le site et AWS, là où la transition crée des risques propres (deux sources de vérité, comptes temporaires, journaux répartis). Limite : STRIDE ne classe pas les menaces selon les attaquants réels ; le briefing de renseignement sur le secteur financier américain sert seulement à pondérer les priorités.

Threat Model
Élément	S (usurpation)	T (altération)	R (répudiation)	I (fuite)	D (indisponibilité)	E (élévation)
Mainframe historique	Identifiants de service partagés avec les outils de migration	Écritures en parallèle d’AWS, données divergentes	Journaux réduits avant l’arrêt	Extractions de données conservées hors du mainframe	Surcharge due à la réplication	Comptes de migration privilégiés jamais retirés
Flux de synchronisation mainframe ↔ AWS	Source non authentifiée qui injecte des données	Transactions modifiées en transit	Aucun contrôle prouvant que les deux côtés sont identiques	Flux non chiffrés avec données clients	Arrêt de la synchro, deux versions des données	Compte de synchro avec écriture totale des deux côtés
Lien réseau site ↔ AWS	Usurpation d’un bout du tunnel	Routes trop larges	Pas de journaux de flux réseau	Trafic interne non chiffré	Lien unique sans secours	Accès des agences vers l’administration AWS
Applications et bases AWS	Comptes partagés entre outils et applications	Données importées non vérifiées	Journaux désactivés pour la performance	Snapshots non chiffrés	Saturation lors des imports massifs	Rôles d’application trop permissifs
Stockage S3 de migration	Clés d’accès statiques	Fichiers modifiables avant import	Accès aux fichiers non journalisés	Extractions complètes accessibles trop largement	Suppression accidentelle de lots	Droits accordés à des rôles sans lien avec la migration
Identités et accès (IAM)	Fédération mal configurée	Politiques modifiées sans revue	Comptes partagés de l’équipe de migration	Clés exposées dans des scripts	Comptes critiques verrouillés	Rôles « temporaires » d’administrateur sans expiration
Journalisation	Faux événements injectés	Journaux modifiables par les comptes surveillés	Piste d’audit coupée entre mainframe et AWS (SOX)	Données clients en clair dans les journaux	Journaux perdus à l’arrêt du mainframe	Admins système avec écriture sur les journaux
Identified Findings
Flux de synchronisation mainframe ↔ AWS — critique. Seul élément touché par les six catégories STRIDE, et propre à la transition : une erreur non détectée crée deux versions des données financières (intégrité SOX, confidentialité GLBA).
Comptes et rôles temporaires de migration — critique. L’élévation de privilèges (E) revient sur presque chaque élément : des droits larges « le temps de la migration », sans date de fin, donnent le contrôle des deux environnements.
Piste d’audit coupée — haute. La répudiation (R) est faible partout : journaux répartis et risque de perte à l’arrêt du mainframe, alors que SOX exige de pouvoir retracer chaque transaction.
Données de transit (S3, snapshots) — haute. Les extractions complètes de données clients concentrent le risque de fuite (I) et sont souvent oubliées après la migration.
