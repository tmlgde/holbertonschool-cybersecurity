# Notes DNS — Tâche 1

## Finding 1 : sous-domaine de staging
- Valeur : staging-quote.helix-maritime.example
- Source : http://10.42.88.75/dns-intelligence/certificates
- Type : certificat TLS (SAN)
- Validité : 2025-03-04 -> 2025-06-02
- Date de récupération : 2026-11-24

## Finding 2 : ancien sous-domaine avec SSL expiré
- Valeur : hlx-owa01.helix-maritime.example
- Source : http://10.42.88.75/dns-intelligence/certificates
- Type : certificat TLS (SAN), expiré
- Validité : 2018-09-10 -> 2021-09-10
- Date de récupération : 2026-11-24

## Finding 3 : IP du serveur mail
- Valeur : 198.51.100.25
- Source : http://10.42.88.75/dns-intelligence/history
- Type : MX (mail.helix-maritime.example) + A
- Observé : 2014-06-01 -> 2024-09-30 (historique)
- Date de récupération : 2026-11-24

## Finding 4 : enregistrement TXT (service tiers)
- Valeur : v=spf1 include:spf.zephyrmail.example include:spf.marlinmail.example -all
- Source : http://10.42.88.75/dns-intelligence/history
- Type : TXT (SPF)
- Observé : 2024-08-10 -> 2025-05-28
- Date de récupération : 2026-11-24
