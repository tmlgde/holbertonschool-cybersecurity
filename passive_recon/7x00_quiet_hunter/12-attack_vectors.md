# Attack Vectors — Helix Maritime Insurance

## Vector 1: Spear-phish of the technical hiring manager via a job-application pretext
- Entry point: Pieter Janssen, Engineering Manager, who publicly reviews applications for the Security Engineer role.
- Exploitation scenario: The attacker poses as a candidate for the open Security Engineer position and sends an application email carrying a weaponised "CV.pdf". The message uses the confirmed corporate address format (firstname.lastname@helix-maritime.example) so a reply looks internal, references the exact role wording from the public posting, and is addressed directly to Pieter Janssen, who the posting states welcomes informal questions before applying. Because receiving candidate CVs is this person's normal job, an attachment raises no suspicion. A prior phishing incident at Helix shows staff are a realistic target, and the Security Engineer posting itself confirms email authentication (SPF/DKIM/DMARC) is still being matured.
- OSINT prerequisites: `7-jobs_notes.md` Finding 3; `9-employee_notes.md` Findings 1 and 2; `5-press_notes.md` Finding 2.
- Probable business impact: initial access on a technology-team endpoint, a foothold adjacent to the Tidewater risk platform and corporate systems, with potential lateral movement into a regulated insurer's environment.

## Vector 3: Mass credential phishing via a "mailbox migration" pretext
- Entry point: The general employee population (corporate mailboxes).
- Exploitation scenario: Public evidence shows Helix migrated its mailboxes from a self-hosted server to the managed provider Zephyrmail in 2024, and hardened SPF/DMARC afterwards in response to a phishing incident. The attacker imitates a "ZephyrMail Business" notification asking staff to re-confirm their mailbox after the migration — a message that matches a change employees genuinely experienced. The mail is sent through Marlinmail, the third-party campaign sender that Helix's own SPF record authorises, so it passes sender-authentication checks that would stop a naive spoof.
- OSINT prerequisites: `1-dns_notes.md` Finding 3 (historical self-hosted mail) and Finding 4 (SPF authorises Marlinmail); `5-press_notes.md` Finding 2 (phishing incident and mailbox migration); `8-social_notes.md` Finding 3 (whiteboard confirms "hlx-mail01 → ZephyrMail Business").
- Probable business impact: large-scale harvesting of mailbox credentials, enabling business-email compromise, access to claims and underwriting correspondence, and a platform for internal pivoting.

## Vector 4: Targeting of the security lead through personal OSINT
- Entry point: Joris Bakker, Infrastructure & Security Lead, in person.
- Exploitation scenario: The security lead is linkable to a GPS fitness profile whose runs all start and finish at the Helix office, early each morning before work. This yields a recurring location and time window for a privileged individual. An authorised red team could use this for an in-person pretext near the office at a predictable time, physical surveillance, or a highly personalised phishing lure built on his known interests (running, coffee). The irony — the person responsible for security being the most exposed — makes him a high-value, low-noise target.
- OSINT prerequisites: `9-employee_notes.md` Finding 1 (security lead identified, email); `9-employee_notes.md` Finding 4 (GPS routine/workplace); `6-registry_notes.md` Finding 1 (workplace confirmation).
- Probable business impact: compromise of a high-privilege account (infrastructure and security), which would give an attacker broad reach over identity, email and cloud controls across the organisation.
