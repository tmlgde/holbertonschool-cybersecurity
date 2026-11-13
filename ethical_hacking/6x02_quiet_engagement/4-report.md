# Penetration Test Report, Lumen Industrial Systems

**Engagement reference:** VS-LUMEN-2026-PT01
**Reporting period:** 23/11/2026 – 25/11/2026
**Prepared by:**  Junior Consultant, Vanguard Security
**Distribution:** CISO de Lumen, destinataires du dossier de conformité NIS2 en aval

## 1. Executive Summary
Vanguard Security a mené un test d'intrusion externe de l'infrastructure contrôlée par Lumen, afin d'alimenter le dossier de conformité NIS2 présenté aux auditeurs de trois clients industriels. La mission a révélé une chaîne d'attaque critique : une fonction d'upload insuffisamment filtrée sur le panneau d'administration permet l'exécution de code à distance, menant, via des secrets exposés, à l'accès au plan de gestion des objets connectés de Lumen. S'y ajoute un broker MQTT ouvert sans authentification, qui autorise l'écoute et la falsification des données de surveillance de production. Ces faiblesses relèvent directement des mesures de gestion du risque exigées par l'article 21 de NIS2, et leurs conséquences possibles constitueraient des incidents à notifier au sens de l'article 23. Aucune donnée réelle n'a été exfiltrée et la cible a été intégralement restaurée. Les correctifs prioritaires sont réalisables à court terme et permettraient à Lumen de présenter un dossier de conformité solide.

## 2. Scope and Methodology
La mission s'est limitée à l'infrastructure contrôlée par Lumen, conformément aux Rules of Engagement : la plateforme cloud, l'API publique, le panneau d'administration interne, la passerelle de démonstration et le broker MQTT de démonstration. Les passerelles et capteurs déployés chez les clients industriels de Lumen étaient explicitement hors périmètre : Lumen n'a pas l'autorité légale d'autoriser des tests sur une infrastructure appartenant à des tiers, et la joignabilité technique de ces actifs ne change pas cette règle. Les tests de déni de service et toute action destructrice étaient interdits. La méthode suivie est le standard PTES, en sept phases. Chaque action significative a été consignée en temps réel dans le journal d'actions, dont ce rapport est intégralement reconstructible.

## 3. PTES Phase Summary
**Pré-engagement :** rédaction des Rules of Engagement fixant périmètre, fenêtre, contacts, outils et conditions d'arrêt. Enjeu : inscrire l'exclusion des actifs clients.
**Collecte de renseignement :** énumération de l'empreinte publique de Lumen et de ses cinq surfaces autorisées, sans toucher aux actifs hors périmètre.
**Modélisation des menaces :** priorisation des menaces plausibles contre les actifs réellement découverts, rattachées à l'enjeu NIS2.
**Analyse des vulnérabilités :** identification des faiblesses sur chaque surface, en distinguant strictement l'identifié du confirmé.
**Exploitation :** obtention d'un accès par upload polyglotte sans Metasploit, puis pivot via des secrets exposés.
**Post-exploitation :** mesure de l'impact en termes clients et NIS2, puis restauration complète de la cible.
**Rapport :** production du présent document pour le CISO et les auditeurs.

## 4. Findings

### 4.1 Exécution de code via upload de fichier polyglotte, Severity Critical
- **Description technique :** le panneau d'administration valide les fichiers uploadés sur l'extension et la signature d'image, mais pas sur le contenu exécuté. Un fichier polyglotte, à la fois image PNG valide et script PHP, contourne cette validation et obtient l'exécution de code côté serveur (utilisateur www-data).
- **CVSS environnemental :** 9.8 — AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H. Attaque réseau, sans authentification ni interaction, avec impact total.
- **Pertinence NIS2 :** article 21 (défaut de maîtrise du risque sur le traitement des fichiers).
- **Impact business :** point d'entrée vers l'ensemble de la plateforme de surveillance ; compromet directement le dossier de conformité NIS2 des clients.
- **Remédiation :** valider le contenu réel des fichiers, interdire l'exécution dans le répertoire d'upload, servir les fichiers depuis un stockage non exécutable, restreindre les types acceptés.

### 4.2 Secrets exposés menant à un pivot vers le plan IoT, Severity Critical
- **Description technique :** un fichier de configuration applicatif accessible après le foothold contenait des identifiants de service et une clé d'API interne, utilisés pour atteindre les fonctions d'administration et le plan de gestion des objets connectés de Lumen.
- **CVSS environnemental :** 9.1 — AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:H/A:L. Changement de périmètre (scope), impact élevé sur confidentialité et intégrité.
- **Pertinence NIS2 :** article 21 (gestion des secrets et des accès).
- **Impact business :** un attaquant atteindrait la gestion des dispositifs de tous les clients depuis un seul point.
- **Remédiation :** retirer les secrets du code et des configurations, utiliser un coffre à secrets, renouveler les clés exposées, appliquer le moindre privilège.

### 4.3 Broker MQTT ouvert sans authentification, Severity Critical
- **Description technique :** le broker MQTT accepte les opérations subscribe et publish sans authentification. Subscribe permet l'écoute des flux de capteurs ; publish permet d'injecter de fausses mesures.
- **CVSS environnemental :** 9.3 — AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H. L'injection de données affecte des systèmes en aval chez les clients.
- **Pertinence NIS2 :** articles 21 et 23 (une falsification de données de surveillance serait un incident à notifier).
- **Impact business :** de fausses données pourraient masquer une panne ou déclencher un arrêt de ligne chez un client industriel.
- **Remédiation :** imposer l'authentification et le TLS sur le broker, restreindre les droits publish/subscribe par client, cloisonner les topics.

### 4.4 Panneau d'administration sans authentification à second facteur, Severity High
- **Description technique :** la connexion au panneau d'administration repose sur le seul mot de passe, sans MFA.
- **CVSS environnemental :** 8.1 — AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N.
- **Pertinence NIS2 :** article 21 (mesures d'authentification).
- **Impact business :** un identifiant volé ou deviné donne un accès privilégié immédiat.
- **Remédiation :** imposer la MFA sur tous les comptes d'administration, surveiller les connexions anormales.

### 4.5 API sans limitation de débit et contrôle d'accès faible, Severity High
- **Description technique :** le point d'authentification de l'API n'applique pas de limitation de débit (exposition au password spraying), et un contrôle d'accès faible entre ressources suggère un risque d'accès inter-clients (IDOR), identifié mais non confirmé.
- **CVSS environnemental :** 7.5 — AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N.
- **Pertinence NIS2 :** article 21.
- **Impact business :** accès potentiel aux données d'un client depuis un autre compte.
- **Remédiation :** limiter le débit, renforcer le contrôle d'accès par ressource, tester l'IDOR en profondeur.

### 4.6 Documentation d'API et bannières de version exposées, Severity Medium
- **Description technique :** la documentation Swagger de l'API est publique et les bannières de version (nginx, OpenSSH) sont exposées, facilitant le ciblage de CVE connus. Identifié, non confirmé exploitable.
- **CVSS environnemental :** 5.3 — AV:N/AC:L/PR:N/UI:N/S:U/C:L/I:N/A:N.
- **Pertinence NIS2 :** article 21 (réduction de la surface d'exposition).
- **Impact business :** accélère la reconnaissance d'un attaquant.
- **Remédiation :** restreindre l'accès à la documentation, masquer les bannières, maintenir les versions à jour.

## 5. Exploitation Narrative
L'accès initial a été obtenu sans Metasploit, par une charge polyglotte construite à la main : une image PNG valide (signature 89 50 4E 47) suivie d'un bloc PHP minimal, portant l'extension .png (journal, 24/11 09:28). Un premier test avait confirmé que la validation ne portait que sur l'extension et la signature (24/11 09:12). L'upload a été accepté (200 OK, 24/11 09:41) et l'exécution de code confirmée via l'appel du fichier déposé, renvoyant l'utilisateur www-data (24/11 09:43). Depuis ce point d'appui, l'énumération locale a révélé un fichier de configuration contenant une clé d'API interne (24/11 09:55). Cette clé a servi de pivot pour atteindre les fonctions d'administration (24/11 10:14), puis le plan de gestion IoT de Lumen (24/11 10:33). L'impact a été démontré par la lecture d'une classe de données sensible au sens NIS2, sur des enregistrements de test uniquement (24/11 10:51). La chaîne a été arrêtée volontairement avant toute action sur les dispositifs, pour respecter l'interdiction d'action destructrice (24/11 11:05). Chaque étape est traçable dans le journal d'actions.

## 6. Recommendations
**Court terme (avant la remise du dossier NIS2) :** corriger la validation des uploads et interdire l'exécution dans le répertoire concerné ; imposer l'authentification et le TLS sur le broker MQTT ; retirer les secrets des configurations et renouveler les clés exposées ; activer la MFA sur le panneau d'administration.
**Moyen terme :** mettre en place une limitation de débit et un contrôle d'accès strict sur l'API ; restreindre la documentation publique et masquer les bannières ; renforcer la journalisation pour assurer la traçabilité exigée par l'article 21.
**Long terme :** adopter un coffre à secrets et une gestion centralisée des identités ; cloisonner les environnements de démonstration et de production ; instaurer des tests d'intrusion réguliers et un processus de notification d'incident aligné sur l'article 23.

## 7. Limitations and Uncertainty
Ce rapport couvre uniquement l'infrastructure contrôlée par Lumen. Les passerelles et capteurs déployés chez les clients, bien que joignables depuis la position d'énumération, n'ont pas été testés : un tel actif a été rencontré, consigné comme découverte hors périmètre et escaladé au CISO pour une décision d'autorisation séparée (journal, 23/11 14:33). Certaines faiblesses sont identifiées mais non confirmées exploitables, notamment l'IDOR potentiel sur l'API et les CVE suggérés par les bannières de version ; elles sont signalées comme telles et doivent être validées par le client. L'analyse ne constitue pas un audit de conformité NIS2 complet ni un avis juridique ; elle fournit la preuve technique destinée au dossier de conformité.

## 8. Appendices
- **A. Sourced findings :** chaque découverte renvoie à son entrée horodatée dans le journal d'actions (`3-actions_log.md`).
- **B. Action log excerpt :** le journal complet des phases 4, 5 et 6, source de vérité de ce rapport, est fourni séparément.
- **C. Framework references :** PTES (sept phases) ; CVSS v3.1 pour la notation ; directive NIS2 (UE 2022/2555), articles 21 et 23 ; OWASP File Upload Cheat Sheet pour le vecteur d'upload.
