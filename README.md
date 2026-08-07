Holberton Cybersecurity — Comment fonctionne ce programme

La philosophie pédagogique

Pas de tutoriels. Tu ne trouveras pas d'instructions pas-à-pas te disant exactement quoi taper. Tu trouveras des objectifs, des contraintes, des ressources et une deadline. Comment tu atteins l'objectif, c'est à toi de le résoudre.

Des scénarios réels. Chaque projet est construit autour de situations réalistes. Tu ne fais pas des exercices académiques — tu résous des problèmes qui reflètent le vrai travail en sécurité.
Complexité progressive. Les tâches d'un même projet s'appuient les unes sur les autres. Les projets d'un même module s'appuient les uns sur les autres. Les modules d'un même trimestre s'appuient les uns sur les autres. Rien n'existe isolément.

Révision et réflexion. La plupart des projets se terminent par des tâches de révision : des questions ouvertes où tu expliques des concepts avec tes propres mots. Elles valident que tu as compris le pourquoi, pas juste le comment.


Le déroulement du travail

Ta méthode de travail dépend de ce que tu apprends.

Tâches scriptées (principalement T1)

Écris les scripts en local, sur ta machine.

Transfère-les vers l'environnement cible via SCP.

Exécute-les à distance via SSH.

Récupère le flag qui prouve la réussite.

Commit sur GitHub pour validation.


Ça reflète la façon dont travaillent réellement les professionnels de l'infrastructure : l'automatisation plutôt que l'intervention manuelle.

Engagements en boîte noire (T2 & T3)

Aucun indice sur ce qui est vulnérable.

Énumère, analyse, trouve toi-même ton chemin d'attaque.

Exploite la vulnérabilité pour récupérer le flag.

Complexité croissante à mesure que les compétences progressent.



Ça reflète le déroulement des vrais tests d'intrusion — personne ne te dit où chercher.

Projets conceptuels

Exercices basés sur des scénarios demandant du jugement.

Questions ouvertes demandant des explications.

Quiz validant la compréhension avant la pratique.



La sécurité n'est pas que technique. Comprendre le risque, la politique interne et la communication compte aussi.





La validation

Les flags prouvent la compétence technique. Ce sont des hash uniques liés à ton travail — impossible de les falsifier ou de les copier.

Les tâches de révision prouvent la compréhension conceptuelle. Expliquer quelque chose avec tes propres mots démontre un vrai apprentissage.

Les soumissions GitHub contiennent tes scripts, tes flags, et tes réponses écrites. Des checkers automatisés valident les exigences techniques.





Les deadlines

Moment de la soumission

Score plafonné à

Avant la deadline

Jusqu'à 100%

Après la deadline

Plafonné à 65%





Les projets restent accessibles pour continuer à apprendre, mais ton score reflète ta discipline professionnelle. Les deadlines existent dans le monde réel — habitue-toi à ça.





L'équipe pédagogique

Les SWE (Software Engineers) sont là pour aider, pas pour donner les réponses. Ils poseront des questions qui te guident vers la solution. Ils ne taperont pas les commandes à ta place. C'est volontaire, et ça 
reflète la façon dont les collègues seniors fonctionnent en environnement professionnel.





La dimension éthique

Les compétences que tu apprends peuvent causer de vrais dommages si elles sont mal utilisées. Ce n'est pas théorique — on va en prison pour un accès non autorisé à un système informatique.



Les règles sont simples :



Utilise ces techniques uniquement dans des environnements autorisés.

Les labs fournis sont autorisés.

Les systèmes que tu possèdes sont autorisés.

Les systèmes pour lesquels tu as une permission écrite explicite sont autorisés.

Tout le reste est interdit.



Toute violation entraîne un renvoi immédiat du programme. C'est non négociable.



L'industrie de la cybersécurité repose sur la confiance. Les employeurs ont besoin de savoir que tu ne compromettras pas leurs clients. Les clients ont besoin de savoir que tu ne dépasseras pas le cadre de la 
mission. Cette confiance commence ici.





Ton environnement local

Avant de te connecter aux labs distants, tu as besoin d'un environnement local adapté. Les outils de sécurité sont conçus pour Linux. L'industrie tourne sous Linux. Ta configuration locale doit refléter cette 
réalité.

Pourquoi Linux ?

Les outils que tu utiliseras tout au long de ce programme (Nmap, Wireshark, Burp Suite, Metasploit, scripts personnalisés) sont conçus pour Linux en premier. Certains n'existent même pas sur Windows. D'autres 

fonctionnent mal sous macOS. Utiliser Linux élimine les problèmes de compatibilité et t'apprend l'environnement que tu utiliseras professionnellement.


Au-delà des outils, Linux te donne un accès direct aux primitives réseau, aux opérations au niveau du noyau, et aux mécanismes internes du système que Windows masque. Quand tu analyses du trafic réseau ou que tu débogues un exploit, tu as besoin de cet accès.

