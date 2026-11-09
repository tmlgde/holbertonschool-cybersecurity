# Cas 3 : The Overreach — Analyse post-incident

## 1. Ce qui s'est passé
Le PDG d'InnovateTech a demandé une « red team assessment » après avoir lu un
article, alors qu'il voulait en réalité un test de son site web et du phishing.
Le commercial d'Apex n'a pas clarifié ses attentes, et le contrat a repris le
terme « red team » sans en définir le périmètre. Apex l'a interprété au sens
professionnel : simulation complète d'adversaire, y compris intrusion physique.
Un consultant déguisé en livreur est entré par tailgating jusqu'à la salle
serveurs, a été intercepté et la police a été appelée. La mission a été
résiliée, l'incident a fait la presse locale et deux clients potentiels
d'Apex se sont retirés.

## 2. Lois, règles ou normes enfreintes
- **Intrusion physique** : entrer dans des locaux privés sans autorisation
  écrite et explicite peut constituer une infraction pénale (intrusion,
  trespass), indépendamment de toute question informatique.
- **PTES, phase de pré-engagement** : les objectifs, le périmètre et les
  techniques autorisées n'ont pas été définis avec le client.
- **Confusion sur le type de mission** : le client avait besoin d'un pentest
  (web + phishing), pas d'une red team complète.
- **Normes professionnelles (ex. : code de conduite CREST)** : agir sans
  consentement éclairé du client.

## 3. Comportement professionnel attendu
- Le commercial : demander au client ce qu'il veut réellement tester, lui
  expliquer les différences entre pentest, red team et vulnerability
  assessment, puis rédiger le contrat sur ces besoins réels.
- Le consultant : refuser tout test physique sans addendum signé listant les
  lieux autorisés, et sans lettre d'autorisation sur lui.

## 4. Clauses de pré-engagement qui auraient évité l'incident
- **Clause de définition de la mission** : « Le type de mission et chaque
  technique incluse (réseau, web, social engineering, intrusion physique) sont
  listés explicitement. Toute technique non listée est interdite. »
- **Addendum de sécurité physique** : « Les tests physiques ne sont autorisés
  qu'avec un addendum signé précisant les adresses, zones, horaires et
  techniques autorisés. »
- **Lettre d'autorisation** : « Chaque consultant réalisant un test physique
  porte une lettre d'autorisation signée, avec un contact client joignable
  24 h/24 pour la confirmer auprès des forces de l'ordre. »
- **Clause de notification** : « Un responsable désigné chez le client est
  informé des dates des tests physiques. »
