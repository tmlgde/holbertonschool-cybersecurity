# Vulnerabilities Identified — Helix Maritime Insurance

## Vulnerability 1: Deducible email pattern enables targeted phishing
- Description: The corporate email pattern (firstname.lastname@helix-maritime.example) is deducible from commit metadata and PDF properties, and combined with named targets and their roles it allows credible spear-phishing against the whole organisation. Helix has already suffered a phishing incident, and the SPF record authorises a third-party campaign sender (Marlinmail) whose mail passes authentication checks.
- Source findings: `3-pdf_metadata_notes.md` Finding 1, `9-employee_notes.md` Findings 1 and 2, `5-press_notes.md` Finding 2, `1-dns_notes.md` Finding 4, `7-jobs_notes.md` Finding 3
- Risk level: high. Rationale: phishing is the dominant initial-access vector in financial services; a prior incident proves the vector is realistic; Helix's regulated profile makes a compromise materially damaging.
- Exploitation potential: social engineering (spear-phishing)

## Vulnerability 2: Exact software versions expose known vulnerabilities
- Description: The exact versions of the CMS (Veridian CMS 5.2.1) and the internal CRM (Nimbus CRM 9.4 Enterprise Edition) are published. Knowing precise versions lets an attacker look up version-specific CVEs and prepare an exploit before any active reconnaissance, instead of fingerprinting blindly.
- Source findings: `2-source_code_notes.md` Finding 3, `7-jobs_notes.md` Finding 1
- Risk level: medium. Rationale: this is a reconnaissance weakness that facilitates an attack rather than being one itself, but it meaningfully shortens an attacker's path.
- Exploitation potential: technical

## Vulnerability 3: Internal targets mapped from public sources
- Description: Passive collection already names internal targets an attacker would otherwise have to discover: an internal API endpoint (/v2/quote-engine), an internal application host (hlx-app-03), and a forgotten staging environment (staging-quote) that source comments flagged for removal. Once active reconnaissance is authorised (M8), these can be probed directly; staging environments are typically less hardened than production.
- Source findings: `2-source_code_notes.md` Findings 1 and 2, `8-social_notes.md` Finding 3, `1-dns_notes.md` Finding 1
- Risk level: medium. Rationale: the attack surface is reduced and pre-mapped for the attacker, but nothing is yet compromised and exploitation depends on later active reconnaissance.
- Exploitation potential: technical

## Vulnerability 4: Security lead over-exposes location and routine
- Description: The infrastructure and security lead (Joris Bakker) is linkable to a GPS fitness profile (harbour_runner_92) whose runs all start and finish at the Helix office, early each morning before work. This exposes a recurring location and time window for a key individual — ironically the person responsible for security.
- Source findings: `9-employee_notes.md` Findings 1 and 4
- Risk level: medium. Rationale: physical-security and tracking exposure of a key employee; no system access, but a precise human target.
- Exploitation potential: social engineering

## Vulnerability 5: Historical relationships provide credible pretexts
- Description: Archived pages reveal a former CFO (Reinier Hofstede) and a removed strategic reinsurer (Nordstern Re). An attacker can use these past relationships as pretexts to build trust in a social-engineering approach. (The discontinued IT vendor Calypso is explicitly ruled out as a decoy, not a strategic partner.)
- Source findings: `4-web_archive_notes.md` Findings 1 and 2
- Risk level: medium. Rationale: strengthens a phishing or pretext approach; no standalone technical weakness.
- Exploitation potential: social engineering

## Vulnerability 6: Operational leak via corporate photo and public event
- Description: An unvetted whiteboard photo on the corporate feed exposed the internal roadmap at once: mailbox migration, a dated CRM go-live, the Tidewater v2 target host, post-phishing SPF/DMARC hardening, and the owners (dvries, P. Janssen). A publicly announced appearance (Rotterdam Maritime Week 2025) adds a further timing pretext.
- Source findings: `8-social_notes.md` Findings 2 and 3
- Risk level: medium. Rationale: a single image disclosed infrastructure, schedule and personnel, each usable to sharpen a later attack.
- Exploitation potential: social engineering
