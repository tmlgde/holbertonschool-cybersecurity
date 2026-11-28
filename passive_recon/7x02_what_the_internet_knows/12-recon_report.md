# Rapport de footprinting concurrentiel, Synchrohouse Limited
Pour : CISO de Synchrohouse et direction
Rédigé par : Analyste junior, Vanguard Security
Date : 2026-11-28
Périmètre : footprinting de surfaces publiques uniquement, sur un environnement isolé et autorisé reproduisant les trois concurrents. Aucune exploitation, aucun pivot.

## 1. Résumé exécutif

Synchrohouse voulait savoir, avant d'arbitrer son budget de durcissement, lequel de ses trois concurrents est le modèle à suivre et lequel est le contre-exemple. Le footprinting des trois estates — Cerebra (Toronto), Yume (Tokyo), Verdant (Milan) — répond clairement.

Les trois entreprises exposent des surfaces très différentes, et cette différence est l'enseignement. **Cerebra** est le contre-exemple : sa posture transparente laisse voir un contrôleur d'automatisation de bâtiment (ICS) directement joignable depuis l'extérieur, un dépôt Git exposé qui révèle son historique, un format d'email trivialement déductible, et une de ses adresses IP est déjà signalée pour des rappels de type « command-and-control ». **Yume** mise sur l'obscurité (services cachés derrière des virtual hosts et des ports non standard) ; cette approche ralentit un scanner paresseux mais ne protège pas l'essentiel, puisqu'une clé d'API de production traîne dans l'historique de son dépôt et qu'un nom d'hôte interne fuit dans son certificat. **Verdant** est le plus discipliné : sa surface est la plus réduite, ses seules fuites sont des métadonnées de documents.

En appliquant une **métrique d'exposition unique et identique** aux trois (barème détaillé en §3), le classement est : **Cerebra 11, Yume 10, Verdant 2**. Cerebra est donc l'estate le plus exposé, et son **contrôleur ICS joignable (`cerebra.lab:47808`)** est l'actif unique le plus préoccupant du panel : un système touchant à la sécurité physique d'un bâtiment, atteignable sans authentification depuis l'extérieur.

Recommandation d'ensemble : **émuler Verdant** (minimiser la surface, ne rien exposer d'inutile), **traiter Cerebra comme un cas d'école à ne pas reproduire**, et retenir de Yume que **l'obscurité n'est pas de la sécurité**.

## 2. Profils par estate

### 2.1 Cerebra Buildings (cerebra.lab, Toronto) — posture transparente

**Surface d'exposition.** DNS riche et bavard : sous-domaines `www`, `mail`, `bms`, `portal`, `vpn`, `ns1/ns2`, et un environnement de développement oublié, **`dev-bms.cerebra.lab`**, découvert par énumération DNS. Services ouverts : SSH (22), SMTP (25), HTTP (80), un IDE web OpenVSCode (3000), un terminal web ttyd (3001), un dashboard Grafana « ForgeBuilding » (8080), et surtout un **contrôleur BACnet** sur 47808.

**Findings notables.**
- **Contrôleur ICS exposé** : `ForgeBuilding Controller/4.8` (BACnet-Management) joignable sur `cerebra.lab:47808` — l'actif le plus sensible du panel.
- **Dépôt Git exposé** (`/.git`) : l'historique révèle une page partenaires supprimée mentionnant une relation non publique, **Meridian Controls Ltd** (programme BMS conjoint).
- **Format d'email déductible** : `firstname.lastname@cerebra.lab`, confirmé par la page équipe et les committers Git.
- **Contexte de réputation** : l'IP `127.22.0.10` porte un score de réputation de 9 avec « scanning and C2 callbacks observed », et l'email `marie.dubois@cerebra.lab` apparaît dans la fuite récente **CloudLeak (2023)**.

**Maturité apparente : faible.** Transparence assumée mais indiscipline : un `.git` en production, un ICS exposé, des outils de dev (IDE, terminal web) accessibles.

### 2.2 Yume Building Systems (yume.lab, Tokyo) — posture d'obscurité

**Surface d'exposition.** Scan simple peu bavard : SSH (22), HTTP (80), HTTPS (443), et des ports non standard (2222, 3000, 3001, 9000). Les vrais services ne répondent qu'au bon en-tête `Host` ou sur des ports décalés.

**Findings notables.**
- **Fuite dans le certificat TLS** : le SAN liste `internal-bms.yume.lab`, un nom interne qui n'aurait jamais dû figurer dans un certificat public ; le certificat est de plus **auto-signé** (Issuer = Subject).
- **Virtual host caché** : `internal-bms.yume.lab`, révélé par fuzzing du Host header, sert une « Internal BMS Gateway » (interface opérationnelle restreinte). Recoupement net avec la fuite du certificat.
- **Service de management** : `YumeOps Console/2.3` sur le port 9000.
- **Secret dans le dépôt** : le `.git` exposé contient un commit « Stop tracking environment file » qui supprime `deploy.env` — mais la **clé d'API de production** `YBS_API_KEY` reste lisible dans l'historique (classée APIKEY).
- **Responsable IT identifié** : **Kenji Tanaka** (`k.tanaka@yume.lab`), recoupé entre la page équipe et les committers Git.

**Maturité apparente : moyenne.** L'effort d'obscurcissement est réel, mais contredit par un secret de production versionné et un certificat auto-signé qui fuit l'interne.

### 2.3 Verdant Systems (verdant.lab, Milan) — posture « document »

**Surface d'exposition.** La plus réduite : un site web sous `VerdantCMS 3.4.1`, un dossier `/documents/`, et peu d'autres services. Les fuites sont dans ce que Verdant **publie**.

**Findings notables.**
- **Métadonnées de documents** : un champ `Source Path` planté dans un PDF révèle le chemin interne `C:\Users\m.rossi\Templates\BMS\`, qui trahit à la fois l'arborescence interne et le format de login (`m.rossi` = Marco Rossi).
- **Endpoint non lié** : `robots.txt` désigne `/portal-internal/`, absent de la navigation, dont le fichier `status` expose un jeton de build.
- **CMS identifié** : `VerdantCMS/3.4.1`, fingerprinté via header, meta generator et X-Powered-By concordants.

**Maturité apparente : la plus élevée.** Surface minimale, pas d'ICS exposé, pas de secret versionné, pas de mauvaise réputation IP.

## 3. Analyse comparative

**Métrique unique, appliquée identiquement.** Chaque estate reçoit des points pondérés par pertinence sécurité : service ICS exposé (+4), service MGMT exposé (+3), secret versionné (+3), IP de mauvaise réputation + hit de fuite (+3), fuite de certificat (+2), gateway interne cachée (+2), `.git` exposé (+2), sous-domaine oublié (+1), format d'email déductible (+1), fuites documents/CMS (+1 chacune). Le script `11-compare.sh` calcule ce barème à partir des findings.

| Estate | Score | Forces | Faiblesses |
|---|---|---|---|
| **Cerebra** | **11** | Rien de caché à chercher longtemps (transparence) | ICS exposé, `.git` public, IP signalée C2, email déductible |
| **Yume** | **10** | Scan simple peu révélateur, services masqués | Secret de prod versionné, certificat auto-signé qui fuit l'interne |
| **Verdant** | **2** | Surface minimale, pas d'ICS ni de secret | Fuites de métadonnées (chemin interne, login) |

**Ce qui les différencie.** Chaque estate « cache » son intelligence différemment, et demande donc une technique différente : Cerebra se lit par **énumération DNS/certificats et récupération Git** ; Yume par **énumération de virtual hosts et de ports non standard** ; Verdant par **analyse de métadonnées de documents**. La leçon pour Synchrohouse : aucune posture unique ne suffit, et surtout **l'obscurité (Yume) ne compense pas une hygiène défaillante** (un secret versionné reste exposé quel que soit le port).

## 4. Recommandations pour Synchrohouse

**Le modèle à émuler : Verdant.** Sa discipline — surface minimale, aucun service sensible exposé, aucun secret versionné — est la posture cible. À copier : ne publier que le nécessaire, et surveiller ce qui fuit dans les documents (nettoyer les métadonnées avant publication).

**Le contre-exemple : Cerebra.** À ne surtout pas reproduire : un contrôleur ICS ne doit **jamais** être joignable depuis l'extérieur ; un dossier `.git` ne doit jamais être servi par le web ; les outils de dev (IDE, terminaux web) ne doivent pas être exposés.

**Le concurrent à craindre sur le plan opérationnel : Yume**, mais pour la mauvaise raison — sa posture d'obscurité peut donner un faux sentiment de sécurité. Synchrohouse doit en tirer l'inverse : ne pas confondre « difficile à scanner » et « sûr ».

**À durcir en priorité chez Synchrohouse, par analogie :**
1. Vérifier qu'aucun service ICS/BACnet n'est joignable depuis Internet (segmentation).
2. Scanner ses propres dépôts pour des secrets versionnés (gitleaks/trufflehog), et purger l'historique si besoin.
3. S'assurer qu'aucun `.git` n'est servi par les serveurs web.
4. Nettoyer les métadonnées des documents publiés (outil, auteur, chemins).
5. Utiliser des certificats émis par une autorité reconnue, sans nom interne dans le SAN.
6. Contrôler la réputation de ses plages IP et l'exposition de ses emails dans les fuites connues.

## 5. Méthodologie (technique et outil par finding)

| # | Finding | Estate | Outil / requête |
|---|---|---|---|
| 1 | Sous-domaine oublié `dev-bms` | Cerebra | `gobuster dns` + `dig TXT` (résolveur du lab) |
| 2 | Nom interne dans le SAN | Yume | `openssl s_client -connect yume.lab:443` + `openssl x509 -text` |
| 3 | Contrôleur ICS BACnet / console MGMT | Cerebra / Yume | `nmap -sT -p-` puis `nmap -sV` + `nc` sur le port |
| 4 | Virtual host caché `internal-bms` | Yume | `ffuf -H "Host: FUZZ.yume.lab"` + `curl -H "Host:"` |
| 5 | Outil dominant / chemin interne | Cerebra / Verdant | `wget -r` + `exiftool` (+ `uniq -c` pour la fréquence) |
| 6 | Page partenaires supprimée | Cerebra | `git-dumper` sur `/.git` + `git log -p` |
| 7 | CMS + endpoint non lié | Verdant | `whatweb` + lecture `robots.txt` + `curl` |
| 8 | Format email / responsable IT | Cerebra / Yume | page équipe + committers Git (recoupement 2 sources) |
| 9 | Secret APIKEY versionné | Yume | `git-dumper` + `git log -p` sur `deploy.env` |
| 10 | Fuite + réputation IP | Cerebra | `grep` sur `/opt/intel/breaches.txt` et `reputation.csv` |

Chaque finding critique a été **recoupé** avant d'être affirmé : `internal-bms.yume.lab` apparaît à la fois dans le certificat (T2) et comme vhost (T4) ; l'identité de Kenji Tanaka est confirmée par page équipe et Git (T8/T9) ; le format d'email Cerebra par page équipe et committers (T8).

## 6. Limites et incertitudes

**Ce que le footprinting seul ne peut pas confirmer.** On a établi l'**existence** et l'**exposition** d'actifs, pas leur **exploitabilité**. Le contrôleur ICS de Cerebra répond, mais on n'a ni tenté de l'authentifier ni vérifié ce qu'il permet réellement — par discipline et par périmètre (footprinting uniquement). Un 401/403 confirme qu'une ressource existe, sans autoriser à contourner le contrôle d'accès.

**Confirmé vs inféré.** Sont **confirmés** : les services et versions lus dans les bannières, les noms dans les certificats et le DNS, les champs de métadonnées, les secrets et pages dans l'historique Git, les lignes des corpus locaux. Sont des **inférences** : le format d'email généralisé à toute l'entreprise (déduit de quelques exemples concordants), la maturité « apparente » de chaque estate (jugement, non mesure), et la pondération du barème (§3), qui est défendable mais reste un choix d'analyste.

**Portée des corpus.** Les contextes de fuite et de réputation proviennent des corpus locaux fournis (`/opt/intel/`), non d'une interrogation de services réels ; ils valent pour cet exercice et à la date qu'ils portent.

**Environnement.** Les trois estates sont des reproductions isolées et autorisées ; aucune des vraies entreprises n'a été touchée.
