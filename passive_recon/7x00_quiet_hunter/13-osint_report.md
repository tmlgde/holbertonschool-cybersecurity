# OSINT Intelligence Report — Helix Maritime Insurance
Prepared by: Junior OSINT Analyst, Vanguard Security
For: Marcus Bauer, Lead Red Teamer, Vanguard Security
Date: 2026-11-24
Classification: Internal — Vanguard Red Team Only
Collection discipline: passive only. No active reconnaissance, scanning, authentication, or exploitation was performed. All evidence is drawn from published, observable sources inside the engagement scope.

## 1. Executive summary

Helix Maritime Insurance is a mid-size, privately held marine insurer headquartered in Rotterdam, regulated in the Netherlands, with secondary desks in Singapore and Piraeus. Its registered identity, leadership, technology stack and a substantial part of its internal operational context are all recoverable from public sources alone.

The central finding of this assessment is that Helix's technical perimeter is modest and conventional, but its **people-and-document surface leaks heavily**. The organisation publishes enough to let an outside observer reconstruct its corporate email format, identify named individuals and their roles, enumerate its core software with exact versions, and even read an internal project roadmap from an unvetted photograph. The highest-leverage attack paths are therefore social-engineering vectors grounded in genuine, verifiable internal context, not technical exploitation of exposed infrastructure.

Three conditions make these vectors unusually credible. First, the corporate email pattern (firstname.lastname@helix-maritime.example) is deducible and generalises to the whole organisation. Second, Helix has already suffered a targeted phishing incident (May 2024), which proves the vector is realistic against this specific target. Third, the SPF record authorises a third-party campaign sender whose mail passes authentication, giving an attacker a legitimate-looking delivery channel.

Recommendation: the red team should prioritise spear-phishing against named technical personnel using job-application and vendor/migration pretexts, supported by the operational detail recovered in Movement 1. The technical exposures (internal API endpoint, a forgotten staging host, an internal application host) should be logged for the active phase but not treated as confirmed access today. This report is built to let planning begin without returning to the analyst for clarification.

## 2. Synthesized corporate profile

### 2.1 Organizational structure

Helix Maritime Insurance N.V. is registered with the Dutch Kamer van Koophandel under number 24418876, founded 14-03-2009, with a declared paid-up capital of EUR 2.500.000 and a registered seat at Wilhelminakade 909, 3072 AP Rotterdam (Appendix: T6-F1, T6-F2, T6-F3). The authoritative registry lists 142 employees — materially below the ~220 figure circulated informally — and records M. van der Velde as director and M. Larsen as authorised signatory (financial director) since January 2024.

Current leadership includes Margriet van der Velde (CEO, co-founder), Sven Aaltonen (CTO), Anneke Visser (Head of Underwriting), Marit Larsen (CFO, joined early 2024), and regional directors in Singapore (Li Wei Chen) and Piraeus (Dimitris Papadakis). Historical records show the CFO role was previously held by Reinier Hofstede, no longer with the firm (T4-F1); this is labelled historical and used only as pretext context.

The technology function is small and named. Pieter Janssen is Engineering Manager and reviews technical applications (T7-F3); Daan de Vries (username "dvries", developer id DEV-2291) is a senior software engineer who maintains the corporate site build and the risk-platform repository (T2-F1, T9-F2); Joris Bakker is Infrastructure & Security Lead (T9-F1); Marleen Koster runs communications and the corporate social channel (T3-F2, T8-F1, T9-F3).

### 2.2 Technical surface

- Corporate website: Veridian CMS 5.2.1, built with Vite, served by Nginx; front end in React/TypeScript (T2-F3, T10-F1).
- Internal platform: the "Tidewater Risk Engine", primarily Kotlin on the JVM (T5-F1, T7-F2).
- Internal CRM: Nimbus CRM 9.4 Enterprise Edition, used across the commercial floor (T7-F1).
- Email: migrated in 2024 from a self-hosted Microsoft Exchange server (legacy hosts hlx-owa01, hlx-mail01 / 198.51.100.25) to the managed provider Zephyrmail; SPF also authorises Marlinmail, a third-party campaign sender (T1-F2, T1-F3, T1-F4, T10-F2).
- Exposed internal references (documented only, never probed): an internal API endpoint https://api-internal.helix-maritime.example/v2/quote-engine (T2-F2); an internal application host hlx-app-03.helix-maritime.example (T8-F3); a forgotten staging environment staging-quote.helix-maritime.example (T1-F1), which source comments flagged for removal.
- Cloud: Meridian Cloud Systems is named as the primary cloud partner in a conference talk but appears nowhere on the corporate site (T5-F3).

Naming convention: internal hosts follow hlx-<role><number> (hlx-owa01, hlx-mail01, hlx-app-03), an inference supported by three independent observations.

### 2.3 Social footprint

The brand operates a corporate feed ("@helixmaritime") managed by Marleen Koster, identifiable from a recurring "— M.K." signature corroborated across humans.txt, PDF authorship and a whiteboard caption (T8-F1). The feed announced an upcoming appearance at Rotterdam Maritime Week 2025 (September), absent from the corporate site (T8-F2), and published a sprint-planning photograph whose whiteboard disclosed the internal roadmap: mailbox migration to ZephyrMail Business, a dated Nimbus CRM go-live, the Tidewater v2 target host hlx-app-03, post-phishing SPF/DMARC hardening, and the owners dvries and P. Janssen (T8-F3).

Employee profiles are recoverable and cross-linkable. Marleen Koster's profile exposes a personal direct line, +31 10 555 0173 (T9-F3). The Infrastructure & Security Lead, Joris Bakker, is linkable to a GPS fitness profile (harbour_runner_92) whose runs all start and finish at the registered office early each morning, exposing a workplace-anchored routine for the most security-sensitive individual (T9-F4).

## 3. Vulnerabilities identified

(Synthesized from Task 11; each item cites the underlying Movement 1 notes.)

1. **Deducible email pattern enables targeted phishing.** The firstname.lastname@ pattern generalises to the whole organisation and combines with named targets and a prior phishing incident. Sources: `3-pdf_metadata_notes.md` F1; `9-employee_notes.md` F1, F2; `5-press_notes.md` F2; `1-dns_notes.md` F4. Risk: high. Category: social engineering.
2. **Exact software versions expose known vulnerabilities.** Veridian CMS 5.2.1 and Nimbus CRM 9.4 Enterprise Edition allow version-specific CVE research ahead of any active phase. Sources: `2-source_code_notes.md` F3; `7-jobs_notes.md` F1. Risk: medium. Category: technical.
3. **Internal targets mapped from public sources.** An internal API endpoint, an internal application host and a forgotten staging environment are pre-identified for the active phase; staging is typically less hardened. Sources: `2-source_code_notes.md` F1, F2; `8-social_notes.md` F3; `1-dns_notes.md` F1. Risk: medium. Category: technical.
4. **Security lead over-exposes routine.** A privileged individual's workplace-anchored routine and interests are recoverable via a fitness profile. Sources: `9-employee_notes.md` F1, F4. Risk: medium. Category: social engineering.
5. **Historical relationships provide credible pretexts.** A former CFO and a removed strategic reinsurer support trust-building pretexts. Sources: `4-web_archive_notes.md` F1, F2. Risk: medium. Category: social engineering.
6. **Operational leak via corporate photo and public event.** One unvetted whiteboard photo disclosed infrastructure, schedule and personnel; a public appearance adds a timing pretext. Sources: `8-social_notes.md` F2, F3. Risk: medium. Category: social engineering.

## 4. Attack vectors recommended

(Synthesized from Task 12.)

**Vector A — Spear-phish of the technical hiring manager (job-application pretext).** Pieter Janssen publicly reviews Security Engineer applications and welcomes informal contact; a weaponised "CV.pdf" to his address, in the confirmed email format, is consistent with his normal workflow. Prerequisites: `7-jobs_notes.md` F3; `9-employee_notes.md` F1, F2; `5-press_notes.md` F2. Impact: initial access on a technology-team endpoint adjacent to the Tidewater platform.

**Vector B — Mass credential phishing (mailbox-migration pretext).** A "ZephyrMail Business" re-confirmation notice matches a migration staff genuinely experienced; delivery via Marlinmail passes SPF. Prerequisites: `1-dns_notes.md` F3, F4; `5-press_notes.md` F2; `8-social_notes.md` F3. Impact: large-scale mailbox credential theft and business-email compromise.

**Vector C — Personalised phishing of the security lead.** A highly tailored lure built on Joris Bakker's recoverable routine and interests, delivered to his corporate address. Prerequisites: `9-employee_notes.md` F1, F4; `6-registry_notes.md` F1. Impact: compromise of a high-privilege infrastructure/security account.

## 5. Targeting recommendations

- **Prioritised personas:** (1) Pieter Janssen, Engineering Manager — a workflow that normalises inbound attachments. (2) Joris Bakker, Infrastructure & Security Lead — highest privilege, highest personal exposure. (3) The general employee population for the migration-pretext campaign.
- **Prioritised vectors, in order:** Vector A (highest credibility-to-noise ratio), then Vector B (breadth), then Vector C (high value, requires care given the target's role).
- **Pretext inventory ready for use:** the Security Engineer vacancy; the 2024 mailbox migration to Zephyrmail; the Rotterdam Maritime Week 2025 appearance; the Meridian Cloud Systems relationship; the former CFO and former reinsurer for trust-building.
- **Indicators of red-team readiness:** confirmed email format; named targets with roles and at least one direct line; a legitimate SPF-passing delivery channel (Marlinmail); exact software versions for payload and lure selection; a prior-incident precedent demonstrating susceptibility.
- **Confidence and limitations:** email addresses beyond those observed are inferences from a confirmed pattern. Internal endpoints and hosts are documented, not tested; their reachability and state are unknown until the authorised active phase. Employee counts and leadership reflect the 2025-05-30 registry extract and may have changed.

## 6. Decoys ruled out

The following were identified as deliberate decoys and are NOT treated as authentic intelligence:
- `helix-maritime-insurance.example` (registrant "Helix Insurance Brokers LLP") — lookalike domain, distinct organisation (CT logs, /dns-intelligence/certificates).
- Joris Bakker, Logistics Coordinator at Batavia Freight BV, Amsterdam — homonym of the security lead; different employer, city and field (/social/employees/joris-bakker-decoy).
- `decoy-market-analysis.pdf` (Westport Analytics Ltd) — third-party document, not authored by Helix (T3).
- `helix-dev99` — public fork with no original contributions and no corroboration linking it to Helix (T9).
- Calypso Underwriting Systems — discontinued IT vendor, explicitly not a strategic partner (T4).
- `cdn-test.helix-maritime.example` (203.0.113.40) — short-lived CDN experiment, unrelated to mail (T1).
- Meridian Marine Reinsurance vs Meridian Cloud Systems — name collision between a reinsurer and the cloud partner; distinct entities (T5).

## Appendix A: Source documentation

Format: ID — value — notes file — lab source URL — date — corroboration.

### Task 1 — DNS & subdomains (`1-dns_notes.md`)
- T1-F1 — staging-quote.helix-maritime.example — http://[PROVIDED_IP]/dns-intelligence/certificates — cert validity 2025-03-04→2025-06-02 — corroborated by T2-F1 (staging-quote TODO).
- T1-F2 — hlx-owa01.helix-maritime.example (legacy, expired) — http://[PROVIDED_IP]/dns-intelligence/certificates — 2018-09-10→2021-09-10 (historical) — corroborates hlx-<role><number> convention.
- T1-F3 — 198.51.100.25 (historical mail server) — http://[PROVIDED_IP]/dns-intelligence/history — observed 2014-06-01→2024-09-30 (historical) — internal label hlx-mail01.
- T1-F4 — SPF: v=spf1 include:spf.zephyrmail.example include:spf.marlinmail.example -all — http://[PROVIDED_IP]/dns-intelligence/history — observed 2024-08-10→2025-05-28 — corroborated by T8-F3.

### Task 2 — Source code (`2-source_code_notes.md`)
- T2-F1 — dvries (developer id DEV-2291) — http://[PROVIDED_IP]/ — HTML comment, page source line 22 — corroborated by humans.txt and T9-F2.
- T2-F2 — https://api-internal.helix-maritime.example/v2/quote-engine — http://[PROVIDED_IP]/assets/legacy-app.js (referenced in http://[PROVIDED_IP]/robots.txt) — documented only, not queried.
- T2-F3 — Veridian CMS 5.2.1 — http://[PROVIDED_IP]/ — meta generator, page source line 14 — corroborated by humans.txt and /technology (T10-F1).

### Task 3 — PDF metadata (`3-pdf_metadata_notes.md`)
- T3-F1 — document.services@helix-maritime.example — helix-annual-report-2024.pdf — http://[PROVIDED_IP]/documents/helix-annual-report-2024.pdf — Creator field — corroborates internal, non-public address.
- T3-F2 — Marleen Koster — marine-summit-sponsorship.pdf — http://[PROVIDED_IP]/documents/marine-summit-sponsorship.pdf — Author — corroborated by T8-F1.
- T3-F3 — Helix DocForge 3.2 — asia-pacific-expansion.pdf — http://[PROVIDED_IP]/documents/asia-pacific-expansion.pdf — Creator/Producer — present across all Helix PDFs.
- T3-F4 — D:\Helix\Marketing\Reports\apac-expansion-final.indd — asia-pacific-expansion.pdf — http://[PROVIDED_IP]/documents/asia-pacific-expansion.pdf — Original Path.

### Task 4 — Web archive (`4-web_archive_notes.md`)
- T4-F1 — Reinier Hofstede, former CFO — http://[PROVIDED_IP]/archive/2023/team — snapshot 2023-05-09 (historical) — current page: http://[PROVIDED_IP]/company/team.
- T4-F2 — Nordstern Re, removed strategic reinsurer — http://[PROVIDED_IP]/archive/2023/partners — snapshot 2023-05-09 (historical) — current page: http://[PROVIDED_IP]/company/partners.
- T4-F3 — Scheepvaartkade 12, 3011 BR Rotterdam (+31 10 555 0102) — http://[PROVIDED_IP]/archive/2022/contact — snapshot 2022-08-14 (historical) — superseded by T6-F1.

### Task 5 — Press (`5-press_notes.md`)
- T5-F1 — Tidewater Risk Engine — http://[PROVIDED_IP]/press/interviews/cto-vision-2025 — 2025-03-11 — corroborated by /technology and /developer.
- T5-F2 — targeted phishing incident, May 2024 — http://[PROVIDED_IP]/press/communiques/q2-2024 — 2024-07-15.
- T5-F3 — Meridian Cloud Systems (primary cloud partner) — http://[PROVIDED_IP]/press/conferences/marine-data-summit-2024 — 2024-10-08 — absent from /company/partners; distinct from Meridian Marine Reinsurance.

### Task 6 — Registry (`6-registry_notes.md`)
- T6-F1 — Wilhelminakade 909, 3072 AP Rotterdam — http://[PROVIDED_IP]/registry — extract 2025-05-30 — matches current /company/contact.
- T6-F2 — KvK 24418876 — http://[PROVIDED_IP]/registry — extract 2025-05-30 — matches site footer.
- T6-F3 — founded 14-03-2009; capital EUR 2.500.000 — http://[PROVIDED_IP]/registry — extract 2025-05-30.

### Task 7 — Job postings (`7-jobs_notes.md`)
- T7-F1 — Nimbus CRM 9.4 Enterprise Edition — http://[PROVIDED_IP]/careers/crm-administrator — posted 2025-03-30.
- T7-F2 — Kotlin (JVM) — http://[PROVIDED_IP]/careers/backend-developer — posted 2025-04-22 — corroborated by /technology.
- T7-F3 — Pieter Janssen, Engineering Manager — http://[PROVIDED_IP]/careers/security-engineer — posted 2025-05-06 — corroborated by humans.txt.

### Task 8 — Corporate social (`8-social_notes.md`)
- T8-F1 — Marleen Koster (— M.K. signature) — http://[PROVIDED_IP]/social — corroborated by humans.txt, T3-F2, whiteboard.
- T8-F2 — Rotterdam Maritime Week 2025 (September) — http://[PROVIDED_IP]/social — post 2025-05-29 — absent from corporate site.
- T8-F3 — hlx-app-03.helix-maritime.example — http://[PROVIDED_IP]/social and http://[PROVIDED_IP]/social/gallery (whiteboard image) — post 2025-06-03.

### Task 9 — Employee profiles (`9-employee_notes.md`)
- T9-F1 — Joris Bakker; joris.bakker@helix-maritime.example (inferred) — http://[PROVIDED_IP]/social/employees/joris-bakker — corroborated by humans.txt; homonym ruled out (joris-bakker-decoy).
- T9-F2 — dvries / Daan de Vries — http://[PROVIDED_IP]/developer — commit author on tidewater-engine; corroborated by T2-F1, humans.txt, profile; decoy helix-dev99 ruled out.
- T9-F3 — +31 10 555 0173 — http://[PROVIDED_IP]/social/employees/marleen-koster — direct line; corroborated by T8-F1, T3-F2.
- T9-F4 — harbour_runner_92 (Joris Bakker, J.B.) — http://[PROVIDED_IP]/social/employees/activity/harbour-runner-92 — runs start/finish at office; workplace confirmed by T6-F1.

### Task 10 — Technology synthesis (`10-stack_notes.md`)
- T10-F1 — Veridian CMS 5.2.1 — derived from T2-F3, humans.txt, /technology — no conflicting evidence.
- T10-F2 — Zephyrmail (current email provider) — derived from T1-F3 (historical self-hosted, ruled out as current), T1-F4 (SPF), T8-F3 (migration note) — current MX confirms.
