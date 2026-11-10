Dossier de pré-engagement : Nexus Financial
	
Client	Nexus Financial
Rédigé par	Vanguard Security, consultant junior
Relu par	Sarah Chen, consultante principale
Statut	BROUILLON v1.0, relecture interne avant signature du client
Classification	CONFIDENTIEL, réservé au client et à Vanguard

Les éléments marqués [À CONFIRMER] doivent être confirmés par écrit par le client avant la revue Go / No-Go.

1. Résumé exécutif

Nexus Financial, une plateforme européenne de paiement numérique qui traite environ 2 M€ de transactions par jour sur trois marchés, a demandé à Vanguard Security de réaliser un audit de sécurité indépendant. Son investisseur principal, Meridian Capital, en a fait une condition pour finaliser la levée de fonds de Série B. La mission évaluera la sécurité de la plateforme de paiement de Nexus et de son environnement (API, applications web et mobiles, panneau d’administration, infrastructure AWS, VPN), avec une priorité forte : n’entraîner aucune interruption des paiements pendant une période commerciale critique. Les parties sont Nexus Financial (client : James Okafor, CISO, contact principal ; Thomas, CTO ; Maria, CFO), Vanguard Security (prestataire : Sarah Chen, consultante principale, et l’équipe de test) et Meridian Capital (destinataire du rapport, uniquement avec l’accord écrit de Nexus). Les prestataires tiers présents dans l’environnement (AWS, Stripe, VerifyID) ne sont pas parties à la mission, et leurs infrastructures ne sont pas testées sans leur autorisation écrite.

2. Document de scope
2.1 Actifs dans le scope
#	Actif	Environnement	Tests autorisés	Remarques
1	API de paiement (Ruby on Rails) : api.nexus-financial.com [À CONFIRMER]	Staging (complet) / Production (validation contrôlée)	Tests de l’API avec et sans authentification, logique métier, contrôle d’accès (IDOR), injections	Production : validation en lecture seule des failles confirmées uniquement
2	Application web client : app.nexus-financial.com [À CONFIRMER]	Staging (complet) / Production (validation contrôlée)	Tests basés sur l’OWASP Top 10 et l’ASVS	Comptes de test uniquement
3	Panneau d’administration : admin.nexus-financial.com	Staging (complet) / Production (limité)	Authentification, contrôle d’accès, tests d’identifiants	Tests d’identifiants : voir les limites en 2.3
4	Applications mobiles (iOS / Android) [À CONFIRMER]	Versions de test connectées au staging	Analyse côté application (stockage, épinglage de certificat) et appels API	Mentionnées dans l’email du CISO mais pas lors de l’appel : inclusion à confirmer
5	Environnement AWS (eu-west-1) : EKS, RDS (PostgreSQL), S3. Identifiant(s) de compte [À CONFIRMER]	Production et staging	Revue de configuration via un rôle IAM en lecture seule (droits IAM, politiques S3, groupes de sécurité, EKS, gestion des secrets)	Conforme à la politique de pentest publiée par AWS, aucun déni de service
6	Point d’accès VPN WireGuard : IP publique(s) [À CONFIRMER]	Production	Revue de configuration externe	Pas de force brute
7	Réseau interne de l’entreprise, scénario « assumed breach »	Production	Tests depuis un compte VPN et un ordinateur de test fournis par Nexus	Limité aux plages IP [À CONFIRMER]
8	Code et points d’accès Nexus liés à VerifyID et Stripe	Staging	Manière dont Nexus envoie, reçoit et valide les données des fournisseurs	Les systèmes des fournisseurs eux-mêmes sont hors scope (voir 2.2)
9	Exposition publique (OSINT passif)	—	Dépôts GitHub publics et secrets exposés appartenant à Nexus	Uniquement passif, à la suite de la fuite de clés API du mois dernier
10	Campagne de phishing [conditionnelle]	—	Voir 2.3	Uniquement si toutes les conditions du 2.3 sont réunies

L’« assumed breach » consiste à partir du principe qu’un attaquant est déjà à l’intérieur, pour tester ce qu’il pourrait faire ensuite.

2.2 Actifs hors scope
Actif	Justification
Infrastructure et API de VerifyID	Elles appartiennent à un tiers et sont gérées par lui. Nexus a confirmé ne posséder ni gérer aucune infrastructure VerifyID : Nexus ne peut donc pas en autoriser le test. Aucune donnée, réelle ou de test, n’est envoyée à l’API de production de VerifyID sans son autorisation écrite.
Infrastructure Stripe	Passerelle de paiement tierce. Tester les systèmes de Stripe serait un accès non autorisé. Seule l’intégration de Nexus est testée, avec le mode test de Stripe.
Infrastructure sous-jacente d’AWS	Elle appartient à AWS. Seules les ressources des comptes AWS de Nexus sont évaluées.
Déni de service et tests de charge	Risque inacceptable pour les paiements pendant la levée de fonds (inquiétude du CFO).
Vraies transactions clients et modification des données de production	Impact financier et réglementaire direct. Tous les tests de transaction utilisent des comptes de test et le staging.
Appareils personnels et réseaux domestiques des employés	Ce ne sont pas des actifs de l’entreprise, et ils posent des questions de vie privée.
Intrusion physique et appels sous faux prétexte (vishing)	Non demandés et disproportionnés : la plupart des employés travaillent à distance.
La plateforme GitHub elle-même	Seuls les dépôts publics de Nexus sont consultés, de façon passive.
2.3 Zones grises

A. L’intégration VerifyID

Recommandation : tester uniquement le côté Nexus de l’intégration (construction des requêtes, stockage des clés API, validation des réponses) sur le staging. N’envoyer aucune donnée à l’API de production de VerifyID.
Justification : Nexus ne peut pas autoriser le test d’un système qui ne lui appartient pas (la leçon du cas FinServe). Envoyer des données de test à VerifyID pourrait aussi enfreindre le contrat de Nexus et ses obligations RGPD. Pour aller plus loin, Nexus doit obtenir l’autorisation écrite de VerifyID ou un accès à un environnement de test (sandbox) de VerifyID.

B. Staging ou production

Recommandation : réaliser tous les tests actifs sur le staging, puis faire une validation contrôlée en lecture seule en production, uniquement pour les failles confirmées, dans les créneaux convenus et avec l’équipe d’exploitation de Nexus en veille.
Justification : cela répond à la fois au CTO (des résultats réels, validés sur l’environnement réel) et au CFO (aucun risque d’exploitation en production). Le staging est censé reproduire la production : c’est à confirmer [À CONFIRMER], et les différences doivent figurer dans le rapport.

C. Tests d’identifiants sur le panneau d’administration

Recommandation : sur le staging, des tests complets d’identifiants et d’authentification. En production, uniquement un « password spraying » lent sur une liste de comptes validée par le client, en dessous du seuil de blocage, avec Nexus prévenu des horaires exacts.
Justification : une attaque par force brute agressive pourrait bloquer les comptes des 15 personnes de l’équipe des opérations et perturber l’activité.

Le « password spraying » consiste à tester quelques mots de passe courants sur de nombreux comptes, plutôt que des milliers de mots de passe sur un seul compte.

D. Social engineering (phishing sur tous les employés)

Recommandation : une seule campagne de phishing contrôlée, de type capture d’identifiants (sans logiciel malveillant, sans charge utile), programmée la dernière semaine de tests, uniquement si on obtient : l’autorisation écrite du représentant légal de l’entreprise, l’accord éclairé des RH et du DPO, une liste des personnes exclues, et la confirmation des obligations de droit du travail dans les trois pays. Sinon, la reporter à une mission séparée.
Justification : le CTO le souhaite, mais piéger des employés implique des données personnelles, des relations sociales et parfois des règles locales du travail. Le test doit porter sur les processus, pas sur les individus, avec un rapport anonymisé et un debriefing bienveillant.

E. Tests en dehors des heures de bureau

Recommandation : le staging peut être testé en dehors des heures de bureau. La production reste limitée aux heures de bureau, avec l’équipe d’exploitation en veille.
Justification : le CTO a raison, les attaquants ne respectent pas les horaires. Mais l’objectif ici est de trouver des vulnérabilités, pas de tester la réaction de nuit. Ce serait une mission de red team, qui n’est pas adaptée à une entreprise qui n’a qu’un seul responsable sécurité.
3. Rules of Engagement
3.1 Créneaux de test autorisés
Environnement	Créneau autorisé
Staging	Du lundi au vendredi, 8 h – 20 h (heure de Paris). Tests hors horaires possibles avec un préavis de 24 h
Production (validation en lecture seule)	Du lundi au jeudi, 9 h – 17 h (heure de Paris) uniquement, avec un ingénieur Nexus en veille
Périodes interdites	Sessions d’audit des investisseurs, fin de mois, et toute date signalée par le CFO [À CONFIRMER]

Calendrier :

Semaine 0 : signatures, revue Go / No-Go, réunion de lancement, création des comptes.
Semaines 1 à 3 : tests.
Semaine 4 : rédaction du rapport. Version provisoire en milieu de semaine, rapport final en fin de semaine.
Cela respecte la contrainte « rapport prêt 2 semaines avant la réunion avec les investisseurs, dans 6 semaines ».
Attention : la « fenêtre de test de 4 semaines » demandée par le client et l’échéance du rapport se chevauchent. En réalité, les tests durent 3 semaines et le rapport demande 1 semaine. Tout retard dans les signatures réduit directement le temps de test.
3.2 Approche de test : boîte grise (avec des éléments de boîte blanche)

Recommandation : boîte grise.

Des comptes de test pour chaque rôle (client, opérations, administrateur).
La documentation de l’API et les schémas d’architecture.
Un accès AWS en lecture seule.
Une revue ciblée du code source des parcours d’authentification et de paiement (élément de boîte blanche).

Justification :

Temps : en 3 semaines, une boîte noire gaspillerait l’essentiel du temps en découverte.
Réalisme : la fuite récente sur GitHub montre qu’un attaquant peut déjà disposer d’informations internes.
Attentes des investisseurs : la boîte grise donne la vue la plus complète et la plus fiable de l’exposition réelle au risque.
Sécurité : connaître l’architecture réduit le risque de perturber la production par accident.

Rappel : en boîte noire, le testeur ne sait rien au départ, comme un attaquant extérieur. En boîte grise, il a des informations partielles (comptes, documentation). En boîte blanche, il a tout, y compris le code source.

3.3 Protocoles de communication
Toute la communication opérationnelle passe par les contacts désignés (voir section 4).
Vanguard annonce par email au contact principal le début et la fin de chaque journée de test.
Les adresses IP sources de Vanguard sont déclarées avant les tests [À CONFIRMER], pour que la surveillance de Nexus et d’AWS puisse distinguer notre activité.
Toute demande venant d’une personne hors de la liste de contacts est vérifiée en rappelant un numéro connu (protection contre le pretexting).
3.4 Procédures d’arrêt d’urgence

Déclencheurs :

Toute dégradation de la production ou du traitement des paiements.
Un impact inattendu sur un tiers (Stripe, VerifyID, AWS).
La découverte d’une compromission active.
Un accès inattendu à un grand volume de données personnelles réelles.
La demande de n’importe quelle personne autorisée à arrêter les tests.

Qui peut arrêter les tests :

Côté Nexus : James (CISO), Thomas (CTO) ou Maria (CFO).
Côté Vanguard : n’importe quel testeur, ou Sarah Chen.

Comment :

Appel téléphonique au contact principal de l’autre partie (numéros joignables 24 h/24, échangés au lancement).
Arrêt immédiat de toute activité de test.
Confirmation écrite sous 30 minutes.
Reprise uniquement avec l’accord écrit du CISO.
3.5 Traitement des données
Cadre légal : Nexus traite des données personnelles (noms, adresses, coordonnées bancaires) et est soumis au RGPD. Un accord de traitement des données (article 28 du RGPD) est signé avant les tests.
Minimisation :
Les testeurs utilisent des comptes de test dédiés.
Les failles qui exposent des données sont démontrées entre les propres comptes de test de Vanguard.
En production, un enregistrement maximum est consulté par faille, sans téléchargement.
Preuves : captures d’écran avec les données personnelles masquées, aucune donnée client réelle dans le rapport.
Stockage : stockage chiffré chez Vanguard, situé dans l’UE, avec un accès contrôlé. Aucune donnée sur des appareils personnels.
Conservation et destruction : les données de travail sont supprimées 30 jours après la livraison du rapport final, avec un certificat de destruction écrit envoyé au CISO.
Identifiants : les identifiants de test sont transmis par un canal chiffré et révoqués à la fin de la mission.
3.6 Protocole en cas de découverte d’une compromission

Si les testeurs trouvent des traces d’une compromission en cours ou passée (par exemple l’utilisation des clés API exposées sur GitHub, des comptes inconnus ou des portes dérobées) :

Arrêter les tests sur le système concerné.
Documenter les indicateurs de compromission, sans enquêter davantage.
Prévenir le CISO par téléphone dans l’heure, puis par écrit via le canal sécurisé.
Transmettre les IP sources et le calendrier d’activité de Vanguard, pour que le client puisse distinguer notre activité de celle de l’attaquant.
Ne tenter aucune correction ni « chasse » à l’attaquant : l’enquête revient à Nexus et à son prestataire de réponse à incident.

Recommandation avant le lancement : Nexus devrait vérifier ses journaux AWS (CloudTrail) pour confirmer que les clés exposées n’ont pas été utilisées pendant leur période d’exposition.

Remarque : toute notification de violation de données au titre du RGPD reste de la responsabilité de Nexus, en tant que responsable du traitement.

4. Plan de communication
4.1 Contacts désignés
Rôle	Nexus Financial	Vanguard Security
Contact principal (au quotidien)	James Okafor, CISO	Sarah Chen, consultante principale
Escalade technique	Thomas, CTO	Responsable de l’équipe de test [À CONFIRMER]
Impact business / arrêt en production	Maria, CFO	Sarah Chen
Signataire légal	Représentant légal de l’entreprise (CEO / dirigeant selon le registre des sociétés) [À CONFIRMER]	Directeur général de Vanguard
Veille d’exploitation (créneaux de production)	Ingénieur DevOps [À CONFIRMER]	—
DPO / protection des données	[À CONFIRMER]	Contact protection des données de Vanguard
4.2 Fréquence des points
Chaque jour : court email d’avancement au CISO (activités, systèmes testés, problèmes).
Chaque semaine : appel de 30 minutes avec le CISO, le CTO et le CFO (avancement, résumé des découvertes, décisions).
Découvertes critiques : appel au CISO dans l’heure, suivi écrit le jour même, sans attendre le rapport final.
Rapport provisoire : milieu de la semaine 4. Nexus dispose de 2 jours pour une relecture factuelle.
Rapport final : fin de la semaine 4. Il contient un résumé pour la direction et les investisseurs, et des résultats techniques détaillés avec les corrections pour l’équipe d’ingénierie.
Réunion de restitution : présentation des résultats à la direction de Nexus.
Communication avec l’investisseur : Meridian Capital reçoit uniquement ce que Nexus autorise par écrit (par exemple une attestation ou le résumé exécutif). Le rapport technique complet n’est jamais envoyé à l’investisseur sans l’accord écrit de Nexus.
4.3 Gestion des parties prenantes (désaccord CTO / CFO)
Le désaccord se règle avant la signature, pas pendant les tests. Vanguard organise une réunion d’alignement de 45 minutes avec le CISO, le CTO et le CFO.
Compromis proposé :
L’exigence du CTO, des tests réalistes et approfondis, est satisfaite par des tests complets en boîte grise sur le staging, un scénario « assumed breach » et une campagne de phishing optionnelle.
L’exigence du CFO, aucune interruption, est satisfaite par une validation en lecture seule en production, des créneaux restreints, des périodes interdites, l’absence de déni de service et le droit du CFO d’arrêter les tests.
Le scope convenu est consigné par écrit et signé par les trois dirigeants, en plus du signataire légal. Aucun changement n’est fait ensuite sans avenant écrit.
Le rôle de Vanguard est de conseiller, pas de prendre parti : nous expliquons les avantages et les risques de chaque option, et c’est le client qui décide.
4.4 Canaux de communication sécurisés
Résultats et rapports : email chiffré (PGP ou S/MIME), ou espace de partage sécurisé avec un accès limité à des personnes nommées.
Urgences : téléphone, puis confirmation via une messagerie chiffrée de bout en bout (par exemple Signal) entre contacts nommés.
Interdit : envoyer des détails de vulnérabilités par email non chiffré, sur des canaux de discussion publics ou par SMS.
Vérification d’identité : toute demande inhabituelle (par exemple un « aperçu des résultats ») est confirmée en rappelant un numéro connu.
5. Registre des risques (risques pour la mission)
#	Risque	Probabilité	Impact	Mesures d’atténuation
1	Interruption de la production qui affecte les paiements pendant la levée de fonds	Moyenne	Critique	Tests actifs sur le staging uniquement, validation en lecture seule en production, créneaux restreints, équipe d’exploitation en veille, pas de déni de service, procédure d’arrêt d’urgence
2	Autorisation invalide ou contestée (CISO seul, désaccord CTO / CFO)	Moyenne	Critique	Signature du représentant légal, scope contresigné par le CISO, le CTO et le CFO, aucun test avant le Go / No-Go
3	Accès non autorisé à des tiers (VerifyID, Stripe, AWS)	Moyenne	Élevé	Systèmes tiers explicitement hors scope, mode test de Stripe, aucune donnée envoyée à VerifyID, respect de la politique de pentest d’AWS, listes d’IP autorisées
4	Dépassement du calendrier, qui met en danger l’échéance des investisseurs	Élevée	Élevé	Signatures en semaine 0, plan de test centré en priorité sur la plateforme de paiement, rapport provisoire en milieu de semaine 4, réduction de scope convenue à l’avance en cas de retard
5	Exposition de données personnelles de clients pendant les tests	Moyenne	Élevé	Accord de traitement des données signé, comptes de test, minimisation, masquage, stockage chiffré dans l’UE, certificat de destruction
6	Compromission préexistante (par exemple les clés API exposées, utilisées avant leur remplacement) qui fausse les résultats	Faible à moyenne	Élevé	Vérification des journaux par Nexus avant le lancement, protocole de découverte de compromission, activité de Vanguard identifiable grâce aux IP déclarées
7	Notre activité déclenche des alertes (AWS GuardDuty, détection de fraude de Stripe) et une vraie procédure d’incident	Moyenne	Moyen	IP et créneaux déclarés au CISO et au DevOps, mode test de Stripe, aucun test sur les vrais flux de paiement
8	Réaction négative au social engineering (plaintes RH, problèmes de droit du travail dans un des trois pays)	Moyenne	Moyen	Accord des RH, du DPO et du juridique, vérification des obligations locales, rapport anonymisé, debriefing bienveillant, possibilité de reporter
9	Blocage des comptes de l’équipe des opérations à cause des tests d’identifiants	Moyenne	Moyen	Password spraying lent sous le seuil de blocage, liste de comptes validée, tests complets sur le staging
10	Mauvaise utilisation ou mauvaise interprétation du rapport par l’investisseur	Faible	Moyen	Résumé exécutif séparé, diffusion du rapport uniquement avec l’accord écrit de Nexus, limites du scope clairement indiquées
6. Checklist Go / No-Go

Les tests ne commencent pas tant que tous les éléments ne sont pas cochés.

Autorisation et contrat

 Contrat et cahier des charges signés par le représentant légal de Nexus (pas seulement par le CISO)
 Scope final et Rules of Engagement contresignés par le CISO, le CTO et le CFO
 Accord de traitement des données (article 28 du RGPD) signé
 Lettre d’autorisation signée, disponible pour chaque testeur

Scope

 Tous les éléments [À CONFIRMER] confirmés par écrit (noms de domaine, identifiants de comptes AWS, plages IP, applications mobiles)
 Confirmation que le staging est représentatif de la production
 Périodes interdites en production reçues du CFO
 Décision sur VerifyID consignée (côté Nexus uniquement, ou autorisation écrite de VerifyID)
 Décision sur le phishing consignée, avec l’accord des RH, du DPO et du juridique s’il est inclus

Préparation technique

 Comptes de test créés pour chaque rôle (client, opérations, administrateur) sur le staging, et en production pour la validation
 Rôle IAM AWS en lecture seule fourni
 Compte VPN de test et accès « assumed breach » fournis
 Mode test de Stripe confirmé pour les flux de paiement
 IP sources de Vanguard déclarées à Nexus

Communication et sécurité

 Contacts d’urgence joignables 24 h/24 échangés et testés des deux côtés
 Canaux de communication sécurisés mis en place et testés
 Veille de l’équipe d’exploitation de Nexus confirmée pour les créneaux de production
 Vérification par Nexus des journaux liés aux clés API exposées terminée (ou risque formellement accepté)

Validation finale

 Réunion Go / No-Go tenue, et décision consignée par écrit par Sarah Chen et James Okafor
