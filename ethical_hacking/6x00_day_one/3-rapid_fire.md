# 3. The Rapid Fire — Exercices de jugement

## Cluster A : Limites du scope

### Vignette 1 : API interne non listée
**CAN ?** Zone grise. Le scope inclut « l'application web et ses dépendances
directes ». Une API appelée directement par l'application pourrait en faire
partie, mais la formulation est ambiguë et la propriété de l'API est inconnue :
elle pourrait appartenir à un tiers (comme FinServe dans le cas 2).

**SHOULD ?** Non, pas avant clarification. Une faille critique sur un système au
statut incertain représente le risque maximal en cas d'erreur d'interprétation.
Il faut documenter la découverte sans tester l'API, prévenir le client, et
n'agir qu'après une confirmation écrite que l'API est dans le scope et appartient
au client.

### Vignette 2 : Serveur de développement hors plage
**CAN ?** Non. Le scope signé couvre uniquement 10.0.1.0/24. La mention orale
d'un environnement de développement lors du kickoff n'a aucune valeur
contractuelle face au document signé.

**SHOULD ?** Non. Il faut signaler l'existence du serveur et des identifiants
par défaut, qui représentent un risque réel pour le client. Le fait que le
serveur ait répondu à un ping montre aussi que le scan a débordé du périmètre :
il faut le documenter et le signaler en toute transparence, puis corriger la
configuration du scan. L'accessibilité du réseau de développement depuis la
production révèle un défaut de segmentation, qui peut figurer dans le rapport.

### Vignette 3 : IDOR exposant des données clients
**CAN ?** Oui pour tester la faille, puisque l'application est dans le scope.
Mais le contrat ne dispense pas de la loi sur les données personnelles (RGPD) :
l'accès aux données de vrais clients reste encadré par le principe de
minimisation.

**SHOULD ?** Oui, mais en démontrant l'impact sans exposer de vraies données.
La bonne pratique est de créer deux comptes de test et de prouver que le compte A
accède aux données du compte B. Si un vrai enregistrement doit être touché :
un seul, aucune extraction, données masquées dans les captures du rapport.

## Cluster B : Découvertes fortuites

### Vignette 4 : Preuves de fraude financière
**CAN ?** Oui. Le poste est dans le scope et appartient au client. Le consultant
travaille pour le client : son obligation de confidentialité s'exerce envers lui.
La limite est la vie privée de l'employé : on signale ce qu'on a vu, on ne
fouille pas davantage.

**SHOULD ?** Oui, avec précaution. Arrêter toute exploration, documenter le
minimum (où, quand, quoi) sans copier les documents, escalader d'abord en interne
(responsable de mission et juridique de Vanguard). Le signalement se fait ensuite
de façon confidentielle à un responsable haut placé du client, pas forcément au
contact habituel, qui pourrait être impliqué. La formulation reste factuelle
(« éléments pouvant indiquer une fraude ») et l'information reste hors du rapport
général.

### Vignette 5 : Médecin qui s'auto-prescrit des stupéfiants
**CAN ?** Oui. Le système EHR est dans le scope et l'information concerne
directement le client.

**SHOULD ?** Oui, mais pas uniquement dans le rapport final. Contrairement à la
vignette 4, des patients sont en danger : leurs dossiers médicaux sont falsifiés
et un médecin potentiellement sous influence les soigne. Le rapport final est
trop lent et trop largement diffusé, et y inclure les détails exposerait des
données de santé. Il faut s'arrêter, escalader immédiatement en interne, puis
alerter de façon urgente et confidentielle le trusted agent de la red team ou
une personne haut placée de l'hôpital (direction, juridique, direction médicale).
Le rapport final ne contient qu'une mention anonymisée.

## Cluster C : Communication avec le client

### Vignette 6 : RCE activement exploitée
**CAN ?** Oui. Les RoE fixent le calendrier de livraison des résultats, mais
n'interdisent pas d'alerter sur une urgence. Face à une attaque réelle en cours,
le risque contractuel d'un écart de procédure est minime comparé au préjudice
pour le client. L'absence de clause de découverte critique est une faiblesse
des RoE.

**SHOULD ?** Oui, immédiatement. Arrêter les tests sur la machine concernée pour
ne pas brouiller l'enquête, documenter les IOC, escalader en interne, puis
prévenir le contact désigné par téléphone avec confirmation écrite. Transmettre
les IP sources et le calendrier de Vanguard pour distinguer notre activité de
celle de l'attaquant. Ne pas chasser l'attaquant ni corriger soi-même : c'est le
rôle de l'équipe de réponse à incident du client.

### Vignette 7 : Le RSSI demande un aperçu des résultats
**CAN ?** Non, en l'état. Les RoE désignent le chef de projet comme seul canal.
L'identité de l'appelant ne peut pas être vérifiée : une demande pressante
d'informations sensibles correspond au schéma classique du pretexting. Les RoE
peuvent toutefois être modifiées par écrit par une personne habilitée.

**SHOULD ?** Pas directement, mais il faut chercher une solution. Des résultats
préliminaires non vérifiés présentés à un conseil d'administration risquent de
contenir des faux positifs, et des failles non corrigées sont des informations
sensibles. Il faut rester courtois, escalader chez Vanguard, contacter le chef de
projet malgré ses congés ou son suppléant pour obtenir une autorisation écrite.
Avec autorisation : un résumé de haut niveau marqué « préliminaire ». Sans
autorisation : un simple point d'avancement, sans résultats.

## Cluster D : Qualification de la mission

### Vignette 8 : « Piratez-nous comme un vrai attaquant »
**CAN ?** Oui. Proposer une red team est une offre commerciale, rien d'illégal.
Le scope, les RoE et l'autorisation viendraient au moment du contrat.

**SHOULD ?** Non. Une red team teste la capacité de détection et de réponse
d'une équipe de défense ; cette entreprise n'en a pas et n'a jamais été évaluée.
Le résultat serait prévisible et coûteux. Le vendre profiterait de la
méconnaissance du client, comme dans le cas 3 (InnovateTech). Il faut lui
expliquer les différents types de missions, transformer « surprenez-nous » en
objectifs précis, et proposer une progression : vulnerability assessment ou
pentest ciblé, puis corrections, puis red team plus tard.
