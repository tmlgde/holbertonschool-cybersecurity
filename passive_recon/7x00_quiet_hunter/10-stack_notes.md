# Technology Stack Notes — Task 10

Retrieval date: 2026-11-24

## Finding 1: CMS exact name and version
- Value: Veridian CMS 5.2.1
- Source chain:
  * Task 2 Finding 3: meta tag <meta name="generator" content="Veridian CMS 5.2.1"> on the homepage source
  * Task 2: corroborated by humans.txt ("Content platform: Veridian CMS 5.2.1") and legacy-app.js (cms: 'Veridian CMS 5.2.1')
  * Task 7 / /technology page: "Content platform: Veridian CMS 5.2.1"
- Conflicting/historical evidence: none; all sources agree on the same version.
- Conclusion: three independent sources confirm the exact version, so this is the best-supported current value.

## Finding 2: Corporate email provider
- Value: Zephyrmail (ZephyrMail Business)
- Source chain:
  * Task 1 Finding: current MX records (observed 2024-08-09 → 2025-05-28) point to mx1.zephyrmail.example and mx2.zephyrmail.example
  * Task 1 Finding 4: SPF record includes include:spf.zephyrmail.example (the mailbox provider)
  * Task 3: PDF metadata producer is "Helix DocForge 3.2" (internal), not a mail-provider template; no Microsoft 365 / Google Workspace signal
  * Task 8: whiteboard confirms "Mailbox migration hlx-mail01 (198.51.100.25) → ZephyrMail Business"
- Conflicting/historical evidence: historical MX "mail.helix-maritime.example" (198.51.100.25, internal label hlx-mail01), a self-hosted exchanger retired during the 2024 mailbox migration. This is NOT the current provider.
- Conclusion: the company moved from a self-hosted mail server to the managed provider Zephyrmail in 2024; current MX + SPF + the migration note agree.
