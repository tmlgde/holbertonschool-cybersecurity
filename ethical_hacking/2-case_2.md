# Cas 2 : The Scope Creep — Analyse post-incident

## 1. Ce qui s'est passé
RedLine Security a été mandaté pour un test d'intrusion web limité à
shop.clientcorp.com et à son API api.clientcorp.com. Un consultant a découvert
que l'API communiquait avec un service interne, billing-internal.clientcorp.com,
accessible à cause d'une règle de pare-feu mal configurée. Il s'y est connecté
avec les identifiants par défaut et a consulté les données de facturation de
plus de 10 000 clients, dont des numéros de carte partiels. Il a présenté cette
« découverte bonus » dans le rapport. Le système appartenait en réalité à un
prestataire tiers, FinServe : FinServe et ClientCorp ont engagé des poursuites,
le consultant a été suspendu et l'assurance du cabinet a été activée.

## 2. Lois, règles ou normes enfreintes
- **Lois sur l'accès non autorisé** (CFAA, Computer Misuse Act, art. 323-1 du
  Code pénal) : le système était hors scope et appartenait à un tiers qui
  n'avait rien autorisé.
- **PCI-DSS** : consultation de données de cartes bancaires sans autorisation.
- **Contrat / document de scope** : le périmètre était explicite et a été
  volontairement dépassé.
- **Normes professionnelles (ex. : code de conduite CREST)** : agir en dehors
  du mandat confié par le client.

## 3. Comportement professionnel attendu
- **Documenter** la découverte (chemin d'accès, règle de pare-feu, service
  exposé) sans se connecter au service.
- **S'arrêter** : ne pas tester les identifiants, ne rien consulter.
- **Prévenir immédiatement** le contact client, qui décide de la suite.
- Ne jamais déduire la propriété d'un système de son nom de domaine.

## 4. Clauses de pré-engagement qui auraient évité l'incident
- **Clause de découverte hors scope** : « Tout système hors scope découvert
  pendant les tests est documenté et signalé immédiatement au client, sans
  aucune interaction supplémentaire. »
- **Clause d'extension de scope** : « Toute extension du périmètre nécessite un
  avenant écrit signé par le client et, le cas échéant, par le propriétaire
  du système. »
- **Clause de propriété des actifs** : « Le client confirme par écrit être
  propriétaire ou disposer de l'autorisation pour chaque actif listé.
  Les systèmes de tiers sont explicitement exclus. »
- **Clause sur les données sensibles** : « Toute donnée de carte bancaire ou
  personnelle rencontrée n'est ni consultée ni copiée au-delà du strict
  nécessaire. »
