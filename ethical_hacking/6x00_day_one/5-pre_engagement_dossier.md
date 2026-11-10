1. Résumé exécutif

Nexus Financial, une fintech de paiement européenne, demande un audit de sécurité indépendant. Son investisseur, Meridian Capital, l’exige avant de finaliser la levée de fonds de Série B. La mission évalue la plateforme de paiement et son environnement, sans perturber les paiements. Les parties sont Nexus (James Okafor, CISO ; Thomas, CTO ; Maria, CFO), Vanguard Security (Sarah Chen, consultante principale) et Meridian Capital, qui ne reçoit le rapport qu’avec l’accord de Nexus.

2. Scope
Dans le scope
API de paiement (Ruby on Rails, AWS)
Application web client
Panneau d’administration (admin.nexus-financial.com)
Configuration AWS (EKS, RDS, S3), en lecture seule
VPN WireGuard et réseau interne
Applications mobiles (iOS / Android), à confirmer car elles n’ont pas été évoquées pendant l’appel
Code Nexus qui communique avec VerifyID et Stripe

Les noms de domaine exacts et les plages IP restent à confirmer par le client.

Hors scope
Élément	Pourquoi
VerifyID	Appartient à un tiers : Nexus ne peut pas autoriser le test
Stripe	Tiers : on utilise seulement son mode test
Infrastructure d’AWS	Appartient à AWS : on vérifie seulement les comptes de Nexus
Déni de service	Risque pour les paiements pendant la levée de fonds
Vraies transactions	Impact financier direct
Intrusion physique, appels pièges	Non demandés, et la plupart des employés sont en télétravail
Zones grises
VerifyID : on teste uniquement le côté Nexus, sur le staging. Aucune donnée envoyée à VerifyID sans son autorisation écrite.
Staging ou production : tous les tests actifs se font sur le staging. La production sert seulement à confirmer les failles, en lecture seule.
Phishing : seulement avec l’accord écrit de la direction, des RH et du DPO. Sinon, il est reporté.
3. Rules of Engagement
Horaires : production en semaine de 9 h à 17 h, avec un ingénieur Nexus disponible. Le staging peut être testé plus largement.
Approche : boîte grise (comptes de test, documentation). En 3 semaines, une boîte noire perdrait trop de temps, et la boîte grise donne une vue plus complète du risque.
Communication : un point quotidien par email avec le CISO, et un appel en cas de problème.
Arrêt d’urgence : si la production ralentit, si un tiers est touché ou si on découvre une attaque, les tests s’arrêtent immédiatement. Le CISO, le CTO, le CFO ou Vanguard peuvent déclencher l’arrêt, par téléphone, avec confirmation écrite.
Données (RGPD) : comptes de test uniquement, aucune copie de données réelles, captures masquées, stockage chiffré, suppression 30 jours après le rapport.
Découverte d’une attaque en cours : arrêt, documentation, appel au CISO dans l’heure, pas d’enquête de notre part. Nexus doit aussi vérifier que les clés API publiées sur GitHub n’ont pas été utilisées.
4. Plan de communication
Contacts :
Nexus : James (contact principal), Thomas (questions techniques), Maria (impact business).
Vanguard : Sarah Chen.
Fréquence :
un email chaque jour ;
un appel chaque semaine avec les trois dirigeants ;
un appel dans l’heure pour toute faille critique ;
le rapport final à la fin de la semaine 4.
Désaccord CTO / CFO : une réunion avant la signature pour valider un compromis. Les tests sont complets sur le staging, ce qui répond au CTO, et prudents sur la production, ce qui répond au CFO. Le compromis est signé par les trois dirigeants.
Canaux sécurisés : email chiffré et messagerie chiffrée. Aucun détail de faille par email ordinaire.
5. Registre des risques
Risque	Probabilité	Impact	Atténuation
Panne de la production	Moyenne	Critique	Tests sur le staging, production en lecture seule
Autorisation insuffisante	Moyenne	Critique	Signature du représentant légal, scope signé par le CTO et le CFO
Toucher un tiers (VerifyID, Stripe)	Moyenne	Élevé	Tiers hors scope, mode test de Stripe
Retard sur l’échéance des investisseurs	Élevée	Élevé	3 semaines de tests et 1 semaine de rapport, en priorité sur la plateforme de paiement
Exposition de données clients	Moyenne	Élevé	Comptes de test, aucune copie, données masquées
6. Checklist Go / No-Go
 Contrat signé par le représentant légal de Nexus
 Scope signé par le CISO, le CTO et le CFO
 Accord RGPD (traitement des données) signé
 Noms de domaine, IP et applications mobiles confirmés
 Décisions sur VerifyID et le phishing consignées par écrit
 Comptes de test et accès fournis
 Contacts d’urgence échangés
 IP de Vanguard déclarées à Nexus

Si un seul élément manque, la mission ne démarre pas.
