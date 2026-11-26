# Rapport de reconnaissance active, Astralis Cloud Services
Rédigé par : Spécialiste reconnaissance junior, Vanguard Security
Pour : Marcus Bauer, Lead Red Teamer, Vanguard Security
Date : 2026-11-26
Périmètre : reconnaissance active sous Rules of Engagement signées (intensité modérée, aucune sonde perturbatrice, aucune exploitation). Identification uniquement.

## 1. Résumé exécutif

Astralis Cloud Services présente une surface externe classique mais riche en information. Douze passes de reconnaissance ciblées ont cartographié l'autorité DNS, découvert des hôtes et services absents de la documentation publique, et convergé vers une exposition technique concrète et critique.

Trois constats sont décisifs pour la phase opérationnelle. D'abord, le portail client tourne sous nginx 1.20.1, une version porteuse d'une vulnérabilité critique connue (CVE-2021-23017, CVSS v3.1 9.8) : un point d'entrée immédiat par CVE. Ensuite, l'organisation expose des actifs internes qu'elle n'avait probablement pas l'intention de publier : un sous-domaine interne (internal-svc), un nom d'hôte interne dans le SAN du certificat du portail (internal-mgmt), un service d'administration sur un port non standard (54321), et un endpoint d'API surveillé par la page de statut mais absent de la documentation OpenAPI (/v1/internal-metrics). Enfin, un bucket de stockage objet au nom prévisible (astralis-prod-eu) existe et est protégé par contrôle d'accès, plutôt qu'absent.

La posture mail est partiellement durcie (DMARC appliqué en quarantine), et le portail est protégé par Cloudflare, ce qui conditionne toute action au niveau applicatif. Recommandation : la red team devrait prioriser le chemin de la CVE nginx et les actifs internes/non documentés pour la phase d'énumération, en traitant la couche Cloudflare comme une contrainte sur le sondage applicatif direct. Tous les constats ont été obtenus en mode passif à modéré, et aucun n'a été exploité ; la limite du périmètre a été respectée.

## 2. Cartographie de l'infrastructure

### 2.1 Topologie réseau
L'infrastructure Astralis résout, dans le lab, vers la plage 127.20.0.0/24, derrière un hébergement virtuel par nom (une requête par IP sans Host correspondant renvoie « Not Found »). Hôtes connus :
- astralis-cloud.example → 127.20.0.10 (frontend web principal, port 3000 ouvert)
- internal-svc.astralis-cloud.example → 127.20.0.20
- admin.astralis-cloud.example → 127.20.0.30 (service admin sur 54321/tcp)
- api.astralis-cloud.example → 127.20.0.50 (API HTTPS/443, « astralis-api » v1)
- portal.astralis-cloud.example (portail client, HTTPS)
- status.astralis-cloud.example (page de statut)

Attribution réseau : l'espace IP public est annoncé sous AS64500 (obtenu en live par attribution BGP).

### 2.2 Structure DNS
- Nameserver autoritaire primaire : ns1.astralis-cloud.example (issu du SOA / jeu NS).
- Des enregistrements MX, SPF et DMARC sont publiés (voir 4.4).
- Le bruteforce actif a fait surgir des hôtes au nom interne absents des sources passives (internal-svc), confirmant la leçon de Tomas : le travail DNS approfondi révèle ce que le scan de surface manque.

### 2.3 Services exposés
- Frontend web (nginx) sur le portail et le site principal.
- Service admin sur le port non standard 54321/tcp (hôte admin).
- API REST (astralis-api v1) sur l'hôte api, en HTTPS.
- Bucket de stockage objet astralis-prod-eu (nommage de type S3).

## 3. Inventaire des services et versions

| Service | Hôte | Version / détail | Tâche source |
|---|---|---|---|
| Serveur web (portail) | portal.astralis-cloud.example | nginx/1.20.1 | T5 |
| WAF/CDN | portal.astralis-cloud.example | Cloudflare | T9 |
| API REST | api.astralis-cloud.example | astralis-api v1 (documentée OpenAPI) | T11 |
| Service admin | admin.astralis-cloud.example | TCP 54321 (service indéterminé) | T4 |
| Politique mail | astralis-cloud.example | DMARC p=quarantine | T8 |

## 4. Surface d'attaque identifiée

### 4.1 DNS
- Nameserver primaire autoritaire ns1.astralis-cloud.example identifié.
- Sous-domaine interne internal-svc.astralis-cloud.example découvrable uniquement par bruteforce actif — un actif que l'opérateur considère probablement comme non public.

### 4.2 Réseau
- Port administratif non standard 54321/tcp ouvert sur l'hôte admin. Déplacer un service d'admin dans la plage éphémère est de l'obscurité faible, pas une protection ; c'est entièrement énumérable.
- Réseau annoncé sous l'ASN AS64500.

### 4.3 Application
- Portail client sous nginx 1.20.1, vulnérable à CVE-2021-23017 (CVSS 9.8).
- Chemin administratif divulgué par robots.txt : /admin/dashboard.
- Endpoint d'API non documenté https://api.astralis-cloud.example/v1/internal-metrics — référencé par les health checks de la page de statut mais absent de la spec OpenAPI publiée.
- Le SAN du certificat TLS du portail fuit le nom d'hôte interne internal-mgmt.astralis-cloud.example.
- Le WAF Cloudflare protège le portail et doit être pris en compte dans tout test applicatif.

### 4.4 Mail
- Politique DMARC appliquée en p=quarantine : l'organisation surveille et met en quarantaine le courrier non authentifié. Cela limite la crédibilité des prétextes par email.

### 4.5 Cloud
- Bucket de stockage objet astralis-prod-eu : il existe et renvoie une réponse sous contrôle d'accès (pas de 404), confirmant son existence sans divulgation de contenu. Aucun listing n'a été effectué.

## 5. Cibles prioritaires pour l'énumération

1. **nginx 1.20.1 sur le portail (CVE-2021-23017)** — priorité maximale : une CVE critique confirmée sur un service exposé sur Internet est le chemin le plus direct. Justification : sévérité 9.8, version confirmée en live.
2. **/v1/internal-metrics (API non documentée)** — élevée : surveillée en interne mais non listée, un endpoint fantôme classique. Justification : convergence entre la référence de la page de statut et l'absence dans OpenAPI.
3. **Actifs internes internal-mgmt / internal-svc** — élevée : des noms à vocation interne exposés publiquement, probablement moins durcis. Justification : nommage interne + fuite via certificat/DNS.
4. **Service admin sur 54321/tcp et chemin admin du robots.txt** — moyenne-élevée : surfaces administratives, protégées par la seule obscurité.
5. **Bucket astralis-prod-eu** — moyenne : protégé mais nommé ; à énumérer (permissions) dans une phase ultérieure.

## 6. Documentation de la méthodologie

Chaque flag a été produit par un script Bash d'une seule ligne respectant les RoE (timeouts bornés, intensité de scan modérée). Cible et sortie ci-dessous.

1. **Nameserver primaire** — cible astralis-cloud.example → sortie `ns1.astralis-cloud.example`
   `dig NS astralis-cloud.example +short | sort | head -n1 | sed 's/\.$//'`
2. **Sous-domaine caché** — cible *.astralis-cloud.example → sortie `internal-svc.astralis-cloud.example`
   `while read s; do dig +short "$s.astralis-cloud.example" | grep -q . && echo "$s.astralis-cloud.example"; sleep 1; done < wordlist.txt | grep -E 'internal|backend|admin' | head -1`
3. **ASN** — cible IP d'astralis-cloud.example → sortie `AS64500`
   `curl -s -m 10 "https://api.bgpview.io/ip/$(dig astralis-cloud.example +short | head -1)" | jq -r '.data.prefixes[0].asn.asn' | awk '{print "AS"$1}'`
4. **Port admin** — cible admin.astralis-cloud.example → sortie `54321`
   `nmap -sT -T2 --scan-delay 10ms -p 49152-65535 admin.astralis-cloud.example | grep '/tcp' | grep open | cut -d/ -f1`
5. **Version serveur web du portail** — cible portal.astralis-cloud.example → sortie `nginx/1.20.1`
   `curl -s --head https://portal.astralis-cloud.example | grep -i '^server:' | awk '{print $2}' | tr -d '\r'`
6. **Entrée SAN interne** — cible portal.astralis-cloud.example:443 → sortie `internal-mgmt.astralis-cloud.example`
   `echo | openssl s_client -connect portal.astralis-cloud.example:443 -servername portal.astralis-cloud.example 2>/dev/null | openssl x509 -noout -text | grep -oE 'DNS:[^,]+' | grep -E 'internal|backend|admin|mgmt' | sed 's/DNS://' | head -1`
7. **Chemin admin depuis robots.txt** — cible portal.astralis-cloud.example/robots.txt → sortie `/admin/dashboard`
   `curl -sk https://portal.astralis-cloud.example/robots.txt | grep "Disallow:" | grep -iE 'admin|manage|backend|console' | head -1 | awk '{print $2}'`
8. **Politique DMARC** — cible _dmarc.astralis-cloud.example → sortie `quarantine`
   `dig +short TXT _dmarc.astralis-cloud.example | grep -oE 'p=(none|quarantine|reject)' | cut -d= -f2 | tr -d ' "'`
9. **Fournisseur WAF** — cible portal.astralis-cloud.example → sortie `Cloudflare`
   `wafw00f https://portal.astralis-cloud.example -f json -o /dev/stdout 2>/dev/null | jq -r '.[0].firewall' || curl -skI https://portal.astralis-cloud.example | grep -i 'X-Served-By' | awk '{print $2}' | tr -d '\r'`
10. **Bucket de stockage** — cible *.s3.amazonaws.com → sortie `astralis-prod-eu`
   `for s in prod dev backup backups data assets static media logs prod-eu prod-eu-west storage files; do printf '%s astralis-%s\n' "$(curl -s -m 10 -o /dev/null -w '%{http_code}' "https://astralis-$s.s3.amazonaws.com/")" "$s"; done | grep -E '^(200|301|302|307|403) ' | awk '{print $2; exit}'`
11. **Endpoint API non documenté** — cible hôtes status + api → sortie `https://api.astralis-cloud.example/v1/internal-metrics`
   `for u in $(curl -sk https://status.astralis-cloud.example/api/v2/summary.json | jq -r '.components[].check' | grep -vf <(curl -sk https://api.astralis-cloud.example/v1/docs/openapi.json | jq -r '.paths|keys[]')); do curl -sk -o /dev/null -w '%{http_code}' "$u" | grep -qE '^(200|301|302|401|403)$' && echo "$u"; done | awk '{print; exit}'`
12. **CVE critique** — cible NVD par CPE → sortie `CVE-2021-23017`
   `s=$(curl -s --head https://portal.astralis-cloud.example | grep -i '^server:' | awk '{print $2}' | tr -d '\r'); product=${s%/*}; version=${s#*/}; curl -s -m 25 "https://services.nvd.nist.gov/rest/json/cves/2.0?cpeName=cpe:2.3:a:$product:$product:$version:*:*:*:*:*:*:*" | jq -r '.vulnerabilities[] | [(.cve.metrics.cvssMetricV31[0].cvssData.baseScore // 0), .cve.id] | @tsv' | sort -rn | head -1 | grep -oE 'CVE-[0-9]+-[0-9]+'`

## 7. Limites et incertitudes

- Tous les hôtes résolvent vers des adresses internes au lab ; l'attribution externe (ASN) a été obtenue via une API BGP tierce et reflète le préfixe annoncé au moment de la requête, pas un fait garanti actuel.
- Le service admin sur 54321/tcp a été identifié comme ouvert mais non caractérisé ; sa nature reste indéterminée.
- La reconnaissance s'est limitée à l'identification : aucun contenu de bucket listé, aucun endpoint exercé, aucune CVE exploitée. La joignabilité et l'exploitabilité de CVE-2021-23017 devront être confirmées dans la phase d'énumération/exploitation autorisée.
- Le fronting Cloudflare peut masquer le comportement de l'origine ; les réponses observées sont des réponses de bord, pas nécessairement celles du serveur d'origine.
- Les scans étaient bornés (timing modéré, scan-delay, timeouts) ; des services ne répondant qu'à un sondage plus agressif ont pu ne pas apparaître.

## Annexe A : Index script → flag

| Script | Constat | Valeur du flag |
|---|---|---|
| 1-nameserver.sh | Nameserver primaire | ns1.astralis-cloud.example |
| 2-hidden_subdomain.sh | Sous-domaine caché | internal-svc.astralis-cloud.example |
| 3-asn.sh | ASN | AS64500 |
| 4-admin_port.sh | Port admin | 54321 |
| 5-portal_version.sh | Serveur web du portail | nginx/1.20.1 |
| 6-san_entry.sh | Entrée SAN interne | internal-mgmt.astralis-cloud.example |
| 7-admin_path.sh | Chemin admin | /admin/dashboard |
| 8-dmarc.sh | Politique DMARC | quarantine |
| 9-waf.sh | Fournisseur WAF | Cloudflare |
| 10-bucket.sh | Bucket de stockage | astralis-prod-eu |
| 11-undoc_endpoint.sh | Endpoint non documenté | https://api.astralis-cloud.example/v1/internal-metrics |
| 12-cve.sh | CVE critique | CVE-2021-23017 |
