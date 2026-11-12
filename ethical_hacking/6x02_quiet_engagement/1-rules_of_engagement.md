# Rules of Engagement, Lumen Industrial Systems

## Engagement Metadata
- **Client :** Lumen Industrial Systems s.r.o., Brno, République tchèque
- **Prestataire :** Vanguard Security
- **Référence de la mission :** VS-LUMEN-2026-PT01
- **Type de mission :** test d'intrusion externe (méthode PTES), preuve de conformité NIS2
- **Fenêtre de mission :** 2 semaines, du 23/11/2026 au 04/12/2026
- **Signataires côté client :** le CISO de Lumen (responsable autorisant) et un représentant légal habilité à engager l'entreprise
- **Signataires côté prestataire :** l'associé senior de Vanguard et le consultant en charge

## Scope
### In Scope
- La plateforme d'analyse hébergée dans le cloud (application web), sur ses domaines de production et, s'il est fourni, de pré-production
- L'API publique exposée par la plateforme
- Le panneau d'administration interne exploité par Lumen
- La passerelle de démonstration hébergée en interne par Lumen pour la qualité et les démos commerciales
- Le broker MQTT de démonstration hébergé en interne par Lumen
- La reconnaissance passive (OSINT) de l'empreinte publique de Lumen (DNS, site vitrine, pages en cache, références publiques d'employés et de partenaires)

### Out of Scope
- Les passerelles et capteurs IoT installés chez les clients industriels de Lumen. **Justification légale :** Lumen ne possède ni n'exploite cette infrastructure et n'a aucune autorité légale pour autoriser des tests sur des biens appartenant à des tiers. Le fait que ces actifs soient techniquement joignables depuis la position d'énumération ne confère aucune autorisation.
- Les réseaux internes des clients industriels et tout système appartenant à un client. **Justification légale :** idem ; tout test exige l'autorisation du propriétaire de l'actif.
- L'infrastructure sous-jacente du fournisseur cloud. **Justification légale :** elle appartient au fournisseur ; seuls le compte et les ressources propres de Lumen sont concernés.
- Les tests de déni de service et de charge contre la production. **Justification légale :** risque opérationnel disproportionné pour un service de surveillance industrielle en production ; exclus pour protéger l'activité des clients.
- L'ingénierie sociale contre les employés de Lumen, sauf autorisation écrite séparée.

## Testing Window
- **Jours :** du lundi au vendredi
- **Heures :** 9 h – 18 h (heure d'Europe centrale), afin qu'un incident soit traité par une équipe présente
- **Fuseau horaire :** heure d'Europe centrale (CET/CEST)
- **Périodes interdites :** aucun test actif pendant une fenêtre critique de production déclarée par le client ou une session d'audit client ; toute date signalée par le CISO de Lumen

## Communication and Escalation
- **Contact principal (client) :** le CISO de Lumen, joignable par téléphone et par email pendant la fenêtre de test
- **Contact secondaire (client) :** le responsable DevOps / plateforme de Lumen
- **Contact prestataire :** le consultant en charge chez Vanguard ; escalade vers l'associé senior
- **Canal :** email chiffré pour les découvertes et les rapports ; téléphone pour les urgences, confirmé ensuite par écrit
- **Délais de réponse :** découverte critique signalée par téléphone sous 1 heure ; point d'avancement quotidien par email ; accusé de réception du client attendu sous 1 jour ouvré
- **Vérification d'identité :** toute demande inhabituelle est vérifiée en rappelant un numéro connu

## Authorised Tools, Forbidden Tools
- **Autorisés :** outils standards de reconnaissance et de test (par exemple nmap, outils d'énumération HTTP, Burp Suite, un client MQTT), charges écrites à la main
- **Interdits :** **Metasploit pour l'accès initial** (contrainte du projet) ; la charge d'upload de fichier polyglotte doit être écrite à la main ou être une technique publique documentée, défendable dans le journal d'actions. Metasploit n'est utilisable que pour des tâches utilitaires de post-exploitation, lorsque ce choix est documenté et défendable.
- **Techniques interdites :** déni de service, actions destructrices, modification ou suppression de données de production, toute interaction avec un actif hors périmètre

## Stop Conditions
Les tests s'arrêtent immédiatement si :
- un actif hors périmètre ou appartenant à un client est trouvé joignable (le consigner, ne pas y toucher, escalader au CISO)
- une dégradation du service de surveillance en production est constatée
- des traces d'une compromission préexistante par un tiers sont découvertes
- un volume important de données personnelles ou clients réelles est exposé de façon inattendue
- le client demande l'arrêt
La reprise nécessite l'accord écrit du CISO.

## Data Handling
- Accéder au minimum de données nécessaire pour démontrer l'impact ; démontrer les fuites de données avec les propres données de test du prestataire quand c'est possible.
- Aucune exfiltration de données clients ou personnelles réelles ; les preuves se limitent à des captures d'écran masquées et à des extraits minimaux.
- Stockage : chiffré, à accès contrôlé, au sein de l'Union européenne.
- Conservation : données de travail et preuves conservées 90 jours après la remise du rapport final, pour soutenir l'audit NIS2, puis détruites.
- Destruction : un certificat de destruction écrit est remis au client.

## Post-Engagement Obligations
- **Calendrier de rapport :** rapport provisoire sous 5 jours ouvrés après la fin des tests ; rapport final sous 10 jours ouvrés, à temps pour le dossier de conformité NIS2.
- **Conservation des preuves :** journal d'actions et preuves conservés pendant la fenêtre de support d'audit (90 jours), disponibles sur demande pour les auditeurs du client.
- **Support d'audit :** le consultant en charge reste disponible pour répondre aux questions des auditeurs sur le rapport pendant 30 jours après la remise.

## Signatures
- **Pour Lumen Industrial Systems :** ______________________  Nom / Fonction / Date
- **Pour Vanguard Security :** ______________________  Nom / Fonction / Date
