# Vanguard Security: Threat Modeling Engagement Report
## Client: Meridian Federal Bank

**Prepared by:** [Ton nom], Junior Consultant
**Date:** [Date]
**Distribution:** Meridian internal architecture team

## 1. Executive Summary

La migration du mainframe vers l'architecture hybride AWS / sur site crée, pendant les six semaines de double fonctionnement, des risques qui n'existent ni dans l'ancienne ni dans la nouvelle architecture. Notre analyse STRIDE de sept éléments de la transition fait ressortir quatre priorités : le flux de synchronisation entre le mainframe et AWS, les comptes et rôles temporaires de migration, la piste d'audit répartie entre deux environnements, et les données clients copiées pour la migration. Nous recommandons de traiter les deux premiers points avant le début du double fonctionnement, et les deux suivants avant l'arrêt du mainframe.

## 2. Engagement Context

Meridian Federal Bank, banque régionale américaine soumise à SOX, GLBA et à la supervision de l'OCC, est à mi-parcours d'une migration de son mainframe vers une architecture hybride AWS / sur site. Pendant six semaines, les deux systèmes fonctionneront en parallèle avant l'arrêt définitif du mainframe. Vanguard Security doit identifier les risques propres à cet état de transition.

## 3. Framework Choice and Rationale

**Framework retenu : STRIDE.**

Le schéma de migration montre deux environnements reliés par des flux de synchronisation temporaires, qui créent de nouvelles frontières de confiance pendant le double fonctionnement. La question est donc architecturale, et STRIDE y répond élément par élément. Les Rules of Engagement limitent le périmètre aux composants de la migration, et le public, l'équipe d'architecture, attend des résultats traduisibles en décisions d'ingénierie.

Ce choix contraste avec les deux autres missions : Sundara pose une question stratégique au conseil d'administration (PASTA), et Helix doit prouver sa résistance à des attaquants identifiés (MITRE ATT&CK). Le briefing de renseignement sur les menaces du secteur financier américain a servi uniquement à classer les priorités.

## 4. Threat Model

Sept éléments de l'architecture de transition ont été analysés avec les six catégories STRIDE. Tous présentent des menaces dans chaque catégorie ; la menace principale de chacun est la suivante :

- **Mainframe historique :** comptes de migration privilégiés jamais retirés.
- **Flux de synchronisation mainframe ↔ AWS :** deux versions des données qui divergent sans alerte.
- **Lien réseau site ↔ AWS :** routes trop larges entre les agences et l'administration AWS.
- **Applications et bases de données AWS :** rôles d'application trop permissifs.
- **Stockage S3 de migration :** copies complètes des données clients trop accessibles.
- **Identités et accès (IAM) :** rôles « temporaires » d'administrateur sans date d'expiration.
- **Journalisation :** piste d'audit coupée entre le mainframe et AWS.

Deux catégories reviennent sur presque tous les éléments et caractérisent la transition : l'élévation de privilèges (droits élargis « le temps de la migration ») et la répudiation (journaux répartis ou menacés de perte). Le détail complet figure dans le modèle de menaces associé.

## 5. Recommendations and Prioritization

1. **Sécuriser le flux de synchronisation (avant le double fonctionnement).** Authentification mutuelle (TLS mutuel) entre le mainframe et AWS, chiffrement des fichiers intermédiaires, rapprochement automatique quotidien des deux sources avec alerte en cas d'écart, et compte de synchronisation limité aux tables nécessaires.
2. **Encadrer les accès temporaires (avant le double fonctionnement).** Inventaire de tous les comptes, rôles et clés de migration, date d'expiration alignée sur la fin du double fonctionnement, identifiants temporaires à la place des clés statiques, authentification multifacteur sur les accès d'administration.
3. **Assurer une piste d'audit continue (pendant le double fonctionnement).** Centralisation des journaux du mainframe et d'AWS dans un stockage en écriture unique, test de reconstitution d'une transaction de bout en bout, archivage des journaux du mainframe avant son arrêt.
4. **Purger les données de transit (avant l'arrêt du mainframe).** Blocage de l'accès public S3, chiffrement des buckets et snapshots, suppression vérifiée des extractions une fois l'import validé.

## 6. Limitations and Uncertainty

- **Filiale luxembourgeoise :** exclue du périmètre par les Rules of Engagement, elle n'a pas été modélisée. Elle relève du droit luxembourgeois, du RGPD et de la supervision financière européenne ; ses flux avec l'architecture migrée nécessitent une analyse séparée.
- **Réglementation :** SOX et GLBA ont servi à prioriser les risques ; ce travail n'est pas un audit de conformité.
- **Photo à un instant donné :** les risques évolueront pendant les six semaines ; nous recommandons de revoir le modèle à mi-parcours.
- **Analyse documentaire :** aucun test technique n'a été réalisé ; les menaces doivent être confirmées par une revue de configuration.

## 7. Appendix: Sourced Findings

Aucune découverte cachée n'a été documentée lors de l'exploration de l'espace de travail.
