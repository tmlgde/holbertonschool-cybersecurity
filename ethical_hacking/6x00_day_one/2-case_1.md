# Cas 1 : The Handshake Deal — Analyse post-incident

## 1. Ce qui s'est passé
NorthBay Consulting a lancé un test d'intrusion réseau sur la seule base d'une
autorisation verbale donnée par téléphone par le CTO du client, Mark Reeves.
En 48 heures, l'équipe a exploité une injection SQL dans le système de suivi
des expéditions et extrait 500 véritables enregistrements de clients. La
directrice juridique, qui ignorait l'existence du test, a reçu une alerte du
SIEM, l'a traitée comme une fuite de données et l'a signalée à l'autorité de
protection des données. Ni le PDG ni le service juridique n'avaient approuvé la
mission, et le CTO n'avait pas le pouvoir d'autoriser un accès par un tiers.
NorthBay a reçu une mise en demeure et a passé 8 mois en procédure judiciaire.

## 2. Lois, règles ou normes enfreintes
- **Lois sur l'accès non autorisé** (CFAA, Computer Misuse Act, art. 323-1 du
  Code pénal) : l'accord venait d'une personne sans autorité légale, l'accès
  était donc juridiquement non autorisé.
- **Protection des données (RGPD, minimisation des données)** : extraire 500
  enregistrements personnels dépassait largement ce qui était nécessaire pour
  prouver la faille.
- **PTES, phase de pré-engagement** : les tests ont commencé avant que le scope,
  l'autorisation et les canaux de communication soient formellement établis.
- **Normes professionnelles (ex. : code de conduite CREST)** : aucune
  autorisation écrite et vérifiable avant le début des tests.

## 3. Comportement professionnel attendu
- Refuser de commencer les tests sans une **autorisation écrite signée par un
  représentant légal** de l'entreprise (ex. : le PDG).
- S'assurer que le **service juridique et l'équipe de surveillance sécurité**
  sont informés des dates de test et des adresses IP sources.
- Prouver l'injection SQL avec un **minimum de données** : un seul
  enregistrement ou le nombre de lignes accessibles, avec les données
  personnelles masquées sur les captures d'écran.

## 4. Clauses de pré-engagement qui auraient évité l'incident
- **Clause d'autorisation** : « La mission doit être autorisée par écrit par un
  représentant légal du client. Une autorisation verbale n'est pas valable. »
- **Clause de notification** : « Le service juridique et l'équipe SOC/sécurité
  du client sont informés des dates, horaires et adresses IP sources de
  Vanguard. »
- **Clause de traitement des données** : « Les testeurs accèdent au minimum de
  données nécessaire pour démontrer l'impact (1 enregistrement maximum par
  vulnérabilité). Les données personnelles sont masquées dans toutes les preuves
  et supprimées à la fin de la mission. »
- **Clause de démarrage** : « Aucune activité de test ne commence avant
  l'obtention de toutes les signatures requises. »
