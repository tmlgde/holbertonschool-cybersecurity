4. Know the Territory : cartographie des métiers

Vanguard Security, plan de recrutement du prochain trimestre
Postes retenus : Infrastructure Penetration Tester, Web Application Security Consultant, Social Engineering Specialist

Poste 1 : Infrastructure Penetration Tester
1. Titre et positionnement

Pentesteur infrastructure (niveau consultant). Il fait partie de l’équipe pentest principale de Vanguard et travaille au quotidien avec :

le consultant principal / chef de projet, qui gère la relation client ;
l’équipe commerciale, pour définir un scope techniquement juste avant la signature ;
les autres consultants de Vanguard (web, social engineering) sur les missions combinées ;
côté client, l’équipe informatique ou le contact technique désigné dans les RoE.
2. Périmètre d’intervention
Il teste : les réseaux internes et externes, les serveurs Windows et Linux, l’Active Directory, les VPN, les pare-feu, les services réseau exposés, les postes de travail et le matériel réseau.
Pas son domaine : la logique des applications web en profondeur, la configuration des comptes cloud (AWS, Azure, GCP), les applications mobiles, les dispositifs médicaux ou industriels (OT), et les tests sur les personnes.
3. Compétences clés

Techniques

Protocoles réseau : TCP/IP, DNS, SSH, RDP, SMB, LDAP, Telnet.
Attaques Active Directory : abus de Kerberos et NTLM, chemins d’élévation de privilèges.
Élévation de privilèges sous Windows et Linux.
Outils : Nmap, Metasploit, BloodHound, Impacket.

Humaines

Expliquer un chemin d’attaque complexe (par exemple, d’un compte piégé par phishing jusqu’à l’administrateur du domaine) à un dirigeant non technique en moins de cinq minutes.
Rédiger des rapports clairs et reproductibles, avec des recommandations priorisées.
Rigueur stricte sur le scope : s’arrêter et escalader dès qu’un système semble hors périmètre.
Sang-froid : appliquer la procédure d’urgence si un système tombe ou si un vrai attaquant est détecté.
4. Certifications
OSCP (OffSec) : examen entièrement pratique sur des machines en réseau, Active Directory compris, suivi d’un rapport professionnel. Elle prouve que le candidat sait réellement compromettre une infrastructure, pas seulement la décrire.
CREST CRT (Registered Penetration Tester) : reconnue par des gouvernements et des régulateurs. C’est un signal fort pour nos clients européens régulés (santé, finance), et c’est cohérent avec l’adhésion de Vanguard au code de conduite CREST.
CREST CCT INF (pour les profils seniors) : examen avancé, écrit et pratique, centré sur les failles réseau et système. C’est le niveau attendu d’un chef d’équipe.
5. Différence avec les postes voisins
Red Team Operator : le pentesteur infrastructure cherche le maximum de failles dans un scope défini, sans chercher à être discret. Le Red Team Operator poursuit un objectif précis, discrètement, pour tester la détection et la réponse.
Cloud Security Assessor : l’un travaille sur les réseaux et serveurs sur site, l’autre évalue les identités, les droits et la configuration des comptes chez les fournisseurs cloud.
Web Application Consultant : le pentesteur infrastructure peut repérer un serveur web, mais n’analyse pas en profondeur la logique de l’application.
6. Scénario de mission typique

Un groupe de cliniques régionales demande un pentest interne après une attaque par ransomware. Le consultant participe au cadrage : il obtient les plages IP, exclut les dispositifs médicaux connectés et vérifie l’autorisation écrite du prestataire qui gère le pare-feu. Pendant les tests, il cartographie le réseau, compromet un compte Active Directory et démontre comment un attaquant pourrait atteindre le serveur de fichiers, sans jamais copier de données de patients. Il livre un rapport avec un résumé pour la direction et des recommandations priorisées, puis le présente à l’équipe informatique du client en réunion de restitution.

Poste 2 : Web Application Security Consultant
1. Titre et positionnement

Consultant en sécurité des applications web. Il fait partie de l’équipe pentest de Vanguard, spécialisé dans la couche applicative. Il travaille avec :

le consultant principal / chef de projet ;
le pentesteur infrastructure et le spécialiste en social engineering sur les missions combinées ;
côté client, les équipes de développement lors de la restitution, pour les aider à comprendre et corriger les failles.
2. Périmètre d’intervention
Il teste : les applications web et portails clients, les API (REST, GraphQL, SOAP), l’authentification et la gestion des sessions (OAuth 2.0, OpenID Connect, SAML, JWT, SSO), les CMS (WordPress, Drupal, Magento), et le code source lors des audits en boîte blanche.
Pas son domaine : l’infrastructure réseau (Active Directory, VPN), la configuration des comptes cloud, l’application mobile installée sur le téléphone, et les tests sur les personnes.
3. Compétences clés

Techniques

Maîtrise de l’OWASP Top 10 et de l’OWASP ASVS.
Tests manuels des injections (SQL, NoSQL), des défauts de contrôle d’accès (IDOR), des failles SSRF et XSS, et des contournements d’authentification.
Lecture de code dans les langages courants : JavaScript/TypeScript, Python, PHP, Java, .NET.
Utilisation experte de Burp Suite.

Humaines

Diplomatie avec les développeurs : présenter les failles en partenaire, pas en donneur de leçons.
Expliquer une faille comme la SSRF aussi bien à un développeur senior qu’à un chef de produit non technique.
Pragmatisme : proposer des correctifs réalistes, compatibles avec le calendrier de livraison du client.
Rédiger des preuves de concept précises, pour que les équipes puissent reproduire et corriger chaque faille.
Minimisation des données : démontrer l’impact avec des comptes de test plutôt qu’avec de vrais dossiers clients.
4. Certifications
OSWE (OffSec) : examen web avancé basé sur l’analyse de code source et l’écriture d’exploits fonctionnels. Directement utile pour les missions en boîte blanche.
Burp Suite Certified Practitioner (PortSwigger) : examen pratique sur l’outil principal du métier. Il prouve l’efficacité sur de vraies vulnérabilités web.
CREST CCT APP : examen avancé de test applicatif, reconnu en Europe et aligné sur les standards CREST de Vanguard.
5. Différence avec les postes voisins
Infrastructure Penetration Tester : le consultant web attaque la logique de l’application (qui a le droit de voir quoi, comment les données sont validées), pas le serveur qui l’héberge.
Mobile Application Penetration Tester : les deux touchent aux API. Le consultant web teste l’API côté serveur, le pentesteur mobile analyse l’application installée sur le téléphone (stockage local, code de l’application, épinglage de certificat).
Cloud Security Assessor : l’application peut tourner dans le cloud, mais la configuration du compte cloud est hors de son périmètre.
6. Scénario de mission typique

Une fintech prépare le lancement d’un nouveau portail client et doit fournir un rapport de pentest à son régulateur. Le consultant définit le scope avec le client : le domaine du portail, son API, et deux comptes de test par niveau de droits. Il découvre une faille IDOR permettant à un client de consulter les relevés d’un autre client, et la démontre uniquement entre ses propres comptes de test. Il livre un rapport avec une preuve de concept reproductible et un niveau de gravité, puis anime une séance de restitution avec les développeurs pour valider les correctifs.

Poste 3 : Social Engineering Specialist
1. Titre et positionnement

Spécialiste en ingénierie sociale. Il fait partie de l’équipe offensive de Vanguard, centré sur la couche humaine. Il travaille avec :

le consultant principal / chef de projet ;
le pentesteur infrastructure, souvent en binôme : le spécialiste obtient l’accès initial, le testeur technique prend le relais ;
côté client, la direction, les RH et le service juridique, qui doivent valider le cadre, les cibles et les prétextes avant toute campagne.
2. Périmètre d’intervention
Il teste : le phishing (email), le smishing (SMS), le vishing (appels sous un faux prétexte), l’intrusion physique (tailgating, se faire passer pour un livreur ou un prestataire), et l’OSINT pour préparer des scénarios réalistes. Ce qui est réellement testé, ce sont les processus de l’organisation et la vigilance du personnel.
Pas son domaine : exploiter les failles techniques une fois l’accès obtenu (c’est le rôle des testeurs techniques), et construire le programme de sensibilisation à long terme du client.
3. Compétences clés

Techniques

Monter des campagnes de phishing réalistes : infrastructure email, compréhension de SPF/DKIM/DMARC, pages de capture d’identifiants dans un cadre strictement contrôlé.
Méthodologie OSINT pour cartographier une organisation à partir de sources publiques.
Bases de sécurité physique : systèmes de badges, contrôle d’accès, techniques de tailgating.

Humaines

Improviser de façon crédible sous pression, tout en restant strictement dans les prétextes autorisés.
Animer un debriefing bienveillant : « la cible, c’est le processus, pas l’individu ». Aucun employé n’est nommé ni blâmé.
Confidentialité absolue sur les informations personnelles croisées pendant l’OSINT ou les appels.
Jugement éthique solide : ne jamais se faire passer pour les forces de l’ordre ou du personnel médical, ne jamais utiliser de prétexte personnel ou bouleversant.
4. Certifications
CESE, Certified Ethical Social Engineer (Social-Engineer, LLC ; anciennement SEPP) : l’une des rares certifications pratiques du domaine. L’examen dure 48 heures et couvre la recherche, le phishing, les appels et la rédaction d’un rapport sur une cible réaliste.
CompTIA PenTest+ : elle situe le social engineering dans une méthodologie de pentest complète (cadrage, aspects légaux, rapport), indispensable pour travailler avec les testeurs techniques.
(Formation, pas certification) SANS SEC567, Social Engineering for Penetration Testers : elle prépare aux défis éthiques et aux risques propres aux missions de social engineering.
5. Différence avec les postes voisins
Red Team Operator : en red team, le social engineering n’est qu’une porte d’entrée vers un objectif plus large. Le spécialiste en social engineering mesure la résistance des personnes et des processus comme objectif en soi.
Infrastructure Penetration Tester : l’un attaque les personnes, l’autre les machines. Ils sont complémentaires sur une même mission.
6. Scénario de mission typique

Une banque régionale veut mesurer la résistance de ses agences aux tentatives de fraude. Le spécialiste définit avec la direction, les RH et le juridique les techniques autorisées (phishing, appels au service client), les populations ciblées et les prétextes interdits. Il mène une campagne de phishing et une série d’appels en se faisant passer pour le support informatique, en mesurant les taux de clic, de saisie d’identifiants et de signalement. Il livre un rapport anonymisé, centré sur les processus défaillants plutôt que sur les individus, puis anime un debriefing bienveillant avec les équipes.

Pourquoi ces trois postes ?

Ces trois postes couvrent les trois grandes surfaces d’attaque de toute organisation : le réseau, les applications et les humains. Ensemble, ils reproduisent la chaîne d’attaque la plus fréquente contre nos clients : un email de phishing compromet un employé, l’attaquant se déplace dans le réseau interne, puis exploite les applications ou les données, comme dans les attaques par ransomware que l’on voit régulièrement dans la santé. Pour nos clients de la santé et de la finance, cette combinaison répond aux besoins les plus fréquents : tests du réseau interne, sécurité des portails clients et des API, résistance au phishing et à la fraude. Sur le plan stratégique, ce plan de recrutement montre que Vanguard consolide son cœur de métier, le pentest, avant de se diversifier. Il pose aussi les bases d’une future capacité red team, puisque les opérations red team combinent justement ces trois compétences. Nous n’avons volontairement pas priorisé de Cloud Security Assessor ce trimestre : beaucoup de nos clients s’appuient encore sur des réseaux sur site et sur des plateformes SaaS de tiers, que nous ne pouvons pas tester directement. L’expertise cloud sera notre prochaine priorité de recrutement, à mesure que nos clients du secteur technologique poursuivent leur migration.
