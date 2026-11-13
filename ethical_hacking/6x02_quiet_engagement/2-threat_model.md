# Threat Model, Lumen Industrial Systems

## Framework Mix
Ce modèle mélange trois lentilles, choisies ligne par ligne selon l'actif. MITRE ATT&CK tague les menaces techniques directement observées à la reconnaissance (API exposée, panneau d'administration, broker MQTT), car elles correspondent à des techniques d'attaquant documentées. STRIDE décompose la plateforme cloud et son broker au niveau des propriétés de sécurité (intégrité, confidentialité, authentification). PASTA relie les menaces les plus lourdes à l'enjeu business de Lumen : la conformité NIS2 de ses clients et la clôture de la levée de fonds. Ce mélange est volontaire : chaque menace est taguée avec la lentille qui la justifie le mieux.

## Threat Matrix

| # | Menace | Actif (reco) | Tag framework | Gravité | Justification |
| --- | --- | --- | --- | --- | --- |
| 1 | Broker MQTT accepte publish sans authentification : injection de fausses données de capteurs | mqtt.lumen-industrial.com | STRIDE-S / MITRE-T1565.001 | Critical | La reco montre un broker ouvert en publish ; de fausses mesures peuvent masquer une panne ou déclencher un arrêt de ligne chez les clients industriels. |
| 2 | Broker MQTT accepte subscribe sans authentification : écoute des données de production | mqtt.lumen-industrial.com | STRIDE-I | High | Subscribe ouvert = n'importe qui lit les flux de capteurs des clients, donnée industrielle sensible. |
| 3 | Upload de fichier non filtré sur la plateforme : dépôt d'un fichier polyglotte exécutable | app.lumen-industrial.com | MITRE-T1190 | Critical | La reco a repéré une fonction d'upload ; un fichier polyglotte validé seulement sur l'extension peut mener à l'exécution de code côté serveur. |
| 4 | Panneau d'administration sans second facteur d'authentification | admin.lumen-industrial.com | STRIDE-S / MITRE-T1078 | High | Page de login admin exposée sans MFA ; un identifiant volé ou deviné donne un accès privilégié. |
| 5 | Documentation d'API publique exposée (Swagger) facilitant l'énumération | api.lumen-industrial.com/docs | MITRE-T1190 | Medium | La doc publique révèle les points d'accès et paramètres, ce qui accélère la recherche de failles. |
| 6 | API sans limitation de débit : attaque par force sur l'authentification | api.lumen-industrial.com | MITRE-T1110 | High | Sans rate limiting, les points d'authentification de l'API sont exposés au password spraying. |
| 7 | Contrôle d'accès faible sur l'API : accès aux données d'un autre client (IDOR) | api.lumen-industrial.com | STRIDE-I / PASTA-Stage-IV | Critical | Une API multi-clients sans contrôle d'accès strict permettrait de lire les données d'un client depuis le compte d'un autre. |
| 8 | Bannières de version exposées (Nginx, Django) pointant vers des CVE connus | app.lumen-industrial.com | MITRE-T1595 | Medium | Les bannières relevées à la reco permettent de cibler des vulnérabilités publiques si les versions ne sont pas à jour. |
| 9 | Passerelle de démonstration partageant une configuration avec la production | demo-gw.lumen-industrial.com | STRIDE-E | High | Une passerelle de démo mal isolée peut servir de pivot vers des composants internes. |
| 10 | Absence de chiffrement TLS sur le port MQTT (1883) | mqtt.lumen-industrial.com | STRIDE-I | Medium | Le trafic MQTT en clair peut être intercepté sur le réseau. |
| 11 | Journalisation insuffisante des accès admin et API : actions non traçables | admin / api | STRIDE-R / PASTA-Stage-VII | High | Sans journaux fiables, Lumen ne peut pas démontrer la traçabilité exigée par NIS2 (article 21). |
| 12 | Exposition de données personnelles/industrielles via la plateforme sans cloisonnement clair | app.lumen-industrial.com | PASTA-Stage-VII | High | Une fuite de données clients industriels compromettrait la conformité NIS2 et la clôture de la Série A. |

## Prioritisation Note
Les trois menaces prioritaires pour Lumen sont, dans l'ordre : l'injection de fausses données via le broker MQTT ouvert en publish (menace 1), l'upload de fichier polyglotte menant à l'exécution de code (menace 3), et l'accès transversal aux données entre clients via l'API (menace 7). Leur gravité ne tient pas seulement à l'impact technique, mais aux conséquences business : Lumen vend un service de surveillance industrielle à des entités essentielles NIS2. De fausses données injectées pourraient masquer un incident sur une ligne de production ; une exécution de code ou une fuite inter-clients ferait de Lumen le maillon faible du dossier de conformité NIS2 de ses clients, faisant échouer les trois renouvellements dont dépend la levée de fonds. Ce sont ces trois menaces que le rapport final devra mettre en avant pour le CISO.
