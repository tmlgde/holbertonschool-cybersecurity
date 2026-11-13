# Action Log, Lumen Engagement

| Timestamp (UTC) | Phase | Action | Target | Result |
| --- | --- | --- | --- | --- |
| 2026-11-23T09:05:11Z | 4 | Relecture des Rules of Engagement avant énumération, confirmation du périmètre autorisé | Interne | Cinq surfaces Lumen dans le périmètre confirmées ; actifs clients hors périmètre notés comme interdits. |
| 2026-11-23T09:14:02Z | 4 | nmap -sV -p- sur le portail web client | app.lumen-industrial.com | Ports ouverts : 80, 443. Serveur HTTP : nginx 1.24. Application web React, back-end Django identifié via en-têtes. |
| 2026-11-23T09:31:18Z | 4 | gobuster dir sur le portail web client | app.lumen-industrial.com | Répertoires découverts : /login, /dashboard, /upload, /reports. Fonction d'upload de fichiers présente. |
| 2026-11-23T09:48:40Z | 4 | Analyse manuelle de la fonction d'upload (types acceptés) | app.lumen-industrial.com/upload | Upload semble validé sur l'extension uniquement ; type MIME non vérifié côté serveur. IDENTIFIÉ, non confirmé. |
| 2026-11-23T10:12:05Z | 4 | nmap -sV sur le panneau d'administration | admin.lumen-industrial.com | Ports ouverts : 443. Formulaire de connexion sur /login. Aucun second facteur visible. |
| 2026-11-23T10:29:33Z | 4 | Test manuel de la page de connexion admin (comportement MFA) | admin.lumen-industrial.com/login | Authentification par mot de passe seul, pas de MFA. IDENTIFIÉ comme faiblesse d'authentification. |
| 2026-11-23T10:51:47Z | 4 | Énumération de l'API publique via la documentation exposée | api.lumen-industrial.com/docs | Interface Swagger accessible publiquement. Points d'accès d'authentification et de gestion des capteurs listés. |
| 2026-11-23T11:08:20Z | 4 | Test de limitation de débit sur le point d'authentification de l'API | api.lumen-industrial.com/auth | Aucune limitation de débit observée sur une courte série de requêtes. IDENTIFIÉ, exposition au password spraying. |
| 2026-11-23T11:27:54Z | 4 | Test d'accès à une ressource d'un autre identifiant (contrôle d'accès) | api.lumen-industrial.com/sensors | Réponses suggérant un contrôle d'accès faible entre identifiants de ressources. IDENTIFIÉ (IDOR potentiel), non confirmé. |
| 2026-11-23T11:52:36Z | 4 | nmap -sV sur la passerelle de démonstration | demo-gw.lumen-industrial.com | Port 22 ouvert (SSH). Bannière OpenSSH indiquant une version à vérifier contre les CVE publics. IDENTIFIÉ. |
| 2026-11-23T13:04:09Z | 4 | Test d'authentification SSH sur la passerelle de démo (identifiants par défaut) | demo-gw.lumen-industrial.com:22 | Service SSH répond ; hypothèse d'identifiants faibles/par défaut à vérifier. IDENTIFIÉ, non confirmé. |
| 2026-11-23T13:38:21Z | 4 | Connexion à un client MQTT, test des opérations subscribe | mqtt.lumen-industrial.com:1883 | Subscribe accepté sans authentification. Flux de données de capteurs lisibles. IDENTIFIÉ. |
| 2026-11-23T13:55:47Z | 4 | Test des opérations publish sur le broker MQTT | mqtt.lumen-industrial.com:1883 | Publish accepté sans authentification sur un topic de test. Injection de message possible. IDENTIFIÉ, à confirmer en phase 5. |
| 2026-11-23T14:10:02Z | 4 | Vérification du chiffrement du port MQTT | mqtt.lumen-industrial.com:1883 | Trafic en clair, pas de TLS sur le port 1883. IDENTIFIÉ. |
| 2026-11-23T14:33:15Z | 4 | Découverte incidente d'un hôte résolvant vers un domaine client, hors périmètre | (hors périmètre) | Actif joignable mais HORS PÉRIMÈTRE. Non sondé. Consigné et escaladé au CISO pour décision d'autorisation séparée (RoE, conditions d'arrêt). |
